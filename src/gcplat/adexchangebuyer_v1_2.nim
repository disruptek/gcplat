
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Ad Exchange Buyer
## version: v1.2
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
    base: "/adexchangebuyer/v1.2", url: url_AdexchangebuyerAccountsList_597695,
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
    base: "/adexchangebuyer/v1.2", url: url_AdexchangebuyerAccountsUpdate_597992,
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
    base: "/adexchangebuyer/v1.2", url: url_AdexchangebuyerAccountsGet_597963,
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
    base: "/adexchangebuyer/v1.2", url: url_AdexchangebuyerAccountsPatch_598009,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_598040 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerCreativesInsert_598042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_598041(path: JsonNode;
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
  var valid_598043 = query.getOrDefault("fields")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "fields", valid_598043
  var valid_598044 = query.getOrDefault("quotaUser")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "quotaUser", valid_598044
  var valid_598045 = query.getOrDefault("alt")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = newJString("json"))
  if valid_598045 != nil:
    section.add "alt", valid_598045
  var valid_598046 = query.getOrDefault("oauth_token")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "oauth_token", valid_598046
  var valid_598047 = query.getOrDefault("userIp")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "userIp", valid_598047
  var valid_598048 = query.getOrDefault("key")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "key", valid_598048
  var valid_598049 = query.getOrDefault("prettyPrint")
  valid_598049 = validateParameter(valid_598049, JBool, required = false,
                                 default = newJBool(true))
  if valid_598049 != nil:
    section.add "prettyPrint", valid_598049
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

proc call*(call_598051: Call_AdexchangebuyerCreativesInsert_598040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_598051.validator(path, query, header, formData, body)
  let scheme = call_598051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598051.url(scheme.get, call_598051.host, call_598051.base,
                         call_598051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598051, url, valid)

proc call*(call_598052: Call_AdexchangebuyerCreativesInsert_598040;
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
  var query_598053 = newJObject()
  var body_598054 = newJObject()
  add(query_598053, "fields", newJString(fields))
  add(query_598053, "quotaUser", newJString(quotaUser))
  add(query_598053, "alt", newJString(alt))
  add(query_598053, "oauth_token", newJString(oauthToken))
  add(query_598053, "userIp", newJString(userIp))
  add(query_598053, "key", newJString(key))
  if body != nil:
    body_598054 = body
  add(query_598053, "prettyPrint", newJBool(prettyPrint))
  result = call_598052.call(nil, query_598053, nil, nil, body_598054)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_598040(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_598041,
    base: "/adexchangebuyer/v1.2", url: url_AdexchangebuyerCreativesInsert_598042,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_598024 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerCreativesList_598026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_598025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
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
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
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
  var valid_598028 = query.getOrDefault("pageToken")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "pageToken", valid_598028
  var valid_598029 = query.getOrDefault("quotaUser")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "quotaUser", valid_598029
  var valid_598030 = query.getOrDefault("statusFilter")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = newJString("approved"))
  if valid_598030 != nil:
    section.add "statusFilter", valid_598030
  var valid_598031 = query.getOrDefault("alt")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = newJString("json"))
  if valid_598031 != nil:
    section.add "alt", valid_598031
  var valid_598032 = query.getOrDefault("oauth_token")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "oauth_token", valid_598032
  var valid_598033 = query.getOrDefault("userIp")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "userIp", valid_598033
  var valid_598034 = query.getOrDefault("maxResults")
  valid_598034 = validateParameter(valid_598034, JInt, required = false, default = nil)
  if valid_598034 != nil:
    section.add "maxResults", valid_598034
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

proc call*(call_598037: Call_AdexchangebuyerCreativesList_598024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_598037.validator(path, query, header, formData, body)
  let scheme = call_598037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598037.url(scheme.get, call_598037.host, call_598037.base,
                         call_598037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598037, url, valid)

proc call*(call_598038: Call_AdexchangebuyerCreativesList_598024;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          statusFilter: string = "approved"; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangebuyerCreativesList
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
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
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598039 = newJObject()
  add(query_598039, "fields", newJString(fields))
  add(query_598039, "pageToken", newJString(pageToken))
  add(query_598039, "quotaUser", newJString(quotaUser))
  add(query_598039, "statusFilter", newJString(statusFilter))
  add(query_598039, "alt", newJString(alt))
  add(query_598039, "oauth_token", newJString(oauthToken))
  add(query_598039, "userIp", newJString(userIp))
  add(query_598039, "maxResults", newJInt(maxResults))
  add(query_598039, "key", newJString(key))
  add(query_598039, "prettyPrint", newJBool(prettyPrint))
  result = call_598038.call(nil, query_598039, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_598024(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_598025,
    base: "/adexchangebuyer/v1.2", url: url_AdexchangebuyerCreativesList_598026,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_598055 = ref object of OpenApiRestCall_597424
proc url_AdexchangebuyerCreativesGet_598057(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesGet_598056(path: JsonNode; query: JsonNode;
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
  var valid_598058 = path.getOrDefault("accountId")
  valid_598058 = validateParameter(valid_598058, JInt, required = true, default = nil)
  if valid_598058 != nil:
    section.add "accountId", valid_598058
  var valid_598059 = path.getOrDefault("buyerCreativeId")
  valid_598059 = validateParameter(valid_598059, JString, required = true,
                                 default = nil)
  if valid_598059 != nil:
    section.add "buyerCreativeId", valid_598059
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
  var valid_598060 = query.getOrDefault("fields")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "fields", valid_598060
  var valid_598061 = query.getOrDefault("quotaUser")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "quotaUser", valid_598061
  var valid_598062 = query.getOrDefault("alt")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString("json"))
  if valid_598062 != nil:
    section.add "alt", valid_598062
  var valid_598063 = query.getOrDefault("oauth_token")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "oauth_token", valid_598063
  var valid_598064 = query.getOrDefault("userIp")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "userIp", valid_598064
  var valid_598065 = query.getOrDefault("key")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "key", valid_598065
  var valid_598066 = query.getOrDefault("prettyPrint")
  valid_598066 = validateParameter(valid_598066, JBool, required = false,
                                 default = newJBool(true))
  if valid_598066 != nil:
    section.add "prettyPrint", valid_598066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598067: Call_AdexchangebuyerCreativesGet_598055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_598067.validator(path, query, header, formData, body)
  let scheme = call_598067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598067.url(scheme.get, call_598067.host, call_598067.base,
                         call_598067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598067, url, valid)

proc call*(call_598068: Call_AdexchangebuyerCreativesGet_598055; accountId: int;
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
  var path_598069 = newJObject()
  var query_598070 = newJObject()
  add(query_598070, "fields", newJString(fields))
  add(query_598070, "quotaUser", newJString(quotaUser))
  add(query_598070, "alt", newJString(alt))
  add(query_598070, "oauth_token", newJString(oauthToken))
  add(path_598069, "accountId", newJInt(accountId))
  add(query_598070, "userIp", newJString(userIp))
  add(path_598069, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_598070, "key", newJString(key))
  add(query_598070, "prettyPrint", newJBool(prettyPrint))
  result = call_598068.call(path_598069, query_598070, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_598055(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_598056,
    base: "/adexchangebuyer/v1.2", url: url_AdexchangebuyerCreativesGet_598057,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
