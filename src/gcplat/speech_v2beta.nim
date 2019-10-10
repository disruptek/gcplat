
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Speech-to-Text
## version: v2beta
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Converts audio to text by applying powerful neural network models.
## 
## https://cloud.google.com/speech-to-text/docs/quickstart-protocol
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
  gcpServiceName = "speech"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpeechProjectsLocationsOperationsGet_588710 = ref object of OpenApiRestCall_588441
proc url_SpeechProjectsLocationsOperationsGet_588712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechProjectsLocationsOperationsGet_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_SpeechProjectsLocationsOperationsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_SpeechProjectsLocationsOperationsGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## speechProjectsLocationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var speechProjectsLocationsOperationsGet* = Call_SpeechProjectsLocationsOperationsGet_588710(
    name: "speechProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v2beta/{name}",
    validator: validate_SpeechProjectsLocationsOperationsGet_588711, base: "/",
    url: url_SpeechProjectsLocationsOperationsGet_588712, schemes: {Scheme.Https})
type
  Call_SpeechProjectsLocationsOperationsList_588998 = ref object of OpenApiRestCall_588441
proc url_SpeechProjectsLocationsOperationsList_589000(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechProjectsLocationsOperationsList_588999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("pageToken")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "pageToken", valid_589004
  var valid_589005 = query.getOrDefault("quotaUser")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "quotaUser", valid_589005
  var valid_589006 = query.getOrDefault("alt")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("json"))
  if valid_589006 != nil:
    section.add "alt", valid_589006
  var valid_589007 = query.getOrDefault("oauth_token")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "oauth_token", valid_589007
  var valid_589008 = query.getOrDefault("callback")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "callback", valid_589008
  var valid_589009 = query.getOrDefault("access_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "access_token", valid_589009
  var valid_589010 = query.getOrDefault("uploadType")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "uploadType", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("pageSize")
  valid_589013 = validateParameter(valid_589013, JInt, required = false, default = nil)
  if valid_589013 != nil:
    section.add "pageSize", valid_589013
  var valid_589014 = query.getOrDefault("prettyPrint")
  valid_589014 = validateParameter(valid_589014, JBool, required = false,
                                 default = newJBool(true))
  if valid_589014 != nil:
    section.add "prettyPrint", valid_589014
  var valid_589015 = query.getOrDefault("filter")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "filter", valid_589015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589016: Call_SpeechProjectsLocationsOperationsList_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_589016.validator(path, query, header, formData, body)
  let scheme = call_589016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589016.url(scheme.get, call_589016.host, call_589016.base,
                         call_589016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589016, url, valid)

proc call*(call_589017: Call_SpeechProjectsLocationsOperationsList_588998;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## speechProjectsLocationsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589018 = newJObject()
  var query_589019 = newJObject()
  add(query_589019, "upload_protocol", newJString(uploadProtocol))
  add(query_589019, "fields", newJString(fields))
  add(query_589019, "pageToken", newJString(pageToken))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(path_589018, "name", newJString(name))
  add(query_589019, "alt", newJString(alt))
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "callback", newJString(callback))
  add(query_589019, "access_token", newJString(accessToken))
  add(query_589019, "uploadType", newJString(uploadType))
  add(query_589019, "key", newJString(key))
  add(query_589019, "$.xgafv", newJString(Xgafv))
  add(query_589019, "pageSize", newJInt(pageSize))
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  add(query_589019, "filter", newJString(filter))
  result = call_589017.call(path_589018, query_589019, nil, nil, nil)

var speechProjectsLocationsOperationsList* = Call_SpeechProjectsLocationsOperationsList_588998(
    name: "speechProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v2beta/{name}/operations",
    validator: validate_SpeechProjectsLocationsOperationsList_588999, base: "/",
    url: url_SpeechProjectsLocationsOperationsList_589000, schemes: {Scheme.Https})
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
