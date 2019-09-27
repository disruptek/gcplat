
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597437): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangebuyerAccountsList_597706 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerAccountsList_597708(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerAccountsList_597707(path: JsonNode; query: JsonNode;
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
  var valid_597820 = query.getOrDefault("fields")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "fields", valid_597820
  var valid_597821 = query.getOrDefault("quotaUser")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "quotaUser", valid_597821
  var valid_597835 = query.getOrDefault("alt")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = newJString("json"))
  if valid_597835 != nil:
    section.add "alt", valid_597835
  var valid_597836 = query.getOrDefault("oauth_token")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "oauth_token", valid_597836
  var valid_597837 = query.getOrDefault("userIp")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = nil)
  if valid_597837 != nil:
    section.add "userIp", valid_597837
  var valid_597838 = query.getOrDefault("key")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "key", valid_597838
  var valid_597839 = query.getOrDefault("prettyPrint")
  valid_597839 = validateParameter(valid_597839, JBool, required = false,
                                 default = newJBool(true))
  if valid_597839 != nil:
    section.add "prettyPrint", valid_597839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597862: Call_AdexchangebuyerAccountsList_597706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of accounts.
  ## 
  let valid = call_597862.validator(path, query, header, formData, body)
  let scheme = call_597862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597862.url(scheme.get, call_597862.host, call_597862.base,
                         call_597862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597862, url, valid)

proc call*(call_597933: Call_AdexchangebuyerAccountsList_597706;
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
  var query_597934 = newJObject()
  add(query_597934, "fields", newJString(fields))
  add(query_597934, "quotaUser", newJString(quotaUser))
  add(query_597934, "alt", newJString(alt))
  add(query_597934, "oauth_token", newJString(oauthToken))
  add(query_597934, "userIp", newJString(userIp))
  add(query_597934, "key", newJString(key))
  add(query_597934, "prettyPrint", newJBool(prettyPrint))
  result = call_597933.call(nil, query_597934, nil, nil, nil)

var adexchangebuyerAccountsList* = Call_AdexchangebuyerAccountsList_597706(
    name: "adexchangebuyerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangebuyerAccountsList_597707,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsList_597708,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsUpdate_598003 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerAccountsUpdate_598005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerAccountsUpdate_598004(path: JsonNode; query: JsonNode;
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
  var valid_598006 = path.getOrDefault("id")
  valid_598006 = validateParameter(valid_598006, JInt, required = true, default = nil)
  if valid_598006 != nil:
    section.add "id", valid_598006
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
  var valid_598007 = query.getOrDefault("fields")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "fields", valid_598007
  var valid_598008 = query.getOrDefault("quotaUser")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "quotaUser", valid_598008
  var valid_598009 = query.getOrDefault("alt")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = newJString("json"))
  if valid_598009 != nil:
    section.add "alt", valid_598009
  var valid_598010 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_598010 = validateParameter(valid_598010, JBool, required = false, default = nil)
  if valid_598010 != nil:
    section.add "confirmUnsafeAccountChange", valid_598010
  var valid_598011 = query.getOrDefault("oauth_token")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "oauth_token", valid_598011
  var valid_598012 = query.getOrDefault("userIp")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "userIp", valid_598012
  var valid_598013 = query.getOrDefault("key")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "key", valid_598013
  var valid_598014 = query.getOrDefault("prettyPrint")
  valid_598014 = validateParameter(valid_598014, JBool, required = false,
                                 default = newJBool(true))
  if valid_598014 != nil:
    section.add "prettyPrint", valid_598014
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

proc call*(call_598016: Call_AdexchangebuyerAccountsUpdate_598003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account.
  ## 
  let valid = call_598016.validator(path, query, header, formData, body)
  let scheme = call_598016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598016.url(scheme.get, call_598016.host, call_598016.base,
                         call_598016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598016, url, valid)

proc call*(call_598017: Call_AdexchangebuyerAccountsUpdate_598003; id: int;
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
  var path_598018 = newJObject()
  var query_598019 = newJObject()
  var body_598020 = newJObject()
  add(query_598019, "fields", newJString(fields))
  add(query_598019, "quotaUser", newJString(quotaUser))
  add(query_598019, "alt", newJString(alt))
  add(query_598019, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  add(query_598019, "oauth_token", newJString(oauthToken))
  add(query_598019, "userIp", newJString(userIp))
  add(path_598018, "id", newJInt(id))
  add(query_598019, "key", newJString(key))
  if body != nil:
    body_598020 = body
  add(query_598019, "prettyPrint", newJBool(prettyPrint))
  result = call_598017.call(path_598018, query_598019, nil, nil, body_598020)

var adexchangebuyerAccountsUpdate* = Call_AdexchangebuyerAccountsUpdate_598003(
    name: "adexchangebuyerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsUpdate_598004,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsUpdate_598005,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsGet_597974 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerAccountsGet_597976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerAccountsGet_597975(path: JsonNode; query: JsonNode;
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
  var valid_597991 = path.getOrDefault("id")
  valid_597991 = validateParameter(valid_597991, JInt, required = true, default = nil)
  if valid_597991 != nil:
    section.add "id", valid_597991
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
  var valid_597992 = query.getOrDefault("fields")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "fields", valid_597992
  var valid_597993 = query.getOrDefault("quotaUser")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "quotaUser", valid_597993
  var valid_597994 = query.getOrDefault("alt")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = newJString("json"))
  if valid_597994 != nil:
    section.add "alt", valid_597994
  var valid_597995 = query.getOrDefault("oauth_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "oauth_token", valid_597995
  var valid_597996 = query.getOrDefault("userIp")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "userIp", valid_597996
  var valid_597997 = query.getOrDefault("key")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "key", valid_597997
  var valid_597998 = query.getOrDefault("prettyPrint")
  valid_597998 = validateParameter(valid_597998, JBool, required = false,
                                 default = newJBool(true))
  if valid_597998 != nil:
    section.add "prettyPrint", valid_597998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597999: Call_AdexchangebuyerAccountsGet_597974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one account by ID.
  ## 
  let valid = call_597999.validator(path, query, header, formData, body)
  let scheme = call_597999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597999.url(scheme.get, call_597999.host, call_597999.base,
                         call_597999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597999, url, valid)

proc call*(call_598000: Call_AdexchangebuyerAccountsGet_597974; id: int;
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
  var path_598001 = newJObject()
  var query_598002 = newJObject()
  add(query_598002, "fields", newJString(fields))
  add(query_598002, "quotaUser", newJString(quotaUser))
  add(query_598002, "alt", newJString(alt))
  add(query_598002, "oauth_token", newJString(oauthToken))
  add(query_598002, "userIp", newJString(userIp))
  add(path_598001, "id", newJInt(id))
  add(query_598002, "key", newJString(key))
  add(query_598002, "prettyPrint", newJBool(prettyPrint))
  result = call_598000.call(path_598001, query_598002, nil, nil, nil)

var adexchangebuyerAccountsGet* = Call_AdexchangebuyerAccountsGet_597974(
    name: "adexchangebuyerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsGet_597975,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsGet_597976,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsPatch_598021 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerAccountsPatch_598023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerAccountsPatch_598022(path: JsonNode; query: JsonNode;
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
  var valid_598024 = path.getOrDefault("id")
  valid_598024 = validateParameter(valid_598024, JInt, required = true, default = nil)
  if valid_598024 != nil:
    section.add "id", valid_598024
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
  var valid_598025 = query.getOrDefault("fields")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "fields", valid_598025
  var valid_598026 = query.getOrDefault("quotaUser")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "quotaUser", valid_598026
  var valid_598027 = query.getOrDefault("alt")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = newJString("json"))
  if valid_598027 != nil:
    section.add "alt", valid_598027
  var valid_598028 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_598028 = validateParameter(valid_598028, JBool, required = false, default = nil)
  if valid_598028 != nil:
    section.add "confirmUnsafeAccountChange", valid_598028
  var valid_598029 = query.getOrDefault("oauth_token")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "oauth_token", valid_598029
  var valid_598030 = query.getOrDefault("userIp")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "userIp", valid_598030
  var valid_598031 = query.getOrDefault("key")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "key", valid_598031
  var valid_598032 = query.getOrDefault("prettyPrint")
  valid_598032 = validateParameter(valid_598032, JBool, required = false,
                                 default = newJBool(true))
  if valid_598032 != nil:
    section.add "prettyPrint", valid_598032
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

proc call*(call_598034: Call_AdexchangebuyerAccountsPatch_598021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  let valid = call_598034.validator(path, query, header, formData, body)
  let scheme = call_598034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598034.url(scheme.get, call_598034.host, call_598034.base,
                         call_598034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598034, url, valid)

proc call*(call_598035: Call_AdexchangebuyerAccountsPatch_598021; id: int;
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
  var path_598036 = newJObject()
  var query_598037 = newJObject()
  var body_598038 = newJObject()
  add(query_598037, "fields", newJString(fields))
  add(query_598037, "quotaUser", newJString(quotaUser))
  add(query_598037, "alt", newJString(alt))
  add(query_598037, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  add(query_598037, "oauth_token", newJString(oauthToken))
  add(query_598037, "userIp", newJString(userIp))
  add(path_598036, "id", newJInt(id))
  add(query_598037, "key", newJString(key))
  if body != nil:
    body_598038 = body
  add(query_598037, "prettyPrint", newJBool(prettyPrint))
  result = call_598035.call(path_598036, query_598037, nil, nil, body_598038)

var adexchangebuyerAccountsPatch* = Call_AdexchangebuyerAccountsPatch_598021(
    name: "adexchangebuyerAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsPatch_598022,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsPatch_598023,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoList_598039 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerBillingInfoList_598041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerBillingInfoList_598040(path: JsonNode;
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
  var valid_598042 = query.getOrDefault("fields")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "fields", valid_598042
  var valid_598043 = query.getOrDefault("quotaUser")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "quotaUser", valid_598043
  var valid_598044 = query.getOrDefault("alt")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = newJString("json"))
  if valid_598044 != nil:
    section.add "alt", valid_598044
  var valid_598045 = query.getOrDefault("oauth_token")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "oauth_token", valid_598045
  var valid_598046 = query.getOrDefault("userIp")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "userIp", valid_598046
  var valid_598047 = query.getOrDefault("key")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "key", valid_598047
  var valid_598048 = query.getOrDefault("prettyPrint")
  valid_598048 = validateParameter(valid_598048, JBool, required = false,
                                 default = newJBool(true))
  if valid_598048 != nil:
    section.add "prettyPrint", valid_598048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598049: Call_AdexchangebuyerBillingInfoList_598039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
  ## 
  let valid = call_598049.validator(path, query, header, formData, body)
  let scheme = call_598049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598049.url(scheme.get, call_598049.host, call_598049.base,
                         call_598049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598049, url, valid)

proc call*(call_598050: Call_AdexchangebuyerBillingInfoList_598039;
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
  var query_598051 = newJObject()
  add(query_598051, "fields", newJString(fields))
  add(query_598051, "quotaUser", newJString(quotaUser))
  add(query_598051, "alt", newJString(alt))
  add(query_598051, "oauth_token", newJString(oauthToken))
  add(query_598051, "userIp", newJString(userIp))
  add(query_598051, "key", newJString(key))
  add(query_598051, "prettyPrint", newJBool(prettyPrint))
  result = call_598050.call(nil, query_598051, nil, nil, nil)

var adexchangebuyerBillingInfoList* = Call_AdexchangebuyerBillingInfoList_598039(
    name: "adexchangebuyerBillingInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo",
    validator: validate_AdexchangebuyerBillingInfoList_598040,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoList_598041,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoGet_598052 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerBillingInfoGet_598054(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/billinginfo/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerBillingInfoGet_598053(path: JsonNode; query: JsonNode;
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
  var valid_598055 = path.getOrDefault("accountId")
  valid_598055 = validateParameter(valid_598055, JInt, required = true, default = nil)
  if valid_598055 != nil:
    section.add "accountId", valid_598055
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
  var valid_598056 = query.getOrDefault("fields")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "fields", valid_598056
  var valid_598057 = query.getOrDefault("quotaUser")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "quotaUser", valid_598057
  var valid_598058 = query.getOrDefault("alt")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = newJString("json"))
  if valid_598058 != nil:
    section.add "alt", valid_598058
  var valid_598059 = query.getOrDefault("oauth_token")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "oauth_token", valid_598059
  var valid_598060 = query.getOrDefault("userIp")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "userIp", valid_598060
  var valid_598061 = query.getOrDefault("key")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "key", valid_598061
  var valid_598062 = query.getOrDefault("prettyPrint")
  valid_598062 = validateParameter(valid_598062, JBool, required = false,
                                 default = newJBool(true))
  if valid_598062 != nil:
    section.add "prettyPrint", valid_598062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598063: Call_AdexchangebuyerBillingInfoGet_598052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the billing information for one account specified by account ID.
  ## 
  let valid = call_598063.validator(path, query, header, formData, body)
  let scheme = call_598063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598063.url(scheme.get, call_598063.host, call_598063.base,
                         call_598063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598063, url, valid)

proc call*(call_598064: Call_AdexchangebuyerBillingInfoGet_598052; accountId: int;
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
  var path_598065 = newJObject()
  var query_598066 = newJObject()
  add(query_598066, "fields", newJString(fields))
  add(query_598066, "quotaUser", newJString(quotaUser))
  add(query_598066, "alt", newJString(alt))
  add(query_598066, "oauth_token", newJString(oauthToken))
  add(path_598065, "accountId", newJInt(accountId))
  add(query_598066, "userIp", newJString(userIp))
  add(query_598066, "key", newJString(key))
  add(query_598066, "prettyPrint", newJBool(prettyPrint))
  result = call_598064.call(path_598065, query_598066, nil, nil, nil)

var adexchangebuyerBillingInfoGet* = Call_AdexchangebuyerBillingInfoGet_598052(
    name: "adexchangebuyerBillingInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}",
    validator: validate_AdexchangebuyerBillingInfoGet_598053,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoGet_598054,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetUpdate_598083 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerBudgetUpdate_598085(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerBudgetUpdate_598084(path: JsonNode; query: JsonNode;
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
  var valid_598086 = path.getOrDefault("billingId")
  valid_598086 = validateParameter(valid_598086, JString, required = true,
                                 default = nil)
  if valid_598086 != nil:
    section.add "billingId", valid_598086
  var valid_598087 = path.getOrDefault("accountId")
  valid_598087 = validateParameter(valid_598087, JString, required = true,
                                 default = nil)
  if valid_598087 != nil:
    section.add "accountId", valid_598087
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
  var valid_598088 = query.getOrDefault("fields")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "fields", valid_598088
  var valid_598089 = query.getOrDefault("quotaUser")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "quotaUser", valid_598089
  var valid_598090 = query.getOrDefault("alt")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = newJString("json"))
  if valid_598090 != nil:
    section.add "alt", valid_598090
  var valid_598091 = query.getOrDefault("oauth_token")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "oauth_token", valid_598091
  var valid_598092 = query.getOrDefault("userIp")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "userIp", valid_598092
  var valid_598093 = query.getOrDefault("key")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "key", valid_598093
  var valid_598094 = query.getOrDefault("prettyPrint")
  valid_598094 = validateParameter(valid_598094, JBool, required = false,
                                 default = newJBool(true))
  if valid_598094 != nil:
    section.add "prettyPrint", valid_598094
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

proc call*(call_598096: Call_AdexchangebuyerBudgetUpdate_598083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  let valid = call_598096.validator(path, query, header, formData, body)
  let scheme = call_598096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598096.url(scheme.get, call_598096.host, call_598096.base,
                         call_598096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598096, url, valid)

proc call*(call_598097: Call_AdexchangebuyerBudgetUpdate_598083; billingId: string;
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
  var path_598098 = newJObject()
  var query_598099 = newJObject()
  var body_598100 = newJObject()
  add(query_598099, "fields", newJString(fields))
  add(query_598099, "quotaUser", newJString(quotaUser))
  add(path_598098, "billingId", newJString(billingId))
  add(query_598099, "alt", newJString(alt))
  add(query_598099, "oauth_token", newJString(oauthToken))
  add(path_598098, "accountId", newJString(accountId))
  add(query_598099, "userIp", newJString(userIp))
  add(query_598099, "key", newJString(key))
  if body != nil:
    body_598100 = body
  add(query_598099, "prettyPrint", newJBool(prettyPrint))
  result = call_598097.call(path_598098, query_598099, nil, nil, body_598100)

var adexchangebuyerBudgetUpdate* = Call_AdexchangebuyerBudgetUpdate_598083(
    name: "adexchangebuyerBudgetUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetUpdate_598084,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetUpdate_598085,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetGet_598067 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerBudgetGet_598069(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerBudgetGet_598068(path: JsonNode; query: JsonNode;
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
  var valid_598070 = path.getOrDefault("billingId")
  valid_598070 = validateParameter(valid_598070, JString, required = true,
                                 default = nil)
  if valid_598070 != nil:
    section.add "billingId", valid_598070
  var valid_598071 = path.getOrDefault("accountId")
  valid_598071 = validateParameter(valid_598071, JString, required = true,
                                 default = nil)
  if valid_598071 != nil:
    section.add "accountId", valid_598071
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
  var valid_598072 = query.getOrDefault("fields")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "fields", valid_598072
  var valid_598073 = query.getOrDefault("quotaUser")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "quotaUser", valid_598073
  var valid_598074 = query.getOrDefault("alt")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = newJString("json"))
  if valid_598074 != nil:
    section.add "alt", valid_598074
  var valid_598075 = query.getOrDefault("oauth_token")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "oauth_token", valid_598075
  var valid_598076 = query.getOrDefault("userIp")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "userIp", valid_598076
  var valid_598077 = query.getOrDefault("key")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "key", valid_598077
  var valid_598078 = query.getOrDefault("prettyPrint")
  valid_598078 = validateParameter(valid_598078, JBool, required = false,
                                 default = newJBool(true))
  if valid_598078 != nil:
    section.add "prettyPrint", valid_598078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598079: Call_AdexchangebuyerBudgetGet_598067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  let valid = call_598079.validator(path, query, header, formData, body)
  let scheme = call_598079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598079.url(scheme.get, call_598079.host, call_598079.base,
                         call_598079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598079, url, valid)

proc call*(call_598080: Call_AdexchangebuyerBudgetGet_598067; billingId: string;
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
  var path_598081 = newJObject()
  var query_598082 = newJObject()
  add(query_598082, "fields", newJString(fields))
  add(query_598082, "quotaUser", newJString(quotaUser))
  add(path_598081, "billingId", newJString(billingId))
  add(query_598082, "alt", newJString(alt))
  add(query_598082, "oauth_token", newJString(oauthToken))
  add(path_598081, "accountId", newJString(accountId))
  add(query_598082, "userIp", newJString(userIp))
  add(query_598082, "key", newJString(key))
  add(query_598082, "prettyPrint", newJBool(prettyPrint))
  result = call_598080.call(path_598081, query_598082, nil, nil, nil)

var adexchangebuyerBudgetGet* = Call_AdexchangebuyerBudgetGet_598067(
    name: "adexchangebuyerBudgetGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetGet_598068,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetGet_598069,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetPatch_598101 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerBudgetPatch_598103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerBudgetPatch_598102(path: JsonNode; query: JsonNode;
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
  var valid_598104 = path.getOrDefault("billingId")
  valid_598104 = validateParameter(valid_598104, JString, required = true,
                                 default = nil)
  if valid_598104 != nil:
    section.add "billingId", valid_598104
  var valid_598105 = path.getOrDefault("accountId")
  valid_598105 = validateParameter(valid_598105, JString, required = true,
                                 default = nil)
  if valid_598105 != nil:
    section.add "accountId", valid_598105
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
  var valid_598106 = query.getOrDefault("fields")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "fields", valid_598106
  var valid_598107 = query.getOrDefault("quotaUser")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "quotaUser", valid_598107
  var valid_598108 = query.getOrDefault("alt")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = newJString("json"))
  if valid_598108 != nil:
    section.add "alt", valid_598108
  var valid_598109 = query.getOrDefault("oauth_token")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "oauth_token", valid_598109
  var valid_598110 = query.getOrDefault("userIp")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "userIp", valid_598110
  var valid_598111 = query.getOrDefault("key")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "key", valid_598111
  var valid_598112 = query.getOrDefault("prettyPrint")
  valid_598112 = validateParameter(valid_598112, JBool, required = false,
                                 default = newJBool(true))
  if valid_598112 != nil:
    section.add "prettyPrint", valid_598112
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

proc call*(call_598114: Call_AdexchangebuyerBudgetPatch_598101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  let valid = call_598114.validator(path, query, header, formData, body)
  let scheme = call_598114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598114.url(scheme.get, call_598114.host, call_598114.base,
                         call_598114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598114, url, valid)

proc call*(call_598115: Call_AdexchangebuyerBudgetPatch_598101; billingId: string;
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
  var path_598116 = newJObject()
  var query_598117 = newJObject()
  var body_598118 = newJObject()
  add(query_598117, "fields", newJString(fields))
  add(query_598117, "quotaUser", newJString(quotaUser))
  add(path_598116, "billingId", newJString(billingId))
  add(query_598117, "alt", newJString(alt))
  add(query_598117, "oauth_token", newJString(oauthToken))
  add(path_598116, "accountId", newJString(accountId))
  add(query_598117, "userIp", newJString(userIp))
  add(query_598117, "key", newJString(key))
  if body != nil:
    body_598118 = body
  add(query_598117, "prettyPrint", newJBool(prettyPrint))
  result = call_598115.call(path_598116, query_598117, nil, nil, body_598118)

var adexchangebuyerBudgetPatch* = Call_AdexchangebuyerBudgetPatch_598101(
    name: "adexchangebuyerBudgetPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetPatch_598102,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetPatch_598103,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_598138 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerCreativesInsert_598140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_598139(path: JsonNode;
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
  var valid_598141 = query.getOrDefault("fields")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "fields", valid_598141
  var valid_598142 = query.getOrDefault("quotaUser")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "quotaUser", valid_598142
  var valid_598143 = query.getOrDefault("alt")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = newJString("json"))
  if valid_598143 != nil:
    section.add "alt", valid_598143
  var valid_598144 = query.getOrDefault("oauth_token")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "oauth_token", valid_598144
  var valid_598145 = query.getOrDefault("userIp")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "userIp", valid_598145
  var valid_598146 = query.getOrDefault("key")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "key", valid_598146
  var valid_598147 = query.getOrDefault("prettyPrint")
  valid_598147 = validateParameter(valid_598147, JBool, required = false,
                                 default = newJBool(true))
  if valid_598147 != nil:
    section.add "prettyPrint", valid_598147
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

proc call*(call_598149: Call_AdexchangebuyerCreativesInsert_598138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_598149.validator(path, query, header, formData, body)
  let scheme = call_598149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598149.url(scheme.get, call_598149.host, call_598149.base,
                         call_598149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598149, url, valid)

proc call*(call_598150: Call_AdexchangebuyerCreativesInsert_598138;
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
  var query_598151 = newJObject()
  var body_598152 = newJObject()
  add(query_598151, "fields", newJString(fields))
  add(query_598151, "quotaUser", newJString(quotaUser))
  add(query_598151, "alt", newJString(alt))
  add(query_598151, "oauth_token", newJString(oauthToken))
  add(query_598151, "userIp", newJString(userIp))
  add(query_598151, "key", newJString(key))
  if body != nil:
    body_598152 = body
  add(query_598151, "prettyPrint", newJBool(prettyPrint))
  result = call_598150.call(nil, query_598151, nil, nil, body_598152)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_598138(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_598139,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesInsert_598140,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_598119 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerCreativesList_598121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_598120(path: JsonNode; query: JsonNode;
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
  var valid_598122 = query.getOrDefault("buyerCreativeId")
  valid_598122 = validateParameter(valid_598122, JArray, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "buyerCreativeId", valid_598122
  var valid_598123 = query.getOrDefault("fields")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "fields", valid_598123
  var valid_598124 = query.getOrDefault("pageToken")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "pageToken", valid_598124
  var valid_598125 = query.getOrDefault("quotaUser")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "quotaUser", valid_598125
  var valid_598126 = query.getOrDefault("alt")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = newJString("json"))
  if valid_598126 != nil:
    section.add "alt", valid_598126
  var valid_598127 = query.getOrDefault("oauth_token")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "oauth_token", valid_598127
  var valid_598128 = query.getOrDefault("accountId")
  valid_598128 = validateParameter(valid_598128, JArray, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "accountId", valid_598128
  var valid_598129 = query.getOrDefault("userIp")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "userIp", valid_598129
  var valid_598130 = query.getOrDefault("maxResults")
  valid_598130 = validateParameter(valid_598130, JInt, required = false, default = nil)
  if valid_598130 != nil:
    section.add "maxResults", valid_598130
  var valid_598131 = query.getOrDefault("openAuctionStatusFilter")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = newJString("approved"))
  if valid_598131 != nil:
    section.add "openAuctionStatusFilter", valid_598131
  var valid_598132 = query.getOrDefault("key")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "key", valid_598132
  var valid_598133 = query.getOrDefault("dealsStatusFilter")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = newJString("approved"))
  if valid_598133 != nil:
    section.add "dealsStatusFilter", valid_598133
  var valid_598134 = query.getOrDefault("prettyPrint")
  valid_598134 = validateParameter(valid_598134, JBool, required = false,
                                 default = newJBool(true))
  if valid_598134 != nil:
    section.add "prettyPrint", valid_598134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598135: Call_AdexchangebuyerCreativesList_598119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_598135.validator(path, query, header, formData, body)
  let scheme = call_598135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598135.url(scheme.get, call_598135.host, call_598135.base,
                         call_598135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598135, url, valid)

proc call*(call_598136: Call_AdexchangebuyerCreativesList_598119;
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
  var query_598137 = newJObject()
  if buyerCreativeId != nil:
    query_598137.add "buyerCreativeId", buyerCreativeId
  add(query_598137, "fields", newJString(fields))
  add(query_598137, "pageToken", newJString(pageToken))
  add(query_598137, "quotaUser", newJString(quotaUser))
  add(query_598137, "alt", newJString(alt))
  add(query_598137, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_598137.add "accountId", accountId
  add(query_598137, "userIp", newJString(userIp))
  add(query_598137, "maxResults", newJInt(maxResults))
  add(query_598137, "openAuctionStatusFilter", newJString(openAuctionStatusFilter))
  add(query_598137, "key", newJString(key))
  add(query_598137, "dealsStatusFilter", newJString(dealsStatusFilter))
  add(query_598137, "prettyPrint", newJBool(prettyPrint))
  result = call_598136.call(nil, query_598137, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_598119(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_598120,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesList_598121,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_598153 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerCreativesGet_598155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerCreativesGet_598154(path: JsonNode; query: JsonNode;
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
  var valid_598156 = path.getOrDefault("accountId")
  valid_598156 = validateParameter(valid_598156, JInt, required = true, default = nil)
  if valid_598156 != nil:
    section.add "accountId", valid_598156
  var valid_598157 = path.getOrDefault("buyerCreativeId")
  valid_598157 = validateParameter(valid_598157, JString, required = true,
                                 default = nil)
  if valid_598157 != nil:
    section.add "buyerCreativeId", valid_598157
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
  var valid_598158 = query.getOrDefault("fields")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "fields", valid_598158
  var valid_598159 = query.getOrDefault("quotaUser")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "quotaUser", valid_598159
  var valid_598160 = query.getOrDefault("alt")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = newJString("json"))
  if valid_598160 != nil:
    section.add "alt", valid_598160
  var valid_598161 = query.getOrDefault("oauth_token")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "oauth_token", valid_598161
  var valid_598162 = query.getOrDefault("userIp")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "userIp", valid_598162
  var valid_598163 = query.getOrDefault("key")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "key", valid_598163
  var valid_598164 = query.getOrDefault("prettyPrint")
  valid_598164 = validateParameter(valid_598164, JBool, required = false,
                                 default = newJBool(true))
  if valid_598164 != nil:
    section.add "prettyPrint", valid_598164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598165: Call_AdexchangebuyerCreativesGet_598153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_598165.validator(path, query, header, formData, body)
  let scheme = call_598165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598165.url(scheme.get, call_598165.host, call_598165.base,
                         call_598165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598165, url, valid)

proc call*(call_598166: Call_AdexchangebuyerCreativesGet_598153; accountId: int;
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
  var path_598167 = newJObject()
  var query_598168 = newJObject()
  add(query_598168, "fields", newJString(fields))
  add(query_598168, "quotaUser", newJString(quotaUser))
  add(query_598168, "alt", newJString(alt))
  add(query_598168, "oauth_token", newJString(oauthToken))
  add(path_598167, "accountId", newJInt(accountId))
  add(query_598168, "userIp", newJString(userIp))
  add(path_598167, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_598168, "key", newJString(key))
  add(query_598168, "prettyPrint", newJBool(prettyPrint))
  result = call_598166.call(path_598167, query_598168, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_598153(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_598154,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesGet_598155,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesAddDeal_598169 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerCreativesAddDeal_598171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerCreativesAddDeal_598170(path: JsonNode;
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
  var valid_598172 = path.getOrDefault("accountId")
  valid_598172 = validateParameter(valid_598172, JInt, required = true, default = nil)
  if valid_598172 != nil:
    section.add "accountId", valid_598172
  var valid_598173 = path.getOrDefault("buyerCreativeId")
  valid_598173 = validateParameter(valid_598173, JString, required = true,
                                 default = nil)
  if valid_598173 != nil:
    section.add "buyerCreativeId", valid_598173
  var valid_598174 = path.getOrDefault("dealId")
  valid_598174 = validateParameter(valid_598174, JString, required = true,
                                 default = nil)
  if valid_598174 != nil:
    section.add "dealId", valid_598174
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
  var valid_598175 = query.getOrDefault("fields")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "fields", valid_598175
  var valid_598176 = query.getOrDefault("quotaUser")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "quotaUser", valid_598176
  var valid_598177 = query.getOrDefault("alt")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = newJString("json"))
  if valid_598177 != nil:
    section.add "alt", valid_598177
  var valid_598178 = query.getOrDefault("oauth_token")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "oauth_token", valid_598178
  var valid_598179 = query.getOrDefault("userIp")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "userIp", valid_598179
  var valid_598180 = query.getOrDefault("key")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "key", valid_598180
  var valid_598181 = query.getOrDefault("prettyPrint")
  valid_598181 = validateParameter(valid_598181, JBool, required = false,
                                 default = newJBool(true))
  if valid_598181 != nil:
    section.add "prettyPrint", valid_598181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598182: Call_AdexchangebuyerCreativesAddDeal_598169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a deal id association for the creative.
  ## 
  let valid = call_598182.validator(path, query, header, formData, body)
  let scheme = call_598182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598182.url(scheme.get, call_598182.host, call_598182.base,
                         call_598182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598182, url, valid)

proc call*(call_598183: Call_AdexchangebuyerCreativesAddDeal_598169;
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
  var path_598184 = newJObject()
  var query_598185 = newJObject()
  add(query_598185, "fields", newJString(fields))
  add(query_598185, "quotaUser", newJString(quotaUser))
  add(query_598185, "alt", newJString(alt))
  add(query_598185, "oauth_token", newJString(oauthToken))
  add(path_598184, "accountId", newJInt(accountId))
  add(query_598185, "userIp", newJString(userIp))
  add(path_598184, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_598185, "key", newJString(key))
  add(query_598185, "prettyPrint", newJBool(prettyPrint))
  add(path_598184, "dealId", newJString(dealId))
  result = call_598183.call(path_598184, query_598185, nil, nil, nil)

var adexchangebuyerCreativesAddDeal* = Call_AdexchangebuyerCreativesAddDeal_598169(
    name: "adexchangebuyerCreativesAddDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/addDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesAddDeal_598170,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesAddDeal_598171,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesListDeals_598186 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerCreativesListDeals_598188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerCreativesListDeals_598187(path: JsonNode;
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
  var valid_598189 = path.getOrDefault("accountId")
  valid_598189 = validateParameter(valid_598189, JInt, required = true, default = nil)
  if valid_598189 != nil:
    section.add "accountId", valid_598189
  var valid_598190 = path.getOrDefault("buyerCreativeId")
  valid_598190 = validateParameter(valid_598190, JString, required = true,
                                 default = nil)
  if valid_598190 != nil:
    section.add "buyerCreativeId", valid_598190
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
  var valid_598191 = query.getOrDefault("fields")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "fields", valid_598191
  var valid_598192 = query.getOrDefault("quotaUser")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "quotaUser", valid_598192
  var valid_598193 = query.getOrDefault("alt")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = newJString("json"))
  if valid_598193 != nil:
    section.add "alt", valid_598193
  var valid_598194 = query.getOrDefault("oauth_token")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "oauth_token", valid_598194
  var valid_598195 = query.getOrDefault("userIp")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "userIp", valid_598195
  var valid_598196 = query.getOrDefault("key")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "key", valid_598196
  var valid_598197 = query.getOrDefault("prettyPrint")
  valid_598197 = validateParameter(valid_598197, JBool, required = false,
                                 default = newJBool(true))
  if valid_598197 != nil:
    section.add "prettyPrint", valid_598197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598198: Call_AdexchangebuyerCreativesListDeals_598186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the external deal ids associated with the creative.
  ## 
  let valid = call_598198.validator(path, query, header, formData, body)
  let scheme = call_598198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598198.url(scheme.get, call_598198.host, call_598198.base,
                         call_598198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598198, url, valid)

proc call*(call_598199: Call_AdexchangebuyerCreativesListDeals_598186;
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
  var path_598200 = newJObject()
  var query_598201 = newJObject()
  add(query_598201, "fields", newJString(fields))
  add(query_598201, "quotaUser", newJString(quotaUser))
  add(query_598201, "alt", newJString(alt))
  add(query_598201, "oauth_token", newJString(oauthToken))
  add(path_598200, "accountId", newJInt(accountId))
  add(query_598201, "userIp", newJString(userIp))
  add(path_598200, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_598201, "key", newJString(key))
  add(query_598201, "prettyPrint", newJBool(prettyPrint))
  result = call_598199.call(path_598200, query_598201, nil, nil, nil)

var adexchangebuyerCreativesListDeals* = Call_AdexchangebuyerCreativesListDeals_598186(
    name: "adexchangebuyerCreativesListDeals", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/listDeals",
    validator: validate_AdexchangebuyerCreativesListDeals_598187,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesListDeals_598188,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesRemoveDeal_598202 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerCreativesRemoveDeal_598204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerCreativesRemoveDeal_598203(path: JsonNode;
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
  var valid_598205 = path.getOrDefault("accountId")
  valid_598205 = validateParameter(valid_598205, JInt, required = true, default = nil)
  if valid_598205 != nil:
    section.add "accountId", valid_598205
  var valid_598206 = path.getOrDefault("buyerCreativeId")
  valid_598206 = validateParameter(valid_598206, JString, required = true,
                                 default = nil)
  if valid_598206 != nil:
    section.add "buyerCreativeId", valid_598206
  var valid_598207 = path.getOrDefault("dealId")
  valid_598207 = validateParameter(valid_598207, JString, required = true,
                                 default = nil)
  if valid_598207 != nil:
    section.add "dealId", valid_598207
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
  var valid_598208 = query.getOrDefault("fields")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "fields", valid_598208
  var valid_598209 = query.getOrDefault("quotaUser")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "quotaUser", valid_598209
  var valid_598210 = query.getOrDefault("alt")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = newJString("json"))
  if valid_598210 != nil:
    section.add "alt", valid_598210
  var valid_598211 = query.getOrDefault("oauth_token")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "oauth_token", valid_598211
  var valid_598212 = query.getOrDefault("userIp")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "userIp", valid_598212
  var valid_598213 = query.getOrDefault("key")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "key", valid_598213
  var valid_598214 = query.getOrDefault("prettyPrint")
  valid_598214 = validateParameter(valid_598214, JBool, required = false,
                                 default = newJBool(true))
  if valid_598214 != nil:
    section.add "prettyPrint", valid_598214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598215: Call_AdexchangebuyerCreativesRemoveDeal_598202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove a deal id associated with the creative.
  ## 
  let valid = call_598215.validator(path, query, header, formData, body)
  let scheme = call_598215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598215.url(scheme.get, call_598215.host, call_598215.base,
                         call_598215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598215, url, valid)

proc call*(call_598216: Call_AdexchangebuyerCreativesRemoveDeal_598202;
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
  var path_598217 = newJObject()
  var query_598218 = newJObject()
  add(query_598218, "fields", newJString(fields))
  add(query_598218, "quotaUser", newJString(quotaUser))
  add(query_598218, "alt", newJString(alt))
  add(query_598218, "oauth_token", newJString(oauthToken))
  add(path_598217, "accountId", newJInt(accountId))
  add(query_598218, "userIp", newJString(userIp))
  add(path_598217, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_598218, "key", newJString(key))
  add(query_598218, "prettyPrint", newJBool(prettyPrint))
  add(path_598217, "dealId", newJString(dealId))
  result = call_598216.call(path_598217, query_598218, nil, nil, nil)

var adexchangebuyerCreativesRemoveDeal* = Call_AdexchangebuyerCreativesRemoveDeal_598202(
    name: "adexchangebuyerCreativesRemoveDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/removeDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesRemoveDeal_598203,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesRemoveDeal_598204,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPerformanceReportList_598219 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPerformanceReportList_598221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerPerformanceReportList_598220(path: JsonNode;
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
  var valid_598222 = query.getOrDefault("fields")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "fields", valid_598222
  var valid_598223 = query.getOrDefault("pageToken")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "pageToken", valid_598223
  var valid_598224 = query.getOrDefault("quotaUser")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "quotaUser", valid_598224
  var valid_598225 = query.getOrDefault("alt")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = newJString("json"))
  if valid_598225 != nil:
    section.add "alt", valid_598225
  assert query != nil,
        "query argument is necessary due to required `startDateTime` field"
  var valid_598226 = query.getOrDefault("startDateTime")
  valid_598226 = validateParameter(valid_598226, JString, required = true,
                                 default = nil)
  if valid_598226 != nil:
    section.add "startDateTime", valid_598226
  var valid_598227 = query.getOrDefault("oauth_token")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "oauth_token", valid_598227
  var valid_598228 = query.getOrDefault("accountId")
  valid_598228 = validateParameter(valid_598228, JString, required = true,
                                 default = nil)
  if valid_598228 != nil:
    section.add "accountId", valid_598228
  var valid_598229 = query.getOrDefault("userIp")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "userIp", valid_598229
  var valid_598230 = query.getOrDefault("maxResults")
  valid_598230 = validateParameter(valid_598230, JInt, required = false, default = nil)
  if valid_598230 != nil:
    section.add "maxResults", valid_598230
  var valid_598231 = query.getOrDefault("key")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "key", valid_598231
  var valid_598232 = query.getOrDefault("endDateTime")
  valid_598232 = validateParameter(valid_598232, JString, required = true,
                                 default = nil)
  if valid_598232 != nil:
    section.add "endDateTime", valid_598232
  var valid_598233 = query.getOrDefault("prettyPrint")
  valid_598233 = validateParameter(valid_598233, JBool, required = false,
                                 default = newJBool(true))
  if valid_598233 != nil:
    section.add "prettyPrint", valid_598233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598234: Call_AdexchangebuyerPerformanceReportList_598219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  let valid = call_598234.validator(path, query, header, formData, body)
  let scheme = call_598234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598234.url(scheme.get, call_598234.host, call_598234.base,
                         call_598234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598234, url, valid)

proc call*(call_598235: Call_AdexchangebuyerPerformanceReportList_598219;
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
  var query_598236 = newJObject()
  add(query_598236, "fields", newJString(fields))
  add(query_598236, "pageToken", newJString(pageToken))
  add(query_598236, "quotaUser", newJString(quotaUser))
  add(query_598236, "alt", newJString(alt))
  add(query_598236, "startDateTime", newJString(startDateTime))
  add(query_598236, "oauth_token", newJString(oauthToken))
  add(query_598236, "accountId", newJString(accountId))
  add(query_598236, "userIp", newJString(userIp))
  add(query_598236, "maxResults", newJInt(maxResults))
  add(query_598236, "key", newJString(key))
  add(query_598236, "endDateTime", newJString(endDateTime))
  add(query_598236, "prettyPrint", newJBool(prettyPrint))
  result = call_598235.call(nil, query_598236, nil, nil, nil)

var adexchangebuyerPerformanceReportList* = Call_AdexchangebuyerPerformanceReportList_598219(
    name: "adexchangebuyerPerformanceReportList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/performancereport",
    validator: validate_AdexchangebuyerPerformanceReportList_598220,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPerformanceReportList_598221,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigInsert_598252 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPretargetingConfigInsert_598254(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigInsert_598253(path: JsonNode;
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
  var valid_598255 = path.getOrDefault("accountId")
  valid_598255 = validateParameter(valid_598255, JString, required = true,
                                 default = nil)
  if valid_598255 != nil:
    section.add "accountId", valid_598255
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
  var valid_598256 = query.getOrDefault("fields")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "fields", valid_598256
  var valid_598257 = query.getOrDefault("quotaUser")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = nil)
  if valid_598257 != nil:
    section.add "quotaUser", valid_598257
  var valid_598258 = query.getOrDefault("alt")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = newJString("json"))
  if valid_598258 != nil:
    section.add "alt", valid_598258
  var valid_598259 = query.getOrDefault("oauth_token")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "oauth_token", valid_598259
  var valid_598260 = query.getOrDefault("userIp")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "userIp", valid_598260
  var valid_598261 = query.getOrDefault("key")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = nil)
  if valid_598261 != nil:
    section.add "key", valid_598261
  var valid_598262 = query.getOrDefault("prettyPrint")
  valid_598262 = validateParameter(valid_598262, JBool, required = false,
                                 default = newJBool(true))
  if valid_598262 != nil:
    section.add "prettyPrint", valid_598262
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

proc call*(call_598264: Call_AdexchangebuyerPretargetingConfigInsert_598252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new pretargeting configuration.
  ## 
  let valid = call_598264.validator(path, query, header, formData, body)
  let scheme = call_598264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598264.url(scheme.get, call_598264.host, call_598264.base,
                         call_598264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598264, url, valid)

proc call*(call_598265: Call_AdexchangebuyerPretargetingConfigInsert_598252;
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
  var path_598266 = newJObject()
  var query_598267 = newJObject()
  var body_598268 = newJObject()
  add(query_598267, "fields", newJString(fields))
  add(query_598267, "quotaUser", newJString(quotaUser))
  add(query_598267, "alt", newJString(alt))
  add(query_598267, "oauth_token", newJString(oauthToken))
  add(path_598266, "accountId", newJString(accountId))
  add(query_598267, "userIp", newJString(userIp))
  add(query_598267, "key", newJString(key))
  if body != nil:
    body_598268 = body
  add(query_598267, "prettyPrint", newJBool(prettyPrint))
  result = call_598265.call(path_598266, query_598267, nil, nil, body_598268)

var adexchangebuyerPretargetingConfigInsert* = Call_AdexchangebuyerPretargetingConfigInsert_598252(
    name: "adexchangebuyerPretargetingConfigInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigInsert_598253,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigInsert_598254,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigList_598237 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPretargetingConfigList_598239(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/pretargetingconfigs/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerPretargetingConfigList_598238(path: JsonNode;
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
  var valid_598240 = path.getOrDefault("accountId")
  valid_598240 = validateParameter(valid_598240, JString, required = true,
                                 default = nil)
  if valid_598240 != nil:
    section.add "accountId", valid_598240
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
  var valid_598241 = query.getOrDefault("fields")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "fields", valid_598241
  var valid_598242 = query.getOrDefault("quotaUser")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "quotaUser", valid_598242
  var valid_598243 = query.getOrDefault("alt")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = newJString("json"))
  if valid_598243 != nil:
    section.add "alt", valid_598243
  var valid_598244 = query.getOrDefault("oauth_token")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "oauth_token", valid_598244
  var valid_598245 = query.getOrDefault("userIp")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "userIp", valid_598245
  var valid_598246 = query.getOrDefault("key")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "key", valid_598246
  var valid_598247 = query.getOrDefault("prettyPrint")
  valid_598247 = validateParameter(valid_598247, JBool, required = false,
                                 default = newJBool(true))
  if valid_598247 != nil:
    section.add "prettyPrint", valid_598247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598248: Call_AdexchangebuyerPretargetingConfigList_598237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  let valid = call_598248.validator(path, query, header, formData, body)
  let scheme = call_598248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598248.url(scheme.get, call_598248.host, call_598248.base,
                         call_598248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598248, url, valid)

proc call*(call_598249: Call_AdexchangebuyerPretargetingConfigList_598237;
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
  var path_598250 = newJObject()
  var query_598251 = newJObject()
  add(query_598251, "fields", newJString(fields))
  add(query_598251, "quotaUser", newJString(quotaUser))
  add(query_598251, "alt", newJString(alt))
  add(query_598251, "oauth_token", newJString(oauthToken))
  add(path_598250, "accountId", newJString(accountId))
  add(query_598251, "userIp", newJString(userIp))
  add(query_598251, "key", newJString(key))
  add(query_598251, "prettyPrint", newJBool(prettyPrint))
  result = call_598249.call(path_598250, query_598251, nil, nil, nil)

var adexchangebuyerPretargetingConfigList* = Call_AdexchangebuyerPretargetingConfigList_598237(
    name: "adexchangebuyerPretargetingConfigList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigList_598238,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigList_598239,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigUpdate_598285 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPretargetingConfigUpdate_598287(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerPretargetingConfigUpdate_598286(path: JsonNode;
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
  var valid_598288 = path.getOrDefault("accountId")
  valid_598288 = validateParameter(valid_598288, JString, required = true,
                                 default = nil)
  if valid_598288 != nil:
    section.add "accountId", valid_598288
  var valid_598289 = path.getOrDefault("configId")
  valid_598289 = validateParameter(valid_598289, JString, required = true,
                                 default = nil)
  if valid_598289 != nil:
    section.add "configId", valid_598289
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
  var valid_598290 = query.getOrDefault("fields")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "fields", valid_598290
  var valid_598291 = query.getOrDefault("quotaUser")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "quotaUser", valid_598291
  var valid_598292 = query.getOrDefault("alt")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = newJString("json"))
  if valid_598292 != nil:
    section.add "alt", valid_598292
  var valid_598293 = query.getOrDefault("oauth_token")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "oauth_token", valid_598293
  var valid_598294 = query.getOrDefault("userIp")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "userIp", valid_598294
  var valid_598295 = query.getOrDefault("key")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "key", valid_598295
  var valid_598296 = query.getOrDefault("prettyPrint")
  valid_598296 = validateParameter(valid_598296, JBool, required = false,
                                 default = newJBool(true))
  if valid_598296 != nil:
    section.add "prettyPrint", valid_598296
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

proc call*(call_598298: Call_AdexchangebuyerPretargetingConfigUpdate_598285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config.
  ## 
  let valid = call_598298.validator(path, query, header, formData, body)
  let scheme = call_598298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598298.url(scheme.get, call_598298.host, call_598298.base,
                         call_598298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598298, url, valid)

proc call*(call_598299: Call_AdexchangebuyerPretargetingConfigUpdate_598285;
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
  var path_598300 = newJObject()
  var query_598301 = newJObject()
  var body_598302 = newJObject()
  add(query_598301, "fields", newJString(fields))
  add(query_598301, "quotaUser", newJString(quotaUser))
  add(query_598301, "alt", newJString(alt))
  add(query_598301, "oauth_token", newJString(oauthToken))
  add(path_598300, "accountId", newJString(accountId))
  add(query_598301, "userIp", newJString(userIp))
  add(query_598301, "key", newJString(key))
  add(path_598300, "configId", newJString(configId))
  if body != nil:
    body_598302 = body
  add(query_598301, "prettyPrint", newJBool(prettyPrint))
  result = call_598299.call(path_598300, query_598301, nil, nil, body_598302)

var adexchangebuyerPretargetingConfigUpdate* = Call_AdexchangebuyerPretargetingConfigUpdate_598285(
    name: "adexchangebuyerPretargetingConfigUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigUpdate_598286,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigUpdate_598287,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigGet_598269 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPretargetingConfigGet_598271(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerPretargetingConfigGet_598270(path: JsonNode;
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
  var valid_598272 = path.getOrDefault("accountId")
  valid_598272 = validateParameter(valid_598272, JString, required = true,
                                 default = nil)
  if valid_598272 != nil:
    section.add "accountId", valid_598272
  var valid_598273 = path.getOrDefault("configId")
  valid_598273 = validateParameter(valid_598273, JString, required = true,
                                 default = nil)
  if valid_598273 != nil:
    section.add "configId", valid_598273
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
  var valid_598274 = query.getOrDefault("fields")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "fields", valid_598274
  var valid_598275 = query.getOrDefault("quotaUser")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = nil)
  if valid_598275 != nil:
    section.add "quotaUser", valid_598275
  var valid_598276 = query.getOrDefault("alt")
  valid_598276 = validateParameter(valid_598276, JString, required = false,
                                 default = newJString("json"))
  if valid_598276 != nil:
    section.add "alt", valid_598276
  var valid_598277 = query.getOrDefault("oauth_token")
  valid_598277 = validateParameter(valid_598277, JString, required = false,
                                 default = nil)
  if valid_598277 != nil:
    section.add "oauth_token", valid_598277
  var valid_598278 = query.getOrDefault("userIp")
  valid_598278 = validateParameter(valid_598278, JString, required = false,
                                 default = nil)
  if valid_598278 != nil:
    section.add "userIp", valid_598278
  var valid_598279 = query.getOrDefault("key")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "key", valid_598279
  var valid_598280 = query.getOrDefault("prettyPrint")
  valid_598280 = validateParameter(valid_598280, JBool, required = false,
                                 default = newJBool(true))
  if valid_598280 != nil:
    section.add "prettyPrint", valid_598280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598281: Call_AdexchangebuyerPretargetingConfigGet_598269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific pretargeting configuration
  ## 
  let valid = call_598281.validator(path, query, header, formData, body)
  let scheme = call_598281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598281.url(scheme.get, call_598281.host, call_598281.base,
                         call_598281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598281, url, valid)

proc call*(call_598282: Call_AdexchangebuyerPretargetingConfigGet_598269;
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
  var path_598283 = newJObject()
  var query_598284 = newJObject()
  add(query_598284, "fields", newJString(fields))
  add(query_598284, "quotaUser", newJString(quotaUser))
  add(query_598284, "alt", newJString(alt))
  add(query_598284, "oauth_token", newJString(oauthToken))
  add(path_598283, "accountId", newJString(accountId))
  add(query_598284, "userIp", newJString(userIp))
  add(query_598284, "key", newJString(key))
  add(path_598283, "configId", newJString(configId))
  add(query_598284, "prettyPrint", newJBool(prettyPrint))
  result = call_598282.call(path_598283, query_598284, nil, nil, nil)

var adexchangebuyerPretargetingConfigGet* = Call_AdexchangebuyerPretargetingConfigGet_598269(
    name: "adexchangebuyerPretargetingConfigGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigGet_598270,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigGet_598271,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigPatch_598319 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPretargetingConfigPatch_598321(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerPretargetingConfigPatch_598320(path: JsonNode;
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
  var valid_598322 = path.getOrDefault("accountId")
  valid_598322 = validateParameter(valid_598322, JString, required = true,
                                 default = nil)
  if valid_598322 != nil:
    section.add "accountId", valid_598322
  var valid_598323 = path.getOrDefault("configId")
  valid_598323 = validateParameter(valid_598323, JString, required = true,
                                 default = nil)
  if valid_598323 != nil:
    section.add "configId", valid_598323
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
  var valid_598324 = query.getOrDefault("fields")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "fields", valid_598324
  var valid_598325 = query.getOrDefault("quotaUser")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "quotaUser", valid_598325
  var valid_598326 = query.getOrDefault("alt")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = newJString("json"))
  if valid_598326 != nil:
    section.add "alt", valid_598326
  var valid_598327 = query.getOrDefault("oauth_token")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "oauth_token", valid_598327
  var valid_598328 = query.getOrDefault("userIp")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "userIp", valid_598328
  var valid_598329 = query.getOrDefault("key")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "key", valid_598329
  var valid_598330 = query.getOrDefault("prettyPrint")
  valid_598330 = validateParameter(valid_598330, JBool, required = false,
                                 default = newJBool(true))
  if valid_598330 != nil:
    section.add "prettyPrint", valid_598330
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

proc call*(call_598332: Call_AdexchangebuyerPretargetingConfigPatch_598319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  let valid = call_598332.validator(path, query, header, formData, body)
  let scheme = call_598332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598332.url(scheme.get, call_598332.host, call_598332.base,
                         call_598332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598332, url, valid)

proc call*(call_598333: Call_AdexchangebuyerPretargetingConfigPatch_598319;
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
  var path_598334 = newJObject()
  var query_598335 = newJObject()
  var body_598336 = newJObject()
  add(query_598335, "fields", newJString(fields))
  add(query_598335, "quotaUser", newJString(quotaUser))
  add(query_598335, "alt", newJString(alt))
  add(query_598335, "oauth_token", newJString(oauthToken))
  add(path_598334, "accountId", newJString(accountId))
  add(query_598335, "userIp", newJString(userIp))
  add(query_598335, "key", newJString(key))
  add(path_598334, "configId", newJString(configId))
  if body != nil:
    body_598336 = body
  add(query_598335, "prettyPrint", newJBool(prettyPrint))
  result = call_598333.call(path_598334, query_598335, nil, nil, body_598336)

var adexchangebuyerPretargetingConfigPatch* = Call_AdexchangebuyerPretargetingConfigPatch_598319(
    name: "adexchangebuyerPretargetingConfigPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigPatch_598320,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigPatch_598321,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigDelete_598303 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPretargetingConfigDelete_598305(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerPretargetingConfigDelete_598304(path: JsonNode;
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
  var valid_598306 = path.getOrDefault("accountId")
  valid_598306 = validateParameter(valid_598306, JString, required = true,
                                 default = nil)
  if valid_598306 != nil:
    section.add "accountId", valid_598306
  var valid_598307 = path.getOrDefault("configId")
  valid_598307 = validateParameter(valid_598307, JString, required = true,
                                 default = nil)
  if valid_598307 != nil:
    section.add "configId", valid_598307
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
  var valid_598308 = query.getOrDefault("fields")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "fields", valid_598308
  var valid_598309 = query.getOrDefault("quotaUser")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "quotaUser", valid_598309
  var valid_598310 = query.getOrDefault("alt")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = newJString("json"))
  if valid_598310 != nil:
    section.add "alt", valid_598310
  var valid_598311 = query.getOrDefault("oauth_token")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = nil)
  if valid_598311 != nil:
    section.add "oauth_token", valid_598311
  var valid_598312 = query.getOrDefault("userIp")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "userIp", valid_598312
  var valid_598313 = query.getOrDefault("key")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "key", valid_598313
  var valid_598314 = query.getOrDefault("prettyPrint")
  valid_598314 = validateParameter(valid_598314, JBool, required = false,
                                 default = newJBool(true))
  if valid_598314 != nil:
    section.add "prettyPrint", valid_598314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598315: Call_AdexchangebuyerPretargetingConfigDelete_598303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing pretargeting config.
  ## 
  let valid = call_598315.validator(path, query, header, formData, body)
  let scheme = call_598315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598315.url(scheme.get, call_598315.host, call_598315.base,
                         call_598315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598315, url, valid)

proc call*(call_598316: Call_AdexchangebuyerPretargetingConfigDelete_598303;
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
  var path_598317 = newJObject()
  var query_598318 = newJObject()
  add(query_598318, "fields", newJString(fields))
  add(query_598318, "quotaUser", newJString(quotaUser))
  add(query_598318, "alt", newJString(alt))
  add(query_598318, "oauth_token", newJString(oauthToken))
  add(path_598317, "accountId", newJString(accountId))
  add(query_598318, "userIp", newJString(userIp))
  add(query_598318, "key", newJString(key))
  add(path_598317, "configId", newJString(configId))
  add(query_598318, "prettyPrint", newJBool(prettyPrint))
  result = call_598316.call(path_598317, query_598318, nil, nil, nil)

var adexchangebuyerPretargetingConfigDelete* = Call_AdexchangebuyerPretargetingConfigDelete_598303(
    name: "adexchangebuyerPretargetingConfigDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigDelete_598304,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigDelete_598305,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598337 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598339(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598338(
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
  var valid_598340 = path.getOrDefault("privateAuctionId")
  valid_598340 = validateParameter(valid_598340, JString, required = true,
                                 default = nil)
  if valid_598340 != nil:
    section.add "privateAuctionId", valid_598340
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
  var valid_598341 = query.getOrDefault("fields")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = nil)
  if valid_598341 != nil:
    section.add "fields", valid_598341
  var valid_598342 = query.getOrDefault("quotaUser")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = nil)
  if valid_598342 != nil:
    section.add "quotaUser", valid_598342
  var valid_598343 = query.getOrDefault("alt")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = newJString("json"))
  if valid_598343 != nil:
    section.add "alt", valid_598343
  var valid_598344 = query.getOrDefault("oauth_token")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = nil)
  if valid_598344 != nil:
    section.add "oauth_token", valid_598344
  var valid_598345 = query.getOrDefault("userIp")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "userIp", valid_598345
  var valid_598346 = query.getOrDefault("key")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = nil)
  if valid_598346 != nil:
    section.add "key", valid_598346
  var valid_598347 = query.getOrDefault("prettyPrint")
  valid_598347 = validateParameter(valid_598347, JBool, required = false,
                                 default = newJBool(true))
  if valid_598347 != nil:
    section.add "prettyPrint", valid_598347
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

proc call*(call_598349: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a given private auction proposal
  ## 
  let valid = call_598349.validator(path, query, header, formData, body)
  let scheme = call_598349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598349.url(scheme.get, call_598349.host, call_598349.base,
                         call_598349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598349, url, valid)

proc call*(call_598350: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598337;
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
  var path_598351 = newJObject()
  var query_598352 = newJObject()
  var body_598353 = newJObject()
  add(query_598352, "fields", newJString(fields))
  add(query_598352, "quotaUser", newJString(quotaUser))
  add(query_598352, "alt", newJString(alt))
  add(query_598352, "oauth_token", newJString(oauthToken))
  add(query_598352, "userIp", newJString(userIp))
  add(query_598352, "key", newJString(key))
  if body != nil:
    body_598353 = body
  add(query_598352, "prettyPrint", newJBool(prettyPrint))
  add(path_598351, "privateAuctionId", newJString(privateAuctionId))
  result = call_598350.call(path_598351, query_598352, nil, nil, body_598353)

var adexchangebuyerMarketplaceprivateauctionUpdateproposal* = Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598337(
    name: "adexchangebuyerMarketplaceprivateauctionUpdateproposal",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/privateauction/{privateAuctionId}/updateproposal",
    validator: validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598338,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_598339,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsSearch_598354 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProductsSearch_598356(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProductsSearch_598355(path: JsonNode; query: JsonNode;
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
  var valid_598357 = query.getOrDefault("fields")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "fields", valid_598357
  var valid_598358 = query.getOrDefault("quotaUser")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "quotaUser", valid_598358
  var valid_598359 = query.getOrDefault("alt")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = newJString("json"))
  if valid_598359 != nil:
    section.add "alt", valid_598359
  var valid_598360 = query.getOrDefault("pqlQuery")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "pqlQuery", valid_598360
  var valid_598361 = query.getOrDefault("oauth_token")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "oauth_token", valid_598361
  var valid_598362 = query.getOrDefault("userIp")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "userIp", valid_598362
  var valid_598363 = query.getOrDefault("key")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = nil)
  if valid_598363 != nil:
    section.add "key", valid_598363
  var valid_598364 = query.getOrDefault("prettyPrint")
  valid_598364 = validateParameter(valid_598364, JBool, required = false,
                                 default = newJBool(true))
  if valid_598364 != nil:
    section.add "prettyPrint", valid_598364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598365: Call_AdexchangebuyerProductsSearch_598354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product.
  ## 
  let valid = call_598365.validator(path, query, header, formData, body)
  let scheme = call_598365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598365.url(scheme.get, call_598365.host, call_598365.base,
                         call_598365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598365, url, valid)

proc call*(call_598366: Call_AdexchangebuyerProductsSearch_598354;
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
  var query_598367 = newJObject()
  add(query_598367, "fields", newJString(fields))
  add(query_598367, "quotaUser", newJString(quotaUser))
  add(query_598367, "alt", newJString(alt))
  add(query_598367, "pqlQuery", newJString(pqlQuery))
  add(query_598367, "oauth_token", newJString(oauthToken))
  add(query_598367, "userIp", newJString(userIp))
  add(query_598367, "key", newJString(key))
  add(query_598367, "prettyPrint", newJBool(prettyPrint))
  result = call_598366.call(nil, query_598367, nil, nil, nil)

var adexchangebuyerProductsSearch* = Call_AdexchangebuyerProductsSearch_598354(
    name: "adexchangebuyerProductsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/search",
    validator: validate_AdexchangebuyerProductsSearch_598355,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsSearch_598356,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsGet_598368 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProductsGet_598370(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerProductsGet_598369(path: JsonNode; query: JsonNode;
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
  var valid_598371 = path.getOrDefault("productId")
  valid_598371 = validateParameter(valid_598371, JString, required = true,
                                 default = nil)
  if valid_598371 != nil:
    section.add "productId", valid_598371
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
  var valid_598372 = query.getOrDefault("fields")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "fields", valid_598372
  var valid_598373 = query.getOrDefault("quotaUser")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = nil)
  if valid_598373 != nil:
    section.add "quotaUser", valid_598373
  var valid_598374 = query.getOrDefault("alt")
  valid_598374 = validateParameter(valid_598374, JString, required = false,
                                 default = newJString("json"))
  if valid_598374 != nil:
    section.add "alt", valid_598374
  var valid_598375 = query.getOrDefault("oauth_token")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "oauth_token", valid_598375
  var valid_598376 = query.getOrDefault("userIp")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "userIp", valid_598376
  var valid_598377 = query.getOrDefault("key")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "key", valid_598377
  var valid_598378 = query.getOrDefault("prettyPrint")
  valid_598378 = validateParameter(valid_598378, JBool, required = false,
                                 default = newJBool(true))
  if valid_598378 != nil:
    section.add "prettyPrint", valid_598378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598379: Call_AdexchangebuyerProductsGet_598368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product by id.
  ## 
  let valid = call_598379.validator(path, query, header, formData, body)
  let scheme = call_598379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598379.url(scheme.get, call_598379.host, call_598379.base,
                         call_598379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598379, url, valid)

proc call*(call_598380: Call_AdexchangebuyerProductsGet_598368; productId: string;
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
  var path_598381 = newJObject()
  var query_598382 = newJObject()
  add(query_598382, "fields", newJString(fields))
  add(query_598382, "quotaUser", newJString(quotaUser))
  add(query_598382, "alt", newJString(alt))
  add(query_598382, "oauth_token", newJString(oauthToken))
  add(query_598382, "userIp", newJString(userIp))
  add(query_598382, "key", newJString(key))
  add(path_598381, "productId", newJString(productId))
  add(query_598382, "prettyPrint", newJBool(prettyPrint))
  result = call_598380.call(path_598381, query_598382, nil, nil, nil)

var adexchangebuyerProductsGet* = Call_AdexchangebuyerProductsGet_598368(
    name: "adexchangebuyerProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/{productId}",
    validator: validate_AdexchangebuyerProductsGet_598369,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsGet_598370,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsInsert_598383 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProposalsInsert_598385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsInsert_598384(path: JsonNode;
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
  var valid_598386 = query.getOrDefault("fields")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "fields", valid_598386
  var valid_598387 = query.getOrDefault("quotaUser")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "quotaUser", valid_598387
  var valid_598388 = query.getOrDefault("alt")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = newJString("json"))
  if valid_598388 != nil:
    section.add "alt", valid_598388
  var valid_598389 = query.getOrDefault("oauth_token")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "oauth_token", valid_598389
  var valid_598390 = query.getOrDefault("userIp")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "userIp", valid_598390
  var valid_598391 = query.getOrDefault("key")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "key", valid_598391
  var valid_598392 = query.getOrDefault("prettyPrint")
  valid_598392 = validateParameter(valid_598392, JBool, required = false,
                                 default = newJBool(true))
  if valid_598392 != nil:
    section.add "prettyPrint", valid_598392
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

proc call*(call_598394: Call_AdexchangebuyerProposalsInsert_598383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the given list of proposals
  ## 
  let valid = call_598394.validator(path, query, header, formData, body)
  let scheme = call_598394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598394.url(scheme.get, call_598394.host, call_598394.base,
                         call_598394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598394, url, valid)

proc call*(call_598395: Call_AdexchangebuyerProposalsInsert_598383;
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
  var query_598396 = newJObject()
  var body_598397 = newJObject()
  add(query_598396, "fields", newJString(fields))
  add(query_598396, "quotaUser", newJString(quotaUser))
  add(query_598396, "alt", newJString(alt))
  add(query_598396, "oauth_token", newJString(oauthToken))
  add(query_598396, "userIp", newJString(userIp))
  add(query_598396, "key", newJString(key))
  if body != nil:
    body_598397 = body
  add(query_598396, "prettyPrint", newJBool(prettyPrint))
  result = call_598395.call(nil, query_598396, nil, nil, body_598397)

var adexchangebuyerProposalsInsert* = Call_AdexchangebuyerProposalsInsert_598383(
    name: "adexchangebuyerProposalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/insert",
    validator: validate_AdexchangebuyerProposalsInsert_598384,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsInsert_598385,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSearch_598398 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProposalsSearch_598400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsSearch_598399(path: JsonNode;
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
  var valid_598401 = query.getOrDefault("fields")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "fields", valid_598401
  var valid_598402 = query.getOrDefault("quotaUser")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "quotaUser", valid_598402
  var valid_598403 = query.getOrDefault("alt")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = newJString("json"))
  if valid_598403 != nil:
    section.add "alt", valid_598403
  var valid_598404 = query.getOrDefault("pqlQuery")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "pqlQuery", valid_598404
  var valid_598405 = query.getOrDefault("oauth_token")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "oauth_token", valid_598405
  var valid_598406 = query.getOrDefault("userIp")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "userIp", valid_598406
  var valid_598407 = query.getOrDefault("key")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "key", valid_598407
  var valid_598408 = query.getOrDefault("prettyPrint")
  valid_598408 = validateParameter(valid_598408, JBool, required = false,
                                 default = newJBool(true))
  if valid_598408 != nil:
    section.add "prettyPrint", valid_598408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598409: Call_AdexchangebuyerProposalsSearch_598398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for proposals using pql query
  ## 
  let valid = call_598409.validator(path, query, header, formData, body)
  let scheme = call_598409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598409.url(scheme.get, call_598409.host, call_598409.base,
                         call_598409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598409, url, valid)

proc call*(call_598410: Call_AdexchangebuyerProposalsSearch_598398;
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
  var query_598411 = newJObject()
  add(query_598411, "fields", newJString(fields))
  add(query_598411, "quotaUser", newJString(quotaUser))
  add(query_598411, "alt", newJString(alt))
  add(query_598411, "pqlQuery", newJString(pqlQuery))
  add(query_598411, "oauth_token", newJString(oauthToken))
  add(query_598411, "userIp", newJString(userIp))
  add(query_598411, "key", newJString(key))
  add(query_598411, "prettyPrint", newJBool(prettyPrint))
  result = call_598410.call(nil, query_598411, nil, nil, nil)

var adexchangebuyerProposalsSearch* = Call_AdexchangebuyerProposalsSearch_598398(
    name: "adexchangebuyerProposalsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/search",
    validator: validate_AdexchangebuyerProposalsSearch_598399,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSearch_598400,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsGet_598412 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProposalsGet_598414(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "proposalId" in path, "`proposalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/proposals/"),
               (kind: VariableSegment, value: "proposalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerProposalsGet_598413(path: JsonNode; query: JsonNode;
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
  var valid_598415 = path.getOrDefault("proposalId")
  valid_598415 = validateParameter(valid_598415, JString, required = true,
                                 default = nil)
  if valid_598415 != nil:
    section.add "proposalId", valid_598415
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
  var valid_598416 = query.getOrDefault("fields")
  valid_598416 = validateParameter(valid_598416, JString, required = false,
                                 default = nil)
  if valid_598416 != nil:
    section.add "fields", valid_598416
  var valid_598417 = query.getOrDefault("quotaUser")
  valid_598417 = validateParameter(valid_598417, JString, required = false,
                                 default = nil)
  if valid_598417 != nil:
    section.add "quotaUser", valid_598417
  var valid_598418 = query.getOrDefault("alt")
  valid_598418 = validateParameter(valid_598418, JString, required = false,
                                 default = newJString("json"))
  if valid_598418 != nil:
    section.add "alt", valid_598418
  var valid_598419 = query.getOrDefault("oauth_token")
  valid_598419 = validateParameter(valid_598419, JString, required = false,
                                 default = nil)
  if valid_598419 != nil:
    section.add "oauth_token", valid_598419
  var valid_598420 = query.getOrDefault("userIp")
  valid_598420 = validateParameter(valid_598420, JString, required = false,
                                 default = nil)
  if valid_598420 != nil:
    section.add "userIp", valid_598420
  var valid_598421 = query.getOrDefault("key")
  valid_598421 = validateParameter(valid_598421, JString, required = false,
                                 default = nil)
  if valid_598421 != nil:
    section.add "key", valid_598421
  var valid_598422 = query.getOrDefault("prettyPrint")
  valid_598422 = validateParameter(valid_598422, JBool, required = false,
                                 default = newJBool(true))
  if valid_598422 != nil:
    section.add "prettyPrint", valid_598422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598423: Call_AdexchangebuyerProposalsGet_598412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a proposal given its id
  ## 
  let valid = call_598423.validator(path, query, header, formData, body)
  let scheme = call_598423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598423.url(scheme.get, call_598423.host, call_598423.base,
                         call_598423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598423, url, valid)

proc call*(call_598424: Call_AdexchangebuyerProposalsGet_598412;
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
  var path_598425 = newJObject()
  var query_598426 = newJObject()
  add(query_598426, "fields", newJString(fields))
  add(query_598426, "quotaUser", newJString(quotaUser))
  add(query_598426, "alt", newJString(alt))
  add(path_598425, "proposalId", newJString(proposalId))
  add(query_598426, "oauth_token", newJString(oauthToken))
  add(query_598426, "userIp", newJString(userIp))
  add(query_598426, "key", newJString(key))
  add(query_598426, "prettyPrint", newJBool(prettyPrint))
  result = call_598424.call(path_598425, query_598426, nil, nil, nil)

var adexchangebuyerProposalsGet* = Call_AdexchangebuyerProposalsGet_598412(
    name: "adexchangebuyerProposalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}",
    validator: validate_AdexchangebuyerProposalsGet_598413,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsGet_598414,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsList_598427 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerMarketplacedealsList_598429(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerMarketplacedealsList_598428(path: JsonNode;
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
  var valid_598430 = path.getOrDefault("proposalId")
  valid_598430 = validateParameter(valid_598430, JString, required = true,
                                 default = nil)
  if valid_598430 != nil:
    section.add "proposalId", valid_598430
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
  var valid_598431 = query.getOrDefault("fields")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "fields", valid_598431
  var valid_598432 = query.getOrDefault("quotaUser")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = nil)
  if valid_598432 != nil:
    section.add "quotaUser", valid_598432
  var valid_598433 = query.getOrDefault("alt")
  valid_598433 = validateParameter(valid_598433, JString, required = false,
                                 default = newJString("json"))
  if valid_598433 != nil:
    section.add "alt", valid_598433
  var valid_598434 = query.getOrDefault("pqlQuery")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "pqlQuery", valid_598434
  var valid_598435 = query.getOrDefault("oauth_token")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "oauth_token", valid_598435
  var valid_598436 = query.getOrDefault("userIp")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "userIp", valid_598436
  var valid_598437 = query.getOrDefault("key")
  valid_598437 = validateParameter(valid_598437, JString, required = false,
                                 default = nil)
  if valid_598437 != nil:
    section.add "key", valid_598437
  var valid_598438 = query.getOrDefault("prettyPrint")
  valid_598438 = validateParameter(valid_598438, JBool, required = false,
                                 default = newJBool(true))
  if valid_598438 != nil:
    section.add "prettyPrint", valid_598438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598439: Call_AdexchangebuyerMarketplacedealsList_598427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the deals for a given proposal
  ## 
  let valid = call_598439.validator(path, query, header, formData, body)
  let scheme = call_598439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598439.url(scheme.get, call_598439.host, call_598439.base,
                         call_598439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598439, url, valid)

proc call*(call_598440: Call_AdexchangebuyerMarketplacedealsList_598427;
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
  var path_598441 = newJObject()
  var query_598442 = newJObject()
  add(query_598442, "fields", newJString(fields))
  add(query_598442, "quotaUser", newJString(quotaUser))
  add(query_598442, "alt", newJString(alt))
  add(query_598442, "pqlQuery", newJString(pqlQuery))
  add(path_598441, "proposalId", newJString(proposalId))
  add(query_598442, "oauth_token", newJString(oauthToken))
  add(query_598442, "userIp", newJString(userIp))
  add(query_598442, "key", newJString(key))
  add(query_598442, "prettyPrint", newJBool(prettyPrint))
  result = call_598440.call(path_598441, query_598442, nil, nil, nil)

var adexchangebuyerMarketplacedealsList* = Call_AdexchangebuyerMarketplacedealsList_598427(
    name: "adexchangebuyerMarketplacedealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals",
    validator: validate_AdexchangebuyerMarketplacedealsList_598428,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsList_598429,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsDelete_598443 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerMarketplacedealsDelete_598445(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerMarketplacedealsDelete_598444(path: JsonNode;
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
  var valid_598446 = path.getOrDefault("proposalId")
  valid_598446 = validateParameter(valid_598446, JString, required = true,
                                 default = nil)
  if valid_598446 != nil:
    section.add "proposalId", valid_598446
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
  var valid_598447 = query.getOrDefault("fields")
  valid_598447 = validateParameter(valid_598447, JString, required = false,
                                 default = nil)
  if valid_598447 != nil:
    section.add "fields", valid_598447
  var valid_598448 = query.getOrDefault("quotaUser")
  valid_598448 = validateParameter(valid_598448, JString, required = false,
                                 default = nil)
  if valid_598448 != nil:
    section.add "quotaUser", valid_598448
  var valid_598449 = query.getOrDefault("alt")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = newJString("json"))
  if valid_598449 != nil:
    section.add "alt", valid_598449
  var valid_598450 = query.getOrDefault("oauth_token")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "oauth_token", valid_598450
  var valid_598451 = query.getOrDefault("userIp")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "userIp", valid_598451
  var valid_598452 = query.getOrDefault("key")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "key", valid_598452
  var valid_598453 = query.getOrDefault("prettyPrint")
  valid_598453 = validateParameter(valid_598453, JBool, required = false,
                                 default = newJBool(true))
  if valid_598453 != nil:
    section.add "prettyPrint", valid_598453
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

proc call*(call_598455: Call_AdexchangebuyerMarketplacedealsDelete_598443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified deals from the proposal
  ## 
  let valid = call_598455.validator(path, query, header, formData, body)
  let scheme = call_598455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598455.url(scheme.get, call_598455.host, call_598455.base,
                         call_598455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598455, url, valid)

proc call*(call_598456: Call_AdexchangebuyerMarketplacedealsDelete_598443;
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
  var path_598457 = newJObject()
  var query_598458 = newJObject()
  var body_598459 = newJObject()
  add(query_598458, "fields", newJString(fields))
  add(query_598458, "quotaUser", newJString(quotaUser))
  add(query_598458, "alt", newJString(alt))
  add(path_598457, "proposalId", newJString(proposalId))
  add(query_598458, "oauth_token", newJString(oauthToken))
  add(query_598458, "userIp", newJString(userIp))
  add(query_598458, "key", newJString(key))
  if body != nil:
    body_598459 = body
  add(query_598458, "prettyPrint", newJBool(prettyPrint))
  result = call_598456.call(path_598457, query_598458, nil, nil, body_598459)

var adexchangebuyerMarketplacedealsDelete* = Call_AdexchangebuyerMarketplacedealsDelete_598443(
    name: "adexchangebuyerMarketplacedealsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/delete",
    validator: validate_AdexchangebuyerMarketplacedealsDelete_598444,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsDelete_598445,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsInsert_598460 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerMarketplacedealsInsert_598462(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerMarketplacedealsInsert_598461(path: JsonNode;
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
  var valid_598463 = path.getOrDefault("proposalId")
  valid_598463 = validateParameter(valid_598463, JString, required = true,
                                 default = nil)
  if valid_598463 != nil:
    section.add "proposalId", valid_598463
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
  var valid_598464 = query.getOrDefault("fields")
  valid_598464 = validateParameter(valid_598464, JString, required = false,
                                 default = nil)
  if valid_598464 != nil:
    section.add "fields", valid_598464
  var valid_598465 = query.getOrDefault("quotaUser")
  valid_598465 = validateParameter(valid_598465, JString, required = false,
                                 default = nil)
  if valid_598465 != nil:
    section.add "quotaUser", valid_598465
  var valid_598466 = query.getOrDefault("alt")
  valid_598466 = validateParameter(valid_598466, JString, required = false,
                                 default = newJString("json"))
  if valid_598466 != nil:
    section.add "alt", valid_598466
  var valid_598467 = query.getOrDefault("oauth_token")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = nil)
  if valid_598467 != nil:
    section.add "oauth_token", valid_598467
  var valid_598468 = query.getOrDefault("userIp")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = nil)
  if valid_598468 != nil:
    section.add "userIp", valid_598468
  var valid_598469 = query.getOrDefault("key")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "key", valid_598469
  var valid_598470 = query.getOrDefault("prettyPrint")
  valid_598470 = validateParameter(valid_598470, JBool, required = false,
                                 default = newJBool(true))
  if valid_598470 != nil:
    section.add "prettyPrint", valid_598470
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

proc call*(call_598472: Call_AdexchangebuyerMarketplacedealsInsert_598460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add new deals for the specified proposal
  ## 
  let valid = call_598472.validator(path, query, header, formData, body)
  let scheme = call_598472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598472.url(scheme.get, call_598472.host, call_598472.base,
                         call_598472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598472, url, valid)

proc call*(call_598473: Call_AdexchangebuyerMarketplacedealsInsert_598460;
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
  var path_598474 = newJObject()
  var query_598475 = newJObject()
  var body_598476 = newJObject()
  add(query_598475, "fields", newJString(fields))
  add(query_598475, "quotaUser", newJString(quotaUser))
  add(query_598475, "alt", newJString(alt))
  add(path_598474, "proposalId", newJString(proposalId))
  add(query_598475, "oauth_token", newJString(oauthToken))
  add(query_598475, "userIp", newJString(userIp))
  add(query_598475, "key", newJString(key))
  if body != nil:
    body_598476 = body
  add(query_598475, "prettyPrint", newJBool(prettyPrint))
  result = call_598473.call(path_598474, query_598475, nil, nil, body_598476)

var adexchangebuyerMarketplacedealsInsert* = Call_AdexchangebuyerMarketplacedealsInsert_598460(
    name: "adexchangebuyerMarketplacedealsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/insert",
    validator: validate_AdexchangebuyerMarketplacedealsInsert_598461,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsInsert_598462,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsUpdate_598477 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerMarketplacedealsUpdate_598479(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerMarketplacedealsUpdate_598478(path: JsonNode;
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
  var valid_598480 = path.getOrDefault("proposalId")
  valid_598480 = validateParameter(valid_598480, JString, required = true,
                                 default = nil)
  if valid_598480 != nil:
    section.add "proposalId", valid_598480
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
  var valid_598481 = query.getOrDefault("fields")
  valid_598481 = validateParameter(valid_598481, JString, required = false,
                                 default = nil)
  if valid_598481 != nil:
    section.add "fields", valid_598481
  var valid_598482 = query.getOrDefault("quotaUser")
  valid_598482 = validateParameter(valid_598482, JString, required = false,
                                 default = nil)
  if valid_598482 != nil:
    section.add "quotaUser", valid_598482
  var valid_598483 = query.getOrDefault("alt")
  valid_598483 = validateParameter(valid_598483, JString, required = false,
                                 default = newJString("json"))
  if valid_598483 != nil:
    section.add "alt", valid_598483
  var valid_598484 = query.getOrDefault("oauth_token")
  valid_598484 = validateParameter(valid_598484, JString, required = false,
                                 default = nil)
  if valid_598484 != nil:
    section.add "oauth_token", valid_598484
  var valid_598485 = query.getOrDefault("userIp")
  valid_598485 = validateParameter(valid_598485, JString, required = false,
                                 default = nil)
  if valid_598485 != nil:
    section.add "userIp", valid_598485
  var valid_598486 = query.getOrDefault("key")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "key", valid_598486
  var valid_598487 = query.getOrDefault("prettyPrint")
  valid_598487 = validateParameter(valid_598487, JBool, required = false,
                                 default = newJBool(true))
  if valid_598487 != nil:
    section.add "prettyPrint", valid_598487
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

proc call*(call_598489: Call_AdexchangebuyerMarketplacedealsUpdate_598477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces all the deals in the proposal with the passed in deals
  ## 
  let valid = call_598489.validator(path, query, header, formData, body)
  let scheme = call_598489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598489.url(scheme.get, call_598489.host, call_598489.base,
                         call_598489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598489, url, valid)

proc call*(call_598490: Call_AdexchangebuyerMarketplacedealsUpdate_598477;
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
  var path_598491 = newJObject()
  var query_598492 = newJObject()
  var body_598493 = newJObject()
  add(query_598492, "fields", newJString(fields))
  add(query_598492, "quotaUser", newJString(quotaUser))
  add(query_598492, "alt", newJString(alt))
  add(path_598491, "proposalId", newJString(proposalId))
  add(query_598492, "oauth_token", newJString(oauthToken))
  add(query_598492, "userIp", newJString(userIp))
  add(query_598492, "key", newJString(key))
  if body != nil:
    body_598493 = body
  add(query_598492, "prettyPrint", newJBool(prettyPrint))
  result = call_598490.call(path_598491, query_598492, nil, nil, body_598493)

var adexchangebuyerMarketplacedealsUpdate* = Call_AdexchangebuyerMarketplacedealsUpdate_598477(
    name: "adexchangebuyerMarketplacedealsUpdate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/update",
    validator: validate_AdexchangebuyerMarketplacedealsUpdate_598478,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsUpdate_598479,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesList_598494 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerMarketplacenotesList_598496(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerMarketplacenotesList_598495(path: JsonNode;
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
  var valid_598497 = path.getOrDefault("proposalId")
  valid_598497 = validateParameter(valid_598497, JString, required = true,
                                 default = nil)
  if valid_598497 != nil:
    section.add "proposalId", valid_598497
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
  var valid_598498 = query.getOrDefault("fields")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "fields", valid_598498
  var valid_598499 = query.getOrDefault("quotaUser")
  valid_598499 = validateParameter(valid_598499, JString, required = false,
                                 default = nil)
  if valid_598499 != nil:
    section.add "quotaUser", valid_598499
  var valid_598500 = query.getOrDefault("alt")
  valid_598500 = validateParameter(valid_598500, JString, required = false,
                                 default = newJString("json"))
  if valid_598500 != nil:
    section.add "alt", valid_598500
  var valid_598501 = query.getOrDefault("pqlQuery")
  valid_598501 = validateParameter(valid_598501, JString, required = false,
                                 default = nil)
  if valid_598501 != nil:
    section.add "pqlQuery", valid_598501
  var valid_598502 = query.getOrDefault("oauth_token")
  valid_598502 = validateParameter(valid_598502, JString, required = false,
                                 default = nil)
  if valid_598502 != nil:
    section.add "oauth_token", valid_598502
  var valid_598503 = query.getOrDefault("userIp")
  valid_598503 = validateParameter(valid_598503, JString, required = false,
                                 default = nil)
  if valid_598503 != nil:
    section.add "userIp", valid_598503
  var valid_598504 = query.getOrDefault("key")
  valid_598504 = validateParameter(valid_598504, JString, required = false,
                                 default = nil)
  if valid_598504 != nil:
    section.add "key", valid_598504
  var valid_598505 = query.getOrDefault("prettyPrint")
  valid_598505 = validateParameter(valid_598505, JBool, required = false,
                                 default = newJBool(true))
  if valid_598505 != nil:
    section.add "prettyPrint", valid_598505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598506: Call_AdexchangebuyerMarketplacenotesList_598494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the notes associated with a proposal
  ## 
  let valid = call_598506.validator(path, query, header, formData, body)
  let scheme = call_598506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598506.url(scheme.get, call_598506.host, call_598506.base,
                         call_598506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598506, url, valid)

proc call*(call_598507: Call_AdexchangebuyerMarketplacenotesList_598494;
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
  var path_598508 = newJObject()
  var query_598509 = newJObject()
  add(query_598509, "fields", newJString(fields))
  add(query_598509, "quotaUser", newJString(quotaUser))
  add(query_598509, "alt", newJString(alt))
  add(query_598509, "pqlQuery", newJString(pqlQuery))
  add(path_598508, "proposalId", newJString(proposalId))
  add(query_598509, "oauth_token", newJString(oauthToken))
  add(query_598509, "userIp", newJString(userIp))
  add(query_598509, "key", newJString(key))
  add(query_598509, "prettyPrint", newJBool(prettyPrint))
  result = call_598507.call(path_598508, query_598509, nil, nil, nil)

var adexchangebuyerMarketplacenotesList* = Call_AdexchangebuyerMarketplacenotesList_598494(
    name: "adexchangebuyerMarketplacenotesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes",
    validator: validate_AdexchangebuyerMarketplacenotesList_598495,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesList_598496,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesInsert_598510 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerMarketplacenotesInsert_598512(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerMarketplacenotesInsert_598511(path: JsonNode;
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
  var valid_598513 = path.getOrDefault("proposalId")
  valid_598513 = validateParameter(valid_598513, JString, required = true,
                                 default = nil)
  if valid_598513 != nil:
    section.add "proposalId", valid_598513
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
  var valid_598514 = query.getOrDefault("fields")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "fields", valid_598514
  var valid_598515 = query.getOrDefault("quotaUser")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "quotaUser", valid_598515
  var valid_598516 = query.getOrDefault("alt")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = newJString("json"))
  if valid_598516 != nil:
    section.add "alt", valid_598516
  var valid_598517 = query.getOrDefault("oauth_token")
  valid_598517 = validateParameter(valid_598517, JString, required = false,
                                 default = nil)
  if valid_598517 != nil:
    section.add "oauth_token", valid_598517
  var valid_598518 = query.getOrDefault("userIp")
  valid_598518 = validateParameter(valid_598518, JString, required = false,
                                 default = nil)
  if valid_598518 != nil:
    section.add "userIp", valid_598518
  var valid_598519 = query.getOrDefault("key")
  valid_598519 = validateParameter(valid_598519, JString, required = false,
                                 default = nil)
  if valid_598519 != nil:
    section.add "key", valid_598519
  var valid_598520 = query.getOrDefault("prettyPrint")
  valid_598520 = validateParameter(valid_598520, JBool, required = false,
                                 default = newJBool(true))
  if valid_598520 != nil:
    section.add "prettyPrint", valid_598520
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

proc call*(call_598522: Call_AdexchangebuyerMarketplacenotesInsert_598510;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add notes to the proposal
  ## 
  let valid = call_598522.validator(path, query, header, formData, body)
  let scheme = call_598522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598522.url(scheme.get, call_598522.host, call_598522.base,
                         call_598522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598522, url, valid)

proc call*(call_598523: Call_AdexchangebuyerMarketplacenotesInsert_598510;
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
  var path_598524 = newJObject()
  var query_598525 = newJObject()
  var body_598526 = newJObject()
  add(query_598525, "fields", newJString(fields))
  add(query_598525, "quotaUser", newJString(quotaUser))
  add(query_598525, "alt", newJString(alt))
  add(path_598524, "proposalId", newJString(proposalId))
  add(query_598525, "oauth_token", newJString(oauthToken))
  add(query_598525, "userIp", newJString(userIp))
  add(query_598525, "key", newJString(key))
  if body != nil:
    body_598526 = body
  add(query_598525, "prettyPrint", newJBool(prettyPrint))
  result = call_598523.call(path_598524, query_598525, nil, nil, body_598526)

var adexchangebuyerMarketplacenotesInsert* = Call_AdexchangebuyerMarketplacenotesInsert_598510(
    name: "adexchangebuyerMarketplacenotesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes/insert",
    validator: validate_AdexchangebuyerMarketplacenotesInsert_598511,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesInsert_598512,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSetupcomplete_598527 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProposalsSetupcomplete_598529(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerProposalsSetupcomplete_598528(path: JsonNode;
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
  var valid_598530 = path.getOrDefault("proposalId")
  valid_598530 = validateParameter(valid_598530, JString, required = true,
                                 default = nil)
  if valid_598530 != nil:
    section.add "proposalId", valid_598530
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
  var valid_598531 = query.getOrDefault("fields")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = nil)
  if valid_598531 != nil:
    section.add "fields", valid_598531
  var valid_598532 = query.getOrDefault("quotaUser")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "quotaUser", valid_598532
  var valid_598533 = query.getOrDefault("alt")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = newJString("json"))
  if valid_598533 != nil:
    section.add "alt", valid_598533
  var valid_598534 = query.getOrDefault("oauth_token")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "oauth_token", valid_598534
  var valid_598535 = query.getOrDefault("userIp")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "userIp", valid_598535
  var valid_598536 = query.getOrDefault("key")
  valid_598536 = validateParameter(valid_598536, JString, required = false,
                                 default = nil)
  if valid_598536 != nil:
    section.add "key", valid_598536
  var valid_598537 = query.getOrDefault("prettyPrint")
  valid_598537 = validateParameter(valid_598537, JBool, required = false,
                                 default = newJBool(true))
  if valid_598537 != nil:
    section.add "prettyPrint", valid_598537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598538: Call_AdexchangebuyerProposalsSetupcomplete_598527;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the given proposal to indicate that setup has been completed.
  ## 
  let valid = call_598538.validator(path, query, header, formData, body)
  let scheme = call_598538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598538.url(scheme.get, call_598538.host, call_598538.base,
                         call_598538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598538, url, valid)

proc call*(call_598539: Call_AdexchangebuyerProposalsSetupcomplete_598527;
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
  var path_598540 = newJObject()
  var query_598541 = newJObject()
  add(query_598541, "fields", newJString(fields))
  add(query_598541, "quotaUser", newJString(quotaUser))
  add(query_598541, "alt", newJString(alt))
  add(path_598540, "proposalId", newJString(proposalId))
  add(query_598541, "oauth_token", newJString(oauthToken))
  add(query_598541, "userIp", newJString(userIp))
  add(query_598541, "key", newJString(key))
  add(query_598541, "prettyPrint", newJBool(prettyPrint))
  result = call_598539.call(path_598540, query_598541, nil, nil, nil)

var adexchangebuyerProposalsSetupcomplete* = Call_AdexchangebuyerProposalsSetupcomplete_598527(
    name: "adexchangebuyerProposalsSetupcomplete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/setupcomplete",
    validator: validate_AdexchangebuyerProposalsSetupcomplete_598528,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSetupcomplete_598529,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsUpdate_598542 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProposalsUpdate_598544(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerProposalsUpdate_598543(path: JsonNode;
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
  var valid_598545 = path.getOrDefault("updateAction")
  valid_598545 = validateParameter(valid_598545, JString, required = true,
                                 default = newJString("accept"))
  if valid_598545 != nil:
    section.add "updateAction", valid_598545
  var valid_598546 = path.getOrDefault("proposalId")
  valid_598546 = validateParameter(valid_598546, JString, required = true,
                                 default = nil)
  if valid_598546 != nil:
    section.add "proposalId", valid_598546
  var valid_598547 = path.getOrDefault("revisionNumber")
  valid_598547 = validateParameter(valid_598547, JString, required = true,
                                 default = nil)
  if valid_598547 != nil:
    section.add "revisionNumber", valid_598547
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
  var valid_598548 = query.getOrDefault("fields")
  valid_598548 = validateParameter(valid_598548, JString, required = false,
                                 default = nil)
  if valid_598548 != nil:
    section.add "fields", valid_598548
  var valid_598549 = query.getOrDefault("quotaUser")
  valid_598549 = validateParameter(valid_598549, JString, required = false,
                                 default = nil)
  if valid_598549 != nil:
    section.add "quotaUser", valid_598549
  var valid_598550 = query.getOrDefault("alt")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = newJString("json"))
  if valid_598550 != nil:
    section.add "alt", valid_598550
  var valid_598551 = query.getOrDefault("oauth_token")
  valid_598551 = validateParameter(valid_598551, JString, required = false,
                                 default = nil)
  if valid_598551 != nil:
    section.add "oauth_token", valid_598551
  var valid_598552 = query.getOrDefault("userIp")
  valid_598552 = validateParameter(valid_598552, JString, required = false,
                                 default = nil)
  if valid_598552 != nil:
    section.add "userIp", valid_598552
  var valid_598553 = query.getOrDefault("key")
  valid_598553 = validateParameter(valid_598553, JString, required = false,
                                 default = nil)
  if valid_598553 != nil:
    section.add "key", valid_598553
  var valid_598554 = query.getOrDefault("prettyPrint")
  valid_598554 = validateParameter(valid_598554, JBool, required = false,
                                 default = newJBool(true))
  if valid_598554 != nil:
    section.add "prettyPrint", valid_598554
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

proc call*(call_598556: Call_AdexchangebuyerProposalsUpdate_598542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal
  ## 
  let valid = call_598556.validator(path, query, header, formData, body)
  let scheme = call_598556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598556.url(scheme.get, call_598556.host, call_598556.base,
                         call_598556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598556, url, valid)

proc call*(call_598557: Call_AdexchangebuyerProposalsUpdate_598542;
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
  var path_598558 = newJObject()
  var query_598559 = newJObject()
  var body_598560 = newJObject()
  add(path_598558, "updateAction", newJString(updateAction))
  add(query_598559, "fields", newJString(fields))
  add(query_598559, "quotaUser", newJString(quotaUser))
  add(query_598559, "alt", newJString(alt))
  add(path_598558, "proposalId", newJString(proposalId))
  add(path_598558, "revisionNumber", newJString(revisionNumber))
  add(query_598559, "oauth_token", newJString(oauthToken))
  add(query_598559, "userIp", newJString(userIp))
  add(query_598559, "key", newJString(key))
  if body != nil:
    body_598560 = body
  add(query_598559, "prettyPrint", newJBool(prettyPrint))
  result = call_598557.call(path_598558, query_598559, nil, nil, body_598560)

var adexchangebuyerProposalsUpdate* = Call_AdexchangebuyerProposalsUpdate_598542(
    name: "adexchangebuyerProposalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsUpdate_598543,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsUpdate_598544,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsPatch_598561 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerProposalsPatch_598563(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerProposalsPatch_598562(path: JsonNode; query: JsonNode;
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
  var valid_598564 = path.getOrDefault("updateAction")
  valid_598564 = validateParameter(valid_598564, JString, required = true,
                                 default = newJString("accept"))
  if valid_598564 != nil:
    section.add "updateAction", valid_598564
  var valid_598565 = path.getOrDefault("proposalId")
  valid_598565 = validateParameter(valid_598565, JString, required = true,
                                 default = nil)
  if valid_598565 != nil:
    section.add "proposalId", valid_598565
  var valid_598566 = path.getOrDefault("revisionNumber")
  valid_598566 = validateParameter(valid_598566, JString, required = true,
                                 default = nil)
  if valid_598566 != nil:
    section.add "revisionNumber", valid_598566
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
  var valid_598567 = query.getOrDefault("fields")
  valid_598567 = validateParameter(valid_598567, JString, required = false,
                                 default = nil)
  if valid_598567 != nil:
    section.add "fields", valid_598567
  var valid_598568 = query.getOrDefault("quotaUser")
  valid_598568 = validateParameter(valid_598568, JString, required = false,
                                 default = nil)
  if valid_598568 != nil:
    section.add "quotaUser", valid_598568
  var valid_598569 = query.getOrDefault("alt")
  valid_598569 = validateParameter(valid_598569, JString, required = false,
                                 default = newJString("json"))
  if valid_598569 != nil:
    section.add "alt", valid_598569
  var valid_598570 = query.getOrDefault("oauth_token")
  valid_598570 = validateParameter(valid_598570, JString, required = false,
                                 default = nil)
  if valid_598570 != nil:
    section.add "oauth_token", valid_598570
  var valid_598571 = query.getOrDefault("userIp")
  valid_598571 = validateParameter(valid_598571, JString, required = false,
                                 default = nil)
  if valid_598571 != nil:
    section.add "userIp", valid_598571
  var valid_598572 = query.getOrDefault("key")
  valid_598572 = validateParameter(valid_598572, JString, required = false,
                                 default = nil)
  if valid_598572 != nil:
    section.add "key", valid_598572
  var valid_598573 = query.getOrDefault("prettyPrint")
  valid_598573 = validateParameter(valid_598573, JBool, required = false,
                                 default = newJBool(true))
  if valid_598573 != nil:
    section.add "prettyPrint", valid_598573
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

proc call*(call_598575: Call_AdexchangebuyerProposalsPatch_598561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal. This method supports patch semantics.
  ## 
  let valid = call_598575.validator(path, query, header, formData, body)
  let scheme = call_598575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598575.url(scheme.get, call_598575.host, call_598575.base,
                         call_598575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598575, url, valid)

proc call*(call_598576: Call_AdexchangebuyerProposalsPatch_598561;
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
  var path_598577 = newJObject()
  var query_598578 = newJObject()
  var body_598579 = newJObject()
  add(path_598577, "updateAction", newJString(updateAction))
  add(query_598578, "fields", newJString(fields))
  add(query_598578, "quotaUser", newJString(quotaUser))
  add(query_598578, "alt", newJString(alt))
  add(path_598577, "proposalId", newJString(proposalId))
  add(path_598577, "revisionNumber", newJString(revisionNumber))
  add(query_598578, "oauth_token", newJString(oauthToken))
  add(query_598578, "userIp", newJString(userIp))
  add(query_598578, "key", newJString(key))
  if body != nil:
    body_598579 = body
  add(query_598578, "prettyPrint", newJBool(prettyPrint))
  result = call_598576.call(path_598577, query_598578, nil, nil, body_598579)

var adexchangebuyerProposalsPatch* = Call_AdexchangebuyerProposalsPatch_598561(
    name: "adexchangebuyerProposalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsPatch_598562,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsPatch_598563,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPubprofilesList_598580 = ref object of OpenApiRestCall_597437
proc url_AdexchangebuyerPubprofilesList_598582(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangebuyerPubprofilesList_598581(path: JsonNode;
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
  var valid_598583 = path.getOrDefault("accountId")
  valid_598583 = validateParameter(valid_598583, JInt, required = true, default = nil)
  if valid_598583 != nil:
    section.add "accountId", valid_598583
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
  var valid_598584 = query.getOrDefault("fields")
  valid_598584 = validateParameter(valid_598584, JString, required = false,
                                 default = nil)
  if valid_598584 != nil:
    section.add "fields", valid_598584
  var valid_598585 = query.getOrDefault("quotaUser")
  valid_598585 = validateParameter(valid_598585, JString, required = false,
                                 default = nil)
  if valid_598585 != nil:
    section.add "quotaUser", valid_598585
  var valid_598586 = query.getOrDefault("alt")
  valid_598586 = validateParameter(valid_598586, JString, required = false,
                                 default = newJString("json"))
  if valid_598586 != nil:
    section.add "alt", valid_598586
  var valid_598587 = query.getOrDefault("oauth_token")
  valid_598587 = validateParameter(valid_598587, JString, required = false,
                                 default = nil)
  if valid_598587 != nil:
    section.add "oauth_token", valid_598587
  var valid_598588 = query.getOrDefault("userIp")
  valid_598588 = validateParameter(valid_598588, JString, required = false,
                                 default = nil)
  if valid_598588 != nil:
    section.add "userIp", valid_598588
  var valid_598589 = query.getOrDefault("key")
  valid_598589 = validateParameter(valid_598589, JString, required = false,
                                 default = nil)
  if valid_598589 != nil:
    section.add "key", valid_598589
  var valid_598590 = query.getOrDefault("prettyPrint")
  valid_598590 = validateParameter(valid_598590, JBool, required = false,
                                 default = newJBool(true))
  if valid_598590 != nil:
    section.add "prettyPrint", valid_598590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598591: Call_AdexchangebuyerPubprofilesList_598580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested publisher profile(s) by publisher accountId.
  ## 
  let valid = call_598591.validator(path, query, header, formData, body)
  let scheme = call_598591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598591.url(scheme.get, call_598591.host, call_598591.base,
                         call_598591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598591, url, valid)

proc call*(call_598592: Call_AdexchangebuyerPubprofilesList_598580; accountId: int;
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
  var path_598593 = newJObject()
  var query_598594 = newJObject()
  add(query_598594, "fields", newJString(fields))
  add(query_598594, "quotaUser", newJString(quotaUser))
  add(query_598594, "alt", newJString(alt))
  add(query_598594, "oauth_token", newJString(oauthToken))
  add(path_598593, "accountId", newJInt(accountId))
  add(query_598594, "userIp", newJString(userIp))
  add(query_598594, "key", newJString(key))
  add(query_598594, "prettyPrint", newJBool(prettyPrint))
  result = call_598592.call(path_598593, query_598594, nil, nil, nil)

var adexchangebuyerPubprofilesList* = Call_AdexchangebuyerPubprofilesList_598580(
    name: "adexchangebuyerPubprofilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/publisher/{accountId}/profiles",
    validator: validate_AdexchangebuyerPubprofilesList_598581,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPubprofilesList_598582,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
