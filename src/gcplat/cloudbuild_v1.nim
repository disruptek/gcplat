
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Build
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages builds on Google Cloud Platform.
## 
## https://cloud.google.com/cloud-build/docs/
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
  gcpServiceName = "cloudbuild"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbuildProjectsBuildsCreate_578901 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsBuildsCreate_578903(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/builds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsBuildsCreate_578902(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a build with the specified configuration.
  ## 
  ## This method returns a long-running `Operation`, which includes the build
  ## ID. Pass the build ID to `GetBuild` to determine the build status (such as
  ## `SUCCESS` or `FAILURE`).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578904 = path.getOrDefault("projectId")
  valid_578904 = validateParameter(valid_578904, JString, required = true,
                                 default = nil)
  if valid_578904 != nil:
    section.add "projectId", valid_578904
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
  var valid_578905 = query.getOrDefault("key")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "key", valid_578905
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("$.xgafv")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("1"))
  if valid_578908 != nil:
    section.add "$.xgafv", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("uploadType")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "uploadType", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("callback")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "callback", valid_578912
  var valid_578913 = query.getOrDefault("fields")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "fields", valid_578913
  var valid_578914 = query.getOrDefault("access_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "access_token", valid_578914
  var valid_578915 = query.getOrDefault("upload_protocol")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "upload_protocol", valid_578915
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

proc call*(call_578917: Call_CloudbuildProjectsBuildsCreate_578901; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a build with the specified configuration.
  ## 
  ## This method returns a long-running `Operation`, which includes the build
  ## ID. Pass the build ID to `GetBuild` to determine the build status (such as
  ## `SUCCESS` or `FAILURE`).
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_CloudbuildProjectsBuildsCreate_578901;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsBuildsCreate
  ## Starts a build with the specified configuration.
  ## 
  ## This method returns a long-running `Operation`, which includes the build
  ## ID. Pass the build ID to `GetBuild` to determine the build status (such as
  ## `SUCCESS` or `FAILURE`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578919 = newJObject()
  var query_578920 = newJObject()
  var body_578921 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(path_578919, "projectId", newJString(projectId))
  add(query_578920, "$.xgafv", newJString(Xgafv))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "uploadType", newJString(uploadType))
  add(query_578920, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578921 = body
  add(query_578920, "callback", newJString(callback))
  add(query_578920, "fields", newJString(fields))
  add(query_578920, "access_token", newJString(accessToken))
  add(query_578920, "upload_protocol", newJString(uploadProtocol))
  result = call_578918.call(path_578919, query_578920, nil, nil, body_578921)

var cloudbuildProjectsBuildsCreate* = Call_CloudbuildProjectsBuildsCreate_578901(
    name: "cloudbuildProjectsBuildsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsCreate_578902, base: "/",
    url: url_CloudbuildProjectsBuildsCreate_578903, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsList_578610 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsBuildsList_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/builds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsBuildsList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists previously requested builds.
  ## 
  ## Previously requested builds may still be in-progress, or may have finished
  ## successfully or unsuccessfully.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578738 = path.getOrDefault("projectId")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "projectId", valid_578738
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
  ##           : Number of results to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The raw filter text to constrain the results.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  var valid_578756 = query.getOrDefault("pageSize")
  valid_578756 = validateParameter(valid_578756, JInt, required = false, default = nil)
  if valid_578756 != nil:
    section.add "pageSize", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("uploadType")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "uploadType", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  var valid_578760 = query.getOrDefault("filter")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "filter", valid_578760
  var valid_578761 = query.getOrDefault("pageToken")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "pageToken", valid_578761
  var valid_578762 = query.getOrDefault("callback")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "callback", valid_578762
  var valid_578763 = query.getOrDefault("fields")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "fields", valid_578763
  var valid_578764 = query.getOrDefault("access_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "access_token", valid_578764
  var valid_578765 = query.getOrDefault("upload_protocol")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "upload_protocol", valid_578765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578788: Call_CloudbuildProjectsBuildsList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists previously requested builds.
  ## 
  ## Previously requested builds may still be in-progress, or may have finished
  ## successfully or unsuccessfully.
  ## 
  let valid = call_578788.validator(path, query, header, formData, body)
  let scheme = call_578788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578788.url(scheme.get, call_578788.host, call_578788.base,
                         call_578788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578788, url, valid)

proc call*(call_578859: Call_CloudbuildProjectsBuildsList_578610;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsBuildsList
  ## Lists previously requested builds.
  ## 
  ## Previously requested builds may still be in-progress, or may have finished
  ## successfully or unsuccessfully.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of results to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The raw filter text to constrain the results.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578860 = newJObject()
  var query_578862 = newJObject()
  add(query_578862, "key", newJString(key))
  add(query_578862, "prettyPrint", newJBool(prettyPrint))
  add(query_578862, "oauth_token", newJString(oauthToken))
  add(path_578860, "projectId", newJString(projectId))
  add(query_578862, "$.xgafv", newJString(Xgafv))
  add(query_578862, "pageSize", newJInt(pageSize))
  add(query_578862, "alt", newJString(alt))
  add(query_578862, "uploadType", newJString(uploadType))
  add(query_578862, "quotaUser", newJString(quotaUser))
  add(query_578862, "filter", newJString(filter))
  add(query_578862, "pageToken", newJString(pageToken))
  add(query_578862, "callback", newJString(callback))
  add(query_578862, "fields", newJString(fields))
  add(query_578862, "access_token", newJString(accessToken))
  add(query_578862, "upload_protocol", newJString(uploadProtocol))
  result = call_578859.call(path_578860, query_578862, nil, nil, nil)

var cloudbuildProjectsBuildsList* = Call_CloudbuildProjectsBuildsList_578610(
    name: "cloudbuildProjectsBuildsList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsList_578611, base: "/",
    url: url_CloudbuildProjectsBuildsList_578612, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsGet_578922 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsBuildsGet_578924(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/builds/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsBuildsGet_578923(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project.
  ##   id: JString (required)
  ##     : ID of the build.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578925 = path.getOrDefault("projectId")
  valid_578925 = validateParameter(valid_578925, JString, required = true,
                                 default = nil)
  if valid_578925 != nil:
    section.add "projectId", valid_578925
  var valid_578926 = path.getOrDefault("id")
  valid_578926 = validateParameter(valid_578926, JString, required = true,
                                 default = nil)
  if valid_578926 != nil:
    section.add "id", valid_578926
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
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("$.xgafv")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("1"))
  if valid_578930 != nil:
    section.add "$.xgafv", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("uploadType")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "uploadType", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("callback")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "callback", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("access_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "access_token", valid_578936
  var valid_578937 = query.getOrDefault("upload_protocol")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "upload_protocol", valid_578937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578938: Call_CloudbuildProjectsBuildsGet_578922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_CloudbuildProjectsBuildsGet_578922; projectId: string;
          id: string; key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsBuildsGet
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : ID of the build.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578940 = newJObject()
  var query_578941 = newJObject()
  add(query_578941, "key", newJString(key))
  add(query_578941, "prettyPrint", newJBool(prettyPrint))
  add(query_578941, "oauth_token", newJString(oauthToken))
  add(path_578940, "projectId", newJString(projectId))
  add(query_578941, "$.xgafv", newJString(Xgafv))
  add(path_578940, "id", newJString(id))
  add(query_578941, "alt", newJString(alt))
  add(query_578941, "uploadType", newJString(uploadType))
  add(query_578941, "quotaUser", newJString(quotaUser))
  add(query_578941, "callback", newJString(callback))
  add(query_578941, "fields", newJString(fields))
  add(query_578941, "access_token", newJString(accessToken))
  add(query_578941, "upload_protocol", newJString(uploadProtocol))
  result = call_578939.call(path_578940, query_578941, nil, nil, nil)

var cloudbuildProjectsBuildsGet* = Call_CloudbuildProjectsBuildsGet_578922(
    name: "cloudbuildProjectsBuildsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}",
    validator: validate_CloudbuildProjectsBuildsGet_578923, base: "/",
    url: url_CloudbuildProjectsBuildsGet_578924, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsCancel_578942 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsBuildsCancel_578944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/builds/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsBuildsCancel_578943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a build in progress.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project.
  ##   id: JString (required)
  ##     : ID of the build.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578945 = path.getOrDefault("projectId")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "projectId", valid_578945
  var valid_578946 = path.getOrDefault("id")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "id", valid_578946
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
  var valid_578947 = query.getOrDefault("key")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "key", valid_578947
  var valid_578948 = query.getOrDefault("prettyPrint")
  valid_578948 = validateParameter(valid_578948, JBool, required = false,
                                 default = newJBool(true))
  if valid_578948 != nil:
    section.add "prettyPrint", valid_578948
  var valid_578949 = query.getOrDefault("oauth_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "oauth_token", valid_578949
  var valid_578950 = query.getOrDefault("$.xgafv")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("1"))
  if valid_578950 != nil:
    section.add "$.xgafv", valid_578950
  var valid_578951 = query.getOrDefault("alt")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("json"))
  if valid_578951 != nil:
    section.add "alt", valid_578951
  var valid_578952 = query.getOrDefault("uploadType")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "uploadType", valid_578952
  var valid_578953 = query.getOrDefault("quotaUser")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "quotaUser", valid_578953
  var valid_578954 = query.getOrDefault("callback")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "callback", valid_578954
  var valid_578955 = query.getOrDefault("fields")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "fields", valid_578955
  var valid_578956 = query.getOrDefault("access_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "access_token", valid_578956
  var valid_578957 = query.getOrDefault("upload_protocol")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "upload_protocol", valid_578957
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

proc call*(call_578959: Call_CloudbuildProjectsBuildsCancel_578942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a build in progress.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_CloudbuildProjectsBuildsCancel_578942;
          projectId: string; id: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsBuildsCancel
  ## Cancels a build in progress.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : ID of the build.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578961 = newJObject()
  var query_578962 = newJObject()
  var body_578963 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(path_578961, "projectId", newJString(projectId))
  add(query_578962, "$.xgafv", newJString(Xgafv))
  add(path_578961, "id", newJString(id))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "uploadType", newJString(uploadType))
  add(query_578962, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578963 = body
  add(query_578962, "callback", newJString(callback))
  add(query_578962, "fields", newJString(fields))
  add(query_578962, "access_token", newJString(accessToken))
  add(query_578962, "upload_protocol", newJString(uploadProtocol))
  result = call_578960.call(path_578961, query_578962, nil, nil, body_578963)

var cloudbuildProjectsBuildsCancel* = Call_CloudbuildProjectsBuildsCancel_578942(
    name: "cloudbuildProjectsBuildsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:cancel",
    validator: validate_CloudbuildProjectsBuildsCancel_578943, base: "/",
    url: url_CloudbuildProjectsBuildsCancel_578944, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsRetry_578964 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsBuildsRetry_578966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/builds/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":retry")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsBuildsRetry_578965(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new build based on the specified build.
  ## 
  ## This method creates a new build using the original build request, which may
  ## or may not result in an identical build.
  ## 
  ## For triggered builds:
  ## 
  ## * Triggered builds resolve to a precise revision; therefore a retry of a
  ## triggered build will result in a build that uses the same revision.
  ## 
  ## For non-triggered builds that specify `RepoSource`:
  ## 
  ## * If the original build built from the tip of a branch, the retried build
  ## will build from the tip of that branch, which may not be the same revision
  ## as the original build.
  ## * If the original build specified a commit sha or revision ID, the retried
  ## build will use the identical source.
  ## 
  ## For builds that specify `StorageSource`:
  ## 
  ## * If the original build pulled source from Google Cloud Storage without
  ## specifying the generation of the object, the new build will use the current
  ## object, which may be different from the original build source.
  ## * If the original build pulled source from Cloud Storage and specified the
  ## generation of the object, the new build will attempt to use the same
  ## object, which may or may not be available depending on the bucket's
  ## lifecycle management settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project.
  ##   id: JString (required)
  ##     : Build ID of the original build.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578967 = path.getOrDefault("projectId")
  valid_578967 = validateParameter(valid_578967, JString, required = true,
                                 default = nil)
  if valid_578967 != nil:
    section.add "projectId", valid_578967
  var valid_578968 = path.getOrDefault("id")
  valid_578968 = validateParameter(valid_578968, JString, required = true,
                                 default = nil)
  if valid_578968 != nil:
    section.add "id", valid_578968
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
  var valid_578969 = query.getOrDefault("key")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "key", valid_578969
  var valid_578970 = query.getOrDefault("prettyPrint")
  valid_578970 = validateParameter(valid_578970, JBool, required = false,
                                 default = newJBool(true))
  if valid_578970 != nil:
    section.add "prettyPrint", valid_578970
  var valid_578971 = query.getOrDefault("oauth_token")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "oauth_token", valid_578971
  var valid_578972 = query.getOrDefault("$.xgafv")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("1"))
  if valid_578972 != nil:
    section.add "$.xgafv", valid_578972
  var valid_578973 = query.getOrDefault("alt")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = newJString("json"))
  if valid_578973 != nil:
    section.add "alt", valid_578973
  var valid_578974 = query.getOrDefault("uploadType")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "uploadType", valid_578974
  var valid_578975 = query.getOrDefault("quotaUser")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "quotaUser", valid_578975
  var valid_578976 = query.getOrDefault("callback")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "callback", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
  var valid_578978 = query.getOrDefault("access_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "access_token", valid_578978
  var valid_578979 = query.getOrDefault("upload_protocol")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "upload_protocol", valid_578979
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

proc call*(call_578981: Call_CloudbuildProjectsBuildsRetry_578964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new build based on the specified build.
  ## 
  ## This method creates a new build using the original build request, which may
  ## or may not result in an identical build.
  ## 
  ## For triggered builds:
  ## 
  ## * Triggered builds resolve to a precise revision; therefore a retry of a
  ## triggered build will result in a build that uses the same revision.
  ## 
  ## For non-triggered builds that specify `RepoSource`:
  ## 
  ## * If the original build built from the tip of a branch, the retried build
  ## will build from the tip of that branch, which may not be the same revision
  ## as the original build.
  ## * If the original build specified a commit sha or revision ID, the retried
  ## build will use the identical source.
  ## 
  ## For builds that specify `StorageSource`:
  ## 
  ## * If the original build pulled source from Google Cloud Storage without
  ## specifying the generation of the object, the new build will use the current
  ## object, which may be different from the original build source.
  ## * If the original build pulled source from Cloud Storage and specified the
  ## generation of the object, the new build will attempt to use the same
  ## object, which may or may not be available depending on the bucket's
  ## lifecycle management settings.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_CloudbuildProjectsBuildsRetry_578964;
          projectId: string; id: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsBuildsRetry
  ## Creates a new build based on the specified build.
  ## 
  ## This method creates a new build using the original build request, which may
  ## or may not result in an identical build.
  ## 
  ## For triggered builds:
  ## 
  ## * Triggered builds resolve to a precise revision; therefore a retry of a
  ## triggered build will result in a build that uses the same revision.
  ## 
  ## For non-triggered builds that specify `RepoSource`:
  ## 
  ## * If the original build built from the tip of a branch, the retried build
  ## will build from the tip of that branch, which may not be the same revision
  ## as the original build.
  ## * If the original build specified a commit sha or revision ID, the retried
  ## build will use the identical source.
  ## 
  ## For builds that specify `StorageSource`:
  ## 
  ## * If the original build pulled source from Google Cloud Storage without
  ## specifying the generation of the object, the new build will use the current
  ## object, which may be different from the original build source.
  ## * If the original build pulled source from Cloud Storage and specified the
  ## generation of the object, the new build will attempt to use the same
  ## object, which may or may not be available depending on the bucket's
  ## lifecycle management settings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Build ID of the original build.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  var body_578985 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(path_578983, "projectId", newJString(projectId))
  add(query_578984, "$.xgafv", newJString(Xgafv))
  add(path_578983, "id", newJString(id))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "uploadType", newJString(uploadType))
  add(query_578984, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578985 = body
  add(query_578984, "callback", newJString(callback))
  add(query_578984, "fields", newJString(fields))
  add(query_578984, "access_token", newJString(accessToken))
  add(query_578984, "upload_protocol", newJString(uploadProtocol))
  result = call_578982.call(path_578983, query_578984, nil, nil, body_578985)

var cloudbuildProjectsBuildsRetry* = Call_CloudbuildProjectsBuildsRetry_578964(
    name: "cloudbuildProjectsBuildsRetry", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:retry",
    validator: validate_CloudbuildProjectsBuildsRetry_578965, base: "/",
    url: url_CloudbuildProjectsBuildsRetry_578966, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersCreate_579007 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsTriggersCreate_579009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsTriggersCreate_579008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project for which to configure automatic builds.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579010 = path.getOrDefault("projectId")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = nil)
  if valid_579010 != nil:
    section.add "projectId", valid_579010
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
  var valid_579011 = query.getOrDefault("key")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "key", valid_579011
  var valid_579012 = query.getOrDefault("prettyPrint")
  valid_579012 = validateParameter(valid_579012, JBool, required = false,
                                 default = newJBool(true))
  if valid_579012 != nil:
    section.add "prettyPrint", valid_579012
  var valid_579013 = query.getOrDefault("oauth_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "oauth_token", valid_579013
  var valid_579014 = query.getOrDefault("$.xgafv")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("1"))
  if valid_579014 != nil:
    section.add "$.xgafv", valid_579014
  var valid_579015 = query.getOrDefault("alt")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("json"))
  if valid_579015 != nil:
    section.add "alt", valid_579015
  var valid_579016 = query.getOrDefault("uploadType")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "uploadType", valid_579016
  var valid_579017 = query.getOrDefault("quotaUser")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "quotaUser", valid_579017
  var valid_579018 = query.getOrDefault("callback")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "callback", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
  var valid_579020 = query.getOrDefault("access_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "access_token", valid_579020
  var valid_579021 = query.getOrDefault("upload_protocol")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "upload_protocol", valid_579021
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

proc call*(call_579023: Call_CloudbuildProjectsTriggersCreate_579007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_579023.validator(path, query, header, formData, body)
  let scheme = call_579023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579023.url(scheme.get, call_579023.host, call_579023.base,
                         call_579023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579023, url, valid)

proc call*(call_579024: Call_CloudbuildProjectsTriggersCreate_579007;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsTriggersCreate
  ## Creates a new `BuildTrigger`.
  ## 
  ## This API is experimental.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project for which to configure automatic builds.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579025 = newJObject()
  var query_579026 = newJObject()
  var body_579027 = newJObject()
  add(query_579026, "key", newJString(key))
  add(query_579026, "prettyPrint", newJBool(prettyPrint))
  add(query_579026, "oauth_token", newJString(oauthToken))
  add(path_579025, "projectId", newJString(projectId))
  add(query_579026, "$.xgafv", newJString(Xgafv))
  add(query_579026, "alt", newJString(alt))
  add(query_579026, "uploadType", newJString(uploadType))
  add(query_579026, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579027 = body
  add(query_579026, "callback", newJString(callback))
  add(query_579026, "fields", newJString(fields))
  add(query_579026, "access_token", newJString(accessToken))
  add(query_579026, "upload_protocol", newJString(uploadProtocol))
  result = call_579024.call(path_579025, query_579026, nil, nil, body_579027)

var cloudbuildProjectsTriggersCreate* = Call_CloudbuildProjectsTriggersCreate_579007(
    name: "cloudbuildProjectsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersCreate_579008, base: "/",
    url: url_CloudbuildProjectsTriggersCreate_579009, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersList_578986 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsTriggersList_578988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsTriggersList_578987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists existing `BuildTrigger`s.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project for which to list BuildTriggers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578989 = path.getOrDefault("projectId")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "projectId", valid_578989
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
  ##           : Number of results to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("pageSize")
  valid_578994 = validateParameter(valid_578994, JInt, required = false, default = nil)
  if valid_578994 != nil:
    section.add "pageSize", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("uploadType")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "uploadType", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("pageToken")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "pageToken", valid_578998
  var valid_578999 = query.getOrDefault("callback")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "callback", valid_578999
  var valid_579000 = query.getOrDefault("fields")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "fields", valid_579000
  var valid_579001 = query.getOrDefault("access_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "access_token", valid_579001
  var valid_579002 = query.getOrDefault("upload_protocol")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "upload_protocol", valid_579002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579003: Call_CloudbuildProjectsTriggersList_578986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing `BuildTrigger`s.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_CloudbuildProjectsTriggersList_578986;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsTriggersList
  ## Lists existing `BuildTrigger`s.
  ## 
  ## This API is experimental.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project for which to list BuildTriggers.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of results to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(path_579005, "projectId", newJString(projectId))
  add(query_579006, "$.xgafv", newJString(Xgafv))
  add(query_579006, "pageSize", newJInt(pageSize))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "uploadType", newJString(uploadType))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(query_579006, "pageToken", newJString(pageToken))
  add(query_579006, "callback", newJString(callback))
  add(query_579006, "fields", newJString(fields))
  add(query_579006, "access_token", newJString(accessToken))
  add(query_579006, "upload_protocol", newJString(uploadProtocol))
  result = call_579004.call(path_579005, query_579006, nil, nil, nil)

var cloudbuildProjectsTriggersList* = Call_CloudbuildProjectsTriggersList_578986(
    name: "cloudbuildProjectsTriggersList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersList_578987, base: "/",
    url: url_CloudbuildProjectsTriggersList_578988, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersGet_579028 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsTriggersGet_579030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "triggerId" in path, "`triggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsTriggersGet_579029(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project that owns the trigger.
  ##   triggerId: JString (required)
  ##            : ID of the `BuildTrigger` to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579031 = path.getOrDefault("projectId")
  valid_579031 = validateParameter(valid_579031, JString, required = true,
                                 default = nil)
  if valid_579031 != nil:
    section.add "projectId", valid_579031
  var valid_579032 = path.getOrDefault("triggerId")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "triggerId", valid_579032
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
  var valid_579033 = query.getOrDefault("key")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "key", valid_579033
  var valid_579034 = query.getOrDefault("prettyPrint")
  valid_579034 = validateParameter(valid_579034, JBool, required = false,
                                 default = newJBool(true))
  if valid_579034 != nil:
    section.add "prettyPrint", valid_579034
  var valid_579035 = query.getOrDefault("oauth_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "oauth_token", valid_579035
  var valid_579036 = query.getOrDefault("$.xgafv")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("1"))
  if valid_579036 != nil:
    section.add "$.xgafv", valid_579036
  var valid_579037 = query.getOrDefault("alt")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("json"))
  if valid_579037 != nil:
    section.add "alt", valid_579037
  var valid_579038 = query.getOrDefault("uploadType")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "uploadType", valid_579038
  var valid_579039 = query.getOrDefault("quotaUser")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "quotaUser", valid_579039
  var valid_579040 = query.getOrDefault("callback")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "callback", valid_579040
  var valid_579041 = query.getOrDefault("fields")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "fields", valid_579041
  var valid_579042 = query.getOrDefault("access_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "access_token", valid_579042
  var valid_579043 = query.getOrDefault("upload_protocol")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "upload_protocol", valid_579043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579044: Call_CloudbuildProjectsTriggersGet_579028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_579044.validator(path, query, header, formData, body)
  let scheme = call_579044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579044.url(scheme.get, call_579044.host, call_579044.base,
                         call_579044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579044, url, valid)

proc call*(call_579045: Call_CloudbuildProjectsTriggersGet_579028;
          projectId: string; triggerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsTriggersGet
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project that owns the trigger.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   triggerId: string (required)
  ##            : ID of the `BuildTrigger` to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579046 = newJObject()
  var query_579047 = newJObject()
  add(query_579047, "key", newJString(key))
  add(query_579047, "prettyPrint", newJBool(prettyPrint))
  add(query_579047, "oauth_token", newJString(oauthToken))
  add(path_579046, "projectId", newJString(projectId))
  add(query_579047, "$.xgafv", newJString(Xgafv))
  add(query_579047, "alt", newJString(alt))
  add(query_579047, "uploadType", newJString(uploadType))
  add(query_579047, "quotaUser", newJString(quotaUser))
  add(path_579046, "triggerId", newJString(triggerId))
  add(query_579047, "callback", newJString(callback))
  add(query_579047, "fields", newJString(fields))
  add(query_579047, "access_token", newJString(accessToken))
  add(query_579047, "upload_protocol", newJString(uploadProtocol))
  result = call_579045.call(path_579046, query_579047, nil, nil, nil)

var cloudbuildProjectsTriggersGet* = Call_CloudbuildProjectsTriggersGet_579028(
    name: "cloudbuildProjectsTriggersGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersGet_579029, base: "/",
    url: url_CloudbuildProjectsTriggersGet_579030, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersPatch_579068 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsTriggersPatch_579070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "triggerId" in path, "`triggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsTriggersPatch_579069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project that owns the trigger.
  ##   triggerId: JString (required)
  ##            : ID of the `BuildTrigger` to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579071 = path.getOrDefault("projectId")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "projectId", valid_579071
  var valid_579072 = path.getOrDefault("triggerId")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "triggerId", valid_579072
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
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("$.xgafv")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("1"))
  if valid_579076 != nil:
    section.add "$.xgafv", valid_579076
  var valid_579077 = query.getOrDefault("alt")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("json"))
  if valid_579077 != nil:
    section.add "alt", valid_579077
  var valid_579078 = query.getOrDefault("uploadType")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "uploadType", valid_579078
  var valid_579079 = query.getOrDefault("quotaUser")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "quotaUser", valid_579079
  var valid_579080 = query.getOrDefault("callback")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "callback", valid_579080
  var valid_579081 = query.getOrDefault("fields")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "fields", valid_579081
  var valid_579082 = query.getOrDefault("access_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "access_token", valid_579082
  var valid_579083 = query.getOrDefault("upload_protocol")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "upload_protocol", valid_579083
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

proc call*(call_579085: Call_CloudbuildProjectsTriggersPatch_579068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_CloudbuildProjectsTriggersPatch_579068;
          projectId: string; triggerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsTriggersPatch
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project that owns the trigger.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   triggerId: string (required)
  ##            : ID of the `BuildTrigger` to update.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  var body_579089 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(path_579087, "projectId", newJString(projectId))
  add(query_579088, "$.xgafv", newJString(Xgafv))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "uploadType", newJString(uploadType))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(path_579087, "triggerId", newJString(triggerId))
  if body != nil:
    body_579089 = body
  add(query_579088, "callback", newJString(callback))
  add(query_579088, "fields", newJString(fields))
  add(query_579088, "access_token", newJString(accessToken))
  add(query_579088, "upload_protocol", newJString(uploadProtocol))
  result = call_579086.call(path_579087, query_579088, nil, nil, body_579089)

var cloudbuildProjectsTriggersPatch* = Call_CloudbuildProjectsTriggersPatch_579068(
    name: "cloudbuildProjectsTriggersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersPatch_579069, base: "/",
    url: url_CloudbuildProjectsTriggersPatch_579070, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersDelete_579048 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsTriggersDelete_579050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "triggerId" in path, "`triggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsTriggersDelete_579049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project that owns the trigger.
  ##   triggerId: JString (required)
  ##            : ID of the `BuildTrigger` to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579051 = path.getOrDefault("projectId")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "projectId", valid_579051
  var valid_579052 = path.getOrDefault("triggerId")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "triggerId", valid_579052
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
  var valid_579053 = query.getOrDefault("key")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "key", valid_579053
  var valid_579054 = query.getOrDefault("prettyPrint")
  valid_579054 = validateParameter(valid_579054, JBool, required = false,
                                 default = newJBool(true))
  if valid_579054 != nil:
    section.add "prettyPrint", valid_579054
  var valid_579055 = query.getOrDefault("oauth_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "oauth_token", valid_579055
  var valid_579056 = query.getOrDefault("$.xgafv")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = newJString("1"))
  if valid_579056 != nil:
    section.add "$.xgafv", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("uploadType")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "uploadType", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("callback")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "callback", valid_579060
  var valid_579061 = query.getOrDefault("fields")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "fields", valid_579061
  var valid_579062 = query.getOrDefault("access_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "access_token", valid_579062
  var valid_579063 = query.getOrDefault("upload_protocol")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "upload_protocol", valid_579063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579064: Call_CloudbuildProjectsTriggersDelete_579048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_579064.validator(path, query, header, formData, body)
  let scheme = call_579064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579064.url(scheme.get, call_579064.host, call_579064.base,
                         call_579064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579064, url, valid)

proc call*(call_579065: Call_CloudbuildProjectsTriggersDelete_579048;
          projectId: string; triggerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsTriggersDelete
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project that owns the trigger.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   triggerId: string (required)
  ##            : ID of the `BuildTrigger` to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579066 = newJObject()
  var query_579067 = newJObject()
  add(query_579067, "key", newJString(key))
  add(query_579067, "prettyPrint", newJBool(prettyPrint))
  add(query_579067, "oauth_token", newJString(oauthToken))
  add(path_579066, "projectId", newJString(projectId))
  add(query_579067, "$.xgafv", newJString(Xgafv))
  add(query_579067, "alt", newJString(alt))
  add(query_579067, "uploadType", newJString(uploadType))
  add(query_579067, "quotaUser", newJString(quotaUser))
  add(path_579066, "triggerId", newJString(triggerId))
  add(query_579067, "callback", newJString(callback))
  add(query_579067, "fields", newJString(fields))
  add(query_579067, "access_token", newJString(accessToken))
  add(query_579067, "upload_protocol", newJString(uploadProtocol))
  result = call_579065.call(path_579066, query_579067, nil, nil, nil)

var cloudbuildProjectsTriggersDelete* = Call_CloudbuildProjectsTriggersDelete_579048(
    name: "cloudbuildProjectsTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersDelete_579049, base: "/",
    url: url_CloudbuildProjectsTriggersDelete_579050, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersRun_579090 = ref object of OpenApiRestCall_578339
proc url_CloudbuildProjectsTriggersRun_579092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "triggerId" in path, "`triggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerId"),
               (kind: ConstantSegment, value: ":run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsTriggersRun_579091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a `BuildTrigger` at a particular source revision.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the project.
  ##   triggerId: JString (required)
  ##            : ID of the trigger.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579093 = path.getOrDefault("projectId")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "projectId", valid_579093
  var valid_579094 = path.getOrDefault("triggerId")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "triggerId", valid_579094
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
  var valid_579095 = query.getOrDefault("key")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "key", valid_579095
  var valid_579096 = query.getOrDefault("prettyPrint")
  valid_579096 = validateParameter(valid_579096, JBool, required = false,
                                 default = newJBool(true))
  if valid_579096 != nil:
    section.add "prettyPrint", valid_579096
  var valid_579097 = query.getOrDefault("oauth_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "oauth_token", valid_579097
  var valid_579098 = query.getOrDefault("$.xgafv")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("1"))
  if valid_579098 != nil:
    section.add "$.xgafv", valid_579098
  var valid_579099 = query.getOrDefault("alt")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("json"))
  if valid_579099 != nil:
    section.add "alt", valid_579099
  var valid_579100 = query.getOrDefault("uploadType")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "uploadType", valid_579100
  var valid_579101 = query.getOrDefault("quotaUser")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "quotaUser", valid_579101
  var valid_579102 = query.getOrDefault("callback")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "callback", valid_579102
  var valid_579103 = query.getOrDefault("fields")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "fields", valid_579103
  var valid_579104 = query.getOrDefault("access_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "access_token", valid_579104
  var valid_579105 = query.getOrDefault("upload_protocol")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "upload_protocol", valid_579105
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

proc call*(call_579107: Call_CloudbuildProjectsTriggersRun_579090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a `BuildTrigger` at a particular source revision.
  ## 
  let valid = call_579107.validator(path, query, header, formData, body)
  let scheme = call_579107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579107.url(scheme.get, call_579107.host, call_579107.base,
                         call_579107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579107, url, valid)

proc call*(call_579108: Call_CloudbuildProjectsTriggersRun_579090;
          projectId: string; triggerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbuildProjectsTriggersRun
  ## Runs a `BuildTrigger` at a particular source revision.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   triggerId: string (required)
  ##            : ID of the trigger.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579109 = newJObject()
  var query_579110 = newJObject()
  var body_579111 = newJObject()
  add(query_579110, "key", newJString(key))
  add(query_579110, "prettyPrint", newJBool(prettyPrint))
  add(query_579110, "oauth_token", newJString(oauthToken))
  add(path_579109, "projectId", newJString(projectId))
  add(query_579110, "$.xgafv", newJString(Xgafv))
  add(query_579110, "alt", newJString(alt))
  add(query_579110, "uploadType", newJString(uploadType))
  add(query_579110, "quotaUser", newJString(quotaUser))
  add(path_579109, "triggerId", newJString(triggerId))
  if body != nil:
    body_579111 = body
  add(query_579110, "callback", newJString(callback))
  add(query_579110, "fields", newJString(fields))
  add(query_579110, "access_token", newJString(accessToken))
  add(query_579110, "upload_protocol", newJString(uploadProtocol))
  result = call_579108.call(path_579109, query_579110, nil, nil, body_579111)

var cloudbuildProjectsTriggersRun* = Call_CloudbuildProjectsTriggersRun_579090(
    name: "cloudbuildProjectsTriggersRun", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}:run",
    validator: validate_CloudbuildProjectsTriggersRun_579091, base: "/",
    url: url_CloudbuildProjectsTriggersRun_579092, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsGet_579112 = ref object of OpenApiRestCall_578339
proc url_CloudbuildOperationsGet_579114(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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

proc validate_CloudbuildOperationsGet_579113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579115 = path.getOrDefault("name")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "name", valid_579115
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
  var valid_579116 = query.getOrDefault("key")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "key", valid_579116
  var valid_579117 = query.getOrDefault("prettyPrint")
  valid_579117 = validateParameter(valid_579117, JBool, required = false,
                                 default = newJBool(true))
  if valid_579117 != nil:
    section.add "prettyPrint", valid_579117
  var valid_579118 = query.getOrDefault("oauth_token")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "oauth_token", valid_579118
  var valid_579119 = query.getOrDefault("$.xgafv")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = newJString("1"))
  if valid_579119 != nil:
    section.add "$.xgafv", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("uploadType")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "uploadType", valid_579121
  var valid_579122 = query.getOrDefault("quotaUser")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "quotaUser", valid_579122
  var valid_579123 = query.getOrDefault("callback")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "callback", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  var valid_579125 = query.getOrDefault("access_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "access_token", valid_579125
  var valid_579126 = query.getOrDefault("upload_protocol")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "upload_protocol", valid_579126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579127: Call_CloudbuildOperationsGet_579112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579127.validator(path, query, header, formData, body)
  let scheme = call_579127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579127.url(scheme.get, call_579127.host, call_579127.base,
                         call_579127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579127, url, valid)

proc call*(call_579128: Call_CloudbuildOperationsGet_579112; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbuildOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579129 = newJObject()
  var query_579130 = newJObject()
  add(query_579130, "key", newJString(key))
  add(query_579130, "prettyPrint", newJBool(prettyPrint))
  add(query_579130, "oauth_token", newJString(oauthToken))
  add(query_579130, "$.xgafv", newJString(Xgafv))
  add(query_579130, "alt", newJString(alt))
  add(query_579130, "uploadType", newJString(uploadType))
  add(query_579130, "quotaUser", newJString(quotaUser))
  add(path_579129, "name", newJString(name))
  add(query_579130, "callback", newJString(callback))
  add(query_579130, "fields", newJString(fields))
  add(query_579130, "access_token", newJString(accessToken))
  add(query_579130, "upload_protocol", newJString(uploadProtocol))
  result = call_579128.call(path_579129, query_579130, nil, nil, nil)

var cloudbuildOperationsGet* = Call_CloudbuildOperationsGet_579112(
    name: "cloudbuildOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbuildOperationsGet_579113, base: "/",
    url: url_CloudbuildOperationsGet_579114, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsCancel_579131 = ref object of OpenApiRestCall_578339
proc url_CloudbuildOperationsCancel_579133(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildOperationsCancel_579132(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579134 = path.getOrDefault("name")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "name", valid_579134
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
  var valid_579135 = query.getOrDefault("key")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "key", valid_579135
  var valid_579136 = query.getOrDefault("prettyPrint")
  valid_579136 = validateParameter(valid_579136, JBool, required = false,
                                 default = newJBool(true))
  if valid_579136 != nil:
    section.add "prettyPrint", valid_579136
  var valid_579137 = query.getOrDefault("oauth_token")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "oauth_token", valid_579137
  var valid_579138 = query.getOrDefault("$.xgafv")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = newJString("1"))
  if valid_579138 != nil:
    section.add "$.xgafv", valid_579138
  var valid_579139 = query.getOrDefault("alt")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("json"))
  if valid_579139 != nil:
    section.add "alt", valid_579139
  var valid_579140 = query.getOrDefault("uploadType")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "uploadType", valid_579140
  var valid_579141 = query.getOrDefault("quotaUser")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "quotaUser", valid_579141
  var valid_579142 = query.getOrDefault("callback")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "callback", valid_579142
  var valid_579143 = query.getOrDefault("fields")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "fields", valid_579143
  var valid_579144 = query.getOrDefault("access_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "access_token", valid_579144
  var valid_579145 = query.getOrDefault("upload_protocol")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "upload_protocol", valid_579145
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

proc call*(call_579147: Call_CloudbuildOperationsCancel_579131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_579147.validator(path, query, header, formData, body)
  let scheme = call_579147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579147.url(scheme.get, call_579147.host, call_579147.base,
                         call_579147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579147, url, valid)

proc call*(call_579148: Call_CloudbuildOperationsCancel_579131; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbuildOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
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
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579149 = newJObject()
  var query_579150 = newJObject()
  var body_579151 = newJObject()
  add(query_579150, "key", newJString(key))
  add(query_579150, "prettyPrint", newJBool(prettyPrint))
  add(query_579150, "oauth_token", newJString(oauthToken))
  add(query_579150, "$.xgafv", newJString(Xgafv))
  add(query_579150, "alt", newJString(alt))
  add(query_579150, "uploadType", newJString(uploadType))
  add(query_579150, "quotaUser", newJString(quotaUser))
  add(path_579149, "name", newJString(name))
  if body != nil:
    body_579151 = body
  add(query_579150, "callback", newJString(callback))
  add(query_579150, "fields", newJString(fields))
  add(query_579150, "access_token", newJString(accessToken))
  add(query_579150, "upload_protocol", newJString(uploadProtocol))
  result = call_579148.call(path_579149, query_579150, nil, nil, body_579151)

var cloudbuildOperationsCancel* = Call_CloudbuildOperationsCancel_579131(
    name: "cloudbuildOperationsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_CloudbuildOperationsCancel_579132, base: "/",
    url: url_CloudbuildOperationsCancel_579133, schemes: {Scheme.Https})
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
