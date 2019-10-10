
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: PageSpeed Insights
## version: v4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Analyzes the performance of a web page and provides tailored suggestions to make that page faster.
## 
## https://developers.google.com/speed/docs/insights/v4/getting-started
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
  gcpServiceName = "pagespeedonline"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PagespeedonlinePagespeedapiRunpagespeed_588709 = ref object of OpenApiRestCall_588441
proc url_PagespeedonlinePagespeedapiRunpagespeed_588711(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PagespeedonlinePagespeedapiRunpagespeed_588710(path: JsonNode;
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
  ##   snapshots: JBool
  ##            : Indicates if binary data containing snapshot images should be included
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
  ##   filter_third_party_resources: JBool
  ##                               : Indicates if third party resources should be filtered out before PageSpeed analysis.
  ##   url: JString (required)
  ##      : The URL to fetch and analyze
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rule: JArray
  ##       : A PageSpeed rule to run; if none are given, all rules are run
  ##   screenshot: JBool
  ##             : Indicates if binary data containing a screenshot should be included
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   strategy: JString
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   utm_campaign: JString
  ##               : Campaign name for analytics.
  section = newJObject()
  var valid_588823 = query.getOrDefault("utm_source")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "utm_source", valid_588823
  var valid_588824 = query.getOrDefault("locale")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "locale", valid_588824
  var valid_588838 = query.getOrDefault("snapshots")
  valid_588838 = validateParameter(valid_588838, JBool, required = false,
                                 default = newJBool(false))
  if valid_588838 != nil:
    section.add "snapshots", valid_588838
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("quotaUser")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "quotaUser", valid_588840
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("userIp")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "userIp", valid_588843
  var valid_588844 = query.getOrDefault("filter_third_party_resources")
  valid_588844 = validateParameter(valid_588844, JBool, required = false,
                                 default = newJBool(false))
  if valid_588844 != nil:
    section.add "filter_third_party_resources", valid_588844
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_588845 = query.getOrDefault("url")
  valid_588845 = validateParameter(valid_588845, JString, required = true,
                                 default = nil)
  if valid_588845 != nil:
    section.add "url", valid_588845
  var valid_588846 = query.getOrDefault("key")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "key", valid_588846
  var valid_588847 = query.getOrDefault("rule")
  valid_588847 = validateParameter(valid_588847, JArray, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "rule", valid_588847
  var valid_588848 = query.getOrDefault("screenshot")
  valid_588848 = validateParameter(valid_588848, JBool, required = false,
                                 default = newJBool(false))
  if valid_588848 != nil:
    section.add "screenshot", valid_588848
  var valid_588849 = query.getOrDefault("prettyPrint")
  valid_588849 = validateParameter(valid_588849, JBool, required = false,
                                 default = newJBool(true))
  if valid_588849 != nil:
    section.add "prettyPrint", valid_588849
  var valid_588850 = query.getOrDefault("strategy")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("desktop"))
  if valid_588850 != nil:
    section.add "strategy", valid_588850
  var valid_588851 = query.getOrDefault("utm_campaign")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "utm_campaign", valid_588851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588874: Call_PagespeedonlinePagespeedapiRunpagespeed_588709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ## 
  let valid = call_588874.validator(path, query, header, formData, body)
  let scheme = call_588874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588874.url(scheme.get, call_588874.host, call_588874.base,
                         call_588874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588874, url, valid)

proc call*(call_588945: Call_PagespeedonlinePagespeedapiRunpagespeed_588709;
          url: string; utmSource: string = ""; locale: string = "";
          snapshots: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          filterThirdPartyResources: bool = false; key: string = "";
          rule: JsonNode = nil; screenshot: bool = false; prettyPrint: bool = true;
          strategy: string = "desktop"; utmCampaign: string = ""): Recallable =
  ## pagespeedonlinePagespeedapiRunpagespeed
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ##   utmSource: string
  ##            : Campaign source for analytics.
  ##   locale: string
  ##         : The locale used to localize formatted results
  ##   snapshots: bool
  ##            : Indicates if binary data containing snapshot images should be included
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
  ##   filterThirdPartyResources: bool
  ##                            : Indicates if third party resources should be filtered out before PageSpeed analysis.
  ##   url: string (required)
  ##      : The URL to fetch and analyze
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rule: JArray
  ##       : A PageSpeed rule to run; if none are given, all rules are run
  ##   screenshot: bool
  ##             : Indicates if binary data containing a screenshot should be included
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   strategy: string
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   utmCampaign: string
  ##              : Campaign name for analytics.
  var query_588946 = newJObject()
  add(query_588946, "utm_source", newJString(utmSource))
  add(query_588946, "locale", newJString(locale))
  add(query_588946, "snapshots", newJBool(snapshots))
  add(query_588946, "fields", newJString(fields))
  add(query_588946, "quotaUser", newJString(quotaUser))
  add(query_588946, "alt", newJString(alt))
  add(query_588946, "oauth_token", newJString(oauthToken))
  add(query_588946, "userIp", newJString(userIp))
  add(query_588946, "filter_third_party_resources",
      newJBool(filterThirdPartyResources))
  add(query_588946, "url", newJString(url))
  add(query_588946, "key", newJString(key))
  if rule != nil:
    query_588946.add "rule", rule
  add(query_588946, "screenshot", newJBool(screenshot))
  add(query_588946, "prettyPrint", newJBool(prettyPrint))
  add(query_588946, "strategy", newJString(strategy))
  add(query_588946, "utm_campaign", newJString(utmCampaign))
  result = call_588945.call(nil, query_588946, nil, nil, nil)

var pagespeedonlinePagespeedapiRunpagespeed* = Call_PagespeedonlinePagespeedapiRunpagespeed_588709(
    name: "pagespeedonlinePagespeedapiRunpagespeed", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/runPagespeed",
    validator: validate_PagespeedonlinePagespeedapiRunpagespeed_588710,
    base: "/pagespeedonline/v4", url: url_PagespeedonlinePagespeedapiRunpagespeed_588711,
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
