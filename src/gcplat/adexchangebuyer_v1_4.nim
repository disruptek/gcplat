
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
  gcpServiceName = "adexchangebuyer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangebuyerAccountsList_579706 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerAccountsList_579708(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerAccountsList_579707(path: JsonNode; query: JsonNode;
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
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("userIp")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "userIp", valid_579837
  var valid_579838 = query.getOrDefault("key")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "key", valid_579838
  var valid_579839 = query.getOrDefault("prettyPrint")
  valid_579839 = validateParameter(valid_579839, JBool, required = false,
                                 default = newJBool(true))
  if valid_579839 != nil:
    section.add "prettyPrint", valid_579839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579862: Call_AdexchangebuyerAccountsList_579706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of accounts.
  ## 
  let valid = call_579862.validator(path, query, header, formData, body)
  let scheme = call_579862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579862.url(scheme.get, call_579862.host, call_579862.base,
                         call_579862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579862, url, valid)

proc call*(call_579933: Call_AdexchangebuyerAccountsList_579706;
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
  var query_579934 = newJObject()
  add(query_579934, "fields", newJString(fields))
  add(query_579934, "quotaUser", newJString(quotaUser))
  add(query_579934, "alt", newJString(alt))
  add(query_579934, "oauth_token", newJString(oauthToken))
  add(query_579934, "userIp", newJString(userIp))
  add(query_579934, "key", newJString(key))
  add(query_579934, "prettyPrint", newJBool(prettyPrint))
  result = call_579933.call(nil, query_579934, nil, nil, nil)

var adexchangebuyerAccountsList* = Call_AdexchangebuyerAccountsList_579706(
    name: "adexchangebuyerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangebuyerAccountsList_579707,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsList_579708,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsUpdate_580003 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerAccountsUpdate_580005(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsUpdate_580004(path: JsonNode; query: JsonNode;
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
  var valid_580006 = path.getOrDefault("id")
  valid_580006 = validateParameter(valid_580006, JInt, required = true, default = nil)
  if valid_580006 != nil:
    section.add "id", valid_580006
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
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_580010 = validateParameter(valid_580010, JBool, required = false, default = nil)
  if valid_580010 != nil:
    section.add "confirmUnsafeAccountChange", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("userIp")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "userIp", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
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

proc call*(call_580016: Call_AdexchangebuyerAccountsUpdate_580003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account.
  ## 
  let valid = call_580016.validator(path, query, header, formData, body)
  let scheme = call_580016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580016.url(scheme.get, call_580016.host, call_580016.base,
                         call_580016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580016, url, valid)

proc call*(call_580017: Call_AdexchangebuyerAccountsUpdate_580003; id: int;
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
  var path_580018 = newJObject()
  var query_580019 = newJObject()
  var body_580020 = newJObject()
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "userIp", newJString(userIp))
  add(path_580018, "id", newJInt(id))
  add(query_580019, "key", newJString(key))
  if body != nil:
    body_580020 = body
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580017.call(path_580018, query_580019, nil, nil, body_580020)

var adexchangebuyerAccountsUpdate* = Call_AdexchangebuyerAccountsUpdate_580003(
    name: "adexchangebuyerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsUpdate_580004,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsUpdate_580005,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsGet_579974 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerAccountsGet_579976(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsGet_579975(path: JsonNode; query: JsonNode;
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
  var valid_579991 = path.getOrDefault("id")
  valid_579991 = validateParameter(valid_579991, JInt, required = true, default = nil)
  if valid_579991 != nil:
    section.add "id", valid_579991
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
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("userIp")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "userIp", valid_579996
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579999: Call_AdexchangebuyerAccountsGet_579974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one account by ID.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_AdexchangebuyerAccountsGet_579974; id: int;
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
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "userIp", newJString(userIp))
  add(path_580001, "id", newJInt(id))
  add(query_580002, "key", newJString(key))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  result = call_580000.call(path_580001, query_580002, nil, nil, nil)

var adexchangebuyerAccountsGet* = Call_AdexchangebuyerAccountsGet_579974(
    name: "adexchangebuyerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsGet_579975,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsGet_579976,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsPatch_580021 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerAccountsPatch_580023(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsPatch_580022(path: JsonNode; query: JsonNode;
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
  var valid_580024 = path.getOrDefault("id")
  valid_580024 = validateParameter(valid_580024, JInt, required = true, default = nil)
  if valid_580024 != nil:
    section.add "id", valid_580024
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
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_580028 = validateParameter(valid_580028, JBool, required = false, default = nil)
  if valid_580028 != nil:
    section.add "confirmUnsafeAccountChange", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("userIp")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "userIp", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("prettyPrint")
  valid_580032 = validateParameter(valid_580032, JBool, required = false,
                                 default = newJBool(true))
  if valid_580032 != nil:
    section.add "prettyPrint", valid_580032
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

proc call*(call_580034: Call_AdexchangebuyerAccountsPatch_580021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_AdexchangebuyerAccountsPatch_580021; id: int;
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
  var path_580036 = newJObject()
  var query_580037 = newJObject()
  var body_580038 = newJObject()
  add(query_580037, "fields", newJString(fields))
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "userIp", newJString(userIp))
  add(path_580036, "id", newJInt(id))
  add(query_580037, "key", newJString(key))
  if body != nil:
    body_580038 = body
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  result = call_580035.call(path_580036, query_580037, nil, nil, body_580038)

var adexchangebuyerAccountsPatch* = Call_AdexchangebuyerAccountsPatch_580021(
    name: "adexchangebuyerAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsPatch_580022,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsPatch_580023,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoList_580039 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerBillingInfoList_580041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerBillingInfoList_580040(path: JsonNode;
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
  var valid_580042 = query.getOrDefault("fields")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fields", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("alt")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("json"))
  if valid_580044 != nil:
    section.add "alt", valid_580044
  var valid_580045 = query.getOrDefault("oauth_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "oauth_token", valid_580045
  var valid_580046 = query.getOrDefault("userIp")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "userIp", valid_580046
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("prettyPrint")
  valid_580048 = validateParameter(valid_580048, JBool, required = false,
                                 default = newJBool(true))
  if valid_580048 != nil:
    section.add "prettyPrint", valid_580048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580049: Call_AdexchangebuyerBillingInfoList_580039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
  ## 
  let valid = call_580049.validator(path, query, header, formData, body)
  let scheme = call_580049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580049.url(scheme.get, call_580049.host, call_580049.base,
                         call_580049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580049, url, valid)

proc call*(call_580050: Call_AdexchangebuyerBillingInfoList_580039;
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
  var query_580051 = newJObject()
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "userIp", newJString(userIp))
  add(query_580051, "key", newJString(key))
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  result = call_580050.call(nil, query_580051, nil, nil, nil)

var adexchangebuyerBillingInfoList* = Call_AdexchangebuyerBillingInfoList_580039(
    name: "adexchangebuyerBillingInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo",
    validator: validate_AdexchangebuyerBillingInfoList_580040,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoList_580041,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoGet_580052 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerBillingInfoGet_580054(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBillingInfoGet_580053(path: JsonNode; query: JsonNode;
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
  var valid_580055 = path.getOrDefault("accountId")
  valid_580055 = validateParameter(valid_580055, JInt, required = true, default = nil)
  if valid_580055 != nil:
    section.add "accountId", valid_580055
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
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("userIp")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "userIp", valid_580060
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("prettyPrint")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(true))
  if valid_580062 != nil:
    section.add "prettyPrint", valid_580062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580063: Call_AdexchangebuyerBillingInfoGet_580052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the billing information for one account specified by account ID.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_AdexchangebuyerBillingInfoGet_580052; accountId: int;
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
  var path_580065 = newJObject()
  var query_580066 = newJObject()
  add(query_580066, "fields", newJString(fields))
  add(query_580066, "quotaUser", newJString(quotaUser))
  add(query_580066, "alt", newJString(alt))
  add(query_580066, "oauth_token", newJString(oauthToken))
  add(path_580065, "accountId", newJInt(accountId))
  add(query_580066, "userIp", newJString(userIp))
  add(query_580066, "key", newJString(key))
  add(query_580066, "prettyPrint", newJBool(prettyPrint))
  result = call_580064.call(path_580065, query_580066, nil, nil, nil)

var adexchangebuyerBillingInfoGet* = Call_AdexchangebuyerBillingInfoGet_580052(
    name: "adexchangebuyerBillingInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}",
    validator: validate_AdexchangebuyerBillingInfoGet_580053,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoGet_580054,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetUpdate_580083 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerBudgetUpdate_580085(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetUpdate_580084(path: JsonNode; query: JsonNode;
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
  var valid_580086 = path.getOrDefault("billingId")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "billingId", valid_580086
  var valid_580087 = path.getOrDefault("accountId")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "accountId", valid_580087
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
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("alt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("json"))
  if valid_580090 != nil:
    section.add "alt", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("userIp")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "userIp", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("prettyPrint")
  valid_580094 = validateParameter(valid_580094, JBool, required = false,
                                 default = newJBool(true))
  if valid_580094 != nil:
    section.add "prettyPrint", valid_580094
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

proc call*(call_580096: Call_AdexchangebuyerBudgetUpdate_580083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_AdexchangebuyerBudgetUpdate_580083; billingId: string;
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
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  var body_580100 = newJObject()
  add(query_580099, "fields", newJString(fields))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(path_580098, "billingId", newJString(billingId))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(path_580098, "accountId", newJString(accountId))
  add(query_580099, "userIp", newJString(userIp))
  add(query_580099, "key", newJString(key))
  if body != nil:
    body_580100 = body
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  result = call_580097.call(path_580098, query_580099, nil, nil, body_580100)

var adexchangebuyerBudgetUpdate* = Call_AdexchangebuyerBudgetUpdate_580083(
    name: "adexchangebuyerBudgetUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetUpdate_580084,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetUpdate_580085,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetGet_580067 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerBudgetGet_580069(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetGet_580068(path: JsonNode; query: JsonNode;
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
  var valid_580070 = path.getOrDefault("billingId")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "billingId", valid_580070
  var valid_580071 = path.getOrDefault("accountId")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "accountId", valid_580071
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
  var valid_580072 = query.getOrDefault("fields")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "fields", valid_580072
  var valid_580073 = query.getOrDefault("quotaUser")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "quotaUser", valid_580073
  var valid_580074 = query.getOrDefault("alt")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("json"))
  if valid_580074 != nil:
    section.add "alt", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("userIp")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "userIp", valid_580076
  var valid_580077 = query.getOrDefault("key")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "key", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580079: Call_AdexchangebuyerBudgetGet_580067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_AdexchangebuyerBudgetGet_580067; billingId: string;
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
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(path_580081, "billingId", newJString(billingId))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(path_580081, "accountId", newJString(accountId))
  add(query_580082, "userIp", newJString(userIp))
  add(query_580082, "key", newJString(key))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  result = call_580080.call(path_580081, query_580082, nil, nil, nil)

var adexchangebuyerBudgetGet* = Call_AdexchangebuyerBudgetGet_580067(
    name: "adexchangebuyerBudgetGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetGet_580068,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetGet_580069,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetPatch_580101 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerBudgetPatch_580103(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetPatch_580102(path: JsonNode; query: JsonNode;
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
  var valid_580104 = path.getOrDefault("billingId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "billingId", valid_580104
  var valid_580105 = path.getOrDefault("accountId")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "accountId", valid_580105
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
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  var valid_580107 = query.getOrDefault("quotaUser")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "quotaUser", valid_580107
  var valid_580108 = query.getOrDefault("alt")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("json"))
  if valid_580108 != nil:
    section.add "alt", valid_580108
  var valid_580109 = query.getOrDefault("oauth_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "oauth_token", valid_580109
  var valid_580110 = query.getOrDefault("userIp")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "userIp", valid_580110
  var valid_580111 = query.getOrDefault("key")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "key", valid_580111
  var valid_580112 = query.getOrDefault("prettyPrint")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(true))
  if valid_580112 != nil:
    section.add "prettyPrint", valid_580112
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

proc call*(call_580114: Call_AdexchangebuyerBudgetPatch_580101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  let valid = call_580114.validator(path, query, header, formData, body)
  let scheme = call_580114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580114.url(scheme.get, call_580114.host, call_580114.base,
                         call_580114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580114, url, valid)

proc call*(call_580115: Call_AdexchangebuyerBudgetPatch_580101; billingId: string;
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
  var path_580116 = newJObject()
  var query_580117 = newJObject()
  var body_580118 = newJObject()
  add(query_580117, "fields", newJString(fields))
  add(query_580117, "quotaUser", newJString(quotaUser))
  add(path_580116, "billingId", newJString(billingId))
  add(query_580117, "alt", newJString(alt))
  add(query_580117, "oauth_token", newJString(oauthToken))
  add(path_580116, "accountId", newJString(accountId))
  add(query_580117, "userIp", newJString(userIp))
  add(query_580117, "key", newJString(key))
  if body != nil:
    body_580118 = body
  add(query_580117, "prettyPrint", newJBool(prettyPrint))
  result = call_580115.call(path_580116, query_580117, nil, nil, body_580118)

var adexchangebuyerBudgetPatch* = Call_AdexchangebuyerBudgetPatch_580101(
    name: "adexchangebuyerBudgetPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetPatch_580102,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetPatch_580103,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_580138 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerCreativesInsert_580140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_580139(path: JsonNode;
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
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("userIp")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "userIp", valid_580145
  var valid_580146 = query.getOrDefault("key")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "key", valid_580146
  var valid_580147 = query.getOrDefault("prettyPrint")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "prettyPrint", valid_580147
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

proc call*(call_580149: Call_AdexchangebuyerCreativesInsert_580138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_AdexchangebuyerCreativesInsert_580138;
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
  var query_580151 = newJObject()
  var body_580152 = newJObject()
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "userIp", newJString(userIp))
  add(query_580151, "key", newJString(key))
  if body != nil:
    body_580152 = body
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(nil, query_580151, nil, nil, body_580152)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_580138(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_580139,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesInsert_580140,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_580119 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerCreativesList_580121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_580120(path: JsonNode; query: JsonNode;
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
  var valid_580122 = query.getOrDefault("buyerCreativeId")
  valid_580122 = validateParameter(valid_580122, JArray, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "buyerCreativeId", valid_580122
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("pageToken")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "pageToken", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("oauth_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "oauth_token", valid_580127
  var valid_580128 = query.getOrDefault("accountId")
  valid_580128 = validateParameter(valid_580128, JArray, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "accountId", valid_580128
  var valid_580129 = query.getOrDefault("userIp")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "userIp", valid_580129
  var valid_580130 = query.getOrDefault("maxResults")
  valid_580130 = validateParameter(valid_580130, JInt, required = false, default = nil)
  if valid_580130 != nil:
    section.add "maxResults", valid_580130
  var valid_580131 = query.getOrDefault("openAuctionStatusFilter")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("approved"))
  if valid_580131 != nil:
    section.add "openAuctionStatusFilter", valid_580131
  var valid_580132 = query.getOrDefault("key")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "key", valid_580132
  var valid_580133 = query.getOrDefault("dealsStatusFilter")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("approved"))
  if valid_580133 != nil:
    section.add "dealsStatusFilter", valid_580133
  var valid_580134 = query.getOrDefault("prettyPrint")
  valid_580134 = validateParameter(valid_580134, JBool, required = false,
                                 default = newJBool(true))
  if valid_580134 != nil:
    section.add "prettyPrint", valid_580134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580135: Call_AdexchangebuyerCreativesList_580119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_580135.validator(path, query, header, formData, body)
  let scheme = call_580135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580135.url(scheme.get, call_580135.host, call_580135.base,
                         call_580135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580135, url, valid)

proc call*(call_580136: Call_AdexchangebuyerCreativesList_580119;
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
  var query_580137 = newJObject()
  if buyerCreativeId != nil:
    query_580137.add "buyerCreativeId", buyerCreativeId
  add(query_580137, "fields", newJString(fields))
  add(query_580137, "pageToken", newJString(pageToken))
  add(query_580137, "quotaUser", newJString(quotaUser))
  add(query_580137, "alt", newJString(alt))
  add(query_580137, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_580137.add "accountId", accountId
  add(query_580137, "userIp", newJString(userIp))
  add(query_580137, "maxResults", newJInt(maxResults))
  add(query_580137, "openAuctionStatusFilter", newJString(openAuctionStatusFilter))
  add(query_580137, "key", newJString(key))
  add(query_580137, "dealsStatusFilter", newJString(dealsStatusFilter))
  add(query_580137, "prettyPrint", newJBool(prettyPrint))
  result = call_580136.call(nil, query_580137, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_580119(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_580120,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesList_580121,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_580153 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerCreativesGet_580155(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesGet_580154(path: JsonNode; query: JsonNode;
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
  var valid_580156 = path.getOrDefault("accountId")
  valid_580156 = validateParameter(valid_580156, JInt, required = true, default = nil)
  if valid_580156 != nil:
    section.add "accountId", valid_580156
  var valid_580157 = path.getOrDefault("buyerCreativeId")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "buyerCreativeId", valid_580157
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
  var valid_580158 = query.getOrDefault("fields")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "fields", valid_580158
  var valid_580159 = query.getOrDefault("quotaUser")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "quotaUser", valid_580159
  var valid_580160 = query.getOrDefault("alt")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("json"))
  if valid_580160 != nil:
    section.add "alt", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("userIp")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "userIp", valid_580162
  var valid_580163 = query.getOrDefault("key")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "key", valid_580163
  var valid_580164 = query.getOrDefault("prettyPrint")
  valid_580164 = validateParameter(valid_580164, JBool, required = false,
                                 default = newJBool(true))
  if valid_580164 != nil:
    section.add "prettyPrint", valid_580164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580165: Call_AdexchangebuyerCreativesGet_580153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_580165.validator(path, query, header, formData, body)
  let scheme = call_580165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580165.url(scheme.get, call_580165.host, call_580165.base,
                         call_580165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580165, url, valid)

proc call*(call_580166: Call_AdexchangebuyerCreativesGet_580153; accountId: int;
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
  var path_580167 = newJObject()
  var query_580168 = newJObject()
  add(query_580168, "fields", newJString(fields))
  add(query_580168, "quotaUser", newJString(quotaUser))
  add(query_580168, "alt", newJString(alt))
  add(query_580168, "oauth_token", newJString(oauthToken))
  add(path_580167, "accountId", newJInt(accountId))
  add(query_580168, "userIp", newJString(userIp))
  add(path_580167, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_580168, "key", newJString(key))
  add(query_580168, "prettyPrint", newJBool(prettyPrint))
  result = call_580166.call(path_580167, query_580168, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_580153(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_580154,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesGet_580155,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesAddDeal_580169 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerCreativesAddDeal_580171(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesAddDeal_580170(path: JsonNode;
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
  var valid_580172 = path.getOrDefault("accountId")
  valid_580172 = validateParameter(valid_580172, JInt, required = true, default = nil)
  if valid_580172 != nil:
    section.add "accountId", valid_580172
  var valid_580173 = path.getOrDefault("buyerCreativeId")
  valid_580173 = validateParameter(valid_580173, JString, required = true,
                                 default = nil)
  if valid_580173 != nil:
    section.add "buyerCreativeId", valid_580173
  var valid_580174 = path.getOrDefault("dealId")
  valid_580174 = validateParameter(valid_580174, JString, required = true,
                                 default = nil)
  if valid_580174 != nil:
    section.add "dealId", valid_580174
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
  var valid_580175 = query.getOrDefault("fields")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "fields", valid_580175
  var valid_580176 = query.getOrDefault("quotaUser")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "quotaUser", valid_580176
  var valid_580177 = query.getOrDefault("alt")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = newJString("json"))
  if valid_580177 != nil:
    section.add "alt", valid_580177
  var valid_580178 = query.getOrDefault("oauth_token")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "oauth_token", valid_580178
  var valid_580179 = query.getOrDefault("userIp")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "userIp", valid_580179
  var valid_580180 = query.getOrDefault("key")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "key", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580182: Call_AdexchangebuyerCreativesAddDeal_580169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a deal id association for the creative.
  ## 
  let valid = call_580182.validator(path, query, header, formData, body)
  let scheme = call_580182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580182.url(scheme.get, call_580182.host, call_580182.base,
                         call_580182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580182, url, valid)

proc call*(call_580183: Call_AdexchangebuyerCreativesAddDeal_580169;
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
  var path_580184 = newJObject()
  var query_580185 = newJObject()
  add(query_580185, "fields", newJString(fields))
  add(query_580185, "quotaUser", newJString(quotaUser))
  add(query_580185, "alt", newJString(alt))
  add(query_580185, "oauth_token", newJString(oauthToken))
  add(path_580184, "accountId", newJInt(accountId))
  add(query_580185, "userIp", newJString(userIp))
  add(path_580184, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_580185, "key", newJString(key))
  add(query_580185, "prettyPrint", newJBool(prettyPrint))
  add(path_580184, "dealId", newJString(dealId))
  result = call_580183.call(path_580184, query_580185, nil, nil, nil)

var adexchangebuyerCreativesAddDeal* = Call_AdexchangebuyerCreativesAddDeal_580169(
    name: "adexchangebuyerCreativesAddDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/addDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesAddDeal_580170,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesAddDeal_580171,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesListDeals_580186 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerCreativesListDeals_580188(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesListDeals_580187(path: JsonNode;
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
  var valid_580189 = path.getOrDefault("accountId")
  valid_580189 = validateParameter(valid_580189, JInt, required = true, default = nil)
  if valid_580189 != nil:
    section.add "accountId", valid_580189
  var valid_580190 = path.getOrDefault("buyerCreativeId")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "buyerCreativeId", valid_580190
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
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("userIp")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "userIp", valid_580195
  var valid_580196 = query.getOrDefault("key")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "key", valid_580196
  var valid_580197 = query.getOrDefault("prettyPrint")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(true))
  if valid_580197 != nil:
    section.add "prettyPrint", valid_580197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580198: Call_AdexchangebuyerCreativesListDeals_580186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the external deal ids associated with the creative.
  ## 
  let valid = call_580198.validator(path, query, header, formData, body)
  let scheme = call_580198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580198.url(scheme.get, call_580198.host, call_580198.base,
                         call_580198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580198, url, valid)

proc call*(call_580199: Call_AdexchangebuyerCreativesListDeals_580186;
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
  var path_580200 = newJObject()
  var query_580201 = newJObject()
  add(query_580201, "fields", newJString(fields))
  add(query_580201, "quotaUser", newJString(quotaUser))
  add(query_580201, "alt", newJString(alt))
  add(query_580201, "oauth_token", newJString(oauthToken))
  add(path_580200, "accountId", newJInt(accountId))
  add(query_580201, "userIp", newJString(userIp))
  add(path_580200, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_580201, "key", newJString(key))
  add(query_580201, "prettyPrint", newJBool(prettyPrint))
  result = call_580199.call(path_580200, query_580201, nil, nil, nil)

var adexchangebuyerCreativesListDeals* = Call_AdexchangebuyerCreativesListDeals_580186(
    name: "adexchangebuyerCreativesListDeals", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/listDeals",
    validator: validate_AdexchangebuyerCreativesListDeals_580187,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesListDeals_580188,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesRemoveDeal_580202 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerCreativesRemoveDeal_580204(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesRemoveDeal_580203(path: JsonNode;
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
  var valid_580205 = path.getOrDefault("accountId")
  valid_580205 = validateParameter(valid_580205, JInt, required = true, default = nil)
  if valid_580205 != nil:
    section.add "accountId", valid_580205
  var valid_580206 = path.getOrDefault("buyerCreativeId")
  valid_580206 = validateParameter(valid_580206, JString, required = true,
                                 default = nil)
  if valid_580206 != nil:
    section.add "buyerCreativeId", valid_580206
  var valid_580207 = path.getOrDefault("dealId")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "dealId", valid_580207
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
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  var valid_580209 = query.getOrDefault("quotaUser")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "quotaUser", valid_580209
  var valid_580210 = query.getOrDefault("alt")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("json"))
  if valid_580210 != nil:
    section.add "alt", valid_580210
  var valid_580211 = query.getOrDefault("oauth_token")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "oauth_token", valid_580211
  var valid_580212 = query.getOrDefault("userIp")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "userIp", valid_580212
  var valid_580213 = query.getOrDefault("key")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "key", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580215: Call_AdexchangebuyerCreativesRemoveDeal_580202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove a deal id associated with the creative.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_AdexchangebuyerCreativesRemoveDeal_580202;
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
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(path_580217, "accountId", newJInt(accountId))
  add(query_580218, "userIp", newJString(userIp))
  add(path_580217, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_580218, "key", newJString(key))
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  add(path_580217, "dealId", newJString(dealId))
  result = call_580216.call(path_580217, query_580218, nil, nil, nil)

var adexchangebuyerCreativesRemoveDeal* = Call_AdexchangebuyerCreativesRemoveDeal_580202(
    name: "adexchangebuyerCreativesRemoveDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/removeDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesRemoveDeal_580203,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesRemoveDeal_580204,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPerformanceReportList_580219 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPerformanceReportList_580221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerPerformanceReportList_580220(path: JsonNode;
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
  var valid_580222 = query.getOrDefault("fields")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "fields", valid_580222
  var valid_580223 = query.getOrDefault("pageToken")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "pageToken", valid_580223
  var valid_580224 = query.getOrDefault("quotaUser")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "quotaUser", valid_580224
  var valid_580225 = query.getOrDefault("alt")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("json"))
  if valid_580225 != nil:
    section.add "alt", valid_580225
  assert query != nil,
        "query argument is necessary due to required `startDateTime` field"
  var valid_580226 = query.getOrDefault("startDateTime")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "startDateTime", valid_580226
  var valid_580227 = query.getOrDefault("oauth_token")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "oauth_token", valid_580227
  var valid_580228 = query.getOrDefault("accountId")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "accountId", valid_580228
  var valid_580229 = query.getOrDefault("userIp")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "userIp", valid_580229
  var valid_580230 = query.getOrDefault("maxResults")
  valid_580230 = validateParameter(valid_580230, JInt, required = false, default = nil)
  if valid_580230 != nil:
    section.add "maxResults", valid_580230
  var valid_580231 = query.getOrDefault("key")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "key", valid_580231
  var valid_580232 = query.getOrDefault("endDateTime")
  valid_580232 = validateParameter(valid_580232, JString, required = true,
                                 default = nil)
  if valid_580232 != nil:
    section.add "endDateTime", valid_580232
  var valid_580233 = query.getOrDefault("prettyPrint")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(true))
  if valid_580233 != nil:
    section.add "prettyPrint", valid_580233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580234: Call_AdexchangebuyerPerformanceReportList_580219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  let valid = call_580234.validator(path, query, header, formData, body)
  let scheme = call_580234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580234.url(scheme.get, call_580234.host, call_580234.base,
                         call_580234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580234, url, valid)

proc call*(call_580235: Call_AdexchangebuyerPerformanceReportList_580219;
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
  var query_580236 = newJObject()
  add(query_580236, "fields", newJString(fields))
  add(query_580236, "pageToken", newJString(pageToken))
  add(query_580236, "quotaUser", newJString(quotaUser))
  add(query_580236, "alt", newJString(alt))
  add(query_580236, "startDateTime", newJString(startDateTime))
  add(query_580236, "oauth_token", newJString(oauthToken))
  add(query_580236, "accountId", newJString(accountId))
  add(query_580236, "userIp", newJString(userIp))
  add(query_580236, "maxResults", newJInt(maxResults))
  add(query_580236, "key", newJString(key))
  add(query_580236, "endDateTime", newJString(endDateTime))
  add(query_580236, "prettyPrint", newJBool(prettyPrint))
  result = call_580235.call(nil, query_580236, nil, nil, nil)

var adexchangebuyerPerformanceReportList* = Call_AdexchangebuyerPerformanceReportList_580219(
    name: "adexchangebuyerPerformanceReportList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/performancereport",
    validator: validate_AdexchangebuyerPerformanceReportList_580220,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPerformanceReportList_580221,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigInsert_580252 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPretargetingConfigInsert_580254(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigInsert_580253(path: JsonNode;
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
  var valid_580255 = path.getOrDefault("accountId")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "accountId", valid_580255
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
  var valid_580256 = query.getOrDefault("fields")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "fields", valid_580256
  var valid_580257 = query.getOrDefault("quotaUser")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "quotaUser", valid_580257
  var valid_580258 = query.getOrDefault("alt")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = newJString("json"))
  if valid_580258 != nil:
    section.add "alt", valid_580258
  var valid_580259 = query.getOrDefault("oauth_token")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "oauth_token", valid_580259
  var valid_580260 = query.getOrDefault("userIp")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "userIp", valid_580260
  var valid_580261 = query.getOrDefault("key")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "key", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
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

proc call*(call_580264: Call_AdexchangebuyerPretargetingConfigInsert_580252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new pretargeting configuration.
  ## 
  let valid = call_580264.validator(path, query, header, formData, body)
  let scheme = call_580264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580264.url(scheme.get, call_580264.host, call_580264.base,
                         call_580264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580264, url, valid)

proc call*(call_580265: Call_AdexchangebuyerPretargetingConfigInsert_580252;
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
  var path_580266 = newJObject()
  var query_580267 = newJObject()
  var body_580268 = newJObject()
  add(query_580267, "fields", newJString(fields))
  add(query_580267, "quotaUser", newJString(quotaUser))
  add(query_580267, "alt", newJString(alt))
  add(query_580267, "oauth_token", newJString(oauthToken))
  add(path_580266, "accountId", newJString(accountId))
  add(query_580267, "userIp", newJString(userIp))
  add(query_580267, "key", newJString(key))
  if body != nil:
    body_580268 = body
  add(query_580267, "prettyPrint", newJBool(prettyPrint))
  result = call_580265.call(path_580266, query_580267, nil, nil, body_580268)

var adexchangebuyerPretargetingConfigInsert* = Call_AdexchangebuyerPretargetingConfigInsert_580252(
    name: "adexchangebuyerPretargetingConfigInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigInsert_580253,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigInsert_580254,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigList_580237 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPretargetingConfigList_580239(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigList_580238(path: JsonNode;
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
  var valid_580240 = path.getOrDefault("accountId")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "accountId", valid_580240
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
  var valid_580241 = query.getOrDefault("fields")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "fields", valid_580241
  var valid_580242 = query.getOrDefault("quotaUser")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "quotaUser", valid_580242
  var valid_580243 = query.getOrDefault("alt")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("json"))
  if valid_580243 != nil:
    section.add "alt", valid_580243
  var valid_580244 = query.getOrDefault("oauth_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "oauth_token", valid_580244
  var valid_580245 = query.getOrDefault("userIp")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "userIp", valid_580245
  var valid_580246 = query.getOrDefault("key")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "key", valid_580246
  var valid_580247 = query.getOrDefault("prettyPrint")
  valid_580247 = validateParameter(valid_580247, JBool, required = false,
                                 default = newJBool(true))
  if valid_580247 != nil:
    section.add "prettyPrint", valid_580247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580248: Call_AdexchangebuyerPretargetingConfigList_580237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_AdexchangebuyerPretargetingConfigList_580237;
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
  var path_580250 = newJObject()
  var query_580251 = newJObject()
  add(query_580251, "fields", newJString(fields))
  add(query_580251, "quotaUser", newJString(quotaUser))
  add(query_580251, "alt", newJString(alt))
  add(query_580251, "oauth_token", newJString(oauthToken))
  add(path_580250, "accountId", newJString(accountId))
  add(query_580251, "userIp", newJString(userIp))
  add(query_580251, "key", newJString(key))
  add(query_580251, "prettyPrint", newJBool(prettyPrint))
  result = call_580249.call(path_580250, query_580251, nil, nil, nil)

var adexchangebuyerPretargetingConfigList* = Call_AdexchangebuyerPretargetingConfigList_580237(
    name: "adexchangebuyerPretargetingConfigList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigList_580238,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigList_580239,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigUpdate_580285 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPretargetingConfigUpdate_580287(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigUpdate_580286(path: JsonNode;
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
  var valid_580288 = path.getOrDefault("accountId")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = nil)
  if valid_580288 != nil:
    section.add "accountId", valid_580288
  var valid_580289 = path.getOrDefault("configId")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "configId", valid_580289
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
  var valid_580290 = query.getOrDefault("fields")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "fields", valid_580290
  var valid_580291 = query.getOrDefault("quotaUser")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "quotaUser", valid_580291
  var valid_580292 = query.getOrDefault("alt")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("json"))
  if valid_580292 != nil:
    section.add "alt", valid_580292
  var valid_580293 = query.getOrDefault("oauth_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "oauth_token", valid_580293
  var valid_580294 = query.getOrDefault("userIp")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "userIp", valid_580294
  var valid_580295 = query.getOrDefault("key")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "key", valid_580295
  var valid_580296 = query.getOrDefault("prettyPrint")
  valid_580296 = validateParameter(valid_580296, JBool, required = false,
                                 default = newJBool(true))
  if valid_580296 != nil:
    section.add "prettyPrint", valid_580296
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

proc call*(call_580298: Call_AdexchangebuyerPretargetingConfigUpdate_580285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config.
  ## 
  let valid = call_580298.validator(path, query, header, formData, body)
  let scheme = call_580298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580298.url(scheme.get, call_580298.host, call_580298.base,
                         call_580298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580298, url, valid)

proc call*(call_580299: Call_AdexchangebuyerPretargetingConfigUpdate_580285;
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
  var path_580300 = newJObject()
  var query_580301 = newJObject()
  var body_580302 = newJObject()
  add(query_580301, "fields", newJString(fields))
  add(query_580301, "quotaUser", newJString(quotaUser))
  add(query_580301, "alt", newJString(alt))
  add(query_580301, "oauth_token", newJString(oauthToken))
  add(path_580300, "accountId", newJString(accountId))
  add(query_580301, "userIp", newJString(userIp))
  add(query_580301, "key", newJString(key))
  add(path_580300, "configId", newJString(configId))
  if body != nil:
    body_580302 = body
  add(query_580301, "prettyPrint", newJBool(prettyPrint))
  result = call_580299.call(path_580300, query_580301, nil, nil, body_580302)

var adexchangebuyerPretargetingConfigUpdate* = Call_AdexchangebuyerPretargetingConfigUpdate_580285(
    name: "adexchangebuyerPretargetingConfigUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigUpdate_580286,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigUpdate_580287,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigGet_580269 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPretargetingConfigGet_580271(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigGet_580270(path: JsonNode;
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
  var valid_580272 = path.getOrDefault("accountId")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "accountId", valid_580272
  var valid_580273 = path.getOrDefault("configId")
  valid_580273 = validateParameter(valid_580273, JString, required = true,
                                 default = nil)
  if valid_580273 != nil:
    section.add "configId", valid_580273
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
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
  var valid_580275 = query.getOrDefault("quotaUser")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "quotaUser", valid_580275
  var valid_580276 = query.getOrDefault("alt")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("json"))
  if valid_580276 != nil:
    section.add "alt", valid_580276
  var valid_580277 = query.getOrDefault("oauth_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "oauth_token", valid_580277
  var valid_580278 = query.getOrDefault("userIp")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "userIp", valid_580278
  var valid_580279 = query.getOrDefault("key")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "key", valid_580279
  var valid_580280 = query.getOrDefault("prettyPrint")
  valid_580280 = validateParameter(valid_580280, JBool, required = false,
                                 default = newJBool(true))
  if valid_580280 != nil:
    section.add "prettyPrint", valid_580280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580281: Call_AdexchangebuyerPretargetingConfigGet_580269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific pretargeting configuration
  ## 
  let valid = call_580281.validator(path, query, header, formData, body)
  let scheme = call_580281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580281.url(scheme.get, call_580281.host, call_580281.base,
                         call_580281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580281, url, valid)

proc call*(call_580282: Call_AdexchangebuyerPretargetingConfigGet_580269;
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
  var path_580283 = newJObject()
  var query_580284 = newJObject()
  add(query_580284, "fields", newJString(fields))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(path_580283, "accountId", newJString(accountId))
  add(query_580284, "userIp", newJString(userIp))
  add(query_580284, "key", newJString(key))
  add(path_580283, "configId", newJString(configId))
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  result = call_580282.call(path_580283, query_580284, nil, nil, nil)

var adexchangebuyerPretargetingConfigGet* = Call_AdexchangebuyerPretargetingConfigGet_580269(
    name: "adexchangebuyerPretargetingConfigGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigGet_580270,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigGet_580271,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigPatch_580319 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPretargetingConfigPatch_580321(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigPatch_580320(path: JsonNode;
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
  var valid_580322 = path.getOrDefault("accountId")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "accountId", valid_580322
  var valid_580323 = path.getOrDefault("configId")
  valid_580323 = validateParameter(valid_580323, JString, required = true,
                                 default = nil)
  if valid_580323 != nil:
    section.add "configId", valid_580323
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
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("oauth_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "oauth_token", valid_580327
  var valid_580328 = query.getOrDefault("userIp")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "userIp", valid_580328
  var valid_580329 = query.getOrDefault("key")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "key", valid_580329
  var valid_580330 = query.getOrDefault("prettyPrint")
  valid_580330 = validateParameter(valid_580330, JBool, required = false,
                                 default = newJBool(true))
  if valid_580330 != nil:
    section.add "prettyPrint", valid_580330
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

proc call*(call_580332: Call_AdexchangebuyerPretargetingConfigPatch_580319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  let valid = call_580332.validator(path, query, header, formData, body)
  let scheme = call_580332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580332.url(scheme.get, call_580332.host, call_580332.base,
                         call_580332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580332, url, valid)

proc call*(call_580333: Call_AdexchangebuyerPretargetingConfigPatch_580319;
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
  var path_580334 = newJObject()
  var query_580335 = newJObject()
  var body_580336 = newJObject()
  add(query_580335, "fields", newJString(fields))
  add(query_580335, "quotaUser", newJString(quotaUser))
  add(query_580335, "alt", newJString(alt))
  add(query_580335, "oauth_token", newJString(oauthToken))
  add(path_580334, "accountId", newJString(accountId))
  add(query_580335, "userIp", newJString(userIp))
  add(query_580335, "key", newJString(key))
  add(path_580334, "configId", newJString(configId))
  if body != nil:
    body_580336 = body
  add(query_580335, "prettyPrint", newJBool(prettyPrint))
  result = call_580333.call(path_580334, query_580335, nil, nil, body_580336)

var adexchangebuyerPretargetingConfigPatch* = Call_AdexchangebuyerPretargetingConfigPatch_580319(
    name: "adexchangebuyerPretargetingConfigPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigPatch_580320,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigPatch_580321,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigDelete_580303 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPretargetingConfigDelete_580305(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigDelete_580304(path: JsonNode;
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
  var valid_580306 = path.getOrDefault("accountId")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "accountId", valid_580306
  var valid_580307 = path.getOrDefault("configId")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "configId", valid_580307
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
  var valid_580308 = query.getOrDefault("fields")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "fields", valid_580308
  var valid_580309 = query.getOrDefault("quotaUser")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "quotaUser", valid_580309
  var valid_580310 = query.getOrDefault("alt")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("json"))
  if valid_580310 != nil:
    section.add "alt", valid_580310
  var valid_580311 = query.getOrDefault("oauth_token")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "oauth_token", valid_580311
  var valid_580312 = query.getOrDefault("userIp")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "userIp", valid_580312
  var valid_580313 = query.getOrDefault("key")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "key", valid_580313
  var valid_580314 = query.getOrDefault("prettyPrint")
  valid_580314 = validateParameter(valid_580314, JBool, required = false,
                                 default = newJBool(true))
  if valid_580314 != nil:
    section.add "prettyPrint", valid_580314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580315: Call_AdexchangebuyerPretargetingConfigDelete_580303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing pretargeting config.
  ## 
  let valid = call_580315.validator(path, query, header, formData, body)
  let scheme = call_580315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580315.url(scheme.get, call_580315.host, call_580315.base,
                         call_580315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580315, url, valid)

proc call*(call_580316: Call_AdexchangebuyerPretargetingConfigDelete_580303;
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
  var path_580317 = newJObject()
  var query_580318 = newJObject()
  add(query_580318, "fields", newJString(fields))
  add(query_580318, "quotaUser", newJString(quotaUser))
  add(query_580318, "alt", newJString(alt))
  add(query_580318, "oauth_token", newJString(oauthToken))
  add(path_580317, "accountId", newJString(accountId))
  add(query_580318, "userIp", newJString(userIp))
  add(query_580318, "key", newJString(key))
  add(path_580317, "configId", newJString(configId))
  add(query_580318, "prettyPrint", newJBool(prettyPrint))
  result = call_580316.call(path_580317, query_580318, nil, nil, nil)

var adexchangebuyerPretargetingConfigDelete* = Call_AdexchangebuyerPretargetingConfigDelete_580303(
    name: "adexchangebuyerPretargetingConfigDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigDelete_580304,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigDelete_580305,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580337 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580339(
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

proc validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580338(
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
  var valid_580340 = path.getOrDefault("privateAuctionId")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "privateAuctionId", valid_580340
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
  var valid_580341 = query.getOrDefault("fields")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "fields", valid_580341
  var valid_580342 = query.getOrDefault("quotaUser")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "quotaUser", valid_580342
  var valid_580343 = query.getOrDefault("alt")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = newJString("json"))
  if valid_580343 != nil:
    section.add "alt", valid_580343
  var valid_580344 = query.getOrDefault("oauth_token")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "oauth_token", valid_580344
  var valid_580345 = query.getOrDefault("userIp")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "userIp", valid_580345
  var valid_580346 = query.getOrDefault("key")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "key", valid_580346
  var valid_580347 = query.getOrDefault("prettyPrint")
  valid_580347 = validateParameter(valid_580347, JBool, required = false,
                                 default = newJBool(true))
  if valid_580347 != nil:
    section.add "prettyPrint", valid_580347
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

proc call*(call_580349: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a given private auction proposal
  ## 
  let valid = call_580349.validator(path, query, header, formData, body)
  let scheme = call_580349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580349.url(scheme.get, call_580349.host, call_580349.base,
                         call_580349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580349, url, valid)

proc call*(call_580350: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580337;
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
  var path_580351 = newJObject()
  var query_580352 = newJObject()
  var body_580353 = newJObject()
  add(query_580352, "fields", newJString(fields))
  add(query_580352, "quotaUser", newJString(quotaUser))
  add(query_580352, "alt", newJString(alt))
  add(query_580352, "oauth_token", newJString(oauthToken))
  add(query_580352, "userIp", newJString(userIp))
  add(query_580352, "key", newJString(key))
  if body != nil:
    body_580353 = body
  add(query_580352, "prettyPrint", newJBool(prettyPrint))
  add(path_580351, "privateAuctionId", newJString(privateAuctionId))
  result = call_580350.call(path_580351, query_580352, nil, nil, body_580353)

var adexchangebuyerMarketplaceprivateauctionUpdateproposal* = Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580337(
    name: "adexchangebuyerMarketplaceprivateauctionUpdateproposal",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/privateauction/{privateAuctionId}/updateproposal",
    validator: validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580338,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_580339,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsSearch_580354 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProductsSearch_580356(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProductsSearch_580355(path: JsonNode; query: JsonNode;
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
  var valid_580357 = query.getOrDefault("fields")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "fields", valid_580357
  var valid_580358 = query.getOrDefault("quotaUser")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "quotaUser", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("pqlQuery")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "pqlQuery", valid_580360
  var valid_580361 = query.getOrDefault("oauth_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "oauth_token", valid_580361
  var valid_580362 = query.getOrDefault("userIp")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "userIp", valid_580362
  var valid_580363 = query.getOrDefault("key")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "key", valid_580363
  var valid_580364 = query.getOrDefault("prettyPrint")
  valid_580364 = validateParameter(valid_580364, JBool, required = false,
                                 default = newJBool(true))
  if valid_580364 != nil:
    section.add "prettyPrint", valid_580364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580365: Call_AdexchangebuyerProductsSearch_580354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product.
  ## 
  let valid = call_580365.validator(path, query, header, formData, body)
  let scheme = call_580365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580365.url(scheme.get, call_580365.host, call_580365.base,
                         call_580365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580365, url, valid)

proc call*(call_580366: Call_AdexchangebuyerProductsSearch_580354;
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
  var query_580367 = newJObject()
  add(query_580367, "fields", newJString(fields))
  add(query_580367, "quotaUser", newJString(quotaUser))
  add(query_580367, "alt", newJString(alt))
  add(query_580367, "pqlQuery", newJString(pqlQuery))
  add(query_580367, "oauth_token", newJString(oauthToken))
  add(query_580367, "userIp", newJString(userIp))
  add(query_580367, "key", newJString(key))
  add(query_580367, "prettyPrint", newJBool(prettyPrint))
  result = call_580366.call(nil, query_580367, nil, nil, nil)

var adexchangebuyerProductsSearch* = Call_AdexchangebuyerProductsSearch_580354(
    name: "adexchangebuyerProductsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/search",
    validator: validate_AdexchangebuyerProductsSearch_580355,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsSearch_580356,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsGet_580368 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProductsGet_580370(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProductsGet_580369(path: JsonNode; query: JsonNode;
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
  var valid_580371 = path.getOrDefault("productId")
  valid_580371 = validateParameter(valid_580371, JString, required = true,
                                 default = nil)
  if valid_580371 != nil:
    section.add "productId", valid_580371
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
  var valid_580372 = query.getOrDefault("fields")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "fields", valid_580372
  var valid_580373 = query.getOrDefault("quotaUser")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "quotaUser", valid_580373
  var valid_580374 = query.getOrDefault("alt")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = newJString("json"))
  if valid_580374 != nil:
    section.add "alt", valid_580374
  var valid_580375 = query.getOrDefault("oauth_token")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "oauth_token", valid_580375
  var valid_580376 = query.getOrDefault("userIp")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "userIp", valid_580376
  var valid_580377 = query.getOrDefault("key")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "key", valid_580377
  var valid_580378 = query.getOrDefault("prettyPrint")
  valid_580378 = validateParameter(valid_580378, JBool, required = false,
                                 default = newJBool(true))
  if valid_580378 != nil:
    section.add "prettyPrint", valid_580378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580379: Call_AdexchangebuyerProductsGet_580368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product by id.
  ## 
  let valid = call_580379.validator(path, query, header, formData, body)
  let scheme = call_580379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580379.url(scheme.get, call_580379.host, call_580379.base,
                         call_580379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580379, url, valid)

proc call*(call_580380: Call_AdexchangebuyerProductsGet_580368; productId: string;
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
  var path_580381 = newJObject()
  var query_580382 = newJObject()
  add(query_580382, "fields", newJString(fields))
  add(query_580382, "quotaUser", newJString(quotaUser))
  add(query_580382, "alt", newJString(alt))
  add(query_580382, "oauth_token", newJString(oauthToken))
  add(query_580382, "userIp", newJString(userIp))
  add(query_580382, "key", newJString(key))
  add(path_580381, "productId", newJString(productId))
  add(query_580382, "prettyPrint", newJBool(prettyPrint))
  result = call_580380.call(path_580381, query_580382, nil, nil, nil)

var adexchangebuyerProductsGet* = Call_AdexchangebuyerProductsGet_580368(
    name: "adexchangebuyerProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/{productId}",
    validator: validate_AdexchangebuyerProductsGet_580369,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsGet_580370,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsInsert_580383 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProposalsInsert_580385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsInsert_580384(path: JsonNode;
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
  var valid_580386 = query.getOrDefault("fields")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "fields", valid_580386
  var valid_580387 = query.getOrDefault("quotaUser")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "quotaUser", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("oauth_token")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "oauth_token", valid_580389
  var valid_580390 = query.getOrDefault("userIp")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "userIp", valid_580390
  var valid_580391 = query.getOrDefault("key")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "key", valid_580391
  var valid_580392 = query.getOrDefault("prettyPrint")
  valid_580392 = validateParameter(valid_580392, JBool, required = false,
                                 default = newJBool(true))
  if valid_580392 != nil:
    section.add "prettyPrint", valid_580392
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

proc call*(call_580394: Call_AdexchangebuyerProposalsInsert_580383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the given list of proposals
  ## 
  let valid = call_580394.validator(path, query, header, formData, body)
  let scheme = call_580394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580394.url(scheme.get, call_580394.host, call_580394.base,
                         call_580394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580394, url, valid)

proc call*(call_580395: Call_AdexchangebuyerProposalsInsert_580383;
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
  var query_580396 = newJObject()
  var body_580397 = newJObject()
  add(query_580396, "fields", newJString(fields))
  add(query_580396, "quotaUser", newJString(quotaUser))
  add(query_580396, "alt", newJString(alt))
  add(query_580396, "oauth_token", newJString(oauthToken))
  add(query_580396, "userIp", newJString(userIp))
  add(query_580396, "key", newJString(key))
  if body != nil:
    body_580397 = body
  add(query_580396, "prettyPrint", newJBool(prettyPrint))
  result = call_580395.call(nil, query_580396, nil, nil, body_580397)

var adexchangebuyerProposalsInsert* = Call_AdexchangebuyerProposalsInsert_580383(
    name: "adexchangebuyerProposalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/insert",
    validator: validate_AdexchangebuyerProposalsInsert_580384,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsInsert_580385,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSearch_580398 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProposalsSearch_580400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsSearch_580399(path: JsonNode;
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
  var valid_580401 = query.getOrDefault("fields")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "fields", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("pqlQuery")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "pqlQuery", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("userIp")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "userIp", valid_580406
  var valid_580407 = query.getOrDefault("key")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "key", valid_580407
  var valid_580408 = query.getOrDefault("prettyPrint")
  valid_580408 = validateParameter(valid_580408, JBool, required = false,
                                 default = newJBool(true))
  if valid_580408 != nil:
    section.add "prettyPrint", valid_580408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580409: Call_AdexchangebuyerProposalsSearch_580398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for proposals using pql query
  ## 
  let valid = call_580409.validator(path, query, header, formData, body)
  let scheme = call_580409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580409.url(scheme.get, call_580409.host, call_580409.base,
                         call_580409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580409, url, valid)

proc call*(call_580410: Call_AdexchangebuyerProposalsSearch_580398;
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
  var query_580411 = newJObject()
  add(query_580411, "fields", newJString(fields))
  add(query_580411, "quotaUser", newJString(quotaUser))
  add(query_580411, "alt", newJString(alt))
  add(query_580411, "pqlQuery", newJString(pqlQuery))
  add(query_580411, "oauth_token", newJString(oauthToken))
  add(query_580411, "userIp", newJString(userIp))
  add(query_580411, "key", newJString(key))
  add(query_580411, "prettyPrint", newJBool(prettyPrint))
  result = call_580410.call(nil, query_580411, nil, nil, nil)

var adexchangebuyerProposalsSearch* = Call_AdexchangebuyerProposalsSearch_580398(
    name: "adexchangebuyerProposalsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/search",
    validator: validate_AdexchangebuyerProposalsSearch_580399,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSearch_580400,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsGet_580412 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProposalsGet_580414(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProposalsGet_580413(path: JsonNode; query: JsonNode;
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
  var valid_580415 = path.getOrDefault("proposalId")
  valid_580415 = validateParameter(valid_580415, JString, required = true,
                                 default = nil)
  if valid_580415 != nil:
    section.add "proposalId", valid_580415
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
  var valid_580416 = query.getOrDefault("fields")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "fields", valid_580416
  var valid_580417 = query.getOrDefault("quotaUser")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "quotaUser", valid_580417
  var valid_580418 = query.getOrDefault("alt")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("json"))
  if valid_580418 != nil:
    section.add "alt", valid_580418
  var valid_580419 = query.getOrDefault("oauth_token")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "oauth_token", valid_580419
  var valid_580420 = query.getOrDefault("userIp")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "userIp", valid_580420
  var valid_580421 = query.getOrDefault("key")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "key", valid_580421
  var valid_580422 = query.getOrDefault("prettyPrint")
  valid_580422 = validateParameter(valid_580422, JBool, required = false,
                                 default = newJBool(true))
  if valid_580422 != nil:
    section.add "prettyPrint", valid_580422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580423: Call_AdexchangebuyerProposalsGet_580412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a proposal given its id
  ## 
  let valid = call_580423.validator(path, query, header, formData, body)
  let scheme = call_580423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580423.url(scheme.get, call_580423.host, call_580423.base,
                         call_580423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580423, url, valid)

proc call*(call_580424: Call_AdexchangebuyerProposalsGet_580412;
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
  var path_580425 = newJObject()
  var query_580426 = newJObject()
  add(query_580426, "fields", newJString(fields))
  add(query_580426, "quotaUser", newJString(quotaUser))
  add(query_580426, "alt", newJString(alt))
  add(path_580425, "proposalId", newJString(proposalId))
  add(query_580426, "oauth_token", newJString(oauthToken))
  add(query_580426, "userIp", newJString(userIp))
  add(query_580426, "key", newJString(key))
  add(query_580426, "prettyPrint", newJBool(prettyPrint))
  result = call_580424.call(path_580425, query_580426, nil, nil, nil)

var adexchangebuyerProposalsGet* = Call_AdexchangebuyerProposalsGet_580412(
    name: "adexchangebuyerProposalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}",
    validator: validate_AdexchangebuyerProposalsGet_580413,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsGet_580414,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsList_580427 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerMarketplacedealsList_580429(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerMarketplacedealsList_580428(path: JsonNode;
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
  var valid_580430 = path.getOrDefault("proposalId")
  valid_580430 = validateParameter(valid_580430, JString, required = true,
                                 default = nil)
  if valid_580430 != nil:
    section.add "proposalId", valid_580430
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
  var valid_580431 = query.getOrDefault("fields")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "fields", valid_580431
  var valid_580432 = query.getOrDefault("quotaUser")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "quotaUser", valid_580432
  var valid_580433 = query.getOrDefault("alt")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("json"))
  if valid_580433 != nil:
    section.add "alt", valid_580433
  var valid_580434 = query.getOrDefault("pqlQuery")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "pqlQuery", valid_580434
  var valid_580435 = query.getOrDefault("oauth_token")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "oauth_token", valid_580435
  var valid_580436 = query.getOrDefault("userIp")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "userIp", valid_580436
  var valid_580437 = query.getOrDefault("key")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "key", valid_580437
  var valid_580438 = query.getOrDefault("prettyPrint")
  valid_580438 = validateParameter(valid_580438, JBool, required = false,
                                 default = newJBool(true))
  if valid_580438 != nil:
    section.add "prettyPrint", valid_580438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580439: Call_AdexchangebuyerMarketplacedealsList_580427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the deals for a given proposal
  ## 
  let valid = call_580439.validator(path, query, header, formData, body)
  let scheme = call_580439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580439.url(scheme.get, call_580439.host, call_580439.base,
                         call_580439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580439, url, valid)

proc call*(call_580440: Call_AdexchangebuyerMarketplacedealsList_580427;
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
  var path_580441 = newJObject()
  var query_580442 = newJObject()
  add(query_580442, "fields", newJString(fields))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(query_580442, "alt", newJString(alt))
  add(query_580442, "pqlQuery", newJString(pqlQuery))
  add(path_580441, "proposalId", newJString(proposalId))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(query_580442, "userIp", newJString(userIp))
  add(query_580442, "key", newJString(key))
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  result = call_580440.call(path_580441, query_580442, nil, nil, nil)

var adexchangebuyerMarketplacedealsList* = Call_AdexchangebuyerMarketplacedealsList_580427(
    name: "adexchangebuyerMarketplacedealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals",
    validator: validate_AdexchangebuyerMarketplacedealsList_580428,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsList_580429,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsDelete_580443 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerMarketplacedealsDelete_580445(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacedealsDelete_580444(path: JsonNode;
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
  var valid_580446 = path.getOrDefault("proposalId")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "proposalId", valid_580446
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
  var valid_580447 = query.getOrDefault("fields")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "fields", valid_580447
  var valid_580448 = query.getOrDefault("quotaUser")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "quotaUser", valid_580448
  var valid_580449 = query.getOrDefault("alt")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = newJString("json"))
  if valid_580449 != nil:
    section.add "alt", valid_580449
  var valid_580450 = query.getOrDefault("oauth_token")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "oauth_token", valid_580450
  var valid_580451 = query.getOrDefault("userIp")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "userIp", valid_580451
  var valid_580452 = query.getOrDefault("key")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "key", valid_580452
  var valid_580453 = query.getOrDefault("prettyPrint")
  valid_580453 = validateParameter(valid_580453, JBool, required = false,
                                 default = newJBool(true))
  if valid_580453 != nil:
    section.add "prettyPrint", valid_580453
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

proc call*(call_580455: Call_AdexchangebuyerMarketplacedealsDelete_580443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified deals from the proposal
  ## 
  let valid = call_580455.validator(path, query, header, formData, body)
  let scheme = call_580455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580455.url(scheme.get, call_580455.host, call_580455.base,
                         call_580455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580455, url, valid)

proc call*(call_580456: Call_AdexchangebuyerMarketplacedealsDelete_580443;
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
  var path_580457 = newJObject()
  var query_580458 = newJObject()
  var body_580459 = newJObject()
  add(query_580458, "fields", newJString(fields))
  add(query_580458, "quotaUser", newJString(quotaUser))
  add(query_580458, "alt", newJString(alt))
  add(path_580457, "proposalId", newJString(proposalId))
  add(query_580458, "oauth_token", newJString(oauthToken))
  add(query_580458, "userIp", newJString(userIp))
  add(query_580458, "key", newJString(key))
  if body != nil:
    body_580459 = body
  add(query_580458, "prettyPrint", newJBool(prettyPrint))
  result = call_580456.call(path_580457, query_580458, nil, nil, body_580459)

var adexchangebuyerMarketplacedealsDelete* = Call_AdexchangebuyerMarketplacedealsDelete_580443(
    name: "adexchangebuyerMarketplacedealsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/delete",
    validator: validate_AdexchangebuyerMarketplacedealsDelete_580444,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsDelete_580445,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsInsert_580460 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerMarketplacedealsInsert_580462(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacedealsInsert_580461(path: JsonNode;
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
  var valid_580463 = path.getOrDefault("proposalId")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = nil)
  if valid_580463 != nil:
    section.add "proposalId", valid_580463
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
  var valid_580464 = query.getOrDefault("fields")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "fields", valid_580464
  var valid_580465 = query.getOrDefault("quotaUser")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "quotaUser", valid_580465
  var valid_580466 = query.getOrDefault("alt")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = newJString("json"))
  if valid_580466 != nil:
    section.add "alt", valid_580466
  var valid_580467 = query.getOrDefault("oauth_token")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "oauth_token", valid_580467
  var valid_580468 = query.getOrDefault("userIp")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "userIp", valid_580468
  var valid_580469 = query.getOrDefault("key")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "key", valid_580469
  var valid_580470 = query.getOrDefault("prettyPrint")
  valid_580470 = validateParameter(valid_580470, JBool, required = false,
                                 default = newJBool(true))
  if valid_580470 != nil:
    section.add "prettyPrint", valid_580470
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

proc call*(call_580472: Call_AdexchangebuyerMarketplacedealsInsert_580460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add new deals for the specified proposal
  ## 
  let valid = call_580472.validator(path, query, header, formData, body)
  let scheme = call_580472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580472.url(scheme.get, call_580472.host, call_580472.base,
                         call_580472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580472, url, valid)

proc call*(call_580473: Call_AdexchangebuyerMarketplacedealsInsert_580460;
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
  var path_580474 = newJObject()
  var query_580475 = newJObject()
  var body_580476 = newJObject()
  add(query_580475, "fields", newJString(fields))
  add(query_580475, "quotaUser", newJString(quotaUser))
  add(query_580475, "alt", newJString(alt))
  add(path_580474, "proposalId", newJString(proposalId))
  add(query_580475, "oauth_token", newJString(oauthToken))
  add(query_580475, "userIp", newJString(userIp))
  add(query_580475, "key", newJString(key))
  if body != nil:
    body_580476 = body
  add(query_580475, "prettyPrint", newJBool(prettyPrint))
  result = call_580473.call(path_580474, query_580475, nil, nil, body_580476)

var adexchangebuyerMarketplacedealsInsert* = Call_AdexchangebuyerMarketplacedealsInsert_580460(
    name: "adexchangebuyerMarketplacedealsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/insert",
    validator: validate_AdexchangebuyerMarketplacedealsInsert_580461,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsInsert_580462,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsUpdate_580477 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerMarketplacedealsUpdate_580479(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacedealsUpdate_580478(path: JsonNode;
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
  var valid_580480 = path.getOrDefault("proposalId")
  valid_580480 = validateParameter(valid_580480, JString, required = true,
                                 default = nil)
  if valid_580480 != nil:
    section.add "proposalId", valid_580480
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
  var valid_580481 = query.getOrDefault("fields")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "fields", valid_580481
  var valid_580482 = query.getOrDefault("quotaUser")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "quotaUser", valid_580482
  var valid_580483 = query.getOrDefault("alt")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = newJString("json"))
  if valid_580483 != nil:
    section.add "alt", valid_580483
  var valid_580484 = query.getOrDefault("oauth_token")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "oauth_token", valid_580484
  var valid_580485 = query.getOrDefault("userIp")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "userIp", valid_580485
  var valid_580486 = query.getOrDefault("key")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "key", valid_580486
  var valid_580487 = query.getOrDefault("prettyPrint")
  valid_580487 = validateParameter(valid_580487, JBool, required = false,
                                 default = newJBool(true))
  if valid_580487 != nil:
    section.add "prettyPrint", valid_580487
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

proc call*(call_580489: Call_AdexchangebuyerMarketplacedealsUpdate_580477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces all the deals in the proposal with the passed in deals
  ## 
  let valid = call_580489.validator(path, query, header, formData, body)
  let scheme = call_580489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580489.url(scheme.get, call_580489.host, call_580489.base,
                         call_580489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580489, url, valid)

proc call*(call_580490: Call_AdexchangebuyerMarketplacedealsUpdate_580477;
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
  var path_580491 = newJObject()
  var query_580492 = newJObject()
  var body_580493 = newJObject()
  add(query_580492, "fields", newJString(fields))
  add(query_580492, "quotaUser", newJString(quotaUser))
  add(query_580492, "alt", newJString(alt))
  add(path_580491, "proposalId", newJString(proposalId))
  add(query_580492, "oauth_token", newJString(oauthToken))
  add(query_580492, "userIp", newJString(userIp))
  add(query_580492, "key", newJString(key))
  if body != nil:
    body_580493 = body
  add(query_580492, "prettyPrint", newJBool(prettyPrint))
  result = call_580490.call(path_580491, query_580492, nil, nil, body_580493)

var adexchangebuyerMarketplacedealsUpdate* = Call_AdexchangebuyerMarketplacedealsUpdate_580477(
    name: "adexchangebuyerMarketplacedealsUpdate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/update",
    validator: validate_AdexchangebuyerMarketplacedealsUpdate_580478,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsUpdate_580479,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesList_580494 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerMarketplacenotesList_580496(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerMarketplacenotesList_580495(path: JsonNode;
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
  var valid_580497 = path.getOrDefault("proposalId")
  valid_580497 = validateParameter(valid_580497, JString, required = true,
                                 default = nil)
  if valid_580497 != nil:
    section.add "proposalId", valid_580497
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
  var valid_580498 = query.getOrDefault("fields")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "fields", valid_580498
  var valid_580499 = query.getOrDefault("quotaUser")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "quotaUser", valid_580499
  var valid_580500 = query.getOrDefault("alt")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = newJString("json"))
  if valid_580500 != nil:
    section.add "alt", valid_580500
  var valid_580501 = query.getOrDefault("pqlQuery")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "pqlQuery", valid_580501
  var valid_580502 = query.getOrDefault("oauth_token")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "oauth_token", valid_580502
  var valid_580503 = query.getOrDefault("userIp")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "userIp", valid_580503
  var valid_580504 = query.getOrDefault("key")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "key", valid_580504
  var valid_580505 = query.getOrDefault("prettyPrint")
  valid_580505 = validateParameter(valid_580505, JBool, required = false,
                                 default = newJBool(true))
  if valid_580505 != nil:
    section.add "prettyPrint", valid_580505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580506: Call_AdexchangebuyerMarketplacenotesList_580494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the notes associated with a proposal
  ## 
  let valid = call_580506.validator(path, query, header, formData, body)
  let scheme = call_580506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580506.url(scheme.get, call_580506.host, call_580506.base,
                         call_580506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580506, url, valid)

proc call*(call_580507: Call_AdexchangebuyerMarketplacenotesList_580494;
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
  var path_580508 = newJObject()
  var query_580509 = newJObject()
  add(query_580509, "fields", newJString(fields))
  add(query_580509, "quotaUser", newJString(quotaUser))
  add(query_580509, "alt", newJString(alt))
  add(query_580509, "pqlQuery", newJString(pqlQuery))
  add(path_580508, "proposalId", newJString(proposalId))
  add(query_580509, "oauth_token", newJString(oauthToken))
  add(query_580509, "userIp", newJString(userIp))
  add(query_580509, "key", newJString(key))
  add(query_580509, "prettyPrint", newJBool(prettyPrint))
  result = call_580507.call(path_580508, query_580509, nil, nil, nil)

var adexchangebuyerMarketplacenotesList* = Call_AdexchangebuyerMarketplacenotesList_580494(
    name: "adexchangebuyerMarketplacenotesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes",
    validator: validate_AdexchangebuyerMarketplacenotesList_580495,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesList_580496,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesInsert_580510 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerMarketplacenotesInsert_580512(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacenotesInsert_580511(path: JsonNode;
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
  var valid_580513 = path.getOrDefault("proposalId")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "proposalId", valid_580513
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
  var valid_580514 = query.getOrDefault("fields")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "fields", valid_580514
  var valid_580515 = query.getOrDefault("quotaUser")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "quotaUser", valid_580515
  var valid_580516 = query.getOrDefault("alt")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = newJString("json"))
  if valid_580516 != nil:
    section.add "alt", valid_580516
  var valid_580517 = query.getOrDefault("oauth_token")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "oauth_token", valid_580517
  var valid_580518 = query.getOrDefault("userIp")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "userIp", valid_580518
  var valid_580519 = query.getOrDefault("key")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "key", valid_580519
  var valid_580520 = query.getOrDefault("prettyPrint")
  valid_580520 = validateParameter(valid_580520, JBool, required = false,
                                 default = newJBool(true))
  if valid_580520 != nil:
    section.add "prettyPrint", valid_580520
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

proc call*(call_580522: Call_AdexchangebuyerMarketplacenotesInsert_580510;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add notes to the proposal
  ## 
  let valid = call_580522.validator(path, query, header, formData, body)
  let scheme = call_580522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580522.url(scheme.get, call_580522.host, call_580522.base,
                         call_580522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580522, url, valid)

proc call*(call_580523: Call_AdexchangebuyerMarketplacenotesInsert_580510;
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
  var path_580524 = newJObject()
  var query_580525 = newJObject()
  var body_580526 = newJObject()
  add(query_580525, "fields", newJString(fields))
  add(query_580525, "quotaUser", newJString(quotaUser))
  add(query_580525, "alt", newJString(alt))
  add(path_580524, "proposalId", newJString(proposalId))
  add(query_580525, "oauth_token", newJString(oauthToken))
  add(query_580525, "userIp", newJString(userIp))
  add(query_580525, "key", newJString(key))
  if body != nil:
    body_580526 = body
  add(query_580525, "prettyPrint", newJBool(prettyPrint))
  result = call_580523.call(path_580524, query_580525, nil, nil, body_580526)

var adexchangebuyerMarketplacenotesInsert* = Call_AdexchangebuyerMarketplacenotesInsert_580510(
    name: "adexchangebuyerMarketplacenotesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes/insert",
    validator: validate_AdexchangebuyerMarketplacenotesInsert_580511,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesInsert_580512,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSetupcomplete_580527 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProposalsSetupcomplete_580529(protocol: Scheme;
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

proc validate_AdexchangebuyerProposalsSetupcomplete_580528(path: JsonNode;
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
  var valid_580530 = path.getOrDefault("proposalId")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "proposalId", valid_580530
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
  var valid_580531 = query.getOrDefault("fields")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "fields", valid_580531
  var valid_580532 = query.getOrDefault("quotaUser")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "quotaUser", valid_580532
  var valid_580533 = query.getOrDefault("alt")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = newJString("json"))
  if valid_580533 != nil:
    section.add "alt", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("userIp")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "userIp", valid_580535
  var valid_580536 = query.getOrDefault("key")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "key", valid_580536
  var valid_580537 = query.getOrDefault("prettyPrint")
  valid_580537 = validateParameter(valid_580537, JBool, required = false,
                                 default = newJBool(true))
  if valid_580537 != nil:
    section.add "prettyPrint", valid_580537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580538: Call_AdexchangebuyerProposalsSetupcomplete_580527;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the given proposal to indicate that setup has been completed.
  ## 
  let valid = call_580538.validator(path, query, header, formData, body)
  let scheme = call_580538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580538.url(scheme.get, call_580538.host, call_580538.base,
                         call_580538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580538, url, valid)

proc call*(call_580539: Call_AdexchangebuyerProposalsSetupcomplete_580527;
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
  var path_580540 = newJObject()
  var query_580541 = newJObject()
  add(query_580541, "fields", newJString(fields))
  add(query_580541, "quotaUser", newJString(quotaUser))
  add(query_580541, "alt", newJString(alt))
  add(path_580540, "proposalId", newJString(proposalId))
  add(query_580541, "oauth_token", newJString(oauthToken))
  add(query_580541, "userIp", newJString(userIp))
  add(query_580541, "key", newJString(key))
  add(query_580541, "prettyPrint", newJBool(prettyPrint))
  result = call_580539.call(path_580540, query_580541, nil, nil, nil)

var adexchangebuyerProposalsSetupcomplete* = Call_AdexchangebuyerProposalsSetupcomplete_580527(
    name: "adexchangebuyerProposalsSetupcomplete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/setupcomplete",
    validator: validate_AdexchangebuyerProposalsSetupcomplete_580528,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSetupcomplete_580529,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsUpdate_580542 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProposalsUpdate_580544(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProposalsUpdate_580543(path: JsonNode;
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
  var valid_580545 = path.getOrDefault("updateAction")
  valid_580545 = validateParameter(valid_580545, JString, required = true,
                                 default = newJString("accept"))
  if valid_580545 != nil:
    section.add "updateAction", valid_580545
  var valid_580546 = path.getOrDefault("proposalId")
  valid_580546 = validateParameter(valid_580546, JString, required = true,
                                 default = nil)
  if valid_580546 != nil:
    section.add "proposalId", valid_580546
  var valid_580547 = path.getOrDefault("revisionNumber")
  valid_580547 = validateParameter(valid_580547, JString, required = true,
                                 default = nil)
  if valid_580547 != nil:
    section.add "revisionNumber", valid_580547
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
  var valid_580548 = query.getOrDefault("fields")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "fields", valid_580548
  var valid_580549 = query.getOrDefault("quotaUser")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "quotaUser", valid_580549
  var valid_580550 = query.getOrDefault("alt")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = newJString("json"))
  if valid_580550 != nil:
    section.add "alt", valid_580550
  var valid_580551 = query.getOrDefault("oauth_token")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "oauth_token", valid_580551
  var valid_580552 = query.getOrDefault("userIp")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "userIp", valid_580552
  var valid_580553 = query.getOrDefault("key")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "key", valid_580553
  var valid_580554 = query.getOrDefault("prettyPrint")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(true))
  if valid_580554 != nil:
    section.add "prettyPrint", valid_580554
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

proc call*(call_580556: Call_AdexchangebuyerProposalsUpdate_580542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal
  ## 
  let valid = call_580556.validator(path, query, header, formData, body)
  let scheme = call_580556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580556.url(scheme.get, call_580556.host, call_580556.base,
                         call_580556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580556, url, valid)

proc call*(call_580557: Call_AdexchangebuyerProposalsUpdate_580542;
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
  var path_580558 = newJObject()
  var query_580559 = newJObject()
  var body_580560 = newJObject()
  add(path_580558, "updateAction", newJString(updateAction))
  add(query_580559, "fields", newJString(fields))
  add(query_580559, "quotaUser", newJString(quotaUser))
  add(query_580559, "alt", newJString(alt))
  add(path_580558, "proposalId", newJString(proposalId))
  add(path_580558, "revisionNumber", newJString(revisionNumber))
  add(query_580559, "oauth_token", newJString(oauthToken))
  add(query_580559, "userIp", newJString(userIp))
  add(query_580559, "key", newJString(key))
  if body != nil:
    body_580560 = body
  add(query_580559, "prettyPrint", newJBool(prettyPrint))
  result = call_580557.call(path_580558, query_580559, nil, nil, body_580560)

var adexchangebuyerProposalsUpdate* = Call_AdexchangebuyerProposalsUpdate_580542(
    name: "adexchangebuyerProposalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsUpdate_580543,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsUpdate_580544,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsPatch_580561 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerProposalsPatch_580563(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProposalsPatch_580562(path: JsonNode; query: JsonNode;
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
  var valid_580564 = path.getOrDefault("updateAction")
  valid_580564 = validateParameter(valid_580564, JString, required = true,
                                 default = newJString("accept"))
  if valid_580564 != nil:
    section.add "updateAction", valid_580564
  var valid_580565 = path.getOrDefault("proposalId")
  valid_580565 = validateParameter(valid_580565, JString, required = true,
                                 default = nil)
  if valid_580565 != nil:
    section.add "proposalId", valid_580565
  var valid_580566 = path.getOrDefault("revisionNumber")
  valid_580566 = validateParameter(valid_580566, JString, required = true,
                                 default = nil)
  if valid_580566 != nil:
    section.add "revisionNumber", valid_580566
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
  var valid_580567 = query.getOrDefault("fields")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "fields", valid_580567
  var valid_580568 = query.getOrDefault("quotaUser")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "quotaUser", valid_580568
  var valid_580569 = query.getOrDefault("alt")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = newJString("json"))
  if valid_580569 != nil:
    section.add "alt", valid_580569
  var valid_580570 = query.getOrDefault("oauth_token")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "oauth_token", valid_580570
  var valid_580571 = query.getOrDefault("userIp")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "userIp", valid_580571
  var valid_580572 = query.getOrDefault("key")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "key", valid_580572
  var valid_580573 = query.getOrDefault("prettyPrint")
  valid_580573 = validateParameter(valid_580573, JBool, required = false,
                                 default = newJBool(true))
  if valid_580573 != nil:
    section.add "prettyPrint", valid_580573
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

proc call*(call_580575: Call_AdexchangebuyerProposalsPatch_580561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal. This method supports patch semantics.
  ## 
  let valid = call_580575.validator(path, query, header, formData, body)
  let scheme = call_580575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580575.url(scheme.get, call_580575.host, call_580575.base,
                         call_580575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580575, url, valid)

proc call*(call_580576: Call_AdexchangebuyerProposalsPatch_580561;
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
  var path_580577 = newJObject()
  var query_580578 = newJObject()
  var body_580579 = newJObject()
  add(path_580577, "updateAction", newJString(updateAction))
  add(query_580578, "fields", newJString(fields))
  add(query_580578, "quotaUser", newJString(quotaUser))
  add(query_580578, "alt", newJString(alt))
  add(path_580577, "proposalId", newJString(proposalId))
  add(path_580577, "revisionNumber", newJString(revisionNumber))
  add(query_580578, "oauth_token", newJString(oauthToken))
  add(query_580578, "userIp", newJString(userIp))
  add(query_580578, "key", newJString(key))
  if body != nil:
    body_580579 = body
  add(query_580578, "prettyPrint", newJBool(prettyPrint))
  result = call_580576.call(path_580577, query_580578, nil, nil, body_580579)

var adexchangebuyerProposalsPatch* = Call_AdexchangebuyerProposalsPatch_580561(
    name: "adexchangebuyerProposalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsPatch_580562,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsPatch_580563,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPubprofilesList_580580 = ref object of OpenApiRestCall_579437
proc url_AdexchangebuyerPubprofilesList_580582(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerPubprofilesList_580581(path: JsonNode;
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
  var valid_580583 = path.getOrDefault("accountId")
  valid_580583 = validateParameter(valid_580583, JInt, required = true, default = nil)
  if valid_580583 != nil:
    section.add "accountId", valid_580583
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
  var valid_580584 = query.getOrDefault("fields")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "fields", valid_580584
  var valid_580585 = query.getOrDefault("quotaUser")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "quotaUser", valid_580585
  var valid_580586 = query.getOrDefault("alt")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = newJString("json"))
  if valid_580586 != nil:
    section.add "alt", valid_580586
  var valid_580587 = query.getOrDefault("oauth_token")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "oauth_token", valid_580587
  var valid_580588 = query.getOrDefault("userIp")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "userIp", valid_580588
  var valid_580589 = query.getOrDefault("key")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "key", valid_580589
  var valid_580590 = query.getOrDefault("prettyPrint")
  valid_580590 = validateParameter(valid_580590, JBool, required = false,
                                 default = newJBool(true))
  if valid_580590 != nil:
    section.add "prettyPrint", valid_580590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580591: Call_AdexchangebuyerPubprofilesList_580580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested publisher profile(s) by publisher accountId.
  ## 
  let valid = call_580591.validator(path, query, header, formData, body)
  let scheme = call_580591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580591.url(scheme.get, call_580591.host, call_580591.base,
                         call_580591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580591, url, valid)

proc call*(call_580592: Call_AdexchangebuyerPubprofilesList_580580; accountId: int;
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
  var path_580593 = newJObject()
  var query_580594 = newJObject()
  add(query_580594, "fields", newJString(fields))
  add(query_580594, "quotaUser", newJString(quotaUser))
  add(query_580594, "alt", newJString(alt))
  add(query_580594, "oauth_token", newJString(oauthToken))
  add(path_580593, "accountId", newJInt(accountId))
  add(query_580594, "userIp", newJString(userIp))
  add(query_580594, "key", newJString(key))
  add(query_580594, "prettyPrint", newJBool(prettyPrint))
  result = call_580592.call(path_580593, query_580594, nil, nil, nil)

var adexchangebuyerPubprofilesList* = Call_AdexchangebuyerPubprofilesList_580580(
    name: "adexchangebuyerPubprofilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/publisher/{accountId}/profiles",
    validator: validate_AdexchangebuyerPubprofilesList_580581,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPubprofilesList_580582,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
