
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: PageSpeed Insights
## version: v5
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Analyzes the performance of a web page and provides tailored suggestions to make that page faster.
## 
## https://developers.google.com/speed/docs/insights/v5/get-started
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
  gcpServiceName = "pagespeedonline"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PagespeedonlinePagespeedapiRunpagespeed_579676 = ref object of OpenApiRestCall_579408
proc url_PagespeedonlinePagespeedapiRunpagespeed_579678(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PagespeedonlinePagespeedapiRunpagespeed_579677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   utm_source: JString
  ##             : Campaign source for analytics.
  ##   locale: JString
  ##         : The locale used to localize formatted results
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
  ##   url: JString (required)
  ##      : The URL to fetch and analyze
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   category: JArray
  ##           : A Lighthouse category to run; if none are given, only Performance category will be run
  ##   strategy: JString
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   utm_campaign: JString
  ##               : Campaign name for analytics.
  section = newJObject()
  var valid_579790 = query.getOrDefault("utm_source")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "utm_source", valid_579790
  var valid_579791 = query.getOrDefault("locale")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "locale", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("quotaUser")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "quotaUser", valid_579793
  var valid_579807 = query.getOrDefault("alt")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = newJString("json"))
  if valid_579807 != nil:
    section.add "alt", valid_579807
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("userIp")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "userIp", valid_579809
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_579810 = query.getOrDefault("url")
  valid_579810 = validateParameter(valid_579810, JString, required = true,
                                 default = nil)
  if valid_579810 != nil:
    section.add "url", valid_579810
  var valid_579811 = query.getOrDefault("key")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "key", valid_579811
  var valid_579812 = query.getOrDefault("prettyPrint")
  valid_579812 = validateParameter(valid_579812, JBool, required = false,
                                 default = newJBool(true))
  if valid_579812 != nil:
    section.add "prettyPrint", valid_579812
  var valid_579813 = query.getOrDefault("category")
  valid_579813 = validateParameter(valid_579813, JArray, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "category", valid_579813
  var valid_579814 = query.getOrDefault("strategy")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = newJString("desktop"))
  if valid_579814 != nil:
    section.add "strategy", valid_579814
  var valid_579815 = query.getOrDefault("utm_campaign")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "utm_campaign", valid_579815
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579838: Call_PagespeedonlinePagespeedapiRunpagespeed_579676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ## 
  let valid = call_579838.validator(path, query, header, formData, body)
  let scheme = call_579838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579838.url(scheme.get, call_579838.host, call_579838.base,
                         call_579838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579838, url, valid)

proc call*(call_579909: Call_PagespeedonlinePagespeedapiRunpagespeed_579676;
          url: string; utmSource: string = ""; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          category: JsonNode = nil; strategy: string = "desktop";
          utmCampaign: string = ""): Recallable =
  ## pagespeedonlinePagespeedapiRunpagespeed
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ##   utmSource: string
  ##            : Campaign source for analytics.
  ##   locale: string
  ##         : The locale used to localize formatted results
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
  ##   url: string (required)
  ##      : The URL to fetch and analyze
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   category: JArray
  ##           : A Lighthouse category to run; if none are given, only Performance category will be run
  ##   strategy: string
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   utmCampaign: string
  ##              : Campaign name for analytics.
  var query_579910 = newJObject()
  add(query_579910, "utm_source", newJString(utmSource))
  add(query_579910, "locale", newJString(locale))
  add(query_579910, "fields", newJString(fields))
  add(query_579910, "quotaUser", newJString(quotaUser))
  add(query_579910, "alt", newJString(alt))
  add(query_579910, "oauth_token", newJString(oauthToken))
  add(query_579910, "userIp", newJString(userIp))
  add(query_579910, "url", newJString(url))
  add(query_579910, "key", newJString(key))
  add(query_579910, "prettyPrint", newJBool(prettyPrint))
  if category != nil:
    query_579910.add "category", category
  add(query_579910, "strategy", newJString(strategy))
  add(query_579910, "utm_campaign", newJString(utmCampaign))
  result = call_579909.call(nil, query_579910, nil, nil, nil)

var pagespeedonlinePagespeedapiRunpagespeed* = Call_PagespeedonlinePagespeedapiRunpagespeed_579676(
    name: "pagespeedonlinePagespeedapiRunpagespeed", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/runPagespeed",
    validator: validate_PagespeedonlinePagespeedapiRunpagespeed_579677,
    base: "/pagespeedonline/v5", url: url_PagespeedonlinePagespeedapiRunpagespeed_579678,
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
