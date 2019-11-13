
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Admin Data Transfer
## version: datatransfer_v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Transfers user data from one user to another.
## 
## https://developers.google.com/admin-sdk/data-transfer/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "admin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatatransferApplicationsList_579650 = ref object of OpenApiRestCall_579380
proc url_DatatransferApplicationsList_579652(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DatatransferApplicationsList_579651(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applications available for data transfer for a customer.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to specify next page in the list.
  ##   customerId: JString
  ##             : Immutable ID of the G Suite account.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Default is 100.
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("alt")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("json"))
  if valid_579780 != nil:
    section.add "alt", valid_579780
  var valid_579781 = query.getOrDefault("userIp")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "userIp", valid_579781
  var valid_579782 = query.getOrDefault("quotaUser")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "quotaUser", valid_579782
  var valid_579783 = query.getOrDefault("pageToken")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "pageToken", valid_579783
  var valid_579784 = query.getOrDefault("customerId")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "customerId", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("maxResults")
  valid_579786 = validateParameter(valid_579786, JInt, required = false, default = nil)
  if valid_579786 != nil:
    section.add "maxResults", valid_579786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579809: Call_DatatransferApplicationsList_579650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the applications available for data transfer for a customer.
  ## 
  let valid = call_579809.validator(path, query, header, formData, body)
  let scheme = call_579809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579809.url(scheme.get, call_579809.host, call_579809.base,
                         call_579809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579809, url, valid)

proc call*(call_579880: Call_DatatransferApplicationsList_579650; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          customerId: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## datatransferApplicationsList
  ## Lists the applications available for data transfer for a customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify next page in the list.
  ##   customerId: string
  ##             : Immutable ID of the G Suite account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return. Default is 100.
  var query_579881 = newJObject()
  add(query_579881, "key", newJString(key))
  add(query_579881, "prettyPrint", newJBool(prettyPrint))
  add(query_579881, "oauth_token", newJString(oauthToken))
  add(query_579881, "alt", newJString(alt))
  add(query_579881, "userIp", newJString(userIp))
  add(query_579881, "quotaUser", newJString(quotaUser))
  add(query_579881, "pageToken", newJString(pageToken))
  add(query_579881, "customerId", newJString(customerId))
  add(query_579881, "fields", newJString(fields))
  add(query_579881, "maxResults", newJInt(maxResults))
  result = call_579880.call(nil, query_579881, nil, nil, nil)

var datatransferApplicationsList* = Call_DatatransferApplicationsList_579650(
    name: "datatransferApplicationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications",
    validator: validate_DatatransferApplicationsList_579651,
    base: "/admin/datatransfer/v1", url: url_DatatransferApplicationsList_579652,
    schemes: {Scheme.Https})
type
  Call_DatatransferApplicationsGet_579921 = ref object of OpenApiRestCall_579380
proc url_DatatransferApplicationsGet_579923(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DatatransferApplicationsGet_579922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about an application for the given application ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : ID of the application resource to be retrieved.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_579938 = path.getOrDefault("applicationId")
  valid_579938 = validateParameter(valid_579938, JString, required = true,
                                 default = nil)
  if valid_579938 != nil:
    section.add "applicationId", valid_579938
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579939 = query.getOrDefault("key")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "key", valid_579939
  var valid_579940 = query.getOrDefault("prettyPrint")
  valid_579940 = validateParameter(valid_579940, JBool, required = false,
                                 default = newJBool(true))
  if valid_579940 != nil:
    section.add "prettyPrint", valid_579940
  var valid_579941 = query.getOrDefault("oauth_token")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "oauth_token", valid_579941
  var valid_579942 = query.getOrDefault("alt")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = newJString("json"))
  if valid_579942 != nil:
    section.add "alt", valid_579942
  var valid_579943 = query.getOrDefault("userIp")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "userIp", valid_579943
  var valid_579944 = query.getOrDefault("quotaUser")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "quotaUser", valid_579944
  var valid_579945 = query.getOrDefault("fields")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "fields", valid_579945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579946: Call_DatatransferApplicationsGet_579921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an application for the given application ID.
  ## 
  let valid = call_579946.validator(path, query, header, formData, body)
  let scheme = call_579946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579946.url(scheme.get, call_579946.host, call_579946.base,
                         call_579946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579946, url, valid)

proc call*(call_579947: Call_DatatransferApplicationsGet_579921;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## datatransferApplicationsGet
  ## Retrieves information about an application for the given application ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   applicationId: string (required)
  ##                : ID of the application resource to be retrieved.
  var path_579948 = newJObject()
  var query_579949 = newJObject()
  add(query_579949, "key", newJString(key))
  add(query_579949, "prettyPrint", newJBool(prettyPrint))
  add(query_579949, "oauth_token", newJString(oauthToken))
  add(query_579949, "alt", newJString(alt))
  add(query_579949, "userIp", newJString(userIp))
  add(query_579949, "quotaUser", newJString(quotaUser))
  add(query_579949, "fields", newJString(fields))
  add(path_579948, "applicationId", newJString(applicationId))
  result = call_579947.call(path_579948, query_579949, nil, nil, nil)

var datatransferApplicationsGet* = Call_DatatransferApplicationsGet_579921(
    name: "datatransferApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_DatatransferApplicationsGet_579922,
    base: "/admin/datatransfer/v1", url: url_DatatransferApplicationsGet_579923,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersInsert_579969 = ref object of OpenApiRestCall_579380
proc url_DatatransferTransfersInsert_579971(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DatatransferTransfersInsert_579970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a data transfer request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579972 = query.getOrDefault("key")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "key", valid_579972
  var valid_579973 = query.getOrDefault("prettyPrint")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(true))
  if valid_579973 != nil:
    section.add "prettyPrint", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
  var valid_579976 = query.getOrDefault("userIp")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "userIp", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("fields")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "fields", valid_579978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_DatatransferTransfersInsert_579969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a data transfer request.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_DatatransferTransfersInsert_579969; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## datatransferTransfersInsert
  ## Inserts a data transfer request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579982 = newJObject()
  var body_579983 = newJObject()
  add(query_579982, "key", newJString(key))
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "userIp", newJString(userIp))
  add(query_579982, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579983 = body
  add(query_579982, "fields", newJString(fields))
  result = call_579981.call(nil, query_579982, nil, nil, body_579983)

var datatransferTransfersInsert* = Call_DatatransferTransfersInsert_579969(
    name: "datatransferTransfersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/transfers",
    validator: validate_DatatransferTransfersInsert_579970,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersInsert_579971,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersList_579950 = ref object of OpenApiRestCall_579380
proc url_DatatransferTransfersList_579952(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DatatransferTransfersList_579951(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transfers for a customer by source user, destination user, or status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   oldOwnerUserId: JString
  ##                 : Source user's profile ID.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   newOwnerUserId: JString
  ##                 : Destination user's profile ID.
  ##   customerId: JString
  ##             : Immutable ID of the G Suite account.
  ##   status: JString
  ##         : Status of the transfer.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Default is 100.
  section = newJObject()
  var valid_579953 = query.getOrDefault("key")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "key", valid_579953
  var valid_579954 = query.getOrDefault("prettyPrint")
  valid_579954 = validateParameter(valid_579954, JBool, required = false,
                                 default = newJBool(true))
  if valid_579954 != nil:
    section.add "prettyPrint", valid_579954
  var valid_579955 = query.getOrDefault("oauth_token")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "oauth_token", valid_579955
  var valid_579956 = query.getOrDefault("alt")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = newJString("json"))
  if valid_579956 != nil:
    section.add "alt", valid_579956
  var valid_579957 = query.getOrDefault("userIp")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "userIp", valid_579957
  var valid_579958 = query.getOrDefault("quotaUser")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "quotaUser", valid_579958
  var valid_579959 = query.getOrDefault("oldOwnerUserId")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oldOwnerUserId", valid_579959
  var valid_579960 = query.getOrDefault("pageToken")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "pageToken", valid_579960
  var valid_579961 = query.getOrDefault("newOwnerUserId")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "newOwnerUserId", valid_579961
  var valid_579962 = query.getOrDefault("customerId")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "customerId", valid_579962
  var valid_579963 = query.getOrDefault("status")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "status", valid_579963
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("maxResults")
  valid_579965 = validateParameter(valid_579965, JInt, required = false, default = nil)
  if valid_579965 != nil:
    section.add "maxResults", valid_579965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579966: Call_DatatransferTransfersList_579950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transfers for a customer by source user, destination user, or status.
  ## 
  let valid = call_579966.validator(path, query, header, formData, body)
  let scheme = call_579966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579966.url(scheme.get, call_579966.host, call_579966.base,
                         call_579966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579966, url, valid)

proc call*(call_579967: Call_DatatransferTransfersList_579950; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; oldOwnerUserId: string = "";
          pageToken: string = ""; newOwnerUserId: string = ""; customerId: string = "";
          status: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## datatransferTransfersList
  ## Lists the transfers for a customer by source user, destination user, or status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   oldOwnerUserId: string
  ##                 : Source user's profile ID.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   newOwnerUserId: string
  ##                 : Destination user's profile ID.
  ##   customerId: string
  ##             : Immutable ID of the G Suite account.
  ##   status: string
  ##         : Status of the transfer.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return. Default is 100.
  var query_579968 = newJObject()
  add(query_579968, "key", newJString(key))
  add(query_579968, "prettyPrint", newJBool(prettyPrint))
  add(query_579968, "oauth_token", newJString(oauthToken))
  add(query_579968, "alt", newJString(alt))
  add(query_579968, "userIp", newJString(userIp))
  add(query_579968, "quotaUser", newJString(quotaUser))
  add(query_579968, "oldOwnerUserId", newJString(oldOwnerUserId))
  add(query_579968, "pageToken", newJString(pageToken))
  add(query_579968, "newOwnerUserId", newJString(newOwnerUserId))
  add(query_579968, "customerId", newJString(customerId))
  add(query_579968, "status", newJString(status))
  add(query_579968, "fields", newJString(fields))
  add(query_579968, "maxResults", newJInt(maxResults))
  result = call_579967.call(nil, query_579968, nil, nil, nil)

var datatransferTransfersList* = Call_DatatransferTransfersList_579950(
    name: "datatransferTransfersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/transfers",
    validator: validate_DatatransferTransfersList_579951,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersList_579952,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersGet_579984 = ref object of OpenApiRestCall_579380
proc url_DatatransferTransfersGet_579986(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "dataTransferId" in path, "`dataTransferId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "dataTransferId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DatatransferTransfersGet_579985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a data transfer request by its resource ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataTransferId: JString (required)
  ##                 : ID of the resource to be retrieved. This is returned in the response from the insert method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataTransferId` field"
  var valid_579987 = path.getOrDefault("dataTransferId")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "dataTransferId", valid_579987
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("userIp")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "userIp", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579995: Call_DatatransferTransfersGet_579984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a data transfer request by its resource ID.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_DatatransferTransfersGet_579984;
          dataTransferId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## datatransferTransfersGet
  ## Retrieves a data transfer request by its resource ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dataTransferId: string (required)
  ##                 : ID of the resource to be retrieved. This is returned in the response from the insert method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  add(query_579998, "key", newJString(key))
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "userIp", newJString(userIp))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(path_579997, "dataTransferId", newJString(dataTransferId))
  add(query_579998, "fields", newJString(fields))
  result = call_579996.call(path_579997, query_579998, nil, nil, nil)

var datatransferTransfersGet* = Call_DatatransferTransfersGet_579984(
    name: "datatransferTransfersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/transfers/{dataTransferId}",
    validator: validate_DatatransferTransfersGet_579985,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersGet_579986,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
