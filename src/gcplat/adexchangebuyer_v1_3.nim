
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "adexchangebuyer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangebuyerAccountsList_597693 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerAccountsList_597695(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerAccountsList_597694(path: JsonNode; query: JsonNode;
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
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
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
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("userIp")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "userIp", valid_597824
  var valid_597825 = query.getOrDefault("key")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "key", valid_597825
  var valid_597826 = query.getOrDefault("prettyPrint")
  valid_597826 = validateParameter(valid_597826, JBool, required = false,
                                 default = newJBool(true))
  if valid_597826 != nil:
    section.add "prettyPrint", valid_597826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597849: Call_AdexchangebuyerAccountsList_597693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of accounts.
  ## 
  let valid = call_597849.validator(path, query, header, formData, body)
  let scheme = call_597849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597849.url(scheme.get, call_597849.host, call_597849.base,
                         call_597849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597849, url, valid)

proc call*(call_597920: Call_AdexchangebuyerAccountsList_597693;
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
  var query_597921 = newJObject()
  add(query_597921, "fields", newJString(fields))
  add(query_597921, "quotaUser", newJString(quotaUser))
  add(query_597921, "alt", newJString(alt))
  add(query_597921, "oauth_token", newJString(oauthToken))
  add(query_597921, "userIp", newJString(userIp))
  add(query_597921, "key", newJString(key))
  add(query_597921, "prettyPrint", newJBool(prettyPrint))
  result = call_597920.call(nil, query_597921, nil, nil, nil)

var adexchangebuyerAccountsList* = Call_AdexchangebuyerAccountsList_597693(
    name: "adexchangebuyerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangebuyerAccountsList_597694,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsList_597695,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsUpdate_597990 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerAccountsUpdate_597992(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsUpdate_597991(path: JsonNode; query: JsonNode;
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
  var valid_597993 = path.getOrDefault("id")
  valid_597993 = validateParameter(valid_597993, JInt, required = true, default = nil)
  if valid_597993 != nil:
    section.add "id", valid_597993
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
  var valid_597994 = query.getOrDefault("fields")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "fields", valid_597994
  var valid_597995 = query.getOrDefault("quotaUser")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "quotaUser", valid_597995
  var valid_597996 = query.getOrDefault("alt")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("json"))
  if valid_597996 != nil:
    section.add "alt", valid_597996
  var valid_597997 = query.getOrDefault("oauth_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "oauth_token", valid_597997
  var valid_597998 = query.getOrDefault("userIp")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "userIp", valid_597998
  var valid_597999 = query.getOrDefault("key")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "key", valid_597999
  var valid_598000 = query.getOrDefault("prettyPrint")
  valid_598000 = validateParameter(valid_598000, JBool, required = false,
                                 default = newJBool(true))
  if valid_598000 != nil:
    section.add "prettyPrint", valid_598000
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

proc call*(call_598002: Call_AdexchangebuyerAccountsUpdate_597990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account.
  ## 
  let valid = call_598002.validator(path, query, header, formData, body)
  let scheme = call_598002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598002.url(scheme.get, call_598002.host, call_598002.base,
                         call_598002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598002, url, valid)

proc call*(call_598003: Call_AdexchangebuyerAccountsUpdate_597990; id: int;
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
  var path_598004 = newJObject()
  var query_598005 = newJObject()
  var body_598006 = newJObject()
  add(query_598005, "fields", newJString(fields))
  add(query_598005, "quotaUser", newJString(quotaUser))
  add(query_598005, "alt", newJString(alt))
  add(query_598005, "oauth_token", newJString(oauthToken))
  add(query_598005, "userIp", newJString(userIp))
  add(path_598004, "id", newJInt(id))
  add(query_598005, "key", newJString(key))
  if body != nil:
    body_598006 = body
  add(query_598005, "prettyPrint", newJBool(prettyPrint))
  result = call_598003.call(path_598004, query_598005, nil, nil, body_598006)

var adexchangebuyerAccountsUpdate* = Call_AdexchangebuyerAccountsUpdate_597990(
    name: "adexchangebuyerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsUpdate_597991,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsUpdate_597992,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsGet_597961 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerAccountsGet_597963(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsGet_597962(path: JsonNode; query: JsonNode;
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
  var valid_597978 = path.getOrDefault("id")
  valid_597978 = validateParameter(valid_597978, JInt, required = true, default = nil)
  if valid_597978 != nil:
    section.add "id", valid_597978
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
  var valid_597979 = query.getOrDefault("fields")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "fields", valid_597979
  var valid_597980 = query.getOrDefault("quotaUser")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "quotaUser", valid_597980
  var valid_597981 = query.getOrDefault("alt")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = newJString("json"))
  if valid_597981 != nil:
    section.add "alt", valid_597981
  var valid_597982 = query.getOrDefault("oauth_token")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "oauth_token", valid_597982
  var valid_597983 = query.getOrDefault("userIp")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "userIp", valid_597983
  var valid_597984 = query.getOrDefault("key")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "key", valid_597984
  var valid_597985 = query.getOrDefault("prettyPrint")
  valid_597985 = validateParameter(valid_597985, JBool, required = false,
                                 default = newJBool(true))
  if valid_597985 != nil:
    section.add "prettyPrint", valid_597985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597986: Call_AdexchangebuyerAccountsGet_597961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one account by ID.
  ## 
  let valid = call_597986.validator(path, query, header, formData, body)
  let scheme = call_597986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597986.url(scheme.get, call_597986.host, call_597986.base,
                         call_597986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597986, url, valid)

proc call*(call_597987: Call_AdexchangebuyerAccountsGet_597961; id: int;
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
  var path_597988 = newJObject()
  var query_597989 = newJObject()
  add(query_597989, "fields", newJString(fields))
  add(query_597989, "quotaUser", newJString(quotaUser))
  add(query_597989, "alt", newJString(alt))
  add(query_597989, "oauth_token", newJString(oauthToken))
  add(query_597989, "userIp", newJString(userIp))
  add(path_597988, "id", newJInt(id))
  add(query_597989, "key", newJString(key))
  add(query_597989, "prettyPrint", newJBool(prettyPrint))
  result = call_597987.call(path_597988, query_597989, nil, nil, nil)

var adexchangebuyerAccountsGet* = Call_AdexchangebuyerAccountsGet_597961(
    name: "adexchangebuyerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsGet_597962,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsGet_597963,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsPatch_598007 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerAccountsPatch_598009(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsPatch_598008(path: JsonNode; query: JsonNode;
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
  var valid_598010 = path.getOrDefault("id")
  valid_598010 = validateParameter(valid_598010, JInt, required = true, default = nil)
  if valid_598010 != nil:
    section.add "id", valid_598010
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
  var valid_598011 = query.getOrDefault("fields")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "fields", valid_598011
  var valid_598012 = query.getOrDefault("quotaUser")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "quotaUser", valid_598012
  var valid_598013 = query.getOrDefault("alt")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("json"))
  if valid_598013 != nil:
    section.add "alt", valid_598013
  var valid_598014 = query.getOrDefault("oauth_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "oauth_token", valid_598014
  var valid_598015 = query.getOrDefault("userIp")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "userIp", valid_598015
  var valid_598016 = query.getOrDefault("key")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "key", valid_598016
  var valid_598017 = query.getOrDefault("prettyPrint")
  valid_598017 = validateParameter(valid_598017, JBool, required = false,
                                 default = newJBool(true))
  if valid_598017 != nil:
    section.add "prettyPrint", valid_598017
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

proc call*(call_598019: Call_AdexchangebuyerAccountsPatch_598007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  let valid = call_598019.validator(path, query, header, formData, body)
  let scheme = call_598019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598019.url(scheme.get, call_598019.host, call_598019.base,
                         call_598019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598019, url, valid)

proc call*(call_598020: Call_AdexchangebuyerAccountsPatch_598007; id: int;
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
  var path_598021 = newJObject()
  var query_598022 = newJObject()
  var body_598023 = newJObject()
  add(query_598022, "fields", newJString(fields))
  add(query_598022, "quotaUser", newJString(quotaUser))
  add(query_598022, "alt", newJString(alt))
  add(query_598022, "oauth_token", newJString(oauthToken))
  add(query_598022, "userIp", newJString(userIp))
  add(path_598021, "id", newJInt(id))
  add(query_598022, "key", newJString(key))
  if body != nil:
    body_598023 = body
  add(query_598022, "prettyPrint", newJBool(prettyPrint))
  result = call_598020.call(path_598021, query_598022, nil, nil, body_598023)

var adexchangebuyerAccountsPatch* = Call_AdexchangebuyerAccountsPatch_598007(
    name: "adexchangebuyerAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsPatch_598008,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsPatch_598009,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoList_598024 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerBillingInfoList_598026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerBillingInfoList_598025(path: JsonNode;
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
  var valid_598027 = query.getOrDefault("fields")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "fields", valid_598027
  var valid_598028 = query.getOrDefault("quotaUser")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "quotaUser", valid_598028
  var valid_598029 = query.getOrDefault("alt")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = newJString("json"))
  if valid_598029 != nil:
    section.add "alt", valid_598029
  var valid_598030 = query.getOrDefault("oauth_token")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "oauth_token", valid_598030
  var valid_598031 = query.getOrDefault("userIp")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "userIp", valid_598031
  var valid_598032 = query.getOrDefault("key")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "key", valid_598032
  var valid_598033 = query.getOrDefault("prettyPrint")
  valid_598033 = validateParameter(valid_598033, JBool, required = false,
                                 default = newJBool(true))
  if valid_598033 != nil:
    section.add "prettyPrint", valid_598033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598034: Call_AdexchangebuyerBillingInfoList_598024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
  ## 
  let valid = call_598034.validator(path, query, header, formData, body)
  let scheme = call_598034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598034.url(scheme.get, call_598034.host, call_598034.base,
                         call_598034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598034, url, valid)

proc call*(call_598035: Call_AdexchangebuyerBillingInfoList_598024;
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
  var query_598036 = newJObject()
  add(query_598036, "fields", newJString(fields))
  add(query_598036, "quotaUser", newJString(quotaUser))
  add(query_598036, "alt", newJString(alt))
  add(query_598036, "oauth_token", newJString(oauthToken))
  add(query_598036, "userIp", newJString(userIp))
  add(query_598036, "key", newJString(key))
  add(query_598036, "prettyPrint", newJBool(prettyPrint))
  result = call_598035.call(nil, query_598036, nil, nil, nil)

var adexchangebuyerBillingInfoList* = Call_AdexchangebuyerBillingInfoList_598024(
    name: "adexchangebuyerBillingInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo",
    validator: validate_AdexchangebuyerBillingInfoList_598025,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBillingInfoList_598026,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoGet_598037 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerBillingInfoGet_598039(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBillingInfoGet_598038(path: JsonNode; query: JsonNode;
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
  var valid_598040 = path.getOrDefault("accountId")
  valid_598040 = validateParameter(valid_598040, JInt, required = true, default = nil)
  if valid_598040 != nil:
    section.add "accountId", valid_598040
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
  var valid_598041 = query.getOrDefault("fields")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "fields", valid_598041
  var valid_598042 = query.getOrDefault("quotaUser")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "quotaUser", valid_598042
  var valid_598043 = query.getOrDefault("alt")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = newJString("json"))
  if valid_598043 != nil:
    section.add "alt", valid_598043
  var valid_598044 = query.getOrDefault("oauth_token")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "oauth_token", valid_598044
  var valid_598045 = query.getOrDefault("userIp")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "userIp", valid_598045
  var valid_598046 = query.getOrDefault("key")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "key", valid_598046
  var valid_598047 = query.getOrDefault("prettyPrint")
  valid_598047 = validateParameter(valid_598047, JBool, required = false,
                                 default = newJBool(true))
  if valid_598047 != nil:
    section.add "prettyPrint", valid_598047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598048: Call_AdexchangebuyerBillingInfoGet_598037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the billing information for one account specified by account ID.
  ## 
  let valid = call_598048.validator(path, query, header, formData, body)
  let scheme = call_598048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598048.url(scheme.get, call_598048.host, call_598048.base,
                         call_598048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598048, url, valid)

proc call*(call_598049: Call_AdexchangebuyerBillingInfoGet_598037; accountId: int;
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
  var path_598050 = newJObject()
  var query_598051 = newJObject()
  add(query_598051, "fields", newJString(fields))
  add(query_598051, "quotaUser", newJString(quotaUser))
  add(query_598051, "alt", newJString(alt))
  add(query_598051, "oauth_token", newJString(oauthToken))
  add(path_598050, "accountId", newJInt(accountId))
  add(query_598051, "userIp", newJString(userIp))
  add(query_598051, "key", newJString(key))
  add(query_598051, "prettyPrint", newJBool(prettyPrint))
  result = call_598049.call(path_598050, query_598051, nil, nil, nil)

var adexchangebuyerBillingInfoGet* = Call_AdexchangebuyerBillingInfoGet_598037(
    name: "adexchangebuyerBillingInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}",
    validator: validate_AdexchangebuyerBillingInfoGet_598038,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBillingInfoGet_598039,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetUpdate_598068 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerBudgetUpdate_598070(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetUpdate_598069(path: JsonNode; query: JsonNode;
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
  var valid_598071 = path.getOrDefault("billingId")
  valid_598071 = validateParameter(valid_598071, JString, required = true,
                                 default = nil)
  if valid_598071 != nil:
    section.add "billingId", valid_598071
  var valid_598072 = path.getOrDefault("accountId")
  valid_598072 = validateParameter(valid_598072, JString, required = true,
                                 default = nil)
  if valid_598072 != nil:
    section.add "accountId", valid_598072
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
  var valid_598073 = query.getOrDefault("fields")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "fields", valid_598073
  var valid_598074 = query.getOrDefault("quotaUser")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "quotaUser", valid_598074
  var valid_598075 = query.getOrDefault("alt")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = newJString("json"))
  if valid_598075 != nil:
    section.add "alt", valid_598075
  var valid_598076 = query.getOrDefault("oauth_token")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "oauth_token", valid_598076
  var valid_598077 = query.getOrDefault("userIp")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "userIp", valid_598077
  var valid_598078 = query.getOrDefault("key")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "key", valid_598078
  var valid_598079 = query.getOrDefault("prettyPrint")
  valid_598079 = validateParameter(valid_598079, JBool, required = false,
                                 default = newJBool(true))
  if valid_598079 != nil:
    section.add "prettyPrint", valid_598079
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

proc call*(call_598081: Call_AdexchangebuyerBudgetUpdate_598068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  let valid = call_598081.validator(path, query, header, formData, body)
  let scheme = call_598081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598081.url(scheme.get, call_598081.host, call_598081.base,
                         call_598081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598081, url, valid)

proc call*(call_598082: Call_AdexchangebuyerBudgetUpdate_598068; billingId: string;
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
  var path_598083 = newJObject()
  var query_598084 = newJObject()
  var body_598085 = newJObject()
  add(query_598084, "fields", newJString(fields))
  add(query_598084, "quotaUser", newJString(quotaUser))
  add(path_598083, "billingId", newJString(billingId))
  add(query_598084, "alt", newJString(alt))
  add(query_598084, "oauth_token", newJString(oauthToken))
  add(path_598083, "accountId", newJString(accountId))
  add(query_598084, "userIp", newJString(userIp))
  add(query_598084, "key", newJString(key))
  if body != nil:
    body_598085 = body
  add(query_598084, "prettyPrint", newJBool(prettyPrint))
  result = call_598082.call(path_598083, query_598084, nil, nil, body_598085)

var adexchangebuyerBudgetUpdate* = Call_AdexchangebuyerBudgetUpdate_598068(
    name: "adexchangebuyerBudgetUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetUpdate_598069,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetUpdate_598070,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetGet_598052 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerBudgetGet_598054(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetGet_598053(path: JsonNode; query: JsonNode;
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
  var valid_598055 = path.getOrDefault("billingId")
  valid_598055 = validateParameter(valid_598055, JString, required = true,
                                 default = nil)
  if valid_598055 != nil:
    section.add "billingId", valid_598055
  var valid_598056 = path.getOrDefault("accountId")
  valid_598056 = validateParameter(valid_598056, JString, required = true,
                                 default = nil)
  if valid_598056 != nil:
    section.add "accountId", valid_598056
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
  var valid_598057 = query.getOrDefault("fields")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "fields", valid_598057
  var valid_598058 = query.getOrDefault("quotaUser")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "quotaUser", valid_598058
  var valid_598059 = query.getOrDefault("alt")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = newJString("json"))
  if valid_598059 != nil:
    section.add "alt", valid_598059
  var valid_598060 = query.getOrDefault("oauth_token")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "oauth_token", valid_598060
  var valid_598061 = query.getOrDefault("userIp")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "userIp", valid_598061
  var valid_598062 = query.getOrDefault("key")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "key", valid_598062
  var valid_598063 = query.getOrDefault("prettyPrint")
  valid_598063 = validateParameter(valid_598063, JBool, required = false,
                                 default = newJBool(true))
  if valid_598063 != nil:
    section.add "prettyPrint", valid_598063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598064: Call_AdexchangebuyerBudgetGet_598052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  let valid = call_598064.validator(path, query, header, formData, body)
  let scheme = call_598064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598064.url(scheme.get, call_598064.host, call_598064.base,
                         call_598064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598064, url, valid)

proc call*(call_598065: Call_AdexchangebuyerBudgetGet_598052; billingId: string;
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
  var path_598066 = newJObject()
  var query_598067 = newJObject()
  add(query_598067, "fields", newJString(fields))
  add(query_598067, "quotaUser", newJString(quotaUser))
  add(path_598066, "billingId", newJString(billingId))
  add(query_598067, "alt", newJString(alt))
  add(query_598067, "oauth_token", newJString(oauthToken))
  add(path_598066, "accountId", newJString(accountId))
  add(query_598067, "userIp", newJString(userIp))
  add(query_598067, "key", newJString(key))
  add(query_598067, "prettyPrint", newJBool(prettyPrint))
  result = call_598065.call(path_598066, query_598067, nil, nil, nil)

var adexchangebuyerBudgetGet* = Call_AdexchangebuyerBudgetGet_598052(
    name: "adexchangebuyerBudgetGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetGet_598053,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetGet_598054,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetPatch_598086 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerBudgetPatch_598088(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetPatch_598087(path: JsonNode; query: JsonNode;
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
  var valid_598089 = path.getOrDefault("billingId")
  valid_598089 = validateParameter(valid_598089, JString, required = true,
                                 default = nil)
  if valid_598089 != nil:
    section.add "billingId", valid_598089
  var valid_598090 = path.getOrDefault("accountId")
  valid_598090 = validateParameter(valid_598090, JString, required = true,
                                 default = nil)
  if valid_598090 != nil:
    section.add "accountId", valid_598090
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
  var valid_598091 = query.getOrDefault("fields")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "fields", valid_598091
  var valid_598092 = query.getOrDefault("quotaUser")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "quotaUser", valid_598092
  var valid_598093 = query.getOrDefault("alt")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = newJString("json"))
  if valid_598093 != nil:
    section.add "alt", valid_598093
  var valid_598094 = query.getOrDefault("oauth_token")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "oauth_token", valid_598094
  var valid_598095 = query.getOrDefault("userIp")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "userIp", valid_598095
  var valid_598096 = query.getOrDefault("key")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "key", valid_598096
  var valid_598097 = query.getOrDefault("prettyPrint")
  valid_598097 = validateParameter(valid_598097, JBool, required = false,
                                 default = newJBool(true))
  if valid_598097 != nil:
    section.add "prettyPrint", valid_598097
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

proc call*(call_598099: Call_AdexchangebuyerBudgetPatch_598086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  let valid = call_598099.validator(path, query, header, formData, body)
  let scheme = call_598099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598099.url(scheme.get, call_598099.host, call_598099.base,
                         call_598099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598099, url, valid)

proc call*(call_598100: Call_AdexchangebuyerBudgetPatch_598086; billingId: string;
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
  var path_598101 = newJObject()
  var query_598102 = newJObject()
  var body_598103 = newJObject()
  add(query_598102, "fields", newJString(fields))
  add(query_598102, "quotaUser", newJString(quotaUser))
  add(path_598101, "billingId", newJString(billingId))
  add(query_598102, "alt", newJString(alt))
  add(query_598102, "oauth_token", newJString(oauthToken))
  add(path_598101, "accountId", newJString(accountId))
  add(query_598102, "userIp", newJString(userIp))
  add(query_598102, "key", newJString(key))
  if body != nil:
    body_598103 = body
  add(query_598102, "prettyPrint", newJBool(prettyPrint))
  result = call_598100.call(path_598101, query_598102, nil, nil, body_598103)

var adexchangebuyerBudgetPatch* = Call_AdexchangebuyerBudgetPatch_598086(
    name: "adexchangebuyerBudgetPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetPatch_598087,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetPatch_598088,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_598122 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerCreativesInsert_598124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_598123(path: JsonNode;
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
  var valid_598125 = query.getOrDefault("fields")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "fields", valid_598125
  var valid_598126 = query.getOrDefault("quotaUser")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "quotaUser", valid_598126
  var valid_598127 = query.getOrDefault("alt")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = newJString("json"))
  if valid_598127 != nil:
    section.add "alt", valid_598127
  var valid_598128 = query.getOrDefault("oauth_token")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "oauth_token", valid_598128
  var valid_598129 = query.getOrDefault("userIp")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "userIp", valid_598129
  var valid_598130 = query.getOrDefault("key")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "key", valid_598130
  var valid_598131 = query.getOrDefault("prettyPrint")
  valid_598131 = validateParameter(valid_598131, JBool, required = false,
                                 default = newJBool(true))
  if valid_598131 != nil:
    section.add "prettyPrint", valid_598131
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

proc call*(call_598133: Call_AdexchangebuyerCreativesInsert_598122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_598133.validator(path, query, header, formData, body)
  let scheme = call_598133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598133.url(scheme.get, call_598133.host, call_598133.base,
                         call_598133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598133, url, valid)

proc call*(call_598134: Call_AdexchangebuyerCreativesInsert_598122;
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
  var query_598135 = newJObject()
  var body_598136 = newJObject()
  add(query_598135, "fields", newJString(fields))
  add(query_598135, "quotaUser", newJString(quotaUser))
  add(query_598135, "alt", newJString(alt))
  add(query_598135, "oauth_token", newJString(oauthToken))
  add(query_598135, "userIp", newJString(userIp))
  add(query_598135, "key", newJString(key))
  if body != nil:
    body_598136 = body
  add(query_598135, "prettyPrint", newJBool(prettyPrint))
  result = call_598134.call(nil, query_598135, nil, nil, body_598136)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_598122(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_598123,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesInsert_598124,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_598104 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerCreativesList_598106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_598105(path: JsonNode; query: JsonNode;
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
  var valid_598107 = query.getOrDefault("buyerCreativeId")
  valid_598107 = validateParameter(valid_598107, JArray, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "buyerCreativeId", valid_598107
  var valid_598108 = query.getOrDefault("fields")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "fields", valid_598108
  var valid_598109 = query.getOrDefault("pageToken")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "pageToken", valid_598109
  var valid_598110 = query.getOrDefault("quotaUser")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "quotaUser", valid_598110
  var valid_598111 = query.getOrDefault("statusFilter")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = newJString("approved"))
  if valid_598111 != nil:
    section.add "statusFilter", valid_598111
  var valid_598112 = query.getOrDefault("alt")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = newJString("json"))
  if valid_598112 != nil:
    section.add "alt", valid_598112
  var valid_598113 = query.getOrDefault("oauth_token")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "oauth_token", valid_598113
  var valid_598114 = query.getOrDefault("accountId")
  valid_598114 = validateParameter(valid_598114, JArray, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "accountId", valid_598114
  var valid_598115 = query.getOrDefault("userIp")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "userIp", valid_598115
  var valid_598116 = query.getOrDefault("maxResults")
  valid_598116 = validateParameter(valid_598116, JInt, required = false, default = nil)
  if valid_598116 != nil:
    section.add "maxResults", valid_598116
  var valid_598117 = query.getOrDefault("key")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "key", valid_598117
  var valid_598118 = query.getOrDefault("prettyPrint")
  valid_598118 = validateParameter(valid_598118, JBool, required = false,
                                 default = newJBool(true))
  if valid_598118 != nil:
    section.add "prettyPrint", valid_598118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598119: Call_AdexchangebuyerCreativesList_598104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_598119.validator(path, query, header, formData, body)
  let scheme = call_598119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598119.url(scheme.get, call_598119.host, call_598119.base,
                         call_598119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598119, url, valid)

proc call*(call_598120: Call_AdexchangebuyerCreativesList_598104;
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
  var query_598121 = newJObject()
  if buyerCreativeId != nil:
    query_598121.add "buyerCreativeId", buyerCreativeId
  add(query_598121, "fields", newJString(fields))
  add(query_598121, "pageToken", newJString(pageToken))
  add(query_598121, "quotaUser", newJString(quotaUser))
  add(query_598121, "statusFilter", newJString(statusFilter))
  add(query_598121, "alt", newJString(alt))
  add(query_598121, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_598121.add "accountId", accountId
  add(query_598121, "userIp", newJString(userIp))
  add(query_598121, "maxResults", newJInt(maxResults))
  add(query_598121, "key", newJString(key))
  add(query_598121, "prettyPrint", newJBool(prettyPrint))
  result = call_598120.call(nil, query_598121, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_598104(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_598105,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesList_598106,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_598137 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerCreativesGet_598139(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesGet_598138(path: JsonNode; query: JsonNode;
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
  var valid_598140 = path.getOrDefault("accountId")
  valid_598140 = validateParameter(valid_598140, JInt, required = true, default = nil)
  if valid_598140 != nil:
    section.add "accountId", valid_598140
  var valid_598141 = path.getOrDefault("buyerCreativeId")
  valid_598141 = validateParameter(valid_598141, JString, required = true,
                                 default = nil)
  if valid_598141 != nil:
    section.add "buyerCreativeId", valid_598141
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
  var valid_598142 = query.getOrDefault("fields")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "fields", valid_598142
  var valid_598143 = query.getOrDefault("quotaUser")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "quotaUser", valid_598143
  var valid_598144 = query.getOrDefault("alt")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = newJString("json"))
  if valid_598144 != nil:
    section.add "alt", valid_598144
  var valid_598145 = query.getOrDefault("oauth_token")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "oauth_token", valid_598145
  var valid_598146 = query.getOrDefault("userIp")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "userIp", valid_598146
  var valid_598147 = query.getOrDefault("key")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "key", valid_598147
  var valid_598148 = query.getOrDefault("prettyPrint")
  valid_598148 = validateParameter(valid_598148, JBool, required = false,
                                 default = newJBool(true))
  if valid_598148 != nil:
    section.add "prettyPrint", valid_598148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598149: Call_AdexchangebuyerCreativesGet_598137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_598149.validator(path, query, header, formData, body)
  let scheme = call_598149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598149.url(scheme.get, call_598149.host, call_598149.base,
                         call_598149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598149, url, valid)

proc call*(call_598150: Call_AdexchangebuyerCreativesGet_598137; accountId: int;
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
  var path_598151 = newJObject()
  var query_598152 = newJObject()
  add(query_598152, "fields", newJString(fields))
  add(query_598152, "quotaUser", newJString(quotaUser))
  add(query_598152, "alt", newJString(alt))
  add(query_598152, "oauth_token", newJString(oauthToken))
  add(path_598151, "accountId", newJInt(accountId))
  add(query_598152, "userIp", newJString(userIp))
  add(path_598151, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_598152, "key", newJString(key))
  add(query_598152, "prettyPrint", newJBool(prettyPrint))
  result = call_598150.call(path_598151, query_598152, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_598137(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_598138,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesGet_598139,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerDirectDealsList_598153 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerDirectDealsList_598155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerDirectDealsList_598154(path: JsonNode;
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
  var valid_598156 = query.getOrDefault("fields")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "fields", valid_598156
  var valid_598157 = query.getOrDefault("quotaUser")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "quotaUser", valid_598157
  var valid_598158 = query.getOrDefault("alt")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = newJString("json"))
  if valid_598158 != nil:
    section.add "alt", valid_598158
  var valid_598159 = query.getOrDefault("oauth_token")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "oauth_token", valid_598159
  var valid_598160 = query.getOrDefault("userIp")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "userIp", valid_598160
  var valid_598161 = query.getOrDefault("key")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "key", valid_598161
  var valid_598162 = query.getOrDefault("prettyPrint")
  valid_598162 = validateParameter(valid_598162, JBool, required = false,
                                 default = newJBool(true))
  if valid_598162 != nil:
    section.add "prettyPrint", valid_598162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598163: Call_AdexchangebuyerDirectDealsList_598153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of direct deals.
  ## 
  let valid = call_598163.validator(path, query, header, formData, body)
  let scheme = call_598163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598163.url(scheme.get, call_598163.host, call_598163.base,
                         call_598163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598163, url, valid)

proc call*(call_598164: Call_AdexchangebuyerDirectDealsList_598153;
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
  var query_598165 = newJObject()
  add(query_598165, "fields", newJString(fields))
  add(query_598165, "quotaUser", newJString(quotaUser))
  add(query_598165, "alt", newJString(alt))
  add(query_598165, "oauth_token", newJString(oauthToken))
  add(query_598165, "userIp", newJString(userIp))
  add(query_598165, "key", newJString(key))
  add(query_598165, "prettyPrint", newJBool(prettyPrint))
  result = call_598164.call(nil, query_598165, nil, nil, nil)

var adexchangebuyerDirectDealsList* = Call_AdexchangebuyerDirectDealsList_598153(
    name: "adexchangebuyerDirectDealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/directdeals",
    validator: validate_AdexchangebuyerDirectDealsList_598154,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerDirectDealsList_598155,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerDirectDealsGet_598166 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerDirectDealsGet_598168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/directdeals/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangebuyerDirectDealsGet_598167(path: JsonNode; query: JsonNode;
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
  var valid_598169 = path.getOrDefault("id")
  valid_598169 = validateParameter(valid_598169, JString, required = true,
                                 default = nil)
  if valid_598169 != nil:
    section.add "id", valid_598169
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
  var valid_598170 = query.getOrDefault("fields")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "fields", valid_598170
  var valid_598171 = query.getOrDefault("quotaUser")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "quotaUser", valid_598171
  var valid_598172 = query.getOrDefault("alt")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = newJString("json"))
  if valid_598172 != nil:
    section.add "alt", valid_598172
  var valid_598173 = query.getOrDefault("oauth_token")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "oauth_token", valid_598173
  var valid_598174 = query.getOrDefault("userIp")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "userIp", valid_598174
  var valid_598175 = query.getOrDefault("key")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "key", valid_598175
  var valid_598176 = query.getOrDefault("prettyPrint")
  valid_598176 = validateParameter(valid_598176, JBool, required = false,
                                 default = newJBool(true))
  if valid_598176 != nil:
    section.add "prettyPrint", valid_598176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598177: Call_AdexchangebuyerDirectDealsGet_598166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one direct deal by ID.
  ## 
  let valid = call_598177.validator(path, query, header, formData, body)
  let scheme = call_598177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598177.url(scheme.get, call_598177.host, call_598177.base,
                         call_598177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598177, url, valid)

proc call*(call_598178: Call_AdexchangebuyerDirectDealsGet_598166; id: string;
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
  var path_598179 = newJObject()
  var query_598180 = newJObject()
  add(query_598180, "fields", newJString(fields))
  add(query_598180, "quotaUser", newJString(quotaUser))
  add(query_598180, "alt", newJString(alt))
  add(query_598180, "oauth_token", newJString(oauthToken))
  add(query_598180, "userIp", newJString(userIp))
  add(path_598179, "id", newJString(id))
  add(query_598180, "key", newJString(key))
  add(query_598180, "prettyPrint", newJBool(prettyPrint))
  result = call_598178.call(path_598179, query_598180, nil, nil, nil)

var adexchangebuyerDirectDealsGet* = Call_AdexchangebuyerDirectDealsGet_598166(
    name: "adexchangebuyerDirectDealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/directdeals/{id}",
    validator: validate_AdexchangebuyerDirectDealsGet_598167,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerDirectDealsGet_598168,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPerformanceReportList_598181 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerPerformanceReportList_598183(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerPerformanceReportList_598182(path: JsonNode;
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
  var valid_598184 = query.getOrDefault("fields")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "fields", valid_598184
  var valid_598185 = query.getOrDefault("pageToken")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "pageToken", valid_598185
  var valid_598186 = query.getOrDefault("quotaUser")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "quotaUser", valid_598186
  var valid_598187 = query.getOrDefault("alt")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = newJString("json"))
  if valid_598187 != nil:
    section.add "alt", valid_598187
  assert query != nil,
        "query argument is necessary due to required `startDateTime` field"
  var valid_598188 = query.getOrDefault("startDateTime")
  valid_598188 = validateParameter(valid_598188, JString, required = true,
                                 default = nil)
  if valid_598188 != nil:
    section.add "startDateTime", valid_598188
  var valid_598189 = query.getOrDefault("oauth_token")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "oauth_token", valid_598189
  var valid_598190 = query.getOrDefault("accountId")
  valid_598190 = validateParameter(valid_598190, JString, required = true,
                                 default = nil)
  if valid_598190 != nil:
    section.add "accountId", valid_598190
  var valid_598191 = query.getOrDefault("userIp")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "userIp", valid_598191
  var valid_598192 = query.getOrDefault("maxResults")
  valid_598192 = validateParameter(valid_598192, JInt, required = false, default = nil)
  if valid_598192 != nil:
    section.add "maxResults", valid_598192
  var valid_598193 = query.getOrDefault("key")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "key", valid_598193
  var valid_598194 = query.getOrDefault("endDateTime")
  valid_598194 = validateParameter(valid_598194, JString, required = true,
                                 default = nil)
  if valid_598194 != nil:
    section.add "endDateTime", valid_598194
  var valid_598195 = query.getOrDefault("prettyPrint")
  valid_598195 = validateParameter(valid_598195, JBool, required = false,
                                 default = newJBool(true))
  if valid_598195 != nil:
    section.add "prettyPrint", valid_598195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598196: Call_AdexchangebuyerPerformanceReportList_598181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  let valid = call_598196.validator(path, query, header, formData, body)
  let scheme = call_598196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598196.url(scheme.get, call_598196.host, call_598196.base,
                         call_598196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598196, url, valid)

proc call*(call_598197: Call_AdexchangebuyerPerformanceReportList_598181;
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
  var query_598198 = newJObject()
  add(query_598198, "fields", newJString(fields))
  add(query_598198, "pageToken", newJString(pageToken))
  add(query_598198, "quotaUser", newJString(quotaUser))
  add(query_598198, "alt", newJString(alt))
  add(query_598198, "startDateTime", newJString(startDateTime))
  add(query_598198, "oauth_token", newJString(oauthToken))
  add(query_598198, "accountId", newJString(accountId))
  add(query_598198, "userIp", newJString(userIp))
  add(query_598198, "maxResults", newJInt(maxResults))
  add(query_598198, "key", newJString(key))
  add(query_598198, "endDateTime", newJString(endDateTime))
  add(query_598198, "prettyPrint", newJBool(prettyPrint))
  result = call_598197.call(nil, query_598198, nil, nil, nil)

var adexchangebuyerPerformanceReportList* = Call_AdexchangebuyerPerformanceReportList_598181(
    name: "adexchangebuyerPerformanceReportList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/performancereport",
    validator: validate_AdexchangebuyerPerformanceReportList_598182,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPerformanceReportList_598183,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigInsert_598214 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerPretargetingConfigInsert_598216(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigInsert_598215(path: JsonNode;
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
  var valid_598217 = path.getOrDefault("accountId")
  valid_598217 = validateParameter(valid_598217, JString, required = true,
                                 default = nil)
  if valid_598217 != nil:
    section.add "accountId", valid_598217
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
  var valid_598218 = query.getOrDefault("fields")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = nil)
  if valid_598218 != nil:
    section.add "fields", valid_598218
  var valid_598219 = query.getOrDefault("quotaUser")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "quotaUser", valid_598219
  var valid_598220 = query.getOrDefault("alt")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = newJString("json"))
  if valid_598220 != nil:
    section.add "alt", valid_598220
  var valid_598221 = query.getOrDefault("oauth_token")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "oauth_token", valid_598221
  var valid_598222 = query.getOrDefault("userIp")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "userIp", valid_598222
  var valid_598223 = query.getOrDefault("key")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "key", valid_598223
  var valid_598224 = query.getOrDefault("prettyPrint")
  valid_598224 = validateParameter(valid_598224, JBool, required = false,
                                 default = newJBool(true))
  if valid_598224 != nil:
    section.add "prettyPrint", valid_598224
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

proc call*(call_598226: Call_AdexchangebuyerPretargetingConfigInsert_598214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new pretargeting configuration.
  ## 
  let valid = call_598226.validator(path, query, header, formData, body)
  let scheme = call_598226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598226.url(scheme.get, call_598226.host, call_598226.base,
                         call_598226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598226, url, valid)

proc call*(call_598227: Call_AdexchangebuyerPretargetingConfigInsert_598214;
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
  var path_598228 = newJObject()
  var query_598229 = newJObject()
  var body_598230 = newJObject()
  add(query_598229, "fields", newJString(fields))
  add(query_598229, "quotaUser", newJString(quotaUser))
  add(query_598229, "alt", newJString(alt))
  add(query_598229, "oauth_token", newJString(oauthToken))
  add(path_598228, "accountId", newJString(accountId))
  add(query_598229, "userIp", newJString(userIp))
  add(query_598229, "key", newJString(key))
  if body != nil:
    body_598230 = body
  add(query_598229, "prettyPrint", newJBool(prettyPrint))
  result = call_598227.call(path_598228, query_598229, nil, nil, body_598230)

var adexchangebuyerPretargetingConfigInsert* = Call_AdexchangebuyerPretargetingConfigInsert_598214(
    name: "adexchangebuyerPretargetingConfigInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigInsert_598215,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigInsert_598216,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigList_598199 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerPretargetingConfigList_598201(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigList_598200(path: JsonNode;
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
  var valid_598202 = path.getOrDefault("accountId")
  valid_598202 = validateParameter(valid_598202, JString, required = true,
                                 default = nil)
  if valid_598202 != nil:
    section.add "accountId", valid_598202
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
  var valid_598203 = query.getOrDefault("fields")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "fields", valid_598203
  var valid_598204 = query.getOrDefault("quotaUser")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "quotaUser", valid_598204
  var valid_598205 = query.getOrDefault("alt")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = newJString("json"))
  if valid_598205 != nil:
    section.add "alt", valid_598205
  var valid_598206 = query.getOrDefault("oauth_token")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "oauth_token", valid_598206
  var valid_598207 = query.getOrDefault("userIp")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "userIp", valid_598207
  var valid_598208 = query.getOrDefault("key")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "key", valid_598208
  var valid_598209 = query.getOrDefault("prettyPrint")
  valid_598209 = validateParameter(valid_598209, JBool, required = false,
                                 default = newJBool(true))
  if valid_598209 != nil:
    section.add "prettyPrint", valid_598209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598210: Call_AdexchangebuyerPretargetingConfigList_598199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  let valid = call_598210.validator(path, query, header, formData, body)
  let scheme = call_598210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598210.url(scheme.get, call_598210.host, call_598210.base,
                         call_598210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598210, url, valid)

proc call*(call_598211: Call_AdexchangebuyerPretargetingConfigList_598199;
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
  var path_598212 = newJObject()
  var query_598213 = newJObject()
  add(query_598213, "fields", newJString(fields))
  add(query_598213, "quotaUser", newJString(quotaUser))
  add(query_598213, "alt", newJString(alt))
  add(query_598213, "oauth_token", newJString(oauthToken))
  add(path_598212, "accountId", newJString(accountId))
  add(query_598213, "userIp", newJString(userIp))
  add(query_598213, "key", newJString(key))
  add(query_598213, "prettyPrint", newJBool(prettyPrint))
  result = call_598211.call(path_598212, query_598213, nil, nil, nil)

var adexchangebuyerPretargetingConfigList* = Call_AdexchangebuyerPretargetingConfigList_598199(
    name: "adexchangebuyerPretargetingConfigList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigList_598200,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPretargetingConfigList_598201,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigUpdate_598247 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerPretargetingConfigUpdate_598249(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigUpdate_598248(path: JsonNode;
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
  var valid_598250 = path.getOrDefault("accountId")
  valid_598250 = validateParameter(valid_598250, JString, required = true,
                                 default = nil)
  if valid_598250 != nil:
    section.add "accountId", valid_598250
  var valid_598251 = path.getOrDefault("configId")
  valid_598251 = validateParameter(valid_598251, JString, required = true,
                                 default = nil)
  if valid_598251 != nil:
    section.add "configId", valid_598251
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
  var valid_598252 = query.getOrDefault("fields")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "fields", valid_598252
  var valid_598253 = query.getOrDefault("quotaUser")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "quotaUser", valid_598253
  var valid_598254 = query.getOrDefault("alt")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = newJString("json"))
  if valid_598254 != nil:
    section.add "alt", valid_598254
  var valid_598255 = query.getOrDefault("oauth_token")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "oauth_token", valid_598255
  var valid_598256 = query.getOrDefault("userIp")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "userIp", valid_598256
  var valid_598257 = query.getOrDefault("key")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = nil)
  if valid_598257 != nil:
    section.add "key", valid_598257
  var valid_598258 = query.getOrDefault("prettyPrint")
  valid_598258 = validateParameter(valid_598258, JBool, required = false,
                                 default = newJBool(true))
  if valid_598258 != nil:
    section.add "prettyPrint", valid_598258
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

proc call*(call_598260: Call_AdexchangebuyerPretargetingConfigUpdate_598247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config.
  ## 
  let valid = call_598260.validator(path, query, header, formData, body)
  let scheme = call_598260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598260.url(scheme.get, call_598260.host, call_598260.base,
                         call_598260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598260, url, valid)

proc call*(call_598261: Call_AdexchangebuyerPretargetingConfigUpdate_598247;
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
  var path_598262 = newJObject()
  var query_598263 = newJObject()
  var body_598264 = newJObject()
  add(query_598263, "fields", newJString(fields))
  add(query_598263, "quotaUser", newJString(quotaUser))
  add(query_598263, "alt", newJString(alt))
  add(query_598263, "oauth_token", newJString(oauthToken))
  add(path_598262, "accountId", newJString(accountId))
  add(query_598263, "userIp", newJString(userIp))
  add(query_598263, "key", newJString(key))
  add(path_598262, "configId", newJString(configId))
  if body != nil:
    body_598264 = body
  add(query_598263, "prettyPrint", newJBool(prettyPrint))
  result = call_598261.call(path_598262, query_598263, nil, nil, body_598264)

var adexchangebuyerPretargetingConfigUpdate* = Call_AdexchangebuyerPretargetingConfigUpdate_598247(
    name: "adexchangebuyerPretargetingConfigUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigUpdate_598248,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigUpdate_598249,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigGet_598231 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerPretargetingConfigGet_598233(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigGet_598232(path: JsonNode;
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
  var valid_598234 = path.getOrDefault("accountId")
  valid_598234 = validateParameter(valid_598234, JString, required = true,
                                 default = nil)
  if valid_598234 != nil:
    section.add "accountId", valid_598234
  var valid_598235 = path.getOrDefault("configId")
  valid_598235 = validateParameter(valid_598235, JString, required = true,
                                 default = nil)
  if valid_598235 != nil:
    section.add "configId", valid_598235
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
  var valid_598236 = query.getOrDefault("fields")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = nil)
  if valid_598236 != nil:
    section.add "fields", valid_598236
  var valid_598237 = query.getOrDefault("quotaUser")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = nil)
  if valid_598237 != nil:
    section.add "quotaUser", valid_598237
  var valid_598238 = query.getOrDefault("alt")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = newJString("json"))
  if valid_598238 != nil:
    section.add "alt", valid_598238
  var valid_598239 = query.getOrDefault("oauth_token")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "oauth_token", valid_598239
  var valid_598240 = query.getOrDefault("userIp")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "userIp", valid_598240
  var valid_598241 = query.getOrDefault("key")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "key", valid_598241
  var valid_598242 = query.getOrDefault("prettyPrint")
  valid_598242 = validateParameter(valid_598242, JBool, required = false,
                                 default = newJBool(true))
  if valid_598242 != nil:
    section.add "prettyPrint", valid_598242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598243: Call_AdexchangebuyerPretargetingConfigGet_598231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific pretargeting configuration
  ## 
  let valid = call_598243.validator(path, query, header, formData, body)
  let scheme = call_598243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598243.url(scheme.get, call_598243.host, call_598243.base,
                         call_598243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598243, url, valid)

proc call*(call_598244: Call_AdexchangebuyerPretargetingConfigGet_598231;
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
  var path_598245 = newJObject()
  var query_598246 = newJObject()
  add(query_598246, "fields", newJString(fields))
  add(query_598246, "quotaUser", newJString(quotaUser))
  add(query_598246, "alt", newJString(alt))
  add(query_598246, "oauth_token", newJString(oauthToken))
  add(path_598245, "accountId", newJString(accountId))
  add(query_598246, "userIp", newJString(userIp))
  add(query_598246, "key", newJString(key))
  add(path_598245, "configId", newJString(configId))
  add(query_598246, "prettyPrint", newJBool(prettyPrint))
  result = call_598244.call(path_598245, query_598246, nil, nil, nil)

var adexchangebuyerPretargetingConfigGet* = Call_AdexchangebuyerPretargetingConfigGet_598231(
    name: "adexchangebuyerPretargetingConfigGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigGet_598232,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPretargetingConfigGet_598233,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigPatch_598281 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerPretargetingConfigPatch_598283(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigPatch_598282(path: JsonNode;
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
  var valid_598284 = path.getOrDefault("accountId")
  valid_598284 = validateParameter(valid_598284, JString, required = true,
                                 default = nil)
  if valid_598284 != nil:
    section.add "accountId", valid_598284
  var valid_598285 = path.getOrDefault("configId")
  valid_598285 = validateParameter(valid_598285, JString, required = true,
                                 default = nil)
  if valid_598285 != nil:
    section.add "configId", valid_598285
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
  var valid_598286 = query.getOrDefault("fields")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "fields", valid_598286
  var valid_598287 = query.getOrDefault("quotaUser")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "quotaUser", valid_598287
  var valid_598288 = query.getOrDefault("alt")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = newJString("json"))
  if valid_598288 != nil:
    section.add "alt", valid_598288
  var valid_598289 = query.getOrDefault("oauth_token")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "oauth_token", valid_598289
  var valid_598290 = query.getOrDefault("userIp")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "userIp", valid_598290
  var valid_598291 = query.getOrDefault("key")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "key", valid_598291
  var valid_598292 = query.getOrDefault("prettyPrint")
  valid_598292 = validateParameter(valid_598292, JBool, required = false,
                                 default = newJBool(true))
  if valid_598292 != nil:
    section.add "prettyPrint", valid_598292
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

proc call*(call_598294: Call_AdexchangebuyerPretargetingConfigPatch_598281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  let valid = call_598294.validator(path, query, header, formData, body)
  let scheme = call_598294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598294.url(scheme.get, call_598294.host, call_598294.base,
                         call_598294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598294, url, valid)

proc call*(call_598295: Call_AdexchangebuyerPretargetingConfigPatch_598281;
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
  var path_598296 = newJObject()
  var query_598297 = newJObject()
  var body_598298 = newJObject()
  add(query_598297, "fields", newJString(fields))
  add(query_598297, "quotaUser", newJString(quotaUser))
  add(query_598297, "alt", newJString(alt))
  add(query_598297, "oauth_token", newJString(oauthToken))
  add(path_598296, "accountId", newJString(accountId))
  add(query_598297, "userIp", newJString(userIp))
  add(query_598297, "key", newJString(key))
  add(path_598296, "configId", newJString(configId))
  if body != nil:
    body_598298 = body
  add(query_598297, "prettyPrint", newJBool(prettyPrint))
  result = call_598295.call(path_598296, query_598297, nil, nil, body_598298)

var adexchangebuyerPretargetingConfigPatch* = Call_AdexchangebuyerPretargetingConfigPatch_598281(
    name: "adexchangebuyerPretargetingConfigPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigPatch_598282,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigPatch_598283,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigDelete_598265 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerPretargetingConfigDelete_598267(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigDelete_598266(path: JsonNode;
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
  var valid_598268 = path.getOrDefault("accountId")
  valid_598268 = validateParameter(valid_598268, JString, required = true,
                                 default = nil)
  if valid_598268 != nil:
    section.add "accountId", valid_598268
  var valid_598269 = path.getOrDefault("configId")
  valid_598269 = validateParameter(valid_598269, JString, required = true,
                                 default = nil)
  if valid_598269 != nil:
    section.add "configId", valid_598269
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
  var valid_598270 = query.getOrDefault("fields")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "fields", valid_598270
  var valid_598271 = query.getOrDefault("quotaUser")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "quotaUser", valid_598271
  var valid_598272 = query.getOrDefault("alt")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = newJString("json"))
  if valid_598272 != nil:
    section.add "alt", valid_598272
  var valid_598273 = query.getOrDefault("oauth_token")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "oauth_token", valid_598273
  var valid_598274 = query.getOrDefault("userIp")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "userIp", valid_598274
  var valid_598275 = query.getOrDefault("key")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = nil)
  if valid_598275 != nil:
    section.add "key", valid_598275
  var valid_598276 = query.getOrDefault("prettyPrint")
  valid_598276 = validateParameter(valid_598276, JBool, required = false,
                                 default = newJBool(true))
  if valid_598276 != nil:
    section.add "prettyPrint", valid_598276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598277: Call_AdexchangebuyerPretargetingConfigDelete_598265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing pretargeting config.
  ## 
  let valid = call_598277.validator(path, query, header, formData, body)
  let scheme = call_598277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598277.url(scheme.get, call_598277.host, call_598277.base,
                         call_598277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598277, url, valid)

proc call*(call_598278: Call_AdexchangebuyerPretargetingConfigDelete_598265;
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
  var path_598279 = newJObject()
  var query_598280 = newJObject()
  add(query_598280, "fields", newJString(fields))
  add(query_598280, "quotaUser", newJString(quotaUser))
  add(query_598280, "alt", newJString(alt))
  add(query_598280, "oauth_token", newJString(oauthToken))
  add(path_598279, "accountId", newJString(accountId))
  add(query_598280, "userIp", newJString(userIp))
  add(query_598280, "key", newJString(key))
  add(path_598279, "configId", newJString(configId))
  add(query_598280, "prettyPrint", newJBool(prettyPrint))
  result = call_598278.call(path_598279, query_598280, nil, nil, nil)

var adexchangebuyerPretargetingConfigDelete* = Call_AdexchangebuyerPretargetingConfigDelete_598265(
    name: "adexchangebuyerPretargetingConfigDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigDelete_598266,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigDelete_598267,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
