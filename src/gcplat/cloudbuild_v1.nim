
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudbuild"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbuildProjectsBuildsCreate_597968 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsBuildsCreate_597970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsBuildsCreate_597969(path: JsonNode;
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
  var valid_597971 = path.getOrDefault("projectId")
  valid_597971 = validateParameter(valid_597971, JString, required = true,
                                 default = nil)
  if valid_597971 != nil:
    section.add "projectId", valid_597971
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
  var valid_597972 = query.getOrDefault("upload_protocol")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "upload_protocol", valid_597972
  var valid_597973 = query.getOrDefault("fields")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "fields", valid_597973
  var valid_597974 = query.getOrDefault("quotaUser")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "quotaUser", valid_597974
  var valid_597975 = query.getOrDefault("alt")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = newJString("json"))
  if valid_597975 != nil:
    section.add "alt", valid_597975
  var valid_597976 = query.getOrDefault("oauth_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "oauth_token", valid_597976
  var valid_597977 = query.getOrDefault("callback")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "callback", valid_597977
  var valid_597978 = query.getOrDefault("access_token")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "access_token", valid_597978
  var valid_597979 = query.getOrDefault("uploadType")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "uploadType", valid_597979
  var valid_597980 = query.getOrDefault("key")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "key", valid_597980
  var valid_597981 = query.getOrDefault("$.xgafv")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = newJString("1"))
  if valid_597981 != nil:
    section.add "$.xgafv", valid_597981
  var valid_597982 = query.getOrDefault("prettyPrint")
  valid_597982 = validateParameter(valid_597982, JBool, required = false,
                                 default = newJBool(true))
  if valid_597982 != nil:
    section.add "prettyPrint", valid_597982
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

proc call*(call_597984: Call_CloudbuildProjectsBuildsCreate_597968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a build with the specified configuration.
  ## 
  ## This method returns a long-running `Operation`, which includes the build
  ## ID. Pass the build ID to `GetBuild` to determine the build status (such as
  ## `SUCCESS` or `FAILURE`).
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_CloudbuildProjectsBuildsCreate_597968;
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
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  var body_597988 = newJObject()
  add(query_597987, "upload_protocol", newJString(uploadProtocol))
  add(query_597987, "fields", newJString(fields))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "callback", newJString(callback))
  add(query_597987, "access_token", newJString(accessToken))
  add(query_597987, "uploadType", newJString(uploadType))
  add(query_597987, "key", newJString(key))
  add(path_597986, "projectId", newJString(projectId))
  add(query_597987, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597988 = body
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  result = call_597985.call(path_597986, query_597987, nil, nil, body_597988)

var cloudbuildProjectsBuildsCreate* = Call_CloudbuildProjectsBuildsCreate_597968(
    name: "cloudbuildProjectsBuildsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsCreate_597969, base: "/",
    url: url_CloudbuildProjectsBuildsCreate_597970, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsList_597677 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsBuildsList_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsBuildsList_597678(path: JsonNode; query: JsonNode;
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
  var valid_597805 = path.getOrDefault("projectId")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "projectId", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("pageToken")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "pageToken", valid_597808
  var valid_597809 = query.getOrDefault("quotaUser")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "quotaUser", valid_597809
  var valid_597823 = query.getOrDefault("alt")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = newJString("json"))
  if valid_597823 != nil:
    section.add "alt", valid_597823
  var valid_597824 = query.getOrDefault("oauth_token")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "oauth_token", valid_597824
  var valid_597825 = query.getOrDefault("callback")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "callback", valid_597825
  var valid_597826 = query.getOrDefault("access_token")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "access_token", valid_597826
  var valid_597827 = query.getOrDefault("uploadType")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "uploadType", valid_597827
  var valid_597828 = query.getOrDefault("key")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "key", valid_597828
  var valid_597829 = query.getOrDefault("$.xgafv")
  valid_597829 = validateParameter(valid_597829, JString, required = false,
                                 default = newJString("1"))
  if valid_597829 != nil:
    section.add "$.xgafv", valid_597829
  var valid_597830 = query.getOrDefault("pageSize")
  valid_597830 = validateParameter(valid_597830, JInt, required = false, default = nil)
  if valid_597830 != nil:
    section.add "pageSize", valid_597830
  var valid_597831 = query.getOrDefault("prettyPrint")
  valid_597831 = validateParameter(valid_597831, JBool, required = false,
                                 default = newJBool(true))
  if valid_597831 != nil:
    section.add "prettyPrint", valid_597831
  var valid_597832 = query.getOrDefault("filter")
  valid_597832 = validateParameter(valid_597832, JString, required = false,
                                 default = nil)
  if valid_597832 != nil:
    section.add "filter", valid_597832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597855: Call_CloudbuildProjectsBuildsList_597677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists previously requested builds.
  ## 
  ## Previously requested builds may still be in-progress, or may have finished
  ## successfully or unsuccessfully.
  ## 
  let valid = call_597855.validator(path, query, header, formData, body)
  let scheme = call_597855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597855.url(scheme.get, call_597855.host, call_597855.base,
                         call_597855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597855, url, valid)

proc call*(call_597926: Call_CloudbuildProjectsBuildsList_597677;
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
  var path_597927 = newJObject()
  var query_597929 = newJObject()
  add(query_597929, "upload_protocol", newJString(uploadProtocol))
  add(query_597929, "fields", newJString(fields))
  add(query_597929, "pageToken", newJString(pageToken))
  add(query_597929, "quotaUser", newJString(quotaUser))
  add(query_597929, "alt", newJString(alt))
  add(query_597929, "oauth_token", newJString(oauthToken))
  add(query_597929, "callback", newJString(callback))
  add(query_597929, "access_token", newJString(accessToken))
  add(query_597929, "uploadType", newJString(uploadType))
  add(query_597929, "key", newJString(key))
  add(path_597927, "projectId", newJString(projectId))
  add(query_597929, "$.xgafv", newJString(Xgafv))
  add(query_597929, "pageSize", newJInt(pageSize))
  add(query_597929, "prettyPrint", newJBool(prettyPrint))
  add(query_597929, "filter", newJString(filter))
  result = call_597926.call(path_597927, query_597929, nil, nil, nil)

var cloudbuildProjectsBuildsList* = Call_CloudbuildProjectsBuildsList_597677(
    name: "cloudbuildProjectsBuildsList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsList_597678, base: "/",
    url: url_CloudbuildProjectsBuildsList_597679, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsGet_597989 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsBuildsGet_597991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsBuildsGet_597990(path: JsonNode; query: JsonNode;
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
  var valid_597992 = path.getOrDefault("id")
  valid_597992 = validateParameter(valid_597992, JString, required = true,
                                 default = nil)
  if valid_597992 != nil:
    section.add "id", valid_597992
  var valid_597993 = path.getOrDefault("projectId")
  valid_597993 = validateParameter(valid_597993, JString, required = true,
                                 default = nil)
  if valid_597993 != nil:
    section.add "projectId", valid_597993
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
  var valid_597994 = query.getOrDefault("upload_protocol")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "upload_protocol", valid_597994
  var valid_597995 = query.getOrDefault("fields")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "fields", valid_597995
  var valid_597996 = query.getOrDefault("quotaUser")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "quotaUser", valid_597996
  var valid_597997 = query.getOrDefault("alt")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = newJString("json"))
  if valid_597997 != nil:
    section.add "alt", valid_597997
  var valid_597998 = query.getOrDefault("oauth_token")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "oauth_token", valid_597998
  var valid_597999 = query.getOrDefault("callback")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "callback", valid_597999
  var valid_598000 = query.getOrDefault("access_token")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "access_token", valid_598000
  var valid_598001 = query.getOrDefault("uploadType")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "uploadType", valid_598001
  var valid_598002 = query.getOrDefault("key")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "key", valid_598002
  var valid_598003 = query.getOrDefault("$.xgafv")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = newJString("1"))
  if valid_598003 != nil:
    section.add "$.xgafv", valid_598003
  var valid_598004 = query.getOrDefault("prettyPrint")
  valid_598004 = validateParameter(valid_598004, JBool, required = false,
                                 default = newJBool(true))
  if valid_598004 != nil:
    section.add "prettyPrint", valid_598004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598005: Call_CloudbuildProjectsBuildsGet_597989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ## 
  let valid = call_598005.validator(path, query, header, formData, body)
  let scheme = call_598005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598005.url(scheme.get, call_598005.host, call_598005.base,
                         call_598005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598005, url, valid)

proc call*(call_598006: Call_CloudbuildProjectsBuildsGet_597989; id: string;
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
  var path_598007 = newJObject()
  var query_598008 = newJObject()
  add(query_598008, "upload_protocol", newJString(uploadProtocol))
  add(query_598008, "fields", newJString(fields))
  add(query_598008, "quotaUser", newJString(quotaUser))
  add(query_598008, "alt", newJString(alt))
  add(query_598008, "oauth_token", newJString(oauthToken))
  add(query_598008, "callback", newJString(callback))
  add(query_598008, "access_token", newJString(accessToken))
  add(query_598008, "uploadType", newJString(uploadType))
  add(path_598007, "id", newJString(id))
  add(query_598008, "key", newJString(key))
  add(path_598007, "projectId", newJString(projectId))
  add(query_598008, "$.xgafv", newJString(Xgafv))
  add(query_598008, "prettyPrint", newJBool(prettyPrint))
  result = call_598006.call(path_598007, query_598008, nil, nil, nil)

var cloudbuildProjectsBuildsGet* = Call_CloudbuildProjectsBuildsGet_597989(
    name: "cloudbuildProjectsBuildsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}",
    validator: validate_CloudbuildProjectsBuildsGet_597990, base: "/",
    url: url_CloudbuildProjectsBuildsGet_597991, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsCancel_598009 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsBuildsCancel_598011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsBuildsCancel_598010(path: JsonNode;
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
  var valid_598012 = path.getOrDefault("id")
  valid_598012 = validateParameter(valid_598012, JString, required = true,
                                 default = nil)
  if valid_598012 != nil:
    section.add "id", valid_598012
  var valid_598013 = path.getOrDefault("projectId")
  valid_598013 = validateParameter(valid_598013, JString, required = true,
                                 default = nil)
  if valid_598013 != nil:
    section.add "projectId", valid_598013
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
  var valid_598014 = query.getOrDefault("upload_protocol")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "upload_protocol", valid_598014
  var valid_598015 = query.getOrDefault("fields")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "fields", valid_598015
  var valid_598016 = query.getOrDefault("quotaUser")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "quotaUser", valid_598016
  var valid_598017 = query.getOrDefault("alt")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = newJString("json"))
  if valid_598017 != nil:
    section.add "alt", valid_598017
  var valid_598018 = query.getOrDefault("oauth_token")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "oauth_token", valid_598018
  var valid_598019 = query.getOrDefault("callback")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "callback", valid_598019
  var valid_598020 = query.getOrDefault("access_token")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "access_token", valid_598020
  var valid_598021 = query.getOrDefault("uploadType")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "uploadType", valid_598021
  var valid_598022 = query.getOrDefault("key")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "key", valid_598022
  var valid_598023 = query.getOrDefault("$.xgafv")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = newJString("1"))
  if valid_598023 != nil:
    section.add "$.xgafv", valid_598023
  var valid_598024 = query.getOrDefault("prettyPrint")
  valid_598024 = validateParameter(valid_598024, JBool, required = false,
                                 default = newJBool(true))
  if valid_598024 != nil:
    section.add "prettyPrint", valid_598024
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

proc call*(call_598026: Call_CloudbuildProjectsBuildsCancel_598009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a build in progress.
  ## 
  let valid = call_598026.validator(path, query, header, formData, body)
  let scheme = call_598026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598026.url(scheme.get, call_598026.host, call_598026.base,
                         call_598026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598026, url, valid)

proc call*(call_598027: Call_CloudbuildProjectsBuildsCancel_598009; id: string;
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
  var path_598028 = newJObject()
  var query_598029 = newJObject()
  var body_598030 = newJObject()
  add(query_598029, "upload_protocol", newJString(uploadProtocol))
  add(query_598029, "fields", newJString(fields))
  add(query_598029, "quotaUser", newJString(quotaUser))
  add(query_598029, "alt", newJString(alt))
  add(query_598029, "oauth_token", newJString(oauthToken))
  add(query_598029, "callback", newJString(callback))
  add(query_598029, "access_token", newJString(accessToken))
  add(query_598029, "uploadType", newJString(uploadType))
  add(path_598028, "id", newJString(id))
  add(query_598029, "key", newJString(key))
  add(path_598028, "projectId", newJString(projectId))
  add(query_598029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598030 = body
  add(query_598029, "prettyPrint", newJBool(prettyPrint))
  result = call_598027.call(path_598028, query_598029, nil, nil, body_598030)

var cloudbuildProjectsBuildsCancel* = Call_CloudbuildProjectsBuildsCancel_598009(
    name: "cloudbuildProjectsBuildsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:cancel",
    validator: validate_CloudbuildProjectsBuildsCancel_598010, base: "/",
    url: url_CloudbuildProjectsBuildsCancel_598011, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsRetry_598031 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsBuildsRetry_598033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsBuildsRetry_598032(path: JsonNode; query: JsonNode;
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
  var valid_598034 = path.getOrDefault("id")
  valid_598034 = validateParameter(valid_598034, JString, required = true,
                                 default = nil)
  if valid_598034 != nil:
    section.add "id", valid_598034
  var valid_598035 = path.getOrDefault("projectId")
  valid_598035 = validateParameter(valid_598035, JString, required = true,
                                 default = nil)
  if valid_598035 != nil:
    section.add "projectId", valid_598035
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
  var valid_598036 = query.getOrDefault("upload_protocol")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "upload_protocol", valid_598036
  var valid_598037 = query.getOrDefault("fields")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "fields", valid_598037
  var valid_598038 = query.getOrDefault("quotaUser")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "quotaUser", valid_598038
  var valid_598039 = query.getOrDefault("alt")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = newJString("json"))
  if valid_598039 != nil:
    section.add "alt", valid_598039
  var valid_598040 = query.getOrDefault("oauth_token")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "oauth_token", valid_598040
  var valid_598041 = query.getOrDefault("callback")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "callback", valid_598041
  var valid_598042 = query.getOrDefault("access_token")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "access_token", valid_598042
  var valid_598043 = query.getOrDefault("uploadType")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "uploadType", valid_598043
  var valid_598044 = query.getOrDefault("key")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "key", valid_598044
  var valid_598045 = query.getOrDefault("$.xgafv")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = newJString("1"))
  if valid_598045 != nil:
    section.add "$.xgafv", valid_598045
  var valid_598046 = query.getOrDefault("prettyPrint")
  valid_598046 = validateParameter(valid_598046, JBool, required = false,
                                 default = newJBool(true))
  if valid_598046 != nil:
    section.add "prettyPrint", valid_598046
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

proc call*(call_598048: Call_CloudbuildProjectsBuildsRetry_598031; path: JsonNode;
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
  let valid = call_598048.validator(path, query, header, formData, body)
  let scheme = call_598048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598048.url(scheme.get, call_598048.host, call_598048.base,
                         call_598048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598048, url, valid)

proc call*(call_598049: Call_CloudbuildProjectsBuildsRetry_598031; id: string;
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
  var path_598050 = newJObject()
  var query_598051 = newJObject()
  var body_598052 = newJObject()
  add(query_598051, "upload_protocol", newJString(uploadProtocol))
  add(query_598051, "fields", newJString(fields))
  add(query_598051, "quotaUser", newJString(quotaUser))
  add(query_598051, "alt", newJString(alt))
  add(query_598051, "oauth_token", newJString(oauthToken))
  add(query_598051, "callback", newJString(callback))
  add(query_598051, "access_token", newJString(accessToken))
  add(query_598051, "uploadType", newJString(uploadType))
  add(path_598050, "id", newJString(id))
  add(query_598051, "key", newJString(key))
  add(path_598050, "projectId", newJString(projectId))
  add(query_598051, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598052 = body
  add(query_598051, "prettyPrint", newJBool(prettyPrint))
  result = call_598049.call(path_598050, query_598051, nil, nil, body_598052)

var cloudbuildProjectsBuildsRetry* = Call_CloudbuildProjectsBuildsRetry_598031(
    name: "cloudbuildProjectsBuildsRetry", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:retry",
    validator: validate_CloudbuildProjectsBuildsRetry_598032, base: "/",
    url: url_CloudbuildProjectsBuildsRetry_598033, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersCreate_598074 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsTriggersCreate_598076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsTriggersCreate_598075(path: JsonNode;
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
  var valid_598077 = path.getOrDefault("projectId")
  valid_598077 = validateParameter(valid_598077, JString, required = true,
                                 default = nil)
  if valid_598077 != nil:
    section.add "projectId", valid_598077
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
  var valid_598078 = query.getOrDefault("upload_protocol")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "upload_protocol", valid_598078
  var valid_598079 = query.getOrDefault("fields")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "fields", valid_598079
  var valid_598080 = query.getOrDefault("quotaUser")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "quotaUser", valid_598080
  var valid_598081 = query.getOrDefault("alt")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = newJString("json"))
  if valid_598081 != nil:
    section.add "alt", valid_598081
  var valid_598082 = query.getOrDefault("oauth_token")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "oauth_token", valid_598082
  var valid_598083 = query.getOrDefault("callback")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "callback", valid_598083
  var valid_598084 = query.getOrDefault("access_token")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "access_token", valid_598084
  var valid_598085 = query.getOrDefault("uploadType")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "uploadType", valid_598085
  var valid_598086 = query.getOrDefault("key")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "key", valid_598086
  var valid_598087 = query.getOrDefault("$.xgafv")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = newJString("1"))
  if valid_598087 != nil:
    section.add "$.xgafv", valid_598087
  var valid_598088 = query.getOrDefault("prettyPrint")
  valid_598088 = validateParameter(valid_598088, JBool, required = false,
                                 default = newJBool(true))
  if valid_598088 != nil:
    section.add "prettyPrint", valid_598088
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

proc call*(call_598090: Call_CloudbuildProjectsTriggersCreate_598074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598090.validator(path, query, header, formData, body)
  let scheme = call_598090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598090.url(scheme.get, call_598090.host, call_598090.base,
                         call_598090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598090, url, valid)

proc call*(call_598091: Call_CloudbuildProjectsTriggersCreate_598074;
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
  var path_598092 = newJObject()
  var query_598093 = newJObject()
  var body_598094 = newJObject()
  add(query_598093, "upload_protocol", newJString(uploadProtocol))
  add(query_598093, "fields", newJString(fields))
  add(query_598093, "quotaUser", newJString(quotaUser))
  add(query_598093, "alt", newJString(alt))
  add(query_598093, "oauth_token", newJString(oauthToken))
  add(query_598093, "callback", newJString(callback))
  add(query_598093, "access_token", newJString(accessToken))
  add(query_598093, "uploadType", newJString(uploadType))
  add(query_598093, "key", newJString(key))
  add(path_598092, "projectId", newJString(projectId))
  add(query_598093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598094 = body
  add(query_598093, "prettyPrint", newJBool(prettyPrint))
  result = call_598091.call(path_598092, query_598093, nil, nil, body_598094)

var cloudbuildProjectsTriggersCreate* = Call_CloudbuildProjectsTriggersCreate_598074(
    name: "cloudbuildProjectsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersCreate_598075, base: "/",
    url: url_CloudbuildProjectsTriggersCreate_598076, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersList_598053 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsTriggersList_598055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsTriggersList_598054(path: JsonNode;
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
  var valid_598056 = path.getOrDefault("projectId")
  valid_598056 = validateParameter(valid_598056, JString, required = true,
                                 default = nil)
  if valid_598056 != nil:
    section.add "projectId", valid_598056
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
  var valid_598057 = query.getOrDefault("upload_protocol")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "upload_protocol", valid_598057
  var valid_598058 = query.getOrDefault("fields")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "fields", valid_598058
  var valid_598059 = query.getOrDefault("pageToken")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "pageToken", valid_598059
  var valid_598060 = query.getOrDefault("quotaUser")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "quotaUser", valid_598060
  var valid_598061 = query.getOrDefault("alt")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = newJString("json"))
  if valid_598061 != nil:
    section.add "alt", valid_598061
  var valid_598062 = query.getOrDefault("oauth_token")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "oauth_token", valid_598062
  var valid_598063 = query.getOrDefault("callback")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "callback", valid_598063
  var valid_598064 = query.getOrDefault("access_token")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "access_token", valid_598064
  var valid_598065 = query.getOrDefault("uploadType")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "uploadType", valid_598065
  var valid_598066 = query.getOrDefault("key")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "key", valid_598066
  var valid_598067 = query.getOrDefault("$.xgafv")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = newJString("1"))
  if valid_598067 != nil:
    section.add "$.xgafv", valid_598067
  var valid_598068 = query.getOrDefault("pageSize")
  valid_598068 = validateParameter(valid_598068, JInt, required = false, default = nil)
  if valid_598068 != nil:
    section.add "pageSize", valid_598068
  var valid_598069 = query.getOrDefault("prettyPrint")
  valid_598069 = validateParameter(valid_598069, JBool, required = false,
                                 default = newJBool(true))
  if valid_598069 != nil:
    section.add "prettyPrint", valid_598069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598070: Call_CloudbuildProjectsTriggersList_598053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing `BuildTrigger`s.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598070.validator(path, query, header, formData, body)
  let scheme = call_598070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598070.url(scheme.get, call_598070.host, call_598070.base,
                         call_598070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598070, url, valid)

proc call*(call_598071: Call_CloudbuildProjectsTriggersList_598053;
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
  var path_598072 = newJObject()
  var query_598073 = newJObject()
  add(query_598073, "upload_protocol", newJString(uploadProtocol))
  add(query_598073, "fields", newJString(fields))
  add(query_598073, "pageToken", newJString(pageToken))
  add(query_598073, "quotaUser", newJString(quotaUser))
  add(query_598073, "alt", newJString(alt))
  add(query_598073, "oauth_token", newJString(oauthToken))
  add(query_598073, "callback", newJString(callback))
  add(query_598073, "access_token", newJString(accessToken))
  add(query_598073, "uploadType", newJString(uploadType))
  add(query_598073, "key", newJString(key))
  add(path_598072, "projectId", newJString(projectId))
  add(query_598073, "$.xgafv", newJString(Xgafv))
  add(query_598073, "pageSize", newJInt(pageSize))
  add(query_598073, "prettyPrint", newJBool(prettyPrint))
  result = call_598071.call(path_598072, query_598073, nil, nil, nil)

var cloudbuildProjectsTriggersList* = Call_CloudbuildProjectsTriggersList_598053(
    name: "cloudbuildProjectsTriggersList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersList_598054, base: "/",
    url: url_CloudbuildProjectsTriggersList_598055, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersGet_598095 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsTriggersGet_598097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsTriggersGet_598096(path: JsonNode; query: JsonNode;
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
  var valid_598098 = path.getOrDefault("triggerId")
  valid_598098 = validateParameter(valid_598098, JString, required = true,
                                 default = nil)
  if valid_598098 != nil:
    section.add "triggerId", valid_598098
  var valid_598099 = path.getOrDefault("projectId")
  valid_598099 = validateParameter(valid_598099, JString, required = true,
                                 default = nil)
  if valid_598099 != nil:
    section.add "projectId", valid_598099
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
  var valid_598100 = query.getOrDefault("upload_protocol")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "upload_protocol", valid_598100
  var valid_598101 = query.getOrDefault("fields")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "fields", valid_598101
  var valid_598102 = query.getOrDefault("quotaUser")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "quotaUser", valid_598102
  var valid_598103 = query.getOrDefault("alt")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = newJString("json"))
  if valid_598103 != nil:
    section.add "alt", valid_598103
  var valid_598104 = query.getOrDefault("oauth_token")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "oauth_token", valid_598104
  var valid_598105 = query.getOrDefault("callback")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "callback", valid_598105
  var valid_598106 = query.getOrDefault("access_token")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "access_token", valid_598106
  var valid_598107 = query.getOrDefault("uploadType")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "uploadType", valid_598107
  var valid_598108 = query.getOrDefault("key")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "key", valid_598108
  var valid_598109 = query.getOrDefault("$.xgafv")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = newJString("1"))
  if valid_598109 != nil:
    section.add "$.xgafv", valid_598109
  var valid_598110 = query.getOrDefault("prettyPrint")
  valid_598110 = validateParameter(valid_598110, JBool, required = false,
                                 default = newJBool(true))
  if valid_598110 != nil:
    section.add "prettyPrint", valid_598110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598111: Call_CloudbuildProjectsTriggersGet_598095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598111.validator(path, query, header, formData, body)
  let scheme = call_598111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598111.url(scheme.get, call_598111.host, call_598111.base,
                         call_598111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598111, url, valid)

proc call*(call_598112: Call_CloudbuildProjectsTriggersGet_598095;
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
  var path_598113 = newJObject()
  var query_598114 = newJObject()
  add(query_598114, "upload_protocol", newJString(uploadProtocol))
  add(query_598114, "fields", newJString(fields))
  add(query_598114, "quotaUser", newJString(quotaUser))
  add(query_598114, "alt", newJString(alt))
  add(query_598114, "oauth_token", newJString(oauthToken))
  add(query_598114, "callback", newJString(callback))
  add(query_598114, "access_token", newJString(accessToken))
  add(query_598114, "uploadType", newJString(uploadType))
  add(path_598113, "triggerId", newJString(triggerId))
  add(query_598114, "key", newJString(key))
  add(path_598113, "projectId", newJString(projectId))
  add(query_598114, "$.xgafv", newJString(Xgafv))
  add(query_598114, "prettyPrint", newJBool(prettyPrint))
  result = call_598112.call(path_598113, query_598114, nil, nil, nil)

var cloudbuildProjectsTriggersGet* = Call_CloudbuildProjectsTriggersGet_598095(
    name: "cloudbuildProjectsTriggersGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersGet_598096, base: "/",
    url: url_CloudbuildProjectsTriggersGet_598097, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersPatch_598135 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsTriggersPatch_598137(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsTriggersPatch_598136(path: JsonNode;
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
  var valid_598138 = path.getOrDefault("triggerId")
  valid_598138 = validateParameter(valid_598138, JString, required = true,
                                 default = nil)
  if valid_598138 != nil:
    section.add "triggerId", valid_598138
  var valid_598139 = path.getOrDefault("projectId")
  valid_598139 = validateParameter(valid_598139, JString, required = true,
                                 default = nil)
  if valid_598139 != nil:
    section.add "projectId", valid_598139
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
  var valid_598140 = query.getOrDefault("upload_protocol")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "upload_protocol", valid_598140
  var valid_598141 = query.getOrDefault("fields")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "fields", valid_598141
  var valid_598142 = query.getOrDefault("quotaUser")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "quotaUser", valid_598142
  var valid_598143 = query.getOrDefault("alt")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = newJString("json"))
  if valid_598143 != nil:
    section.add "alt", valid_598143
  var valid_598144 = query.getOrDefault("oauth_token")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "oauth_token", valid_598144
  var valid_598145 = query.getOrDefault("callback")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "callback", valid_598145
  var valid_598146 = query.getOrDefault("access_token")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "access_token", valid_598146
  var valid_598147 = query.getOrDefault("uploadType")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "uploadType", valid_598147
  var valid_598148 = query.getOrDefault("key")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "key", valid_598148
  var valid_598149 = query.getOrDefault("$.xgafv")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = newJString("1"))
  if valid_598149 != nil:
    section.add "$.xgafv", valid_598149
  var valid_598150 = query.getOrDefault("prettyPrint")
  valid_598150 = validateParameter(valid_598150, JBool, required = false,
                                 default = newJBool(true))
  if valid_598150 != nil:
    section.add "prettyPrint", valid_598150
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

proc call*(call_598152: Call_CloudbuildProjectsTriggersPatch_598135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598152.validator(path, query, header, formData, body)
  let scheme = call_598152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598152.url(scheme.get, call_598152.host, call_598152.base,
                         call_598152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598152, url, valid)

proc call*(call_598153: Call_CloudbuildProjectsTriggersPatch_598135;
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
  var path_598154 = newJObject()
  var query_598155 = newJObject()
  var body_598156 = newJObject()
  add(query_598155, "upload_protocol", newJString(uploadProtocol))
  add(query_598155, "fields", newJString(fields))
  add(query_598155, "quotaUser", newJString(quotaUser))
  add(query_598155, "alt", newJString(alt))
  add(query_598155, "oauth_token", newJString(oauthToken))
  add(query_598155, "callback", newJString(callback))
  add(query_598155, "access_token", newJString(accessToken))
  add(query_598155, "uploadType", newJString(uploadType))
  add(path_598154, "triggerId", newJString(triggerId))
  add(query_598155, "key", newJString(key))
  add(path_598154, "projectId", newJString(projectId))
  add(query_598155, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598156 = body
  add(query_598155, "prettyPrint", newJBool(prettyPrint))
  result = call_598153.call(path_598154, query_598155, nil, nil, body_598156)

var cloudbuildProjectsTriggersPatch* = Call_CloudbuildProjectsTriggersPatch_598135(
    name: "cloudbuildProjectsTriggersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersPatch_598136, base: "/",
    url: url_CloudbuildProjectsTriggersPatch_598137, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersDelete_598115 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsTriggersDelete_598117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsTriggersDelete_598116(path: JsonNode;
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
  var valid_598118 = path.getOrDefault("triggerId")
  valid_598118 = validateParameter(valid_598118, JString, required = true,
                                 default = nil)
  if valid_598118 != nil:
    section.add "triggerId", valid_598118
  var valid_598119 = path.getOrDefault("projectId")
  valid_598119 = validateParameter(valid_598119, JString, required = true,
                                 default = nil)
  if valid_598119 != nil:
    section.add "projectId", valid_598119
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
  var valid_598120 = query.getOrDefault("upload_protocol")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "upload_protocol", valid_598120
  var valid_598121 = query.getOrDefault("fields")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "fields", valid_598121
  var valid_598122 = query.getOrDefault("quotaUser")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "quotaUser", valid_598122
  var valid_598123 = query.getOrDefault("alt")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = newJString("json"))
  if valid_598123 != nil:
    section.add "alt", valid_598123
  var valid_598124 = query.getOrDefault("oauth_token")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "oauth_token", valid_598124
  var valid_598125 = query.getOrDefault("callback")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "callback", valid_598125
  var valid_598126 = query.getOrDefault("access_token")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "access_token", valid_598126
  var valid_598127 = query.getOrDefault("uploadType")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "uploadType", valid_598127
  var valid_598128 = query.getOrDefault("key")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "key", valid_598128
  var valid_598129 = query.getOrDefault("$.xgafv")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = newJString("1"))
  if valid_598129 != nil:
    section.add "$.xgafv", valid_598129
  var valid_598130 = query.getOrDefault("prettyPrint")
  valid_598130 = validateParameter(valid_598130, JBool, required = false,
                                 default = newJBool(true))
  if valid_598130 != nil:
    section.add "prettyPrint", valid_598130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598131: Call_CloudbuildProjectsTriggersDelete_598115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598131.validator(path, query, header, formData, body)
  let scheme = call_598131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598131.url(scheme.get, call_598131.host, call_598131.base,
                         call_598131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598131, url, valid)

proc call*(call_598132: Call_CloudbuildProjectsTriggersDelete_598115;
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
  var path_598133 = newJObject()
  var query_598134 = newJObject()
  add(query_598134, "upload_protocol", newJString(uploadProtocol))
  add(query_598134, "fields", newJString(fields))
  add(query_598134, "quotaUser", newJString(quotaUser))
  add(query_598134, "alt", newJString(alt))
  add(query_598134, "oauth_token", newJString(oauthToken))
  add(query_598134, "callback", newJString(callback))
  add(query_598134, "access_token", newJString(accessToken))
  add(query_598134, "uploadType", newJString(uploadType))
  add(path_598133, "triggerId", newJString(triggerId))
  add(query_598134, "key", newJString(key))
  add(path_598133, "projectId", newJString(projectId))
  add(query_598134, "$.xgafv", newJString(Xgafv))
  add(query_598134, "prettyPrint", newJBool(prettyPrint))
  result = call_598132.call(path_598133, query_598134, nil, nil, nil)

var cloudbuildProjectsTriggersDelete* = Call_CloudbuildProjectsTriggersDelete_598115(
    name: "cloudbuildProjectsTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersDelete_598116, base: "/",
    url: url_CloudbuildProjectsTriggersDelete_598117, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersRun_598157 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsTriggersRun_598159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsTriggersRun_598158(path: JsonNode; query: JsonNode;
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
  var valid_598160 = path.getOrDefault("triggerId")
  valid_598160 = validateParameter(valid_598160, JString, required = true,
                                 default = nil)
  if valid_598160 != nil:
    section.add "triggerId", valid_598160
  var valid_598161 = path.getOrDefault("projectId")
  valid_598161 = validateParameter(valid_598161, JString, required = true,
                                 default = nil)
  if valid_598161 != nil:
    section.add "projectId", valid_598161
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
  var valid_598162 = query.getOrDefault("upload_protocol")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "upload_protocol", valid_598162
  var valid_598163 = query.getOrDefault("fields")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "fields", valid_598163
  var valid_598164 = query.getOrDefault("quotaUser")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "quotaUser", valid_598164
  var valid_598165 = query.getOrDefault("alt")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = newJString("json"))
  if valid_598165 != nil:
    section.add "alt", valid_598165
  var valid_598166 = query.getOrDefault("oauth_token")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "oauth_token", valid_598166
  var valid_598167 = query.getOrDefault("callback")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "callback", valid_598167
  var valid_598168 = query.getOrDefault("access_token")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "access_token", valid_598168
  var valid_598169 = query.getOrDefault("uploadType")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "uploadType", valid_598169
  var valid_598170 = query.getOrDefault("key")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "key", valid_598170
  var valid_598171 = query.getOrDefault("$.xgafv")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = newJString("1"))
  if valid_598171 != nil:
    section.add "$.xgafv", valid_598171
  var valid_598172 = query.getOrDefault("prettyPrint")
  valid_598172 = validateParameter(valid_598172, JBool, required = false,
                                 default = newJBool(true))
  if valid_598172 != nil:
    section.add "prettyPrint", valid_598172
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

proc call*(call_598174: Call_CloudbuildProjectsTriggersRun_598157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a `BuildTrigger` at a particular source revision.
  ## 
  let valid = call_598174.validator(path, query, header, formData, body)
  let scheme = call_598174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598174.url(scheme.get, call_598174.host, call_598174.base,
                         call_598174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598174, url, valid)

proc call*(call_598175: Call_CloudbuildProjectsTriggersRun_598157;
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
  var path_598176 = newJObject()
  var query_598177 = newJObject()
  var body_598178 = newJObject()
  add(query_598177, "upload_protocol", newJString(uploadProtocol))
  add(query_598177, "fields", newJString(fields))
  add(query_598177, "quotaUser", newJString(quotaUser))
  add(query_598177, "alt", newJString(alt))
  add(query_598177, "oauth_token", newJString(oauthToken))
  add(query_598177, "callback", newJString(callback))
  add(query_598177, "access_token", newJString(accessToken))
  add(query_598177, "uploadType", newJString(uploadType))
  add(path_598176, "triggerId", newJString(triggerId))
  add(query_598177, "key", newJString(key))
  add(path_598176, "projectId", newJString(projectId))
  add(query_598177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598178 = body
  add(query_598177, "prettyPrint", newJBool(prettyPrint))
  result = call_598175.call(path_598176, query_598177, nil, nil, body_598178)

var cloudbuildProjectsTriggersRun* = Call_CloudbuildProjectsTriggersRun_598157(
    name: "cloudbuildProjectsTriggersRun", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}:run",
    validator: validate_CloudbuildProjectsTriggersRun_598158, base: "/",
    url: url_CloudbuildProjectsTriggersRun_598159, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsGet_598179 = ref object of OpenApiRestCall_597408
proc url_CloudbuildOperationsGet_598181(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildOperationsGet_598180(path: JsonNode; query: JsonNode;
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
  var valid_598182 = path.getOrDefault("name")
  valid_598182 = validateParameter(valid_598182, JString, required = true,
                                 default = nil)
  if valid_598182 != nil:
    section.add "name", valid_598182
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
  var valid_598183 = query.getOrDefault("upload_protocol")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "upload_protocol", valid_598183
  var valid_598184 = query.getOrDefault("fields")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "fields", valid_598184
  var valid_598185 = query.getOrDefault("quotaUser")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "quotaUser", valid_598185
  var valid_598186 = query.getOrDefault("alt")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = newJString("json"))
  if valid_598186 != nil:
    section.add "alt", valid_598186
  var valid_598187 = query.getOrDefault("oauth_token")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "oauth_token", valid_598187
  var valid_598188 = query.getOrDefault("callback")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "callback", valid_598188
  var valid_598189 = query.getOrDefault("access_token")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "access_token", valid_598189
  var valid_598190 = query.getOrDefault("uploadType")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "uploadType", valid_598190
  var valid_598191 = query.getOrDefault("key")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "key", valid_598191
  var valid_598192 = query.getOrDefault("$.xgafv")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = newJString("1"))
  if valid_598192 != nil:
    section.add "$.xgafv", valid_598192
  var valid_598193 = query.getOrDefault("prettyPrint")
  valid_598193 = validateParameter(valid_598193, JBool, required = false,
                                 default = newJBool(true))
  if valid_598193 != nil:
    section.add "prettyPrint", valid_598193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598194: Call_CloudbuildOperationsGet_598179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_598194.validator(path, query, header, formData, body)
  let scheme = call_598194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598194.url(scheme.get, call_598194.host, call_598194.base,
                         call_598194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598194, url, valid)

proc call*(call_598195: Call_CloudbuildOperationsGet_598179; name: string;
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
  var path_598196 = newJObject()
  var query_598197 = newJObject()
  add(query_598197, "upload_protocol", newJString(uploadProtocol))
  add(query_598197, "fields", newJString(fields))
  add(query_598197, "quotaUser", newJString(quotaUser))
  add(path_598196, "name", newJString(name))
  add(query_598197, "alt", newJString(alt))
  add(query_598197, "oauth_token", newJString(oauthToken))
  add(query_598197, "callback", newJString(callback))
  add(query_598197, "access_token", newJString(accessToken))
  add(query_598197, "uploadType", newJString(uploadType))
  add(query_598197, "key", newJString(key))
  add(query_598197, "$.xgafv", newJString(Xgafv))
  add(query_598197, "prettyPrint", newJBool(prettyPrint))
  result = call_598195.call(path_598196, query_598197, nil, nil, nil)

var cloudbuildOperationsGet* = Call_CloudbuildOperationsGet_598179(
    name: "cloudbuildOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbuildOperationsGet_598180, base: "/",
    url: url_CloudbuildOperationsGet_598181, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsCancel_598198 = ref object of OpenApiRestCall_597408
proc url_CloudbuildOperationsCancel_598200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildOperationsCancel_598199(path: JsonNode; query: JsonNode;
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
  var valid_598201 = path.getOrDefault("name")
  valid_598201 = validateParameter(valid_598201, JString, required = true,
                                 default = nil)
  if valid_598201 != nil:
    section.add "name", valid_598201
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
  var valid_598202 = query.getOrDefault("upload_protocol")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "upload_protocol", valid_598202
  var valid_598203 = query.getOrDefault("fields")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "fields", valid_598203
  var valid_598204 = query.getOrDefault("quotaUser")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "quotaUser", valid_598204
  var valid_598205 = query.getOrDefault("alt")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = newJString("json"))
  if valid_598205 != nil:
    section.add "alt", valid_598205
  var valid_598206 = query.getOrDefault("oauth_token")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "oauth_token", valid_598206
  var valid_598207 = query.getOrDefault("callback")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "callback", valid_598207
  var valid_598208 = query.getOrDefault("access_token")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "access_token", valid_598208
  var valid_598209 = query.getOrDefault("uploadType")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "uploadType", valid_598209
  var valid_598210 = query.getOrDefault("key")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "key", valid_598210
  var valid_598211 = query.getOrDefault("$.xgafv")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = newJString("1"))
  if valid_598211 != nil:
    section.add "$.xgafv", valid_598211
  var valid_598212 = query.getOrDefault("prettyPrint")
  valid_598212 = validateParameter(valid_598212, JBool, required = false,
                                 default = newJBool(true))
  if valid_598212 != nil:
    section.add "prettyPrint", valid_598212
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

proc call*(call_598214: Call_CloudbuildOperationsCancel_598198; path: JsonNode;
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
  let valid = call_598214.validator(path, query, header, formData, body)
  let scheme = call_598214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598214.url(scheme.get, call_598214.host, call_598214.base,
                         call_598214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598214, url, valid)

proc call*(call_598215: Call_CloudbuildOperationsCancel_598198; name: string;
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
  var path_598216 = newJObject()
  var query_598217 = newJObject()
  var body_598218 = newJObject()
  add(query_598217, "upload_protocol", newJString(uploadProtocol))
  add(query_598217, "fields", newJString(fields))
  add(query_598217, "quotaUser", newJString(quotaUser))
  add(path_598216, "name", newJString(name))
  add(query_598217, "alt", newJString(alt))
  add(query_598217, "oauth_token", newJString(oauthToken))
  add(query_598217, "callback", newJString(callback))
  add(query_598217, "access_token", newJString(accessToken))
  add(query_598217, "uploadType", newJString(uploadType))
  add(query_598217, "key", newJString(key))
  add(query_598217, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598218 = body
  add(query_598217, "prettyPrint", newJBool(prettyPrint))
  result = call_598215.call(path_598216, query_598217, nil, nil, body_598218)

var cloudbuildOperationsCancel* = Call_CloudbuildOperationsCancel_598198(
    name: "cloudbuildOperationsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_CloudbuildOperationsCancel_598199, base: "/",
    url: url_CloudbuildOperationsCancel_598200, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
