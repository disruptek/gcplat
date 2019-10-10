
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "admin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatatransferApplicationsList_588725 = ref object of OpenApiRestCall_588457
proc url_DatatransferApplicationsList_588727(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DatatransferApplicationsList_588726(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applications available for data transfer for a customer.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Immutable ID of the Google Apps account.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Default is 100.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("pageToken")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "pageToken", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("customerId")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "customerId", valid_588856
  var valid_588857 = query.getOrDefault("oauth_token")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "oauth_token", valid_588857
  var valid_588858 = query.getOrDefault("userIp")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "userIp", valid_588858
  var valid_588859 = query.getOrDefault("maxResults")
  valid_588859 = validateParameter(valid_588859, JInt, required = false, default = nil)
  if valid_588859 != nil:
    section.add "maxResults", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("prettyPrint")
  valid_588861 = validateParameter(valid_588861, JBool, required = false,
                                 default = newJBool(true))
  if valid_588861 != nil:
    section.add "prettyPrint", valid_588861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588884: Call_DatatransferApplicationsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the applications available for data transfer for a customer.
  ## 
  let valid = call_588884.validator(path, query, header, formData, body)
  let scheme = call_588884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588884.url(scheme.get, call_588884.host, call_588884.base,
                         call_588884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588884, url, valid)

proc call*(call_588955: Call_DatatransferApplicationsList_588725;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## datatransferApplicationsList
  ## Lists the applications available for data transfer for a customer.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Immutable ID of the Google Apps account.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return. Default is 100.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588956 = newJObject()
  add(query_588956, "fields", newJString(fields))
  add(query_588956, "pageToken", newJString(pageToken))
  add(query_588956, "quotaUser", newJString(quotaUser))
  add(query_588956, "alt", newJString(alt))
  add(query_588956, "customerId", newJString(customerId))
  add(query_588956, "oauth_token", newJString(oauthToken))
  add(query_588956, "userIp", newJString(userIp))
  add(query_588956, "maxResults", newJInt(maxResults))
  add(query_588956, "key", newJString(key))
  add(query_588956, "prettyPrint", newJBool(prettyPrint))
  result = call_588955.call(nil, query_588956, nil, nil, nil)

var datatransferApplicationsList* = Call_DatatransferApplicationsList_588725(
    name: "datatransferApplicationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications",
    validator: validate_DatatransferApplicationsList_588726,
    base: "/admin/datatransfer/v1", url: url_DatatransferApplicationsList_588727,
    schemes: {Scheme.Https})
type
  Call_DatatransferApplicationsGet_588996 = ref object of OpenApiRestCall_588457
proc url_DatatransferApplicationsGet_588998(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DatatransferApplicationsGet_588997(path: JsonNode; query: JsonNode;
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
  var valid_589013 = path.getOrDefault("applicationId")
  valid_589013 = validateParameter(valid_589013, JString, required = true,
                                 default = nil)
  if valid_589013 != nil:
    section.add "applicationId", valid_589013
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("userIp")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "userIp", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("prettyPrint")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "prettyPrint", valid_589020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589021: Call_DatatransferApplicationsGet_588996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an application for the given application ID.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_DatatransferApplicationsGet_588996;
          applicationId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## datatransferApplicationsGet
  ## Retrieves information about an application for the given application ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   applicationId: string (required)
  ##                : ID of the application resource to be retrieved.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589023 = newJObject()
  var query_589024 = newJObject()
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(query_589024, "userIp", newJString(userIp))
  add(path_589023, "applicationId", newJString(applicationId))
  add(query_589024, "key", newJString(key))
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(path_589023, query_589024, nil, nil, nil)

var datatransferApplicationsGet* = Call_DatatransferApplicationsGet_588996(
    name: "datatransferApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_DatatransferApplicationsGet_588997,
    base: "/admin/datatransfer/v1", url: url_DatatransferApplicationsGet_588998,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersInsert_589044 = ref object of OpenApiRestCall_588457
proc url_DatatransferTransfersInsert_589046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DatatransferTransfersInsert_589045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a data transfer request.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("userIp")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "userIp", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(true))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
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

proc call*(call_589055: Call_DatatransferTransfersInsert_589044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a data transfer request.
  ## 
  let valid = call_589055.validator(path, query, header, formData, body)
  let scheme = call_589055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589055.url(scheme.get, call_589055.host, call_589055.base,
                         call_589055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589055, url, valid)

proc call*(call_589056: Call_DatatransferTransfersInsert_589044;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## datatransferTransfersInsert
  ## Inserts a data transfer request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589057 = newJObject()
  var body_589058 = newJObject()
  add(query_589057, "fields", newJString(fields))
  add(query_589057, "quotaUser", newJString(quotaUser))
  add(query_589057, "alt", newJString(alt))
  add(query_589057, "oauth_token", newJString(oauthToken))
  add(query_589057, "userIp", newJString(userIp))
  add(query_589057, "key", newJString(key))
  if body != nil:
    body_589058 = body
  add(query_589057, "prettyPrint", newJBool(prettyPrint))
  result = call_589056.call(nil, query_589057, nil, nil, body_589058)

var datatransferTransfersInsert* = Call_DatatransferTransfersInsert_589044(
    name: "datatransferTransfersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/transfers",
    validator: validate_DatatransferTransfersInsert_589045,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersInsert_589046,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersList_589025 = ref object of OpenApiRestCall_588457
proc url_DatatransferTransfersList_589027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DatatransferTransfersList_589026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transfers for a customer by source user, destination user, or status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   newOwnerUserId: JString
  ##                 : Destination user's profile ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Immutable ID of the Google Apps account.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   oldOwnerUserId: JString
  ##                 : Source user's profile ID.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Default is 100.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   status: JString
  ##         : Status of the transfer.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589028 = query.getOrDefault("newOwnerUserId")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "newOwnerUserId", valid_589028
  var valid_589029 = query.getOrDefault("fields")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "fields", valid_589029
  var valid_589030 = query.getOrDefault("pageToken")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "pageToken", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("customerId")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "customerId", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("userIp")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "userIp", valid_589035
  var valid_589036 = query.getOrDefault("oldOwnerUserId")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "oldOwnerUserId", valid_589036
  var valid_589037 = query.getOrDefault("maxResults")
  valid_589037 = validateParameter(valid_589037, JInt, required = false, default = nil)
  if valid_589037 != nil:
    section.add "maxResults", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("status")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "status", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589041: Call_DatatransferTransfersList_589025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transfers for a customer by source user, destination user, or status.
  ## 
  let valid = call_589041.validator(path, query, header, formData, body)
  let scheme = call_589041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589041.url(scheme.get, call_589041.host, call_589041.base,
                         call_589041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589041, url, valid)

proc call*(call_589042: Call_DatatransferTransfersList_589025;
          newOwnerUserId: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; customerId: string = "";
          oauthToken: string = ""; userIp: string = ""; oldOwnerUserId: string = "";
          maxResults: int = 0; key: string = ""; status: string = "";
          prettyPrint: bool = true): Recallable =
  ## datatransferTransfersList
  ## Lists the transfers for a customer by source user, destination user, or status.
  ##   newOwnerUserId: string
  ##                 : Destination user's profile ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Immutable ID of the Google Apps account.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   oldOwnerUserId: string
  ##                 : Source user's profile ID.
  ##   maxResults: int
  ##             : Maximum number of results to return. Default is 100.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   status: string
  ##         : Status of the transfer.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589043 = newJObject()
  add(query_589043, "newOwnerUserId", newJString(newOwnerUserId))
  add(query_589043, "fields", newJString(fields))
  add(query_589043, "pageToken", newJString(pageToken))
  add(query_589043, "quotaUser", newJString(quotaUser))
  add(query_589043, "alt", newJString(alt))
  add(query_589043, "customerId", newJString(customerId))
  add(query_589043, "oauth_token", newJString(oauthToken))
  add(query_589043, "userIp", newJString(userIp))
  add(query_589043, "oldOwnerUserId", newJString(oldOwnerUserId))
  add(query_589043, "maxResults", newJInt(maxResults))
  add(query_589043, "key", newJString(key))
  add(query_589043, "status", newJString(status))
  add(query_589043, "prettyPrint", newJBool(prettyPrint))
  result = call_589042.call(nil, query_589043, nil, nil, nil)

var datatransferTransfersList* = Call_DatatransferTransfersList_589025(
    name: "datatransferTransfersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/transfers",
    validator: validate_DatatransferTransfersList_589026,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersList_589027,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersGet_589059 = ref object of OpenApiRestCall_588457
proc url_DatatransferTransfersGet_589061(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DatatransferTransfersGet_589060(path: JsonNode; query: JsonNode;
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
  var valid_589062 = path.getOrDefault("dataTransferId")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "dataTransferId", valid_589062
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589063 = query.getOrDefault("fields")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "fields", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("userIp")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "userIp", valid_589067
  var valid_589068 = query.getOrDefault("key")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "key", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589070: Call_DatatransferTransfersGet_589059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a data transfer request by its resource ID.
  ## 
  let valid = call_589070.validator(path, query, header, formData, body)
  let scheme = call_589070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589070.url(scheme.get, call_589070.host, call_589070.base,
                         call_589070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589070, url, valid)

proc call*(call_589071: Call_DatatransferTransfersGet_589059;
          dataTransferId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## datatransferTransfersGet
  ## Retrieves a data transfer request by its resource ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   dataTransferId: string (required)
  ##                 : ID of the resource to be retrieved. This is returned in the response from the insert method.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589072 = newJObject()
  var query_589073 = newJObject()
  add(query_589073, "fields", newJString(fields))
  add(query_589073, "quotaUser", newJString(quotaUser))
  add(query_589073, "alt", newJString(alt))
  add(query_589073, "oauth_token", newJString(oauthToken))
  add(query_589073, "userIp", newJString(userIp))
  add(query_589073, "key", newJString(key))
  add(path_589072, "dataTransferId", newJString(dataTransferId))
  add(query_589073, "prettyPrint", newJBool(prettyPrint))
  result = call_589071.call(path_589072, query_589073, nil, nil, nil)

var datatransferTransfersGet* = Call_DatatransferTransfersGet_589059(
    name: "datatransferTransfersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/transfers/{dataTransferId}",
    validator: validate_DatatransferTransfersGet_589060,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersGet_589061,
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
