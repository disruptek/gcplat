
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Knowledge Graph Search
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Searches the Google Knowledge Graph for entities.
## 
## https://developers.google.com/knowledge-graph/
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
  gcpServiceName = "kgsearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_KgsearchEntitiesSearch_579677 = ref object of OpenApiRestCall_579408
proc url_KgsearchEntitiesSearch_579679(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_KgsearchEntitiesSearch_579678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches Knowledge Graph for entities that match the constraints.
  ## A list of matched entities will be returned in response, which will be in
  ## JSON-LD format and compatible with http://schema.org
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   languages: JArray
  ##            : The list of language codes (defined in ISO 693) to run the query with,
  ## e.g. 'en'.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The literal query string for search.
  ##   types: JArray
  ##        : Restricts returned entities with these types, e.g. Person
  ## (as defined in http://schema.org/Person). If multiple types are specified,
  ## returned entities will contain one or more of these types.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   indent: JBool
  ##         : Enables indenting of json results.
  ##   ids: JArray
  ##      : The list of entity id to be used for search instead of query string.
  ## To specify multiple ids in the HTTP request, repeat the parameter in the
  ## URL as in ...?ids=A&ids=B
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JBool
  ##         : Enables prefix match against names and aliases of entities
  ##   limit: JInt
  ##        : Limits the number of entities to be returned.
  section = newJObject()
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("languages")
  valid_579793 = validateParameter(valid_579793, JArray, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "languages", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("query")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "query", valid_579809
  var valid_579810 = query.getOrDefault("types")
  valid_579810 = validateParameter(valid_579810, JArray, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "types", valid_579810
  var valid_579811 = query.getOrDefault("oauth_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "oauth_token", valid_579811
  var valid_579812 = query.getOrDefault("callback")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "callback", valid_579812
  var valid_579813 = query.getOrDefault("access_token")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "access_token", valid_579813
  var valid_579814 = query.getOrDefault("uploadType")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "uploadType", valid_579814
  var valid_579815 = query.getOrDefault("indent")
  valid_579815 = validateParameter(valid_579815, JBool, required = false, default = nil)
  if valid_579815 != nil:
    section.add "indent", valid_579815
  var valid_579816 = query.getOrDefault("ids")
  valid_579816 = validateParameter(valid_579816, JArray, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "ids", valid_579816
  var valid_579817 = query.getOrDefault("key")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "key", valid_579817
  var valid_579818 = query.getOrDefault("$.xgafv")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = newJString("1"))
  if valid_579818 != nil:
    section.add "$.xgafv", valid_579818
  var valid_579819 = query.getOrDefault("prettyPrint")
  valid_579819 = validateParameter(valid_579819, JBool, required = false,
                                 default = newJBool(true))
  if valid_579819 != nil:
    section.add "prettyPrint", valid_579819
  var valid_579820 = query.getOrDefault("prefix")
  valid_579820 = validateParameter(valid_579820, JBool, required = false, default = nil)
  if valid_579820 != nil:
    section.add "prefix", valid_579820
  var valid_579821 = query.getOrDefault("limit")
  valid_579821 = validateParameter(valid_579821, JInt, required = false, default = nil)
  if valid_579821 != nil:
    section.add "limit", valid_579821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579844: Call_KgsearchEntitiesSearch_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches Knowledge Graph for entities that match the constraints.
  ## A list of matched entities will be returned in response, which will be in
  ## JSON-LD format and compatible with http://schema.org
  ## 
  let valid = call_579844.validator(path, query, header, formData, body)
  let scheme = call_579844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579844.url(scheme.get, call_579844.host, call_579844.base,
                         call_579844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579844, url, valid)

proc call*(call_579915: Call_KgsearchEntitiesSearch_579677;
          uploadProtocol: string = ""; fields: string = ""; languages: JsonNode = nil;
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          types: JsonNode = nil; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; indent: bool = false;
          ids: JsonNode = nil; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; prefix: bool = false; limit: int = 0): Recallable =
  ## kgsearchEntitiesSearch
  ## Searches Knowledge Graph for entities that match the constraints.
  ## A list of matched entities will be returned in response, which will be in
  ## JSON-LD format and compatible with http://schema.org
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   languages: JArray
  ##            : The list of language codes (defined in ISO 693) to run the query with,
  ## e.g. 'en'.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The literal query string for search.
  ##   types: JArray
  ##        : Restricts returned entities with these types, e.g. Person
  ## (as defined in http://schema.org/Person). If multiple types are specified,
  ## returned entities will contain one or more of these types.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   indent: bool
  ##         : Enables indenting of json results.
  ##   ids: JArray
  ##      : The list of entity id to be used for search instead of query string.
  ## To specify multiple ids in the HTTP request, repeat the parameter in the
  ## URL as in ...?ids=A&ids=B
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: bool
  ##         : Enables prefix match against names and aliases of entities
  ##   limit: int
  ##        : Limits the number of entities to be returned.
  var query_579916 = newJObject()
  add(query_579916, "upload_protocol", newJString(uploadProtocol))
  add(query_579916, "fields", newJString(fields))
  if languages != nil:
    query_579916.add "languages", languages
  add(query_579916, "quotaUser", newJString(quotaUser))
  add(query_579916, "alt", newJString(alt))
  add(query_579916, "query", newJString(query))
  if types != nil:
    query_579916.add "types", types
  add(query_579916, "oauth_token", newJString(oauthToken))
  add(query_579916, "callback", newJString(callback))
  add(query_579916, "access_token", newJString(accessToken))
  add(query_579916, "uploadType", newJString(uploadType))
  add(query_579916, "indent", newJBool(indent))
  if ids != nil:
    query_579916.add "ids", ids
  add(query_579916, "key", newJString(key))
  add(query_579916, "$.xgafv", newJString(Xgafv))
  add(query_579916, "prettyPrint", newJBool(prettyPrint))
  add(query_579916, "prefix", newJBool(prefix))
  add(query_579916, "limit", newJInt(limit))
  result = call_579915.call(nil, query_579916, nil, nil, nil)

var kgsearchEntitiesSearch* = Call_KgsearchEntitiesSearch_579677(
    name: "kgsearchEntitiesSearch", meth: HttpMethod.HttpGet,
    host: "kgsearch.googleapis.com", route: "/v1/entities:search",
    validator: validate_KgsearchEntitiesSearch_579678, base: "/",
    url: url_KgsearchEntitiesSearch_579679, schemes: {Scheme.Https})
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
