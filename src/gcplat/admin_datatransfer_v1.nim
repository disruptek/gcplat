
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatatransferApplicationsList_597692 = ref object of OpenApiRestCall_597424
proc url_DatatransferApplicationsList_597694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DatatransferApplicationsList_597693(path: JsonNode; query: JsonNode;
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
  var valid_597806 = query.getOrDefault("fields")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "fields", valid_597806
  var valid_597807 = query.getOrDefault("pageToken")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "pageToken", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("customerId")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "customerId", valid_597823
  var valid_597824 = query.getOrDefault("oauth_token")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "oauth_token", valid_597824
  var valid_597825 = query.getOrDefault("userIp")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "userIp", valid_597825
  var valid_597826 = query.getOrDefault("maxResults")
  valid_597826 = validateParameter(valid_597826, JInt, required = false, default = nil)
  if valid_597826 != nil:
    section.add "maxResults", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("prettyPrint")
  valid_597828 = validateParameter(valid_597828, JBool, required = false,
                                 default = newJBool(true))
  if valid_597828 != nil:
    section.add "prettyPrint", valid_597828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597851: Call_DatatransferApplicationsList_597692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the applications available for data transfer for a customer.
  ## 
  let valid = call_597851.validator(path, query, header, formData, body)
  let scheme = call_597851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597851.url(scheme.get, call_597851.host, call_597851.base,
                         call_597851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597851, url, valid)

proc call*(call_597922: Call_DatatransferApplicationsList_597692;
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
  var query_597923 = newJObject()
  add(query_597923, "fields", newJString(fields))
  add(query_597923, "pageToken", newJString(pageToken))
  add(query_597923, "quotaUser", newJString(quotaUser))
  add(query_597923, "alt", newJString(alt))
  add(query_597923, "customerId", newJString(customerId))
  add(query_597923, "oauth_token", newJString(oauthToken))
  add(query_597923, "userIp", newJString(userIp))
  add(query_597923, "maxResults", newJInt(maxResults))
  add(query_597923, "key", newJString(key))
  add(query_597923, "prettyPrint", newJBool(prettyPrint))
  result = call_597922.call(nil, query_597923, nil, nil, nil)

var datatransferApplicationsList* = Call_DatatransferApplicationsList_597692(
    name: "datatransferApplicationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications",
    validator: validate_DatatransferApplicationsList_597693,
    base: "/admin/datatransfer/v1", url: url_DatatransferApplicationsList_597694,
    schemes: {Scheme.Https})
type
  Call_DatatransferApplicationsGet_597963 = ref object of OpenApiRestCall_597424
proc url_DatatransferApplicationsGet_597965(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatatransferApplicationsGet_597964(path: JsonNode; query: JsonNode;
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
  var valid_597980 = path.getOrDefault("applicationId")
  valid_597980 = validateParameter(valid_597980, JString, required = true,
                                 default = nil)
  if valid_597980 != nil:
    section.add "applicationId", valid_597980
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
  var valid_597981 = query.getOrDefault("fields")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "fields", valid_597981
  var valid_597982 = query.getOrDefault("quotaUser")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "quotaUser", valid_597982
  var valid_597983 = query.getOrDefault("alt")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = newJString("json"))
  if valid_597983 != nil:
    section.add "alt", valid_597983
  var valid_597984 = query.getOrDefault("oauth_token")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "oauth_token", valid_597984
  var valid_597985 = query.getOrDefault("userIp")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "userIp", valid_597985
  var valid_597986 = query.getOrDefault("key")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "key", valid_597986
  var valid_597987 = query.getOrDefault("prettyPrint")
  valid_597987 = validateParameter(valid_597987, JBool, required = false,
                                 default = newJBool(true))
  if valid_597987 != nil:
    section.add "prettyPrint", valid_597987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597988: Call_DatatransferApplicationsGet_597963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an application for the given application ID.
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_DatatransferApplicationsGet_597963;
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
  var path_597990 = newJObject()
  var query_597991 = newJObject()
  add(query_597991, "fields", newJString(fields))
  add(query_597991, "quotaUser", newJString(quotaUser))
  add(query_597991, "alt", newJString(alt))
  add(query_597991, "oauth_token", newJString(oauthToken))
  add(query_597991, "userIp", newJString(userIp))
  add(path_597990, "applicationId", newJString(applicationId))
  add(query_597991, "key", newJString(key))
  add(query_597991, "prettyPrint", newJBool(prettyPrint))
  result = call_597989.call(path_597990, query_597991, nil, nil, nil)

var datatransferApplicationsGet* = Call_DatatransferApplicationsGet_597963(
    name: "datatransferApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_DatatransferApplicationsGet_597964,
    base: "/admin/datatransfer/v1", url: url_DatatransferApplicationsGet_597965,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersInsert_598011 = ref object of OpenApiRestCall_597424
proc url_DatatransferTransfersInsert_598013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DatatransferTransfersInsert_598012(path: JsonNode; query: JsonNode;
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
  var valid_598014 = query.getOrDefault("fields")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "fields", valid_598014
  var valid_598015 = query.getOrDefault("quotaUser")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "quotaUser", valid_598015
  var valid_598016 = query.getOrDefault("alt")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = newJString("json"))
  if valid_598016 != nil:
    section.add "alt", valid_598016
  var valid_598017 = query.getOrDefault("oauth_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "oauth_token", valid_598017
  var valid_598018 = query.getOrDefault("userIp")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "userIp", valid_598018
  var valid_598019 = query.getOrDefault("key")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "key", valid_598019
  var valid_598020 = query.getOrDefault("prettyPrint")
  valid_598020 = validateParameter(valid_598020, JBool, required = false,
                                 default = newJBool(true))
  if valid_598020 != nil:
    section.add "prettyPrint", valid_598020
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

proc call*(call_598022: Call_DatatransferTransfersInsert_598011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a data transfer request.
  ## 
  let valid = call_598022.validator(path, query, header, formData, body)
  let scheme = call_598022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598022.url(scheme.get, call_598022.host, call_598022.base,
                         call_598022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598022, url, valid)

proc call*(call_598023: Call_DatatransferTransfersInsert_598011;
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
  var query_598024 = newJObject()
  var body_598025 = newJObject()
  add(query_598024, "fields", newJString(fields))
  add(query_598024, "quotaUser", newJString(quotaUser))
  add(query_598024, "alt", newJString(alt))
  add(query_598024, "oauth_token", newJString(oauthToken))
  add(query_598024, "userIp", newJString(userIp))
  add(query_598024, "key", newJString(key))
  if body != nil:
    body_598025 = body
  add(query_598024, "prettyPrint", newJBool(prettyPrint))
  result = call_598023.call(nil, query_598024, nil, nil, body_598025)

var datatransferTransfersInsert* = Call_DatatransferTransfersInsert_598011(
    name: "datatransferTransfersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/transfers",
    validator: validate_DatatransferTransfersInsert_598012,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersInsert_598013,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersList_597992 = ref object of OpenApiRestCall_597424
proc url_DatatransferTransfersList_597994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DatatransferTransfersList_597993(path: JsonNode; query: JsonNode;
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
  var valid_597995 = query.getOrDefault("newOwnerUserId")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "newOwnerUserId", valid_597995
  var valid_597996 = query.getOrDefault("fields")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "fields", valid_597996
  var valid_597997 = query.getOrDefault("pageToken")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "pageToken", valid_597997
  var valid_597998 = query.getOrDefault("quotaUser")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "quotaUser", valid_597998
  var valid_597999 = query.getOrDefault("alt")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = newJString("json"))
  if valid_597999 != nil:
    section.add "alt", valid_597999
  var valid_598000 = query.getOrDefault("customerId")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "customerId", valid_598000
  var valid_598001 = query.getOrDefault("oauth_token")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "oauth_token", valid_598001
  var valid_598002 = query.getOrDefault("userIp")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "userIp", valid_598002
  var valid_598003 = query.getOrDefault("oldOwnerUserId")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "oldOwnerUserId", valid_598003
  var valid_598004 = query.getOrDefault("maxResults")
  valid_598004 = validateParameter(valid_598004, JInt, required = false, default = nil)
  if valid_598004 != nil:
    section.add "maxResults", valid_598004
  var valid_598005 = query.getOrDefault("key")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "key", valid_598005
  var valid_598006 = query.getOrDefault("status")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "status", valid_598006
  var valid_598007 = query.getOrDefault("prettyPrint")
  valid_598007 = validateParameter(valid_598007, JBool, required = false,
                                 default = newJBool(true))
  if valid_598007 != nil:
    section.add "prettyPrint", valid_598007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598008: Call_DatatransferTransfersList_597992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transfers for a customer by source user, destination user, or status.
  ## 
  let valid = call_598008.validator(path, query, header, formData, body)
  let scheme = call_598008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598008.url(scheme.get, call_598008.host, call_598008.base,
                         call_598008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598008, url, valid)

proc call*(call_598009: Call_DatatransferTransfersList_597992;
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
  var query_598010 = newJObject()
  add(query_598010, "newOwnerUserId", newJString(newOwnerUserId))
  add(query_598010, "fields", newJString(fields))
  add(query_598010, "pageToken", newJString(pageToken))
  add(query_598010, "quotaUser", newJString(quotaUser))
  add(query_598010, "alt", newJString(alt))
  add(query_598010, "customerId", newJString(customerId))
  add(query_598010, "oauth_token", newJString(oauthToken))
  add(query_598010, "userIp", newJString(userIp))
  add(query_598010, "oldOwnerUserId", newJString(oldOwnerUserId))
  add(query_598010, "maxResults", newJInt(maxResults))
  add(query_598010, "key", newJString(key))
  add(query_598010, "status", newJString(status))
  add(query_598010, "prettyPrint", newJBool(prettyPrint))
  result = call_598009.call(nil, query_598010, nil, nil, nil)

var datatransferTransfersList* = Call_DatatransferTransfersList_597992(
    name: "datatransferTransfersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/transfers",
    validator: validate_DatatransferTransfersList_597993,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersList_597994,
    schemes: {Scheme.Https})
type
  Call_DatatransferTransfersGet_598026 = ref object of OpenApiRestCall_597424
proc url_DatatransferTransfersGet_598028(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "dataTransferId" in path, "`dataTransferId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "dataTransferId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatatransferTransfersGet_598027(path: JsonNode; query: JsonNode;
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
  var valid_598029 = path.getOrDefault("dataTransferId")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "dataTransferId", valid_598029
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
  var valid_598030 = query.getOrDefault("fields")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "fields", valid_598030
  var valid_598031 = query.getOrDefault("quotaUser")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "quotaUser", valid_598031
  var valid_598032 = query.getOrDefault("alt")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = newJString("json"))
  if valid_598032 != nil:
    section.add "alt", valid_598032
  var valid_598033 = query.getOrDefault("oauth_token")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "oauth_token", valid_598033
  var valid_598034 = query.getOrDefault("userIp")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "userIp", valid_598034
  var valid_598035 = query.getOrDefault("key")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "key", valid_598035
  var valid_598036 = query.getOrDefault("prettyPrint")
  valid_598036 = validateParameter(valid_598036, JBool, required = false,
                                 default = newJBool(true))
  if valid_598036 != nil:
    section.add "prettyPrint", valid_598036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598037: Call_DatatransferTransfersGet_598026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a data transfer request by its resource ID.
  ## 
  let valid = call_598037.validator(path, query, header, formData, body)
  let scheme = call_598037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598037.url(scheme.get, call_598037.host, call_598037.base,
                         call_598037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598037, url, valid)

proc call*(call_598038: Call_DatatransferTransfersGet_598026;
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
  var path_598039 = newJObject()
  var query_598040 = newJObject()
  add(query_598040, "fields", newJString(fields))
  add(query_598040, "quotaUser", newJString(quotaUser))
  add(query_598040, "alt", newJString(alt))
  add(query_598040, "oauth_token", newJString(oauthToken))
  add(query_598040, "userIp", newJString(userIp))
  add(query_598040, "key", newJString(key))
  add(path_598039, "dataTransferId", newJString(dataTransferId))
  add(query_598040, "prettyPrint", newJBool(prettyPrint))
  result = call_598038.call(path_598039, query_598040, nil, nil, nil)

var datatransferTransfersGet* = Call_DatatransferTransfersGet_598026(
    name: "datatransferTransfersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/transfers/{dataTransferId}",
    validator: validate_DatatransferTransfersGet_598027,
    base: "/admin/datatransfer/v1", url: url_DatatransferTransfersGet_598028,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
