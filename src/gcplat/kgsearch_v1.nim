
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
  gcpServiceName = "kgsearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_KgsearchEntitiesSearch_588710 = ref object of OpenApiRestCall_588441
proc url_KgsearchEntitiesSearch_588712(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_KgsearchEntitiesSearch_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("languages")
  valid_588826 = validateParameter(valid_588826, JArray, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "languages", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("query")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "query", valid_588842
  var valid_588843 = query.getOrDefault("types")
  valid_588843 = validateParameter(valid_588843, JArray, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "types", valid_588843
  var valid_588844 = query.getOrDefault("oauth_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "oauth_token", valid_588844
  var valid_588845 = query.getOrDefault("callback")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "callback", valid_588845
  var valid_588846 = query.getOrDefault("access_token")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "access_token", valid_588846
  var valid_588847 = query.getOrDefault("uploadType")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "uploadType", valid_588847
  var valid_588848 = query.getOrDefault("indent")
  valid_588848 = validateParameter(valid_588848, JBool, required = false, default = nil)
  if valid_588848 != nil:
    section.add "indent", valid_588848
  var valid_588849 = query.getOrDefault("ids")
  valid_588849 = validateParameter(valid_588849, JArray, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "ids", valid_588849
  var valid_588850 = query.getOrDefault("key")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "key", valid_588850
  var valid_588851 = query.getOrDefault("$.xgafv")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = newJString("1"))
  if valid_588851 != nil:
    section.add "$.xgafv", valid_588851
  var valid_588852 = query.getOrDefault("prettyPrint")
  valid_588852 = validateParameter(valid_588852, JBool, required = false,
                                 default = newJBool(true))
  if valid_588852 != nil:
    section.add "prettyPrint", valid_588852
  var valid_588853 = query.getOrDefault("prefix")
  valid_588853 = validateParameter(valid_588853, JBool, required = false, default = nil)
  if valid_588853 != nil:
    section.add "prefix", valid_588853
  var valid_588854 = query.getOrDefault("limit")
  valid_588854 = validateParameter(valid_588854, JInt, required = false, default = nil)
  if valid_588854 != nil:
    section.add "limit", valid_588854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588877: Call_KgsearchEntitiesSearch_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches Knowledge Graph for entities that match the constraints.
  ## A list of matched entities will be returned in response, which will be in
  ## JSON-LD format and compatible with http://schema.org
  ## 
  let valid = call_588877.validator(path, query, header, formData, body)
  let scheme = call_588877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588877.url(scheme.get, call_588877.host, call_588877.base,
                         call_588877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588877, url, valid)

proc call*(call_588948: Call_KgsearchEntitiesSearch_588710;
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
  var query_588949 = newJObject()
  add(query_588949, "upload_protocol", newJString(uploadProtocol))
  add(query_588949, "fields", newJString(fields))
  if languages != nil:
    query_588949.add "languages", languages
  add(query_588949, "quotaUser", newJString(quotaUser))
  add(query_588949, "alt", newJString(alt))
  add(query_588949, "query", newJString(query))
  if types != nil:
    query_588949.add "types", types
  add(query_588949, "oauth_token", newJString(oauthToken))
  add(query_588949, "callback", newJString(callback))
  add(query_588949, "access_token", newJString(accessToken))
  add(query_588949, "uploadType", newJString(uploadType))
  add(query_588949, "indent", newJBool(indent))
  if ids != nil:
    query_588949.add "ids", ids
  add(query_588949, "key", newJString(key))
  add(query_588949, "$.xgafv", newJString(Xgafv))
  add(query_588949, "prettyPrint", newJBool(prettyPrint))
  add(query_588949, "prefix", newJBool(prefix))
  add(query_588949, "limit", newJInt(limit))
  result = call_588948.call(nil, query_588949, nil, nil, nil)

var kgsearchEntitiesSearch* = Call_KgsearchEntitiesSearch_588710(
    name: "kgsearchEntitiesSearch", meth: HttpMethod.HttpGet,
    host: "kgsearch.googleapis.com", route: "/v1/entities:search",
    validator: validate_KgsearchEntitiesSearch_588711, base: "/",
    url: url_KgsearchEntitiesSearch_588712, schemes: {Scheme.Https})
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
