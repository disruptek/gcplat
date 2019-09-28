
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: URL Shortener
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Lets you create, inspect, and manage goo.gl short URLs
## 
## https://developers.google.com/url-shortener/v1/getting_started
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "urlshortener"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UrlshortenerUrlInsert_579946 = ref object of OpenApiRestCall_579408
proc url_UrlshortenerUrlInsert_579948(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlInsert_579947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new short URL.
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
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
  var valid_579950 = query.getOrDefault("quotaUser")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "quotaUser", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("userIp")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "userIp", valid_579953
  var valid_579954 = query.getOrDefault("key")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "key", valid_579954
  var valid_579955 = query.getOrDefault("prettyPrint")
  valid_579955 = validateParameter(valid_579955, JBool, required = false,
                                 default = newJBool(true))
  if valid_579955 != nil:
    section.add "prettyPrint", valid_579955
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

proc call*(call_579957: Call_UrlshortenerUrlInsert_579946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new short URL.
  ## 
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_UrlshortenerUrlInsert_579946; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## urlshortenerUrlInsert
  ## Creates a new short URL.
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
  var query_579959 = newJObject()
  var body_579960 = newJObject()
  add(query_579959, "fields", newJString(fields))
  add(query_579959, "quotaUser", newJString(quotaUser))
  add(query_579959, "alt", newJString(alt))
  add(query_579959, "oauth_token", newJString(oauthToken))
  add(query_579959, "userIp", newJString(userIp))
  add(query_579959, "key", newJString(key))
  if body != nil:
    body_579960 = body
  add(query_579959, "prettyPrint", newJBool(prettyPrint))
  result = call_579958.call(nil, query_579959, nil, nil, body_579960)

var urlshortenerUrlInsert* = Call_UrlshortenerUrlInsert_579946(
    name: "urlshortenerUrlInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/url",
    validator: validate_UrlshortenerUrlInsert_579947, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlInsert_579948, schemes: {Scheme.Https})
type
  Call_UrlshortenerUrlGet_579676 = ref object of OpenApiRestCall_579408
proc url_UrlshortenerUrlGet_579678(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlGet_579677(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Expands a short URL or gets creation time and analytics.
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
  ##   shortUrl: JString (required)
  ##           : The short URL, including the protocol.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Additional information to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("oauth_token")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "oauth_token", valid_579806
  assert query != nil,
        "query argument is necessary due to required `shortUrl` field"
  var valid_579807 = query.getOrDefault("shortUrl")
  valid_579807 = validateParameter(valid_579807, JString, required = true,
                                 default = nil)
  if valid_579807 != nil:
    section.add "shortUrl", valid_579807
  var valid_579808 = query.getOrDefault("userIp")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "userIp", valid_579808
  var valid_579809 = query.getOrDefault("key")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "key", valid_579809
  var valid_579810 = query.getOrDefault("projection")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = newJString("ANALYTICS_CLICKS"))
  if valid_579810 != nil:
    section.add "projection", valid_579810
  var valid_579811 = query.getOrDefault("prettyPrint")
  valid_579811 = validateParameter(valid_579811, JBool, required = false,
                                 default = newJBool(true))
  if valid_579811 != nil:
    section.add "prettyPrint", valid_579811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579834: Call_UrlshortenerUrlGet_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expands a short URL or gets creation time and analytics.
  ## 
  let valid = call_579834.validator(path, query, header, formData, body)
  let scheme = call_579834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579834.url(scheme.get, call_579834.host, call_579834.base,
                         call_579834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579834, url, valid)

proc call*(call_579905: Call_UrlshortenerUrlGet_579676; shortUrl: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "ANALYTICS_CLICKS"; prettyPrint: bool = true): Recallable =
  ## urlshortenerUrlGet
  ## Expands a short URL or gets creation time and analytics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   shortUrl: string (required)
  ##           : The short URL, including the protocol.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Additional information to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579906 = newJObject()
  add(query_579906, "fields", newJString(fields))
  add(query_579906, "quotaUser", newJString(quotaUser))
  add(query_579906, "alt", newJString(alt))
  add(query_579906, "oauth_token", newJString(oauthToken))
  add(query_579906, "shortUrl", newJString(shortUrl))
  add(query_579906, "userIp", newJString(userIp))
  add(query_579906, "key", newJString(key))
  add(query_579906, "projection", newJString(projection))
  add(query_579906, "prettyPrint", newJBool(prettyPrint))
  result = call_579905.call(nil, query_579906, nil, nil, nil)

var urlshortenerUrlGet* = Call_UrlshortenerUrlGet_579676(
    name: "urlshortenerUrlGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/url",
    validator: validate_UrlshortenerUrlGet_579677, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlGet_579678, schemes: {Scheme.Https})
type
  Call_UrlshortenerUrlList_579961 = ref object of OpenApiRestCall_579408
proc url_UrlshortenerUrlList_579963(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlList_579962(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a list of URLs shortened by a user.
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
  ##   projection: JString
  ##             : Additional information to return.
  ##   start-token: JString
  ##              : Token for requesting successive pages of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("json"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("projection")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("ANALYTICS_CLICKS"))
  if valid_579970 != nil:
    section.add "projection", valid_579970
  var valid_579971 = query.getOrDefault("start-token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "start-token", valid_579971
  var valid_579972 = query.getOrDefault("prettyPrint")
  valid_579972 = validateParameter(valid_579972, JBool, required = false,
                                 default = newJBool(true))
  if valid_579972 != nil:
    section.add "prettyPrint", valid_579972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579973: Call_UrlshortenerUrlList_579961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of URLs shortened by a user.
  ## 
  let valid = call_579973.validator(path, query, header, formData, body)
  let scheme = call_579973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579973.url(scheme.get, call_579973.host, call_579973.base,
                         call_579973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579973, url, valid)

proc call*(call_579974: Call_UrlshortenerUrlList_579961; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = "";
          projection: string = "ANALYTICS_CLICKS"; startToken: string = "";
          prettyPrint: bool = true): Recallable =
  ## urlshortenerUrlList
  ## Retrieves a list of URLs shortened by a user.
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
  ##   projection: string
  ##             : Additional information to return.
  ##   startToken: string
  ##             : Token for requesting successive pages of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579975 = newJObject()
  add(query_579975, "fields", newJString(fields))
  add(query_579975, "quotaUser", newJString(quotaUser))
  add(query_579975, "alt", newJString(alt))
  add(query_579975, "oauth_token", newJString(oauthToken))
  add(query_579975, "userIp", newJString(userIp))
  add(query_579975, "key", newJString(key))
  add(query_579975, "projection", newJString(projection))
  add(query_579975, "start-token", newJString(startToken))
  add(query_579975, "prettyPrint", newJBool(prettyPrint))
  result = call_579974.call(nil, query_579975, nil, nil, nil)

var urlshortenerUrlList* = Call_UrlshortenerUrlList_579961(
    name: "urlshortenerUrlList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/url/history",
    validator: validate_UrlshortenerUrlList_579962, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlList_579963, schemes: {Scheme.Https})
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
