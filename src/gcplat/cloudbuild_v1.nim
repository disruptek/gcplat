
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
  gcpServiceName = "cloudbuild"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbuildProjectsBuildsCreate_589001 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsBuildsCreate_589003(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsCreate_589002(path: JsonNode;
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
  var valid_589004 = path.getOrDefault("projectId")
  valid_589004 = validateParameter(valid_589004, JString, required = true,
                                 default = nil)
  if valid_589004 != nil:
    section.add "projectId", valid_589004
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
  var valid_589005 = query.getOrDefault("upload_protocol")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "upload_protocol", valid_589005
  var valid_589006 = query.getOrDefault("fields")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "fields", valid_589006
  var valid_589007 = query.getOrDefault("quotaUser")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "quotaUser", valid_589007
  var valid_589008 = query.getOrDefault("alt")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("json"))
  if valid_589008 != nil:
    section.add "alt", valid_589008
  var valid_589009 = query.getOrDefault("oauth_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "oauth_token", valid_589009
  var valid_589010 = query.getOrDefault("callback")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "callback", valid_589010
  var valid_589011 = query.getOrDefault("access_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "access_token", valid_589011
  var valid_589012 = query.getOrDefault("uploadType")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "uploadType", valid_589012
  var valid_589013 = query.getOrDefault("key")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "key", valid_589013
  var valid_589014 = query.getOrDefault("$.xgafv")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("1"))
  if valid_589014 != nil:
    section.add "$.xgafv", valid_589014
  var valid_589015 = query.getOrDefault("prettyPrint")
  valid_589015 = validateParameter(valid_589015, JBool, required = false,
                                 default = newJBool(true))
  if valid_589015 != nil:
    section.add "prettyPrint", valid_589015
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

proc call*(call_589017: Call_CloudbuildProjectsBuildsCreate_589001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a build with the specified configuration.
  ## 
  ## This method returns a long-running `Operation`, which includes the build
  ## ID. Pass the build ID to `GetBuild` to determine the build status (such as
  ## `SUCCESS` or `FAILURE`).
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_CloudbuildProjectsBuildsCreate_589001;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsBuildsCreate
  ## Starts a build with the specified configuration.
  ## 
  ## This method returns a long-running `Operation`, which includes the build
  ## ID. Pass the build ID to `GetBuild` to determine the build status (such as
  ## `SUCCESS` or `FAILURE`).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589019 = newJObject()
  var query_589020 = newJObject()
  var body_589021 = newJObject()
  add(query_589020, "upload_protocol", newJString(uploadProtocol))
  add(query_589020, "fields", newJString(fields))
  add(query_589020, "quotaUser", newJString(quotaUser))
  add(query_589020, "alt", newJString(alt))
  add(query_589020, "oauth_token", newJString(oauthToken))
  add(query_589020, "callback", newJString(callback))
  add(query_589020, "access_token", newJString(accessToken))
  add(query_589020, "uploadType", newJString(uploadType))
  add(query_589020, "key", newJString(key))
  add(path_589019, "projectId", newJString(projectId))
  add(query_589020, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589021 = body
  add(query_589020, "prettyPrint", newJBool(prettyPrint))
  result = call_589018.call(path_589019, query_589020, nil, nil, body_589021)

var cloudbuildProjectsBuildsCreate* = Call_CloudbuildProjectsBuildsCreate_589001(
    name: "cloudbuildProjectsBuildsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsCreate_589002, base: "/",
    url: url_CloudbuildProjectsBuildsCreate_589003, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsList_588710 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsBuildsList_588712(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588838 = path.getOrDefault("projectId")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "projectId", valid_588838
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : Number of results to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The raw filter text to constrain the results.
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
  var valid_588841 = query.getOrDefault("pageToken")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "pageToken", valid_588841
  var valid_588842 = query.getOrDefault("quotaUser")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "quotaUser", valid_588842
  var valid_588856 = query.getOrDefault("alt")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("json"))
  if valid_588856 != nil:
    section.add "alt", valid_588856
  var valid_588857 = query.getOrDefault("oauth_token")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "oauth_token", valid_588857
  var valid_588858 = query.getOrDefault("callback")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "callback", valid_588858
  var valid_588859 = query.getOrDefault("access_token")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "access_token", valid_588859
  var valid_588860 = query.getOrDefault("uploadType")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "uploadType", valid_588860
  var valid_588861 = query.getOrDefault("key")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "key", valid_588861
  var valid_588862 = query.getOrDefault("$.xgafv")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("1"))
  if valid_588862 != nil:
    section.add "$.xgafv", valid_588862
  var valid_588863 = query.getOrDefault("pageSize")
  valid_588863 = validateParameter(valid_588863, JInt, required = false, default = nil)
  if valid_588863 != nil:
    section.add "pageSize", valid_588863
  var valid_588864 = query.getOrDefault("prettyPrint")
  valid_588864 = validateParameter(valid_588864, JBool, required = false,
                                 default = newJBool(true))
  if valid_588864 != nil:
    section.add "prettyPrint", valid_588864
  var valid_588865 = query.getOrDefault("filter")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "filter", valid_588865
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588888: Call_CloudbuildProjectsBuildsList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists previously requested builds.
  ## 
  ## Previously requested builds may still be in-progress, or may have finished
  ## successfully or unsuccessfully.
  ## 
  let valid = call_588888.validator(path, query, header, formData, body)
  let scheme = call_588888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588888.url(scheme.get, call_588888.host, call_588888.base,
                         call_588888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588888, url, valid)

proc call*(call_588959: Call_CloudbuildProjectsBuildsList_588710;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudbuildProjectsBuildsList
  ## Lists previously requested builds.
  ## 
  ## Previously requested builds may still be in-progress, or may have finished
  ## successfully or unsuccessfully.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of results to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The raw filter text to constrain the results.
  var path_588960 = newJObject()
  var query_588962 = newJObject()
  add(query_588962, "upload_protocol", newJString(uploadProtocol))
  add(query_588962, "fields", newJString(fields))
  add(query_588962, "pageToken", newJString(pageToken))
  add(query_588962, "quotaUser", newJString(quotaUser))
  add(query_588962, "alt", newJString(alt))
  add(query_588962, "oauth_token", newJString(oauthToken))
  add(query_588962, "callback", newJString(callback))
  add(query_588962, "access_token", newJString(accessToken))
  add(query_588962, "uploadType", newJString(uploadType))
  add(query_588962, "key", newJString(key))
  add(path_588960, "projectId", newJString(projectId))
  add(query_588962, "$.xgafv", newJString(Xgafv))
  add(query_588962, "pageSize", newJInt(pageSize))
  add(query_588962, "prettyPrint", newJBool(prettyPrint))
  add(query_588962, "filter", newJString(filter))
  result = call_588959.call(path_588960, query_588962, nil, nil, nil)

var cloudbuildProjectsBuildsList* = Call_CloudbuildProjectsBuildsList_588710(
    name: "cloudbuildProjectsBuildsList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsList_588711, base: "/",
    url: url_CloudbuildProjectsBuildsList_588712, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsGet_589022 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsBuildsGet_589024(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsGet_589023(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : ID of the build.
  ##   projectId: JString (required)
  ##            : ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589025 = path.getOrDefault("id")
  valid_589025 = validateParameter(valid_589025, JString, required = true,
                                 default = nil)
  if valid_589025 != nil:
    section.add "id", valid_589025
  var valid_589026 = path.getOrDefault("projectId")
  valid_589026 = validateParameter(valid_589026, JString, required = true,
                                 default = nil)
  if valid_589026 != nil:
    section.add "projectId", valid_589026
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
  var valid_589027 = query.getOrDefault("upload_protocol")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "upload_protocol", valid_589027
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("quotaUser")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "quotaUser", valid_589029
  var valid_589030 = query.getOrDefault("alt")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("json"))
  if valid_589030 != nil:
    section.add "alt", valid_589030
  var valid_589031 = query.getOrDefault("oauth_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "oauth_token", valid_589031
  var valid_589032 = query.getOrDefault("callback")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "callback", valid_589032
  var valid_589033 = query.getOrDefault("access_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "access_token", valid_589033
  var valid_589034 = query.getOrDefault("uploadType")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "uploadType", valid_589034
  var valid_589035 = query.getOrDefault("key")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "key", valid_589035
  var valid_589036 = query.getOrDefault("$.xgafv")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("1"))
  if valid_589036 != nil:
    section.add "$.xgafv", valid_589036
  var valid_589037 = query.getOrDefault("prettyPrint")
  valid_589037 = validateParameter(valid_589037, JBool, required = false,
                                 default = newJBool(true))
  if valid_589037 != nil:
    section.add "prettyPrint", valid_589037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589038: Call_CloudbuildProjectsBuildsGet_589022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ## 
  let valid = call_589038.validator(path, query, header, formData, body)
  let scheme = call_589038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589038.url(scheme.get, call_589038.host, call_589038.base,
                         call_589038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589038, url, valid)

proc call*(call_589039: Call_CloudbuildProjectsBuildsGet_589022; id: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsBuildsGet
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   id: string (required)
  ##     : ID of the build.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589040 = newJObject()
  var query_589041 = newJObject()
  add(query_589041, "upload_protocol", newJString(uploadProtocol))
  add(query_589041, "fields", newJString(fields))
  add(query_589041, "quotaUser", newJString(quotaUser))
  add(query_589041, "alt", newJString(alt))
  add(query_589041, "oauth_token", newJString(oauthToken))
  add(query_589041, "callback", newJString(callback))
  add(query_589041, "access_token", newJString(accessToken))
  add(query_589041, "uploadType", newJString(uploadType))
  add(path_589040, "id", newJString(id))
  add(query_589041, "key", newJString(key))
  add(path_589040, "projectId", newJString(projectId))
  add(query_589041, "$.xgafv", newJString(Xgafv))
  add(query_589041, "prettyPrint", newJBool(prettyPrint))
  result = call_589039.call(path_589040, query_589041, nil, nil, nil)

var cloudbuildProjectsBuildsGet* = Call_CloudbuildProjectsBuildsGet_589022(
    name: "cloudbuildProjectsBuildsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}",
    validator: validate_CloudbuildProjectsBuildsGet_589023, base: "/",
    url: url_CloudbuildProjectsBuildsGet_589024, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsCancel_589042 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsBuildsCancel_589044(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsCancel_589043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a build in progress.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : ID of the build.
  ##   projectId: JString (required)
  ##            : ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589045 = path.getOrDefault("id")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "id", valid_589045
  var valid_589046 = path.getOrDefault("projectId")
  valid_589046 = validateParameter(valid_589046, JString, required = true,
                                 default = nil)
  if valid_589046 != nil:
    section.add "projectId", valid_589046
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
  var valid_589047 = query.getOrDefault("upload_protocol")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "upload_protocol", valid_589047
  var valid_589048 = query.getOrDefault("fields")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "fields", valid_589048
  var valid_589049 = query.getOrDefault("quotaUser")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "quotaUser", valid_589049
  var valid_589050 = query.getOrDefault("alt")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = newJString("json"))
  if valid_589050 != nil:
    section.add "alt", valid_589050
  var valid_589051 = query.getOrDefault("oauth_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "oauth_token", valid_589051
  var valid_589052 = query.getOrDefault("callback")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "callback", valid_589052
  var valid_589053 = query.getOrDefault("access_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "access_token", valid_589053
  var valid_589054 = query.getOrDefault("uploadType")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "uploadType", valid_589054
  var valid_589055 = query.getOrDefault("key")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "key", valid_589055
  var valid_589056 = query.getOrDefault("$.xgafv")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("1"))
  if valid_589056 != nil:
    section.add "$.xgafv", valid_589056
  var valid_589057 = query.getOrDefault("prettyPrint")
  valid_589057 = validateParameter(valid_589057, JBool, required = false,
                                 default = newJBool(true))
  if valid_589057 != nil:
    section.add "prettyPrint", valid_589057
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

proc call*(call_589059: Call_CloudbuildProjectsBuildsCancel_589042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a build in progress.
  ## 
  let valid = call_589059.validator(path, query, header, formData, body)
  let scheme = call_589059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589059.url(scheme.get, call_589059.host, call_589059.base,
                         call_589059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589059, url, valid)

proc call*(call_589060: Call_CloudbuildProjectsBuildsCancel_589042; id: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsBuildsCancel
  ## Cancels a build in progress.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   id: string (required)
  ##     : ID of the build.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589061 = newJObject()
  var query_589062 = newJObject()
  var body_589063 = newJObject()
  add(query_589062, "upload_protocol", newJString(uploadProtocol))
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "callback", newJString(callback))
  add(query_589062, "access_token", newJString(accessToken))
  add(query_589062, "uploadType", newJString(uploadType))
  add(path_589061, "id", newJString(id))
  add(query_589062, "key", newJString(key))
  add(path_589061, "projectId", newJString(projectId))
  add(query_589062, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589063 = body
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  result = call_589060.call(path_589061, query_589062, nil, nil, body_589063)

var cloudbuildProjectsBuildsCancel* = Call_CloudbuildProjectsBuildsCancel_589042(
    name: "cloudbuildProjectsBuildsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:cancel",
    validator: validate_CloudbuildProjectsBuildsCancel_589043, base: "/",
    url: url_CloudbuildProjectsBuildsCancel_589044, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsRetry_589064 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsBuildsRetry_589066(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsRetry_589065(path: JsonNode; query: JsonNode;
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
  ##   id: JString (required)
  ##     : Build ID of the original build.
  ##   projectId: JString (required)
  ##            : ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589067 = path.getOrDefault("id")
  valid_589067 = validateParameter(valid_589067, JString, required = true,
                                 default = nil)
  if valid_589067 != nil:
    section.add "id", valid_589067
  var valid_589068 = path.getOrDefault("projectId")
  valid_589068 = validateParameter(valid_589068, JString, required = true,
                                 default = nil)
  if valid_589068 != nil:
    section.add "projectId", valid_589068
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
  var valid_589069 = query.getOrDefault("upload_protocol")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "upload_protocol", valid_589069
  var valid_589070 = query.getOrDefault("fields")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "fields", valid_589070
  var valid_589071 = query.getOrDefault("quotaUser")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "quotaUser", valid_589071
  var valid_589072 = query.getOrDefault("alt")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("json"))
  if valid_589072 != nil:
    section.add "alt", valid_589072
  var valid_589073 = query.getOrDefault("oauth_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "oauth_token", valid_589073
  var valid_589074 = query.getOrDefault("callback")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "callback", valid_589074
  var valid_589075 = query.getOrDefault("access_token")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "access_token", valid_589075
  var valid_589076 = query.getOrDefault("uploadType")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "uploadType", valid_589076
  var valid_589077 = query.getOrDefault("key")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "key", valid_589077
  var valid_589078 = query.getOrDefault("$.xgafv")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("1"))
  if valid_589078 != nil:
    section.add "$.xgafv", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
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

proc call*(call_589081: Call_CloudbuildProjectsBuildsRetry_589064; path: JsonNode;
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
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_CloudbuildProjectsBuildsRetry_589064; id: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   id: string (required)
  ##     : Build ID of the original build.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  var body_589085 = newJObject()
  add(query_589084, "upload_protocol", newJString(uploadProtocol))
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(query_589084, "alt", newJString(alt))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "callback", newJString(callback))
  add(query_589084, "access_token", newJString(accessToken))
  add(query_589084, "uploadType", newJString(uploadType))
  add(path_589083, "id", newJString(id))
  add(query_589084, "key", newJString(key))
  add(path_589083, "projectId", newJString(projectId))
  add(query_589084, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589085 = body
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  result = call_589082.call(path_589083, query_589084, nil, nil, body_589085)

var cloudbuildProjectsBuildsRetry* = Call_CloudbuildProjectsBuildsRetry_589064(
    name: "cloudbuildProjectsBuildsRetry", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:retry",
    validator: validate_CloudbuildProjectsBuildsRetry_589065, base: "/",
    url: url_CloudbuildProjectsBuildsRetry_589066, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersCreate_589107 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsTriggersCreate_589109(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersCreate_589108(path: JsonNode;
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
  var valid_589110 = path.getOrDefault("projectId")
  valid_589110 = validateParameter(valid_589110, JString, required = true,
                                 default = nil)
  if valid_589110 != nil:
    section.add "projectId", valid_589110
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
  var valid_589111 = query.getOrDefault("upload_protocol")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "upload_protocol", valid_589111
  var valid_589112 = query.getOrDefault("fields")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "fields", valid_589112
  var valid_589113 = query.getOrDefault("quotaUser")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "quotaUser", valid_589113
  var valid_589114 = query.getOrDefault("alt")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("json"))
  if valid_589114 != nil:
    section.add "alt", valid_589114
  var valid_589115 = query.getOrDefault("oauth_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "oauth_token", valid_589115
  var valid_589116 = query.getOrDefault("callback")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "callback", valid_589116
  var valid_589117 = query.getOrDefault("access_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "access_token", valid_589117
  var valid_589118 = query.getOrDefault("uploadType")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "uploadType", valid_589118
  var valid_589119 = query.getOrDefault("key")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "key", valid_589119
  var valid_589120 = query.getOrDefault("$.xgafv")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = newJString("1"))
  if valid_589120 != nil:
    section.add "$.xgafv", valid_589120
  var valid_589121 = query.getOrDefault("prettyPrint")
  valid_589121 = validateParameter(valid_589121, JBool, required = false,
                                 default = newJBool(true))
  if valid_589121 != nil:
    section.add "prettyPrint", valid_589121
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

proc call*(call_589123: Call_CloudbuildProjectsTriggersCreate_589107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_589123.validator(path, query, header, formData, body)
  let scheme = call_589123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589123.url(scheme.get, call_589123.host, call_589123.base,
                         call_589123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589123, url, valid)

proc call*(call_589124: Call_CloudbuildProjectsTriggersCreate_589107;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsTriggersCreate
  ## Creates a new `BuildTrigger`.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   projectId: string (required)
  ##            : ID of the project for which to configure automatic builds.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589125 = newJObject()
  var query_589126 = newJObject()
  var body_589127 = newJObject()
  add(query_589126, "upload_protocol", newJString(uploadProtocol))
  add(query_589126, "fields", newJString(fields))
  add(query_589126, "quotaUser", newJString(quotaUser))
  add(query_589126, "alt", newJString(alt))
  add(query_589126, "oauth_token", newJString(oauthToken))
  add(query_589126, "callback", newJString(callback))
  add(query_589126, "access_token", newJString(accessToken))
  add(query_589126, "uploadType", newJString(uploadType))
  add(query_589126, "key", newJString(key))
  add(path_589125, "projectId", newJString(projectId))
  add(query_589126, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589127 = body
  add(query_589126, "prettyPrint", newJBool(prettyPrint))
  result = call_589124.call(path_589125, query_589126, nil, nil, body_589127)

var cloudbuildProjectsTriggersCreate* = Call_CloudbuildProjectsTriggersCreate_589107(
    name: "cloudbuildProjectsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersCreate_589108, base: "/",
    url: url_CloudbuildProjectsTriggersCreate_589109, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersList_589086 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsTriggersList_589088(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersList_589087(path: JsonNode;
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
  var valid_589089 = path.getOrDefault("projectId")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "projectId", valid_589089
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : Number of results to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589090 = query.getOrDefault("upload_protocol")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "upload_protocol", valid_589090
  var valid_589091 = query.getOrDefault("fields")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fields", valid_589091
  var valid_589092 = query.getOrDefault("pageToken")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "pageToken", valid_589092
  var valid_589093 = query.getOrDefault("quotaUser")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "quotaUser", valid_589093
  var valid_589094 = query.getOrDefault("alt")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("json"))
  if valid_589094 != nil:
    section.add "alt", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("callback")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "callback", valid_589096
  var valid_589097 = query.getOrDefault("access_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "access_token", valid_589097
  var valid_589098 = query.getOrDefault("uploadType")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "uploadType", valid_589098
  var valid_589099 = query.getOrDefault("key")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "key", valid_589099
  var valid_589100 = query.getOrDefault("$.xgafv")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("1"))
  if valid_589100 != nil:
    section.add "$.xgafv", valid_589100
  var valid_589101 = query.getOrDefault("pageSize")
  valid_589101 = validateParameter(valid_589101, JInt, required = false, default = nil)
  if valid_589101 != nil:
    section.add "pageSize", valid_589101
  var valid_589102 = query.getOrDefault("prettyPrint")
  valid_589102 = validateParameter(valid_589102, JBool, required = false,
                                 default = newJBool(true))
  if valid_589102 != nil:
    section.add "prettyPrint", valid_589102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589103: Call_CloudbuildProjectsTriggersList_589086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing `BuildTrigger`s.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_589103.validator(path, query, header, formData, body)
  let scheme = call_589103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589103.url(scheme.get, call_589103.host, call_589103.base,
                         call_589103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589103, url, valid)

proc call*(call_589104: Call_CloudbuildProjectsTriggersList_589086;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsTriggersList
  ## Lists existing `BuildTrigger`s.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   projectId: string (required)
  ##            : ID of the project for which to list BuildTriggers.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of results to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589105 = newJObject()
  var query_589106 = newJObject()
  add(query_589106, "upload_protocol", newJString(uploadProtocol))
  add(query_589106, "fields", newJString(fields))
  add(query_589106, "pageToken", newJString(pageToken))
  add(query_589106, "quotaUser", newJString(quotaUser))
  add(query_589106, "alt", newJString(alt))
  add(query_589106, "oauth_token", newJString(oauthToken))
  add(query_589106, "callback", newJString(callback))
  add(query_589106, "access_token", newJString(accessToken))
  add(query_589106, "uploadType", newJString(uploadType))
  add(query_589106, "key", newJString(key))
  add(path_589105, "projectId", newJString(projectId))
  add(query_589106, "$.xgafv", newJString(Xgafv))
  add(query_589106, "pageSize", newJInt(pageSize))
  add(query_589106, "prettyPrint", newJBool(prettyPrint))
  result = call_589104.call(path_589105, query_589106, nil, nil, nil)

var cloudbuildProjectsTriggersList* = Call_CloudbuildProjectsTriggersList_589086(
    name: "cloudbuildProjectsTriggersList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersList_589087, base: "/",
    url: url_CloudbuildProjectsTriggersList_589088, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersGet_589128 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsTriggersGet_589130(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersGet_589129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   triggerId: JString (required)
  ##            : ID of the `BuildTrigger` to get.
  ##   projectId: JString (required)
  ##            : ID of the project that owns the trigger.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `triggerId` field"
  var valid_589131 = path.getOrDefault("triggerId")
  valid_589131 = validateParameter(valid_589131, JString, required = true,
                                 default = nil)
  if valid_589131 != nil:
    section.add "triggerId", valid_589131
  var valid_589132 = path.getOrDefault("projectId")
  valid_589132 = validateParameter(valid_589132, JString, required = true,
                                 default = nil)
  if valid_589132 != nil:
    section.add "projectId", valid_589132
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
  var valid_589133 = query.getOrDefault("upload_protocol")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "upload_protocol", valid_589133
  var valid_589134 = query.getOrDefault("fields")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "fields", valid_589134
  var valid_589135 = query.getOrDefault("quotaUser")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "quotaUser", valid_589135
  var valid_589136 = query.getOrDefault("alt")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("json"))
  if valid_589136 != nil:
    section.add "alt", valid_589136
  var valid_589137 = query.getOrDefault("oauth_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "oauth_token", valid_589137
  var valid_589138 = query.getOrDefault("callback")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "callback", valid_589138
  var valid_589139 = query.getOrDefault("access_token")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "access_token", valid_589139
  var valid_589140 = query.getOrDefault("uploadType")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "uploadType", valid_589140
  var valid_589141 = query.getOrDefault("key")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "key", valid_589141
  var valid_589142 = query.getOrDefault("$.xgafv")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("1"))
  if valid_589142 != nil:
    section.add "$.xgafv", valid_589142
  var valid_589143 = query.getOrDefault("prettyPrint")
  valid_589143 = validateParameter(valid_589143, JBool, required = false,
                                 default = newJBool(true))
  if valid_589143 != nil:
    section.add "prettyPrint", valid_589143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589144: Call_CloudbuildProjectsTriggersGet_589128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_589144.validator(path, query, header, formData, body)
  let scheme = call_589144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589144.url(scheme.get, call_589144.host, call_589144.base,
                         call_589144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589144, url, valid)

proc call*(call_589145: Call_CloudbuildProjectsTriggersGet_589128;
          triggerId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsTriggersGet
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   triggerId: string (required)
  ##            : ID of the `BuildTrigger` to get.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the project that owns the trigger.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589146 = newJObject()
  var query_589147 = newJObject()
  add(query_589147, "upload_protocol", newJString(uploadProtocol))
  add(query_589147, "fields", newJString(fields))
  add(query_589147, "quotaUser", newJString(quotaUser))
  add(query_589147, "alt", newJString(alt))
  add(query_589147, "oauth_token", newJString(oauthToken))
  add(query_589147, "callback", newJString(callback))
  add(query_589147, "access_token", newJString(accessToken))
  add(query_589147, "uploadType", newJString(uploadType))
  add(path_589146, "triggerId", newJString(triggerId))
  add(query_589147, "key", newJString(key))
  add(path_589146, "projectId", newJString(projectId))
  add(query_589147, "$.xgafv", newJString(Xgafv))
  add(query_589147, "prettyPrint", newJBool(prettyPrint))
  result = call_589145.call(path_589146, query_589147, nil, nil, nil)

var cloudbuildProjectsTriggersGet* = Call_CloudbuildProjectsTriggersGet_589128(
    name: "cloudbuildProjectsTriggersGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersGet_589129, base: "/",
    url: url_CloudbuildProjectsTriggersGet_589130, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersPatch_589168 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsTriggersPatch_589170(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersPatch_589169(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   triggerId: JString (required)
  ##            : ID of the `BuildTrigger` to update.
  ##   projectId: JString (required)
  ##            : ID of the project that owns the trigger.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `triggerId` field"
  var valid_589171 = path.getOrDefault("triggerId")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = nil)
  if valid_589171 != nil:
    section.add "triggerId", valid_589171
  var valid_589172 = path.getOrDefault("projectId")
  valid_589172 = validateParameter(valid_589172, JString, required = true,
                                 default = nil)
  if valid_589172 != nil:
    section.add "projectId", valid_589172
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
  var valid_589173 = query.getOrDefault("upload_protocol")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "upload_protocol", valid_589173
  var valid_589174 = query.getOrDefault("fields")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "fields", valid_589174
  var valid_589175 = query.getOrDefault("quotaUser")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "quotaUser", valid_589175
  var valid_589176 = query.getOrDefault("alt")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = newJString("json"))
  if valid_589176 != nil:
    section.add "alt", valid_589176
  var valid_589177 = query.getOrDefault("oauth_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "oauth_token", valid_589177
  var valid_589178 = query.getOrDefault("callback")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "callback", valid_589178
  var valid_589179 = query.getOrDefault("access_token")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "access_token", valid_589179
  var valid_589180 = query.getOrDefault("uploadType")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "uploadType", valid_589180
  var valid_589181 = query.getOrDefault("key")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "key", valid_589181
  var valid_589182 = query.getOrDefault("$.xgafv")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = newJString("1"))
  if valid_589182 != nil:
    section.add "$.xgafv", valid_589182
  var valid_589183 = query.getOrDefault("prettyPrint")
  valid_589183 = validateParameter(valid_589183, JBool, required = false,
                                 default = newJBool(true))
  if valid_589183 != nil:
    section.add "prettyPrint", valid_589183
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

proc call*(call_589185: Call_CloudbuildProjectsTriggersPatch_589168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_589185.validator(path, query, header, formData, body)
  let scheme = call_589185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589185.url(scheme.get, call_589185.host, call_589185.base,
                         call_589185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589185, url, valid)

proc call*(call_589186: Call_CloudbuildProjectsTriggersPatch_589168;
          triggerId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsTriggersPatch
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   triggerId: string (required)
  ##            : ID of the `BuildTrigger` to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the project that owns the trigger.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589187 = newJObject()
  var query_589188 = newJObject()
  var body_589189 = newJObject()
  add(query_589188, "upload_protocol", newJString(uploadProtocol))
  add(query_589188, "fields", newJString(fields))
  add(query_589188, "quotaUser", newJString(quotaUser))
  add(query_589188, "alt", newJString(alt))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "callback", newJString(callback))
  add(query_589188, "access_token", newJString(accessToken))
  add(query_589188, "uploadType", newJString(uploadType))
  add(path_589187, "triggerId", newJString(triggerId))
  add(query_589188, "key", newJString(key))
  add(path_589187, "projectId", newJString(projectId))
  add(query_589188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589189 = body
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  result = call_589186.call(path_589187, query_589188, nil, nil, body_589189)

var cloudbuildProjectsTriggersPatch* = Call_CloudbuildProjectsTriggersPatch_589168(
    name: "cloudbuildProjectsTriggersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersPatch_589169, base: "/",
    url: url_CloudbuildProjectsTriggersPatch_589170, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersDelete_589148 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsTriggersDelete_589150(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersDelete_589149(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   triggerId: JString (required)
  ##            : ID of the `BuildTrigger` to delete.
  ##   projectId: JString (required)
  ##            : ID of the project that owns the trigger.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `triggerId` field"
  var valid_589151 = path.getOrDefault("triggerId")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "triggerId", valid_589151
  var valid_589152 = path.getOrDefault("projectId")
  valid_589152 = validateParameter(valid_589152, JString, required = true,
                                 default = nil)
  if valid_589152 != nil:
    section.add "projectId", valid_589152
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
  var valid_589153 = query.getOrDefault("upload_protocol")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "upload_protocol", valid_589153
  var valid_589154 = query.getOrDefault("fields")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "fields", valid_589154
  var valid_589155 = query.getOrDefault("quotaUser")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "quotaUser", valid_589155
  var valid_589156 = query.getOrDefault("alt")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("json"))
  if valid_589156 != nil:
    section.add "alt", valid_589156
  var valid_589157 = query.getOrDefault("oauth_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "oauth_token", valid_589157
  var valid_589158 = query.getOrDefault("callback")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "callback", valid_589158
  var valid_589159 = query.getOrDefault("access_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "access_token", valid_589159
  var valid_589160 = query.getOrDefault("uploadType")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "uploadType", valid_589160
  var valid_589161 = query.getOrDefault("key")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "key", valid_589161
  var valid_589162 = query.getOrDefault("$.xgafv")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = newJString("1"))
  if valid_589162 != nil:
    section.add "$.xgafv", valid_589162
  var valid_589163 = query.getOrDefault("prettyPrint")
  valid_589163 = validateParameter(valid_589163, JBool, required = false,
                                 default = newJBool(true))
  if valid_589163 != nil:
    section.add "prettyPrint", valid_589163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589164: Call_CloudbuildProjectsTriggersDelete_589148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_589164.validator(path, query, header, formData, body)
  let scheme = call_589164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589164.url(scheme.get, call_589164.host, call_589164.base,
                         call_589164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589164, url, valid)

proc call*(call_589165: Call_CloudbuildProjectsTriggersDelete_589148;
          triggerId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsTriggersDelete
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   triggerId: string (required)
  ##            : ID of the `BuildTrigger` to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the project that owns the trigger.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589166 = newJObject()
  var query_589167 = newJObject()
  add(query_589167, "upload_protocol", newJString(uploadProtocol))
  add(query_589167, "fields", newJString(fields))
  add(query_589167, "quotaUser", newJString(quotaUser))
  add(query_589167, "alt", newJString(alt))
  add(query_589167, "oauth_token", newJString(oauthToken))
  add(query_589167, "callback", newJString(callback))
  add(query_589167, "access_token", newJString(accessToken))
  add(query_589167, "uploadType", newJString(uploadType))
  add(path_589166, "triggerId", newJString(triggerId))
  add(query_589167, "key", newJString(key))
  add(path_589166, "projectId", newJString(projectId))
  add(query_589167, "$.xgafv", newJString(Xgafv))
  add(query_589167, "prettyPrint", newJBool(prettyPrint))
  result = call_589165.call(path_589166, query_589167, nil, nil, nil)

var cloudbuildProjectsTriggersDelete* = Call_CloudbuildProjectsTriggersDelete_589148(
    name: "cloudbuildProjectsTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersDelete_589149, base: "/",
    url: url_CloudbuildProjectsTriggersDelete_589150, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersRun_589190 = ref object of OpenApiRestCall_588441
proc url_CloudbuildProjectsTriggersRun_589192(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersRun_589191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a `BuildTrigger` at a particular source revision.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   triggerId: JString (required)
  ##            : ID of the trigger.
  ##   projectId: JString (required)
  ##            : ID of the project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `triggerId` field"
  var valid_589193 = path.getOrDefault("triggerId")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "triggerId", valid_589193
  var valid_589194 = path.getOrDefault("projectId")
  valid_589194 = validateParameter(valid_589194, JString, required = true,
                                 default = nil)
  if valid_589194 != nil:
    section.add "projectId", valid_589194
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
  var valid_589195 = query.getOrDefault("upload_protocol")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "upload_protocol", valid_589195
  var valid_589196 = query.getOrDefault("fields")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "fields", valid_589196
  var valid_589197 = query.getOrDefault("quotaUser")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "quotaUser", valid_589197
  var valid_589198 = query.getOrDefault("alt")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = newJString("json"))
  if valid_589198 != nil:
    section.add "alt", valid_589198
  var valid_589199 = query.getOrDefault("oauth_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "oauth_token", valid_589199
  var valid_589200 = query.getOrDefault("callback")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "callback", valid_589200
  var valid_589201 = query.getOrDefault("access_token")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "access_token", valid_589201
  var valid_589202 = query.getOrDefault("uploadType")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "uploadType", valid_589202
  var valid_589203 = query.getOrDefault("key")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "key", valid_589203
  var valid_589204 = query.getOrDefault("$.xgafv")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = newJString("1"))
  if valid_589204 != nil:
    section.add "$.xgafv", valid_589204
  var valid_589205 = query.getOrDefault("prettyPrint")
  valid_589205 = validateParameter(valid_589205, JBool, required = false,
                                 default = newJBool(true))
  if valid_589205 != nil:
    section.add "prettyPrint", valid_589205
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

proc call*(call_589207: Call_CloudbuildProjectsTriggersRun_589190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a `BuildTrigger` at a particular source revision.
  ## 
  let valid = call_589207.validator(path, query, header, formData, body)
  let scheme = call_589207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589207.url(scheme.get, call_589207.host, call_589207.base,
                         call_589207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589207, url, valid)

proc call*(call_589208: Call_CloudbuildProjectsTriggersRun_589190;
          triggerId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsTriggersRun
  ## Runs a `BuildTrigger` at a particular source revision.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   triggerId: string (required)
  ##            : ID of the trigger.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589209 = newJObject()
  var query_589210 = newJObject()
  var body_589211 = newJObject()
  add(query_589210, "upload_protocol", newJString(uploadProtocol))
  add(query_589210, "fields", newJString(fields))
  add(query_589210, "quotaUser", newJString(quotaUser))
  add(query_589210, "alt", newJString(alt))
  add(query_589210, "oauth_token", newJString(oauthToken))
  add(query_589210, "callback", newJString(callback))
  add(query_589210, "access_token", newJString(accessToken))
  add(query_589210, "uploadType", newJString(uploadType))
  add(path_589209, "triggerId", newJString(triggerId))
  add(query_589210, "key", newJString(key))
  add(path_589209, "projectId", newJString(projectId))
  add(query_589210, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589211 = body
  add(query_589210, "prettyPrint", newJBool(prettyPrint))
  result = call_589208.call(path_589209, query_589210, nil, nil, body_589211)

var cloudbuildProjectsTriggersRun* = Call_CloudbuildProjectsTriggersRun_589190(
    name: "cloudbuildProjectsTriggersRun", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}:run",
    validator: validate_CloudbuildProjectsTriggersRun_589191, base: "/",
    url: url_CloudbuildProjectsTriggersRun_589192, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsGet_589212 = ref object of OpenApiRestCall_588441
proc url_CloudbuildOperationsGet_589214(protocol: Scheme; host: string; base: string;
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

proc validate_CloudbuildOperationsGet_589213(path: JsonNode; query: JsonNode;
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
  var valid_589215 = path.getOrDefault("name")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "name", valid_589215
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
  var valid_589216 = query.getOrDefault("upload_protocol")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "upload_protocol", valid_589216
  var valid_589217 = query.getOrDefault("fields")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "fields", valid_589217
  var valid_589218 = query.getOrDefault("quotaUser")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "quotaUser", valid_589218
  var valid_589219 = query.getOrDefault("alt")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = newJString("json"))
  if valid_589219 != nil:
    section.add "alt", valid_589219
  var valid_589220 = query.getOrDefault("oauth_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "oauth_token", valid_589220
  var valid_589221 = query.getOrDefault("callback")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "callback", valid_589221
  var valid_589222 = query.getOrDefault("access_token")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "access_token", valid_589222
  var valid_589223 = query.getOrDefault("uploadType")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "uploadType", valid_589223
  var valid_589224 = query.getOrDefault("key")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "key", valid_589224
  var valid_589225 = query.getOrDefault("$.xgafv")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("1"))
  if valid_589225 != nil:
    section.add "$.xgafv", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589227: Call_CloudbuildOperationsGet_589212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589227.validator(path, query, header, formData, body)
  let scheme = call_589227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589227.url(scheme.get, call_589227.host, call_589227.base,
                         call_589227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589227, url, valid)

proc call*(call_589228: Call_CloudbuildOperationsGet_589212; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbuildOperationsGet
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
  var path_589229 = newJObject()
  var query_589230 = newJObject()
  add(query_589230, "upload_protocol", newJString(uploadProtocol))
  add(query_589230, "fields", newJString(fields))
  add(query_589230, "quotaUser", newJString(quotaUser))
  add(path_589229, "name", newJString(name))
  add(query_589230, "alt", newJString(alt))
  add(query_589230, "oauth_token", newJString(oauthToken))
  add(query_589230, "callback", newJString(callback))
  add(query_589230, "access_token", newJString(accessToken))
  add(query_589230, "uploadType", newJString(uploadType))
  add(query_589230, "key", newJString(key))
  add(query_589230, "$.xgafv", newJString(Xgafv))
  add(query_589230, "prettyPrint", newJBool(prettyPrint))
  result = call_589228.call(path_589229, query_589230, nil, nil, nil)

var cloudbuildOperationsGet* = Call_CloudbuildOperationsGet_589212(
    name: "cloudbuildOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbuildOperationsGet_589213, base: "/",
    url: url_CloudbuildOperationsGet_589214, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsCancel_589231 = ref object of OpenApiRestCall_588441
proc url_CloudbuildOperationsCancel_589233(protocol: Scheme; host: string;
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

proc validate_CloudbuildOperationsCancel_589232(path: JsonNode; query: JsonNode;
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
  var valid_589234 = path.getOrDefault("name")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "name", valid_589234
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
  var valid_589235 = query.getOrDefault("upload_protocol")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "upload_protocol", valid_589235
  var valid_589236 = query.getOrDefault("fields")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "fields", valid_589236
  var valid_589237 = query.getOrDefault("quotaUser")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "quotaUser", valid_589237
  var valid_589238 = query.getOrDefault("alt")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = newJString("json"))
  if valid_589238 != nil:
    section.add "alt", valid_589238
  var valid_589239 = query.getOrDefault("oauth_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "oauth_token", valid_589239
  var valid_589240 = query.getOrDefault("callback")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "callback", valid_589240
  var valid_589241 = query.getOrDefault("access_token")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "access_token", valid_589241
  var valid_589242 = query.getOrDefault("uploadType")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "uploadType", valid_589242
  var valid_589243 = query.getOrDefault("key")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "key", valid_589243
  var valid_589244 = query.getOrDefault("$.xgafv")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("1"))
  if valid_589244 != nil:
    section.add "$.xgafv", valid_589244
  var valid_589245 = query.getOrDefault("prettyPrint")
  valid_589245 = validateParameter(valid_589245, JBool, required = false,
                                 default = newJBool(true))
  if valid_589245 != nil:
    section.add "prettyPrint", valid_589245
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

proc call*(call_589247: Call_CloudbuildOperationsCancel_589231; path: JsonNode;
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
  let valid = call_589247.validator(path, query, header, formData, body)
  let scheme = call_589247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589247.url(scheme.get, call_589247.host, call_589247.base,
                         call_589247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589247, url, valid)

proc call*(call_589248: Call_CloudbuildOperationsCancel_589231; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589249 = newJObject()
  var query_589250 = newJObject()
  var body_589251 = newJObject()
  add(query_589250, "upload_protocol", newJString(uploadProtocol))
  add(query_589250, "fields", newJString(fields))
  add(query_589250, "quotaUser", newJString(quotaUser))
  add(path_589249, "name", newJString(name))
  add(query_589250, "alt", newJString(alt))
  add(query_589250, "oauth_token", newJString(oauthToken))
  add(query_589250, "callback", newJString(callback))
  add(query_589250, "access_token", newJString(accessToken))
  add(query_589250, "uploadType", newJString(uploadType))
  add(query_589250, "key", newJString(key))
  add(query_589250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589251 = body
  add(query_589250, "prettyPrint", newJBool(prettyPrint))
  result = call_589248.call(path_589249, query_589250, nil, nil, body_589251)

var cloudbuildOperationsCancel* = Call_CloudbuildOperationsCancel_589231(
    name: "cloudbuildOperationsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_CloudbuildOperationsCancel_589232, base: "/",
    url: url_CloudbuildOperationsCancel_589233, schemes: {Scheme.Https})
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
