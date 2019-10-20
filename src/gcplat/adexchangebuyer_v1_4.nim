
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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  Call_AdexchangebuyerAccountsList_578635 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerAccountsList_578637(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerAccountsList_578636(path: JsonNode; query: JsonNode;
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
  var valid_578749 = query.getOrDefault("key")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "key", valid_578749
  var valid_578763 = query.getOrDefault("prettyPrint")
  valid_578763 = validateParameter(valid_578763, JBool, required = false,
                                 default = newJBool(true))
  if valid_578763 != nil:
    section.add "prettyPrint", valid_578763
  var valid_578764 = query.getOrDefault("oauth_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "oauth_token", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("userIp")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "userIp", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("fields")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "fields", valid_578768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578791: Call_AdexchangebuyerAccountsList_578635; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of accounts.
  ## 
  let valid = call_578791.validator(path, query, header, formData, body)
  let scheme = call_578791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578791.url(scheme.get, call_578791.host, call_578791.base,
                         call_578791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578791, url, valid)

proc call*(call_578862: Call_AdexchangebuyerAccountsList_578635; key: string = "";
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
  var query_578863 = newJObject()
  add(query_578863, "key", newJString(key))
  add(query_578863, "prettyPrint", newJBool(prettyPrint))
  add(query_578863, "oauth_token", newJString(oauthToken))
  add(query_578863, "alt", newJString(alt))
  add(query_578863, "userIp", newJString(userIp))
  add(query_578863, "quotaUser", newJString(quotaUser))
  add(query_578863, "fields", newJString(fields))
  result = call_578862.call(nil, query_578863, nil, nil, nil)

var adexchangebuyerAccountsList* = Call_AdexchangebuyerAccountsList_578635(
    name: "adexchangebuyerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangebuyerAccountsList_578636,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsList_578637,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsUpdate_578932 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerAccountsUpdate_578934(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsUpdate_578933(path: JsonNode; query: JsonNode;
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
  var valid_578935 = path.getOrDefault("id")
  valid_578935 = validateParameter(valid_578935, JInt, required = true, default = nil)
  if valid_578935 != nil:
    section.add "id", valid_578935
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
  ##   confirmUnsafeAccountChange: JBool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578936 = query.getOrDefault("key")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "key", valid_578936
  var valid_578937 = query.getOrDefault("prettyPrint")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "prettyPrint", valid_578937
  var valid_578938 = query.getOrDefault("oauth_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "oauth_token", valid_578938
  var valid_578939 = query.getOrDefault("alt")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("json"))
  if valid_578939 != nil:
    section.add "alt", valid_578939
  var valid_578940 = query.getOrDefault("userIp")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "userIp", valid_578940
  var valid_578941 = query.getOrDefault("quotaUser")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "quotaUser", valid_578941
  var valid_578942 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_578942 = validateParameter(valid_578942, JBool, required = false, default = nil)
  if valid_578942 != nil:
    section.add "confirmUnsafeAccountChange", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
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

proc call*(call_578945: Call_AdexchangebuyerAccountsUpdate_578932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account.
  ## 
  let valid = call_578945.validator(path, query, header, formData, body)
  let scheme = call_578945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578945.url(scheme.get, call_578945.host, call_578945.base,
                         call_578945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578945, url, valid)

proc call*(call_578946: Call_AdexchangebuyerAccountsUpdate_578932; id: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          confirmUnsafeAccountChange: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  ##   confirmUnsafeAccountChange: bool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578947 = newJObject()
  var query_578948 = newJObject()
  var body_578949 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(path_578947, "id", newJInt(id))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "userIp", newJString(userIp))
  add(query_578948, "quotaUser", newJString(quotaUser))
  add(query_578948, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  if body != nil:
    body_578949 = body
  add(query_578948, "fields", newJString(fields))
  result = call_578946.call(path_578947, query_578948, nil, nil, body_578949)

var adexchangebuyerAccountsUpdate* = Call_AdexchangebuyerAccountsUpdate_578932(
    name: "adexchangebuyerAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsUpdate_578933,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsUpdate_578934,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsGet_578903 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerAccountsGet_578905(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsGet_578904(path: JsonNode; query: JsonNode;
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
  var valid_578920 = path.getOrDefault("id")
  valid_578920 = validateParameter(valid_578920, JInt, required = true, default = nil)
  if valid_578920 != nil:
    section.add "id", valid_578920
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
  var valid_578921 = query.getOrDefault("key")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "key", valid_578921
  var valid_578922 = query.getOrDefault("prettyPrint")
  valid_578922 = validateParameter(valid_578922, JBool, required = false,
                                 default = newJBool(true))
  if valid_578922 != nil:
    section.add "prettyPrint", valid_578922
  var valid_578923 = query.getOrDefault("oauth_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "oauth_token", valid_578923
  var valid_578924 = query.getOrDefault("alt")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("json"))
  if valid_578924 != nil:
    section.add "alt", valid_578924
  var valid_578925 = query.getOrDefault("userIp")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "userIp", valid_578925
  var valid_578926 = query.getOrDefault("quotaUser")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "quotaUser", valid_578926
  var valid_578927 = query.getOrDefault("fields")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "fields", valid_578927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578928: Call_AdexchangebuyerAccountsGet_578903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one account by ID.
  ## 
  let valid = call_578928.validator(path, query, header, formData, body)
  let scheme = call_578928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578928.url(scheme.get, call_578928.host, call_578928.base,
                         call_578928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578928, url, valid)

proc call*(call_578929: Call_AdexchangebuyerAccountsGet_578903; id: int;
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
  var path_578930 = newJObject()
  var query_578931 = newJObject()
  add(query_578931, "key", newJString(key))
  add(query_578931, "prettyPrint", newJBool(prettyPrint))
  add(query_578931, "oauth_token", newJString(oauthToken))
  add(path_578930, "id", newJInt(id))
  add(query_578931, "alt", newJString(alt))
  add(query_578931, "userIp", newJString(userIp))
  add(query_578931, "quotaUser", newJString(quotaUser))
  add(query_578931, "fields", newJString(fields))
  result = call_578929.call(path_578930, query_578931, nil, nil, nil)

var adexchangebuyerAccountsGet* = Call_AdexchangebuyerAccountsGet_578903(
    name: "adexchangebuyerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsGet_578904,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsGet_578905,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerAccountsPatch_578950 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerAccountsPatch_578952(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerAccountsPatch_578951(path: JsonNode; query: JsonNode;
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
  var valid_578953 = path.getOrDefault("id")
  valid_578953 = validateParameter(valid_578953, JInt, required = true, default = nil)
  if valid_578953 != nil:
    section.add "id", valid_578953
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
  ##   confirmUnsafeAccountChange: JBool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("userIp")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "userIp", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("confirmUnsafeAccountChange")
  valid_578960 = validateParameter(valid_578960, JBool, required = false, default = nil)
  if valid_578960 != nil:
    section.add "confirmUnsafeAccountChange", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
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

proc call*(call_578963: Call_AdexchangebuyerAccountsPatch_578950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing account. This method supports patch semantics.
  ## 
  let valid = call_578963.validator(path, query, header, formData, body)
  let scheme = call_578963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578963.url(scheme.get, call_578963.host, call_578963.base,
                         call_578963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578963, url, valid)

proc call*(call_578964: Call_AdexchangebuyerAccountsPatch_578950; id: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          confirmUnsafeAccountChange: bool = false; body: JsonNode = nil;
          fields: string = ""): Recallable =
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
  ##   confirmUnsafeAccountChange: bool
  ##                             : Confirmation for erasing bidder and cookie matching urls.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578965 = newJObject()
  var query_578966 = newJObject()
  var body_578967 = newJObject()
  add(query_578966, "key", newJString(key))
  add(query_578966, "prettyPrint", newJBool(prettyPrint))
  add(query_578966, "oauth_token", newJString(oauthToken))
  add(path_578965, "id", newJInt(id))
  add(query_578966, "alt", newJString(alt))
  add(query_578966, "userIp", newJString(userIp))
  add(query_578966, "quotaUser", newJString(quotaUser))
  add(query_578966, "confirmUnsafeAccountChange",
      newJBool(confirmUnsafeAccountChange))
  if body != nil:
    body_578967 = body
  add(query_578966, "fields", newJString(fields))
  result = call_578964.call(path_578965, query_578966, nil, nil, body_578967)

var adexchangebuyerAccountsPatch* = Call_AdexchangebuyerAccountsPatch_578950(
    name: "adexchangebuyerAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/accounts/{id}",
    validator: validate_AdexchangebuyerAccountsPatch_578951,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerAccountsPatch_578952,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoList_578968 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerBillingInfoList_578970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerBillingInfoList_578969(path: JsonNode;
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
  var valid_578971 = query.getOrDefault("key")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "key", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  var valid_578974 = query.getOrDefault("alt")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = newJString("json"))
  if valid_578974 != nil:
    section.add "alt", valid_578974
  var valid_578975 = query.getOrDefault("userIp")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "userIp", valid_578975
  var valid_578976 = query.getOrDefault("quotaUser")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "quotaUser", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578978: Call_AdexchangebuyerBillingInfoList_578968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of billing information for all accounts of the authenticated user.
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_AdexchangebuyerBillingInfoList_578968;
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
  var query_578980 = newJObject()
  add(query_578980, "key", newJString(key))
  add(query_578980, "prettyPrint", newJBool(prettyPrint))
  add(query_578980, "oauth_token", newJString(oauthToken))
  add(query_578980, "alt", newJString(alt))
  add(query_578980, "userIp", newJString(userIp))
  add(query_578980, "quotaUser", newJString(quotaUser))
  add(query_578980, "fields", newJString(fields))
  result = call_578979.call(nil, query_578980, nil, nil, nil)

var adexchangebuyerBillingInfoList* = Call_AdexchangebuyerBillingInfoList_578968(
    name: "adexchangebuyerBillingInfoList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo",
    validator: validate_AdexchangebuyerBillingInfoList_578969,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoList_578970,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBillingInfoGet_578981 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerBillingInfoGet_578983(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBillingInfoGet_578982(path: JsonNode; query: JsonNode;
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
  var valid_578984 = path.getOrDefault("accountId")
  valid_578984 = validateParameter(valid_578984, JInt, required = true, default = nil)
  if valid_578984 != nil:
    section.add "accountId", valid_578984
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
  var valid_578985 = query.getOrDefault("key")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "key", valid_578985
  var valid_578986 = query.getOrDefault("prettyPrint")
  valid_578986 = validateParameter(valid_578986, JBool, required = false,
                                 default = newJBool(true))
  if valid_578986 != nil:
    section.add "prettyPrint", valid_578986
  var valid_578987 = query.getOrDefault("oauth_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "oauth_token", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("userIp")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "userIp", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578992: Call_AdexchangebuyerBillingInfoGet_578981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the billing information for one account specified by account ID.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_AdexchangebuyerBillingInfoGet_578981; accountId: int;
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
  var path_578994 = newJObject()
  var query_578995 = newJObject()
  add(query_578995, "key", newJString(key))
  add(query_578995, "prettyPrint", newJBool(prettyPrint))
  add(query_578995, "oauth_token", newJString(oauthToken))
  add(query_578995, "alt", newJString(alt))
  add(query_578995, "userIp", newJString(userIp))
  add(query_578995, "quotaUser", newJString(quotaUser))
  add(path_578994, "accountId", newJInt(accountId))
  add(query_578995, "fields", newJString(fields))
  result = call_578993.call(path_578994, query_578995, nil, nil, nil)

var adexchangebuyerBillingInfoGet* = Call_AdexchangebuyerBillingInfoGet_578981(
    name: "adexchangebuyerBillingInfoGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}",
    validator: validate_AdexchangebuyerBillingInfoGet_578982,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBillingInfoGet_578983,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetUpdate_579012 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerBudgetUpdate_579014(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetUpdate_579013(path: JsonNode; query: JsonNode;
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
  var valid_579015 = path.getOrDefault("billingId")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "billingId", valid_579015
  var valid_579016 = path.getOrDefault("accountId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "accountId", valid_579016
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
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("alt")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("json"))
  if valid_579020 != nil:
    section.add "alt", valid_579020
  var valid_579021 = query.getOrDefault("userIp")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "userIp", valid_579021
  var valid_579022 = query.getOrDefault("quotaUser")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "quotaUser", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
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

proc call*(call_579025: Call_AdexchangebuyerBudgetUpdate_579012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_AdexchangebuyerBudgetUpdate_579012; billingId: string;
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
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  var body_579029 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(path_579027, "billingId", newJString(billingId))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "userIp", newJString(userIp))
  add(query_579028, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579029 = body
  add(path_579027, "accountId", newJString(accountId))
  add(query_579028, "fields", newJString(fields))
  result = call_579026.call(path_579027, query_579028, nil, nil, body_579029)

var adexchangebuyerBudgetUpdate* = Call_AdexchangebuyerBudgetUpdate_579012(
    name: "adexchangebuyerBudgetUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetUpdate_579013,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetUpdate_579014,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetGet_578996 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerBudgetGet_578998(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetGet_578997(path: JsonNode; query: JsonNode;
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
  var valid_578999 = path.getOrDefault("billingId")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "billingId", valid_578999
  var valid_579000 = path.getOrDefault("accountId")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "accountId", valid_579000
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
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("alt")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("json"))
  if valid_579004 != nil:
    section.add "alt", valid_579004
  var valid_579005 = query.getOrDefault("userIp")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "userIp", valid_579005
  var valid_579006 = query.getOrDefault("quotaUser")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "quotaUser", valid_579006
  var valid_579007 = query.getOrDefault("fields")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "fields", valid_579007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579008: Call_AdexchangebuyerBudgetGet_578996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the budget information for the adgroup specified by the accountId and billingId.
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_AdexchangebuyerBudgetGet_578996; billingId: string;
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
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(path_579010, "billingId", newJString(billingId))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "userIp", newJString(userIp))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(path_579010, "accountId", newJString(accountId))
  add(query_579011, "fields", newJString(fields))
  result = call_579009.call(path_579010, query_579011, nil, nil, nil)

var adexchangebuyerBudgetGet* = Call_AdexchangebuyerBudgetGet_578996(
    name: "adexchangebuyerBudgetGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetGet_578997,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetGet_578998,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerBudgetPatch_579030 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerBudgetPatch_579032(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerBudgetPatch_579031(path: JsonNode; query: JsonNode;
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
  var valid_579033 = path.getOrDefault("billingId")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "billingId", valid_579033
  var valid_579034 = path.getOrDefault("accountId")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "accountId", valid_579034
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
  var valid_579035 = query.getOrDefault("key")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "key", valid_579035
  var valid_579036 = query.getOrDefault("prettyPrint")
  valid_579036 = validateParameter(valid_579036, JBool, required = false,
                                 default = newJBool(true))
  if valid_579036 != nil:
    section.add "prettyPrint", valid_579036
  var valid_579037 = query.getOrDefault("oauth_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "oauth_token", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("userIp")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "userIp", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("fields")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "fields", valid_579041
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

proc call*(call_579043: Call_AdexchangebuyerBudgetPatch_579030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the budget amount for the budget of the adgroup specified by the accountId and billingId, with the budget amount in the request. This method supports patch semantics.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_AdexchangebuyerBudgetPatch_579030; billingId: string;
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
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  var body_579047 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(path_579045, "billingId", newJString(billingId))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "userIp", newJString(userIp))
  add(query_579046, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579047 = body
  add(path_579045, "accountId", newJString(accountId))
  add(query_579046, "fields", newJString(fields))
  result = call_579044.call(path_579045, query_579046, nil, nil, body_579047)

var adexchangebuyerBudgetPatch* = Call_AdexchangebuyerBudgetPatch_579030(
    name: "adexchangebuyerBudgetPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/billinginfo/{accountId}/{billingId}",
    validator: validate_AdexchangebuyerBudgetPatch_579031,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerBudgetPatch_579032,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesInsert_579067 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerCreativesInsert_579069(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesInsert_579068(path: JsonNode;
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
  var valid_579070 = query.getOrDefault("key")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "key", valid_579070
  var valid_579071 = query.getOrDefault("prettyPrint")
  valid_579071 = validateParameter(valid_579071, JBool, required = false,
                                 default = newJBool(true))
  if valid_579071 != nil:
    section.add "prettyPrint", valid_579071
  var valid_579072 = query.getOrDefault("oauth_token")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "oauth_token", valid_579072
  var valid_579073 = query.getOrDefault("alt")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("json"))
  if valid_579073 != nil:
    section.add "alt", valid_579073
  var valid_579074 = query.getOrDefault("userIp")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "userIp", valid_579074
  var valid_579075 = query.getOrDefault("quotaUser")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "quotaUser", valid_579075
  var valid_579076 = query.getOrDefault("fields")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "fields", valid_579076
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

proc call*(call_579078: Call_AdexchangebuyerCreativesInsert_579067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit a new creative.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_AdexchangebuyerCreativesInsert_579067;
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
  var query_579080 = newJObject()
  var body_579081 = newJObject()
  add(query_579080, "key", newJString(key))
  add(query_579080, "prettyPrint", newJBool(prettyPrint))
  add(query_579080, "oauth_token", newJString(oauthToken))
  add(query_579080, "alt", newJString(alt))
  add(query_579080, "userIp", newJString(userIp))
  add(query_579080, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579081 = body
  add(query_579080, "fields", newJString(fields))
  result = call_579079.call(nil, query_579080, nil, nil, body_579081)

var adexchangebuyerCreativesInsert* = Call_AdexchangebuyerCreativesInsert_579067(
    name: "adexchangebuyerCreativesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesInsert_579068,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesInsert_579069,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesList_579048 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerCreativesList_579050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerCreativesList_579049(path: JsonNode; query: JsonNode;
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
  ##   openAuctionStatusFilter: JString
  ##                          : When specified, only creatives having the given open auction status are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   dealsStatusFilter: JString
  ##                    : When specified, only creatives having the given deals status are returned.
  ##   accountId: JArray
  ##            : When specified, only creatives for the given account ids are returned.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  section = newJObject()
  var valid_579051 = query.getOrDefault("key")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "key", valid_579051
  var valid_579052 = query.getOrDefault("prettyPrint")
  valid_579052 = validateParameter(valid_579052, JBool, required = false,
                                 default = newJBool(true))
  if valid_579052 != nil:
    section.add "prettyPrint", valid_579052
  var valid_579053 = query.getOrDefault("oauth_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "oauth_token", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("userIp")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "userIp", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("buyerCreativeId")
  valid_579057 = validateParameter(valid_579057, JArray, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "buyerCreativeId", valid_579057
  var valid_579058 = query.getOrDefault("pageToken")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "pageToken", valid_579058
  var valid_579059 = query.getOrDefault("openAuctionStatusFilter")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("approved"))
  if valid_579059 != nil:
    section.add "openAuctionStatusFilter", valid_579059
  var valid_579060 = query.getOrDefault("fields")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "fields", valid_579060
  var valid_579061 = query.getOrDefault("dealsStatusFilter")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("approved"))
  if valid_579061 != nil:
    section.add "dealsStatusFilter", valid_579061
  var valid_579062 = query.getOrDefault("accountId")
  valid_579062 = validateParameter(valid_579062, JArray, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "accountId", valid_579062
  var valid_579063 = query.getOrDefault("maxResults")
  valid_579063 = validateParameter(valid_579063, JInt, required = false, default = nil)
  if valid_579063 != nil:
    section.add "maxResults", valid_579063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579064: Call_AdexchangebuyerCreativesList_579048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_579064.validator(path, query, header, formData, body)
  let scheme = call_579064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579064.url(scheme.get, call_579064.host, call_579064.base,
                         call_579064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579064, url, valid)

proc call*(call_579065: Call_AdexchangebuyerCreativesList_579048; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; buyerCreativeId: JsonNode = nil;
          pageToken: string = ""; openAuctionStatusFilter: string = "approved";
          fields: string = ""; dealsStatusFilter: string = "approved";
          accountId: JsonNode = nil; maxResults: int = 0): Recallable =
  ## adexchangebuyerCreativesList
  ## Retrieves a list of the authenticated user's active creatives. A creative will be available 30-40 minutes after submission.
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
  ##   buyerCreativeId: JArray
  ##                  : When specified, only creatives for the given buyer creative ids are returned.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response. Optional.
  ##   openAuctionStatusFilter: string
  ##                          : When specified, only creatives having the given open auction status are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   dealsStatusFilter: string
  ##                    : When specified, only creatives having the given deals status are returned.
  ##   accountId: JArray
  ##            : When specified, only creatives for the given account ids are returned.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. If not set, the default is 100. Optional.
  var query_579066 = newJObject()
  add(query_579066, "key", newJString(key))
  add(query_579066, "prettyPrint", newJBool(prettyPrint))
  add(query_579066, "oauth_token", newJString(oauthToken))
  add(query_579066, "alt", newJString(alt))
  add(query_579066, "userIp", newJString(userIp))
  add(query_579066, "quotaUser", newJString(quotaUser))
  if buyerCreativeId != nil:
    query_579066.add "buyerCreativeId", buyerCreativeId
  add(query_579066, "pageToken", newJString(pageToken))
  add(query_579066, "openAuctionStatusFilter", newJString(openAuctionStatusFilter))
  add(query_579066, "fields", newJString(fields))
  add(query_579066, "dealsStatusFilter", newJString(dealsStatusFilter))
  if accountId != nil:
    query_579066.add "accountId", accountId
  add(query_579066, "maxResults", newJInt(maxResults))
  result = call_579065.call(nil, query_579066, nil, nil, nil)

var adexchangebuyerCreativesList* = Call_AdexchangebuyerCreativesList_579048(
    name: "adexchangebuyerCreativesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives",
    validator: validate_AdexchangebuyerCreativesList_579049,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesList_579050,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesGet_579082 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerCreativesGet_579084(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesGet_579083(path: JsonNode; query: JsonNode;
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
  var valid_579085 = path.getOrDefault("buyerCreativeId")
  valid_579085 = validateParameter(valid_579085, JString, required = true,
                                 default = nil)
  if valid_579085 != nil:
    section.add "buyerCreativeId", valid_579085
  var valid_579086 = path.getOrDefault("accountId")
  valid_579086 = validateParameter(valid_579086, JInt, required = true, default = nil)
  if valid_579086 != nil:
    section.add "accountId", valid_579086
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
  var valid_579087 = query.getOrDefault("key")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "key", valid_579087
  var valid_579088 = query.getOrDefault("prettyPrint")
  valid_579088 = validateParameter(valid_579088, JBool, required = false,
                                 default = newJBool(true))
  if valid_579088 != nil:
    section.add "prettyPrint", valid_579088
  var valid_579089 = query.getOrDefault("oauth_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "oauth_token", valid_579089
  var valid_579090 = query.getOrDefault("alt")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = newJString("json"))
  if valid_579090 != nil:
    section.add "alt", valid_579090
  var valid_579091 = query.getOrDefault("userIp")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "userIp", valid_579091
  var valid_579092 = query.getOrDefault("quotaUser")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "quotaUser", valid_579092
  var valid_579093 = query.getOrDefault("fields")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "fields", valid_579093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579094: Call_AdexchangebuyerCreativesGet_579082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status for a single creative. A creative will be available 30-40 minutes after submission.
  ## 
  let valid = call_579094.validator(path, query, header, formData, body)
  let scheme = call_579094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579094.url(scheme.get, call_579094.host, call_579094.base,
                         call_579094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579094, url, valid)

proc call*(call_579095: Call_AdexchangebuyerCreativesGet_579082;
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
  var path_579096 = newJObject()
  var query_579097 = newJObject()
  add(query_579097, "key", newJString(key))
  add(query_579097, "prettyPrint", newJBool(prettyPrint))
  add(query_579097, "oauth_token", newJString(oauthToken))
  add(path_579096, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_579097, "alt", newJString(alt))
  add(query_579097, "userIp", newJString(userIp))
  add(query_579097, "quotaUser", newJString(quotaUser))
  add(path_579096, "accountId", newJInt(accountId))
  add(query_579097, "fields", newJString(fields))
  result = call_579095.call(path_579096, query_579097, nil, nil, nil)

var adexchangebuyerCreativesGet* = Call_AdexchangebuyerCreativesGet_579082(
    name: "adexchangebuyerCreativesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/creatives/{accountId}/{buyerCreativeId}",
    validator: validate_AdexchangebuyerCreativesGet_579083,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesGet_579084,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesAddDeal_579098 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerCreativesAddDeal_579100(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesAddDeal_579099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a deal id association for the creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   buyerCreativeId: JString (required)
  ##                  : The buyer-specific id for this creative.
  ##   dealId: JString (required)
  ##         : The id of the deal id to associate with this creative.
  ##   accountId: JInt (required)
  ##            : The id for the account that will serve this creative.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `buyerCreativeId` field"
  var valid_579101 = path.getOrDefault("buyerCreativeId")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "buyerCreativeId", valid_579101
  var valid_579102 = path.getOrDefault("dealId")
  valid_579102 = validateParameter(valid_579102, JString, required = true,
                                 default = nil)
  if valid_579102 != nil:
    section.add "dealId", valid_579102
  var valid_579103 = path.getOrDefault("accountId")
  valid_579103 = validateParameter(valid_579103, JInt, required = true, default = nil)
  if valid_579103 != nil:
    section.add "accountId", valid_579103
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
  var valid_579104 = query.getOrDefault("key")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "key", valid_579104
  var valid_579105 = query.getOrDefault("prettyPrint")
  valid_579105 = validateParameter(valid_579105, JBool, required = false,
                                 default = newJBool(true))
  if valid_579105 != nil:
    section.add "prettyPrint", valid_579105
  var valid_579106 = query.getOrDefault("oauth_token")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "oauth_token", valid_579106
  var valid_579107 = query.getOrDefault("alt")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = newJString("json"))
  if valid_579107 != nil:
    section.add "alt", valid_579107
  var valid_579108 = query.getOrDefault("userIp")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "userIp", valid_579108
  var valid_579109 = query.getOrDefault("quotaUser")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "quotaUser", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579111: Call_AdexchangebuyerCreativesAddDeal_579098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a deal id association for the creative.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_AdexchangebuyerCreativesAddDeal_579098;
          buyerCreativeId: string; dealId: string; accountId: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerCreativesAddDeal
  ## Add a deal id association for the creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   buyerCreativeId: string (required)
  ##                  : The buyer-specific id for this creative.
  ##   dealId: string (required)
  ##         : The id of the deal id to associate with this creative.
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
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(path_579113, "buyerCreativeId", newJString(buyerCreativeId))
  add(path_579113, "dealId", newJString(dealId))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "userIp", newJString(userIp))
  add(query_579114, "quotaUser", newJString(quotaUser))
  add(path_579113, "accountId", newJInt(accountId))
  add(query_579114, "fields", newJString(fields))
  result = call_579112.call(path_579113, query_579114, nil, nil, nil)

var adexchangebuyerCreativesAddDeal* = Call_AdexchangebuyerCreativesAddDeal_579098(
    name: "adexchangebuyerCreativesAddDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/addDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesAddDeal_579099,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesAddDeal_579100,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesListDeals_579115 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerCreativesListDeals_579117(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesListDeals_579116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the external deal ids associated with the creative.
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
  var valid_579118 = path.getOrDefault("buyerCreativeId")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "buyerCreativeId", valid_579118
  var valid_579119 = path.getOrDefault("accountId")
  valid_579119 = validateParameter(valid_579119, JInt, required = true, default = nil)
  if valid_579119 != nil:
    section.add "accountId", valid_579119
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
  var valid_579120 = query.getOrDefault("key")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "key", valid_579120
  var valid_579121 = query.getOrDefault("prettyPrint")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(true))
  if valid_579121 != nil:
    section.add "prettyPrint", valid_579121
  var valid_579122 = query.getOrDefault("oauth_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "oauth_token", valid_579122
  var valid_579123 = query.getOrDefault("alt")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("json"))
  if valid_579123 != nil:
    section.add "alt", valid_579123
  var valid_579124 = query.getOrDefault("userIp")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "userIp", valid_579124
  var valid_579125 = query.getOrDefault("quotaUser")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "quotaUser", valid_579125
  var valid_579126 = query.getOrDefault("fields")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "fields", valid_579126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579127: Call_AdexchangebuyerCreativesListDeals_579115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the external deal ids associated with the creative.
  ## 
  let valid = call_579127.validator(path, query, header, formData, body)
  let scheme = call_579127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579127.url(scheme.get, call_579127.host, call_579127.base,
                         call_579127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579127, url, valid)

proc call*(call_579128: Call_AdexchangebuyerCreativesListDeals_579115;
          buyerCreativeId: string; accountId: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerCreativesListDeals
  ## Lists the external deal ids associated with the creative.
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
  var path_579129 = newJObject()
  var query_579130 = newJObject()
  add(query_579130, "key", newJString(key))
  add(query_579130, "prettyPrint", newJBool(prettyPrint))
  add(query_579130, "oauth_token", newJString(oauthToken))
  add(path_579129, "buyerCreativeId", newJString(buyerCreativeId))
  add(query_579130, "alt", newJString(alt))
  add(query_579130, "userIp", newJString(userIp))
  add(query_579130, "quotaUser", newJString(quotaUser))
  add(path_579129, "accountId", newJInt(accountId))
  add(query_579130, "fields", newJString(fields))
  result = call_579128.call(path_579129, query_579130, nil, nil, nil)

var adexchangebuyerCreativesListDeals* = Call_AdexchangebuyerCreativesListDeals_579115(
    name: "adexchangebuyerCreativesListDeals", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/listDeals",
    validator: validate_AdexchangebuyerCreativesListDeals_579116,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesListDeals_579117,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerCreativesRemoveDeal_579131 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerCreativesRemoveDeal_579133(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerCreativesRemoveDeal_579132(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove a deal id associated with the creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   buyerCreativeId: JString (required)
  ##                  : The buyer-specific id for this creative.
  ##   dealId: JString (required)
  ##         : The id of the deal id to disassociate with this creative.
  ##   accountId: JInt (required)
  ##            : The id for the account that will serve this creative.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `buyerCreativeId` field"
  var valid_579134 = path.getOrDefault("buyerCreativeId")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "buyerCreativeId", valid_579134
  var valid_579135 = path.getOrDefault("dealId")
  valid_579135 = validateParameter(valid_579135, JString, required = true,
                                 default = nil)
  if valid_579135 != nil:
    section.add "dealId", valid_579135
  var valid_579136 = path.getOrDefault("accountId")
  valid_579136 = validateParameter(valid_579136, JInt, required = true, default = nil)
  if valid_579136 != nil:
    section.add "accountId", valid_579136
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
  var valid_579137 = query.getOrDefault("key")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "key", valid_579137
  var valid_579138 = query.getOrDefault("prettyPrint")
  valid_579138 = validateParameter(valid_579138, JBool, required = false,
                                 default = newJBool(true))
  if valid_579138 != nil:
    section.add "prettyPrint", valid_579138
  var valid_579139 = query.getOrDefault("oauth_token")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "oauth_token", valid_579139
  var valid_579140 = query.getOrDefault("alt")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("json"))
  if valid_579140 != nil:
    section.add "alt", valid_579140
  var valid_579141 = query.getOrDefault("userIp")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "userIp", valid_579141
  var valid_579142 = query.getOrDefault("quotaUser")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "quotaUser", valid_579142
  var valid_579143 = query.getOrDefault("fields")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "fields", valid_579143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579144: Call_AdexchangebuyerCreativesRemoveDeal_579131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove a deal id associated with the creative.
  ## 
  let valid = call_579144.validator(path, query, header, formData, body)
  let scheme = call_579144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579144.url(scheme.get, call_579144.host, call_579144.base,
                         call_579144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579144, url, valid)

proc call*(call_579145: Call_AdexchangebuyerCreativesRemoveDeal_579131;
          buyerCreativeId: string; dealId: string; accountId: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerCreativesRemoveDeal
  ## Remove a deal id associated with the creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   buyerCreativeId: string (required)
  ##                  : The buyer-specific id for this creative.
  ##   dealId: string (required)
  ##         : The id of the deal id to disassociate with this creative.
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
  var path_579146 = newJObject()
  var query_579147 = newJObject()
  add(query_579147, "key", newJString(key))
  add(query_579147, "prettyPrint", newJBool(prettyPrint))
  add(query_579147, "oauth_token", newJString(oauthToken))
  add(path_579146, "buyerCreativeId", newJString(buyerCreativeId))
  add(path_579146, "dealId", newJString(dealId))
  add(query_579147, "alt", newJString(alt))
  add(query_579147, "userIp", newJString(userIp))
  add(query_579147, "quotaUser", newJString(quotaUser))
  add(path_579146, "accountId", newJInt(accountId))
  add(query_579147, "fields", newJString(fields))
  result = call_579145.call(path_579146, query_579147, nil, nil, nil)

var adexchangebuyerCreativesRemoveDeal* = Call_AdexchangebuyerCreativesRemoveDeal_579131(
    name: "adexchangebuyerCreativesRemoveDeal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/creatives/{accountId}/{buyerCreativeId}/removeDeal/{dealId}",
    validator: validate_AdexchangebuyerCreativesRemoveDeal_579132,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerCreativesRemoveDeal_579133,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPerformanceReportList_579148 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPerformanceReportList_579150(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerPerformanceReportList_579149(path: JsonNode;
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
  var valid_579157 = query.getOrDefault("pageToken")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "pageToken", valid_579157
  assert query != nil,
        "query argument is necessary due to required `startDateTime` field"
  var valid_579158 = query.getOrDefault("startDateTime")
  valid_579158 = validateParameter(valid_579158, JString, required = true,
                                 default = nil)
  if valid_579158 != nil:
    section.add "startDateTime", valid_579158
  var valid_579159 = query.getOrDefault("endDateTime")
  valid_579159 = validateParameter(valid_579159, JString, required = true,
                                 default = nil)
  if valid_579159 != nil:
    section.add "endDateTime", valid_579159
  var valid_579160 = query.getOrDefault("fields")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "fields", valid_579160
  var valid_579161 = query.getOrDefault("accountId")
  valid_579161 = validateParameter(valid_579161, JString, required = true,
                                 default = nil)
  if valid_579161 != nil:
    section.add "accountId", valid_579161
  var valid_579162 = query.getOrDefault("maxResults")
  valid_579162 = validateParameter(valid_579162, JInt, required = false, default = nil)
  if valid_579162 != nil:
    section.add "maxResults", valid_579162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579163: Call_AdexchangebuyerPerformanceReportList_579148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authenticated user's list of performance metrics.
  ## 
  let valid = call_579163.validator(path, query, header, formData, body)
  let scheme = call_579163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579163.url(scheme.get, call_579163.host, call_579163.base,
                         call_579163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579163, url, valid)

proc call*(call_579164: Call_AdexchangebuyerPerformanceReportList_579148;
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
  var query_579165 = newJObject()
  add(query_579165, "key", newJString(key))
  add(query_579165, "prettyPrint", newJBool(prettyPrint))
  add(query_579165, "oauth_token", newJString(oauthToken))
  add(query_579165, "alt", newJString(alt))
  add(query_579165, "userIp", newJString(userIp))
  add(query_579165, "quotaUser", newJString(quotaUser))
  add(query_579165, "pageToken", newJString(pageToken))
  add(query_579165, "startDateTime", newJString(startDateTime))
  add(query_579165, "endDateTime", newJString(endDateTime))
  add(query_579165, "fields", newJString(fields))
  add(query_579165, "accountId", newJString(accountId))
  add(query_579165, "maxResults", newJInt(maxResults))
  result = call_579164.call(nil, query_579165, nil, nil, nil)

var adexchangebuyerPerformanceReportList* = Call_AdexchangebuyerPerformanceReportList_579148(
    name: "adexchangebuyerPerformanceReportList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/performancereport",
    validator: validate_AdexchangebuyerPerformanceReportList_579149,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPerformanceReportList_579150,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigInsert_579181 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPretargetingConfigInsert_579183(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigInsert_579182(path: JsonNode;
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

proc call*(call_579193: Call_AdexchangebuyerPretargetingConfigInsert_579181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new pretargeting configuration.
  ## 
  let valid = call_579193.validator(path, query, header, formData, body)
  let scheme = call_579193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579193.url(scheme.get, call_579193.host, call_579193.base,
                         call_579193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579193, url, valid)

proc call*(call_579194: Call_AdexchangebuyerPretargetingConfigInsert_579181;
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
  var path_579195 = newJObject()
  var query_579196 = newJObject()
  var body_579197 = newJObject()
  add(query_579196, "key", newJString(key))
  add(query_579196, "prettyPrint", newJBool(prettyPrint))
  add(query_579196, "oauth_token", newJString(oauthToken))
  add(query_579196, "alt", newJString(alt))
  add(query_579196, "userIp", newJString(userIp))
  add(query_579196, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579197 = body
  add(path_579195, "accountId", newJString(accountId))
  add(query_579196, "fields", newJString(fields))
  result = call_579194.call(path_579195, query_579196, nil, nil, body_579197)

var adexchangebuyerPretargetingConfigInsert* = Call_AdexchangebuyerPretargetingConfigInsert_579181(
    name: "adexchangebuyerPretargetingConfigInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigInsert_579182,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigInsert_579183,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigList_579166 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPretargetingConfigList_579168(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigList_579167(path: JsonNode;
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
  var valid_579169 = path.getOrDefault("accountId")
  valid_579169 = validateParameter(valid_579169, JString, required = true,
                                 default = nil)
  if valid_579169 != nil:
    section.add "accountId", valid_579169
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
  var valid_579170 = query.getOrDefault("key")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "key", valid_579170
  var valid_579171 = query.getOrDefault("prettyPrint")
  valid_579171 = validateParameter(valid_579171, JBool, required = false,
                                 default = newJBool(true))
  if valid_579171 != nil:
    section.add "prettyPrint", valid_579171
  var valid_579172 = query.getOrDefault("oauth_token")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "oauth_token", valid_579172
  var valid_579173 = query.getOrDefault("alt")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = newJString("json"))
  if valid_579173 != nil:
    section.add "alt", valid_579173
  var valid_579174 = query.getOrDefault("userIp")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "userIp", valid_579174
  var valid_579175 = query.getOrDefault("quotaUser")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "quotaUser", valid_579175
  var valid_579176 = query.getOrDefault("fields")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "fields", valid_579176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579177: Call_AdexchangebuyerPretargetingConfigList_579166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of the authenticated user's pretargeting configurations.
  ## 
  let valid = call_579177.validator(path, query, header, formData, body)
  let scheme = call_579177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579177.url(scheme.get, call_579177.host, call_579177.base,
                         call_579177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579177, url, valid)

proc call*(call_579178: Call_AdexchangebuyerPretargetingConfigList_579166;
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
  var path_579179 = newJObject()
  var query_579180 = newJObject()
  add(query_579180, "key", newJString(key))
  add(query_579180, "prettyPrint", newJBool(prettyPrint))
  add(query_579180, "oauth_token", newJString(oauthToken))
  add(query_579180, "alt", newJString(alt))
  add(query_579180, "userIp", newJString(userIp))
  add(query_579180, "quotaUser", newJString(quotaUser))
  add(path_579179, "accountId", newJString(accountId))
  add(query_579180, "fields", newJString(fields))
  result = call_579178.call(path_579179, query_579180, nil, nil, nil)

var adexchangebuyerPretargetingConfigList* = Call_AdexchangebuyerPretargetingConfigList_579166(
    name: "adexchangebuyerPretargetingConfigList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/pretargetingconfigs/{accountId}",
    validator: validate_AdexchangebuyerPretargetingConfigList_579167,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigList_579168,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigUpdate_579214 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPretargetingConfigUpdate_579216(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigUpdate_579215(path: JsonNode;
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

proc call*(call_579227: Call_AdexchangebuyerPretargetingConfigUpdate_579214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config.
  ## 
  let valid = call_579227.validator(path, query, header, formData, body)
  let scheme = call_579227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579227.url(scheme.get, call_579227.host, call_579227.base,
                         call_579227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579227, url, valid)

proc call*(call_579228: Call_AdexchangebuyerPretargetingConfigUpdate_579214;
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

var adexchangebuyerPretargetingConfigUpdate* = Call_AdexchangebuyerPretargetingConfigUpdate_579214(
    name: "adexchangebuyerPretargetingConfigUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigUpdate_579215,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigUpdate_579216,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigGet_579198 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPretargetingConfigGet_579200(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigGet_579199(path: JsonNode;
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

proc call*(call_579210: Call_AdexchangebuyerPretargetingConfigGet_579198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific pretargeting configuration
  ## 
  let valid = call_579210.validator(path, query, header, formData, body)
  let scheme = call_579210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579210.url(scheme.get, call_579210.host, call_579210.base,
                         call_579210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579210, url, valid)

proc call*(call_579211: Call_AdexchangebuyerPretargetingConfigGet_579198;
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

var adexchangebuyerPretargetingConfigGet* = Call_AdexchangebuyerPretargetingConfigGet_579198(
    name: "adexchangebuyerPretargetingConfigGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigGet_579199,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPretargetingConfigGet_579200,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigPatch_579248 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPretargetingConfigPatch_579250(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigPatch_579249(path: JsonNode;
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
  var valid_579251 = path.getOrDefault("configId")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "configId", valid_579251
  var valid_579252 = path.getOrDefault("accountId")
  valid_579252 = validateParameter(valid_579252, JString, required = true,
                                 default = nil)
  if valid_579252 != nil:
    section.add "accountId", valid_579252
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
  var valid_579253 = query.getOrDefault("key")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "key", valid_579253
  var valid_579254 = query.getOrDefault("prettyPrint")
  valid_579254 = validateParameter(valid_579254, JBool, required = false,
                                 default = newJBool(true))
  if valid_579254 != nil:
    section.add "prettyPrint", valid_579254
  var valid_579255 = query.getOrDefault("oauth_token")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "oauth_token", valid_579255
  var valid_579256 = query.getOrDefault("alt")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = newJString("json"))
  if valid_579256 != nil:
    section.add "alt", valid_579256
  var valid_579257 = query.getOrDefault("userIp")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "userIp", valid_579257
  var valid_579258 = query.getOrDefault("quotaUser")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "quotaUser", valid_579258
  var valid_579259 = query.getOrDefault("fields")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "fields", valid_579259
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

proc call*(call_579261: Call_AdexchangebuyerPretargetingConfigPatch_579248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing pretargeting config. This method supports patch semantics.
  ## 
  let valid = call_579261.validator(path, query, header, formData, body)
  let scheme = call_579261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579261.url(scheme.get, call_579261.host, call_579261.base,
                         call_579261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579261, url, valid)

proc call*(call_579262: Call_AdexchangebuyerPretargetingConfigPatch_579248;
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
  var path_579263 = newJObject()
  var query_579264 = newJObject()
  var body_579265 = newJObject()
  add(query_579264, "key", newJString(key))
  add(query_579264, "prettyPrint", newJBool(prettyPrint))
  add(query_579264, "oauth_token", newJString(oauthToken))
  add(query_579264, "alt", newJString(alt))
  add(query_579264, "userIp", newJString(userIp))
  add(query_579264, "quotaUser", newJString(quotaUser))
  add(path_579263, "configId", newJString(configId))
  if body != nil:
    body_579265 = body
  add(path_579263, "accountId", newJString(accountId))
  add(query_579264, "fields", newJString(fields))
  result = call_579262.call(path_579263, query_579264, nil, nil, body_579265)

var adexchangebuyerPretargetingConfigPatch* = Call_AdexchangebuyerPretargetingConfigPatch_579248(
    name: "adexchangebuyerPretargetingConfigPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigPatch_579249,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigPatch_579250,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPretargetingConfigDelete_579232 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPretargetingConfigDelete_579234(protocol: Scheme;
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

proc validate_AdexchangebuyerPretargetingConfigDelete_579233(path: JsonNode;
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
  var valid_579235 = path.getOrDefault("configId")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "configId", valid_579235
  var valid_579236 = path.getOrDefault("accountId")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "accountId", valid_579236
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
  var valid_579237 = query.getOrDefault("key")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "key", valid_579237
  var valid_579238 = query.getOrDefault("prettyPrint")
  valid_579238 = validateParameter(valid_579238, JBool, required = false,
                                 default = newJBool(true))
  if valid_579238 != nil:
    section.add "prettyPrint", valid_579238
  var valid_579239 = query.getOrDefault("oauth_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "oauth_token", valid_579239
  var valid_579240 = query.getOrDefault("alt")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = newJString("json"))
  if valid_579240 != nil:
    section.add "alt", valid_579240
  var valid_579241 = query.getOrDefault("userIp")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "userIp", valid_579241
  var valid_579242 = query.getOrDefault("quotaUser")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "quotaUser", valid_579242
  var valid_579243 = query.getOrDefault("fields")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "fields", valid_579243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579244: Call_AdexchangebuyerPretargetingConfigDelete_579232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing pretargeting config.
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_AdexchangebuyerPretargetingConfigDelete_579232;
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
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "userIp", newJString(userIp))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(path_579246, "configId", newJString(configId))
  add(path_579246, "accountId", newJString(accountId))
  add(query_579247, "fields", newJString(fields))
  result = call_579245.call(path_579246, query_579247, nil, nil, nil)

var adexchangebuyerPretargetingConfigDelete* = Call_AdexchangebuyerPretargetingConfigDelete_579232(
    name: "adexchangebuyerPretargetingConfigDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/pretargetingconfigs/{accountId}/{configId}",
    validator: validate_AdexchangebuyerPretargetingConfigDelete_579233,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerPretargetingConfigDelete_579234,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579266 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579268(
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

proc validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579267(
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
  var valid_579269 = path.getOrDefault("privateAuctionId")
  valid_579269 = validateParameter(valid_579269, JString, required = true,
                                 default = nil)
  if valid_579269 != nil:
    section.add "privateAuctionId", valid_579269
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
  var valid_579270 = query.getOrDefault("key")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "key", valid_579270
  var valid_579271 = query.getOrDefault("prettyPrint")
  valid_579271 = validateParameter(valid_579271, JBool, required = false,
                                 default = newJBool(true))
  if valid_579271 != nil:
    section.add "prettyPrint", valid_579271
  var valid_579272 = query.getOrDefault("oauth_token")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "oauth_token", valid_579272
  var valid_579273 = query.getOrDefault("alt")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("json"))
  if valid_579273 != nil:
    section.add "alt", valid_579273
  var valid_579274 = query.getOrDefault("userIp")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "userIp", valid_579274
  var valid_579275 = query.getOrDefault("quotaUser")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "quotaUser", valid_579275
  var valid_579276 = query.getOrDefault("fields")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "fields", valid_579276
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

proc call*(call_579278: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a given private auction proposal
  ## 
  let valid = call_579278.validator(path, query, header, formData, body)
  let scheme = call_579278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579278.url(scheme.get, call_579278.host, call_579278.base,
                         call_579278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579278, url, valid)

proc call*(call_579279: Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579266;
          privateAuctionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerMarketplaceprivateauctionUpdateproposal
  ## Update a given private auction proposal
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   privateAuctionId: string (required)
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579280 = newJObject()
  var query_579281 = newJObject()
  var body_579282 = newJObject()
  add(query_579281, "key", newJString(key))
  add(query_579281, "prettyPrint", newJBool(prettyPrint))
  add(query_579281, "oauth_token", newJString(oauthToken))
  add(path_579280, "privateAuctionId", newJString(privateAuctionId))
  add(query_579281, "alt", newJString(alt))
  add(query_579281, "userIp", newJString(userIp))
  add(query_579281, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579282 = body
  add(query_579281, "fields", newJString(fields))
  result = call_579279.call(path_579280, query_579281, nil, nil, body_579282)

var adexchangebuyerMarketplaceprivateauctionUpdateproposal* = Call_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579266(
    name: "adexchangebuyerMarketplaceprivateauctionUpdateproposal",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/privateauction/{privateAuctionId}/updateproposal",
    validator: validate_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579267,
    base: "/adexchangebuyer/v1.4",
    url: url_AdexchangebuyerMarketplaceprivateauctionUpdateproposal_579268,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsSearch_579283 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProductsSearch_579285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProductsSearch_579284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the requested product.
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
  ##   pqlQuery: JString
  ##           : The pql query used to query for products.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579286 = query.getOrDefault("key")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "key", valid_579286
  var valid_579287 = query.getOrDefault("prettyPrint")
  valid_579287 = validateParameter(valid_579287, JBool, required = false,
                                 default = newJBool(true))
  if valid_579287 != nil:
    section.add "prettyPrint", valid_579287
  var valid_579288 = query.getOrDefault("oauth_token")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "oauth_token", valid_579288
  var valid_579289 = query.getOrDefault("alt")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = newJString("json"))
  if valid_579289 != nil:
    section.add "alt", valid_579289
  var valid_579290 = query.getOrDefault("userIp")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "userIp", valid_579290
  var valid_579291 = query.getOrDefault("quotaUser")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "quotaUser", valid_579291
  var valid_579292 = query.getOrDefault("pqlQuery")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "pqlQuery", valid_579292
  var valid_579293 = query.getOrDefault("fields")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "fields", valid_579293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579294: Call_AdexchangebuyerProductsSearch_579283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product.
  ## 
  let valid = call_579294.validator(path, query, header, formData, body)
  let scheme = call_579294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579294.url(scheme.get, call_579294.host, call_579294.base,
                         call_579294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579294, url, valid)

proc call*(call_579295: Call_AdexchangebuyerProductsSearch_579283;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pqlQuery: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerProductsSearch
  ## Gets the requested product.
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
  ##   pqlQuery: string
  ##           : The pql query used to query for products.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579296 = newJObject()
  add(query_579296, "key", newJString(key))
  add(query_579296, "prettyPrint", newJBool(prettyPrint))
  add(query_579296, "oauth_token", newJString(oauthToken))
  add(query_579296, "alt", newJString(alt))
  add(query_579296, "userIp", newJString(userIp))
  add(query_579296, "quotaUser", newJString(quotaUser))
  add(query_579296, "pqlQuery", newJString(pqlQuery))
  add(query_579296, "fields", newJString(fields))
  result = call_579295.call(nil, query_579296, nil, nil, nil)

var adexchangebuyerProductsSearch* = Call_AdexchangebuyerProductsSearch_579283(
    name: "adexchangebuyerProductsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/search",
    validator: validate_AdexchangebuyerProductsSearch_579284,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsSearch_579285,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProductsGet_579297 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProductsGet_579299(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProductsGet_579298(path: JsonNode; query: JsonNode;
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
  var valid_579300 = path.getOrDefault("productId")
  valid_579300 = validateParameter(valid_579300, JString, required = true,
                                 default = nil)
  if valid_579300 != nil:
    section.add "productId", valid_579300
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
  var valid_579301 = query.getOrDefault("key")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "key", valid_579301
  var valid_579302 = query.getOrDefault("prettyPrint")
  valid_579302 = validateParameter(valid_579302, JBool, required = false,
                                 default = newJBool(true))
  if valid_579302 != nil:
    section.add "prettyPrint", valid_579302
  var valid_579303 = query.getOrDefault("oauth_token")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "oauth_token", valid_579303
  var valid_579304 = query.getOrDefault("alt")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = newJString("json"))
  if valid_579304 != nil:
    section.add "alt", valid_579304
  var valid_579305 = query.getOrDefault("userIp")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "userIp", valid_579305
  var valid_579306 = query.getOrDefault("quotaUser")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "quotaUser", valid_579306
  var valid_579307 = query.getOrDefault("fields")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "fields", valid_579307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579308: Call_AdexchangebuyerProductsGet_579297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested product by id.
  ## 
  let valid = call_579308.validator(path, query, header, formData, body)
  let scheme = call_579308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579308.url(scheme.get, call_579308.host, call_579308.base,
                         call_579308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579308, url, valid)

proc call*(call_579309: Call_AdexchangebuyerProductsGet_579297; productId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangebuyerProductsGet
  ## Gets the requested product by id.
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
  ##   productId: string (required)
  ##            : The id for the product to get the head revision for.
  var path_579310 = newJObject()
  var query_579311 = newJObject()
  add(query_579311, "key", newJString(key))
  add(query_579311, "prettyPrint", newJBool(prettyPrint))
  add(query_579311, "oauth_token", newJString(oauthToken))
  add(query_579311, "alt", newJString(alt))
  add(query_579311, "userIp", newJString(userIp))
  add(query_579311, "quotaUser", newJString(quotaUser))
  add(query_579311, "fields", newJString(fields))
  add(path_579310, "productId", newJString(productId))
  result = call_579309.call(path_579310, query_579311, nil, nil, nil)

var adexchangebuyerProductsGet* = Call_AdexchangebuyerProductsGet_579297(
    name: "adexchangebuyerProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/products/{productId}",
    validator: validate_AdexchangebuyerProductsGet_579298,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProductsGet_579299,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsInsert_579312 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProposalsInsert_579314(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsInsert_579313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create the given list of proposals
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
  var valid_579315 = query.getOrDefault("key")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "key", valid_579315
  var valid_579316 = query.getOrDefault("prettyPrint")
  valid_579316 = validateParameter(valid_579316, JBool, required = false,
                                 default = newJBool(true))
  if valid_579316 != nil:
    section.add "prettyPrint", valid_579316
  var valid_579317 = query.getOrDefault("oauth_token")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "oauth_token", valid_579317
  var valid_579318 = query.getOrDefault("alt")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("json"))
  if valid_579318 != nil:
    section.add "alt", valid_579318
  var valid_579319 = query.getOrDefault("userIp")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "userIp", valid_579319
  var valid_579320 = query.getOrDefault("quotaUser")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "quotaUser", valid_579320
  var valid_579321 = query.getOrDefault("fields")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "fields", valid_579321
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

proc call*(call_579323: Call_AdexchangebuyerProposalsInsert_579312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create the given list of proposals
  ## 
  let valid = call_579323.validator(path, query, header, formData, body)
  let scheme = call_579323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579323.url(scheme.get, call_579323.host, call_579323.base,
                         call_579323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579323, url, valid)

proc call*(call_579324: Call_AdexchangebuyerProposalsInsert_579312;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerProposalsInsert
  ## Create the given list of proposals
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
  var query_579325 = newJObject()
  var body_579326 = newJObject()
  add(query_579325, "key", newJString(key))
  add(query_579325, "prettyPrint", newJBool(prettyPrint))
  add(query_579325, "oauth_token", newJString(oauthToken))
  add(query_579325, "alt", newJString(alt))
  add(query_579325, "userIp", newJString(userIp))
  add(query_579325, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579326 = body
  add(query_579325, "fields", newJString(fields))
  result = call_579324.call(nil, query_579325, nil, nil, body_579326)

var adexchangebuyerProposalsInsert* = Call_AdexchangebuyerProposalsInsert_579312(
    name: "adexchangebuyerProposalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/insert",
    validator: validate_AdexchangebuyerProposalsInsert_579313,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsInsert_579314,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSearch_579327 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProposalsSearch_579329(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangebuyerProposalsSearch_579328(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search for proposals using pql query
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
  ##   pqlQuery: JString
  ##           : Query string to retrieve specific proposals.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("alt")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("json"))
  if valid_579333 != nil:
    section.add "alt", valid_579333
  var valid_579334 = query.getOrDefault("userIp")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "userIp", valid_579334
  var valid_579335 = query.getOrDefault("quotaUser")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "quotaUser", valid_579335
  var valid_579336 = query.getOrDefault("pqlQuery")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "pqlQuery", valid_579336
  var valid_579337 = query.getOrDefault("fields")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "fields", valid_579337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579338: Call_AdexchangebuyerProposalsSearch_579327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for proposals using pql query
  ## 
  let valid = call_579338.validator(path, query, header, formData, body)
  let scheme = call_579338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579338.url(scheme.get, call_579338.host, call_579338.base,
                         call_579338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579338, url, valid)

proc call*(call_579339: Call_AdexchangebuyerProposalsSearch_579327;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pqlQuery: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerProposalsSearch
  ## Search for proposals using pql query
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
  ##   pqlQuery: string
  ##           : Query string to retrieve specific proposals.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579340 = newJObject()
  add(query_579340, "key", newJString(key))
  add(query_579340, "prettyPrint", newJBool(prettyPrint))
  add(query_579340, "oauth_token", newJString(oauthToken))
  add(query_579340, "alt", newJString(alt))
  add(query_579340, "userIp", newJString(userIp))
  add(query_579340, "quotaUser", newJString(quotaUser))
  add(query_579340, "pqlQuery", newJString(pqlQuery))
  add(query_579340, "fields", newJString(fields))
  result = call_579339.call(nil, query_579340, nil, nil, nil)

var adexchangebuyerProposalsSearch* = Call_AdexchangebuyerProposalsSearch_579327(
    name: "adexchangebuyerProposalsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/search",
    validator: validate_AdexchangebuyerProposalsSearch_579328,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSearch_579329,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsGet_579341 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProposalsGet_579343(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProposalsGet_579342(path: JsonNode; query: JsonNode;
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
  var valid_579344 = path.getOrDefault("proposalId")
  valid_579344 = validateParameter(valid_579344, JString, required = true,
                                 default = nil)
  if valid_579344 != nil:
    section.add "proposalId", valid_579344
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
  var valid_579345 = query.getOrDefault("key")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "key", valid_579345
  var valid_579346 = query.getOrDefault("prettyPrint")
  valid_579346 = validateParameter(valid_579346, JBool, required = false,
                                 default = newJBool(true))
  if valid_579346 != nil:
    section.add "prettyPrint", valid_579346
  var valid_579347 = query.getOrDefault("oauth_token")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "oauth_token", valid_579347
  var valid_579348 = query.getOrDefault("alt")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = newJString("json"))
  if valid_579348 != nil:
    section.add "alt", valid_579348
  var valid_579349 = query.getOrDefault("userIp")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "userIp", valid_579349
  var valid_579350 = query.getOrDefault("quotaUser")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "quotaUser", valid_579350
  var valid_579351 = query.getOrDefault("fields")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "fields", valid_579351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579352: Call_AdexchangebuyerProposalsGet_579341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a proposal given its id
  ## 
  let valid = call_579352.validator(path, query, header, formData, body)
  let scheme = call_579352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579352.url(scheme.get, call_579352.host, call_579352.base,
                         call_579352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579352, url, valid)

proc call*(call_579353: Call_AdexchangebuyerProposalsGet_579341;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerProposalsGet
  ## Get a proposal given its id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : Id of the proposal to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579354 = newJObject()
  var query_579355 = newJObject()
  add(query_579355, "key", newJString(key))
  add(query_579355, "prettyPrint", newJBool(prettyPrint))
  add(query_579355, "oauth_token", newJString(oauthToken))
  add(path_579354, "proposalId", newJString(proposalId))
  add(query_579355, "alt", newJString(alt))
  add(query_579355, "userIp", newJString(userIp))
  add(query_579355, "quotaUser", newJString(quotaUser))
  add(query_579355, "fields", newJString(fields))
  result = call_579353.call(path_579354, query_579355, nil, nil, nil)

var adexchangebuyerProposalsGet* = Call_AdexchangebuyerProposalsGet_579341(
    name: "adexchangebuyerProposalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}",
    validator: validate_AdexchangebuyerProposalsGet_579342,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsGet_579343,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsList_579356 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerMarketplacedealsList_579358(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerMarketplacedealsList_579357(path: JsonNode;
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
  var valid_579359 = path.getOrDefault("proposalId")
  valid_579359 = validateParameter(valid_579359, JString, required = true,
                                 default = nil)
  if valid_579359 != nil:
    section.add "proposalId", valid_579359
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
  ##   pqlQuery: JString
  ##           : Query string to retrieve specific deals.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579360 = query.getOrDefault("key")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "key", valid_579360
  var valid_579361 = query.getOrDefault("prettyPrint")
  valid_579361 = validateParameter(valid_579361, JBool, required = false,
                                 default = newJBool(true))
  if valid_579361 != nil:
    section.add "prettyPrint", valid_579361
  var valid_579362 = query.getOrDefault("oauth_token")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "oauth_token", valid_579362
  var valid_579363 = query.getOrDefault("alt")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = newJString("json"))
  if valid_579363 != nil:
    section.add "alt", valid_579363
  var valid_579364 = query.getOrDefault("userIp")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "userIp", valid_579364
  var valid_579365 = query.getOrDefault("quotaUser")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "quotaUser", valid_579365
  var valid_579366 = query.getOrDefault("pqlQuery")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "pqlQuery", valid_579366
  var valid_579367 = query.getOrDefault("fields")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "fields", valid_579367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579368: Call_AdexchangebuyerMarketplacedealsList_579356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the deals for a given proposal
  ## 
  let valid = call_579368.validator(path, query, header, formData, body)
  let scheme = call_579368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579368.url(scheme.get, call_579368.host, call_579368.base,
                         call_579368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579368, url, valid)

proc call*(call_579369: Call_AdexchangebuyerMarketplacedealsList_579356;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pqlQuery: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerMarketplacedealsList
  ## List all the deals for a given proposal
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposalId to get deals for. To search across all proposals specify order_id = '-' as part of the URL.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pqlQuery: string
  ##           : Query string to retrieve specific deals.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579370 = newJObject()
  var query_579371 = newJObject()
  add(query_579371, "key", newJString(key))
  add(query_579371, "prettyPrint", newJBool(prettyPrint))
  add(query_579371, "oauth_token", newJString(oauthToken))
  add(path_579370, "proposalId", newJString(proposalId))
  add(query_579371, "alt", newJString(alt))
  add(query_579371, "userIp", newJString(userIp))
  add(query_579371, "quotaUser", newJString(quotaUser))
  add(query_579371, "pqlQuery", newJString(pqlQuery))
  add(query_579371, "fields", newJString(fields))
  result = call_579369.call(path_579370, query_579371, nil, nil, nil)

var adexchangebuyerMarketplacedealsList* = Call_AdexchangebuyerMarketplacedealsList_579356(
    name: "adexchangebuyerMarketplacedealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals",
    validator: validate_AdexchangebuyerMarketplacedealsList_579357,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsList_579358,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsDelete_579372 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerMarketplacedealsDelete_579374(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacedealsDelete_579373(path: JsonNode;
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
  var valid_579375 = path.getOrDefault("proposalId")
  valid_579375 = validateParameter(valid_579375, JString, required = true,
                                 default = nil)
  if valid_579375 != nil:
    section.add "proposalId", valid_579375
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
  var valid_579376 = query.getOrDefault("key")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "key", valid_579376
  var valid_579377 = query.getOrDefault("prettyPrint")
  valid_579377 = validateParameter(valid_579377, JBool, required = false,
                                 default = newJBool(true))
  if valid_579377 != nil:
    section.add "prettyPrint", valid_579377
  var valid_579378 = query.getOrDefault("oauth_token")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "oauth_token", valid_579378
  var valid_579379 = query.getOrDefault("alt")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = newJString("json"))
  if valid_579379 != nil:
    section.add "alt", valid_579379
  var valid_579380 = query.getOrDefault("userIp")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "userIp", valid_579380
  var valid_579381 = query.getOrDefault("quotaUser")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "quotaUser", valid_579381
  var valid_579382 = query.getOrDefault("fields")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "fields", valid_579382
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

proc call*(call_579384: Call_AdexchangebuyerMarketplacedealsDelete_579372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified deals from the proposal
  ## 
  let valid = call_579384.validator(path, query, header, formData, body)
  let scheme = call_579384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579384.url(scheme.get, call_579384.host, call_579384.base,
                         call_579384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579384, url, valid)

proc call*(call_579385: Call_AdexchangebuyerMarketplacedealsDelete_579372;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerMarketplacedealsDelete
  ## Delete the specified deals from the proposal
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposalId to delete deals from.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579386 = newJObject()
  var query_579387 = newJObject()
  var body_579388 = newJObject()
  add(query_579387, "key", newJString(key))
  add(query_579387, "prettyPrint", newJBool(prettyPrint))
  add(query_579387, "oauth_token", newJString(oauthToken))
  add(path_579386, "proposalId", newJString(proposalId))
  add(query_579387, "alt", newJString(alt))
  add(query_579387, "userIp", newJString(userIp))
  add(query_579387, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579388 = body
  add(query_579387, "fields", newJString(fields))
  result = call_579385.call(path_579386, query_579387, nil, nil, body_579388)

var adexchangebuyerMarketplacedealsDelete* = Call_AdexchangebuyerMarketplacedealsDelete_579372(
    name: "adexchangebuyerMarketplacedealsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/delete",
    validator: validate_AdexchangebuyerMarketplacedealsDelete_579373,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsDelete_579374,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsInsert_579389 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerMarketplacedealsInsert_579391(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacedealsInsert_579390(path: JsonNode;
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
  var valid_579392 = path.getOrDefault("proposalId")
  valid_579392 = validateParameter(valid_579392, JString, required = true,
                                 default = nil)
  if valid_579392 != nil:
    section.add "proposalId", valid_579392
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
  var valid_579393 = query.getOrDefault("key")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "key", valid_579393
  var valid_579394 = query.getOrDefault("prettyPrint")
  valid_579394 = validateParameter(valid_579394, JBool, required = false,
                                 default = newJBool(true))
  if valid_579394 != nil:
    section.add "prettyPrint", valid_579394
  var valid_579395 = query.getOrDefault("oauth_token")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "oauth_token", valid_579395
  var valid_579396 = query.getOrDefault("alt")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = newJString("json"))
  if valid_579396 != nil:
    section.add "alt", valid_579396
  var valid_579397 = query.getOrDefault("userIp")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "userIp", valid_579397
  var valid_579398 = query.getOrDefault("quotaUser")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "quotaUser", valid_579398
  var valid_579399 = query.getOrDefault("fields")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "fields", valid_579399
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

proc call*(call_579401: Call_AdexchangebuyerMarketplacedealsInsert_579389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add new deals for the specified proposal
  ## 
  let valid = call_579401.validator(path, query, header, formData, body)
  let scheme = call_579401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579401.url(scheme.get, call_579401.host, call_579401.base,
                         call_579401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579401, url, valid)

proc call*(call_579402: Call_AdexchangebuyerMarketplacedealsInsert_579389;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerMarketplacedealsInsert
  ## Add new deals for the specified proposal
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : proposalId for which deals need to be added.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579403 = newJObject()
  var query_579404 = newJObject()
  var body_579405 = newJObject()
  add(query_579404, "key", newJString(key))
  add(query_579404, "prettyPrint", newJBool(prettyPrint))
  add(query_579404, "oauth_token", newJString(oauthToken))
  add(path_579403, "proposalId", newJString(proposalId))
  add(query_579404, "alt", newJString(alt))
  add(query_579404, "userIp", newJString(userIp))
  add(query_579404, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579405 = body
  add(query_579404, "fields", newJString(fields))
  result = call_579402.call(path_579403, query_579404, nil, nil, body_579405)

var adexchangebuyerMarketplacedealsInsert* = Call_AdexchangebuyerMarketplacedealsInsert_579389(
    name: "adexchangebuyerMarketplacedealsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/insert",
    validator: validate_AdexchangebuyerMarketplacedealsInsert_579390,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsInsert_579391,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacedealsUpdate_579406 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerMarketplacedealsUpdate_579408(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacedealsUpdate_579407(path: JsonNode;
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
  var valid_579409 = path.getOrDefault("proposalId")
  valid_579409 = validateParameter(valid_579409, JString, required = true,
                                 default = nil)
  if valid_579409 != nil:
    section.add "proposalId", valid_579409
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
  var valid_579410 = query.getOrDefault("key")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "key", valid_579410
  var valid_579411 = query.getOrDefault("prettyPrint")
  valid_579411 = validateParameter(valid_579411, JBool, required = false,
                                 default = newJBool(true))
  if valid_579411 != nil:
    section.add "prettyPrint", valid_579411
  var valid_579412 = query.getOrDefault("oauth_token")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "oauth_token", valid_579412
  var valid_579413 = query.getOrDefault("alt")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = newJString("json"))
  if valid_579413 != nil:
    section.add "alt", valid_579413
  var valid_579414 = query.getOrDefault("userIp")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "userIp", valid_579414
  var valid_579415 = query.getOrDefault("quotaUser")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "quotaUser", valid_579415
  var valid_579416 = query.getOrDefault("fields")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "fields", valid_579416
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

proc call*(call_579418: Call_AdexchangebuyerMarketplacedealsUpdate_579406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces all the deals in the proposal with the passed in deals
  ## 
  let valid = call_579418.validator(path, query, header, formData, body)
  let scheme = call_579418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579418.url(scheme.get, call_579418.host, call_579418.base,
                         call_579418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579418, url, valid)

proc call*(call_579419: Call_AdexchangebuyerMarketplacedealsUpdate_579406;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerMarketplacedealsUpdate
  ## Replaces all the deals in the proposal with the passed in deals
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposalId to edit deals on.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579420 = newJObject()
  var query_579421 = newJObject()
  var body_579422 = newJObject()
  add(query_579421, "key", newJString(key))
  add(query_579421, "prettyPrint", newJBool(prettyPrint))
  add(query_579421, "oauth_token", newJString(oauthToken))
  add(path_579420, "proposalId", newJString(proposalId))
  add(query_579421, "alt", newJString(alt))
  add(query_579421, "userIp", newJString(userIp))
  add(query_579421, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579422 = body
  add(query_579421, "fields", newJString(fields))
  result = call_579419.call(path_579420, query_579421, nil, nil, body_579422)

var adexchangebuyerMarketplacedealsUpdate* = Call_AdexchangebuyerMarketplacedealsUpdate_579406(
    name: "adexchangebuyerMarketplacedealsUpdate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/deals/update",
    validator: validate_AdexchangebuyerMarketplacedealsUpdate_579407,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacedealsUpdate_579408,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesList_579423 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerMarketplacenotesList_579425(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerMarketplacenotesList_579424(path: JsonNode;
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
  var valid_579426 = path.getOrDefault("proposalId")
  valid_579426 = validateParameter(valid_579426, JString, required = true,
                                 default = nil)
  if valid_579426 != nil:
    section.add "proposalId", valid_579426
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
  ##   pqlQuery: JString
  ##           : Query string to retrieve specific notes. To search the text contents of notes, please use syntax like "WHERE note.note = "foo" or "WHERE note.note LIKE "%bar%"
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579427 = query.getOrDefault("key")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "key", valid_579427
  var valid_579428 = query.getOrDefault("prettyPrint")
  valid_579428 = validateParameter(valid_579428, JBool, required = false,
                                 default = newJBool(true))
  if valid_579428 != nil:
    section.add "prettyPrint", valid_579428
  var valid_579429 = query.getOrDefault("oauth_token")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "oauth_token", valid_579429
  var valid_579430 = query.getOrDefault("alt")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = newJString("json"))
  if valid_579430 != nil:
    section.add "alt", valid_579430
  var valid_579431 = query.getOrDefault("userIp")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "userIp", valid_579431
  var valid_579432 = query.getOrDefault("quotaUser")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "quotaUser", valid_579432
  var valid_579433 = query.getOrDefault("pqlQuery")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = nil)
  if valid_579433 != nil:
    section.add "pqlQuery", valid_579433
  var valid_579434 = query.getOrDefault("fields")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "fields", valid_579434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579435: Call_AdexchangebuyerMarketplacenotesList_579423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the notes associated with a proposal
  ## 
  let valid = call_579435.validator(path, query, header, formData, body)
  let scheme = call_579435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579435.url(scheme.get, call_579435.host, call_579435.base,
                         call_579435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579435, url, valid)

proc call*(call_579436: Call_AdexchangebuyerMarketplacenotesList_579423;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pqlQuery: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerMarketplacenotesList
  ## Get all the notes associated with a proposal
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposalId to get notes for. To search across all proposals specify order_id = '-' as part of the URL.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pqlQuery: string
  ##           : Query string to retrieve specific notes. To search the text contents of notes, please use syntax like "WHERE note.note = "foo" or "WHERE note.note LIKE "%bar%"
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579437 = newJObject()
  var query_579438 = newJObject()
  add(query_579438, "key", newJString(key))
  add(query_579438, "prettyPrint", newJBool(prettyPrint))
  add(query_579438, "oauth_token", newJString(oauthToken))
  add(path_579437, "proposalId", newJString(proposalId))
  add(query_579438, "alt", newJString(alt))
  add(query_579438, "userIp", newJString(userIp))
  add(query_579438, "quotaUser", newJString(quotaUser))
  add(query_579438, "pqlQuery", newJString(pqlQuery))
  add(query_579438, "fields", newJString(fields))
  result = call_579436.call(path_579437, query_579438, nil, nil, nil)

var adexchangebuyerMarketplacenotesList* = Call_AdexchangebuyerMarketplacenotesList_579423(
    name: "adexchangebuyerMarketplacenotesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes",
    validator: validate_AdexchangebuyerMarketplacenotesList_579424,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesList_579425,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerMarketplacenotesInsert_579439 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerMarketplacenotesInsert_579441(protocol: Scheme;
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

proc validate_AdexchangebuyerMarketplacenotesInsert_579440(path: JsonNode;
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
  var valid_579442 = path.getOrDefault("proposalId")
  valid_579442 = validateParameter(valid_579442, JString, required = true,
                                 default = nil)
  if valid_579442 != nil:
    section.add "proposalId", valid_579442
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
  var valid_579443 = query.getOrDefault("key")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "key", valid_579443
  var valid_579444 = query.getOrDefault("prettyPrint")
  valid_579444 = validateParameter(valid_579444, JBool, required = false,
                                 default = newJBool(true))
  if valid_579444 != nil:
    section.add "prettyPrint", valid_579444
  var valid_579445 = query.getOrDefault("oauth_token")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "oauth_token", valid_579445
  var valid_579446 = query.getOrDefault("alt")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = newJString("json"))
  if valid_579446 != nil:
    section.add "alt", valid_579446
  var valid_579447 = query.getOrDefault("userIp")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "userIp", valid_579447
  var valid_579448 = query.getOrDefault("quotaUser")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "quotaUser", valid_579448
  var valid_579449 = query.getOrDefault("fields")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "fields", valid_579449
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

proc call*(call_579451: Call_AdexchangebuyerMarketplacenotesInsert_579439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add notes to the proposal
  ## 
  let valid = call_579451.validator(path, query, header, formData, body)
  let scheme = call_579451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579451.url(scheme.get, call_579451.host, call_579451.base,
                         call_579451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579451, url, valid)

proc call*(call_579452: Call_AdexchangebuyerMarketplacenotesInsert_579439;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerMarketplacenotesInsert
  ## Add notes to the proposal
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposalId to add notes for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579453 = newJObject()
  var query_579454 = newJObject()
  var body_579455 = newJObject()
  add(query_579454, "key", newJString(key))
  add(query_579454, "prettyPrint", newJBool(prettyPrint))
  add(query_579454, "oauth_token", newJString(oauthToken))
  add(path_579453, "proposalId", newJString(proposalId))
  add(query_579454, "alt", newJString(alt))
  add(query_579454, "userIp", newJString(userIp))
  add(query_579454, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579455 = body
  add(query_579454, "fields", newJString(fields))
  result = call_579452.call(path_579453, query_579454, nil, nil, body_579455)

var adexchangebuyerMarketplacenotesInsert* = Call_AdexchangebuyerMarketplacenotesInsert_579439(
    name: "adexchangebuyerMarketplacenotesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/notes/insert",
    validator: validate_AdexchangebuyerMarketplacenotesInsert_579440,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerMarketplacenotesInsert_579441,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsSetupcomplete_579456 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProposalsSetupcomplete_579458(protocol: Scheme;
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

proc validate_AdexchangebuyerProposalsSetupcomplete_579457(path: JsonNode;
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
  var valid_579459 = path.getOrDefault("proposalId")
  valid_579459 = validateParameter(valid_579459, JString, required = true,
                                 default = nil)
  if valid_579459 != nil:
    section.add "proposalId", valid_579459
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
  var valid_579460 = query.getOrDefault("key")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "key", valid_579460
  var valid_579461 = query.getOrDefault("prettyPrint")
  valid_579461 = validateParameter(valid_579461, JBool, required = false,
                                 default = newJBool(true))
  if valid_579461 != nil:
    section.add "prettyPrint", valid_579461
  var valid_579462 = query.getOrDefault("oauth_token")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "oauth_token", valid_579462
  var valid_579463 = query.getOrDefault("alt")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = newJString("json"))
  if valid_579463 != nil:
    section.add "alt", valid_579463
  var valid_579464 = query.getOrDefault("userIp")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "userIp", valid_579464
  var valid_579465 = query.getOrDefault("quotaUser")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "quotaUser", valid_579465
  var valid_579466 = query.getOrDefault("fields")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "fields", valid_579466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579467: Call_AdexchangebuyerProposalsSetupcomplete_579456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the given proposal to indicate that setup has been completed.
  ## 
  let valid = call_579467.validator(path, query, header, formData, body)
  let scheme = call_579467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579467.url(scheme.get, call_579467.host, call_579467.base,
                         call_579467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579467, url, valid)

proc call*(call_579468: Call_AdexchangebuyerProposalsSetupcomplete_579456;
          proposalId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangebuyerProposalsSetupcomplete
  ## Update the given proposal to indicate that setup has been completed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposal id for which the setup is complete
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579469 = newJObject()
  var query_579470 = newJObject()
  add(query_579470, "key", newJString(key))
  add(query_579470, "prettyPrint", newJBool(prettyPrint))
  add(query_579470, "oauth_token", newJString(oauthToken))
  add(path_579469, "proposalId", newJString(proposalId))
  add(query_579470, "alt", newJString(alt))
  add(query_579470, "userIp", newJString(userIp))
  add(query_579470, "quotaUser", newJString(quotaUser))
  add(query_579470, "fields", newJString(fields))
  result = call_579468.call(path_579469, query_579470, nil, nil, nil)

var adexchangebuyerProposalsSetupcomplete* = Call_AdexchangebuyerProposalsSetupcomplete_579456(
    name: "adexchangebuyerProposalsSetupcomplete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/proposals/{proposalId}/setupcomplete",
    validator: validate_AdexchangebuyerProposalsSetupcomplete_579457,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsSetupcomplete_579458,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsUpdate_579471 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProposalsUpdate_579473(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProposalsUpdate_579472(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the given proposal
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposal id to update.
  ##   updateAction: JString (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   revisionNumber: JString (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_579474 = path.getOrDefault("proposalId")
  valid_579474 = validateParameter(valid_579474, JString, required = true,
                                 default = nil)
  if valid_579474 != nil:
    section.add "proposalId", valid_579474
  var valid_579475 = path.getOrDefault("updateAction")
  valid_579475 = validateParameter(valid_579475, JString, required = true,
                                 default = newJString("accept"))
  if valid_579475 != nil:
    section.add "updateAction", valid_579475
  var valid_579476 = path.getOrDefault("revisionNumber")
  valid_579476 = validateParameter(valid_579476, JString, required = true,
                                 default = nil)
  if valid_579476 != nil:
    section.add "revisionNumber", valid_579476
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
  var valid_579477 = query.getOrDefault("key")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "key", valid_579477
  var valid_579478 = query.getOrDefault("prettyPrint")
  valid_579478 = validateParameter(valid_579478, JBool, required = false,
                                 default = newJBool(true))
  if valid_579478 != nil:
    section.add "prettyPrint", valid_579478
  var valid_579479 = query.getOrDefault("oauth_token")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "oauth_token", valid_579479
  var valid_579480 = query.getOrDefault("alt")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = newJString("json"))
  if valid_579480 != nil:
    section.add "alt", valid_579480
  var valid_579481 = query.getOrDefault("userIp")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "userIp", valid_579481
  var valid_579482 = query.getOrDefault("quotaUser")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "quotaUser", valid_579482
  var valid_579483 = query.getOrDefault("fields")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "fields", valid_579483
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

proc call*(call_579485: Call_AdexchangebuyerProposalsUpdate_579471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal
  ## 
  let valid = call_579485.validator(path, query, header, formData, body)
  let scheme = call_579485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579485.url(scheme.get, call_579485.host, call_579485.base,
                         call_579485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579485, url, valid)

proc call*(call_579486: Call_AdexchangebuyerProposalsUpdate_579471;
          proposalId: string; revisionNumber: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; updateAction: string = "accept"; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerProposalsUpdate
  ## Update the given proposal
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposal id to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   updateAction: string (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   revisionNumber: string (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579487 = newJObject()
  var query_579488 = newJObject()
  var body_579489 = newJObject()
  add(query_579488, "key", newJString(key))
  add(query_579488, "prettyPrint", newJBool(prettyPrint))
  add(query_579488, "oauth_token", newJString(oauthToken))
  add(path_579487, "proposalId", newJString(proposalId))
  add(query_579488, "alt", newJString(alt))
  add(query_579488, "userIp", newJString(userIp))
  add(path_579487, "updateAction", newJString(updateAction))
  add(query_579488, "quotaUser", newJString(quotaUser))
  add(path_579487, "revisionNumber", newJString(revisionNumber))
  if body != nil:
    body_579489 = body
  add(query_579488, "fields", newJString(fields))
  result = call_579486.call(path_579487, query_579488, nil, nil, body_579489)

var adexchangebuyerProposalsUpdate* = Call_AdexchangebuyerProposalsUpdate_579471(
    name: "adexchangebuyerProposalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsUpdate_579472,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsUpdate_579473,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerProposalsPatch_579490 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerProposalsPatch_579492(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerProposalsPatch_579491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the given proposal. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proposalId: JString (required)
  ##             : The proposal id to update.
  ##   updateAction: JString (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   revisionNumber: JString (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `proposalId` field"
  var valid_579493 = path.getOrDefault("proposalId")
  valid_579493 = validateParameter(valid_579493, JString, required = true,
                                 default = nil)
  if valid_579493 != nil:
    section.add "proposalId", valid_579493
  var valid_579494 = path.getOrDefault("updateAction")
  valid_579494 = validateParameter(valid_579494, JString, required = true,
                                 default = newJString("accept"))
  if valid_579494 != nil:
    section.add "updateAction", valid_579494
  var valid_579495 = path.getOrDefault("revisionNumber")
  valid_579495 = validateParameter(valid_579495, JString, required = true,
                                 default = nil)
  if valid_579495 != nil:
    section.add "revisionNumber", valid_579495
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
  var valid_579496 = query.getOrDefault("key")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "key", valid_579496
  var valid_579497 = query.getOrDefault("prettyPrint")
  valid_579497 = validateParameter(valid_579497, JBool, required = false,
                                 default = newJBool(true))
  if valid_579497 != nil:
    section.add "prettyPrint", valid_579497
  var valid_579498 = query.getOrDefault("oauth_token")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "oauth_token", valid_579498
  var valid_579499 = query.getOrDefault("alt")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = newJString("json"))
  if valid_579499 != nil:
    section.add "alt", valid_579499
  var valid_579500 = query.getOrDefault("userIp")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "userIp", valid_579500
  var valid_579501 = query.getOrDefault("quotaUser")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "quotaUser", valid_579501
  var valid_579502 = query.getOrDefault("fields")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "fields", valid_579502
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

proc call*(call_579504: Call_AdexchangebuyerProposalsPatch_579490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the given proposal. This method supports patch semantics.
  ## 
  let valid = call_579504.validator(path, query, header, formData, body)
  let scheme = call_579504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579504.url(scheme.get, call_579504.host, call_579504.base,
                         call_579504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579504, url, valid)

proc call*(call_579505: Call_AdexchangebuyerProposalsPatch_579490;
          proposalId: string; revisionNumber: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; updateAction: string = "accept"; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## adexchangebuyerProposalsPatch
  ## Update the given proposal. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   proposalId: string (required)
  ##             : The proposal id to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   updateAction: string (required)
  ##               : The proposed action to take on the proposal. This field is required and it must be set when updating a proposal.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   revisionNumber: string (required)
  ##                 : The last known revision number to update. If the head revision in the marketplace database has since changed, an error will be thrown. The caller should then fetch the latest proposal at head revision and retry the update at that revision.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579506 = newJObject()
  var query_579507 = newJObject()
  var body_579508 = newJObject()
  add(query_579507, "key", newJString(key))
  add(query_579507, "prettyPrint", newJBool(prettyPrint))
  add(query_579507, "oauth_token", newJString(oauthToken))
  add(path_579506, "proposalId", newJString(proposalId))
  add(query_579507, "alt", newJString(alt))
  add(query_579507, "userIp", newJString(userIp))
  add(path_579506, "updateAction", newJString(updateAction))
  add(query_579507, "quotaUser", newJString(quotaUser))
  add(path_579506, "revisionNumber", newJString(revisionNumber))
  if body != nil:
    body_579508 = body
  add(query_579507, "fields", newJString(fields))
  result = call_579505.call(path_579506, query_579507, nil, nil, body_579508)

var adexchangebuyerProposalsPatch* = Call_AdexchangebuyerProposalsPatch_579490(
    name: "adexchangebuyerProposalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/proposals/{proposalId}/{revisionNumber}/{updateAction}",
    validator: validate_AdexchangebuyerProposalsPatch_579491,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerProposalsPatch_579492,
    schemes: {Scheme.Https})
type
  Call_AdexchangebuyerPubprofilesList_579509 = ref object of OpenApiRestCall_578364
proc url_AdexchangebuyerPubprofilesList_579511(protocol: Scheme; host: string;
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

proc validate_AdexchangebuyerPubprofilesList_579510(path: JsonNode;
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
  var valid_579512 = path.getOrDefault("accountId")
  valid_579512 = validateParameter(valid_579512, JInt, required = true, default = nil)
  if valid_579512 != nil:
    section.add "accountId", valid_579512
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
  var valid_579513 = query.getOrDefault("key")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "key", valid_579513
  var valid_579514 = query.getOrDefault("prettyPrint")
  valid_579514 = validateParameter(valid_579514, JBool, required = false,
                                 default = newJBool(true))
  if valid_579514 != nil:
    section.add "prettyPrint", valid_579514
  var valid_579515 = query.getOrDefault("oauth_token")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "oauth_token", valid_579515
  var valid_579516 = query.getOrDefault("alt")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = newJString("json"))
  if valid_579516 != nil:
    section.add "alt", valid_579516
  var valid_579517 = query.getOrDefault("userIp")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = nil)
  if valid_579517 != nil:
    section.add "userIp", valid_579517
  var valid_579518 = query.getOrDefault("quotaUser")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "quotaUser", valid_579518
  var valid_579519 = query.getOrDefault("fields")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "fields", valid_579519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579520: Call_AdexchangebuyerPubprofilesList_579509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the requested publisher profile(s) by publisher accountId.
  ## 
  let valid = call_579520.validator(path, query, header, formData, body)
  let scheme = call_579520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579520.url(scheme.get, call_579520.host, call_579520.base,
                         call_579520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579520, url, valid)

proc call*(call_579521: Call_AdexchangebuyerPubprofilesList_579509; accountId: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangebuyerPubprofilesList
  ## Gets the requested publisher profile(s) by publisher accountId.
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
  ##            : The accountId of the publisher to get profiles for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579522 = newJObject()
  var query_579523 = newJObject()
  add(query_579523, "key", newJString(key))
  add(query_579523, "prettyPrint", newJBool(prettyPrint))
  add(query_579523, "oauth_token", newJString(oauthToken))
  add(query_579523, "alt", newJString(alt))
  add(query_579523, "userIp", newJString(userIp))
  add(query_579523, "quotaUser", newJString(quotaUser))
  add(path_579522, "accountId", newJInt(accountId))
  add(query_579523, "fields", newJString(fields))
  result = call_579521.call(path_579522, query_579523, nil, nil, nil)

var adexchangebuyerPubprofilesList* = Call_AdexchangebuyerPubprofilesList_579509(
    name: "adexchangebuyerPubprofilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/publisher/{accountId}/profiles",
    validator: validate_AdexchangebuyerPubprofilesList_579510,
    base: "/adexchangebuyer/v1.4", url: url_AdexchangebuyerPubprofilesList_579511,
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
