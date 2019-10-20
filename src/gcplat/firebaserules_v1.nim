
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Firebase Rules
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages rules that determine when a Firebase Rules-enabled service should permit a request.
## 
## 
## https://firebase.google.com/docs/storage/security
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
  gcpServiceName = "firebaserules"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaserulesProjectsReleasesGet_578610 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsReleasesGet_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesGet_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a `Release` by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_FirebaserulesProjectsReleasesGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a `Release` by name.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_FirebaserulesProjectsReleasesGet_578610; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsReleasesGet
  ## Get a `Release` by name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var firebaserulesProjectsReleasesGet* = Call_FirebaserulesProjectsReleasesGet_578610(
    name: "firebaserulesProjectsReleasesGet", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}",
    validator: validate_FirebaserulesProjectsReleasesGet_578611, base: "/",
    url: url_FirebaserulesProjectsReleasesGet_578612, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesPatch_578917 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsReleasesPatch_578919(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesPatch_578918(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a `Release` via PATCH.
  ## 
  ## Only updates to the `ruleset_name` and `test_suite_name` fields will be
  ## honored. `Release` rename is not supported. To create a `Release` use the
  ## CreateRelease method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578920 = path.getOrDefault("name")
  valid_578920 = validateParameter(valid_578920, JString, required = true,
                                 default = nil)
  if valid_578920 != nil:
    section.add "name", valid_578920
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578921 = query.getOrDefault("key")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "key", valid_578921
  var valid_578922 = query.getOrDefault("prettyPrint")
  valid_578922 = validateParameter(valid_578922, JBool, required = false,
                                 default = newJBool(true))
  if valid_578922 != nil:
    section.add "prettyPrint", valid_578922
  var valid_578923 = query.getOrDefault("oauth_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "oauth_token", valid_578923
  var valid_578924 = query.getOrDefault("$.xgafv")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("1"))
  if valid_578924 != nil:
    section.add "$.xgafv", valid_578924
  var valid_578925 = query.getOrDefault("alt")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("json"))
  if valid_578925 != nil:
    section.add "alt", valid_578925
  var valid_578926 = query.getOrDefault("uploadType")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "uploadType", valid_578926
  var valid_578927 = query.getOrDefault("quotaUser")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "quotaUser", valid_578927
  var valid_578928 = query.getOrDefault("callback")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "callback", valid_578928
  var valid_578929 = query.getOrDefault("fields")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "fields", valid_578929
  var valid_578930 = query.getOrDefault("access_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "access_token", valid_578930
  var valid_578931 = query.getOrDefault("upload_protocol")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "upload_protocol", valid_578931
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

proc call*(call_578933: Call_FirebaserulesProjectsReleasesPatch_578917;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a `Release` via PATCH.
  ## 
  ## Only updates to the `ruleset_name` and `test_suite_name` fields will be
  ## honored. `Release` rename is not supported. To create a `Release` use the
  ## CreateRelease method.
  ## 
  let valid = call_578933.validator(path, query, header, formData, body)
  let scheme = call_578933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578933.url(scheme.get, call_578933.host, call_578933.base,
                         call_578933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578933, url, valid)

proc call*(call_578934: Call_FirebaserulesProjectsReleasesPatch_578917;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsReleasesPatch
  ## Update a `Release` via PATCH.
  ## 
  ## Only updates to the `ruleset_name` and `test_suite_name` fields will be
  ## honored. `Release` rename is not supported. To create a `Release` use the
  ## CreateRelease method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578935 = newJObject()
  var query_578936 = newJObject()
  var body_578937 = newJObject()
  add(query_578936, "key", newJString(key))
  add(query_578936, "prettyPrint", newJBool(prettyPrint))
  add(query_578936, "oauth_token", newJString(oauthToken))
  add(query_578936, "$.xgafv", newJString(Xgafv))
  add(query_578936, "alt", newJString(alt))
  add(query_578936, "uploadType", newJString(uploadType))
  add(query_578936, "quotaUser", newJString(quotaUser))
  add(path_578935, "name", newJString(name))
  if body != nil:
    body_578937 = body
  add(query_578936, "callback", newJString(callback))
  add(query_578936, "fields", newJString(fields))
  add(query_578936, "access_token", newJString(accessToken))
  add(query_578936, "upload_protocol", newJString(uploadProtocol))
  result = call_578934.call(path_578935, query_578936, nil, nil, body_578937)

var firebaserulesProjectsReleasesPatch* = Call_FirebaserulesProjectsReleasesPatch_578917(
    name: "firebaserulesProjectsReleasesPatch", meth: HttpMethod.HttpPatch,
    host: "firebaserules.googleapis.com", route: "/v1/{name}",
    validator: validate_FirebaserulesProjectsReleasesPatch_578918, base: "/",
    url: url_FirebaserulesProjectsReleasesPatch_578919, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesDelete_578898 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsReleasesDelete_578900(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesDelete_578899(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a `Release` by resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the `Release` to delete.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_FirebaserulesProjectsReleasesDelete_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a `Release` by resource name.
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_FirebaserulesProjectsReleasesDelete_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsReleasesDelete
  ## Delete a `Release` by resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the `Release` to delete.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578915 = newJObject()
  var query_578916 = newJObject()
  add(query_578916, "key", newJString(key))
  add(query_578916, "prettyPrint", newJBool(prettyPrint))
  add(query_578916, "oauth_token", newJString(oauthToken))
  add(query_578916, "$.xgafv", newJString(Xgafv))
  add(query_578916, "alt", newJString(alt))
  add(query_578916, "uploadType", newJString(uploadType))
  add(query_578916, "quotaUser", newJString(quotaUser))
  add(path_578915, "name", newJString(name))
  add(query_578916, "callback", newJString(callback))
  add(query_578916, "fields", newJString(fields))
  add(query_578916, "access_token", newJString(accessToken))
  add(query_578916, "upload_protocol", newJString(uploadProtocol))
  result = call_578914.call(path_578915, query_578916, nil, nil, nil)

var firebaserulesProjectsReleasesDelete* = Call_FirebaserulesProjectsReleasesDelete_578898(
    name: "firebaserulesProjectsReleasesDelete", meth: HttpMethod.HttpDelete,
    host: "firebaserules.googleapis.com", route: "/v1/{name}",
    validator: validate_FirebaserulesProjectsReleasesDelete_578899, base: "/",
    url: url_FirebaserulesProjectsReleasesDelete_578900, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesCreate_578960 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsReleasesCreate_578962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesCreate_578961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a `Release`.
  ## 
  ## Release names should reflect the developer's deployment practices. For
  ## example, the release name may include the environment name, application
  ## name, application version, or any other name meaningful to the developer.
  ## Once a `Release` refers to a `Ruleset`, the rules can be enforced by
  ## Firebase Rules-enabled services.
  ## 
  ## More than one `Release` may be 'live' concurrently. Consider the following
  ## three `Release` names for `projects/foo` and the `Ruleset` to which they
  ## refer.
  ## 
  ## Release Name                    | Ruleset Name
  ## --------------------------------|-------------
  ## projects/foo/releases/prod      | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/beta | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/v23  | projects/foo/rulesets/uuid456
  ## 
  ## The table reflects the `Ruleset` rollout in progress. The `prod` and
  ## `prod/beta` releases refer to the same `Ruleset`. However, `prod/v23`
  ## refers to a new `Ruleset`. The `Ruleset` reference for a `Release` may be
  ## updated using the UpdateRelease method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578963 = path.getOrDefault("name")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "name", valid_578963
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578964 = query.getOrDefault("key")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "key", valid_578964
  var valid_578965 = query.getOrDefault("prettyPrint")
  valid_578965 = validateParameter(valid_578965, JBool, required = false,
                                 default = newJBool(true))
  if valid_578965 != nil:
    section.add "prettyPrint", valid_578965
  var valid_578966 = query.getOrDefault("oauth_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "oauth_token", valid_578966
  var valid_578967 = query.getOrDefault("$.xgafv")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("1"))
  if valid_578967 != nil:
    section.add "$.xgafv", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("uploadType")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "uploadType", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("callback")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "callback", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
  var valid_578973 = query.getOrDefault("access_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "access_token", valid_578973
  var valid_578974 = query.getOrDefault("upload_protocol")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "upload_protocol", valid_578974
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

proc call*(call_578976: Call_FirebaserulesProjectsReleasesCreate_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a `Release`.
  ## 
  ## Release names should reflect the developer's deployment practices. For
  ## example, the release name may include the environment name, application
  ## name, application version, or any other name meaningful to the developer.
  ## Once a `Release` refers to a `Ruleset`, the rules can be enforced by
  ## Firebase Rules-enabled services.
  ## 
  ## More than one `Release` may be 'live' concurrently. Consider the following
  ## three `Release` names for `projects/foo` and the `Ruleset` to which they
  ## refer.
  ## 
  ## Release Name                    | Ruleset Name
  ## --------------------------------|-------------
  ## projects/foo/releases/prod      | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/beta | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/v23  | projects/foo/rulesets/uuid456
  ## 
  ## The table reflects the `Ruleset` rollout in progress. The `prod` and
  ## `prod/beta` releases refer to the same `Ruleset`. However, `prod/v23`
  ## refers to a new `Ruleset`. The `Ruleset` reference for a `Release` may be
  ## updated using the UpdateRelease method.
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_FirebaserulesProjectsReleasesCreate_578960;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsReleasesCreate
  ## Create a `Release`.
  ## 
  ## Release names should reflect the developer's deployment practices. For
  ## example, the release name may include the environment name, application
  ## name, application version, or any other name meaningful to the developer.
  ## Once a `Release` refers to a `Ruleset`, the rules can be enforced by
  ## Firebase Rules-enabled services.
  ## 
  ## More than one `Release` may be 'live' concurrently. Consider the following
  ## three `Release` names for `projects/foo` and the `Ruleset` to which they
  ## refer.
  ## 
  ## Release Name                    | Ruleset Name
  ## --------------------------------|-------------
  ## projects/foo/releases/prod      | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/beta | projects/foo/rulesets/uuid123
  ## projects/foo/releases/prod/v23  | projects/foo/rulesets/uuid456
  ## 
  ## The table reflects the `Ruleset` rollout in progress. The `prod` and
  ## `prod/beta` releases refer to the same `Ruleset`. However, `prod/v23`
  ## refers to a new `Ruleset`. The `Ruleset` reference for a `Release` may be
  ## updated using the UpdateRelease method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project which owns this `Release`.
  ## 
  ## Format: `projects/{project_id}`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  var body_578980 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(query_578979, "$.xgafv", newJString(Xgafv))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "uploadType", newJString(uploadType))
  add(query_578979, "quotaUser", newJString(quotaUser))
  add(path_578978, "name", newJString(name))
  if body != nil:
    body_578980 = body
  add(query_578979, "callback", newJString(callback))
  add(query_578979, "fields", newJString(fields))
  add(query_578979, "access_token", newJString(accessToken))
  add(query_578979, "upload_protocol", newJString(uploadProtocol))
  result = call_578977.call(path_578978, query_578979, nil, nil, body_578980)

var firebaserulesProjectsReleasesCreate* = Call_FirebaserulesProjectsReleasesCreate_578960(
    name: "firebaserulesProjectsReleasesCreate", meth: HttpMethod.HttpPost,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/releases",
    validator: validate_FirebaserulesProjectsReleasesCreate_578961, base: "/",
    url: url_FirebaserulesProjectsReleasesCreate_578962, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesList_578938 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsReleasesList_578940(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesList_578939(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the `Release` values for a project. This list may optionally be
  ## filtered by `Release` name, `Ruleset` name, `TestSuite` name, or any
  ## combination thereof.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578941 = path.getOrDefault("name")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "name", valid_578941
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load fewer
  ## than `page_size` results due to the size of the output. To traverse all of
  ## the releases, the caller should iterate until the `page_token` on the
  ## response is empty.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : `Release` filter. The list method supports filters with restrictions on the
  ## `Release.name`, `Release.ruleset_name`, and `Release.test_suite_name`.
  ## 
  ## Example 1: A filter of 'name=prod*' might return `Release`s with names
  ## within 'projects/foo' prefixed with 'prod':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v2 | projects/foo/rulesets/uuid8888
  ## 
  ## Example 2: A filter of `name=prod* ruleset_name=uuid1234` would return only
  ## `Release` instances for 'projects/foo' with names prefixed with 'prod'
  ## referring to the same `Ruleset` name of 'uuid1234':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/1234
  ## 
  ## In the examples, the filter parameters refer to the search filters are
  ## relative to the project. Fully qualified prefixed may also be used. e.g.
  ## `test_suite_name=projects/foo/testsuites/uuid1`
  ##   pageToken: JString
  ##            : Next page token for the next batch of `Release` instances.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578942 = query.getOrDefault("key")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "key", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("$.xgafv")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("1"))
  if valid_578945 != nil:
    section.add "$.xgafv", valid_578945
  var valid_578946 = query.getOrDefault("pageSize")
  valid_578946 = validateParameter(valid_578946, JInt, required = false, default = nil)
  if valid_578946 != nil:
    section.add "pageSize", valid_578946
  var valid_578947 = query.getOrDefault("alt")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("json"))
  if valid_578947 != nil:
    section.add "alt", valid_578947
  var valid_578948 = query.getOrDefault("uploadType")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "uploadType", valid_578948
  var valid_578949 = query.getOrDefault("quotaUser")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "quotaUser", valid_578949
  var valid_578950 = query.getOrDefault("filter")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "filter", valid_578950
  var valid_578951 = query.getOrDefault("pageToken")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "pageToken", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578956: Call_FirebaserulesProjectsReleasesList_578938;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the `Release` values for a project. This list may optionally be
  ## filtered by `Release` name, `Ruleset` name, `TestSuite` name, or any
  ## combination thereof.
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_FirebaserulesProjectsReleasesList_578938;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsReleasesList
  ## List the `Release` values for a project. This list may optionally be
  ## filtered by `Release` name, `Ruleset` name, `TestSuite` name, or any
  ## combination thereof.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load fewer
  ## than `page_size` results due to the size of the output. To traverse all of
  ## the releases, the caller should iterate until the `page_token` on the
  ## response is empty.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
  ##   filter: string
  ##         : `Release` filter. The list method supports filters with restrictions on the
  ## `Release.name`, `Release.ruleset_name`, and `Release.test_suite_name`.
  ## 
  ## Example 1: A filter of 'name=prod*' might return `Release`s with names
  ## within 'projects/foo' prefixed with 'prod':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/uuid1234
  ## projects/foo/releases/prod/v2 | projects/foo/rulesets/uuid8888
  ## 
  ## Example 2: A filter of `name=prod* ruleset_name=uuid1234` would return only
  ## `Release` instances for 'projects/foo' with names prefixed with 'prod'
  ## referring to the same `Ruleset` name of 'uuid1234':
  ## 
  ## Name                          | Ruleset Name
  ## ------------------------------|-------------
  ## projects/foo/releases/prod    | projects/foo/rulesets/1234
  ## projects/foo/releases/prod/v1 | projects/foo/rulesets/1234
  ## 
  ## In the examples, the filter parameters refer to the search filters are
  ## relative to the project. Fully qualified prefixed may also be used. e.g.
  ## `test_suite_name=projects/foo/testsuites/uuid1`
  ##   pageToken: string
  ##            : Next page token for the next batch of `Release` instances.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "$.xgafv", newJString(Xgafv))
  add(query_578959, "pageSize", newJInt(pageSize))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "uploadType", newJString(uploadType))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(path_578958, "name", newJString(name))
  add(query_578959, "filter", newJString(filter))
  add(query_578959, "pageToken", newJString(pageToken))
  add(query_578959, "callback", newJString(callback))
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "access_token", newJString(accessToken))
  add(query_578959, "upload_protocol", newJString(uploadProtocol))
  result = call_578957.call(path_578958, query_578959, nil, nil, nil)

var firebaserulesProjectsReleasesList* = Call_FirebaserulesProjectsReleasesList_578938(
    name: "firebaserulesProjectsReleasesList", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/releases",
    validator: validate_FirebaserulesProjectsReleasesList_578939, base: "/",
    url: url_FirebaserulesProjectsReleasesList_578940, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsRulesetsCreate_579003 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsRulesetsCreate_579005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/rulesets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsRulesetsCreate_579004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a `Ruleset` from `Source`.
  ## 
  ## The `Ruleset` is given a unique generated name which is returned to the
  ## caller. `Source` containing syntactic or semantics errors will result in an
  ## error response indicating the first error encountered. For a detailed view
  ## of `Source` issues, use TestRuleset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for Project which owns this `Ruleset`.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579006 = path.getOrDefault("name")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "name", valid_579006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("$.xgafv")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("1"))
  if valid_579010 != nil:
    section.add "$.xgafv", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("uploadType")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "uploadType", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("callback")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "callback", valid_579014
  var valid_579015 = query.getOrDefault("fields")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "fields", valid_579015
  var valid_579016 = query.getOrDefault("access_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "access_token", valid_579016
  var valid_579017 = query.getOrDefault("upload_protocol")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "upload_protocol", valid_579017
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

proc call*(call_579019: Call_FirebaserulesProjectsRulesetsCreate_579003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a `Ruleset` from `Source`.
  ## 
  ## The `Ruleset` is given a unique generated name which is returned to the
  ## caller. `Source` containing syntactic or semantics errors will result in an
  ## error response indicating the first error encountered. For a detailed view
  ## of `Source` issues, use TestRuleset.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_FirebaserulesProjectsRulesetsCreate_579003;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsRulesetsCreate
  ## Create a `Ruleset` from `Source`.
  ## 
  ## The `Ruleset` is given a unique generated name which is returned to the
  ## caller. `Source` containing syntactic or semantics errors will result in an
  ## error response indicating the first error encountered. For a detailed view
  ## of `Source` issues, use TestRuleset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for Project which owns this `Ruleset`.
  ## 
  ## Format: `projects/{project_id}`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  var body_579023 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(query_579022, "$.xgafv", newJString(Xgafv))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "uploadType", newJString(uploadType))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(path_579021, "name", newJString(name))
  if body != nil:
    body_579023 = body
  add(query_579022, "callback", newJString(callback))
  add(query_579022, "fields", newJString(fields))
  add(query_579022, "access_token", newJString(accessToken))
  add(query_579022, "upload_protocol", newJString(uploadProtocol))
  result = call_579020.call(path_579021, query_579022, nil, nil, body_579023)

var firebaserulesProjectsRulesetsCreate* = Call_FirebaserulesProjectsRulesetsCreate_579003(
    name: "firebaserulesProjectsRulesetsCreate", meth: HttpMethod.HttpPost,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/rulesets",
    validator: validate_FirebaserulesProjectsRulesetsCreate_579004, base: "/",
    url: url_FirebaserulesProjectsRulesetsCreate_579005, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsRulesetsList_578981 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsRulesetsList_578983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/rulesets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsRulesetsList_578982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List `Ruleset` metadata only and optionally filter the results by `Ruleset`
  ## name.
  ## 
  ## The full `Source` contents of a `Ruleset` may be retrieved with
  ## GetRuleset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578984 = path.getOrDefault("name")
  valid_578984 = validateParameter(valid_578984, JString, required = true,
                                 default = nil)
  if valid_578984 != nil:
    section.add "name", valid_578984
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load less
  ## than `page_size` due to the size of the output. To traverse all of the
  ## releases, caller should iterate until the `page_token` is empty.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : `Ruleset` filter. The list method supports filters with restrictions on
  ## `Ruleset.name`.
  ## 
  ## Filters on `Ruleset.create_time` should use the `date` function which
  ## parses strings that conform to the RFC 3339 date/time specifications.
  ## 
  ## Example: `create_time > date("2017-01-01T00:00:00Z") AND name=UUID-*`
  ##   pageToken: JString
  ##            : Next page token for loading the next batch of `Ruleset` instances.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578985 = query.getOrDefault("key")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "key", valid_578985
  var valid_578986 = query.getOrDefault("prettyPrint")
  valid_578986 = validateParameter(valid_578986, JBool, required = false,
                                 default = newJBool(true))
  if valid_578986 != nil:
    section.add "prettyPrint", valid_578986
  var valid_578987 = query.getOrDefault("oauth_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "oauth_token", valid_578987
  var valid_578988 = query.getOrDefault("$.xgafv")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("1"))
  if valid_578988 != nil:
    section.add "$.xgafv", valid_578988
  var valid_578989 = query.getOrDefault("pageSize")
  valid_578989 = validateParameter(valid_578989, JInt, required = false, default = nil)
  if valid_578989 != nil:
    section.add "pageSize", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("uploadType")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "uploadType", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("filter")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "filter", valid_578993
  var valid_578994 = query.getOrDefault("pageToken")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "pageToken", valid_578994
  var valid_578995 = query.getOrDefault("callback")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "callback", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
  var valid_578997 = query.getOrDefault("access_token")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "access_token", valid_578997
  var valid_578998 = query.getOrDefault("upload_protocol")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "upload_protocol", valid_578998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578999: Call_FirebaserulesProjectsRulesetsList_578981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List `Ruleset` metadata only and optionally filter the results by `Ruleset`
  ## name.
  ## 
  ## The full `Source` contents of a `Ruleset` may be retrieved with
  ## GetRuleset.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_FirebaserulesProjectsRulesetsList_578981;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsRulesetsList
  ## List `Ruleset` metadata only and optionally filter the results by `Ruleset`
  ## name.
  ## 
  ## The full `Source` contents of a `Ruleset` may be retrieved with
  ## GetRuleset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size to load. Maximum of 100. Defaults to 10.
  ## Note: `page_size` is just a hint and the service may choose to load less
  ## than `page_size` due to the size of the output. To traverse all of the
  ## releases, caller should iterate until the `page_token` is empty.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the project.
  ## 
  ## Format: `projects/{project_id}`
  ##   filter: string
  ##         : `Ruleset` filter. The list method supports filters with restrictions on
  ## `Ruleset.name`.
  ## 
  ## Filters on `Ruleset.create_time` should use the `date` function which
  ## parses strings that conform to the RFC 3339 date/time specifications.
  ## 
  ## Example: `create_time > date("2017-01-01T00:00:00Z") AND name=UUID-*`
  ##   pageToken: string
  ##            : Next page token for loading the next batch of `Ruleset` instances.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(query_579002, "pageSize", newJInt(pageSize))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(path_579001, "name", newJString(name))
  add(query_579002, "filter", newJString(filter))
  add(query_579002, "pageToken", newJString(pageToken))
  add(query_579002, "callback", newJString(callback))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, nil)

var firebaserulesProjectsRulesetsList* = Call_FirebaserulesProjectsRulesetsList_578981(
    name: "firebaserulesProjectsRulesetsList", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}/rulesets",
    validator: validate_FirebaserulesProjectsRulesetsList_578982, base: "/",
    url: url_FirebaserulesProjectsRulesetsList_578983, schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsReleasesGetExecutable_579024 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsReleasesGetExecutable_579026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":getExecutable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsReleasesGetExecutable_579025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the `Release` executable to use when enforcing rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579027 = path.getOrDefault("name")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "name", valid_579027
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   executableVersion: JString
  ##                    : The requested runtime executable version.
  ## Defaults to FIREBASE_RULES_EXECUTABLE_V1.
  section = newJObject()
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("$.xgafv")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("1"))
  if valid_579031 != nil:
    section.add "$.xgafv", valid_579031
  var valid_579032 = query.getOrDefault("alt")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("json"))
  if valid_579032 != nil:
    section.add "alt", valid_579032
  var valid_579033 = query.getOrDefault("uploadType")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "uploadType", valid_579033
  var valid_579034 = query.getOrDefault("quotaUser")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "quotaUser", valid_579034
  var valid_579035 = query.getOrDefault("callback")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "callback", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  var valid_579037 = query.getOrDefault("access_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "access_token", valid_579037
  var valid_579038 = query.getOrDefault("upload_protocol")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "upload_protocol", valid_579038
  var valid_579039 = query.getOrDefault("executableVersion")
  valid_579039 = validateParameter(valid_579039, JString, required = false, default = newJString(
      "RELEASE_EXECUTABLE_VERSION_UNSPECIFIED"))
  if valid_579039 != nil:
    section.add "executableVersion", valid_579039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579040: Call_FirebaserulesProjectsReleasesGetExecutable_579024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the `Release` executable to use when enforcing rules.
  ## 
  let valid = call_579040.validator(path, query, header, formData, body)
  let scheme = call_579040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579040.url(scheme.get, call_579040.host, call_579040.base,
                         call_579040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579040, url, valid)

proc call*(call_579041: Call_FirebaserulesProjectsReleasesGetExecutable_579024;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          executableVersion: string = "RELEASE_EXECUTABLE_VERSION_UNSPECIFIED"): Recallable =
  ## firebaserulesProjectsReleasesGetExecutable
  ## Get the `Release` executable to use when enforcing rules.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the `Release`.
  ## 
  ## Format: `projects/{project_id}/releases/{release_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   executableVersion: string
  ##                    : The requested runtime executable version.
  ## Defaults to FIREBASE_RULES_EXECUTABLE_V1.
  var path_579042 = newJObject()
  var query_579043 = newJObject()
  add(query_579043, "key", newJString(key))
  add(query_579043, "prettyPrint", newJBool(prettyPrint))
  add(query_579043, "oauth_token", newJString(oauthToken))
  add(query_579043, "$.xgafv", newJString(Xgafv))
  add(query_579043, "alt", newJString(alt))
  add(query_579043, "uploadType", newJString(uploadType))
  add(query_579043, "quotaUser", newJString(quotaUser))
  add(path_579042, "name", newJString(name))
  add(query_579043, "callback", newJString(callback))
  add(query_579043, "fields", newJString(fields))
  add(query_579043, "access_token", newJString(accessToken))
  add(query_579043, "upload_protocol", newJString(uploadProtocol))
  add(query_579043, "executableVersion", newJString(executableVersion))
  result = call_579041.call(path_579042, query_579043, nil, nil, nil)

var firebaserulesProjectsReleasesGetExecutable* = Call_FirebaserulesProjectsReleasesGetExecutable_579024(
    name: "firebaserulesProjectsReleasesGetExecutable", meth: HttpMethod.HttpGet,
    host: "firebaserules.googleapis.com", route: "/v1/{name}:getExecutable",
    validator: validate_FirebaserulesProjectsReleasesGetExecutable_579025,
    base: "/", url: url_FirebaserulesProjectsReleasesGetExecutable_579026,
    schemes: {Scheme.Https})
type
  Call_FirebaserulesProjectsTest_579044 = ref object of OpenApiRestCall_578339
proc url_FirebaserulesProjectsTest_579046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":test")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaserulesProjectsTest_579045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Test `Source` for syntactic and semantic correctness. Issues present, if
  ## any, will be returned to the caller with a description, severity, and
  ## source location.
  ## 
  ## The test method may be executed with `Source` or a `Ruleset` name.
  ## Passing `Source` is useful for unit testing new rules. Passing a `Ruleset`
  ## name is useful for regression testing an existing rule.
  ## 
  ## The following is an example of `Source` that permits users to upload images
  ## to a bucket bearing their user id and matching the correct metadata:
  ## 
  ## _*Example*_
  ## 
  ##     // Users are allowed to subscribe and unsubscribe to the blog.
  ##     service firebase.storage {
  ##       match /users/{userId}/images/{imageName} {
  ##           allow write: if userId == request.auth.uid
  ##               && (imageName.matches('*.png$')
  ##               || imageName.matches('*.jpg$'))
  ##               && resource.mimeType.matches('^image/')
  ##       }
  ##     }
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Tests may either provide `source` or a `Ruleset` resource name.
  ## 
  ## For tests against `source`, the resource name must refer to the project:
  ## Format: `projects/{project_id}`
  ## 
  ## For tests against a `Ruleset`, this must be the `Ruleset` resource name:
  ## Format: `projects/{project_id}/rulesets/{ruleset_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579047 = path.getOrDefault("name")
  valid_579047 = validateParameter(valid_579047, JString, required = true,
                                 default = nil)
  if valid_579047 != nil:
    section.add "name", valid_579047
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579048 = query.getOrDefault("key")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "key", valid_579048
  var valid_579049 = query.getOrDefault("prettyPrint")
  valid_579049 = validateParameter(valid_579049, JBool, required = false,
                                 default = newJBool(true))
  if valid_579049 != nil:
    section.add "prettyPrint", valid_579049
  var valid_579050 = query.getOrDefault("oauth_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "oauth_token", valid_579050
  var valid_579051 = query.getOrDefault("$.xgafv")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("1"))
  if valid_579051 != nil:
    section.add "$.xgafv", valid_579051
  var valid_579052 = query.getOrDefault("alt")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("json"))
  if valid_579052 != nil:
    section.add "alt", valid_579052
  var valid_579053 = query.getOrDefault("uploadType")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "uploadType", valid_579053
  var valid_579054 = query.getOrDefault("quotaUser")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "quotaUser", valid_579054
  var valid_579055 = query.getOrDefault("callback")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "callback", valid_579055
  var valid_579056 = query.getOrDefault("fields")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "fields", valid_579056
  var valid_579057 = query.getOrDefault("access_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "access_token", valid_579057
  var valid_579058 = query.getOrDefault("upload_protocol")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "upload_protocol", valid_579058
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

proc call*(call_579060: Call_FirebaserulesProjectsTest_579044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test `Source` for syntactic and semantic correctness. Issues present, if
  ## any, will be returned to the caller with a description, severity, and
  ## source location.
  ## 
  ## The test method may be executed with `Source` or a `Ruleset` name.
  ## Passing `Source` is useful for unit testing new rules. Passing a `Ruleset`
  ## name is useful for regression testing an existing rule.
  ## 
  ## The following is an example of `Source` that permits users to upload images
  ## to a bucket bearing their user id and matching the correct metadata:
  ## 
  ## _*Example*_
  ## 
  ##     // Users are allowed to subscribe and unsubscribe to the blog.
  ##     service firebase.storage {
  ##       match /users/{userId}/images/{imageName} {
  ##           allow write: if userId == request.auth.uid
  ##               && (imageName.matches('*.png$')
  ##               || imageName.matches('*.jpg$'))
  ##               && resource.mimeType.matches('^image/')
  ##       }
  ##     }
  ## 
  let valid = call_579060.validator(path, query, header, formData, body)
  let scheme = call_579060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579060.url(scheme.get, call_579060.host, call_579060.base,
                         call_579060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579060, url, valid)

proc call*(call_579061: Call_FirebaserulesProjectsTest_579044; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaserulesProjectsTest
  ## Test `Source` for syntactic and semantic correctness. Issues present, if
  ## any, will be returned to the caller with a description, severity, and
  ## source location.
  ## 
  ## The test method may be executed with `Source` or a `Ruleset` name.
  ## Passing `Source` is useful for unit testing new rules. Passing a `Ruleset`
  ## name is useful for regression testing an existing rule.
  ## 
  ## The following is an example of `Source` that permits users to upload images
  ## to a bucket bearing their user id and matching the correct metadata:
  ## 
  ## _*Example*_
  ## 
  ##     // Users are allowed to subscribe and unsubscribe to the blog.
  ##     service firebase.storage {
  ##       match /users/{userId}/images/{imageName} {
  ##           allow write: if userId == request.auth.uid
  ##               && (imageName.matches('*.png$')
  ##               || imageName.matches('*.jpg$'))
  ##               && resource.mimeType.matches('^image/')
  ##       }
  ##     }
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Tests may either provide `source` or a `Ruleset` resource name.
  ## 
  ## For tests against `source`, the resource name must refer to the project:
  ## Format: `projects/{project_id}`
  ## 
  ## For tests against a `Ruleset`, this must be the `Ruleset` resource name:
  ## Format: `projects/{project_id}/rulesets/{ruleset_id}`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579062 = newJObject()
  var query_579063 = newJObject()
  var body_579064 = newJObject()
  add(query_579063, "key", newJString(key))
  add(query_579063, "prettyPrint", newJBool(prettyPrint))
  add(query_579063, "oauth_token", newJString(oauthToken))
  add(query_579063, "$.xgafv", newJString(Xgafv))
  add(query_579063, "alt", newJString(alt))
  add(query_579063, "uploadType", newJString(uploadType))
  add(query_579063, "quotaUser", newJString(quotaUser))
  add(path_579062, "name", newJString(name))
  if body != nil:
    body_579064 = body
  add(query_579063, "callback", newJString(callback))
  add(query_579063, "fields", newJString(fields))
  add(query_579063, "access_token", newJString(accessToken))
  add(query_579063, "upload_protocol", newJString(uploadProtocol))
  result = call_579061.call(path_579062, query_579063, nil, nil, body_579064)

var firebaserulesProjectsTest* = Call_FirebaserulesProjectsTest_579044(
    name: "firebaserulesProjectsTest", meth: HttpMethod.HttpPost,
    host: "firebaserules.googleapis.com", route: "/v1/{name}:test",
    validator: validate_FirebaserulesProjectsTest_579045, base: "/",
    url: url_FirebaserulesProjectsTest_579046, schemes: {Scheme.Https})
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
