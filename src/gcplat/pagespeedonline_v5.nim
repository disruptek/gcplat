
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  gcpServiceName = "pagespeedonline"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PagespeedonlinePagespeedapiRunpagespeed_579634 = ref object of OpenApiRestCall_579364
proc url_PagespeedonlinePagespeedapiRunpagespeed_579636(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_PagespeedonlinePagespeedapiRunpagespeed_579635(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
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
  ##   locale: JString
  ##         : The locale used to localize formatted results
  ##   strategy: JString
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   utm_campaign: JString
  ##               : Campaign name for analytics.
  ##   category: JArray
  ##           : A Lighthouse category to run; if none are given, only Performance category will be run
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   utm_source: JString
  ##             : Campaign source for analytics.
  ##   url: JString (required)
  ##      : The URL to fetch and analyze
  section = newJObject()
  var valid_579748 = query.getOrDefault("key")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "key", valid_579748
  var valid_579762 = query.getOrDefault("prettyPrint")
  valid_579762 = validateParameter(valid_579762, JBool, required = false,
                                 default = newJBool(true))
  if valid_579762 != nil:
    section.add "prettyPrint", valid_579762
  var valid_579763 = query.getOrDefault("oauth_token")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = nil)
  if valid_579763 != nil:
    section.add "oauth_token", valid_579763
  var valid_579764 = query.getOrDefault("locale")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "locale", valid_579764
  var valid_579765 = query.getOrDefault("strategy")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("desktop"))
  if valid_579765 != nil:
    section.add "strategy", valid_579765
  var valid_579766 = query.getOrDefault("alt")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = newJString("json"))
  if valid_579766 != nil:
    section.add "alt", valid_579766
  var valid_579767 = query.getOrDefault("userIp")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "userIp", valid_579767
  var valid_579768 = query.getOrDefault("quotaUser")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "quotaUser", valid_579768
  var valid_579769 = query.getOrDefault("utm_campaign")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "utm_campaign", valid_579769
  var valid_579770 = query.getOrDefault("category")
  valid_579770 = validateParameter(valid_579770, JArray, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "category", valid_579770
  var valid_579771 = query.getOrDefault("fields")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "fields", valid_579771
  var valid_579772 = query.getOrDefault("utm_source")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "utm_source", valid_579772
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_579773 = query.getOrDefault("url")
  valid_579773 = validateParameter(valid_579773, JString, required = true,
                                 default = nil)
  if valid_579773 != nil:
    section.add "url", valid_579773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579796: Call_PagespeedonlinePagespeedapiRunpagespeed_579634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ## 
  let valid = call_579796.validator(path, query, header, formData, body)
  let scheme = call_579796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579796.url(scheme.get, call_579796.host, call_579796.base,
                         call_579796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579796, url, valid)

proc call*(call_579867: Call_PagespeedonlinePagespeedapiRunpagespeed_579634;
          url: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; strategy: string = "desktop";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          utmCampaign: string = ""; category: JsonNode = nil; fields: string = "";
          utmSource: string = ""): Recallable =
  ## pagespeedonlinePagespeedapiRunpagespeed
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : The locale used to localize formatted results
  ##   strategy: string
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   utmCampaign: string
  ##              : Campaign name for analytics.
  ##   category: JArray
  ##           : A Lighthouse category to run; if none are given, only Performance category will be run
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   utmSource: string
  ##            : Campaign source for analytics.
  ##   url: string (required)
  ##      : The URL to fetch and analyze
  var query_579868 = newJObject()
  add(query_579868, "key", newJString(key))
  add(query_579868, "prettyPrint", newJBool(prettyPrint))
  add(query_579868, "oauth_token", newJString(oauthToken))
  add(query_579868, "locale", newJString(locale))
  add(query_579868, "strategy", newJString(strategy))
  add(query_579868, "alt", newJString(alt))
  add(query_579868, "userIp", newJString(userIp))
  add(query_579868, "quotaUser", newJString(quotaUser))
  add(query_579868, "utm_campaign", newJString(utmCampaign))
  if category != nil:
    query_579868.add "category", category
  add(query_579868, "fields", newJString(fields))
  add(query_579868, "utm_source", newJString(utmSource))
  add(query_579868, "url", newJString(url))
  result = call_579867.call(nil, query_579868, nil, nil, nil)

var pagespeedonlinePagespeedapiRunpagespeed* = Call_PagespeedonlinePagespeedapiRunpagespeed_579634(
    name: "pagespeedonlinePagespeedapiRunpagespeed", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/runPagespeed",
    validator: validate_PagespeedonlinePagespeedapiRunpagespeed_579635,
    base: "/pagespeedonline/v5", url: url_PagespeedonlinePagespeedapiRunpagespeed_579636,
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
