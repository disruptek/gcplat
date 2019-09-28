
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
  gcpServiceName = "cloudbuild"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbuildProjectsBuildsCreate_579968 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsBuildsCreate_579970(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsCreate_579969(path: JsonNode;
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
  var valid_579971 = path.getOrDefault("projectId")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "projectId", valid_579971
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
  var valid_579972 = query.getOrDefault("upload_protocol")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "upload_protocol", valid_579972
  var valid_579973 = query.getOrDefault("fields")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "fields", valid_579973
  var valid_579974 = query.getOrDefault("quotaUser")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "quotaUser", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
  var valid_579976 = query.getOrDefault("oauth_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "oauth_token", valid_579976
  var valid_579977 = query.getOrDefault("callback")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "callback", valid_579977
  var valid_579978 = query.getOrDefault("access_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "access_token", valid_579978
  var valid_579979 = query.getOrDefault("uploadType")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "uploadType", valid_579979
  var valid_579980 = query.getOrDefault("key")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "key", valid_579980
  var valid_579981 = query.getOrDefault("$.xgafv")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("1"))
  if valid_579981 != nil:
    section.add "$.xgafv", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
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

proc call*(call_579984: Call_CloudbuildProjectsBuildsCreate_579968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a build with the specified configuration.
  ## 
  ## This method returns a long-running `Operation`, which includes the build
  ## ID. Pass the build ID to `GetBuild` to determine the build status (such as
  ## `SUCCESS` or `FAILURE`).
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_CloudbuildProjectsBuildsCreate_579968;
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
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  var body_579988 = newJObject()
  add(query_579987, "upload_protocol", newJString(uploadProtocol))
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "callback", newJString(callback))
  add(query_579987, "access_token", newJString(accessToken))
  add(query_579987, "uploadType", newJString(uploadType))
  add(query_579987, "key", newJString(key))
  add(path_579986, "projectId", newJString(projectId))
  add(query_579987, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579988 = body
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(path_579986, query_579987, nil, nil, body_579988)

var cloudbuildProjectsBuildsCreate* = Call_CloudbuildProjectsBuildsCreate_579968(
    name: "cloudbuildProjectsBuildsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsCreate_579969, base: "/",
    url: url_CloudbuildProjectsBuildsCreate_579970, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsList_579677 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsBuildsList_579679(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579805 = path.getOrDefault("projectId")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "projectId", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("pageToken")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "pageToken", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("callback")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "callback", valid_579825
  var valid_579826 = query.getOrDefault("access_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "access_token", valid_579826
  var valid_579827 = query.getOrDefault("uploadType")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "uploadType", valid_579827
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
  var valid_579829 = query.getOrDefault("$.xgafv")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("1"))
  if valid_579829 != nil:
    section.add "$.xgafv", valid_579829
  var valid_579830 = query.getOrDefault("pageSize")
  valid_579830 = validateParameter(valid_579830, JInt, required = false, default = nil)
  if valid_579830 != nil:
    section.add "pageSize", valid_579830
  var valid_579831 = query.getOrDefault("prettyPrint")
  valid_579831 = validateParameter(valid_579831, JBool, required = false,
                                 default = newJBool(true))
  if valid_579831 != nil:
    section.add "prettyPrint", valid_579831
  var valid_579832 = query.getOrDefault("filter")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "filter", valid_579832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579855: Call_CloudbuildProjectsBuildsList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists previously requested builds.
  ## 
  ## Previously requested builds may still be in-progress, or may have finished
  ## successfully or unsuccessfully.
  ## 
  let valid = call_579855.validator(path, query, header, formData, body)
  let scheme = call_579855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579855.url(scheme.get, call_579855.host, call_579855.base,
                         call_579855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579855, url, valid)

proc call*(call_579926: Call_CloudbuildProjectsBuildsList_579677;
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
  var path_579927 = newJObject()
  var query_579929 = newJObject()
  add(query_579929, "upload_protocol", newJString(uploadProtocol))
  add(query_579929, "fields", newJString(fields))
  add(query_579929, "pageToken", newJString(pageToken))
  add(query_579929, "quotaUser", newJString(quotaUser))
  add(query_579929, "alt", newJString(alt))
  add(query_579929, "oauth_token", newJString(oauthToken))
  add(query_579929, "callback", newJString(callback))
  add(query_579929, "access_token", newJString(accessToken))
  add(query_579929, "uploadType", newJString(uploadType))
  add(query_579929, "key", newJString(key))
  add(path_579927, "projectId", newJString(projectId))
  add(query_579929, "$.xgafv", newJString(Xgafv))
  add(query_579929, "pageSize", newJInt(pageSize))
  add(query_579929, "prettyPrint", newJBool(prettyPrint))
  add(query_579929, "filter", newJString(filter))
  result = call_579926.call(path_579927, query_579929, nil, nil, nil)

var cloudbuildProjectsBuildsList* = Call_CloudbuildProjectsBuildsList_579677(
    name: "cloudbuildProjectsBuildsList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/builds",
    validator: validate_CloudbuildProjectsBuildsList_579678, base: "/",
    url: url_CloudbuildProjectsBuildsList_579679, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsGet_579989 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsBuildsGet_579991(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsGet_579990(path: JsonNode; query: JsonNode;
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
  var valid_579992 = path.getOrDefault("id")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "id", valid_579992
  var valid_579993 = path.getOrDefault("projectId")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "projectId", valid_579993
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
  var valid_579994 = query.getOrDefault("upload_protocol")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "upload_protocol", valid_579994
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("callback")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "callback", valid_579999
  var valid_580000 = query.getOrDefault("access_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "access_token", valid_580000
  var valid_580001 = query.getOrDefault("uploadType")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "uploadType", valid_580001
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("$.xgafv")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("1"))
  if valid_580003 != nil:
    section.add "$.xgafv", valid_580003
  var valid_580004 = query.getOrDefault("prettyPrint")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(true))
  if valid_580004 != nil:
    section.add "prettyPrint", valid_580004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580005: Call_CloudbuildProjectsBuildsGet_579989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a previously requested build.
  ## 
  ## The `Build` that is returned includes its status (such as `SUCCESS`,
  ## `FAILURE`, or `WORKING`), and timing information.
  ## 
  let valid = call_580005.validator(path, query, header, formData, body)
  let scheme = call_580005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580005.url(scheme.get, call_580005.host, call_580005.base,
                         call_580005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580005, url, valid)

proc call*(call_580006: Call_CloudbuildProjectsBuildsGet_579989; id: string;
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
  var path_580007 = newJObject()
  var query_580008 = newJObject()
  add(query_580008, "upload_protocol", newJString(uploadProtocol))
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "quotaUser", newJString(quotaUser))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "callback", newJString(callback))
  add(query_580008, "access_token", newJString(accessToken))
  add(query_580008, "uploadType", newJString(uploadType))
  add(path_580007, "id", newJString(id))
  add(query_580008, "key", newJString(key))
  add(path_580007, "projectId", newJString(projectId))
  add(query_580008, "$.xgafv", newJString(Xgafv))
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  result = call_580006.call(path_580007, query_580008, nil, nil, nil)

var cloudbuildProjectsBuildsGet* = Call_CloudbuildProjectsBuildsGet_579989(
    name: "cloudbuildProjectsBuildsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}",
    validator: validate_CloudbuildProjectsBuildsGet_579990, base: "/",
    url: url_CloudbuildProjectsBuildsGet_579991, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsCancel_580009 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsBuildsCancel_580011(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsCancel_580010(path: JsonNode;
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
  var valid_580012 = path.getOrDefault("id")
  valid_580012 = validateParameter(valid_580012, JString, required = true,
                                 default = nil)
  if valid_580012 != nil:
    section.add "id", valid_580012
  var valid_580013 = path.getOrDefault("projectId")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "projectId", valid_580013
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
  var valid_580014 = query.getOrDefault("upload_protocol")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "upload_protocol", valid_580014
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("quotaUser")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "quotaUser", valid_580016
  var valid_580017 = query.getOrDefault("alt")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("json"))
  if valid_580017 != nil:
    section.add "alt", valid_580017
  var valid_580018 = query.getOrDefault("oauth_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "oauth_token", valid_580018
  var valid_580019 = query.getOrDefault("callback")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "callback", valid_580019
  var valid_580020 = query.getOrDefault("access_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "access_token", valid_580020
  var valid_580021 = query.getOrDefault("uploadType")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "uploadType", valid_580021
  var valid_580022 = query.getOrDefault("key")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "key", valid_580022
  var valid_580023 = query.getOrDefault("$.xgafv")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("1"))
  if valid_580023 != nil:
    section.add "$.xgafv", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
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

proc call*(call_580026: Call_CloudbuildProjectsBuildsCancel_580009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a build in progress.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_CloudbuildProjectsBuildsCancel_580009; id: string;
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
  var path_580028 = newJObject()
  var query_580029 = newJObject()
  var body_580030 = newJObject()
  add(query_580029, "upload_protocol", newJString(uploadProtocol))
  add(query_580029, "fields", newJString(fields))
  add(query_580029, "quotaUser", newJString(quotaUser))
  add(query_580029, "alt", newJString(alt))
  add(query_580029, "oauth_token", newJString(oauthToken))
  add(query_580029, "callback", newJString(callback))
  add(query_580029, "access_token", newJString(accessToken))
  add(query_580029, "uploadType", newJString(uploadType))
  add(path_580028, "id", newJString(id))
  add(query_580029, "key", newJString(key))
  add(path_580028, "projectId", newJString(projectId))
  add(query_580029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580030 = body
  add(query_580029, "prettyPrint", newJBool(prettyPrint))
  result = call_580027.call(path_580028, query_580029, nil, nil, body_580030)

var cloudbuildProjectsBuildsCancel* = Call_CloudbuildProjectsBuildsCancel_580009(
    name: "cloudbuildProjectsBuildsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:cancel",
    validator: validate_CloudbuildProjectsBuildsCancel_580010, base: "/",
    url: url_CloudbuildProjectsBuildsCancel_580011, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsBuildsRetry_580031 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsBuildsRetry_580033(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsBuildsRetry_580032(path: JsonNode; query: JsonNode;
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
  var valid_580034 = path.getOrDefault("id")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "id", valid_580034
  var valid_580035 = path.getOrDefault("projectId")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "projectId", valid_580035
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
  var valid_580036 = query.getOrDefault("upload_protocol")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "upload_protocol", valid_580036
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("callback")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "callback", valid_580041
  var valid_580042 = query.getOrDefault("access_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "access_token", valid_580042
  var valid_580043 = query.getOrDefault("uploadType")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "uploadType", valid_580043
  var valid_580044 = query.getOrDefault("key")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "key", valid_580044
  var valid_580045 = query.getOrDefault("$.xgafv")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("1"))
  if valid_580045 != nil:
    section.add "$.xgafv", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
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

proc call*(call_580048: Call_CloudbuildProjectsBuildsRetry_580031; path: JsonNode;
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
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_CloudbuildProjectsBuildsRetry_580031; id: string;
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
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  var body_580052 = newJObject()
  add(query_580051, "upload_protocol", newJString(uploadProtocol))
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "callback", newJString(callback))
  add(query_580051, "access_token", newJString(accessToken))
  add(query_580051, "uploadType", newJString(uploadType))
  add(path_580050, "id", newJString(id))
  add(query_580051, "key", newJString(key))
  add(path_580050, "projectId", newJString(projectId))
  add(query_580051, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580052 = body
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  result = call_580049.call(path_580050, query_580051, nil, nil, body_580052)

var cloudbuildProjectsBuildsRetry* = Call_CloudbuildProjectsBuildsRetry_580031(
    name: "cloudbuildProjectsBuildsRetry", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/builds/{id}:retry",
    validator: validate_CloudbuildProjectsBuildsRetry_580032, base: "/",
    url: url_CloudbuildProjectsBuildsRetry_580033, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersCreate_580074 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsTriggersCreate_580076(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersCreate_580075(path: JsonNode;
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
  var valid_580077 = path.getOrDefault("projectId")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "projectId", valid_580077
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
  var valid_580078 = query.getOrDefault("upload_protocol")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "upload_protocol", valid_580078
  var valid_580079 = query.getOrDefault("fields")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "fields", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("callback")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "callback", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("uploadType")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "uploadType", valid_580085
  var valid_580086 = query.getOrDefault("key")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "key", valid_580086
  var valid_580087 = query.getOrDefault("$.xgafv")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("1"))
  if valid_580087 != nil:
    section.add "$.xgafv", valid_580087
  var valid_580088 = query.getOrDefault("prettyPrint")
  valid_580088 = validateParameter(valid_580088, JBool, required = false,
                                 default = newJBool(true))
  if valid_580088 != nil:
    section.add "prettyPrint", valid_580088
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

proc call*(call_580090: Call_CloudbuildProjectsTriggersCreate_580074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580090.validator(path, query, header, formData, body)
  let scheme = call_580090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580090.url(scheme.get, call_580090.host, call_580090.base,
                         call_580090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580090, url, valid)

proc call*(call_580091: Call_CloudbuildProjectsTriggersCreate_580074;
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
  var path_580092 = newJObject()
  var query_580093 = newJObject()
  var body_580094 = newJObject()
  add(query_580093, "upload_protocol", newJString(uploadProtocol))
  add(query_580093, "fields", newJString(fields))
  add(query_580093, "quotaUser", newJString(quotaUser))
  add(query_580093, "alt", newJString(alt))
  add(query_580093, "oauth_token", newJString(oauthToken))
  add(query_580093, "callback", newJString(callback))
  add(query_580093, "access_token", newJString(accessToken))
  add(query_580093, "uploadType", newJString(uploadType))
  add(query_580093, "key", newJString(key))
  add(path_580092, "projectId", newJString(projectId))
  add(query_580093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580094 = body
  add(query_580093, "prettyPrint", newJBool(prettyPrint))
  result = call_580091.call(path_580092, query_580093, nil, nil, body_580094)

var cloudbuildProjectsTriggersCreate* = Call_CloudbuildProjectsTriggersCreate_580074(
    name: "cloudbuildProjectsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersCreate_580075, base: "/",
    url: url_CloudbuildProjectsTriggersCreate_580076, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersList_580053 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsTriggersList_580055(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersList_580054(path: JsonNode;
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
  var valid_580056 = path.getOrDefault("projectId")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "projectId", valid_580056
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
  var valid_580057 = query.getOrDefault("upload_protocol")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "upload_protocol", valid_580057
  var valid_580058 = query.getOrDefault("fields")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "fields", valid_580058
  var valid_580059 = query.getOrDefault("pageToken")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "pageToken", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("callback")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "callback", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("uploadType")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "uploadType", valid_580065
  var valid_580066 = query.getOrDefault("key")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "key", valid_580066
  var valid_580067 = query.getOrDefault("$.xgafv")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("1"))
  if valid_580067 != nil:
    section.add "$.xgafv", valid_580067
  var valid_580068 = query.getOrDefault("pageSize")
  valid_580068 = validateParameter(valid_580068, JInt, required = false, default = nil)
  if valid_580068 != nil:
    section.add "pageSize", valid_580068
  var valid_580069 = query.getOrDefault("prettyPrint")
  valid_580069 = validateParameter(valid_580069, JBool, required = false,
                                 default = newJBool(true))
  if valid_580069 != nil:
    section.add "prettyPrint", valid_580069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580070: Call_CloudbuildProjectsTriggersList_580053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing `BuildTrigger`s.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_CloudbuildProjectsTriggersList_580053;
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
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  add(query_580073, "upload_protocol", newJString(uploadProtocol))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "pageToken", newJString(pageToken))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "callback", newJString(callback))
  add(query_580073, "access_token", newJString(accessToken))
  add(query_580073, "uploadType", newJString(uploadType))
  add(query_580073, "key", newJString(key))
  add(path_580072, "projectId", newJString(projectId))
  add(query_580073, "$.xgafv", newJString(Xgafv))
  add(query_580073, "pageSize", newJInt(pageSize))
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  result = call_580071.call(path_580072, query_580073, nil, nil, nil)

var cloudbuildProjectsTriggersList* = Call_CloudbuildProjectsTriggersList_580053(
    name: "cloudbuildProjectsTriggersList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/projects/{projectId}/triggers",
    validator: validate_CloudbuildProjectsTriggersList_580054, base: "/",
    url: url_CloudbuildProjectsTriggersList_580055, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersGet_580095 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsTriggersGet_580097(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersGet_580096(path: JsonNode; query: JsonNode;
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
  var valid_580098 = path.getOrDefault("triggerId")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "triggerId", valid_580098
  var valid_580099 = path.getOrDefault("projectId")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "projectId", valid_580099
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
  var valid_580100 = query.getOrDefault("upload_protocol")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "upload_protocol", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("callback")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "callback", valid_580105
  var valid_580106 = query.getOrDefault("access_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "access_token", valid_580106
  var valid_580107 = query.getOrDefault("uploadType")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "uploadType", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("$.xgafv")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("1"))
  if valid_580109 != nil:
    section.add "$.xgafv", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580111: Call_CloudbuildProjectsTriggersGet_580095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a `BuildTrigger`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580111.validator(path, query, header, formData, body)
  let scheme = call_580111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580111.url(scheme.get, call_580111.host, call_580111.base,
                         call_580111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580111, url, valid)

proc call*(call_580112: Call_CloudbuildProjectsTriggersGet_580095;
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
  var path_580113 = newJObject()
  var query_580114 = newJObject()
  add(query_580114, "upload_protocol", newJString(uploadProtocol))
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "quotaUser", newJString(quotaUser))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(query_580114, "callback", newJString(callback))
  add(query_580114, "access_token", newJString(accessToken))
  add(query_580114, "uploadType", newJString(uploadType))
  add(path_580113, "triggerId", newJString(triggerId))
  add(query_580114, "key", newJString(key))
  add(path_580113, "projectId", newJString(projectId))
  add(query_580114, "$.xgafv", newJString(Xgafv))
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  result = call_580112.call(path_580113, query_580114, nil, nil, nil)

var cloudbuildProjectsTriggersGet* = Call_CloudbuildProjectsTriggersGet_580095(
    name: "cloudbuildProjectsTriggersGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersGet_580096, base: "/",
    url: url_CloudbuildProjectsTriggersGet_580097, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersPatch_580135 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsTriggersPatch_580137(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersPatch_580136(path: JsonNode;
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
  var valid_580138 = path.getOrDefault("triggerId")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "triggerId", valid_580138
  var valid_580139 = path.getOrDefault("projectId")
  valid_580139 = validateParameter(valid_580139, JString, required = true,
                                 default = nil)
  if valid_580139 != nil:
    section.add "projectId", valid_580139
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
  var valid_580140 = query.getOrDefault("upload_protocol")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "upload_protocol", valid_580140
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("callback")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "callback", valid_580145
  var valid_580146 = query.getOrDefault("access_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "access_token", valid_580146
  var valid_580147 = query.getOrDefault("uploadType")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "uploadType", valid_580147
  var valid_580148 = query.getOrDefault("key")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "key", valid_580148
  var valid_580149 = query.getOrDefault("$.xgafv")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("1"))
  if valid_580149 != nil:
    section.add "$.xgafv", valid_580149
  var valid_580150 = query.getOrDefault("prettyPrint")
  valid_580150 = validateParameter(valid_580150, JBool, required = false,
                                 default = newJBool(true))
  if valid_580150 != nil:
    section.add "prettyPrint", valid_580150
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

proc call*(call_580152: Call_CloudbuildProjectsTriggersPatch_580135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580152.validator(path, query, header, formData, body)
  let scheme = call_580152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580152.url(scheme.get, call_580152.host, call_580152.base,
                         call_580152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580152, url, valid)

proc call*(call_580153: Call_CloudbuildProjectsTriggersPatch_580135;
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
  var path_580154 = newJObject()
  var query_580155 = newJObject()
  var body_580156 = newJObject()
  add(query_580155, "upload_protocol", newJString(uploadProtocol))
  add(query_580155, "fields", newJString(fields))
  add(query_580155, "quotaUser", newJString(quotaUser))
  add(query_580155, "alt", newJString(alt))
  add(query_580155, "oauth_token", newJString(oauthToken))
  add(query_580155, "callback", newJString(callback))
  add(query_580155, "access_token", newJString(accessToken))
  add(query_580155, "uploadType", newJString(uploadType))
  add(path_580154, "triggerId", newJString(triggerId))
  add(query_580155, "key", newJString(key))
  add(path_580154, "projectId", newJString(projectId))
  add(query_580155, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580156 = body
  add(query_580155, "prettyPrint", newJBool(prettyPrint))
  result = call_580153.call(path_580154, query_580155, nil, nil, body_580156)

var cloudbuildProjectsTriggersPatch* = Call_CloudbuildProjectsTriggersPatch_580135(
    name: "cloudbuildProjectsTriggersPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersPatch_580136, base: "/",
    url: url_CloudbuildProjectsTriggersPatch_580137, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersDelete_580115 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsTriggersDelete_580117(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersDelete_580116(path: JsonNode;
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
  var valid_580118 = path.getOrDefault("triggerId")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "triggerId", valid_580118
  var valid_580119 = path.getOrDefault("projectId")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "projectId", valid_580119
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
  var valid_580120 = query.getOrDefault("upload_protocol")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "upload_protocol", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("oauth_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "oauth_token", valid_580124
  var valid_580125 = query.getOrDefault("callback")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "callback", valid_580125
  var valid_580126 = query.getOrDefault("access_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "access_token", valid_580126
  var valid_580127 = query.getOrDefault("uploadType")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "uploadType", valid_580127
  var valid_580128 = query.getOrDefault("key")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "key", valid_580128
  var valid_580129 = query.getOrDefault("$.xgafv")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("1"))
  if valid_580129 != nil:
    section.add "$.xgafv", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_CloudbuildProjectsTriggersDelete_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a `BuildTrigger` by its project ID and trigger ID.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_CloudbuildProjectsTriggersDelete_580115;
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
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  add(query_580134, "upload_protocol", newJString(uploadProtocol))
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "callback", newJString(callback))
  add(query_580134, "access_token", newJString(accessToken))
  add(query_580134, "uploadType", newJString(uploadType))
  add(path_580133, "triggerId", newJString(triggerId))
  add(query_580134, "key", newJString(key))
  add(path_580133, "projectId", newJString(projectId))
  add(query_580134, "$.xgafv", newJString(Xgafv))
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  result = call_580132.call(path_580133, query_580134, nil, nil, nil)

var cloudbuildProjectsTriggersDelete* = Call_CloudbuildProjectsTriggersDelete_580115(
    name: "cloudbuildProjectsTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}",
    validator: validate_CloudbuildProjectsTriggersDelete_580116, base: "/",
    url: url_CloudbuildProjectsTriggersDelete_580117, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsTriggersRun_580157 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsTriggersRun_580159(protocol: Scheme; host: string;
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

proc validate_CloudbuildProjectsTriggersRun_580158(path: JsonNode; query: JsonNode;
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
  var valid_580160 = path.getOrDefault("triggerId")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "triggerId", valid_580160
  var valid_580161 = path.getOrDefault("projectId")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "projectId", valid_580161
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
  var valid_580162 = query.getOrDefault("upload_protocol")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "upload_protocol", valid_580162
  var valid_580163 = query.getOrDefault("fields")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "fields", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("callback")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "callback", valid_580167
  var valid_580168 = query.getOrDefault("access_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "access_token", valid_580168
  var valid_580169 = query.getOrDefault("uploadType")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "uploadType", valid_580169
  var valid_580170 = query.getOrDefault("key")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "key", valid_580170
  var valid_580171 = query.getOrDefault("$.xgafv")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("1"))
  if valid_580171 != nil:
    section.add "$.xgafv", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
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

proc call*(call_580174: Call_CloudbuildProjectsTriggersRun_580157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a `BuildTrigger` at a particular source revision.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_CloudbuildProjectsTriggersRun_580157;
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
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  var body_580178 = newJObject()
  add(query_580177, "upload_protocol", newJString(uploadProtocol))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "callback", newJString(callback))
  add(query_580177, "access_token", newJString(accessToken))
  add(query_580177, "uploadType", newJString(uploadType))
  add(path_580176, "triggerId", newJString(triggerId))
  add(query_580177, "key", newJString(key))
  add(path_580176, "projectId", newJString(projectId))
  add(query_580177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580178 = body
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  result = call_580175.call(path_580176, query_580177, nil, nil, body_580178)

var cloudbuildProjectsTriggersRun* = Call_CloudbuildProjectsTriggersRun_580157(
    name: "cloudbuildProjectsTriggersRun", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com",
    route: "/v1/projects/{projectId}/triggers/{triggerId}:run",
    validator: validate_CloudbuildProjectsTriggersRun_580158, base: "/",
    url: url_CloudbuildProjectsTriggersRun_580159, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsGet_580179 = ref object of OpenApiRestCall_579408
proc url_CloudbuildOperationsGet_580181(protocol: Scheme; host: string; base: string;
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

proc validate_CloudbuildOperationsGet_580180(path: JsonNode; query: JsonNode;
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
  var valid_580182 = path.getOrDefault("name")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "name", valid_580182
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
  var valid_580183 = query.getOrDefault("upload_protocol")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "upload_protocol", valid_580183
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("callback")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "callback", valid_580188
  var valid_580189 = query.getOrDefault("access_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "access_token", valid_580189
  var valid_580190 = query.getOrDefault("uploadType")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "uploadType", valid_580190
  var valid_580191 = query.getOrDefault("key")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "key", valid_580191
  var valid_580192 = query.getOrDefault("$.xgafv")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("1"))
  if valid_580192 != nil:
    section.add "$.xgafv", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580194: Call_CloudbuildOperationsGet_580179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580194.validator(path, query, header, formData, body)
  let scheme = call_580194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580194.url(scheme.get, call_580194.host, call_580194.base,
                         call_580194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580194, url, valid)

proc call*(call_580195: Call_CloudbuildOperationsGet_580179; name: string;
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
  var path_580196 = newJObject()
  var query_580197 = newJObject()
  add(query_580197, "upload_protocol", newJString(uploadProtocol))
  add(query_580197, "fields", newJString(fields))
  add(query_580197, "quotaUser", newJString(quotaUser))
  add(path_580196, "name", newJString(name))
  add(query_580197, "alt", newJString(alt))
  add(query_580197, "oauth_token", newJString(oauthToken))
  add(query_580197, "callback", newJString(callback))
  add(query_580197, "access_token", newJString(accessToken))
  add(query_580197, "uploadType", newJString(uploadType))
  add(query_580197, "key", newJString(key))
  add(query_580197, "$.xgafv", newJString(Xgafv))
  add(query_580197, "prettyPrint", newJBool(prettyPrint))
  result = call_580195.call(path_580196, query_580197, nil, nil, nil)

var cloudbuildOperationsGet* = Call_CloudbuildOperationsGet_580179(
    name: "cloudbuildOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbuildOperationsGet_580180, base: "/",
    url: url_CloudbuildOperationsGet_580181, schemes: {Scheme.Https})
type
  Call_CloudbuildOperationsCancel_580198 = ref object of OpenApiRestCall_579408
proc url_CloudbuildOperationsCancel_580200(protocol: Scheme; host: string;
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

proc validate_CloudbuildOperationsCancel_580199(path: JsonNode; query: JsonNode;
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
  var valid_580201 = path.getOrDefault("name")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "name", valid_580201
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
  var valid_580202 = query.getOrDefault("upload_protocol")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "upload_protocol", valid_580202
  var valid_580203 = query.getOrDefault("fields")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "fields", valid_580203
  var valid_580204 = query.getOrDefault("quotaUser")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "quotaUser", valid_580204
  var valid_580205 = query.getOrDefault("alt")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("json"))
  if valid_580205 != nil:
    section.add "alt", valid_580205
  var valid_580206 = query.getOrDefault("oauth_token")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "oauth_token", valid_580206
  var valid_580207 = query.getOrDefault("callback")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "callback", valid_580207
  var valid_580208 = query.getOrDefault("access_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "access_token", valid_580208
  var valid_580209 = query.getOrDefault("uploadType")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "uploadType", valid_580209
  var valid_580210 = query.getOrDefault("key")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "key", valid_580210
  var valid_580211 = query.getOrDefault("$.xgafv")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("1"))
  if valid_580211 != nil:
    section.add "$.xgafv", valid_580211
  var valid_580212 = query.getOrDefault("prettyPrint")
  valid_580212 = validateParameter(valid_580212, JBool, required = false,
                                 default = newJBool(true))
  if valid_580212 != nil:
    section.add "prettyPrint", valid_580212
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

proc call*(call_580214: Call_CloudbuildOperationsCancel_580198; path: JsonNode;
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
  let valid = call_580214.validator(path, query, header, formData, body)
  let scheme = call_580214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580214.url(scheme.get, call_580214.host, call_580214.base,
                         call_580214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580214, url, valid)

proc call*(call_580215: Call_CloudbuildOperationsCancel_580198; name: string;
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
  var path_580216 = newJObject()
  var query_580217 = newJObject()
  var body_580218 = newJObject()
  add(query_580217, "upload_protocol", newJString(uploadProtocol))
  add(query_580217, "fields", newJString(fields))
  add(query_580217, "quotaUser", newJString(quotaUser))
  add(path_580216, "name", newJString(name))
  add(query_580217, "alt", newJString(alt))
  add(query_580217, "oauth_token", newJString(oauthToken))
  add(query_580217, "callback", newJString(callback))
  add(query_580217, "access_token", newJString(accessToken))
  add(query_580217, "uploadType", newJString(uploadType))
  add(query_580217, "key", newJString(key))
  add(query_580217, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580218 = body
  add(query_580217, "prettyPrint", newJBool(prettyPrint))
  result = call_580215.call(path_580216, query_580217, nil, nil, body_580218)

var cloudbuildOperationsCancel* = Call_CloudbuildOperationsCancel_580198(
    name: "cloudbuildOperationsCancel", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_CloudbuildOperationsCancel_580199, base: "/",
    url: url_CloudbuildOperationsCancel_580200, schemes: {Scheme.Https})
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
