
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  gcpServiceName = "adexchangebuyer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangebuyerAccountsList_578626 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerAccountsList_578628(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerAccountsList_578627(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authenticated user's list of accounts.
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
  var valid_578740 = query.getOrDefault("key")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "key", valid_578740
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("userIp")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "userIp", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("fields")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "fields", valid_578759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_AdexchangebuyerAccountsList_578626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of accounts.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_AdexchangebuyerAccountsList_578626; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerAccountsList
  ## Retrieves the authenticated user's list of accounts.
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
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "userIp", newJString(userIp))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(query_578854, "fields", newJString(fields))
  result = call_578853.call(nil, query_578854, nil, nil, nil)

var adexchangebuyerAccountsList* = Call_AdexchangebuyerAccountsList_578626(
    name: "adexchangebuyerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangebuyerAccountsList_578627,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsList_578628,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsUpdate_578923 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerAccountsUpdate_578925(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsUpdate_578924(path: JsonNode; query: JsonNode;
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
  var valid_578926 = path.getOrDefault("id")
  valid_578926 = validateParameter(valid_578926, JInt, required = true, default = nil)
  if valid_578926 != nil:
    section.add "id", valid_578926
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
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("userIp")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "userIp", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
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

proc call*(call_578935: Call_AdexchangebuyerAccountsUpdate_578923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_AdexchangebuyerAccountsUpdate_578923; id: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerAccountsUpdate
  ## Updates an existing account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: int (required)
  ##     : The account id
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  var body_578939 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(path_578937, "id", newJInt(id))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "userIp", newJString(userIp))
  add(query_578938, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578939 = body
  add(query_578938, "fields", newJString(fields))
  result = call_578936.call(path_578937, query_578938, nil, nil, body_578939)

var adexchangebuyerAccountsUpdate* = Call_AdexchangebuyerAccountsUpdate_578923(
    name: "adexchangebuyerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsUpdate_578924,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsUpdate_578925,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsGet_578894 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerAccountsGet_578896(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsGet_578895(path: JsonNode; query: JsonNode;
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
  var valid_578911 = path.getOrDefault("id")
  valid_578911 = validateParameter(valid_578911, JInt, required = true, default = nil)
  if valid_578911 != nil:
    section.add "id", valid_578911
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
  var valid_578912 = query.getOrDefault("key")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "key", valid_578912
  var valid_578913 = query.getOrDefault("prettyPrint")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(true))
  if valid_578913 != nil:
    section.add "prettyPrint", valid_578913
  var valid_578914 = query.getOrDefault("oauth_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "oauth_token", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("userIp")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "userIp", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("fields")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "fields", valid_578918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578919: Call_AdexchangebuyerAccountsGet_578894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one account by ID.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_AdexchangebuyerAccountsGet_578894; id: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangebuyerAccountsGet
  ## Gets one account by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: int (required)
  ##     : The account id
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578921 = newJObject()
  var query_578922 = newJObject()
  add(query_578922, "key", newJString(key))
  add(query_578922, "prettyPrint", newJBool(prettyPrint))
  add(query_578922, "oauth_token", newJString(oauthToken))
  add(path_578921, "id", newJInt(id))
  add(query_578922, "alt", newJString(alt))
  add(query_578922, "userIp", newJString(userIp))
  add(query_578922, "quotaUser", newJString(quotaUser))
  add(query_578922, "fields", newJString(fields))
  result = call_578920.call(path_578921, query_578922, nil, nil, nil)

var adexchangebuyerAccountsGet* = Call_AdexchangebuyerAccountsGet_578894(
    name: "adexchangebuyerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsGet_578895,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsGet_578896,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsPatch_578940 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerAccountsPatch_578942(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsPatch_578941(path: JsonNode; query: JsonNode;
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
  var valid_578943 = path.getOrDefault("id")
  valid_578943 = validateParameter(valid_578943, JInt, required = true, default = nil)
  if valid_578943 != nil:
    section.add "id", valid_578943
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
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("alt")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("json"))
  if valid_578947 != nil:
    section.add "alt", valid_578947
  var valid_578948 = query.getOrDefault("userIp")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "userIp", valid_578948
  var valid_578949 = query.getOrDefault("quotaUser")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "quotaUser", valid_578949
  var valid_578950 = query.getOrDefault("fields")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "fields", valid_578950
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

proc call*(call_578952: Call_AdexchangebuyerAccountsPatch_578940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_AdexchangebuyerAccountsPatch_578940; id: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerAccountsPatch
  ## Updates an existing account. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: int (required)
  ##     : The account id
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  var body_578956 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(path_578954, "id", newJInt(id))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "userIp", newJString(userIp))
  add(query_578955, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578956 = body
  add(query_578955, "fields", newJString(fields))
  result = call_578953.call(path_578954, query_578955, nil, nil, body_578956)

var adexchangebuyerAccountsPatch* = Call_AdexchangebuyerAccountsPatch_578940(
    name: "adexchangebuyerAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsPatch_578941,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerAccountsPatch_578942,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoList_578957 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerBillingInfoList_578959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerBillingInfoList_578958(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
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
  var valid_578960 = query.getOrDefault("key")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "key", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(true))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("userIp")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "userIp", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("fields")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "fields", valid_578966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578967: Call_AdexchangebuyerBillingInfoList_578957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
  ## 
  let valid = call_578967.validator(path, query, header, formData, body)
  let scheme = call_578967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578967.url(scheme.get, call_578967.host, call_578967.base,
                         call_578967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578967, url, valid)

proc call*(call_578968: Call_AdexchangebuyerBillingInfoList_578957;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangebuyerBillingInfoList
  ## Retrieves a list of billing information for all accounts of the authenticated user.
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
  var query_578969 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "userIp", newJString(userIp))
  add(query_578969, "quotaUser", newJString(quotaUser))
  add(query_578969, "fields", newJString(fields))
  result = call_578968.call(nil, query_578969, nil, nil, nil)

var adexchangebuyerBillingInfoList* = Call_AdexchangebuyerBillingInfoList_578957(
    name: "adexchangebuyerBillingInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo",
    validator: validate_AdexchangebuyerBillingInfoList_578958,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBillingInfoList_578959,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoGet_578970 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerBillingInfoGet_578972(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBillingInfoGet_578971(path: JsonNode; query: JsonNode;
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
  var valid_578973 = path.getOrDefault("accountId")
  valid_578973 = validateParameter(valid_578973, JInt, required = true, default = nil)
  if valid_578973 != nil:
    section.add "accountId", valid_578973
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
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("userIp")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "userIp", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("fields")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fields", valid_578980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578981: Call_AdexchangebuyerBillingInfoGet_578970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the billing information for one account specified by account ID.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_AdexchangebuyerBillingInfoGet_578970; accountId: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangebuyerBillingInfoGet
  ## Returns the billing information for one account specified by account ID.
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
  ##   accountId: int (required)
  ##            : The account id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "userIp", newJString(userIp))
  add(query_578984, "quotaUser", newJString(quotaUser))
  add(path_578983, "accountId", newJInt(accountId))
  add(query_578984, "fields", newJString(fields))
  result = call_578982.call(path_578983, query_578984, nil, nil, nil)

var adexchangebuyerBillingInfoGet* = Call_AdexchangebuyerBillingInfoGet_578970(
    name: "adexchangebuyerBillingInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}",
    validator: validate_AdexchangebuyerBillingInfoGet_578971,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBillingInfoGet_578972,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetUpdate_579001 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerBudgetUpdate_579003(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetUpdate_579002(path: JsonNode; query: JsonNode;
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
  var valid_579004 = path.getOrDefault("billingId")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "billingId", valid_579004
  var valid_579005 = path.getOrDefault("accountId")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "accountId", valid_579005
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
  var valid_579006 = query.getOrDefault("key")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "key", valid_579006
  var valid_579007 = query.getOrDefault("prettyPrint")
  valid_579007 = validateParameter(valid_579007, JBool, required = false,
                                 default = newJBool(true))
  if valid_579007 != nil:
    section.add "prettyPrint", valid_579007
  var valid_579008 = query.getOrDefault("oauth_token")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "oauth_token", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("userIp")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "userIp", valid_579010
  var valid_579011 = query.getOrDefault("quotaUser")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "quotaUser", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
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

proc call*(call_579014: Call_AdexchangebuyerBudgetUpdate_579001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  let valid = call_579014.validator(path, query, header, formData, body)
  let scheme = call_579014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579014.url(scheme.get, call_579014.host, call_579014.base,
                         call_579014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579014, url, valid)

proc call*(call_579015: Call_AdexchangebuyerBudgetUpdate_579001; billingId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerBudgetUpdate
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   billingId: string (required)
  ##            : The billing id associated with the budget being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The account id associated with the budget being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579016 = newJObject()
  var query_579017 = newJObject()
  var body_579018 = newJObject()
  add(query_579017, "key", newJString(key))
  add(query_579017, "prettyPrint", newJBool(prettyPrint))
  add(query_579017, "oauth_token", newJString(oauthToken))
  add(path_579016, "billingId", newJString(billingId))
  add(query_579017, "alt", newJString(alt))
  add(query_579017, "userIp", newJString(userIp))
  add(query_579017, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579018 = body
  add(path_579016, "accountId", newJString(accountId))
  add(query_579017, "fields", newJString(fields))
  result = call_579015.call(path_579016, query_579017, nil, nil, body_579018)

var adexchangebuyerBudgetUpdate* = Call_AdexchangebuyerBudgetUpdate_579001(
    name: "adexchangebuyerBudgetUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetUpdate_579002,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetUpdate_579003,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetGet_578985 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerBudgetGet_578987(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetGet_578986(path: JsonNode; query: JsonNode;
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
  var valid_578988 = path.getOrDefault("billingId")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "billingId", valid_578988
  var valid_578989 = path.getOrDefault("accountId")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "accountId", valid_578989
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
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("json"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("userIp")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "userIp", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578997: Call_AdexchangebuyerBudgetGet_578985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_AdexchangebuyerBudgetGet_578985; billingId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerBudgetGet
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   billingId: string (required)
  ##            : The billing id to get the budget information for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The account id to get the budget information for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(path_578999, "billingId", newJString(billingId))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "userIp", newJString(userIp))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(path_578999, "accountId", newJString(accountId))
  add(query_579000, "fields", newJString(fields))
  result = call_578998.call(path_578999, query_579000, nil, nil, nil)

var adexchangebuyerBudgetGet* = Call_AdexchangebuyerBudgetGet_578985(
    name: "adexchangebuyerBudgetGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetGet_578986,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetGet_578987,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetPatch_579019 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerBudgetPatch_579021(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetPatch_579020(path: JsonNode; query: JsonNode;
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
  var valid_579022 = path.getOrDefault("billingId")
  valid_579022 = validateParameter(valid_579022, JString, required = true,
                                 default = nil)
  if valid_579022 != nil:
    section.add "billingId", valid_579022
  var valid_579023 = path.getOrDefault("accountId")
  valid_579023 = validateParameter(valid_579023, JString, required = true,
                                 default = nil)
  if valid_579023 != nil:
    section.add "accountId", valid_579023
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
  var valid_579024 = query.getOrDefault("key")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "key", valid_579024
  var valid_579025 = query.getOrDefault("prettyPrint")
  valid_579025 = validateParameter(valid_579025, JBool, required = false,
                                 default = newJBool(true))
  if valid_579025 != nil:
    section.add "prettyPrint", valid_579025
  var valid_579026 = query.getOrDefault("oauth_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "oauth_token", valid_579026
  var valid_579027 = query.getOrDefault("alt")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = newJString("json"))
  if valid_579027 != nil:
    section.add "alt", valid_579027
  var valid_579028 = query.getOrDefault("userIp")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "userIp", valid_579028
  var valid_579029 = query.getOrDefault("quotaUser")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "quotaUser", valid_579029
  var valid_579030 = query.getOrDefault("fields")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "fields", valid_579030
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

proc call*(call_579032: Call_AdexchangebuyerBudgetPatch_579019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  let valid = call_579032.validator(path, query, header, formData, body)
  let scheme = call_579032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579032.url(scheme.get, call_579032.host, call_579032.base,
                         call_579032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579032, url, valid)

proc call*(call_579033: Call_AdexchangebuyerBudgetPatch_579019; billingId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerBudgetPatch
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   billingId: string (required)
  ##            : The billing id associated with the budget being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The account id associated with the budget being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579034 = newJObject()
  var query_579035 = newJObject()
  var body_579036 = newJObject()
  add(query_579035, "key", newJString(key))
  add(query_579035, "prettyPrint", newJBool(prettyPrint))
  add(query_579035, "oauth_token", newJString(oauthToken))
  add(path_579034, "billingId", newJString(billingId))
  add(query_579035, "alt", newJString(alt))
  add(query_579035, "userIp", newJString(userIp))
  add(query_579035, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579036 = body
  add(path_579034, "accountId", newJString(accountId))
  add(query_579035, "fields", newJString(fields))
  result = call_579033.call(path_579034, query_579035, nil, nil, body_579036)

var adexchangebuyerBudgetPatch* = Call_AdexchangebuyerBudgetPatch_579019(
    name: "adexchangebuyerBudgetPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetPatch_579020,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerBudgetPatch_579021,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_579055 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerCreativesInsert_579057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_579056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit a new creative.
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
  var valid_579058 = query.getOrDefault("key")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "key", valid_579058
  var valid_579059 = query.getOrDefault("prettyPrint")
  valid_579059 = validateParameter(valid_579059, JBool, required = false,
                                 default = newJBool(true))
  if valid_579059 != nil:
    section.add "prettyPrint", valid_579059
  var valid_579060 = query.getOrDefault("oauth_token")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "oauth_token", valid_579060
  var valid_579061 = query.getOrDefault("alt")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("json"))
  if valid_579061 != nil:
    section.add "alt", valid_579061
  var valid_579062 = query.getOrDefault("userIp")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "userIp", valid_579062
  var valid_579063 = query.getOrDefault("quotaUser")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "quotaUser", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
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

proc call*(call_579066: Call_AdexchangebuyerCreativesInsert_579055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_579066.validator(path, query, header, formData, body)
  let scheme = call_579066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579066.url(scheme.get, call_579066.host, call_579066.base,
                         call_579066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579066, url, valid)

proc call*(call_579067: Call_AdexchangebuyerCreativesInsert_579055;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerCreativesInsert
  ## Submit a new creative.
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
  var query_579068 = newJObject()
  var body_579069 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "userIp", newJString(userIp))
  add(query_579068, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579069 = body
  add(query_579068, "fields", newJString(fields))
  result = call_579067.call(nil, query_579068, nil, nil, body_579069)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_579055(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_579056,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesInsert_579057,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_579037 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerCreativesList_579039(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_579038(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
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
  ##   statusFilter: JString
  ##               : When specified, only creatives having the given status are returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buyerCreativeId: JArray
  ##                  : When specified, only creatives for the given buyer creative ids are returned.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   accountId: JArray
  ##            : When specified, only creatives for the given account ids are returned.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  section = newJObject()
  var valid_579040 = query.getOrDefault("key")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "key", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("statusFilter")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("approved"))
  if valid_579043 != nil:
    section.add "statusFilter", valid_579043
  var valid_579044 = query.getOrDefault("alt")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("json"))
  if valid_579044 != nil:
    section.add "alt", valid_579044
  var valid_579045 = query.getOrDefault("userIp")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "userIp", valid_579045
  var valid_579046 = query.getOrDefault("quotaUser")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "quotaUser", valid_579046
  var valid_579047 = query.getOrDefault("buyerCreativeId")
  valid_579047 = validateParameter(valid_579047, JArray, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "buyerCreativeId", valid_579047
  var valid_579048 = query.getOrDefault("pageToken")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "pageToken", valid_579048
  var valid_579049 = query.getOrDefault("fields")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "fields", valid_579049
  var valid_579050 = query.getOrDefault("accountId")
  valid_579050 = validateParameter(valid_579050, JArray, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "accountId", valid_579050
  var valid_579051 = query.getOrDefault("maxResults")
  valid_579051 = validateParameter(valid_579051, JInt, required = false, default = nil)
  if valid_579051 != nil:
    section.add "maxResults", valid_579051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579052: Call_AdexchangebuyerCreativesList_579037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_579052.validator(path, query, header, formData, body)
  let scheme = call_579052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579052.url(scheme.get, call_579052.host, call_579052.base,
                         call_579052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579052, url, valid)

proc call*(call_579053: Call_AdexchangebuyerCreativesList_579037; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          statusFilter: string = "approved"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; buyerCreativeId: JsonNode = nil;
          pageToken: string = ""; fields: string = ""; accountId: JsonNode = nil;
          maxResults: int = 0): Recallable =
  ## adexchangebuyerCreativesList
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   statusFilter: string
  ##               : When specified, only creatives having the given status are returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buyerCreativeId: JArray
  ##                  : When specified, only creatives for the given buyer creative ids are returned.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accountId: JArray
  ##            : When specified, only creatives for the given account ids are returned.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  var query_579054 = newJObject()
  add(query_579054, "key", newJString(key))
  add(query_579054, "prettyPrint", newJBool(prettyPrint))
  add(query_579054, "oauth_token", newJString(oauthToken))
  add(query_579054, "statusFilter", newJString(statusFilter))
  add(query_579054, "alt", newJString(alt))
  add(query_579054, "userIp", newJString(userIp))
  add(query_579054, "quotaUser", newJString(quotaUser))
  if buyerCreativeId != nil:
    query_579054.add "buyerCreativeId", buyerCreativeId
  add(query_579054, "pageToken", newJString(pageToken))
  add(query_579054, "fields", newJString(fields))
  if accountId != nil:
    query_579054.add "accountId", accountId
  add(query_579054, "maxResults", newJInt(maxResults))
  result = call_579053.call(nil, query_579054, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_579037(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_579038,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesList_579039,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_579070 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerCreativesGet_579072(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesGet_579071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   buyerCreativeId: JString (required)
  ##                  : The buyer-specific id for this creative.
  ##   accountId: JInt (required)
  ##            : The id for the account that will serve this creative.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `buyerCreativeId` field"
  var valid_579073 = path.getOrDefault("buyerCreativeId")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "buyerCreativeId", valid_579073
  var valid_579074 = path.getOrDefault("accountId")
  valid_579074 = validateParameter(valid_579074, JInt, required = true, default = nil)
  if valid_579074 != nil:
    section.add "accountId", valid_579074
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
  var valid_579075 = query.getOrDefault("key")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "key", valid_579075
  var valid_579076 = query.getOrDefault("prettyPrint")
  valid_579076 = validateParameter(valid_579076, JBool, required = false,
                                 default = newJBool(true))
  if valid_579076 != nil:
    section.add "prettyPrint", valid_579076
  var valid_579077 = query.getOrDefault("oauth_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "oauth_token", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("userIp")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "userIp", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("fields")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "fields", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_AdexchangebuyerCreativesGet_579070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_AdexchangebuyerCreativesGet_579070;
          buyerCreativeId: string; accountId: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerCreativesGet
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   buyerCreativeId: string (required)
  ##                  : The buyer-specific id for this creative.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: int (required)
  ##            : The id for the account that will serve this creative.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(path_579084, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "userIp", newJString(userIp))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(path_579084, "accountId", newJInt(accountId))
  add(query_579085, "fields", newJString(fields))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_579070(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_579071,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerCreativesGet_579072,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerDirectDealsList_579086 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerDirectDealsList_579088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerDirectDealsList_579087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authenticated user's list of direct deals.
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
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("userIp")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "userIp", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579096: Call_AdexchangebuyerDirectDealsList_579086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of direct deals.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_AdexchangebuyerDirectDealsList_579086;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangebuyerDirectDealsList
  ## Retrieves the authenticated user's list of direct deals.
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
  var query_579098 = newJObject()
  add(query_579098, "key", newJString(key))
  add(query_579098, "prettyPrint", newJBool(prettyPrint))
  add(query_579098, "oauth_token", newJString(oauthToken))
  add(query_579098, "alt", newJString(alt))
  add(query_579098, "userIp", newJString(userIp))
  add(query_579098, "quotaUser", newJString(quotaUser))
  add(query_579098, "fields", newJString(fields))
  result = call_579097.call(nil, query_579098, nil, nil, nil)

var adexchangebuyerDirectDealsList* = Call_AdexchangebuyerDirectDealsList_579086(
    name: "adexchangebuyerDirectDealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/directdeals",
    validator: validate_AdexchangebuyerDirectDealsList_579087,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerDirectDealsList_579088,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerDirectDealsGet_579099 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerDirectDealsGet_579101(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerDirectDealsGet_579100(path: JsonNode; query: JsonNode;
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
  var valid_579102 = path.getOrDefault("id")
  valid_579102 = validateParameter(valid_579102, JString, required = true,
                                 default = nil)
  if valid_579102 != nil:
    section.add "id", valid_579102
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
  var valid_579103 = query.getOrDefault("key")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "key", valid_579103
  var valid_579104 = query.getOrDefault("prettyPrint")
  valid_579104 = validateParameter(valid_579104, JBool, required = false,
                                 default = newJBool(true))
  if valid_579104 != nil:
    section.add "prettyPrint", valid_579104
  var valid_579105 = query.getOrDefault("oauth_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "oauth_token", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("userIp")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "userIp", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
  var valid_579109 = query.getOrDefault("fields")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "fields", valid_579109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_AdexchangebuyerDirectDealsGet_579099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one direct deal by ID.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_AdexchangebuyerDirectDealsGet_579099; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangebuyerDirectDealsGet
  ## Gets one direct deal by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The direct deal id
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(path_579112, "id", newJString(id))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "userIp", newJString(userIp))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(query_579113, "fields", newJString(fields))
  result = call_579111.call(path_579112, query_579113, nil, nil, nil)

var adexchangebuyerDirectDealsGet* = Call_AdexchangebuyerDirectDealsGet_579099(
    name: "adexchangebuyerDirectDealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/directdeals/{id}",
    validator: validate_AdexchangebuyerDirectDealsGet_579100,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerDirectDealsGet_579101,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPerformanceReportList_579114 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerPerformanceReportList_579116(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerPerformanceReportList_579115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authenticated user's list of performance metrics.
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
  ##            : A continuation token, used to page through performance reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   startDateTime: JString (required)
  ##                : The start time of the report in ISO 8601 timestamp format using UTC.
  ##   endDateTime: JString (required)
  ##              : The end time of the report in ISO 8601 timestamp format using UTC.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   accountId: JString (required)
  ##            : The account id to get the reports.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  section = newJObject()
  var valid_579117 = query.getOrDefault("key")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "key", valid_579117
  var valid_579118 = query.getOrDefault("prettyPrint")
  valid_579118 = validateParameter(valid_579118, JBool, required = false,
                                 default = newJBool(true))
  if valid_579118 != nil:
    section.add "prettyPrint", valid_579118
  var valid_579119 = query.getOrDefault("oauth_token")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "oauth_token", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("userIp")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "userIp", valid_579121
  var valid_579122 = query.getOrDefault("quotaUser")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "quotaUser", valid_579122
  var valid_579123 = query.getOrDefault("pageToken")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "pageToken", valid_579123
  assert query != nil,
        "query argument is necessary due to required `startDateTime` field"
  var valid_579124 = query.getOrDefault("startDateTime")
  valid_579124 = validateParameter(valid_579124, JString, required = true,
                                 default = nil)
  if valid_579124 != nil:
    section.add "startDateTime", valid_579124
  var valid_579125 = query.getOrDefault("endDateTime")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "endDateTime", valid_579125
  var valid_579126 = query.getOrDefault("fields")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "fields", valid_579126
  var valid_579127 = query.getOrDefault("accountId")
  valid_579127 = validateParameter(valid_579127, JString, required = true,
                                 default = nil)
  if valid_579127 != nil:
    section.add "accountId", valid_579127
  var valid_579128 = query.getOrDefault("maxResults")
  valid_579128 = validateParameter(valid_579128, JInt, required = false, default = nil)
  if valid_579128 != nil:
    section.add "maxResults", valid_579128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579129: Call_AdexchangebuyerPerformanceReportList_579114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  let valid = call_579129.validator(path, query, header, formData, body)
  let scheme = call_579129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579129.url(scheme.get, call_579129.host, call_579129.base,
                         call_579129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579129, url, valid)

proc call*(call_579130: Call_AdexchangebuyerPerformanceReportList_579114;
          startDateTime: string; endDateTime: string; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangebuyerPerformanceReportList
  ## Retrieves the authenticated user's list of performance metrics.
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
  ##            : A continuation token, used to page through performance reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   startDateTime: string (required)
  ##                : The start time of the report in ISO 8601 timestamp format using UTC.
  ##   endDateTime: string (required)
  ##              : The end time of the report in ISO 8601 timestamp format using UTC.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accountId: string (required)
  ##            : The account id to get the reports.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  var query_579131 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "userIp", newJString(userIp))
  add(query_579131, "quotaUser", newJString(quotaUser))
  add(query_579131, "pageToken", newJString(pageToken))
  add(query_579131, "startDateTime", newJString(startDateTime))
  add(query_579131, "endDateTime", newJString(endDateTime))
  add(query_579131, "fields", newJString(fields))
  add(query_579131, "accountId", newJString(accountId))
  add(query_579131, "maxResults", newJInt(maxResults))
  result = call_579130.call(nil, query_579131, nil, nil, nil)

var adexchangebuyerPerformanceReportList* = Call_AdexchangebuyerPerformanceReportList_579114(
    name: "adexchangebuyerPerformanceReportList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/performancereport",
    validator: validate_AdexchangebuyerPerformanceReportList_579115,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPerformanceReportList_579116,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigInsert_579147 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerPretargetingConfigInsert_579149(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigInsert_579148(path: JsonNode;
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
  var valid_579150 = path.getOrDefault("accountId")
  valid_579150 = validateParameter(valid_579150, JString, required = true,
                                 default = nil)
  if valid_579150 != nil:
    section.add "accountId", valid_579150
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
  var valid_579151 = query.getOrDefault("key")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "key", valid_579151
  var valid_579152 = query.getOrDefault("prettyPrint")
  valid_579152 = validateParameter(valid_579152, JBool, required = false,
                                 default = newJBool(true))
  if valid_579152 != nil:
    section.add "prettyPrint", valid_579152
  var valid_579153 = query.getOrDefault("oauth_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "oauth_token", valid_579153
  var valid_579154 = query.getOrDefault("alt")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = newJString("json"))
  if valid_579154 != nil:
    section.add "alt", valid_579154
  var valid_579155 = query.getOrDefault("userIp")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "userIp", valid_579155
  var valid_579156 = query.getOrDefault("quotaUser")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "quotaUser", valid_579156
  var valid_579157 = query.getOrDefault("fields")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "fields", valid_579157
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

proc call*(call_579159: Call_AdexchangebuyerPretargetingConfigInsert_579147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new pretargeting configuration.
  ## 
  let valid = call_579159.validator(path, query, header, formData, body)
  let scheme = call_579159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579159.url(scheme.get, call_579159.host, call_579159.base,
                         call_579159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579159, url, valid)

proc call*(call_579160: Call_AdexchangebuyerPretargetingConfigInsert_579147;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerPretargetingConfigInsert
  ## Inserts a new pretargeting configuration.
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
  ##   accountId: string (required)
  ##            : The account id to insert the pretargeting config for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579161 = newJObject()
  var query_579162 = newJObject()
  var body_579163 = newJObject()
  add(query_579162, "key", newJString(key))
  add(query_579162, "prettyPrint", newJBool(prettyPrint))
  add(query_579162, "oauth_token", newJString(oauthToken))
  add(query_579162, "alt", newJString(alt))
  add(query_579162, "userIp", newJString(userIp))
  add(query_579162, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579163 = body
  add(path_579161, "accountId", newJString(accountId))
  add(query_579162, "fields", newJString(fields))
  result = call_579160.call(path_579161, query_579162, nil, nil, body_579163)

var adexchangebuyerPretargetingConfigInsert* = Call_AdexchangebuyerPretargetingConfigInsert_579147(
    name: "adexchangebuyerPretargetingConfigInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigInsert_579148,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigInsert_579149,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigList_579132 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerPretargetingConfigList_579134(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigList_579133(path: JsonNode;
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
  var valid_579135 = path.getOrDefault("accountId")
  valid_579135 = validateParameter(valid_579135, JString, required = true,
                                 default = nil)
  if valid_579135 != nil:
    section.add "accountId", valid_579135
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
  var valid_579136 = query.getOrDefault("key")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "key", valid_579136
  var valid_579137 = query.getOrDefault("prettyPrint")
  valid_579137 = validateParameter(valid_579137, JBool, required = false,
                                 default = newJBool(true))
  if valid_579137 != nil:
    section.add "prettyPrint", valid_579137
  var valid_579138 = query.getOrDefault("oauth_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "oauth_token", valid_579138
  var valid_579139 = query.getOrDefault("alt")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("json"))
  if valid_579139 != nil:
    section.add "alt", valid_579139
  var valid_579140 = query.getOrDefault("userIp")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "userIp", valid_579140
  var valid_579141 = query.getOrDefault("quotaUser")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "quotaUser", valid_579141
  var valid_579142 = query.getOrDefault("fields")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "fields", valid_579142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579143: Call_AdexchangebuyerPretargetingConfigList_579132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  let valid = call_579143.validator(path, query, header, formData, body)
  let scheme = call_579143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579143.url(scheme.get, call_579143.host, call_579143.base,
                         call_579143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579143, url, valid)

proc call*(call_579144: Call_AdexchangebuyerPretargetingConfigList_579132;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerPretargetingConfigList
  ## Retrieves a list of the authenticated user's pretargeting configurations.
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
  ##   accountId: string (required)
  ##            : The account id to get the pretargeting configs for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579145 = newJObject()
  var query_579146 = newJObject()
  add(query_579146, "key", newJString(key))
  add(query_579146, "prettyPrint", newJBool(prettyPrint))
  add(query_579146, "oauth_token", newJString(oauthToken))
  add(query_579146, "alt", newJString(alt))
  add(query_579146, "userIp", newJString(userIp))
  add(query_579146, "quotaUser", newJString(quotaUser))
  add(path_579145, "accountId", newJString(accountId))
  add(query_579146, "fields", newJString(fields))
  result = call_579144.call(path_579145, query_579146, nil, nil, nil)

var adexchangebuyerPretargetingConfigList* = Call_AdexchangebuyerPretargetingConfigList_579132(
    name: "adexchangebuyerPretargetingConfigList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigList_579133,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPretargetingConfigList_579134,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigUpdate_579180 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerPretargetingConfigUpdate_579182(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigUpdate_579181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing pretargeting config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configId: JString (required)
  ##           : The specific id of the configuration to update.
  ##   accountId: JString (required)
  ##            : The account id to update the pretargeting config for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `configId` field"
  var valid_579183 = path.getOrDefault("configId")
  valid_579183 = validateParameter(valid_579183, JString, required = true,
                                 default = nil)
  if valid_579183 != nil:
    section.add "configId", valid_579183
  var valid_579184 = path.getOrDefault("accountId")
  valid_579184 = validateParameter(valid_579184, JString, required = true,
                                 default = nil)
  if valid_579184 != nil:
    section.add "accountId", valid_579184
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
  var valid_579185 = query.getOrDefault("key")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "key", valid_579185
  var valid_579186 = query.getOrDefault("prettyPrint")
  valid_579186 = validateParameter(valid_579186, JBool, required = false,
                                 default = newJBool(true))
  if valid_579186 != nil:
    section.add "prettyPrint", valid_579186
  var valid_579187 = query.getOrDefault("oauth_token")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "oauth_token", valid_579187
  var valid_579188 = query.getOrDefault("alt")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("json"))
  if valid_579188 != nil:
    section.add "alt", valid_579188
  var valid_579189 = query.getOrDefault("userIp")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "userIp", valid_579189
  var valid_579190 = query.getOrDefault("quotaUser")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "quotaUser", valid_579190
  var valid_579191 = query.getOrDefault("fields")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "fields", valid_579191
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

proc call*(call_579193: Call_AdexchangebuyerPretargetingConfigUpdate_579180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config.
  ## 
  let valid = call_579193.validator(path, query, header, formData, body)
  let scheme = call_579193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579193.url(scheme.get, call_579193.host, call_579193.base,
                         call_579193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579193, url, valid)

proc call*(call_579194: Call_AdexchangebuyerPretargetingConfigUpdate_579180;
          configId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adexchangebuyerPretargetingConfigUpdate
  ## Updates an existing pretargeting config.
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
  ##   configId: string (required)
  ##           : The specific id of the configuration to update.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The account id to update the pretargeting config for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579195 = newJObject()
  var query_579196 = newJObject()
  var body_579197 = newJObject()
  add(query_579196, "key", newJString(key))
  add(query_579196, "prettyPrint", newJBool(prettyPrint))
  add(query_579196, "oauth_token", newJString(oauthToken))
  add(query_579196, "alt", newJString(alt))
  add(query_579196, "userIp", newJString(userIp))
  add(query_579196, "quotaUser", newJString(quotaUser))
  add(path_579195, "configId", newJString(configId))
  if body != nil:
    body_579197 = body
  add(path_579195, "accountId", newJString(accountId))
  add(query_579196, "fields", newJString(fields))
  result = call_579194.call(path_579195, query_579196, nil, nil, body_579197)

var adexchangebuyerPretargetingConfigUpdate* = Call_AdexchangebuyerPretargetingConfigUpdate_579180(
    name: "adexchangebuyerPretargetingConfigUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigUpdate_579181,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigUpdate_579182,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigGet_579164 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerPretargetingConfigGet_579166(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigGet_579165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific pretargeting configuration
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configId: JString (required)
  ##           : The specific id of the configuration to retrieve.
  ##   accountId: JString (required)
  ##            : The account id to get the pretargeting config for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `configId` field"
  var valid_579167 = path.getOrDefault("configId")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "configId", valid_579167
  var valid_579168 = path.getOrDefault("accountId")
  valid_579168 = validateParameter(valid_579168, JString, required = true,
                                 default = nil)
  if valid_579168 != nil:
    section.add "accountId", valid_579168
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
  var valid_579169 = query.getOrDefault("key")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "key", valid_579169
  var valid_579170 = query.getOrDefault("prettyPrint")
  valid_579170 = validateParameter(valid_579170, JBool, required = false,
                                 default = newJBool(true))
  if valid_579170 != nil:
    section.add "prettyPrint", valid_579170
  var valid_579171 = query.getOrDefault("oauth_token")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "oauth_token", valid_579171
  var valid_579172 = query.getOrDefault("alt")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("json"))
  if valid_579172 != nil:
    section.add "alt", valid_579172
  var valid_579173 = query.getOrDefault("userIp")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "userIp", valid_579173
  var valid_579174 = query.getOrDefault("quotaUser")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "quotaUser", valid_579174
  var valid_579175 = query.getOrDefault("fields")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "fields", valid_579175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579176: Call_AdexchangebuyerPretargetingConfigGet_579164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific pretargeting configuration
  ## 
  let valid = call_579176.validator(path, query, header, formData, body)
  let scheme = call_579176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579176.url(scheme.get, call_579176.host, call_579176.base,
                         call_579176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579176, url, valid)

proc call*(call_579177: Call_AdexchangebuyerPretargetingConfigGet_579164;
          configId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerPretargetingConfigGet
  ## Gets a specific pretargeting configuration
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
  ##   configId: string (required)
  ##           : The specific id of the configuration to retrieve.
  ##   accountId: string (required)
  ##            : The account id to get the pretargeting config for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579178 = newJObject()
  var query_579179 = newJObject()
  add(query_579179, "key", newJString(key))
  add(query_579179, "prettyPrint", newJBool(prettyPrint))
  add(query_579179, "oauth_token", newJString(oauthToken))
  add(query_579179, "alt", newJString(alt))
  add(query_579179, "userIp", newJString(userIp))
  add(query_579179, "quotaUser", newJString(quotaUser))
  add(path_579178, "configId", newJString(configId))
  add(path_579178, "accountId", newJString(accountId))
  add(query_579179, "fields", newJString(fields))
  result = call_579177.call(path_579178, query_579179, nil, nil, nil)

var adexchangebuyerPretargetingConfigGet* = Call_AdexchangebuyerPretargetingConfigGet_579164(
    name: "adexchangebuyerPretargetingConfigGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigGet_579165,
    base: "/adexchangebuyer/v1.3", url: url_AdexchangebuyerPretargetingConfigGet_579166,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigPatch_579214 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerPretargetingConfigPatch_579216(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigPatch_579215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configId: JString (required)
  ##           : The specific id of the configuration to update.
  ##   accountId: JString (required)
  ##            : The account id to update the pretargeting config for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `configId` field"
  var valid_579217 = path.getOrDefault("configId")
  valid_579217 = validateParameter(valid_579217, JString, required = true,
                                 default = nil)
  if valid_579217 != nil:
    section.add "configId", valid_579217
  var valid_579218 = path.getOrDefault("accountId")
  valid_579218 = validateParameter(valid_579218, JString, required = true,
                                 default = nil)
  if valid_579218 != nil:
    section.add "accountId", valid_579218
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
  var valid_579219 = query.getOrDefault("key")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "key", valid_579219
  var valid_579220 = query.getOrDefault("prettyPrint")
  valid_579220 = validateParameter(valid_579220, JBool, required = false,
                                 default = newJBool(true))
  if valid_579220 != nil:
    section.add "prettyPrint", valid_579220
  var valid_579221 = query.getOrDefault("oauth_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "oauth_token", valid_579221
  var valid_579222 = query.getOrDefault("alt")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = newJString("json"))
  if valid_579222 != nil:
    section.add "alt", valid_579222
  var valid_579223 = query.getOrDefault("userIp")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "userIp", valid_579223
  var valid_579224 = query.getOrDefault("quotaUser")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "quotaUser", valid_579224
  var valid_579225 = query.getOrDefault("fields")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "fields", valid_579225
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

proc call*(call_579227: Call_AdexchangebuyerPretargetingConfigPatch_579214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  let valid = call_579227.validator(path, query, header, formData, body)
  let scheme = call_579227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579227.url(scheme.get, call_579227.host, call_579227.base,
                         call_579227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579227, url, valid)

proc call*(call_579228: Call_AdexchangebuyerPretargetingConfigPatch_579214;
          configId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adexchangebuyerPretargetingConfigPatch
  ## Updates an existing pretargeting config. This method supports patch semantics.
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
  ##   configId: string (required)
  ##           : The specific id of the configuration to update.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The account id to update the pretargeting config for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579229 = newJObject()
  var query_579230 = newJObject()
  var body_579231 = newJObject()
  add(query_579230, "key", newJString(key))
  add(query_579230, "prettyPrint", newJBool(prettyPrint))
  add(query_579230, "oauth_token", newJString(oauthToken))
  add(query_579230, "alt", newJString(alt))
  add(query_579230, "userIp", newJString(userIp))
  add(query_579230, "quotaUser", newJString(quotaUser))
  add(path_579229, "configId", newJString(configId))
  if body != nil:
    body_579231 = body
  add(path_579229, "accountId", newJString(accountId))
  add(query_579230, "fields", newJString(fields))
  result = call_579228.call(path_579229, query_579230, nil, nil, body_579231)

var adexchangebuyerPretargetingConfigPatch* = Call_AdexchangebuyerPretargetingConfigPatch_579214(
    name: "adexchangebuyerPretargetingConfigPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigPatch_579215,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigPatch_579216,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigDelete_579198 = ref object of OpenApiRestCall_578355
proc url_AdexchangebuyerPretargetingConfigDelete_579200(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigDelete_579199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing pretargeting config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configId: JString (required)
  ##           : The specific id of the configuration to delete.
  ##   accountId: JString (required)
  ##            : The account id to delete the pretargeting config for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `configId` field"
  var valid_579201 = path.getOrDefault("configId")
  valid_579201 = validateParameter(valid_579201, JString, required = true,
                                 default = nil)
  if valid_579201 != nil:
    section.add "configId", valid_579201
  var valid_579202 = path.getOrDefault("accountId")
  valid_579202 = validateParameter(valid_579202, JString, required = true,
                                 default = nil)
  if valid_579202 != nil:
    section.add "accountId", valid_579202
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
  var valid_579203 = query.getOrDefault("key")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "key", valid_579203
  var valid_579204 = query.getOrDefault("prettyPrint")
  valid_579204 = validateParameter(valid_579204, JBool, required = false,
                                 default = newJBool(true))
  if valid_579204 != nil:
    section.add "prettyPrint", valid_579204
  var valid_579205 = query.getOrDefault("oauth_token")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "oauth_token", valid_579205
  var valid_579206 = query.getOrDefault("alt")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = newJString("json"))
  if valid_579206 != nil:
    section.add "alt", valid_579206
  var valid_579207 = query.getOrDefault("userIp")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "userIp", valid_579207
  var valid_579208 = query.getOrDefault("quotaUser")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "quotaUser", valid_579208
  var valid_579209 = query.getOrDefault("fields")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "fields", valid_579209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579210: Call_AdexchangebuyerPretargetingConfigDelete_579198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing pretargeting config.
  ## 
  let valid = call_579210.validator(path, query, header, formData, body)
  let scheme = call_579210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579210.url(scheme.get, call_579210.host, call_579210.base,
                         call_579210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579210, url, valid)

proc call*(call_579211: Call_AdexchangebuyerPretargetingConfigDelete_579198;
          configId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerPretargetingConfigDelete
  ## Deletes an existing pretargeting config.
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
  ##   configId: string (required)
  ##           : The specific id of the configuration to delete.
  ##   accountId: string (required)
  ##            : The account id to delete the pretargeting config for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579212 = newJObject()
  var query_579213 = newJObject()
  add(query_579213, "key", newJString(key))
  add(query_579213, "prettyPrint", newJBool(prettyPrint))
  add(query_579213, "oauth_token", newJString(oauthToken))
  add(query_579213, "alt", newJString(alt))
  add(query_579213, "userIp", newJString(userIp))
  add(query_579213, "quotaUser", newJString(quotaUser))
  add(path_579212, "configId", newJString(configId))
  add(path_579212, "accountId", newJString(accountId))
  add(query_579213, "fields", newJString(fields))
  result = call_579211.call(path_579212, query_579213, nil, nil, nil)

var adexchangebuyerPretargetingConfigDelete* = Call_AdexchangebuyerPretargetingConfigDelete_579198(
    name: "adexchangebuyerPretargetingConfigDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigDelete_579199,
    base: "/adexchangebuyer/v1.3",
    url: url_AdexchangebuyerPretargetingConfigDelete_579200,
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
