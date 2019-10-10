
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Ad Exchange Buyer
## version: v1.4
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

  OpenApiRestCall_588466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588466): Option[Scheme] {.used.} =
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
  Call_AdexchangebuyerAccountsList_588735 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerAccountsList_588737(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerAccountsList_588736(path: JsonNode; query: JsonNode;
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
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("userIp")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "userIp", valid_588866
  var valid_588867 = query.getOrDefault("key")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "key", valid_588867
  var valid_588868 = query.getOrDefault("prettyPrint")
  valid_588868 = validateParameter(valid_588868, JBool, required = false,
                                 default = newJBool(true))
  if valid_588868 != nil:
    section.add "prettyPrint", valid_588868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588891: Call_AdexchangebuyerAccountsList_588735; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of accounts.
  ## 
  let valid = call_588891.validator(path, query, header, formData, body)
  let scheme = call_588891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588891.url(scheme.get, call_588891.host, call_588891.base,
                         call_588891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588891, url, valid)

proc call*(call_588962: Call_AdexchangebuyerAccountsList_588735;
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
  var query_588963 = newJObject()
  add(query_588963, "fields", newJString(fields))
  add(query_588963, "quotaUser", newJString(quotaUser))
  add(query_588963, "alt", newJString(alt))
  add(query_588963, "oauth_token", newJString(oauthToken))
  add(query_588963, "userIp", newJString(userIp))
  add(query_588963, "key", newJString(key))
  add(query_588963, "prettyPrint", newJBool(prettyPrint))
  result = call_588962.call(nil, query_588963, nil, nil, nil)

var adexchangebuyerAccountsList* = Call_AdexchangebuyerAccountsList_588735(
    name: "adexchangebuyerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangebuyerAccountsList_588736,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsList_588737,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsUpdate_589032 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerAccountsUpdate_589034(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsUpdate_589033(path: JsonNode; query: JsonNode;
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
  var valid_589035 = path.getOrDefault("id")
  valid_589035 = validateParameter(valid_589035, JInt, required = true, default = nil)
  if valid_589035 != nil:
    section.add "id", valid_589035
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   confirmUnsafeAccountChange: JBool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("alt")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("json"))
  if valid_589038 != nil:
    section.add "alt", valid_589038
  var valid_589039 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_589039 = validateParameter(valid_589039, JBool, required = false, default = nil)
  if valid_589039 != nil:
    section.add "confirmUnsafeAccountChange", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("userIp")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "userIp", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
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

proc call*(call_589045: Call_AdexchangebuyerAccountsUpdate_589032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account.
  ## 
  let valid = call_589045.validator(path, query, header, formData, body)
  let scheme = call_589045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589045.url(scheme.get, call_589045.host, call_589045.base,
                         call_589045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589045, url, valid)

proc call*(call_589046: Call_AdexchangebuyerAccountsUpdate_589032; id: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          confirmUnsafeAccountChange: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerAccountsUpdate
  ## Updates an existing account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   confirmUnsafeAccountChange: bool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
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
  var path_589047 = newJObject()
  var query_589048 = newJObject()
  var body_589049 = newJObject()
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "userIp", newJString(userIp))
  add(path_589047, "id", newJInt(id))
  add(query_589048, "key", newJString(key))
  if body != nil:
    body_589049 = body
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  result = call_589046.call(path_589047, query_589048, nil, nil, body_589049)

var adexchangebuyerAccountsUpdate* = Call_AdexchangebuyerAccountsUpdate_589032(
    name: "adexchangebuyerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsUpdate_589033,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsUpdate_589034,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsGet_589003 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerAccountsGet_589005(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsGet_589004(path: JsonNode; query: JsonNode;
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
  var valid_589020 = path.getOrDefault("id")
  valid_589020 = validateParameter(valid_589020, JInt, required = true, default = nil)
  if valid_589020 != nil:
    section.add "id", valid_589020
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
  var valid_589021 = query.getOrDefault("fields")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "fields", valid_589021
  var valid_589022 = query.getOrDefault("quotaUser")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "quotaUser", valid_589022
  var valid_589023 = query.getOrDefault("alt")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("json"))
  if valid_589023 != nil:
    section.add "alt", valid_589023
  var valid_589024 = query.getOrDefault("oauth_token")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "oauth_token", valid_589024
  var valid_589025 = query.getOrDefault("userIp")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "userIp", valid_589025
  var valid_589026 = query.getOrDefault("key")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "key", valid_589026
  var valid_589027 = query.getOrDefault("prettyPrint")
  valid_589027 = validateParameter(valid_589027, JBool, required = false,
                                 default = newJBool(true))
  if valid_589027 != nil:
    section.add "prettyPrint", valid_589027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589028: Call_AdexchangebuyerAccountsGet_589003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one account by ID.
  ## 
  let valid = call_589028.validator(path, query, header, formData, body)
  let scheme = call_589028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589028.url(scheme.get, call_589028.host, call_589028.base,
                         call_589028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589028, url, valid)

proc call*(call_589029: Call_AdexchangebuyerAccountsGet_589003; id: int;
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
  var path_589030 = newJObject()
  var query_589031 = newJObject()
  add(query_589031, "fields", newJString(fields))
  add(query_589031, "quotaUser", newJString(quotaUser))
  add(query_589031, "alt", newJString(alt))
  add(query_589031, "oauth_token", newJString(oauthToken))
  add(query_589031, "userIp", newJString(userIp))
  add(path_589030, "id", newJInt(id))
  add(query_589031, "key", newJString(key))
  add(query_589031, "prettyPrint", newJBool(prettyPrint))
  result = call_589029.call(path_589030, query_589031, nil, nil, nil)

var adexchangebuyerAccountsGet* = Call_AdexchangebuyerAccountsGet_589003(
    name: "adexchangebuyerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsGet_589004,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsGet_589005,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsPatch_589050 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerAccountsPatch_589052(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsPatch_589051(path: JsonNode; query: JsonNode;
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
  var valid_589053 = path.getOrDefault("id")
  valid_589053 = validateParameter(valid_589053, JInt, required = true, default = nil)
  if valid_589053 != nil:
    section.add "id", valid_589053
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   confirmUnsafeAccountChange: JBool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_589057 = validateParameter(valid_589057, JBool, required = false, default = nil)
  if valid_589057 != nil:
    section.add "confirmUnsafeAccountChange", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("userIp")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "userIp", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("prettyPrint")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "prettyPrint", valid_589061
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

proc call*(call_589063: Call_AdexchangebuyerAccountsPatch_589050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  let valid = call_589063.validator(path, query, header, formData, body)
  let scheme = call_589063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589063.url(scheme.get, call_589063.host, call_589063.base,
                         call_589063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589063, url, valid)

proc call*(call_589064: Call_AdexchangebuyerAccountsPatch_589050; id: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          confirmUnsafeAccountChange: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerAccountsPatch
  ## Updates an existing account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   confirmUnsafeAccountChange: bool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
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
  var path_589065 = newJObject()
  var query_589066 = newJObject()
  var body_589067 = newJObject()
  add(query_589066, "fields", newJString(fields))
  add(query_589066, "quotaUser", newJString(quotaUser))
  add(query_589066, "alt", newJString(alt))
  add(query_589066, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  add(query_589066, "oauth_token", newJString(oauthToken))
  add(query_589066, "userIp", newJString(userIp))
  add(path_589065, "id", newJInt(id))
  add(query_589066, "key", newJString(key))
  if body != nil:
    body_589067 = body
  add(query_589066, "prettyPrint", newJBool(prettyPrint))
  result = call_589064.call(path_589065, query_589066, nil, nil, body_589067)

var adexchangebuyerAccountsPatch* = Call_AdexchangebuyerAccountsPatch_589050(
    name: "adexchangebuyerAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsPatch_589051,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsPatch_589052,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoList_589068 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerBillingInfoList_589070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerBillingInfoList_589069(path: JsonNode;
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
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("quotaUser")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "quotaUser", valid_589072
  var valid_589073 = query.getOrDefault("alt")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("json"))
  if valid_589073 != nil:
    section.add "alt", valid_589073
  var valid_589074 = query.getOrDefault("oauth_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "oauth_token", valid_589074
  var valid_589075 = query.getOrDefault("userIp")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "userIp", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589078: Call_AdexchangebuyerBillingInfoList_589068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
  ## 
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_AdexchangebuyerBillingInfoList_589068;
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
  var query_589080 = newJObject()
  add(query_589080, "fields", newJString(fields))
  add(query_589080, "quotaUser", newJString(quotaUser))
  add(query_589080, "alt", newJString(alt))
  add(query_589080, "oauth_token", newJString(oauthToken))
  add(query_589080, "userIp", newJString(userIp))
  add(query_589080, "key", newJString(key))
  add(query_589080, "prettyPrint", newJBool(prettyPrint))
  result = call_589079.call(nil, query_589080, nil, nil, nil)

var adexchangebuyerBillingInfoList* = Call_AdexchangebuyerBillingInfoList_589068(
    name: "adexchangebuyerBillingInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo",
    validator: validate_AdexchangebuyerBillingInfoList_589069,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoList_589070,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoGet_589081 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerBillingInfoGet_589083(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBillingInfoGet_589082(path: JsonNode; query: JsonNode;
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
  var valid_589084 = path.getOrDefault("accountId")
  valid_589084 = validateParameter(valid_589084, JInt, required = true, default = nil)
  if valid_589084 != nil:
    section.add "accountId", valid_589084
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
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("userIp")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "userIp", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589092: Call_AdexchangebuyerBillingInfoGet_589081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the billing information for one account specified by account ID.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_AdexchangebuyerBillingInfoGet_589081; accountId: int;
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
  var path_589094 = newJObject()
  var query_589095 = newJObject()
  add(query_589095, "fields", newJString(fields))
  add(query_589095, "quotaUser", newJString(quotaUser))
  add(query_589095, "alt", newJString(alt))
  add(query_589095, "oauth_token", newJString(oauthToken))
  add(path_589094, "accountId", newJInt(accountId))
  add(query_589095, "userIp", newJString(userIp))
  add(query_589095, "key", newJString(key))
  add(query_589095, "prettyPrint", newJBool(prettyPrint))
  result = call_589093.call(path_589094, query_589095, nil, nil, nil)

var adexchangebuyerBillingInfoGet* = Call_AdexchangebuyerBillingInfoGet_589081(
    name: "adexchangebuyerBillingInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}",
    validator: validate_AdexchangebuyerBillingInfoGet_589082,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoGet_589083,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetUpdate_589112 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerBudgetUpdate_589114(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetUpdate_589113(path: JsonNode; query: JsonNode;
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
  var valid_589115 = path.getOrDefault("billingId")
  valid_589115 = validateParameter(valid_589115, JString, required = true,
                                 default = nil)
  if valid_589115 != nil:
    section.add "billingId", valid_589115
  var valid_589116 = path.getOrDefault("accountId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "accountId", valid_589116
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
  var valid_589117 = query.getOrDefault("fields")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "fields", valid_589117
  var valid_589118 = query.getOrDefault("quotaUser")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "quotaUser", valid_589118
  var valid_589119 = query.getOrDefault("alt")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("json"))
  if valid_589119 != nil:
    section.add "alt", valid_589119
  var valid_589120 = query.getOrDefault("oauth_token")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "oauth_token", valid_589120
  var valid_589121 = query.getOrDefault("userIp")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "userIp", valid_589121
  var valid_589122 = query.getOrDefault("key")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "key", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
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

proc call*(call_589125: Call_AdexchangebuyerBudgetUpdate_589112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  let valid = call_589125.validator(path, query, header, formData, body)
  let scheme = call_589125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589125.url(scheme.get, call_589125.host, call_589125.base,
                         call_589125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589125, url, valid)

proc call*(call_589126: Call_AdexchangebuyerBudgetUpdate_589112; billingId: string;
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
  var path_589127 = newJObject()
  var query_589128 = newJObject()
  var body_589129 = newJObject()
  add(query_589128, "fields", newJString(fields))
  add(query_589128, "quotaUser", newJString(quotaUser))
  add(path_589127, "billingId", newJString(billingId))
  add(query_589128, "alt", newJString(alt))
  add(query_589128, "oauth_token", newJString(oauthToken))
  add(path_589127, "accountId", newJString(accountId))
  add(query_589128, "userIp", newJString(userIp))
  add(query_589128, "key", newJString(key))
  if body != nil:
    body_589129 = body
  add(query_589128, "prettyPrint", newJBool(prettyPrint))
  result = call_589126.call(path_589127, query_589128, nil, nil, body_589129)

var adexchangebuyerBudgetUpdate* = Call_AdexchangebuyerBudgetUpdate_589112(
    name: "adexchangebuyerBudgetUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetUpdate_589113,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetUpdate_589114,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetGet_589096 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerBudgetGet_589098(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetGet_589097(path: JsonNode; query: JsonNode;
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
  var valid_589099 = path.getOrDefault("billingId")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "billingId", valid_589099
  var valid_589100 = path.getOrDefault("accountId")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "accountId", valid_589100
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
  var valid_589101 = query.getOrDefault("fields")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "fields", valid_589101
  var valid_589102 = query.getOrDefault("quotaUser")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "quotaUser", valid_589102
  var valid_589103 = query.getOrDefault("alt")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("json"))
  if valid_589103 != nil:
    section.add "alt", valid_589103
  var valid_589104 = query.getOrDefault("oauth_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "oauth_token", valid_589104
  var valid_589105 = query.getOrDefault("userIp")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "userIp", valid_589105
  var valid_589106 = query.getOrDefault("key")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "key", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589108: Call_AdexchangebuyerBudgetGet_589096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_AdexchangebuyerBudgetGet_589096; billingId: string;
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
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(path_589110, "billingId", newJString(billingId))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(path_589110, "accountId", newJString(accountId))
  add(query_589111, "userIp", newJString(userIp))
  add(query_589111, "key", newJString(key))
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  result = call_589109.call(path_589110, query_589111, nil, nil, nil)

var adexchangebuyerBudgetGet* = Call_AdexchangebuyerBudgetGet_589096(
    name: "adexchangebuyerBudgetGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetGet_589097,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetGet_589098,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetPatch_589130 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerBudgetPatch_589132(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetPatch_589131(path: JsonNode; query: JsonNode;
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
  var valid_589133 = path.getOrDefault("billingId")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "billingId", valid_589133
  var valid_589134 = path.getOrDefault("accountId")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "accountId", valid_589134
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
  var valid_589135 = query.getOrDefault("fields")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "fields", valid_589135
  var valid_589136 = query.getOrDefault("quotaUser")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "quotaUser", valid_589136
  var valid_589137 = query.getOrDefault("alt")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("json"))
  if valid_589137 != nil:
    section.add "alt", valid_589137
  var valid_589138 = query.getOrDefault("oauth_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "oauth_token", valid_589138
  var valid_589139 = query.getOrDefault("userIp")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "userIp", valid_589139
  var valid_589140 = query.getOrDefault("key")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "key", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
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

proc call*(call_589143: Call_AdexchangebuyerBudgetPatch_589130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_AdexchangebuyerBudgetPatch_589130; billingId: string;
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
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  var body_589147 = newJObject()
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(path_589145, "billingId", newJString(billingId))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(path_589145, "accountId", newJString(accountId))
  add(query_589146, "userIp", newJString(userIp))
  add(query_589146, "key", newJString(key))
  if body != nil:
    body_589147 = body
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(path_589145, query_589146, nil, nil, body_589147)

var adexchangebuyerBudgetPatch* = Call_AdexchangebuyerBudgetPatch_589130(
    name: "adexchangebuyerBudgetPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetPatch_589131,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetPatch_589132,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_589167 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerCreativesInsert_589169(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_589168(path: JsonNode;
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
  var valid_589170 = query.getOrDefault("fields")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "fields", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("alt")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("json"))
  if valid_589172 != nil:
    section.add "alt", valid_589172
  var valid_589173 = query.getOrDefault("oauth_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "oauth_token", valid_589173
  var valid_589174 = query.getOrDefault("userIp")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "userIp", valid_589174
  var valid_589175 = query.getOrDefault("key")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "key", valid_589175
  var valid_589176 = query.getOrDefault("prettyPrint")
  valid_589176 = validateParameter(valid_589176, JBool, required = false,
                                 default = newJBool(true))
  if valid_589176 != nil:
    section.add "prettyPrint", valid_589176
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

proc call*(call_589178: Call_AdexchangebuyerCreativesInsert_589167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_AdexchangebuyerCreativesInsert_589167;
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
  var query_589180 = newJObject()
  var body_589181 = newJObject()
  add(query_589180, "fields", newJString(fields))
  add(query_589180, "quotaUser", newJString(quotaUser))
  add(query_589180, "alt", newJString(alt))
  add(query_589180, "oauth_token", newJString(oauthToken))
  add(query_589180, "userIp", newJString(userIp))
  add(query_589180, "key", newJString(key))
  if body != nil:
    body_589181 = body
  add(query_589180, "prettyPrint", newJBool(prettyPrint))
  result = call_589179.call(nil, query_589180, nil, nil, body_589181)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_589167(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_589168,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesInsert_589169,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_589148 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerCreativesList_589150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_589149(path: JsonNode; query: JsonNode;
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
  ##   openAuctionStatusFilter: JString
  ##                          : When specified, only creatives having the given open auction status are returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   dealsStatusFilter: JString
  ##                    : When specified, only creatives having the given deals status are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589151 = query.getOrDefault("buyerCreativeId")
  valid_589151 = validateParameter(valid_589151, JArray, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "buyerCreativeId", valid_589151
  var valid_589152 = query.getOrDefault("fields")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "fields", valid_589152
  var valid_589153 = query.getOrDefault("pageToken")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "pageToken", valid_589153
  var valid_589154 = query.getOrDefault("quotaUser")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "quotaUser", valid_589154
  var valid_589155 = query.getOrDefault("alt")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("json"))
  if valid_589155 != nil:
    section.add "alt", valid_589155
  var valid_589156 = query.getOrDefault("oauth_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "oauth_token", valid_589156
  var valid_589157 = query.getOrDefault("accountId")
  valid_589157 = validateParameter(valid_589157, JArray, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "accountId", valid_589157
  var valid_589158 = query.getOrDefault("userIp")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "userIp", valid_589158
  var valid_589159 = query.getOrDefault("maxResults")
  valid_589159 = validateParameter(valid_589159, JInt, required = false, default = nil)
  if valid_589159 != nil:
    section.add "maxResults", valid_589159
  var valid_589160 = query.getOrDefault("openAuctionStatusFilter")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("approved"))
  if valid_589160 != nil:
    section.add "openAuctionStatusFilter", valid_589160
  var valid_589161 = query.getOrDefault("key")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "key", valid_589161
  var valid_589162 = query.getOrDefault("dealsStatusFilter")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = newJString("approved"))
  if valid_589162 != nil:
    section.add "dealsStatusFilter", valid_589162
  var valid_589163 = query.getOrDefault("prettyPrint")
  valid_589163 = validateParameter(valid_589163, JBool, required = false,
                                 default = newJBool(true))
  if valid_589163 != nil:
    section.add "prettyPrint", valid_589163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589164: Call_AdexchangebuyerCreativesList_589148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_589164.validator(path, query, header, formData, body)
  let scheme = call_589164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589164.url(scheme.get, call_589164.host, call_589164.base,
                         call_589164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589164, url, valid)

proc call*(call_589165: Call_AdexchangebuyerCreativesList_589148;
          buyerCreativeId: JsonNode = nil; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          accountId: JsonNode = nil; userIp: string = ""; maxResults: int = 0;
          openAuctionStatusFilter: string = "approved"; key: string = "";
          dealsStatusFilter: string = "approved"; prettyPrint: bool = true): Recallable =
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
  ##   openAuctionStatusFilter: string
  ##                          : When specified, only creatives having the given open auction status are returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   dealsStatusFilter: string
  ##                    : When specified, only creatives having the given deals status are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589166 = newJObject()
  if buyerCreativeId != nil:
    query_589166.add "buyerCreativeId", buyerCreativeId
  add(query_589166, "fields", newJString(fields))
  add(query_589166, "pageToken", newJString(pageToken))
  add(query_589166, "quotaUser", newJString(quotaUser))
  add(query_589166, "alt", newJString(alt))
  add(query_589166, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_589166.add "accountId", accountId
  add(query_589166, "userIp", newJString(userIp))
  add(query_589166, "maxResults", newJInt(maxResults))
  add(query_589166, "openAuctionStatusFilter", newJString(openAuctionStatusFilter))
  add(query_589166, "key", newJString(key))
  add(query_589166, "dealsStatusFilter", newJString(dealsStatusFilter))
  add(query_589166, "prettyPrint", newJBool(prettyPrint))
  result = call_589165.call(nil, query_589166, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_589148(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_589149,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesList_589150,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_589182 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerCreativesGet_589184(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesGet_589183(path: JsonNode; query: JsonNode;
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
  var valid_589185 = path.getOrDefault("accountId")
  valid_589185 = validateParameter(valid_589185, JInt, required = true, default = nil)
  if valid_589185 != nil:
    section.add "accountId", valid_589185
  var valid_589186 = path.getOrDefault("buyerCreativeId")
  valid_589186 = validateParameter(valid_589186, JString, required = true,
                                 default = nil)
  if valid_589186 != nil:
    section.add "buyerCreativeId", valid_589186
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
  var valid_589187 = query.getOrDefault("fields")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "fields", valid_589187
  var valid_589188 = query.getOrDefault("quotaUser")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "quotaUser", valid_589188
  var valid_589189 = query.getOrDefault("alt")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = newJString("json"))
  if valid_589189 != nil:
    section.add "alt", valid_589189
  var valid_589190 = query.getOrDefault("oauth_token")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "oauth_token", valid_589190
  var valid_589191 = query.getOrDefault("userIp")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "userIp", valid_589191
  var valid_589192 = query.getOrDefault("key")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "key", valid_589192
  var valid_589193 = query.getOrDefault("prettyPrint")
  valid_589193 = validateParameter(valid_589193, JBool, required = false,
                                 default = newJBool(true))
  if valid_589193 != nil:
    section.add "prettyPrint", valid_589193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589194: Call_AdexchangebuyerCreativesGet_589182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_589194.validator(path, query, header, formData, body)
  let scheme = call_589194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589194.url(scheme.get, call_589194.host, call_589194.base,
                         call_589194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589194, url, valid)

proc call*(call_589195: Call_AdexchangebuyerCreativesGet_589182; accountId: int;
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
  var path_589196 = newJObject()
  var query_589197 = newJObject()
  add(query_589197, "fields", newJString(fields))
  add(query_589197, "quotaUser", newJString(quotaUser))
  add(query_589197, "alt", newJString(alt))
  add(query_589197, "oauth_token", newJString(oauthToken))
  add(path_589196, "accountId", newJInt(accountId))
  add(query_589197, "userIp", newJString(userIp))
  add(path_589196, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_589197, "key", newJString(key))
  add(query_589197, "prettyPrint", newJBool(prettyPrint))
  result = call_589195.call(path_589196, query_589197, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_589182(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_589183,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesGet_589184,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesAddDeal_589198 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerCreativesAddDeal_589200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "buyerCreativeId" in path, "`buyerCreativeId` is a required path parameter"
  assert "dealId" in path, "`dealId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "buyerCreativeId"),
               (kind: ConstantSegment, value: "/addDeal/"),
               (kind: VariableSegment, value: "dealId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerCreativesAddDeal_589199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a deal id association for the creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JInt (required)
  ##            : The id for the account that will serve this creative.
  ##   buyerCreativeId: JString (required)
  ##                  : The buyer-specific id for this creative.
  ##   dealId: JString (required)
  ##         : The id of the deal id to associate with this creative.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589201 = path.getOrDefault("accountId")
  valid_589201 = validateParameter(valid_589201, JInt, required = true, default = nil)
  if valid_589201 != nil:
    section.add "accountId", valid_589201
  var valid_589202 = path.getOrDefault("buyerCreativeId")
  valid_589202 = validateParameter(valid_589202, JString, required = true,
                                 default = nil)
  if valid_589202 != nil:
    section.add "buyerCreativeId", valid_589202
  var valid_589203 = path.getOrDefault("dealId")
  valid_589203 = validateParameter(valid_589203, JString, required = true,
                                 default = nil)
  if valid_589203 != nil:
    section.add "dealId", valid_589203
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
  var valid_589204 = query.getOrDefault("fields")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "fields", valid_589204
  var valid_589205 = query.getOrDefault("quotaUser")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "quotaUser", valid_589205
  var valid_589206 = query.getOrDefault("alt")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("json"))
  if valid_589206 != nil:
    section.add "alt", valid_589206
  var valid_589207 = query.getOrDefault("oauth_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "oauth_token", valid_589207
  var valid_589208 = query.getOrDefault("userIp")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "userIp", valid_589208
  var valid_589209 = query.getOrDefault("key")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "key", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589211: Call_AdexchangebuyerCreativesAddDeal_589198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a deal id association for the creative.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_AdexchangebuyerCreativesAddDeal_589198;
          accountId: int; buyerCreativeId: string; dealId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerCreativesAddDeal
  ## Add a deal id association for the creative.
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
  ##   dealId: string (required)
  ##         : The id of the deal id to associate with this creative.
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(path_589213, "accountId", newJInt(accountId))
  add(query_589214, "userIp", newJString(userIp))
  add(path_589213, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_589214, "key", newJString(key))
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  add(path_589213, "dealId", newJString(dealId))
  result = call_589212.call(path_589213, query_589214, nil, nil, nil)

var adexchangebuyerCreativesAddDeal* = Call_AdexchangebuyerCreativesAddDeal_589198(
    name: "adexchangebuyerCreativesAddDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/addDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesAddDeal_589199,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesAddDeal_589200,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesListDeals_589215 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerCreativesListDeals_589217(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "buyerCreativeId"),
               (kind: ConstantSegment, value: "/listDeals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerCreativesListDeals_589216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the external deal ids associated with the creative.
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
  var valid_589218 = path.getOrDefault("accountId")
  valid_589218 = validateParameter(valid_589218, JInt, required = true, default = nil)
  if valid_589218 != nil:
    section.add "accountId", valid_589218
  var valid_589219 = path.getOrDefault("buyerCreativeId")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "buyerCreativeId", valid_589219
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
  var valid_589220 = query.getOrDefault("fields")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "fields", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("alt")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("json"))
  if valid_589222 != nil:
    section.add "alt", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("userIp")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "userIp", valid_589224
  var valid_589225 = query.getOrDefault("key")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "key", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589227: Call_AdexchangebuyerCreativesListDeals_589215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the external deal ids associated with the creative.
  ## 
  let valid = call_589227.validator(path, query, header, formData, body)
  let scheme = call_589227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589227.url(scheme.get, call_589227.host, call_589227.base,
                         call_589227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589227, url, valid)

proc call*(call_589228: Call_AdexchangebuyerCreativesListDeals_589215;
          accountId: int; buyerCreativeId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerCreativesListDeals
  ## Lists the external deal ids associated with the creative.
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
  var path_589229 = newJObject()
  var query_589230 = newJObject()
  add(query_589230, "fields", newJString(fields))
  add(query_589230, "quotaUser", newJString(quotaUser))
  add(query_589230, "alt", newJString(alt))
  add(query_589230, "oauth_token", newJString(oauthToken))
  add(path_589229, "accountId", newJInt(accountId))
  add(query_589230, "userIp", newJString(userIp))
  add(path_589229, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_589230, "key", newJString(key))
  add(query_589230, "prettyPrint", newJBool(prettyPrint))
  result = call_589228.call(path_589229, query_589230, nil, nil, nil)

var adexchangebuyerCreativesListDeals* = Call_AdexchangebuyerCreativesListDeals_589215(
    name: "adexchangebuyerCreativesListDeals", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/listDeals",
    validator: validate_AdexchangebuyerCreativesListDeals_589216,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesListDeals_589217,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesRemoveDeal_589231 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerCreativesRemoveDeal_589233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "buyerCreativeId" in path, "`buyerCreativeId` is a required path parameter"
  assert "dealId" in path, "`dealId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "buyerCreativeId"),
               (kind: ConstantSegment, value: "/removeDeal/"),
               (kind: VariableSegment, value: "dealId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerCreativesRemoveDeal_589232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove a deal id associated with the creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JInt (required)
  ##            : The id for the account that will serve this creative.
  ##   buyerCreativeId: JString (required)
  ##                  : The buyer-specific id for this creative.
  ##   dealId: JString (required)
  ##         : The id of the deal id to disassociate with this creative.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589234 = path.getOrDefault("accountId")
  valid_589234 = validateParameter(valid_589234, JInt, required = true, default = nil)
  if valid_589234 != nil:
    section.add "accountId", valid_589234
  var valid_589235 = path.getOrDefault("buyerCreativeId")
  valid_589235 = validateParameter(valid_589235, JString, required = true,
                                 default = nil)
  if valid_589235 != nil:
    section.add "buyerCreativeId", valid_589235
  var valid_589236 = path.getOrDefault("dealId")
  valid_589236 = validateParameter(valid_589236, JString, required = true,
                                 default = nil)
  if valid_589236 != nil:
    section.add "dealId", valid_589236
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
  var valid_589237 = query.getOrDefault("fields")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "fields", valid_589237
  var valid_589238 = query.getOrDefault("quotaUser")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "quotaUser", valid_589238
  var valid_589239 = query.getOrDefault("alt")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("json"))
  if valid_589239 != nil:
    section.add "alt", valid_589239
  var valid_589240 = query.getOrDefault("oauth_token")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "oauth_token", valid_589240
  var valid_589241 = query.getOrDefault("userIp")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "userIp", valid_589241
  var valid_589242 = query.getOrDefault("key")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "key", valid_589242
  var valid_589243 = query.getOrDefault("prettyPrint")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "prettyPrint", valid_589243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589244: Call_AdexchangebuyerCreativesRemoveDeal_589231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove a deal id associated with the creative.
  ## 
  let valid = call_589244.validator(path, query, header, formData, body)
  let scheme = call_589244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589244.url(scheme.get, call_589244.host, call_589244.base,
                         call_589244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589244, url, valid)

proc call*(call_589245: Call_AdexchangebuyerCreativesRemoveDeal_589231;
          accountId: int; buyerCreativeId: string; dealId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerCreativesRemoveDeal
  ## Remove a deal id associated with the creative.
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
  ##   dealId: string (required)
  ##         : The id of the deal id to disassociate with this creative.
  var path_589246 = newJObject()
  var query_589247 = newJObject()
  add(query_589247, "fields", newJString(fields))
  add(query_589247, "quotaUser", newJString(quotaUser))
  add(query_589247, "alt", newJString(alt))
  add(query_589247, "oauth_token", newJString(oauthToken))
  add(path_589246, "accountId", newJInt(accountId))
  add(query_589247, "userIp", newJString(userIp))
  add(path_589246, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_589247, "key", newJString(key))
  add(query_589247, "prettyPrint", newJBool(prettyPrint))
  add(path_589246, "dealId", newJString(dealId))
  result = call_589245.call(path_589246, query_589247, nil, nil, nil)

var adexchangebuyerCreativesRemoveDeal* = Call_AdexchangebuyerCreativesRemoveDeal_589231(
    name: "adexchangebuyerCreativesRemoveDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/removeDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesRemoveDeal_589232,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesRemoveDeal_589233,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPerformanceReportList_589248 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPerformanceReportList_589250(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerPerformanceReportList_589249(path: JsonNode;
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
  var valid_589251 = query.getOrDefault("fields")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "fields", valid_589251
  var valid_589252 = query.getOrDefault("pageToken")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "pageToken", valid_589252
  var valid_589253 = query.getOrDefault("quotaUser")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "quotaUser", valid_589253
  var valid_589254 = query.getOrDefault("alt")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = newJString("json"))
  if valid_589254 != nil:
    section.add "alt", valid_589254
  assert query != nil,
        "query argument is necessary due to required `startDateTime` field"
  var valid_589255 = query.getOrDefault("startDateTime")
  valid_589255 = validateParameter(valid_589255, JString, required = true,
                                 default = nil)
  if valid_589255 != nil:
    section.add "startDateTime", valid_589255
  var valid_589256 = query.getOrDefault("oauth_token")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "oauth_token", valid_589256
  var valid_589257 = query.getOrDefault("accountId")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "accountId", valid_589257
  var valid_589258 = query.getOrDefault("userIp")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "userIp", valid_589258
  var valid_589259 = query.getOrDefault("maxResults")
  valid_589259 = validateParameter(valid_589259, JInt, required = false, default = nil)
  if valid_589259 != nil:
    section.add "maxResults", valid_589259
  var valid_589260 = query.getOrDefault("key")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "key", valid_589260
  var valid_589261 = query.getOrDefault("endDateTime")
  valid_589261 = validateParameter(valid_589261, JString, required = true,
                                 default = nil)
  if valid_589261 != nil:
    section.add "endDateTime", valid_589261
  var valid_589262 = query.getOrDefault("prettyPrint")
  valid_589262 = validateParameter(valid_589262, JBool, required = false,
                                 default = newJBool(true))
  if valid_589262 != nil:
    section.add "prettyPrint", valid_589262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589263: Call_AdexchangebuyerPerformanceReportList_589248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  let valid = call_589263.validator(path, query, header, formData, body)
  let scheme = call_589263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589263.url(scheme.get, call_589263.host, call_589263.base,
                         call_589263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589263, url, valid)

proc call*(call_589264: Call_AdexchangebuyerPerformanceReportList_589248;
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
  var query_589265 = newJObject()
  add(query_589265, "fields", newJString(fields))
  add(query_589265, "pageToken", newJString(pageToken))
  add(query_589265, "quotaUser", newJString(quotaUser))
  add(query_589265, "alt", newJString(alt))
  add(query_589265, "startDateTime", newJString(startDateTime))
  add(query_589265, "oauth_token", newJString(oauthToken))
  add(query_589265, "accountId", newJString(accountId))
  add(query_589265, "userIp", newJString(userIp))
  add(query_589265, "maxResults", newJInt(maxResults))
  add(query_589265, "key", newJString(key))
  add(query_589265, "endDateTime", newJString(endDateTime))
  add(query_589265, "prettyPrint", newJBool(prettyPrint))
  result = call_589264.call(nil, query_589265, nil, nil, nil)

var adexchangebuyerPerformanceReportList* = Call_AdexchangebuyerPerformanceReportList_589248(
    name: "adexchangebuyerPerformanceReportList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/performancereport",
    validator: validate_AdexchangebuyerPerformanceReportList_589249,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPerformanceReportList_589250,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigInsert_589281 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPretargetingConfigInsert_589283(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigInsert_589282(path: JsonNode;
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
  var valid_589284 = path.getOrDefault("accountId")
  valid_589284 = validateParameter(valid_589284, JString, required = true,
                                 default = nil)
  if valid_589284 != nil:
    section.add "accountId", valid_589284
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

proc call*(call_589293: Call_AdexchangebuyerPretargetingConfigInsert_589281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new pretargeting configuration.
  ## 
  let valid = call_589293.validator(path, query, header, formData, body)
  let scheme = call_589293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589293.url(scheme.get, call_589293.host, call_589293.base,
                         call_589293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589293, url, valid)

proc call*(call_589294: Call_AdexchangebuyerPretargetingConfigInsert_589281;
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
  if body != nil:
    body_589297 = body
  add(query_589296, "prettyPrint", newJBool(prettyPrint))
  result = call_589294.call(path_589295, query_589296, nil, nil, body_589297)

var adexchangebuyerPretargetingConfigInsert* = Call_AdexchangebuyerPretargetingConfigInsert_589281(
    name: "adexchangebuyerPretargetingConfigInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigInsert_589282,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigInsert_589283,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigList_589266 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPretargetingConfigList_589268(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigList_589267(path: JsonNode;
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
  var valid_589269 = path.getOrDefault("accountId")
  valid_589269 = validateParameter(valid_589269, JString, required = true,
                                 default = nil)
  if valid_589269 != nil:
    section.add "accountId", valid_589269
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
  var valid_589270 = query.getOrDefault("fields")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "fields", valid_589270
  var valid_589271 = query.getOrDefault("quotaUser")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "quotaUser", valid_589271
  var valid_589272 = query.getOrDefault("alt")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = newJString("json"))
  if valid_589272 != nil:
    section.add "alt", valid_589272
  var valid_589273 = query.getOrDefault("oauth_token")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "oauth_token", valid_589273
  var valid_589274 = query.getOrDefault("userIp")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "userIp", valid_589274
  var valid_589275 = query.getOrDefault("key")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "key", valid_589275
  var valid_589276 = query.getOrDefault("prettyPrint")
  valid_589276 = validateParameter(valid_589276, JBool, required = false,
                                 default = newJBool(true))
  if valid_589276 != nil:
    section.add "prettyPrint", valid_589276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589277: Call_AdexchangebuyerPretargetingConfigList_589266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  let valid = call_589277.validator(path, query, header, formData, body)
  let scheme = call_589277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589277.url(scheme.get, call_589277.host, call_589277.base,
                         call_589277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589277, url, valid)

proc call*(call_589278: Call_AdexchangebuyerPretargetingConfigList_589266;
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
  var path_589279 = newJObject()
  var query_589280 = newJObject()
  add(query_589280, "fields", newJString(fields))
  add(query_589280, "quotaUser", newJString(quotaUser))
  add(query_589280, "alt", newJString(alt))
  add(query_589280, "oauth_token", newJString(oauthToken))
  add(path_589279, "accountId", newJString(accountId))
  add(query_589280, "userIp", newJString(userIp))
  add(query_589280, "key", newJString(key))
  add(query_589280, "prettyPrint", newJBool(prettyPrint))
  result = call_589278.call(path_589279, query_589280, nil, nil, nil)

var adexchangebuyerPretargetingConfigList* = Call_AdexchangebuyerPretargetingConfigList_589266(
    name: "adexchangebuyerPretargetingConfigList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigList_589267,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigList_589268,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigUpdate_589314 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPretargetingConfigUpdate_589316(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigUpdate_589315(path: JsonNode;
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

proc call*(call_589327: Call_AdexchangebuyerPretargetingConfigUpdate_589314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config.
  ## 
  let valid = call_589327.validator(path, query, header, formData, body)
  let scheme = call_589327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589327.url(scheme.get, call_589327.host, call_589327.base,
                         call_589327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589327, url, valid)

proc call*(call_589328: Call_AdexchangebuyerPretargetingConfigUpdate_589314;
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

var adexchangebuyerPretargetingConfigUpdate* = Call_AdexchangebuyerPretargetingConfigUpdate_589314(
    name: "adexchangebuyerPretargetingConfigUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigUpdate_589315,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigUpdate_589316,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigGet_589298 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPretargetingConfigGet_589300(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigGet_589299(path: JsonNode;
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

proc call*(call_589310: Call_AdexchangebuyerPretargetingConfigGet_589298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific pretargeting configuration
  ## 
  let valid = call_589310.validator(path, query, header, formData, body)
  let scheme = call_589310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589310.url(scheme.get, call_589310.host, call_589310.base,
                         call_589310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589310, url, valid)

proc call*(call_589311: Call_AdexchangebuyerPretargetingConfigGet_589298;
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

var adexchangebuyerPretargetingConfigGet* = Call_AdexchangebuyerPretargetingConfigGet_589298(
    name: "adexchangebuyerPretargetingConfigGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigGet_589299,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigGet_589300,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigPatch_589348 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPretargetingConfigPatch_589350(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigPatch_589349(path: JsonNode;
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
  var valid_589351 = path.getOrDefault("accountId")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "accountId", valid_589351
  var valid_589352 = path.getOrDefault("configId")
  valid_589352 = validateParameter(valid_589352, JString, required = true,
                                 default = nil)
  if valid_589352 != nil:
    section.add "configId", valid_589352
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
  var valid_589353 = query.getOrDefault("fields")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "fields", valid_589353
  var valid_589354 = query.getOrDefault("quotaUser")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "quotaUser", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("oauth_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "oauth_token", valid_589356
  var valid_589357 = query.getOrDefault("userIp")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "userIp", valid_589357
  var valid_589358 = query.getOrDefault("key")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "key", valid_589358
  var valid_589359 = query.getOrDefault("prettyPrint")
  valid_589359 = validateParameter(valid_589359, JBool, required = false,
                                 default = newJBool(true))
  if valid_589359 != nil:
    section.add "prettyPrint", valid_589359
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

proc call*(call_589361: Call_AdexchangebuyerPretargetingConfigPatch_589348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  let valid = call_589361.validator(path, query, header, formData, body)
  let scheme = call_589361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589361.url(scheme.get, call_589361.host, call_589361.base,
                         call_589361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589361, url, valid)

proc call*(call_589362: Call_AdexchangebuyerPretargetingConfigPatch_589348;
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
  var path_589363 = newJObject()
  var query_589364 = newJObject()
  var body_589365 = newJObject()
  add(query_589364, "fields", newJString(fields))
  add(query_589364, "quotaUser", newJString(quotaUser))
  add(query_589364, "alt", newJString(alt))
  add(query_589364, "oauth_token", newJString(oauthToken))
  add(path_589363, "accountId", newJString(accountId))
  add(query_589364, "userIp", newJString(userIp))
  add(query_589364, "key", newJString(key))
  add(path_589363, "configId", newJString(configId))
  if body != nil:
    body_589365 = body
  add(query_589364, "prettyPrint", newJBool(prettyPrint))
  result = call_589362.call(path_589363, query_589364, nil, nil, body_589365)

var adexchangebuyerPretargetingConfigPatch* = Call_AdexchangebuyerPretargetingConfigPatch_589348(
    name: "adexchangebuyerPretargetingConfigPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigPatch_589349,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigPatch_589350,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigDelete_589332 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPretargetingConfigDelete_589334(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigDelete_589333(path: JsonNode;
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
  var valid_589335 = path.getOrDefault("accountId")
  valid_589335 = validateParameter(valid_589335, JString, required = true,
                                 default = nil)
  if valid_589335 != nil:
    section.add "accountId", valid_589335
  var valid_589336 = path.getOrDefault("configId")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "configId", valid_589336
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
  var valid_589337 = query.getOrDefault("fields")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "fields", valid_589337
  var valid_589338 = query.getOrDefault("quotaUser")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "quotaUser", valid_589338
  var valid_589339 = query.getOrDefault("alt")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = newJString("json"))
  if valid_589339 != nil:
    section.add "alt", valid_589339
  var valid_589340 = query.getOrDefault("oauth_token")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "oauth_token", valid_589340
  var valid_589341 = query.getOrDefault("userIp")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "userIp", valid_589341
  var valid_589342 = query.getOrDefault("key")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "key", valid_589342
  var valid_589343 = query.getOrDefault("prettyPrint")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(true))
  if valid_589343 != nil:
    section.add "prettyPrint", valid_589343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589344: Call_AdexchangebuyerPretargetingConfigDelete_589332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing pretargeting config.
  ## 
  let valid = call_589344.validator(path, query, header, formData, body)
  let scheme = call_589344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589344.url(scheme.get, call_589344.host, call_589344.base,
                         call_589344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589344, url, valid)

proc call*(call_589345: Call_AdexchangebuyerPretargetingConfigDelete_589332;
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
  var path_589346 = newJObject()
  var query_589347 = newJObject()
  add(query_589347, "fields", newJString(fields))
  add(query_589347, "quotaUser", newJString(quotaUser))
  add(query_589347, "alt", newJString(alt))
  add(query_589347, "oauth_token", newJString(oauthToken))
  add(path_589346, "accountId", newJString(accountId))
  add(query_589347, "userIp", newJString(userIp))
  add(query_589347, "key", newJString(key))
  add(path_589346, "configId", newJString(configId))
  add(query_589347, "prettyPrint", newJBool(prettyPrint))
  result = call_589345.call(path_589346, query_589347, nil, nil, nil)

var adexchangebuyerPretargetingConfigDelete* = Call_AdexchangebuyerPretargetingConfigDelete_589332(
    name: "adexchangebuyerPretargetingConfigDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigDelete_589333,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigDelete_589334,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589366 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589368(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "privateAuctionId" in path,
        "`privateAuctionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/privateauction/"),
               (kind: VariableSegment, value: "privateAuctionId"),
               (kind: ConstantSegment, value: "/updateproposal")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589367(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update a given private auction proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   privateAuctionId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `privateAuctionId` field"
  var valid_589369 = path.getOrDefault("privateAuctionId")
  valid_589369 = validateParameter(valid_589369, JString, required = true,
                                 default = nil)
  if valid_589369 != nil:
    section.add "privateAuctionId", valid_589369
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
  var valid_589370 = query.getOrDefault("fields")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "fields", valid_589370
  var valid_589371 = query.getOrDefault("quotaUser")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "quotaUser", valid_589371
  var valid_589372 = query.getOrDefault("alt")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = newJString("json"))
  if valid_589372 != nil:
    section.add "alt", valid_589372
  var valid_589373 = query.getOrDefault("oauth_token")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "oauth_token", valid_589373
  var valid_589374 = query.getOrDefault("userIp")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "userIp", valid_589374
  var valid_589375 = query.getOrDefault("key")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "key", valid_589375
  var valid_589376 = query.getOrDefault("prettyPrint")
  valid_589376 = validateParameter(valid_589376, JBool, required = false,
                                 default = newJBool(true))
  if valid_589376 != nil:
    section.add "prettyPrint", valid_589376
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

proc call*(call_589378: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a given private auction proposal
  ## 
  let valid = call_589378.validator(path, query, header, formData, body)
  let scheme = call_589378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589378.url(scheme.get, call_589378.host, call_589378.base,
                         call_589378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589378, url, valid)

proc call*(call_589379: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589366;
          privateAuctionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerMarketplaceprivateauctionUpdateproposal
  ## Update a given private auction proposal
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
  ##   privateAuctionId: string (required)
  var path_589380 = newJObject()
  var query_589381 = newJObject()
  var body_589382 = newJObject()
  add(query_589381, "fields", newJString(fields))
  add(query_589381, "quotaUser", newJString(quotaUser))
  add(query_589381, "alt", newJString(alt))
  add(query_589381, "oauth_token", newJString(oauthToken))
  add(query_589381, "userIp", newJString(userIp))
  add(query_589381, "key", newJString(key))
  if body != nil:
    body_589382 = body
  add(query_589381, "prettyPrint", newJBool(prettyPrint))
  add(path_589380, "privateAuctionId", newJString(privateAuctionId))
  result = call_589379.call(path_589380, query_589381, nil, nil, body_589382)

var adexchangebuyerMarketplaceprivateauctionUpdateproposal* = Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589366(
    name: "adexchangebuyerMarketplaceprivateauctionUpdateproposal",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/privateauction/{privateAuctionId}/updateproposal",
    validator: validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589367,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_589368,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsSearch_589383 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProductsSearch_589385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProductsSearch_589384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the requested product.
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
  ##   pqlQuery: JString
  ##           : The pql query used to query for products.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589386 = query.getOrDefault("fields")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "fields", valid_589386
  var valid_589387 = query.getOrDefault("quotaUser")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "quotaUser", valid_589387
  var valid_589388 = query.getOrDefault("alt")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = newJString("json"))
  if valid_589388 != nil:
    section.add "alt", valid_589388
  var valid_589389 = query.getOrDefault("pqlQuery")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "pqlQuery", valid_589389
  var valid_589390 = query.getOrDefault("oauth_token")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "oauth_token", valid_589390
  var valid_589391 = query.getOrDefault("userIp")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "userIp", valid_589391
  var valid_589392 = query.getOrDefault("key")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "key", valid_589392
  var valid_589393 = query.getOrDefault("prettyPrint")
  valid_589393 = validateParameter(valid_589393, JBool, required = false,
                                 default = newJBool(true))
  if valid_589393 != nil:
    section.add "prettyPrint", valid_589393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589394: Call_AdexchangebuyerProductsSearch_589383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product.
  ## 
  let valid = call_589394.validator(path, query, header, formData, body)
  let scheme = call_589394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589394.url(scheme.get, call_589394.host, call_589394.base,
                         call_589394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589394, url, valid)

proc call*(call_589395: Call_AdexchangebuyerProductsSearch_589383;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pqlQuery: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProductsSearch
  ## Gets the requested product.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   pqlQuery: string
  ##           : The pql query used to query for products.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589396 = newJObject()
  add(query_589396, "fields", newJString(fields))
  add(query_589396, "quotaUser", newJString(quotaUser))
  add(query_589396, "alt", newJString(alt))
  add(query_589396, "pqlQuery", newJString(pqlQuery))
  add(query_589396, "oauth_token", newJString(oauthToken))
  add(query_589396, "userIp", newJString(userIp))
  add(query_589396, "key", newJString(key))
  add(query_589396, "prettyPrint", newJBool(prettyPrint))
  result = call_589395.call(nil, query_589396, nil, nil, nil)

var adexchangebuyerProductsSearch* = Call_AdexchangebuyerProductsSearch_589383(
    name: "adexchangebuyerProductsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/search",
    validator: validate_AdexchangebuyerProductsSearch_589384,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsSearch_589385,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsGet_589397 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProductsGet_589399(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerProductsGet_589398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the requested product by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productId: JString (required)
  ##            : The id for the product to get the head revision for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `productId` field"
  var valid_589400 = path.getOrDefault("productId")
  valid_589400 = validateParameter(valid_589400, JString, required = true,
                                 default = nil)
  if valid_589400 != nil:
    section.add "productId", valid_589400
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
  var valid_589401 = query.getOrDefault("fields")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "fields", valid_589401
  var valid_589402 = query.getOrDefault("quotaUser")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "quotaUser", valid_589402
  var valid_589403 = query.getOrDefault("alt")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = newJString("json"))
  if valid_589403 != nil:
    section.add "alt", valid_589403
  var valid_589404 = query.getOrDefault("oauth_token")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "oauth_token", valid_589404
  var valid_589405 = query.getOrDefault("userIp")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "userIp", valid_589405
  var valid_589406 = query.getOrDefault("key")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "key", valid_589406
  var valid_589407 = query.getOrDefault("prettyPrint")
  valid_589407 = validateParameter(valid_589407, JBool, required = false,
                                 default = newJBool(true))
  if valid_589407 != nil:
    section.add "prettyPrint", valid_589407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589408: Call_AdexchangebuyerProductsGet_589397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product by id.
  ## 
  let valid = call_589408.validator(path, query, header, formData, body)
  let scheme = call_589408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589408.url(scheme.get, call_589408.host, call_589408.base,
                         call_589408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589408, url, valid)

proc call*(call_589409: Call_AdexchangebuyerProductsGet_589397; productId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProductsGet
  ## Gets the requested product by id.
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
  ##   productId: string (required)
  ##            : The id for the product to get the head revision for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589410 = newJObject()
  var query_589411 = newJObject()
  add(query_589411, "fields", newJString(fields))
  add(query_589411, "quotaUser", newJString(quotaUser))
  add(query_589411, "alt", newJString(alt))
  add(query_589411, "oauth_token", newJString(oauthToken))
  add(query_589411, "userIp", newJString(userIp))
  add(query_589411, "key", newJString(key))
  add(path_589410, "productId", newJString(productId))
  add(query_589411, "prettyPrint", newJBool(prettyPrint))
  result = call_589409.call(path_589410, query_589411, nil, nil, nil)

var adexchangebuyerProductsGet* = Call_AdexchangebuyerProductsGet_589397(
    name: "adexchangebuyerProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/{productId}",
    validator: validate_AdexchangebuyerProductsGet_589398,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsGet_589399,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsInsert_589412 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProposalsInsert_589414(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsInsert_589413(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create the given list of proposals
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
  var valid_589415 = query.getOrDefault("fields")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "fields", valid_589415
  var valid_589416 = query.getOrDefault("quotaUser")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "quotaUser", valid_589416
  var valid_589417 = query.getOrDefault("alt")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("json"))
  if valid_589417 != nil:
    section.add "alt", valid_589417
  var valid_589418 = query.getOrDefault("oauth_token")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "oauth_token", valid_589418
  var valid_589419 = query.getOrDefault("userIp")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "userIp", valid_589419
  var valid_589420 = query.getOrDefault("key")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "key", valid_589420
  var valid_589421 = query.getOrDefault("prettyPrint")
  valid_589421 = validateParameter(valid_589421, JBool, required = false,
                                 default = newJBool(true))
  if valid_589421 != nil:
    section.add "prettyPrint", valid_589421
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

proc call*(call_589423: Call_AdexchangebuyerProposalsInsert_589412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the given list of proposals
  ## 
  let valid = call_589423.validator(path, query, header, formData, body)
  let scheme = call_589423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589423.url(scheme.get, call_589423.host, call_589423.base,
                         call_589423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589423, url, valid)

proc call*(call_589424: Call_AdexchangebuyerProposalsInsert_589412;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProposalsInsert
  ## Create the given list of proposals
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
  var query_589425 = newJObject()
  var body_589426 = newJObject()
  add(query_589425, "fields", newJString(fields))
  add(query_589425, "quotaUser", newJString(quotaUser))
  add(query_589425, "alt", newJString(alt))
  add(query_589425, "oauth_token", newJString(oauthToken))
  add(query_589425, "userIp", newJString(userIp))
  add(query_589425, "key", newJString(key))
  if body != nil:
    body_589426 = body
  add(query_589425, "prettyPrint", newJBool(prettyPrint))
  result = call_589424.call(nil, query_589425, nil, nil, body_589426)

var adexchangebuyerProposalsInsert* = Call_AdexchangebuyerProposalsInsert_589412(
    name: "adexchangebuyerProposalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/insert",
    validator: validate_AdexchangebuyerProposalsInsert_589413,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsInsert_589414,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSearch_589427 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProposalsSearch_589429(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsSearch_589428(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search for proposals using pql query
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
  ##   pqlQuery: JString
  ##           : Query string to retrieve specific proposals.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589430 = query.getOrDefault("fields")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "fields", valid_589430
  var valid_589431 = query.getOrDefault("quotaUser")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "quotaUser", valid_589431
  var valid_589432 = query.getOrDefault("alt")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = newJString("json"))
  if valid_589432 != nil:
    section.add "alt", valid_589432
  var valid_589433 = query.getOrDefault("pqlQuery")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "pqlQuery", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("userIp")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "userIp", valid_589435
  var valid_589436 = query.getOrDefault("key")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "key", valid_589436
  var valid_589437 = query.getOrDefault("prettyPrint")
  valid_589437 = validateParameter(valid_589437, JBool, required = false,
                                 default = newJBool(true))
  if valid_589437 != nil:
    section.add "prettyPrint", valid_589437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589438: Call_AdexchangebuyerProposalsSearch_589427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for proposals using pql query
  ## 
  let valid = call_589438.validator(path, query, header, formData, body)
  let scheme = call_589438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589438.url(scheme.get, call_589438.host, call_589438.base,
                         call_589438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589438, url, valid)

proc call*(call_589439: Call_AdexchangebuyerProposalsSearch_589427;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pqlQuery: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProposalsSearch
  ## Search for proposals using pql query
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   pqlQuery: string
  ##           : Query string to retrieve specific proposals.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589440 = newJObject()
  add(query_589440, "fields", newJString(fields))
  add(query_589440, "quotaUser", newJString(quotaUser))
  add(query_589440, "alt", newJString(alt))
  add(query_589440, "pqlQuery", newJString(pqlQuery))
  add(query_589440, "oauth_token", newJString(oauthToken))
  add(query_589440, "userIp", newJString(userIp))
  add(query_589440, "key", newJString(key))
  add(query_589440, "prettyPrint", newJBool(prettyPrint))
  result = call_589439.call(nil, query_589440, nil, nil, nil)

var adexchangebuyerProposalsSearch* = Call_AdexchangebuyerProposalsSearch_589427(
    name: "adexchangebuyerProposalsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/search",
    validator: validate_AdexchangebuyerProposalsSearch_589428,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSearch_589429,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsGet_589441 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProposalsGet_589443(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerProposalsGet_589442(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a proposal given its id
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : Id of the proposal to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589444 = path.getOrDefault("proposalId")
  valid_589444 = validateParameter(valid_589444, JString, required = true,
                                 default = nil)
  if valid_589444 != nil:
    section.add "proposalId", valid_589444
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
  var valid_589445 = query.getOrDefault("fields")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "fields", valid_589445
  var valid_589446 = query.getOrDefault("quotaUser")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "quotaUser", valid_589446
  var valid_589447 = query.getOrDefault("alt")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = newJString("json"))
  if valid_589447 != nil:
    section.add "alt", valid_589447
  var valid_589448 = query.getOrDefault("oauth_token")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "oauth_token", valid_589448
  var valid_589449 = query.getOrDefault("userIp")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "userIp", valid_589449
  var valid_589450 = query.getOrDefault("key")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "key", valid_589450
  var valid_589451 = query.getOrDefault("prettyPrint")
  valid_589451 = validateParameter(valid_589451, JBool, required = false,
                                 default = newJBool(true))
  if valid_589451 != nil:
    section.add "prettyPrint", valid_589451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589452: Call_AdexchangebuyerProposalsGet_589441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a proposal given its id
  ## 
  let valid = call_589452.validator(path, query, header, formData, body)
  let scheme = call_589452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589452.url(scheme.get, call_589452.host, call_589452.base,
                         call_589452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589452, url, valid)

proc call*(call_589453: Call_AdexchangebuyerProposalsGet_589441;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProposalsGet
  ## Get a proposal given its id
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : Id of the proposal to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589454 = newJObject()
  var query_589455 = newJObject()
  add(query_589455, "fields", newJString(fields))
  add(query_589455, "quotaUser", newJString(quotaUser))
  add(query_589455, "alt", newJString(alt))
  add(path_589454, "proposalId", newJString(proposalId))
  add(query_589455, "oauth_token", newJString(oauthToken))
  add(query_589455, "userIp", newJString(userIp))
  add(query_589455, "key", newJString(key))
  add(query_589455, "prettyPrint", newJBool(prettyPrint))
  result = call_589453.call(path_589454, query_589455, nil, nil, nil)

var adexchangebuyerProposalsGet* = Call_AdexchangebuyerProposalsGet_589441(
    name: "adexchangebuyerProposalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}",
    validator: validate_AdexchangebuyerProposalsGet_589442,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsGet_589443,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsList_589456 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerMarketplacedealsList_589458(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/deals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerMarketplacedealsList_589457(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the deals for a given proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposalId to get deals for. To search across all proposals specify order_id = '-' as part of the URL.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589459 = path.getOrDefault("proposalId")
  valid_589459 = validateParameter(valid_589459, JString, required = true,
                                 default = nil)
  if valid_589459 != nil:
    section.add "proposalId", valid_589459
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   pqlQuery: JString
  ##           : Query string to retrieve specific deals.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589460 = query.getOrDefault("fields")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "fields", valid_589460
  var valid_589461 = query.getOrDefault("quotaUser")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "quotaUser", valid_589461
  var valid_589462 = query.getOrDefault("alt")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = newJString("json"))
  if valid_589462 != nil:
    section.add "alt", valid_589462
  var valid_589463 = query.getOrDefault("pqlQuery")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "pqlQuery", valid_589463
  var valid_589464 = query.getOrDefault("oauth_token")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "oauth_token", valid_589464
  var valid_589465 = query.getOrDefault("userIp")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "userIp", valid_589465
  var valid_589466 = query.getOrDefault("key")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "key", valid_589466
  var valid_589467 = query.getOrDefault("prettyPrint")
  valid_589467 = validateParameter(valid_589467, JBool, required = false,
                                 default = newJBool(true))
  if valid_589467 != nil:
    section.add "prettyPrint", valid_589467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589468: Call_AdexchangebuyerMarketplacedealsList_589456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the deals for a given proposal
  ## 
  let valid = call_589468.validator(path, query, header, formData, body)
  let scheme = call_589468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589468.url(scheme.get, call_589468.host, call_589468.base,
                         call_589468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589468, url, valid)

proc call*(call_589469: Call_AdexchangebuyerMarketplacedealsList_589456;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pqlQuery: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerMarketplacedealsList
  ## List all the deals for a given proposal
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   pqlQuery: string
  ##           : Query string to retrieve specific deals.
  ##   proposalId: string (required)
  ##             : The proposalId to get deals for. To search across all proposals specify order_id = '-' as part of the URL.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589470 = newJObject()
  var query_589471 = newJObject()
  add(query_589471, "fields", newJString(fields))
  add(query_589471, "quotaUser", newJString(quotaUser))
  add(query_589471, "alt", newJString(alt))
  add(query_589471, "pqlQuery", newJString(pqlQuery))
  add(path_589470, "proposalId", newJString(proposalId))
  add(query_589471, "oauth_token", newJString(oauthToken))
  add(query_589471, "userIp", newJString(userIp))
  add(query_589471, "key", newJString(key))
  add(query_589471, "prettyPrint", newJBool(prettyPrint))
  result = call_589469.call(path_589470, query_589471, nil, nil, nil)

var adexchangebuyerMarketplacedealsList* = Call_AdexchangebuyerMarketplacedealsList_589456(
    name: "adexchangebuyerMarketplacedealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals",
    validator: validate_AdexchangebuyerMarketplacedealsList_589457,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsList_589458,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsDelete_589472 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerMarketplacedealsDelete_589474(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/deals/delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerMarketplacedealsDelete_589473(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified deals from the proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposalId to delete deals from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589475 = path.getOrDefault("proposalId")
  valid_589475 = validateParameter(valid_589475, JString, required = true,
                                 default = nil)
  if valid_589475 != nil:
    section.add "proposalId", valid_589475
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
  var valid_589476 = query.getOrDefault("fields")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "fields", valid_589476
  var valid_589477 = query.getOrDefault("quotaUser")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "quotaUser", valid_589477
  var valid_589478 = query.getOrDefault("alt")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = newJString("json"))
  if valid_589478 != nil:
    section.add "alt", valid_589478
  var valid_589479 = query.getOrDefault("oauth_token")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "oauth_token", valid_589479
  var valid_589480 = query.getOrDefault("userIp")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "userIp", valid_589480
  var valid_589481 = query.getOrDefault("key")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "key", valid_589481
  var valid_589482 = query.getOrDefault("prettyPrint")
  valid_589482 = validateParameter(valid_589482, JBool, required = false,
                                 default = newJBool(true))
  if valid_589482 != nil:
    section.add "prettyPrint", valid_589482
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

proc call*(call_589484: Call_AdexchangebuyerMarketplacedealsDelete_589472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified deals from the proposal
  ## 
  let valid = call_589484.validator(path, query, header, formData, body)
  let scheme = call_589484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589484.url(scheme.get, call_589484.host, call_589484.base,
                         call_589484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589484, url, valid)

proc call*(call_589485: Call_AdexchangebuyerMarketplacedealsDelete_589472;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerMarketplacedealsDelete
  ## Delete the specified deals from the proposal
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : The proposalId to delete deals from.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589486 = newJObject()
  var query_589487 = newJObject()
  var body_589488 = newJObject()
  add(query_589487, "fields", newJString(fields))
  add(query_589487, "quotaUser", newJString(quotaUser))
  add(query_589487, "alt", newJString(alt))
  add(path_589486, "proposalId", newJString(proposalId))
  add(query_589487, "oauth_token", newJString(oauthToken))
  add(query_589487, "userIp", newJString(userIp))
  add(query_589487, "key", newJString(key))
  if body != nil:
    body_589488 = body
  add(query_589487, "prettyPrint", newJBool(prettyPrint))
  result = call_589485.call(path_589486, query_589487, nil, nil, body_589488)

var adexchangebuyerMarketplacedealsDelete* = Call_AdexchangebuyerMarketplacedealsDelete_589472(
    name: "adexchangebuyerMarketplacedealsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/delete",
    validator: validate_AdexchangebuyerMarketplacedealsDelete_589473,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsDelete_589474,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsInsert_589489 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerMarketplacedealsInsert_589491(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/deals/insert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerMarketplacedealsInsert_589490(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add new deals for the specified proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : proposalId for which deals need to be added.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589492 = path.getOrDefault("proposalId")
  valid_589492 = validateParameter(valid_589492, JString, required = true,
                                 default = nil)
  if valid_589492 != nil:
    section.add "proposalId", valid_589492
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
  var valid_589493 = query.getOrDefault("fields")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "fields", valid_589493
  var valid_589494 = query.getOrDefault("quotaUser")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "quotaUser", valid_589494
  var valid_589495 = query.getOrDefault("alt")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = newJString("json"))
  if valid_589495 != nil:
    section.add "alt", valid_589495
  var valid_589496 = query.getOrDefault("oauth_token")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "oauth_token", valid_589496
  var valid_589497 = query.getOrDefault("userIp")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "userIp", valid_589497
  var valid_589498 = query.getOrDefault("key")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "key", valid_589498
  var valid_589499 = query.getOrDefault("prettyPrint")
  valid_589499 = validateParameter(valid_589499, JBool, required = false,
                                 default = newJBool(true))
  if valid_589499 != nil:
    section.add "prettyPrint", valid_589499
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

proc call*(call_589501: Call_AdexchangebuyerMarketplacedealsInsert_589489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add new deals for the specified proposal
  ## 
  let valid = call_589501.validator(path, query, header, formData, body)
  let scheme = call_589501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589501.url(scheme.get, call_589501.host, call_589501.base,
                         call_589501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589501, url, valid)

proc call*(call_589502: Call_AdexchangebuyerMarketplacedealsInsert_589489;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerMarketplacedealsInsert
  ## Add new deals for the specified proposal
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : proposalId for which deals need to be added.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589503 = newJObject()
  var query_589504 = newJObject()
  var body_589505 = newJObject()
  add(query_589504, "fields", newJString(fields))
  add(query_589504, "quotaUser", newJString(quotaUser))
  add(query_589504, "alt", newJString(alt))
  add(path_589503, "proposalId", newJString(proposalId))
  add(query_589504, "oauth_token", newJString(oauthToken))
  add(query_589504, "userIp", newJString(userIp))
  add(query_589504, "key", newJString(key))
  if body != nil:
    body_589505 = body
  add(query_589504, "prettyPrint", newJBool(prettyPrint))
  result = call_589502.call(path_589503, query_589504, nil, nil, body_589505)

var adexchangebuyerMarketplacedealsInsert* = Call_AdexchangebuyerMarketplacedealsInsert_589489(
    name: "adexchangebuyerMarketplacedealsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/insert",
    validator: validate_AdexchangebuyerMarketplacedealsInsert_589490,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsInsert_589491,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsUpdate_589506 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerMarketplacedealsUpdate_589508(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/deals/update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerMarketplacedealsUpdate_589507(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replaces all the deals in the proposal with the passed in deals
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposalId to edit deals on.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589509 = path.getOrDefault("proposalId")
  valid_589509 = validateParameter(valid_589509, JString, required = true,
                                 default = nil)
  if valid_589509 != nil:
    section.add "proposalId", valid_589509
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
  var valid_589510 = query.getOrDefault("fields")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "fields", valid_589510
  var valid_589511 = query.getOrDefault("quotaUser")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "quotaUser", valid_589511
  var valid_589512 = query.getOrDefault("alt")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = newJString("json"))
  if valid_589512 != nil:
    section.add "alt", valid_589512
  var valid_589513 = query.getOrDefault("oauth_token")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "oauth_token", valid_589513
  var valid_589514 = query.getOrDefault("userIp")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "userIp", valid_589514
  var valid_589515 = query.getOrDefault("key")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "key", valid_589515
  var valid_589516 = query.getOrDefault("prettyPrint")
  valid_589516 = validateParameter(valid_589516, JBool, required = false,
                                 default = newJBool(true))
  if valid_589516 != nil:
    section.add "prettyPrint", valid_589516
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

proc call*(call_589518: Call_AdexchangebuyerMarketplacedealsUpdate_589506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces all the deals in the proposal with the passed in deals
  ## 
  let valid = call_589518.validator(path, query, header, formData, body)
  let scheme = call_589518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589518.url(scheme.get, call_589518.host, call_589518.base,
                         call_589518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589518, url, valid)

proc call*(call_589519: Call_AdexchangebuyerMarketplacedealsUpdate_589506;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerMarketplacedealsUpdate
  ## Replaces all the deals in the proposal with the passed in deals
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : The proposalId to edit deals on.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589520 = newJObject()
  var query_589521 = newJObject()
  var body_589522 = newJObject()
  add(query_589521, "fields", newJString(fields))
  add(query_589521, "quotaUser", newJString(quotaUser))
  add(query_589521, "alt", newJString(alt))
  add(path_589520, "proposalId", newJString(proposalId))
  add(query_589521, "oauth_token", newJString(oauthToken))
  add(query_589521, "userIp", newJString(userIp))
  add(query_589521, "key", newJString(key))
  if body != nil:
    body_589522 = body
  add(query_589521, "prettyPrint", newJBool(prettyPrint))
  result = call_589519.call(path_589520, query_589521, nil, nil, body_589522)

var adexchangebuyerMarketplacedealsUpdate* = Call_AdexchangebuyerMarketplacedealsUpdate_589506(
    name: "adexchangebuyerMarketplacedealsUpdate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/update",
    validator: validate_AdexchangebuyerMarketplacedealsUpdate_589507,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsUpdate_589508,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesList_589523 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerMarketplacenotesList_589525(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerMarketplacenotesList_589524(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the notes associated with a proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposalId to get notes for. To search across all proposals specify order_id = '-' as part of the URL.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589526 = path.getOrDefault("proposalId")
  valid_589526 = validateParameter(valid_589526, JString, required = true,
                                 default = nil)
  if valid_589526 != nil:
    section.add "proposalId", valid_589526
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   pqlQuery: JString
  ##           : Query string to retrieve specific notes. To search the text contents of notes, please use syntax like "WHERE note.note = "foo" or "WHERE note.note LIKE "%bar%"
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589527 = query.getOrDefault("fields")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "fields", valid_589527
  var valid_589528 = query.getOrDefault("quotaUser")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "quotaUser", valid_589528
  var valid_589529 = query.getOrDefault("alt")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = newJString("json"))
  if valid_589529 != nil:
    section.add "alt", valid_589529
  var valid_589530 = query.getOrDefault("pqlQuery")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "pqlQuery", valid_589530
  var valid_589531 = query.getOrDefault("oauth_token")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "oauth_token", valid_589531
  var valid_589532 = query.getOrDefault("userIp")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "userIp", valid_589532
  var valid_589533 = query.getOrDefault("key")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "key", valid_589533
  var valid_589534 = query.getOrDefault("prettyPrint")
  valid_589534 = validateParameter(valid_589534, JBool, required = false,
                                 default = newJBool(true))
  if valid_589534 != nil:
    section.add "prettyPrint", valid_589534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589535: Call_AdexchangebuyerMarketplacenotesList_589523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the notes associated with a proposal
  ## 
  let valid = call_589535.validator(path, query, header, formData, body)
  let scheme = call_589535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589535.url(scheme.get, call_589535.host, call_589535.base,
                         call_589535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589535, url, valid)

proc call*(call_589536: Call_AdexchangebuyerMarketplacenotesList_589523;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pqlQuery: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerMarketplacenotesList
  ## Get all the notes associated with a proposal
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   pqlQuery: string
  ##           : Query string to retrieve specific notes. To search the text contents of notes, please use syntax like "WHERE note.note = "foo" or "WHERE note.note LIKE "%bar%"
  ##   proposalId: string (required)
  ##             : The proposalId to get notes for. To search across all proposals specify order_id = '-' as part of the URL.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589537 = newJObject()
  var query_589538 = newJObject()
  add(query_589538, "fields", newJString(fields))
  add(query_589538, "quotaUser", newJString(quotaUser))
  add(query_589538, "alt", newJString(alt))
  add(query_589538, "pqlQuery", newJString(pqlQuery))
  add(path_589537, "proposalId", newJString(proposalId))
  add(query_589538, "oauth_token", newJString(oauthToken))
  add(query_589538, "userIp", newJString(userIp))
  add(query_589538, "key", newJString(key))
  add(query_589538, "prettyPrint", newJBool(prettyPrint))
  result = call_589536.call(path_589537, query_589538, nil, nil, nil)

var adexchangebuyerMarketplacenotesList* = Call_AdexchangebuyerMarketplacenotesList_589523(
    name: "adexchangebuyerMarketplacenotesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes",
    validator: validate_AdexchangebuyerMarketplacenotesList_589524,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesList_589525,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesInsert_589539 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerMarketplacenotesInsert_589541(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/notes/insert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerMarketplacenotesInsert_589540(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add notes to the proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposalId to add notes for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589542 = path.getOrDefault("proposalId")
  valid_589542 = validateParameter(valid_589542, JString, required = true,
                                 default = nil)
  if valid_589542 != nil:
    section.add "proposalId", valid_589542
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
  var valid_589543 = query.getOrDefault("fields")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "fields", valid_589543
  var valid_589544 = query.getOrDefault("quotaUser")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "quotaUser", valid_589544
  var valid_589545 = query.getOrDefault("alt")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = newJString("json"))
  if valid_589545 != nil:
    section.add "alt", valid_589545
  var valid_589546 = query.getOrDefault("oauth_token")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "oauth_token", valid_589546
  var valid_589547 = query.getOrDefault("userIp")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "userIp", valid_589547
  var valid_589548 = query.getOrDefault("key")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "key", valid_589548
  var valid_589549 = query.getOrDefault("prettyPrint")
  valid_589549 = validateParameter(valid_589549, JBool, required = false,
                                 default = newJBool(true))
  if valid_589549 != nil:
    section.add "prettyPrint", valid_589549
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

proc call*(call_589551: Call_AdexchangebuyerMarketplacenotesInsert_589539;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add notes to the proposal
  ## 
  let valid = call_589551.validator(path, query, header, formData, body)
  let scheme = call_589551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589551.url(scheme.get, call_589551.host, call_589551.base,
                         call_589551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589551, url, valid)

proc call*(call_589552: Call_AdexchangebuyerMarketplacenotesInsert_589539;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerMarketplacenotesInsert
  ## Add notes to the proposal
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : The proposalId to add notes for.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589553 = newJObject()
  var query_589554 = newJObject()
  var body_589555 = newJObject()
  add(query_589554, "fields", newJString(fields))
  add(query_589554, "quotaUser", newJString(quotaUser))
  add(query_589554, "alt", newJString(alt))
  add(path_589553, "proposalId", newJString(proposalId))
  add(query_589554, "oauth_token", newJString(oauthToken))
  add(query_589554, "userIp", newJString(userIp))
  add(query_589554, "key", newJString(key))
  if body != nil:
    body_589555 = body
  add(query_589554, "prettyPrint", newJBool(prettyPrint))
  result = call_589552.call(path_589553, query_589554, nil, nil, body_589555)

var adexchangebuyerMarketplacenotesInsert* = Call_AdexchangebuyerMarketplacenotesInsert_589539(
    name: "adexchangebuyerMarketplacenotesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes/insert",
    validator: validate_AdexchangebuyerMarketplacenotesInsert_589540,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesInsert_589541,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSetupcomplete_589556 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProposalsSetupcomplete_589558(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/setupcomplete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerProposalsSetupcomplete_589557(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the given proposal to indicate that setup has been completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposal id for which the setup is complete
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_589559 = path.getOrDefault("proposalId")
  valid_589559 = validateParameter(valid_589559, JString, required = true,
                                 default = nil)
  if valid_589559 != nil:
    section.add "proposalId", valid_589559
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
  var valid_589560 = query.getOrDefault("fields")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "fields", valid_589560
  var valid_589561 = query.getOrDefault("quotaUser")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "quotaUser", valid_589561
  var valid_589562 = query.getOrDefault("alt")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = newJString("json"))
  if valid_589562 != nil:
    section.add "alt", valid_589562
  var valid_589563 = query.getOrDefault("oauth_token")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "oauth_token", valid_589563
  var valid_589564 = query.getOrDefault("userIp")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "userIp", valid_589564
  var valid_589565 = query.getOrDefault("key")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "key", valid_589565
  var valid_589566 = query.getOrDefault("prettyPrint")
  valid_589566 = validateParameter(valid_589566, JBool, required = false,
                                 default = newJBool(true))
  if valid_589566 != nil:
    section.add "prettyPrint", valid_589566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589567: Call_AdexchangebuyerProposalsSetupcomplete_589556;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the given proposal to indicate that setup has been completed.
  ## 
  let valid = call_589567.validator(path, query, header, formData, body)
  let scheme = call_589567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589567.url(scheme.get, call_589567.host, call_589567.base,
                         call_589567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589567, url, valid)

proc call*(call_589568: Call_AdexchangebuyerProposalsSetupcomplete_589556;
          proposalId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProposalsSetupcomplete
  ## Update the given proposal to indicate that setup has been completed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : The proposal id for which the setup is complete
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589569 = newJObject()
  var query_589570 = newJObject()
  add(query_589570, "fields", newJString(fields))
  add(query_589570, "quotaUser", newJString(quotaUser))
  add(query_589570, "alt", newJString(alt))
  add(path_589569, "proposalId", newJString(proposalId))
  add(query_589570, "oauth_token", newJString(oauthToken))
  add(query_589570, "userIp", newJString(userIp))
  add(query_589570, "key", newJString(key))
  add(query_589570, "prettyPrint", newJBool(prettyPrint))
  result = call_589568.call(path_589569, query_589570, nil, nil, nil)

var adexchangebuyerProposalsSetupcomplete* = Call_AdexchangebuyerProposalsSetupcomplete_589556(
    name: "adexchangebuyerProposalsSetupcomplete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/setupcomplete",
    validator: validate_AdexchangebuyerProposalsSetupcomplete_589557,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSetupcomplete_589558,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsUpdate_589571 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProposalsUpdate_589573(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  assert "revisionNumber" in path, "`revisionNumber` is a required path parameter"
  assert "updateAction" in path, "`updateAction` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "revisionNumber"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "updateAction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerProposalsUpdate_589572(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the given proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   updateAction: JString (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   proposalId: JString (required)
  ##             : The proposal id to update.
  ##   revisionNumber: JString (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `updateAction` field"
  var valid_589574 = path.getOrDefault("updateAction")
  valid_589574 = validateParameter(valid_589574, JString, required = true,
                                 default = newJString("accept"))
  if valid_589574 != nil:
    section.add "updateAction", valid_589574
  var valid_589575 = path.getOrDefault("proposalId")
  valid_589575 = validateParameter(valid_589575, JString, required = true,
                                 default = nil)
  if valid_589575 != nil:
    section.add "proposalId", valid_589575
  var valid_589576 = path.getOrDefault("revisionNumber")
  valid_589576 = validateParameter(valid_589576, JString, required = true,
                                 default = nil)
  if valid_589576 != nil:
    section.add "revisionNumber", valid_589576
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
  var valid_589577 = query.getOrDefault("fields")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "fields", valid_589577
  var valid_589578 = query.getOrDefault("quotaUser")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "quotaUser", valid_589578
  var valid_589579 = query.getOrDefault("alt")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = newJString("json"))
  if valid_589579 != nil:
    section.add "alt", valid_589579
  var valid_589580 = query.getOrDefault("oauth_token")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "oauth_token", valid_589580
  var valid_589581 = query.getOrDefault("userIp")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "userIp", valid_589581
  var valid_589582 = query.getOrDefault("key")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = nil)
  if valid_589582 != nil:
    section.add "key", valid_589582
  var valid_589583 = query.getOrDefault("prettyPrint")
  valid_589583 = validateParameter(valid_589583, JBool, required = false,
                                 default = newJBool(true))
  if valid_589583 != nil:
    section.add "prettyPrint", valid_589583
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

proc call*(call_589585: Call_AdexchangebuyerProposalsUpdate_589571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal
  ## 
  let valid = call_589585.validator(path, query, header, formData, body)
  let scheme = call_589585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589585.url(scheme.get, call_589585.host, call_589585.base,
                         call_589585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589585, url, valid)

proc call*(call_589586: Call_AdexchangebuyerProposalsUpdate_589571;
          proposalId: string; revisionNumber: string;
          updateAction: string = "accept"; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProposalsUpdate
  ## Update the given proposal
  ##   updateAction: string (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : The proposal id to update.
  ##   revisionNumber: string (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589587 = newJObject()
  var query_589588 = newJObject()
  var body_589589 = newJObject()
  add(path_589587, "updateAction", newJString(updateAction))
  add(query_589588, "fields", newJString(fields))
  add(query_589588, "quotaUser", newJString(quotaUser))
  add(query_589588, "alt", newJString(alt))
  add(path_589587, "proposalId", newJString(proposalId))
  add(path_589587, "revisionNumber", newJString(revisionNumber))
  add(query_589588, "oauth_token", newJString(oauthToken))
  add(query_589588, "userIp", newJString(userIp))
  add(query_589588, "key", newJString(key))
  if body != nil:
    body_589589 = body
  add(query_589588, "prettyPrint", newJBool(prettyPrint))
  result = call_589586.call(path_589587, query_589588, nil, nil, body_589589)

var adexchangebuyerProposalsUpdate* = Call_AdexchangebuyerProposalsUpdate_589571(
    name: "adexchangebuyerProposalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsUpdate_589572,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsUpdate_589573,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsPatch_589590 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerProposalsPatch_589592(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  assert "revisionNumber" in path, "`revisionNumber` is a required path parameter"
  assert "updateAction" in path, "`updateAction` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "revisionNumber"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "updateAction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerProposalsPatch_589591(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the given proposal. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   updateAction: JString (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   proposalId: JString (required)
  ##             : The proposal id to update.
  ##   revisionNumber: JString (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `updateAction` field"
  var valid_589593 = path.getOrDefault("updateAction")
  valid_589593 = validateParameter(valid_589593, JString, required = true,
                                 default = newJString("accept"))
  if valid_589593 != nil:
    section.add "updateAction", valid_589593
  var valid_589594 = path.getOrDefault("proposalId")
  valid_589594 = validateParameter(valid_589594, JString, required = true,
                                 default = nil)
  if valid_589594 != nil:
    section.add "proposalId", valid_589594
  var valid_589595 = path.getOrDefault("revisionNumber")
  valid_589595 = validateParameter(valid_589595, JString, required = true,
                                 default = nil)
  if valid_589595 != nil:
    section.add "revisionNumber", valid_589595
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
  var valid_589596 = query.getOrDefault("fields")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = nil)
  if valid_589596 != nil:
    section.add "fields", valid_589596
  var valid_589597 = query.getOrDefault("quotaUser")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "quotaUser", valid_589597
  var valid_589598 = query.getOrDefault("alt")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = newJString("json"))
  if valid_589598 != nil:
    section.add "alt", valid_589598
  var valid_589599 = query.getOrDefault("oauth_token")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "oauth_token", valid_589599
  var valid_589600 = query.getOrDefault("userIp")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = nil)
  if valid_589600 != nil:
    section.add "userIp", valid_589600
  var valid_589601 = query.getOrDefault("key")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "key", valid_589601
  var valid_589602 = query.getOrDefault("prettyPrint")
  valid_589602 = validateParameter(valid_589602, JBool, required = false,
                                 default = newJBool(true))
  if valid_589602 != nil:
    section.add "prettyPrint", valid_589602
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

proc call*(call_589604: Call_AdexchangebuyerProposalsPatch_589590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal. This method supports patch semantics.
  ## 
  let valid = call_589604.validator(path, query, header, formData, body)
  let scheme = call_589604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589604.url(scheme.get, call_589604.host, call_589604.base,
                         call_589604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589604, url, valid)

proc call*(call_589605: Call_AdexchangebuyerProposalsPatch_589590;
          proposalId: string; revisionNumber: string;
          updateAction: string = "accept"; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerProposalsPatch
  ## Update the given proposal. This method supports patch semantics.
  ##   updateAction: string (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   proposalId: string (required)
  ##             : The proposal id to update.
  ##   revisionNumber: string (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589606 = newJObject()
  var query_589607 = newJObject()
  var body_589608 = newJObject()
  add(path_589606, "updateAction", newJString(updateAction))
  add(query_589607, "fields", newJString(fields))
  add(query_589607, "quotaUser", newJString(quotaUser))
  add(query_589607, "alt", newJString(alt))
  add(path_589606, "proposalId", newJString(proposalId))
  add(path_589606, "revisionNumber", newJString(revisionNumber))
  add(query_589607, "oauth_token", newJString(oauthToken))
  add(query_589607, "userIp", newJString(userIp))
  add(query_589607, "key", newJString(key))
  if body != nil:
    body_589608 = body
  add(query_589607, "prettyPrint", newJBool(prettyPrint))
  result = call_589605.call(path_589606, query_589607, nil, nil, body_589608)

var adexchangebuyerProposalsPatch* = Call_AdexchangebuyerProposalsPatch_589590(
    name: "adexchangebuyerProposalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsPatch_589591,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsPatch_589592,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPubprofilesList_589609 = ref object of OpenApiRestCall_588466
proc url_AdexchangebuyerPubprofilesList_589611(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/publisher/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPubprofilesList_589610(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the requested publisher profile(s) by publisher accountId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JInt (required)
  ##            : The accountId of the publisher to get profiles for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589612 = path.getOrDefault("accountId")
  valid_589612 = validateParameter(valid_589612, JInt, required = true, default = nil)
  if valid_589612 != nil:
    section.add "accountId", valid_589612
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
  var valid_589613 = query.getOrDefault("fields")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "fields", valid_589613
  var valid_589614 = query.getOrDefault("quotaUser")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "quotaUser", valid_589614
  var valid_589615 = query.getOrDefault("alt")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = newJString("json"))
  if valid_589615 != nil:
    section.add "alt", valid_589615
  var valid_589616 = query.getOrDefault("oauth_token")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "oauth_token", valid_589616
  var valid_589617 = query.getOrDefault("userIp")
  valid_589617 = validateParameter(valid_589617, JString, required = false,
                                 default = nil)
  if valid_589617 != nil:
    section.add "userIp", valid_589617
  var valid_589618 = query.getOrDefault("key")
  valid_589618 = validateParameter(valid_589618, JString, required = false,
                                 default = nil)
  if valid_589618 != nil:
    section.add "key", valid_589618
  var valid_589619 = query.getOrDefault("prettyPrint")
  valid_589619 = validateParameter(valid_589619, JBool, required = false,
                                 default = newJBool(true))
  if valid_589619 != nil:
    section.add "prettyPrint", valid_589619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589620: Call_AdexchangebuyerPubprofilesList_589609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested publisher profile(s) by publisher accountId.
  ## 
  let valid = call_589620.validator(path, query, header, formData, body)
  let scheme = call_589620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589620.url(scheme.get, call_589620.host, call_589620.base,
                         call_589620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589620, url, valid)

proc call*(call_589621: Call_AdexchangebuyerPubprofilesList_589609; accountId: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangebuyerPubprofilesList
  ## Gets the requested publisher profile(s) by publisher accountId.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: int (required)
  ##            : The accountId of the publisher to get profiles for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589622 = newJObject()
  var query_589623 = newJObject()
  add(query_589623, "fields", newJString(fields))
  add(query_589623, "quotaUser", newJString(quotaUser))
  add(query_589623, "alt", newJString(alt))
  add(query_589623, "oauth_token", newJString(oauthToken))
  add(path_589622, "accountId", newJInt(accountId))
  add(query_589623, "userIp", newJString(userIp))
  add(query_589623, "key", newJString(key))
  add(query_589623, "prettyPrint", newJBool(prettyPrint))
  result = call_589621.call(path_589622, query_589623, nil, nil, nil)

var adexchangebuyerPubprofilesList* = Call_AdexchangebuyerPubprofilesList_589609(
    name: "adexchangebuyerPubprofilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/publisher/{accountId}/profiles",
    validator: validate_AdexchangebuyerPubprofilesList_589610,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPubprofilesList_589611,
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
