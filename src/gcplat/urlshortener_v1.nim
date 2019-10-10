
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "urlshortener"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UrlshortenerUrlInsert_588979 = ref object of OpenApiRestCall_588441
proc url_UrlshortenerUrlInsert_588981(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlInsert_588980(path: JsonNode; query: JsonNode;
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
  var valid_588982 = query.getOrDefault("fields")
  valid_588982 = validateParameter(valid_588982, JString, required = false,
                                 default = nil)
  if valid_588982 != nil:
    section.add "fields", valid_588982
  var valid_588983 = query.getOrDefault("quotaUser")
  valid_588983 = validateParameter(valid_588983, JString, required = false,
                                 default = nil)
  if valid_588983 != nil:
    section.add "quotaUser", valid_588983
  var valid_588984 = query.getOrDefault("alt")
  valid_588984 = validateParameter(valid_588984, JString, required = false,
                                 default = newJString("json"))
  if valid_588984 != nil:
    section.add "alt", valid_588984
  var valid_588985 = query.getOrDefault("oauth_token")
  valid_588985 = validateParameter(valid_588985, JString, required = false,
                                 default = nil)
  if valid_588985 != nil:
    section.add "oauth_token", valid_588985
  var valid_588986 = query.getOrDefault("userIp")
  valid_588986 = validateParameter(valid_588986, JString, required = false,
                                 default = nil)
  if valid_588986 != nil:
    section.add "userIp", valid_588986
  var valid_588987 = query.getOrDefault("key")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "key", valid_588987
  var valid_588988 = query.getOrDefault("prettyPrint")
  valid_588988 = validateParameter(valid_588988, JBool, required = false,
                                 default = newJBool(true))
  if valid_588988 != nil:
    section.add "prettyPrint", valid_588988
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

proc call*(call_588990: Call_UrlshortenerUrlInsert_588979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new short URL.
  ## 
  let valid = call_588990.validator(path, query, header, formData, body)
  let scheme = call_588990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588990.url(scheme.get, call_588990.host, call_588990.base,
                         call_588990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588990, url, valid)

proc call*(call_588991: Call_UrlshortenerUrlInsert_588979; fields: string = "";
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
  var query_588992 = newJObject()
  var body_588993 = newJObject()
  add(query_588992, "fields", newJString(fields))
  add(query_588992, "quotaUser", newJString(quotaUser))
  add(query_588992, "alt", newJString(alt))
  add(query_588992, "oauth_token", newJString(oauthToken))
  add(query_588992, "userIp", newJString(userIp))
  add(query_588992, "key", newJString(key))
  if body != nil:
    body_588993 = body
  add(query_588992, "prettyPrint", newJBool(prettyPrint))
  result = call_588991.call(nil, query_588992, nil, nil, body_588993)

var urlshortenerUrlInsert* = Call_UrlshortenerUrlInsert_588979(
    name: "urlshortenerUrlInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/url",
    validator: validate_UrlshortenerUrlInsert_588980, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlInsert_588981, schemes: {Scheme.Https})
type
  Call_UrlshortenerUrlGet_588709 = ref object of OpenApiRestCall_588441
proc url_UrlshortenerUrlGet_588711(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlGet_588710(path: JsonNode; query: JsonNode;
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
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  assert query != nil,
        "query argument is necessary due to required `shortUrl` field"
  var valid_588840 = query.getOrDefault("shortUrl")
  valid_588840 = validateParameter(valid_588840, JString, required = true,
                                 default = nil)
  if valid_588840 != nil:
    section.add "shortUrl", valid_588840
  var valid_588841 = query.getOrDefault("userIp")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "userIp", valid_588841
  var valid_588842 = query.getOrDefault("key")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "key", valid_588842
  var valid_588843 = query.getOrDefault("projection")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = newJString("ANALYTICS_CLICKS"))
  if valid_588843 != nil:
    section.add "projection", valid_588843
  var valid_588844 = query.getOrDefault("prettyPrint")
  valid_588844 = validateParameter(valid_588844, JBool, required = false,
                                 default = newJBool(true))
  if valid_588844 != nil:
    section.add "prettyPrint", valid_588844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588867: Call_UrlshortenerUrlGet_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expands a short URL or gets creation time and analytics.
  ## 
  let valid = call_588867.validator(path, query, header, formData, body)
  let scheme = call_588867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588867.url(scheme.get, call_588867.host, call_588867.base,
                         call_588867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588867, url, valid)

proc call*(call_588938: Call_UrlshortenerUrlGet_588709; shortUrl: string;
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
  var query_588939 = newJObject()
  add(query_588939, "fields", newJString(fields))
  add(query_588939, "quotaUser", newJString(quotaUser))
  add(query_588939, "alt", newJString(alt))
  add(query_588939, "oauth_token", newJString(oauthToken))
  add(query_588939, "shortUrl", newJString(shortUrl))
  add(query_588939, "userIp", newJString(userIp))
  add(query_588939, "key", newJString(key))
  add(query_588939, "projection", newJString(projection))
  add(query_588939, "prettyPrint", newJBool(prettyPrint))
  result = call_588938.call(nil, query_588939, nil, nil, nil)

var urlshortenerUrlGet* = Call_UrlshortenerUrlGet_588709(
    name: "urlshortenerUrlGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/url",
    validator: validate_UrlshortenerUrlGet_588710, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlGet_588711, schemes: {Scheme.Https})
type
  Call_UrlshortenerUrlList_588994 = ref object of OpenApiRestCall_588441
proc url_UrlshortenerUrlList_588996(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_UrlshortenerUrlList_588995(path: JsonNode; query: JsonNode;
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
  var valid_588997 = query.getOrDefault("fields")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "fields", valid_588997
  var valid_588998 = query.getOrDefault("quotaUser")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "quotaUser", valid_588998
  var valid_588999 = query.getOrDefault("alt")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = newJString("json"))
  if valid_588999 != nil:
    section.add "alt", valid_588999
  var valid_589000 = query.getOrDefault("oauth_token")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "oauth_token", valid_589000
  var valid_589001 = query.getOrDefault("userIp")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "userIp", valid_589001
  var valid_589002 = query.getOrDefault("key")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "key", valid_589002
  var valid_589003 = query.getOrDefault("projection")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = newJString("ANALYTICS_CLICKS"))
  if valid_589003 != nil:
    section.add "projection", valid_589003
  var valid_589004 = query.getOrDefault("start-token")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "start-token", valid_589004
  var valid_589005 = query.getOrDefault("prettyPrint")
  valid_589005 = validateParameter(valid_589005, JBool, required = false,
                                 default = newJBool(true))
  if valid_589005 != nil:
    section.add "prettyPrint", valid_589005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589006: Call_UrlshortenerUrlList_588994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of URLs shortened by a user.
  ## 
  let valid = call_589006.validator(path, query, header, formData, body)
  let scheme = call_589006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589006.url(scheme.get, call_589006.host, call_589006.base,
                         call_589006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589006, url, valid)

proc call*(call_589007: Call_UrlshortenerUrlList_588994; fields: string = "";
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
  var query_589008 = newJObject()
  add(query_589008, "fields", newJString(fields))
  add(query_589008, "quotaUser", newJString(quotaUser))
  add(query_589008, "alt", newJString(alt))
  add(query_589008, "oauth_token", newJString(oauthToken))
  add(query_589008, "userIp", newJString(userIp))
  add(query_589008, "key", newJString(key))
  add(query_589008, "projection", newJString(projection))
  add(query_589008, "start-token", newJString(startToken))
  add(query_589008, "prettyPrint", newJBool(prettyPrint))
  result = call_589007.call(nil, query_589008, nil, nil, nil)

var urlshortenerUrlList* = Call_UrlshortenerUrlList_588994(
    name: "urlshortenerUrlList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/url/history",
    validator: validate_UrlshortenerUrlList_588995, base: "/urlshortener/v1",
    url: url_UrlshortenerUrlList_588996, schemes: {Scheme.Https})
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
