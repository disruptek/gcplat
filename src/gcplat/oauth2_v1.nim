
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google OAuth2
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Obtains end-user authorization grants for use with other Google APIs.
## 
## https://developers.google.com/accounts/docs/OAuth2
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
  gcpServiceName = "oauth2"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Oauth2Tokeninfo_578609 = ref object of OpenApiRestCall_578339
proc url_Oauth2Tokeninfo_578611(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2Tokeninfo_578610(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get token info
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
  ##   id_token: JString
  ##           : The ID token
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : The oauth2 access token
  section = newJObject()
  var valid_578723 = query.getOrDefault("key")
  valid_578723 = validateParameter(valid_578723, JString, required = false,
                                 default = nil)
  if valid_578723 != nil:
    section.add "key", valid_578723
  var valid_578737 = query.getOrDefault("prettyPrint")
  valid_578737 = validateParameter(valid_578737, JBool, required = false,
                                 default = newJBool(true))
  if valid_578737 != nil:
    section.add "prettyPrint", valid_578737
  var valid_578738 = query.getOrDefault("oauth_token")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "oauth_token", valid_578738
  var valid_578739 = query.getOrDefault("id_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "id_token", valid_578739
  var valid_578740 = query.getOrDefault("alt")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("json"))
  if valid_578740 != nil:
    section.add "alt", valid_578740
  var valid_578741 = query.getOrDefault("userIp")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "userIp", valid_578741
  var valid_578742 = query.getOrDefault("quotaUser")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "quotaUser", valid_578742
  var valid_578743 = query.getOrDefault("fields")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "fields", valid_578743
  var valid_578744 = query.getOrDefault("access_token")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "access_token", valid_578744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578767: Call_Oauth2Tokeninfo_578609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get token info
  ## 
  let valid = call_578767.validator(path, query, header, formData, body)
  let scheme = call_578767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578767.url(scheme.get, call_578767.host, call_578767.base,
                         call_578767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578767, url, valid)

proc call*(call_578838: Call_Oauth2Tokeninfo_578609; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; idToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; accessToken: string = ""): Recallable =
  ## oauth2Tokeninfo
  ## Get token info
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   idToken: string
  ##          : The ID token
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : The oauth2 access token
  var query_578839 = newJObject()
  add(query_578839, "key", newJString(key))
  add(query_578839, "prettyPrint", newJBool(prettyPrint))
  add(query_578839, "oauth_token", newJString(oauthToken))
  add(query_578839, "id_token", newJString(idToken))
  add(query_578839, "alt", newJString(alt))
  add(query_578839, "userIp", newJString(userIp))
  add(query_578839, "quotaUser", newJString(quotaUser))
  add(query_578839, "fields", newJString(fields))
  add(query_578839, "access_token", newJString(accessToken))
  result = call_578838.call(nil, query_578839, nil, nil, nil)

var oauth2Tokeninfo* = Call_Oauth2Tokeninfo_578609(name: "oauth2Tokeninfo",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/oauth2/v1/tokeninfo", validator: validate_Oauth2Tokeninfo_578610,
    base: "/", url: url_Oauth2Tokeninfo_578611, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoGet_578879 = ref object of OpenApiRestCall_578339
proc url_Oauth2UserinfoGet_578881(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoGet_578880(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get user info
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
  var valid_578882 = query.getOrDefault("key")
  valid_578882 = validateParameter(valid_578882, JString, required = false,
                                 default = nil)
  if valid_578882 != nil:
    section.add "key", valid_578882
  var valid_578883 = query.getOrDefault("prettyPrint")
  valid_578883 = validateParameter(valid_578883, JBool, required = false,
                                 default = newJBool(true))
  if valid_578883 != nil:
    section.add "prettyPrint", valid_578883
  var valid_578884 = query.getOrDefault("oauth_token")
  valid_578884 = validateParameter(valid_578884, JString, required = false,
                                 default = nil)
  if valid_578884 != nil:
    section.add "oauth_token", valid_578884
  var valid_578885 = query.getOrDefault("alt")
  valid_578885 = validateParameter(valid_578885, JString, required = false,
                                 default = newJString("json"))
  if valid_578885 != nil:
    section.add "alt", valid_578885
  var valid_578886 = query.getOrDefault("userIp")
  valid_578886 = validateParameter(valid_578886, JString, required = false,
                                 default = nil)
  if valid_578886 != nil:
    section.add "userIp", valid_578886
  var valid_578887 = query.getOrDefault("quotaUser")
  valid_578887 = validateParameter(valid_578887, JString, required = false,
                                 default = nil)
  if valid_578887 != nil:
    section.add "quotaUser", valid_578887
  var valid_578888 = query.getOrDefault("fields")
  valid_578888 = validateParameter(valid_578888, JString, required = false,
                                 default = nil)
  if valid_578888 != nil:
    section.add "fields", valid_578888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578889: Call_Oauth2UserinfoGet_578879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user info
  ## 
  let valid = call_578889.validator(path, query, header, formData, body)
  let scheme = call_578889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578889.url(scheme.get, call_578889.host, call_578889.base,
                         call_578889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578889, url, valid)

proc call*(call_578890: Call_Oauth2UserinfoGet_578879; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## oauth2UserinfoGet
  ## Get user info
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
  var query_578891 = newJObject()
  add(query_578891, "key", newJString(key))
  add(query_578891, "prettyPrint", newJBool(prettyPrint))
  add(query_578891, "oauth_token", newJString(oauthToken))
  add(query_578891, "alt", newJString(alt))
  add(query_578891, "userIp", newJString(userIp))
  add(query_578891, "quotaUser", newJString(quotaUser))
  add(query_578891, "fields", newJString(fields))
  result = call_578890.call(nil, query_578891, nil, nil, nil)

var oauth2UserinfoGet* = Call_Oauth2UserinfoGet_578879(name: "oauth2UserinfoGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/oauth2/v1/userinfo", validator: validate_Oauth2UserinfoGet_578880,
    base: "/", url: url_Oauth2UserinfoGet_578881, schemes: {Scheme.Https})
type
  Call_Oauth2UserinfoV2MeGet_578892 = ref object of OpenApiRestCall_578339
proc url_Oauth2UserinfoV2MeGet_578894(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_Oauth2UserinfoV2MeGet_578893(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get user info
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
  var valid_578895 = query.getOrDefault("key")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "key", valid_578895
  var valid_578896 = query.getOrDefault("prettyPrint")
  valid_578896 = validateParameter(valid_578896, JBool, required = false,
                                 default = newJBool(true))
  if valid_578896 != nil:
    section.add "prettyPrint", valid_578896
  var valid_578897 = query.getOrDefault("oauth_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "oauth_token", valid_578897
  var valid_578898 = query.getOrDefault("alt")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = newJString("json"))
  if valid_578898 != nil:
    section.add "alt", valid_578898
  var valid_578899 = query.getOrDefault("userIp")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "userIp", valid_578899
  var valid_578900 = query.getOrDefault("quotaUser")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "quotaUser", valid_578900
  var valid_578901 = query.getOrDefault("fields")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "fields", valid_578901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578902: Call_Oauth2UserinfoV2MeGet_578892; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user info
  ## 
  let valid = call_578902.validator(path, query, header, formData, body)
  let scheme = call_578902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578902.url(scheme.get, call_578902.host, call_578902.base,
                         call_578902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578902, url, valid)

proc call*(call_578903: Call_Oauth2UserinfoV2MeGet_578892; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## oauth2UserinfoV2MeGet
  ## Get user info
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
  var query_578904 = newJObject()
  add(query_578904, "key", newJString(key))
  add(query_578904, "prettyPrint", newJBool(prettyPrint))
  add(query_578904, "oauth_token", newJString(oauthToken))
  add(query_578904, "alt", newJString(alt))
  add(query_578904, "userIp", newJString(userIp))
  add(query_578904, "quotaUser", newJString(quotaUser))
  add(query_578904, "fields", newJString(fields))
  result = call_578903.call(nil, query_578904, nil, nil, nil)

var oauth2UserinfoV2MeGet* = Call_Oauth2UserinfoV2MeGet_578892(
    name: "oauth2UserinfoV2MeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/userinfo/v2/me",
    validator: validate_Oauth2UserinfoV2MeGet_578893, base: "/",
    url: url_Oauth2UserinfoV2MeGet_578894, schemes: {Scheme.Https})
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
