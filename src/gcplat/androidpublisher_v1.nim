
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Developer
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses Android application developers' Google Play accounts.
## 
## https://developers.google.com/android-publisher
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "androidpublisher"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidpublisherPurchasesGet_578609 = ref object of OpenApiRestCall_578339
proc url_AndroidpublisherPurchasesGet_578611(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/purchases/"),
               (kind: VariableSegment, value: "token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesGet_578610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578737 = path.getOrDefault("packageName")
  valid_578737 = validateParameter(valid_578737, JString, required = true,
                                 default = nil)
  if valid_578737 != nil:
    section.add "packageName", valid_578737
  var valid_578738 = path.getOrDefault("subscriptionId")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "subscriptionId", valid_578738
  var valid_578739 = path.getOrDefault("token")
  valid_578739 = validateParameter(valid_578739, JString, required = true,
                                 default = nil)
  if valid_578739 != nil:
    section.add "token", valid_578739
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

proc call*(call_578782: Call_AndroidpublisherPurchasesGet_578609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_AndroidpublisherPurchasesGet_578609;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherPurchasesGet
  ## Checks whether a user's subscription purchase is valid and returns its expiry time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578854 = newJObject()
  var query_578856 = newJObject()
  add(query_578856, "key", newJString(key))
  add(query_578856, "prettyPrint", newJBool(prettyPrint))
  add(query_578856, "oauth_token", newJString(oauthToken))
  add(path_578854, "packageName", newJString(packageName))
  add(query_578856, "alt", newJString(alt))
  add(query_578856, "userIp", newJString(userIp))
  add(query_578856, "quotaUser", newJString(quotaUser))
  add(path_578854, "subscriptionId", newJString(subscriptionId))
  add(path_578854, "token", newJString(token))
  add(query_578856, "fields", newJString(fields))
  result = call_578853.call(path_578854, query_578856, nil, nil, nil)

var androidpublisherPurchasesGet* = Call_AndroidpublisherPurchasesGet_578609(
    name: "androidpublisherPurchasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}",
    validator: validate_AndroidpublisherPurchasesGet_578610,
    base: "/androidpublisher/v1/applications",
    url: url_AndroidpublisherPurchasesGet_578611, schemes: {Scheme.Https})
type
  Call_AndroidpublisherPurchasesCancel_578895 = ref object of OpenApiRestCall_578339
proc url_AndroidpublisherPurchasesCancel_578897(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "packageName" in path, "`packageName` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "token" in path, "`token` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "packageName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/purchases/"),
               (kind: VariableSegment, value: "token"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidpublisherPurchasesCancel_578896(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   packageName: JString (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   subscriptionId: JString (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: JString (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `packageName` field"
  var valid_578898 = path.getOrDefault("packageName")
  valid_578898 = validateParameter(valid_578898, JString, required = true,
                                 default = nil)
  if valid_578898 != nil:
    section.add "packageName", valid_578898
  var valid_578899 = path.getOrDefault("subscriptionId")
  valid_578899 = validateParameter(valid_578899, JString, required = true,
                                 default = nil)
  if valid_578899 != nil:
    section.add "subscriptionId", valid_578899
  var valid_578900 = path.getOrDefault("token")
  valid_578900 = validateParameter(valid_578900, JString, required = true,
                                 default = nil)
  if valid_578900 != nil:
    section.add "token", valid_578900
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
  var valid_578901 = query.getOrDefault("key")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "key", valid_578901
  var valid_578902 = query.getOrDefault("prettyPrint")
  valid_578902 = validateParameter(valid_578902, JBool, required = false,
                                 default = newJBool(true))
  if valid_578902 != nil:
    section.add "prettyPrint", valid_578902
  var valid_578903 = query.getOrDefault("oauth_token")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "oauth_token", valid_578903
  var valid_578904 = query.getOrDefault("alt")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = newJString("json"))
  if valid_578904 != nil:
    section.add "alt", valid_578904
  var valid_578905 = query.getOrDefault("userIp")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "userIp", valid_578905
  var valid_578906 = query.getOrDefault("quotaUser")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "quotaUser", valid_578906
  var valid_578907 = query.getOrDefault("fields")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "fields", valid_578907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578908: Call_AndroidpublisherPurchasesCancel_578895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ## 
  let valid = call_578908.validator(path, query, header, formData, body)
  let scheme = call_578908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578908.url(scheme.get, call_578908.host, call_578908.base,
                         call_578908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578908, url, valid)

proc call*(call_578909: Call_AndroidpublisherPurchasesCancel_578895;
          packageName: string; subscriptionId: string; token: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidpublisherPurchasesCancel
  ## Cancels a user's subscription purchase. The subscription remains valid until its expiration time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   packageName: string (required)
  ##              : The package name of the application for which this subscription was purchased (for example, 'com.some.thing').
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   subscriptionId: string (required)
  ##                 : The purchased subscription ID (for example, 'monthly001').
  ##   token: string (required)
  ##        : The token provided to the user's device when the subscription was purchased.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578910 = newJObject()
  var query_578911 = newJObject()
  add(query_578911, "key", newJString(key))
  add(query_578911, "prettyPrint", newJBool(prettyPrint))
  add(query_578911, "oauth_token", newJString(oauthToken))
  add(path_578910, "packageName", newJString(packageName))
  add(query_578911, "alt", newJString(alt))
  add(query_578911, "userIp", newJString(userIp))
  add(query_578911, "quotaUser", newJString(quotaUser))
  add(path_578910, "subscriptionId", newJString(subscriptionId))
  add(path_578910, "token", newJString(token))
  add(query_578911, "fields", newJString(fields))
  result = call_578909.call(path_578910, query_578911, nil, nil, nil)

var androidpublisherPurchasesCancel* = Call_AndroidpublisherPurchasesCancel_578895(
    name: "androidpublisherPurchasesCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{packageName}/subscriptions/{subscriptionId}/purchases/{token}/cancel",
    validator: validate_AndroidpublisherPurchasesCancel_578896,
    base: "/androidpublisher/v1/applications",
    url: url_AndroidpublisherPurchasesCancel_578897, schemes: {Scheme.Https})
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
