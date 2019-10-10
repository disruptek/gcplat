
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Ad Exchange Buyer
## version: v1.3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses your bidding-account information, submits creatives for validation, finds available direct deals, and retrieves performance reports.
## 
## https://developers.google.com/ad-exchange/buyer-rest
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
  gcpServiceName = "adexchangebuyer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangebuyerAccountsList_588726 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerAccountsList_588728(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerAccountsList_588727(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authenticated user's list of accounts.
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
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
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
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("userIp")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "userIp", valid_588857
  var valid_588858 = query.getOrDefault("key")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "key", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588882: Call_AdexchangebuyerAccountsList_588726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of accounts.
  ## 
  let valid = call_588882.validator(path, query, header, formData, body)
  let scheme = call_588882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588882.url(scheme.get, call_588882.host, call_588882.base,
                         call_588882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588882, url, valid)

proc call*(call_588953: Call_AdexchangebuyerAccountsList_588726;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerAccountsList
  ## Retrieves the authenticated user's list of accounts.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588954 = newJObject()
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "userIp", newJString(userIp))
  add(query_588954, "key", newJString(key))
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  result = call_588953.call(nil, query_588954, nil, nil, nil)

var adexchangebuyerAccountsList* = Call_AdexchangebuyerAccountsList_588726(
    name: "adexchangebuyerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangebuyerAccountsList_588727,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsList_588728,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsUpdate_589023 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerAccountsUpdate_589025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerAccountsUpdate_589024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JInt (required)
  ##     : The account id
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589026 = path.getOrDefault("id")
  valid_589026 = validateParameter(valid_589026, JInt, required = true, default = nil)
  if valid_589026 != nil:
    section.add "id", valid_589026
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
  var valid_589027 = query.getOrDefault("fields")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "fields", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("userIp")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "userIp", valid_589031
  var valid_589032 = query.getOrDefault("key")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "key", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
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

proc call*(call_589035: Call_AdexchangebuyerAccountsUpdate_589023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_AdexchangebuyerAccountsUpdate_589023; id: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerAccountsUpdate
  ## Updates an existing account.
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
  ##   id: int (required)
  ##     : The account id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  var body_589039 = newJObject()
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "userIp", newJString(userIp))
  add(path_589037, "id", newJInt(id))
  add(query_589038, "key", newJString(key))
  if body != nil:
    body_589039 = body
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(path_589037, query_589038, nil, nil, body_589039)

var adexchangebuyerAccountsUpdate* = Call_AdexchangebuyerAccountsUpdate_589023(
    name: "adexchangebuyerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsUpdate_589024,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsUpdate_589025,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsGet_588994 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerAccountsGet_588996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerAccountsGet_588995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one account by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JInt (required)
  ##     : The account id
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589011 = path.getOrDefault("id")
  valid_589011 = validateParameter(valid_589011, JInt, required = true, default = nil)
  if valid_589011 != nil:
    section.add "id", valid_589011
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
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("userIp")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "userIp", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589019: Call_AdexchangebuyerAccountsGet_588994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one account by ID.
  ## 
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_AdexchangebuyerAccountsGet_588994; id: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerAccountsGet
  ## Gets one account by ID.
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
  ##   id: int (required)
  ##     : The account id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589021 = newJObject()
  var query_589022 = newJObject()
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "userIp", newJString(userIp))
  add(path_589021, "id", newJInt(id))
  add(query_589022, "key", newJString(key))
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589020.call(path_589021, query_589022, nil, nil, nil)

var adexchangebuyerAccountsGet* = Call_AdexchangebuyerAccountsGet_588994(
    name: "adexchangebuyerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsGet_588995,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsGet_588996,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsPatch_589040 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerAccountsPatch_589042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerAccountsPatch_589041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JInt (required)
  ##     : The account id
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589043 = path.getOrDefault("id")
  valid_589043 = validateParameter(valid_589043, JInt, required = true, default = nil)
  if valid_589043 != nil:
    section.add "id", valid_589043
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
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("quotaUser")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "quotaUser", valid_589045
  var valid_589046 = query.getOrDefault("alt")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("json"))
  if valid_589046 != nil:
    section.add "alt", valid_589046
  var valid_589047 = query.getOrDefault("oauth_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "oauth_token", valid_589047
  var valid_589048 = query.getOrDefault("userIp")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "userIp", valid_589048
  var valid_589049 = query.getOrDefault("key")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "key", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
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

proc call*(call_589052: Call_AdexchangebuyerAccountsPatch_589040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_AdexchangebuyerAccountsPatch_589040; id: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerAccountsPatch
  ## Updates an existing account. This method supports patch semantics.
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
  ##   id: int (required)
  ##     : The account id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  var body_589056 = newJObject()
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "userIp", newJString(userIp))
  add(path_589054, "id", newJInt(id))
  add(query_589055, "key", newJString(key))
  if body != nil:
    body_589056 = body
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589053.call(path_589054, query_589055, nil, nil, body_589056)

var adexchangebuyerAccountsPatch* = Call_AdexchangebuyerAccountsPatch_589040(
    name: "adexchangebuyerAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsPatch_589041,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsPatch_589042,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoList_589057 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerBillingInfoList_589059(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerBillingInfoList_589058(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
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
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("quotaUser")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "quotaUser", valid_589061
  var valid_589062 = query.getOrDefault("alt")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("json"))
  if valid_589062 != nil:
    section.add "alt", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("userIp")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "userIp", valid_589064
  var valid_589065 = query.getOrDefault("key")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "key", valid_589065
  var valid_589066 = query.getOrDefault("prettyPrint")
  valid_589066 = validateParameter(valid_589066, JBool, required = false,
                                 default = newJBool(true))
  if valid_589066 != nil:
    section.add "prettyPrint", valid_589066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589067: Call_AdexchangebuyerBillingInfoList_589057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_AdexchangebuyerBillingInfoList_589057;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerBillingInfoList
  ## Retrieves a list of billing information for all accounts of the authenticated user.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589069 = newJObject()
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(query_589069, "alt", newJString(alt))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "userIp", newJString(userIp))
  add(query_589069, "key", newJString(key))
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  result = call_589068.call(nil, query_589069, nil, nil, nil)

var adexchangebuyerBillingInfoList* = Call_AdexchangebuyerBillingInfoList_589057(
    name: "adexchangebuyerBillingInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo",
    validator: validate_AdexchangebuyerBillingInfoList_589058,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBillingInfoList_589059,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoGet_589070 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerBillingInfoGet_589072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/billinginfo/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerBillingInfoGet_589071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the billing information for one account specified by account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JInt (required)
  ##            : The account id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589073 = path.getOrDefault("accountId")
  valid_589073 = validateParameter(valid_589073, JInt, required = true, default = nil)
  if valid_589073 != nil:
    section.add "accountId", valid_589073
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
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("userIp")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "userIp", valid_589078
  var valid_589079 = query.getOrDefault("key")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "key", valid_589079
  var valid_589080 = query.getOrDefault("prettyPrint")
  valid_589080 = validateParameter(valid_589080, JBool, required = false,
                                 default = newJBool(true))
  if valid_589080 != nil:
    section.add "prettyPrint", valid_589080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589081: Call_AdexchangebuyerBillingInfoGet_589070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the billing information for one account specified by account ID.
  ## 
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_AdexchangebuyerBillingInfoGet_589070; accountId: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerBillingInfoGet
  ## Returns the billing information for one account specified by account ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: int (required)
  ##            : The account id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(query_589084, "alt", newJString(alt))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(path_589083, "accountId", newJInt(accountId))
  add(query_589084, "userIp", newJString(userIp))
  add(query_589084, "key", newJString(key))
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  result = call_589082.call(path_589083, query_589084, nil, nil, nil)

var adexchangebuyerBillingInfoGet* = Call_AdexchangebuyerBillingInfoGet_589070(
    name: "adexchangebuyerBillingInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}",
    validator: validate_AdexchangebuyerBillingInfoGet_589071,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBillingInfoGet_589072,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetUpdate_589101 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerBudgetUpdate_589103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "billingId" in path, "`billingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/billinginfo/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "billingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerBudgetUpdate_589102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingId: JString (required)
  ##            : The billing id associated with the budget being updated.
  ##   accountId: JString (required)
  ##            : The account id associated with the budget being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingId` field"
  var valid_589104 = path.getOrDefault("billingId")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "billingId", valid_589104
  var valid_589105 = path.getOrDefault("accountId")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "accountId", valid_589105
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
  var valid_589106 = query.getOrDefault("fields")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "fields", valid_589106
  var valid_589107 = query.getOrDefault("quotaUser")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "quotaUser", valid_589107
  var valid_589108 = query.getOrDefault("alt")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("json"))
  if valid_589108 != nil:
    section.add "alt", valid_589108
  var valid_589109 = query.getOrDefault("oauth_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "oauth_token", valid_589109
  var valid_589110 = query.getOrDefault("userIp")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "userIp", valid_589110
  var valid_589111 = query.getOrDefault("key")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "key", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
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

proc call*(call_589114: Call_AdexchangebuyerBudgetUpdate_589101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  let valid = call_589114.validator(path, query, header, formData, body)
  let scheme = call_589114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589114.url(scheme.get, call_589114.host, call_589114.base,
                         call_589114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589114, url, valid)

proc call*(call_589115: Call_AdexchangebuyerBudgetUpdate_589101; billingId: string;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerBudgetUpdate
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   billingId: string (required)
  ##            : The billing id associated with the budget being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id associated with the budget being updated.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589116 = newJObject()
  var query_589117 = newJObject()
  var body_589118 = newJObject()
  add(query_589117, "fields", newJString(fields))
  add(query_589117, "quotaUser", newJString(quotaUser))
  add(path_589116, "billingId", newJString(billingId))
  add(query_589117, "alt", newJString(alt))
  add(query_589117, "oauth_token", newJString(oauthToken))
  add(path_589116, "accountId", newJString(accountId))
  add(query_589117, "userIp", newJString(userIp))
  add(query_589117, "key", newJString(key))
  if body != nil:
    body_589118 = body
  add(query_589117, "prettyPrint", newJBool(prettyPrint))
  result = call_589115.call(path_589116, query_589117, nil, nil, body_589118)

var adexchangebuyerBudgetUpdate* = Call_AdexchangebuyerBudgetUpdate_589101(
    name: "adexchangebuyerBudgetUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetUpdate_589102,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetUpdate_589103,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetGet_589085 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerBudgetGet_589087(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "billingId" in path, "`billingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/billinginfo/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "billingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerBudgetGet_589086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingId: JString (required)
  ##            : The billing id to get the budget information for.
  ##   accountId: JString (required)
  ##            : The account id to get the budget information for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingId` field"
  var valid_589088 = path.getOrDefault("billingId")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "billingId", valid_589088
  var valid_589089 = path.getOrDefault("accountId")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "accountId", valid_589089
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
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("userIp")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "userIp", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589097: Call_AdexchangebuyerBudgetGet_589085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_AdexchangebuyerBudgetGet_589085; billingId: string;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerBudgetGet
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   billingId: string (required)
  ##            : The billing id to get the budget information for.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to get the budget information for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589099 = newJObject()
  var query_589100 = newJObject()
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(path_589099, "billingId", newJString(billingId))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(path_589099, "accountId", newJString(accountId))
  add(query_589100, "userIp", newJString(userIp))
  add(query_589100, "key", newJString(key))
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  result = call_589098.call(path_589099, query_589100, nil, nil, nil)

var adexchangebuyerBudgetGet* = Call_AdexchangebuyerBudgetGet_589085(
    name: "adexchangebuyerBudgetGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetGet_589086,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetGet_589087,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetPatch_589119 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerBudgetPatch_589121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "billingId" in path, "`billingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/billinginfo/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "billingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerBudgetPatch_589120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingId: JString (required)
  ##            : The billing id associated with the budget being updated.
  ##   accountId: JString (required)
  ##            : The account id associated with the budget being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingId` field"
  var valid_589122 = path.getOrDefault("billingId")
  valid_589122 = validateParameter(valid_589122, JString, required = true,
                                 default = nil)
  if valid_589122 != nil:
    section.add "billingId", valid_589122
  var valid_589123 = path.getOrDefault("accountId")
  valid_589123 = validateParameter(valid_589123, JString, required = true,
                                 default = nil)
  if valid_589123 != nil:
    section.add "accountId", valid_589123
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
  var valid_589124 = query.getOrDefault("fields")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "fields", valid_589124
  var valid_589125 = query.getOrDefault("quotaUser")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "quotaUser", valid_589125
  var valid_589126 = query.getOrDefault("alt")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = newJString("json"))
  if valid_589126 != nil:
    section.add "alt", valid_589126
  var valid_589127 = query.getOrDefault("oauth_token")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "oauth_token", valid_589127
  var valid_589128 = query.getOrDefault("userIp")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "userIp", valid_589128
  var valid_589129 = query.getOrDefault("key")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "key", valid_589129
  var valid_589130 = query.getOrDefault("prettyPrint")
  valid_589130 = validateParameter(valid_589130, JBool, required = false,
                                 default = newJBool(true))
  if valid_589130 != nil:
    section.add "prettyPrint", valid_589130
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

proc call*(call_589132: Call_AdexchangebuyerBudgetPatch_589119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  let valid = call_589132.validator(path, query, header, formData, body)
  let scheme = call_589132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589132.url(scheme.get, call_589132.host, call_589132.base,
                         call_589132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589132, url, valid)

proc call*(call_589133: Call_AdexchangebuyerBudgetPatch_589119; billingId: string;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerBudgetPatch
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   billingId: string (required)
  ##            : The billing id associated with the budget being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id associated with the budget being updated.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589134 = newJObject()
  var query_589135 = newJObject()
  var body_589136 = newJObject()
  add(query_589135, "fields", newJString(fields))
  add(query_589135, "quotaUser", newJString(quotaUser))
  add(path_589134, "billingId", newJString(billingId))
  add(query_589135, "alt", newJString(alt))
  add(query_589135, "oauth_token", newJString(oauthToken))
  add(path_589134, "accountId", newJString(accountId))
  add(query_589135, "userIp", newJString(userIp))
  add(query_589135, "key", newJString(key))
  if body != nil:
    body_589136 = body
  add(query_589135, "prettyPrint", newJBool(prettyPrint))
  result = call_589133.call(path_589134, query_589135, nil, nil, body_589136)

var adexchangebuyerBudgetPatch* = Call_AdexchangebuyerBudgetPatch_589119(
    name: "adexchangebuyerBudgetPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetPatch_589120,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetPatch_589121,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_589155 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerCreativesInsert_589157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_589156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit a new creative.
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
  var valid_589158 = query.getOrDefault("fields")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "fields", valid_589158
  var valid_589159 = query.getOrDefault("quotaUser")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "quotaUser", valid_589159
  var valid_589160 = query.getOrDefault("alt")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("json"))
  if valid_589160 != nil:
    section.add "alt", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("userIp")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "userIp", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("prettyPrint")
  valid_589164 = validateParameter(valid_589164, JBool, required = false,
                                 default = newJBool(true))
  if valid_589164 != nil:
    section.add "prettyPrint", valid_589164
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

proc call*(call_589166: Call_AdexchangebuyerCreativesInsert_589155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_AdexchangebuyerCreativesInsert_589155;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerCreativesInsert
  ## Submit a new creative.
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
  var query_589168 = newJObject()
  var body_589169 = newJObject()
  add(query_589168, "fields", newJString(fields))
  add(query_589168, "quotaUser", newJString(quotaUser))
  add(query_589168, "alt", newJString(alt))
  add(query_589168, "oauth_token", newJString(oauthToken))
  add(query_589168, "userIp", newJString(userIp))
  add(query_589168, "key", newJString(key))
  if body != nil:
    body_589169 = body
  add(query_589168, "prettyPrint", newJBool(prettyPrint))
  result = call_589167.call(nil, query_589168, nil, nil, body_589169)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_589155(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_589156,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesInsert_589157,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_589137 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerCreativesList_589139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_589138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   buyerCreativeId: JArray
  ##                  : When specified, only creatives for the given buyer creative ids are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   statusFilter: JString
  ##               : When specified, only creatives having the given status are returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   accountId: JArray
  ##            : When specified, only creatives for the given account ids are returned.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589140 = query.getOrDefault("buyerCreativeId")
  valid_589140 = validateParameter(valid_589140, JArray, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "buyerCreativeId", valid_589140
  var valid_589141 = query.getOrDefault("fields")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "fields", valid_589141
  var valid_589142 = query.getOrDefault("pageToken")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "pageToken", valid_589142
  var valid_589143 = query.getOrDefault("quotaUser")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "quotaUser", valid_589143
  var valid_589144 = query.getOrDefault("statusFilter")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = newJString("approved"))
  if valid_589144 != nil:
    section.add "statusFilter", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("accountId")
  valid_589147 = validateParameter(valid_589147, JArray, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "accountId", valid_589147
  var valid_589148 = query.getOrDefault("userIp")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "userIp", valid_589148
  var valid_589149 = query.getOrDefault("maxResults")
  valid_589149 = validateParameter(valid_589149, JInt, required = false, default = nil)
  if valid_589149 != nil:
    section.add "maxResults", valid_589149
  var valid_589150 = query.getOrDefault("key")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "key", valid_589150
  var valid_589151 = query.getOrDefault("prettyPrint")
  valid_589151 = validateParameter(valid_589151, JBool, required = false,
                                 default = newJBool(true))
  if valid_589151 != nil:
    section.add "prettyPrint", valid_589151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589152: Call_AdexchangebuyerCreativesList_589137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_589152.validator(path, query, header, formData, body)
  let scheme = call_589152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589152.url(scheme.get, call_589152.host, call_589152.base,
                         call_589152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589152, url, valid)

proc call*(call_589153: Call_AdexchangebuyerCreativesList_589137;
          buyerCreativeId: JsonNode = nil; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; statusFilter: string = "approved";
          alt: string = "json"; oauthToken: string = ""; accountId: JsonNode = nil;
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerCreativesList
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ##   buyerCreativeId: JArray
  ##                  : When specified, only creatives for the given buyer creative ids are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   statusFilter: string
  ##               : When specified, only creatives having the given status are returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: JArray
  ##            : When specified, only creatives for the given account ids are returned.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589154 = newJObject()
  if buyerCreativeId != nil:
    query_589154.add "buyerCreativeId", buyerCreativeId
  add(query_589154, "fields", newJString(fields))
  add(query_589154, "pageToken", newJString(pageToken))
  add(query_589154, "quotaUser", newJString(quotaUser))
  add(query_589154, "statusFilter", newJString(statusFilter))
  add(query_589154, "alt", newJString(alt))
  add(query_589154, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_589154.add "accountId", accountId
  add(query_589154, "userIp", newJString(userIp))
  add(query_589154, "maxResults", newJInt(maxResults))
  add(query_589154, "key", newJString(key))
  add(query_589154, "prettyPrint", newJBool(prettyPrint))
  result = call_589153.call(nil, query_589154, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_589137(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_589138,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesList_589139,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_589170 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerCreativesGet_589172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "buyerCreativeId" in path, "`buyerCreativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "buyerCreativeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerCreativesGet_589171(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JInt (required)
  ##            : The id for the account that will serve this creative.
  ##   buyerCreativeId: JString (required)
  ##                  : The buyer-specific id for this creative.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589173 = path.getOrDefault("accountId")
  valid_589173 = validateParameter(valid_589173, JInt, required = true, default = nil)
  if valid_589173 != nil:
    section.add "accountId", valid_589173
  var valid_589174 = path.getOrDefault("buyerCreativeId")
  valid_589174 = validateParameter(valid_589174, JString, required = true,
                                 default = nil)
  if valid_589174 != nil:
    section.add "buyerCreativeId", valid_589174
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
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("quotaUser")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "quotaUser", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("oauth_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "oauth_token", valid_589178
  var valid_589179 = query.getOrDefault("userIp")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "userIp", valid_589179
  var valid_589180 = query.getOrDefault("key")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "key", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_AdexchangebuyerCreativesGet_589170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_AdexchangebuyerCreativesGet_589170; accountId: int;
          buyerCreativeId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerCreativesGet
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: int (required)
  ##            : The id for the account that will serve this creative.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   buyerCreativeId: string (required)
  ##                  : The buyer-specific id for this creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(path_589184, "accountId", newJInt(accountId))
  add(query_589185, "userIp", newJString(userIp))
  add(path_589184, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_589185, "key", newJString(key))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_589170(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_589171,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesGet_589172,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerDirectDealsList_589186 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerDirectDealsList_589188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerDirectDealsList_589187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authenticated user's list of direct deals.
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
  var valid_589189 = query.getOrDefault("fields")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "fields", valid_589189
  var valid_589190 = query.getOrDefault("quotaUser")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "quotaUser", valid_589190
  var valid_589191 = query.getOrDefault("alt")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = newJString("json"))
  if valid_589191 != nil:
    section.add "alt", valid_589191
  var valid_589192 = query.getOrDefault("oauth_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "oauth_token", valid_589192
  var valid_589193 = query.getOrDefault("userIp")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "userIp", valid_589193
  var valid_589194 = query.getOrDefault("key")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "key", valid_589194
  var valid_589195 = query.getOrDefault("prettyPrint")
  valid_589195 = validateParameter(valid_589195, JBool, required = false,
                                 default = newJBool(true))
  if valid_589195 != nil:
    section.add "prettyPrint", valid_589195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589196: Call_AdexchangebuyerDirectDealsList_589186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of direct deals.
  ## 
  let valid = call_589196.validator(path, query, header, formData, body)
  let scheme = call_589196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589196.url(scheme.get, call_589196.host, call_589196.base,
                         call_589196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589196, url, valid)

proc call*(call_589197: Call_AdexchangebuyerDirectDealsList_589186;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerDirectDealsList
  ## Retrieves the authenticated user's list of direct deals.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589198 = newJObject()
  add(query_589198, "fields", newJString(fields))
  add(query_589198, "quotaUser", newJString(quotaUser))
  add(query_589198, "alt", newJString(alt))
  add(query_589198, "oauth_token", newJString(oauthToken))
  add(query_589198, "userIp", newJString(userIp))
  add(query_589198, "key", newJString(key))
  add(query_589198, "prettyPrint", newJBool(prettyPrint))
  result = call_589197.call(nil, query_589198, nil, nil, nil)

var adexchangebuyerDirectDealsList* = Call_AdexchangebuyerDirectDealsList_589186(
    name: "adexchangebuyerDirectDealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/directdeals",
    validator: validate_AdexchangebuyerDirectDealsList_589187,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerDirectDealsList_589188,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerDirectDealsGet_589199 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerDirectDealsGet_589201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/directdeals/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerDirectDealsGet_589200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one direct deal by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The direct deal id
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589202 = path.getOrDefault("id")
  valid_589202 = validateParameter(valid_589202, JString, required = true,
                                 default = nil)
  if valid_589202 != nil:
    section.add "id", valid_589202
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
  var valid_589203 = query.getOrDefault("fields")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "fields", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("oauth_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "oauth_token", valid_589206
  var valid_589207 = query.getOrDefault("userIp")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "userIp", valid_589207
  var valid_589208 = query.getOrDefault("key")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "key", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589210: Call_AdexchangebuyerDirectDealsGet_589199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one direct deal by ID.
  ## 
  let valid = call_589210.validator(path, query, header, formData, body)
  let scheme = call_589210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589210.url(scheme.get, call_589210.host, call_589210.base,
                         call_589210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589210, url, valid)

proc call*(call_589211: Call_AdexchangebuyerDirectDealsGet_589199; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerDirectDealsGet
  ## Gets one direct deal by ID.
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
  ##   id: string (required)
  ##     : The direct deal id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589212 = newJObject()
  var query_589213 = newJObject()
  add(query_589213, "fields", newJString(fields))
  add(query_589213, "quotaUser", newJString(quotaUser))
  add(query_589213, "alt", newJString(alt))
  add(query_589213, "oauth_token", newJString(oauthToken))
  add(query_589213, "userIp", newJString(userIp))
  add(path_589212, "id", newJString(id))
  add(query_589213, "key", newJString(key))
  add(query_589213, "prettyPrint", newJBool(prettyPrint))
  result = call_589211.call(path_589212, query_589213, nil, nil, nil)

var adexchangebuyerDirectDealsGet* = Call_AdexchangebuyerDirectDealsGet_589199(
    name: "adexchangebuyerDirectDealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/directdeals/{id}",
    validator: validate_AdexchangebuyerDirectDealsGet_589200,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerDirectDealsGet_589201,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPerformanceReportList_589214 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerPerformanceReportList_589216(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerPerformanceReportList_589215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through performance reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   startDateTime: JString (required)
  ##                : The start time of the report in ISO 8601 timestamp format using UTC.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   accountId: JString (required)
  ##            : The account id to get the reports.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endDateTime: JString (required)
  ##              : The end time of the report in ISO 8601 timestamp format using UTC.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589217 = query.getOrDefault("fields")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "fields", valid_589217
  var valid_589218 = query.getOrDefault("pageToken")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "pageToken", valid_589218
  var valid_589219 = query.getOrDefault("quotaUser")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "quotaUser", valid_589219
  var valid_589220 = query.getOrDefault("alt")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("json"))
  if valid_589220 != nil:
    section.add "alt", valid_589220
  assert query != nil,
        "query argument is necessary due to required `startDateTime` field"
  var valid_589221 = query.getOrDefault("startDateTime")
  valid_589221 = validateParameter(valid_589221, JString, required = true,
                                 default = nil)
  if valid_589221 != nil:
    section.add "startDateTime", valid_589221
  var valid_589222 = query.getOrDefault("oauth_token")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "oauth_token", valid_589222
  var valid_589223 = query.getOrDefault("accountId")
  valid_589223 = validateParameter(valid_589223, JString, required = true,
                                 default = nil)
  if valid_589223 != nil:
    section.add "accountId", valid_589223
  var valid_589224 = query.getOrDefault("userIp")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "userIp", valid_589224
  var valid_589225 = query.getOrDefault("maxResults")
  valid_589225 = validateParameter(valid_589225, JInt, required = false, default = nil)
  if valid_589225 != nil:
    section.add "maxResults", valid_589225
  var valid_589226 = query.getOrDefault("key")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "key", valid_589226
  var valid_589227 = query.getOrDefault("endDateTime")
  valid_589227 = validateParameter(valid_589227, JString, required = true,
                                 default = nil)
  if valid_589227 != nil:
    section.add "endDateTime", valid_589227
  var valid_589228 = query.getOrDefault("prettyPrint")
  valid_589228 = validateParameter(valid_589228, JBool, required = false,
                                 default = newJBool(true))
  if valid_589228 != nil:
    section.add "prettyPrint", valid_589228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589229: Call_AdexchangebuyerPerformanceReportList_589214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  let valid = call_589229.validator(path, query, header, formData, body)
  let scheme = call_589229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589229.url(scheme.get, call_589229.host, call_589229.base,
                         call_589229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589229, url, valid)

proc call*(call_589230: Call_AdexchangebuyerPerformanceReportList_589214;
          startDateTime: string; accountId: string; endDateTime: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPerformanceReportList
  ## Retrieves the authenticated user's list of performance metrics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through performance reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   startDateTime: string (required)
  ##                : The start time of the report in ISO 8601 timestamp format using UTC.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to get the reports.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endDateTime: string (required)
  ##              : The end time of the report in ISO 8601 timestamp format using UTC.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589231 = newJObject()
  add(query_589231, "fields", newJString(fields))
  add(query_589231, "pageToken", newJString(pageToken))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "alt", newJString(alt))
  add(query_589231, "startDateTime", newJString(startDateTime))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(query_589231, "accountId", newJString(accountId))
  add(query_589231, "userIp", newJString(userIp))
  add(query_589231, "maxResults", newJInt(maxResults))
  add(query_589231, "key", newJString(key))
  add(query_589231, "endDateTime", newJString(endDateTime))
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  result = call_589230.call(nil, query_589231, nil, nil, nil)

var adexchangebuyerPerformanceReportList* = Call_AdexchangebuyerPerformanceReportList_589214(
    name: "adexchangebuyerPerformanceReportList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/performancereport",
    validator: validate_AdexchangebuyerPerformanceReportList_589215,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPerformanceReportList_589216,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigInsert_589247 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerPretargetingConfigInsert_589249(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigInsert_589248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new pretargeting configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account id to insert the pretargeting config for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589250 = path.getOrDefault("accountId")
  valid_589250 = validateParameter(valid_589250, JString, required = true,
                                 default = nil)
  if valid_589250 != nil:
    section.add "accountId", valid_589250
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
  var valid_589251 = query.getOrDefault("fields")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "fields", valid_589251
  var valid_589252 = query.getOrDefault("quotaUser")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "quotaUser", valid_589252
  var valid_589253 = query.getOrDefault("alt")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = newJString("json"))
  if valid_589253 != nil:
    section.add "alt", valid_589253
  var valid_589254 = query.getOrDefault("oauth_token")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "oauth_token", valid_589254
  var valid_589255 = query.getOrDefault("userIp")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "userIp", valid_589255
  var valid_589256 = query.getOrDefault("key")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "key", valid_589256
  var valid_589257 = query.getOrDefault("prettyPrint")
  valid_589257 = validateParameter(valid_589257, JBool, required = false,
                                 default = newJBool(true))
  if valid_589257 != nil:
    section.add "prettyPrint", valid_589257
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

proc call*(call_589259: Call_AdexchangebuyerPretargetingConfigInsert_589247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new pretargeting configuration.
  ## 
  let valid = call_589259.validator(path, query, header, formData, body)
  let scheme = call_589259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589259.url(scheme.get, call_589259.host, call_589259.base,
                         call_589259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589259, url, valid)

proc call*(call_589260: Call_AdexchangebuyerPretargetingConfigInsert_589247;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPretargetingConfigInsert
  ## Inserts a new pretargeting configuration.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to insert the pretargeting config for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589261 = newJObject()
  var query_589262 = newJObject()
  var body_589263 = newJObject()
  add(query_589262, "fields", newJString(fields))
  add(query_589262, "quotaUser", newJString(quotaUser))
  add(query_589262, "alt", newJString(alt))
  add(query_589262, "oauth_token", newJString(oauthToken))
  add(path_589261, "accountId", newJString(accountId))
  add(query_589262, "userIp", newJString(userIp))
  add(query_589262, "key", newJString(key))
  if body != nil:
    body_589263 = body
  add(query_589262, "prettyPrint", newJBool(prettyPrint))
  result = call_589260.call(path_589261, query_589262, nil, nil, body_589263)

var adexchangebuyerPretargetingConfigInsert* = Call_AdexchangebuyerPretargetingConfigInsert_589247(
    name: "adexchangebuyerPretargetingConfigInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigInsert_589248,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigInsert_589249,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigList_589232 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerPretargetingConfigList_589234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigList_589233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account id to get the pretargeting configs for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589235 = path.getOrDefault("accountId")
  valid_589235 = validateParameter(valid_589235, JString, required = true,
                                 default = nil)
  if valid_589235 != nil:
    section.add "accountId", valid_589235
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
  var valid_589236 = query.getOrDefault("fields")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "fields", valid_589236
  var valid_589237 = query.getOrDefault("quotaUser")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "quotaUser", valid_589237
  var valid_589238 = query.getOrDefault("alt")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = newJString("json"))
  if valid_589238 != nil:
    section.add "alt", valid_589238
  var valid_589239 = query.getOrDefault("oauth_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "oauth_token", valid_589239
  var valid_589240 = query.getOrDefault("userIp")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "userIp", valid_589240
  var valid_589241 = query.getOrDefault("key")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "key", valid_589241
  var valid_589242 = query.getOrDefault("prettyPrint")
  valid_589242 = validateParameter(valid_589242, JBool, required = false,
                                 default = newJBool(true))
  if valid_589242 != nil:
    section.add "prettyPrint", valid_589242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589243: Call_AdexchangebuyerPretargetingConfigList_589232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  let valid = call_589243.validator(path, query, header, formData, body)
  let scheme = call_589243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589243.url(scheme.get, call_589243.host, call_589243.base,
                         call_589243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589243, url, valid)

proc call*(call_589244: Call_AdexchangebuyerPretargetingConfigList_589232;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPretargetingConfigList
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to get the pretargeting configs for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589245 = newJObject()
  var query_589246 = newJObject()
  add(query_589246, "fields", newJString(fields))
  add(query_589246, "quotaUser", newJString(quotaUser))
  add(query_589246, "alt", newJString(alt))
  add(query_589246, "oauth_token", newJString(oauthToken))
  add(path_589245, "accountId", newJString(accountId))
  add(query_589246, "userIp", newJString(userIp))
  add(query_589246, "key", newJString(key))
  add(query_589246, "prettyPrint", newJBool(prettyPrint))
  result = call_589244.call(path_589245, query_589246, nil, nil, nil)

var adexchangebuyerPretargetingConfigList* = Call_AdexchangebuyerPretargetingConfigList_589232(
    name: "adexchangebuyerPretargetingConfigList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigList_589233,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPretargetingConfigList_589234,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigUpdate_589280 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerPretargetingConfigUpdate_589282(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "configId" in path, "`configId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "configId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigUpdate_589281(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing pretargeting config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account id to update the pretargeting config for.
  ##   configId: JString (required)
  ##           : The specific id of the configuration to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589283 = path.getOrDefault("accountId")
  valid_589283 = validateParameter(valid_589283, JString, required = true,
                                 default = nil)
  if valid_589283 != nil:
    section.add "accountId", valid_589283
  var valid_589284 = path.getOrDefault("configId")
  valid_589284 = validateParameter(valid_589284, JString, required = true,
                                 default = nil)
  if valid_589284 != nil:
    section.add "configId", valid_589284
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
  var valid_589285 = query.getOrDefault("fields")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "fields", valid_589285
  var valid_589286 = query.getOrDefault("quotaUser")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "quotaUser", valid_589286
  var valid_589287 = query.getOrDefault("alt")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = newJString("json"))
  if valid_589287 != nil:
    section.add "alt", valid_589287
  var valid_589288 = query.getOrDefault("oauth_token")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "oauth_token", valid_589288
  var valid_589289 = query.getOrDefault("userIp")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "userIp", valid_589289
  var valid_589290 = query.getOrDefault("key")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "key", valid_589290
  var valid_589291 = query.getOrDefault("prettyPrint")
  valid_589291 = validateParameter(valid_589291, JBool, required = false,
                                 default = newJBool(true))
  if valid_589291 != nil:
    section.add "prettyPrint", valid_589291
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

proc call*(call_589293: Call_AdexchangebuyerPretargetingConfigUpdate_589280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config.
  ## 
  let valid = call_589293.validator(path, query, header, formData, body)
  let scheme = call_589293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589293.url(scheme.get, call_589293.host, call_589293.base,
                         call_589293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589293, url, valid)

proc call*(call_589294: Call_AdexchangebuyerPretargetingConfigUpdate_589280;
          accountId: string; configId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPretargetingConfigUpdate
  ## Updates an existing pretargeting config.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to update the pretargeting config for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   configId: string (required)
  ##           : The specific id of the configuration to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589295 = newJObject()
  var query_589296 = newJObject()
  var body_589297 = newJObject()
  add(query_589296, "fields", newJString(fields))
  add(query_589296, "quotaUser", newJString(quotaUser))
  add(query_589296, "alt", newJString(alt))
  add(query_589296, "oauth_token", newJString(oauthToken))
  add(path_589295, "accountId", newJString(accountId))
  add(query_589296, "userIp", newJString(userIp))
  add(query_589296, "key", newJString(key))
  add(path_589295, "configId", newJString(configId))
  if body != nil:
    body_589297 = body
  add(query_589296, "prettyPrint", newJBool(prettyPrint))
  result = call_589294.call(path_589295, query_589296, nil, nil, body_589297)

var adexchangebuyerPretargetingConfigUpdate* = Call_AdexchangebuyerPretargetingConfigUpdate_589280(
    name: "adexchangebuyerPretargetingConfigUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigUpdate_589281,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigUpdate_589282,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigGet_589264 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerPretargetingConfigGet_589266(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "configId" in path, "`configId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "configId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigGet_589265(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific pretargeting configuration
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account id to get the pretargeting config for.
  ##   configId: JString (required)
  ##           : The specific id of the configuration to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589267 = path.getOrDefault("accountId")
  valid_589267 = validateParameter(valid_589267, JString, required = true,
                                 default = nil)
  if valid_589267 != nil:
    section.add "accountId", valid_589267
  var valid_589268 = path.getOrDefault("configId")
  valid_589268 = validateParameter(valid_589268, JString, required = true,
                                 default = nil)
  if valid_589268 != nil:
    section.add "configId", valid_589268
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
  var valid_589269 = query.getOrDefault("fields")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "fields", valid_589269
  var valid_589270 = query.getOrDefault("quotaUser")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "quotaUser", valid_589270
  var valid_589271 = query.getOrDefault("alt")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("json"))
  if valid_589271 != nil:
    section.add "alt", valid_589271
  var valid_589272 = query.getOrDefault("oauth_token")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "oauth_token", valid_589272
  var valid_589273 = query.getOrDefault("userIp")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "userIp", valid_589273
  var valid_589274 = query.getOrDefault("key")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "key", valid_589274
  var valid_589275 = query.getOrDefault("prettyPrint")
  valid_589275 = validateParameter(valid_589275, JBool, required = false,
                                 default = newJBool(true))
  if valid_589275 != nil:
    section.add "prettyPrint", valid_589275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589276: Call_AdexchangebuyerPretargetingConfigGet_589264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific pretargeting configuration
  ## 
  let valid = call_589276.validator(path, query, header, formData, body)
  let scheme = call_589276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589276.url(scheme.get, call_589276.host, call_589276.base,
                         call_589276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589276, url, valid)

proc call*(call_589277: Call_AdexchangebuyerPretargetingConfigGet_589264;
          accountId: string; configId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPretargetingConfigGet
  ## Gets a specific pretargeting configuration
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to get the pretargeting config for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   configId: string (required)
  ##           : The specific id of the configuration to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589278 = newJObject()
  var query_589279 = newJObject()
  add(query_589279, "fields", newJString(fields))
  add(query_589279, "quotaUser", newJString(quotaUser))
  add(query_589279, "alt", newJString(alt))
  add(query_589279, "oauth_token", newJString(oauthToken))
  add(path_589278, "accountId", newJString(accountId))
  add(query_589279, "userIp", newJString(userIp))
  add(query_589279, "key", newJString(key))
  add(path_589278, "configId", newJString(configId))
  add(query_589279, "prettyPrint", newJBool(prettyPrint))
  result = call_589277.call(path_589278, query_589279, nil, nil, nil)

var adexchangebuyerPretargetingConfigGet* = Call_AdexchangebuyerPretargetingConfigGet_589264(
    name: "adexchangebuyerPretargetingConfigGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigGet_589265,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPretargetingConfigGet_589266,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigPatch_589314 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerPretargetingConfigPatch_589316(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "configId" in path, "`configId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "configId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigPatch_589315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account id to update the pretargeting config for.
  ##   configId: JString (required)
  ##           : The specific id of the configuration to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589317 = path.getOrDefault("accountId")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = nil)
  if valid_589317 != nil:
    section.add "accountId", valid_589317
  var valid_589318 = path.getOrDefault("configId")
  valid_589318 = validateParameter(valid_589318, JString, required = true,
                                 default = nil)
  if valid_589318 != nil:
    section.add "configId", valid_589318
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
  var valid_589319 = query.getOrDefault("fields")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "fields", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("oauth_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "oauth_token", valid_589322
  var valid_589323 = query.getOrDefault("userIp")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "userIp", valid_589323
  var valid_589324 = query.getOrDefault("key")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "key", valid_589324
  var valid_589325 = query.getOrDefault("prettyPrint")
  valid_589325 = validateParameter(valid_589325, JBool, required = false,
                                 default = newJBool(true))
  if valid_589325 != nil:
    section.add "prettyPrint", valid_589325
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

proc call*(call_589327: Call_AdexchangebuyerPretargetingConfigPatch_589314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  let valid = call_589327.validator(path, query, header, formData, body)
  let scheme = call_589327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589327.url(scheme.get, call_589327.host, call_589327.base,
                         call_589327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589327, url, valid)

proc call*(call_589328: Call_AdexchangebuyerPretargetingConfigPatch_589314;
          accountId: string; configId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPretargetingConfigPatch
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to update the pretargeting config for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   configId: string (required)
  ##           : The specific id of the configuration to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589329 = newJObject()
  var query_589330 = newJObject()
  var body_589331 = newJObject()
  add(query_589330, "fields", newJString(fields))
  add(query_589330, "quotaUser", newJString(quotaUser))
  add(query_589330, "alt", newJString(alt))
  add(query_589330, "oauth_token", newJString(oauthToken))
  add(path_589329, "accountId", newJString(accountId))
  add(query_589330, "userIp", newJString(userIp))
  add(query_589330, "key", newJString(key))
  add(path_589329, "configId", newJString(configId))
  if body != nil:
    body_589331 = body
  add(query_589330, "prettyPrint", newJBool(prettyPrint))
  result = call_589328.call(path_589329, query_589330, nil, nil, body_589331)

var adexchangebuyerPretargetingConfigPatch* = Call_AdexchangebuyerPretargetingConfigPatch_589314(
    name: "adexchangebuyerPretargetingConfigPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigPatch_589315,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigPatch_589316,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigDelete_589298 = ref object of OpenApiRestCall_588457
proc url_AdexchangebuyerPretargetingConfigDelete_589300(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "configId" in path, "`configId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "configId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigDelete_589299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing pretargeting config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account id to delete the pretargeting config for.
  ##   configId: JString (required)
  ##           : The specific id of the configuration to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589301 = path.getOrDefault("accountId")
  valid_589301 = validateParameter(valid_589301, JString, required = true,
                                 default = nil)
  if valid_589301 != nil:
    section.add "accountId", valid_589301
  var valid_589302 = path.getOrDefault("configId")
  valid_589302 = validateParameter(valid_589302, JString, required = true,
                                 default = nil)
  if valid_589302 != nil:
    section.add "configId", valid_589302
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
  var valid_589303 = query.getOrDefault("fields")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "fields", valid_589303
  var valid_589304 = query.getOrDefault("quotaUser")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "quotaUser", valid_589304
  var valid_589305 = query.getOrDefault("alt")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("json"))
  if valid_589305 != nil:
    section.add "alt", valid_589305
  var valid_589306 = query.getOrDefault("oauth_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "oauth_token", valid_589306
  var valid_589307 = query.getOrDefault("userIp")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "userIp", valid_589307
  var valid_589308 = query.getOrDefault("key")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "key", valid_589308
  var valid_589309 = query.getOrDefault("prettyPrint")
  valid_589309 = validateParameter(valid_589309, JBool, required = false,
                                 default = newJBool(true))
  if valid_589309 != nil:
    section.add "prettyPrint", valid_589309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589310: Call_AdexchangebuyerPretargetingConfigDelete_589298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing pretargeting config.
  ## 
  let valid = call_589310.validator(path, query, header, formData, body)
  let scheme = call_589310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589310.url(scheme.get, call_589310.host, call_589310.base,
                         call_589310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589310, url, valid)

proc call*(call_589311: Call_AdexchangebuyerPretargetingConfigDelete_589298;
          accountId: string; configId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPretargetingConfigDelete
  ## Deletes an existing pretargeting config.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account id to delete the pretargeting config for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   configId: string (required)
  ##           : The specific id of the configuration to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589312 = newJObject()
  var query_589313 = newJObject()
  add(query_589313, "fields", newJString(fields))
  add(query_589313, "quotaUser", newJString(quotaUser))
  add(query_589313, "alt", newJString(alt))
  add(query_589313, "oauth_token", newJString(oauthToken))
  add(path_589312, "accountId", newJString(accountId))
  add(query_589313, "userIp", newJString(userIp))
  add(query_589313, "key", newJString(key))
  add(path_589312, "configId", newJString(configId))
  add(query_589313, "prettyPrint", newJBool(prettyPrint))
  result = call_589311.call(path_589312, query_589313, nil, nil, nil)

var adexchangebuyerPretargetingConfigDelete* = Call_AdexchangebuyerPretargetingConfigDelete_589298(
    name: "adexchangebuyerPretargetingConfigDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigDelete_589299,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigDelete_589300,
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
