
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Dataproc
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages Hadoop-based clusters and jobs on Google Cloud Platform.
## 
## https://cloud.google.com/dataproc/
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
  gcpServiceName = "dataproc"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataprocProjectsRegionsClustersCreate_589004 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsClustersCreate_589006(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersCreate_589005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request to create a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589007 = path.getOrDefault("projectId")
  valid_589007 = validateParameter(valid_589007, JString, required = true,
                                 default = nil)
  if valid_589007 != nil:
    section.add "projectId", valid_589007
  var valid_589008 = path.getOrDefault("region")
  valid_589008 = validateParameter(valid_589008, JString, required = true,
                                 default = nil)
  if valid_589008 != nil:
    section.add "region", valid_589008
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589009 = query.getOrDefault("upload_protocol")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "upload_protocol", valid_589009
  var valid_589010 = query.getOrDefault("fields")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "fields", valid_589010
  var valid_589011 = query.getOrDefault("quotaUser")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "quotaUser", valid_589011
  var valid_589012 = query.getOrDefault("alt")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("json"))
  if valid_589012 != nil:
    section.add "alt", valid_589012
  var valid_589013 = query.getOrDefault("pp")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "pp", valid_589013
  var valid_589014 = query.getOrDefault("oauth_token")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "oauth_token", valid_589014
  var valid_589015 = query.getOrDefault("uploadType")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "uploadType", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("key")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "key", valid_589018
  var valid_589019 = query.getOrDefault("$.xgafv")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = newJString("1"))
  if valid_589019 != nil:
    section.add "$.xgafv", valid_589019
  var valid_589020 = query.getOrDefault("prettyPrint")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "prettyPrint", valid_589020
  var valid_589021 = query.getOrDefault("bearer_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "bearer_token", valid_589021
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

proc call*(call_589023: Call_DataprocProjectsRegionsClustersCreate_589004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to create a cluster in a project.
  ## 
  let valid = call_589023.validator(path, query, header, formData, body)
  let scheme = call_589023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589023.url(scheme.get, call_589023.host, call_589023.base,
                         call_589023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589023, url, valid)

proc call*(call_589024: Call_DataprocProjectsRegionsClustersCreate_589004;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersCreate
  ## Request to create a cluster in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589025 = newJObject()
  var query_589026 = newJObject()
  var body_589027 = newJObject()
  add(query_589026, "upload_protocol", newJString(uploadProtocol))
  add(query_589026, "fields", newJString(fields))
  add(query_589026, "quotaUser", newJString(quotaUser))
  add(query_589026, "alt", newJString(alt))
  add(query_589026, "pp", newJBool(pp))
  add(query_589026, "oauth_token", newJString(oauthToken))
  add(query_589026, "uploadType", newJString(uploadType))
  add(query_589026, "callback", newJString(callback))
  add(query_589026, "access_token", newJString(accessToken))
  add(query_589026, "key", newJString(key))
  add(path_589025, "projectId", newJString(projectId))
  add(query_589026, "$.xgafv", newJString(Xgafv))
  add(path_589025, "region", newJString(region))
  if body != nil:
    body_589027 = body
  add(query_589026, "prettyPrint", newJBool(prettyPrint))
  add(query_589026, "bearer_token", newJString(bearerToken))
  result = call_589024.call(path_589025, query_589026, nil, nil, body_589027)

var dataprocProjectsRegionsClustersCreate* = Call_DataprocProjectsRegionsClustersCreate_589004(
    name: "dataprocProjectsRegionsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersCreate_589005, base: "/",
    url: url_DataprocProjectsRegionsClustersCreate_589006, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersList_588710 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsClustersList_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersList_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request a list of all regions/{region}/clusters in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_588838 = path.getOrDefault("projectId")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "projectId", valid_588838
  var valid_588839 = path.getOrDefault("region")
  valid_588839 = validateParameter(valid_588839, JString, required = true,
                                 default = nil)
  if valid_588839 != nil:
    section.add "region", valid_588839
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard List page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard List page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional A filter constraining which clusters to list. Valid filters contain label terms such as: labels.key1 = val1 AND (-labels.k2 = val2 OR labels.k3 = val3)
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_588840 = query.getOrDefault("upload_protocol")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "upload_protocol", valid_588840
  var valid_588841 = query.getOrDefault("fields")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "fields", valid_588841
  var valid_588842 = query.getOrDefault("pageToken")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "pageToken", valid_588842
  var valid_588843 = query.getOrDefault("quotaUser")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "quotaUser", valid_588843
  var valid_588857 = query.getOrDefault("alt")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("json"))
  if valid_588857 != nil:
    section.add "alt", valid_588857
  var valid_588858 = query.getOrDefault("pp")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "pp", valid_588858
  var valid_588859 = query.getOrDefault("oauth_token")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "oauth_token", valid_588859
  var valid_588860 = query.getOrDefault("uploadType")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "uploadType", valid_588860
  var valid_588861 = query.getOrDefault("callback")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "callback", valid_588861
  var valid_588862 = query.getOrDefault("access_token")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = nil)
  if valid_588862 != nil:
    section.add "access_token", valid_588862
  var valid_588863 = query.getOrDefault("key")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "key", valid_588863
  var valid_588864 = query.getOrDefault("$.xgafv")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("1"))
  if valid_588864 != nil:
    section.add "$.xgafv", valid_588864
  var valid_588865 = query.getOrDefault("pageSize")
  valid_588865 = validateParameter(valid_588865, JInt, required = false, default = nil)
  if valid_588865 != nil:
    section.add "pageSize", valid_588865
  var valid_588866 = query.getOrDefault("prettyPrint")
  valid_588866 = validateParameter(valid_588866, JBool, required = false,
                                 default = newJBool(true))
  if valid_588866 != nil:
    section.add "prettyPrint", valid_588866
  var valid_588867 = query.getOrDefault("filter")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "filter", valid_588867
  var valid_588868 = query.getOrDefault("bearer_token")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "bearer_token", valid_588868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588891: Call_DataprocProjectsRegionsClustersList_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request a list of all regions/{region}/clusters in a project.
  ## 
  let valid = call_588891.validator(path, query, header, formData, body)
  let scheme = call_588891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588891.url(scheme.get, call_588891.host, call_588891.base,
                         call_588891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588891, url, valid)

proc call*(call_588962: Call_DataprocProjectsRegionsClustersList_588710;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersList
  ## Request a list of all regions/{region}/clusters in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard List page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   pageSize: int
  ##           : The standard List page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional A filter constraining which clusters to list. Valid filters contain label terms such as: labels.key1 = val1 AND (-labels.k2 = val2 OR labels.k3 = val3)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_588963 = newJObject()
  var query_588965 = newJObject()
  add(query_588965, "upload_protocol", newJString(uploadProtocol))
  add(query_588965, "fields", newJString(fields))
  add(query_588965, "pageToken", newJString(pageToken))
  add(query_588965, "quotaUser", newJString(quotaUser))
  add(query_588965, "alt", newJString(alt))
  add(query_588965, "pp", newJBool(pp))
  add(query_588965, "oauth_token", newJString(oauthToken))
  add(query_588965, "uploadType", newJString(uploadType))
  add(query_588965, "callback", newJString(callback))
  add(query_588965, "access_token", newJString(accessToken))
  add(query_588965, "key", newJString(key))
  add(path_588963, "projectId", newJString(projectId))
  add(query_588965, "$.xgafv", newJString(Xgafv))
  add(path_588963, "region", newJString(region))
  add(query_588965, "pageSize", newJInt(pageSize))
  add(query_588965, "prettyPrint", newJBool(prettyPrint))
  add(query_588965, "filter", newJString(filter))
  add(query_588965, "bearer_token", newJString(bearerToken))
  result = call_588962.call(path_588963, query_588965, nil, nil, nil)

var dataprocProjectsRegionsClustersList* = Call_DataprocProjectsRegionsClustersList_588710(
    name: "dataprocProjectsRegionsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersList_588711, base: "/",
    url: url_DataprocProjectsRegionsClustersList_588712, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersGet_589028 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsClustersGet_589030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersGet_589029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request to get the resource representation for a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required The cluster name.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_589031 = path.getOrDefault("clusterName")
  valid_589031 = validateParameter(valid_589031, JString, required = true,
                                 default = nil)
  if valid_589031 != nil:
    section.add "clusterName", valid_589031
  var valid_589032 = path.getOrDefault("projectId")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "projectId", valid_589032
  var valid_589033 = path.getOrDefault("region")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "region", valid_589033
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589034 = query.getOrDefault("upload_protocol")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "upload_protocol", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("pp")
  valid_589038 = validateParameter(valid_589038, JBool, required = false,
                                 default = newJBool(true))
  if valid_589038 != nil:
    section.add "pp", valid_589038
  var valid_589039 = query.getOrDefault("oauth_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "oauth_token", valid_589039
  var valid_589040 = query.getOrDefault("uploadType")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "uploadType", valid_589040
  var valid_589041 = query.getOrDefault("callback")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "callback", valid_589041
  var valid_589042 = query.getOrDefault("access_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "access_token", valid_589042
  var valid_589043 = query.getOrDefault("key")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "key", valid_589043
  var valid_589044 = query.getOrDefault("$.xgafv")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("1"))
  if valid_589044 != nil:
    section.add "$.xgafv", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
  var valid_589046 = query.getOrDefault("bearer_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "bearer_token", valid_589046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589047: Call_DataprocProjectsRegionsClustersGet_589028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to get the resource representation for a cluster in a project.
  ## 
  let valid = call_589047.validator(path, query, header, formData, body)
  let scheme = call_589047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589047.url(scheme.get, call_589047.host, call_589047.base,
                         call_589047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589047, url, valid)

proc call*(call_589048: Call_DataprocProjectsRegionsClustersGet_589028;
          clusterName: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersGet
  ## Request to get the resource representation for a cluster in a project.
  ##   clusterName: string (required)
  ##              : Required The cluster name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589049 = newJObject()
  var query_589050 = newJObject()
  add(path_589049, "clusterName", newJString(clusterName))
  add(query_589050, "upload_protocol", newJString(uploadProtocol))
  add(query_589050, "fields", newJString(fields))
  add(query_589050, "quotaUser", newJString(quotaUser))
  add(query_589050, "alt", newJString(alt))
  add(query_589050, "pp", newJBool(pp))
  add(query_589050, "oauth_token", newJString(oauthToken))
  add(query_589050, "uploadType", newJString(uploadType))
  add(query_589050, "callback", newJString(callback))
  add(query_589050, "access_token", newJString(accessToken))
  add(query_589050, "key", newJString(key))
  add(path_589049, "projectId", newJString(projectId))
  add(query_589050, "$.xgafv", newJString(Xgafv))
  add(path_589049, "region", newJString(region))
  add(query_589050, "prettyPrint", newJBool(prettyPrint))
  add(query_589050, "bearer_token", newJString(bearerToken))
  result = call_589048.call(path_589049, query_589050, nil, nil, nil)

var dataprocProjectsRegionsClustersGet* = Call_DataprocProjectsRegionsClustersGet_589028(
    name: "dataprocProjectsRegionsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersGet_589029, base: "/",
    url: url_DataprocProjectsRegionsClustersGet_589030, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersPatch_589074 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsClustersPatch_589076(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersPatch_589075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request to update a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required The cluster name.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project the cluster belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_589077 = path.getOrDefault("clusterName")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "clusterName", valid_589077
  var valid_589078 = path.getOrDefault("projectId")
  valid_589078 = validateParameter(valid_589078, JString, required = true,
                                 default = nil)
  if valid_589078 != nil:
    section.add "projectId", valid_589078
  var valid_589079 = path.getOrDefault("region")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "region", valid_589079
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Required Specifies the path, relative to <code>Cluster</code>, of the field to update. For example, to change the number of workers in a cluster to 5, the <code>update_mask</code> parameter would be specified as <code>"configuration.worker_configuration.num_instances,"</code> and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "configuration":{
  ##     "workerConfiguration":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> Currently, <code>configuration.worker_configuration.num_instances</code> is the only field that can be updated.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589080 = query.getOrDefault("upload_protocol")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "upload_protocol", valid_589080
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("quotaUser")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "quotaUser", valid_589082
  var valid_589083 = query.getOrDefault("alt")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("json"))
  if valid_589083 != nil:
    section.add "alt", valid_589083
  var valid_589084 = query.getOrDefault("pp")
  valid_589084 = validateParameter(valid_589084, JBool, required = false,
                                 default = newJBool(true))
  if valid_589084 != nil:
    section.add "pp", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("uploadType")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "uploadType", valid_589086
  var valid_589087 = query.getOrDefault("callback")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "callback", valid_589087
  var valid_589088 = query.getOrDefault("access_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "access_token", valid_589088
  var valid_589089 = query.getOrDefault("key")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "key", valid_589089
  var valid_589090 = query.getOrDefault("$.xgafv")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("1"))
  if valid_589090 != nil:
    section.add "$.xgafv", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
  var valid_589092 = query.getOrDefault("updateMask")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "updateMask", valid_589092
  var valid_589093 = query.getOrDefault("bearer_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "bearer_token", valid_589093
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

proc call*(call_589095: Call_DataprocProjectsRegionsClustersPatch_589074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to update a cluster in a project.
  ## 
  let valid = call_589095.validator(path, query, header, formData, body)
  let scheme = call_589095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589095.url(scheme.get, call_589095.host, call_589095.base,
                         call_589095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589095, url, valid)

proc call*(call_589096: Call_DataprocProjectsRegionsClustersPatch_589074;
          clusterName: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""; bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersPatch
  ## Request to update a cluster in a project.
  ##   clusterName: string (required)
  ##              : Required The cluster name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required Specifies the path, relative to <code>Cluster</code>, of the field to update. For example, to change the number of workers in a cluster to 5, the <code>update_mask</code> parameter would be specified as <code>"configuration.worker_configuration.num_instances,"</code> and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "configuration":{
  ##     "workerConfiguration":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> Currently, <code>configuration.worker_configuration.num_instances</code> is the only field that can be updated.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589097 = newJObject()
  var query_589098 = newJObject()
  var body_589099 = newJObject()
  add(path_589097, "clusterName", newJString(clusterName))
  add(query_589098, "upload_protocol", newJString(uploadProtocol))
  add(query_589098, "fields", newJString(fields))
  add(query_589098, "quotaUser", newJString(quotaUser))
  add(query_589098, "alt", newJString(alt))
  add(query_589098, "pp", newJBool(pp))
  add(query_589098, "oauth_token", newJString(oauthToken))
  add(query_589098, "uploadType", newJString(uploadType))
  add(query_589098, "callback", newJString(callback))
  add(query_589098, "access_token", newJString(accessToken))
  add(query_589098, "key", newJString(key))
  add(path_589097, "projectId", newJString(projectId))
  add(query_589098, "$.xgafv", newJString(Xgafv))
  add(path_589097, "region", newJString(region))
  if body != nil:
    body_589099 = body
  add(query_589098, "prettyPrint", newJBool(prettyPrint))
  add(query_589098, "updateMask", newJString(updateMask))
  add(query_589098, "bearer_token", newJString(bearerToken))
  result = call_589096.call(path_589097, query_589098, nil, nil, body_589099)

var dataprocProjectsRegionsClustersPatch* = Call_DataprocProjectsRegionsClustersPatch_589074(
    name: "dataprocProjectsRegionsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersPatch_589075, base: "/",
    url: url_DataprocProjectsRegionsClustersPatch_589076, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDelete_589051 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsClustersDelete_589053(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersDelete_589052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request to delete a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required The cluster name.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_589054 = path.getOrDefault("clusterName")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "clusterName", valid_589054
  var valid_589055 = path.getOrDefault("projectId")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "projectId", valid_589055
  var valid_589056 = path.getOrDefault("region")
  valid_589056 = validateParameter(valid_589056, JString, required = true,
                                 default = nil)
  if valid_589056 != nil:
    section.add "region", valid_589056
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589057 = query.getOrDefault("upload_protocol")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "upload_protocol", valid_589057
  var valid_589058 = query.getOrDefault("fields")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "fields", valid_589058
  var valid_589059 = query.getOrDefault("quotaUser")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "quotaUser", valid_589059
  var valid_589060 = query.getOrDefault("alt")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("json"))
  if valid_589060 != nil:
    section.add "alt", valid_589060
  var valid_589061 = query.getOrDefault("pp")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "pp", valid_589061
  var valid_589062 = query.getOrDefault("oauth_token")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "oauth_token", valid_589062
  var valid_589063 = query.getOrDefault("uploadType")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "uploadType", valid_589063
  var valid_589064 = query.getOrDefault("callback")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "callback", valid_589064
  var valid_589065 = query.getOrDefault("access_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "access_token", valid_589065
  var valid_589066 = query.getOrDefault("key")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "key", valid_589066
  var valid_589067 = query.getOrDefault("$.xgafv")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("1"))
  if valid_589067 != nil:
    section.add "$.xgafv", valid_589067
  var valid_589068 = query.getOrDefault("prettyPrint")
  valid_589068 = validateParameter(valid_589068, JBool, required = false,
                                 default = newJBool(true))
  if valid_589068 != nil:
    section.add "prettyPrint", valid_589068
  var valid_589069 = query.getOrDefault("bearer_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "bearer_token", valid_589069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589070: Call_DataprocProjectsRegionsClustersDelete_589051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to delete a cluster in a project.
  ## 
  let valid = call_589070.validator(path, query, header, formData, body)
  let scheme = call_589070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589070.url(scheme.get, call_589070.host, call_589070.base,
                         call_589070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589070, url, valid)

proc call*(call_589071: Call_DataprocProjectsRegionsClustersDelete_589051;
          clusterName: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersDelete
  ## Request to delete a cluster in a project.
  ##   clusterName: string (required)
  ##              : Required The cluster name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589072 = newJObject()
  var query_589073 = newJObject()
  add(path_589072, "clusterName", newJString(clusterName))
  add(query_589073, "upload_protocol", newJString(uploadProtocol))
  add(query_589073, "fields", newJString(fields))
  add(query_589073, "quotaUser", newJString(quotaUser))
  add(query_589073, "alt", newJString(alt))
  add(query_589073, "pp", newJBool(pp))
  add(query_589073, "oauth_token", newJString(oauthToken))
  add(query_589073, "uploadType", newJString(uploadType))
  add(query_589073, "callback", newJString(callback))
  add(query_589073, "access_token", newJString(accessToken))
  add(query_589073, "key", newJString(key))
  add(path_589072, "projectId", newJString(projectId))
  add(query_589073, "$.xgafv", newJString(Xgafv))
  add(path_589072, "region", newJString(region))
  add(query_589073, "prettyPrint", newJBool(prettyPrint))
  add(query_589073, "bearer_token", newJString(bearerToken))
  result = call_589071.call(path_589072, query_589073, nil, nil, nil)

var dataprocProjectsRegionsClustersDelete* = Call_DataprocProjectsRegionsClustersDelete_589051(
    name: "dataprocProjectsRegionsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersDelete_589052, base: "/",
    url: url_DataprocProjectsRegionsClustersDelete_589053, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsGet_589100 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsJobsGet_589102(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsGet_589101(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589103 = path.getOrDefault("jobId")
  valid_589103 = validateParameter(valid_589103, JString, required = true,
                                 default = nil)
  if valid_589103 != nil:
    section.add "jobId", valid_589103
  var valid_589104 = path.getOrDefault("projectId")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "projectId", valid_589104
  var valid_589105 = path.getOrDefault("region")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "region", valid_589105
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589106 = query.getOrDefault("upload_protocol")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "upload_protocol", valid_589106
  var valid_589107 = query.getOrDefault("fields")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "fields", valid_589107
  var valid_589108 = query.getOrDefault("quotaUser")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "quotaUser", valid_589108
  var valid_589109 = query.getOrDefault("alt")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("json"))
  if valid_589109 != nil:
    section.add "alt", valid_589109
  var valid_589110 = query.getOrDefault("pp")
  valid_589110 = validateParameter(valid_589110, JBool, required = false,
                                 default = newJBool(true))
  if valid_589110 != nil:
    section.add "pp", valid_589110
  var valid_589111 = query.getOrDefault("oauth_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "oauth_token", valid_589111
  var valid_589112 = query.getOrDefault("uploadType")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "uploadType", valid_589112
  var valid_589113 = query.getOrDefault("callback")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "callback", valid_589113
  var valid_589114 = query.getOrDefault("access_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "access_token", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("$.xgafv")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("1"))
  if valid_589116 != nil:
    section.add "$.xgafv", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  var valid_589118 = query.getOrDefault("bearer_token")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "bearer_token", valid_589118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589119: Call_DataprocProjectsRegionsJobsGet_589100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_DataprocProjectsRegionsJobsGet_589100; jobId: string;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsGet
  ## Gets the resource representation for a job in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  add(query_589122, "upload_protocol", newJString(uploadProtocol))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "pp", newJBool(pp))
  add(path_589121, "jobId", newJString(jobId))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "uploadType", newJString(uploadType))
  add(query_589122, "callback", newJString(callback))
  add(query_589122, "access_token", newJString(accessToken))
  add(query_589122, "key", newJString(key))
  add(path_589121, "projectId", newJString(projectId))
  add(query_589122, "$.xgafv", newJString(Xgafv))
  add(path_589121, "region", newJString(region))
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  add(query_589122, "bearer_token", newJString(bearerToken))
  result = call_589120.call(path_589121, query_589122, nil, nil, nil)

var dataprocProjectsRegionsJobsGet* = Call_DataprocProjectsRegionsJobsGet_589100(
    name: "dataprocProjectsRegionsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsGet_589101, base: "/",
    url: url_DataprocProjectsRegionsJobsGet_589102, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsPatch_589146 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsJobsPatch_589148(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsPatch_589147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589149 = path.getOrDefault("jobId")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "jobId", valid_589149
  var valid_589150 = path.getOrDefault("projectId")
  valid_589150 = validateParameter(valid_589150, JString, required = true,
                                 default = nil)
  if valid_589150 != nil:
    section.add "projectId", valid_589150
  var valid_589151 = path.getOrDefault("region")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "region", valid_589151
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Required Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589152 = query.getOrDefault("upload_protocol")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "upload_protocol", valid_589152
  var valid_589153 = query.getOrDefault("fields")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "fields", valid_589153
  var valid_589154 = query.getOrDefault("quotaUser")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "quotaUser", valid_589154
  var valid_589155 = query.getOrDefault("alt")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("json"))
  if valid_589155 != nil:
    section.add "alt", valid_589155
  var valid_589156 = query.getOrDefault("pp")
  valid_589156 = validateParameter(valid_589156, JBool, required = false,
                                 default = newJBool(true))
  if valid_589156 != nil:
    section.add "pp", valid_589156
  var valid_589157 = query.getOrDefault("oauth_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "oauth_token", valid_589157
  var valid_589158 = query.getOrDefault("uploadType")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "uploadType", valid_589158
  var valid_589159 = query.getOrDefault("callback")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "callback", valid_589159
  var valid_589160 = query.getOrDefault("access_token")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "access_token", valid_589160
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
  var valid_589164 = query.getOrDefault("updateMask")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "updateMask", valid_589164
  var valid_589165 = query.getOrDefault("bearer_token")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "bearer_token", valid_589165
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

proc call*(call_589167: Call_DataprocProjectsRegionsJobsPatch_589146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_589167.validator(path, query, header, formData, body)
  let scheme = call_589167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589167.url(scheme.get, call_589167.host, call_589167.base,
                         call_589167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589167, url, valid)

proc call*(call_589168: Call_DataprocProjectsRegionsJobsPatch_589146;
          jobId: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""; bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsPatch
  ## Updates a job in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589169 = newJObject()
  var query_589170 = newJObject()
  var body_589171 = newJObject()
  add(query_589170, "upload_protocol", newJString(uploadProtocol))
  add(query_589170, "fields", newJString(fields))
  add(query_589170, "quotaUser", newJString(quotaUser))
  add(query_589170, "alt", newJString(alt))
  add(query_589170, "pp", newJBool(pp))
  add(path_589169, "jobId", newJString(jobId))
  add(query_589170, "oauth_token", newJString(oauthToken))
  add(query_589170, "uploadType", newJString(uploadType))
  add(query_589170, "callback", newJString(callback))
  add(query_589170, "access_token", newJString(accessToken))
  add(query_589170, "key", newJString(key))
  add(path_589169, "projectId", newJString(projectId))
  add(query_589170, "$.xgafv", newJString(Xgafv))
  add(path_589169, "region", newJString(region))
  if body != nil:
    body_589171 = body
  add(query_589170, "prettyPrint", newJBool(prettyPrint))
  add(query_589170, "updateMask", newJString(updateMask))
  add(query_589170, "bearer_token", newJString(bearerToken))
  result = call_589168.call(path_589169, query_589170, nil, nil, body_589171)

var dataprocProjectsRegionsJobsPatch* = Call_DataprocProjectsRegionsJobsPatch_589146(
    name: "dataprocProjectsRegionsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsPatch_589147, base: "/",
    url: url_DataprocProjectsRegionsJobsPatch_589148, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsDelete_589123 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsJobsDelete_589125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsDelete_589124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589126 = path.getOrDefault("jobId")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "jobId", valid_589126
  var valid_589127 = path.getOrDefault("projectId")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "projectId", valid_589127
  var valid_589128 = path.getOrDefault("region")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "region", valid_589128
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589129 = query.getOrDefault("upload_protocol")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "upload_protocol", valid_589129
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("pp")
  valid_589133 = validateParameter(valid_589133, JBool, required = false,
                                 default = newJBool(true))
  if valid_589133 != nil:
    section.add "pp", valid_589133
  var valid_589134 = query.getOrDefault("oauth_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "oauth_token", valid_589134
  var valid_589135 = query.getOrDefault("uploadType")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "uploadType", valid_589135
  var valid_589136 = query.getOrDefault("callback")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "callback", valid_589136
  var valid_589137 = query.getOrDefault("access_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "access_token", valid_589137
  var valid_589138 = query.getOrDefault("key")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "key", valid_589138
  var valid_589139 = query.getOrDefault("$.xgafv")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("1"))
  if valid_589139 != nil:
    section.add "$.xgafv", valid_589139
  var valid_589140 = query.getOrDefault("prettyPrint")
  valid_589140 = validateParameter(valid_589140, JBool, required = false,
                                 default = newJBool(true))
  if valid_589140 != nil:
    section.add "prettyPrint", valid_589140
  var valid_589141 = query.getOrDefault("bearer_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "bearer_token", valid_589141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589142: Call_DataprocProjectsRegionsJobsDelete_589123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_589142.validator(path, query, header, formData, body)
  let scheme = call_589142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589142.url(scheme.get, call_589142.host, call_589142.base,
                         call_589142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589142, url, valid)

proc call*(call_589143: Call_DataprocProjectsRegionsJobsDelete_589123;
          jobId: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsDelete
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589144 = newJObject()
  var query_589145 = newJObject()
  add(query_589145, "upload_protocol", newJString(uploadProtocol))
  add(query_589145, "fields", newJString(fields))
  add(query_589145, "quotaUser", newJString(quotaUser))
  add(query_589145, "alt", newJString(alt))
  add(query_589145, "pp", newJBool(pp))
  add(path_589144, "jobId", newJString(jobId))
  add(query_589145, "oauth_token", newJString(oauthToken))
  add(query_589145, "uploadType", newJString(uploadType))
  add(query_589145, "callback", newJString(callback))
  add(query_589145, "access_token", newJString(accessToken))
  add(query_589145, "key", newJString(key))
  add(path_589144, "projectId", newJString(projectId))
  add(query_589145, "$.xgafv", newJString(Xgafv))
  add(path_589144, "region", newJString(region))
  add(query_589145, "prettyPrint", newJBool(prettyPrint))
  add(query_589145, "bearer_token", newJString(bearerToken))
  result = call_589143.call(path_589144, query_589145, nil, nil, nil)

var dataprocProjectsRegionsJobsDelete* = Call_DataprocProjectsRegionsJobsDelete_589123(
    name: "dataprocProjectsRegionsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsDelete_589124, base: "/",
    url: url_DataprocProjectsRegionsJobsDelete_589125, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsCancel_589172 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsJobsCancel_589174(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsCancel_589173(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs:list or regions/{region}/jobs:get.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589175 = path.getOrDefault("jobId")
  valid_589175 = validateParameter(valid_589175, JString, required = true,
                                 default = nil)
  if valid_589175 != nil:
    section.add "jobId", valid_589175
  var valid_589176 = path.getOrDefault("projectId")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "projectId", valid_589176
  var valid_589177 = path.getOrDefault("region")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "region", valid_589177
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589178 = query.getOrDefault("upload_protocol")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "upload_protocol", valid_589178
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("alt")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("json"))
  if valid_589181 != nil:
    section.add "alt", valid_589181
  var valid_589182 = query.getOrDefault("pp")
  valid_589182 = validateParameter(valid_589182, JBool, required = false,
                                 default = newJBool(true))
  if valid_589182 != nil:
    section.add "pp", valid_589182
  var valid_589183 = query.getOrDefault("oauth_token")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "oauth_token", valid_589183
  var valid_589184 = query.getOrDefault("uploadType")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "uploadType", valid_589184
  var valid_589185 = query.getOrDefault("callback")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "callback", valid_589185
  var valid_589186 = query.getOrDefault("access_token")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "access_token", valid_589186
  var valid_589187 = query.getOrDefault("key")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "key", valid_589187
  var valid_589188 = query.getOrDefault("$.xgafv")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = newJString("1"))
  if valid_589188 != nil:
    section.add "$.xgafv", valid_589188
  var valid_589189 = query.getOrDefault("prettyPrint")
  valid_589189 = validateParameter(valid_589189, JBool, required = false,
                                 default = newJBool(true))
  if valid_589189 != nil:
    section.add "prettyPrint", valid_589189
  var valid_589190 = query.getOrDefault("bearer_token")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "bearer_token", valid_589190
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

proc call*(call_589192: Call_DataprocProjectsRegionsJobsCancel_589172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs:list or regions/{region}/jobs:get.
  ## 
  let valid = call_589192.validator(path, query, header, formData, body)
  let scheme = call_589192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589192.url(scheme.get, call_589192.host, call_589192.base,
                         call_589192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589192, url, valid)

proc call*(call_589193: Call_DataprocProjectsRegionsJobsCancel_589172;
          jobId: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsCancel
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs:list or regions/{region}/jobs:get.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589194 = newJObject()
  var query_589195 = newJObject()
  var body_589196 = newJObject()
  add(query_589195, "upload_protocol", newJString(uploadProtocol))
  add(query_589195, "fields", newJString(fields))
  add(query_589195, "quotaUser", newJString(quotaUser))
  add(query_589195, "alt", newJString(alt))
  add(query_589195, "pp", newJBool(pp))
  add(path_589194, "jobId", newJString(jobId))
  add(query_589195, "oauth_token", newJString(oauthToken))
  add(query_589195, "uploadType", newJString(uploadType))
  add(query_589195, "callback", newJString(callback))
  add(query_589195, "access_token", newJString(accessToken))
  add(query_589195, "key", newJString(key))
  add(path_589194, "projectId", newJString(projectId))
  add(query_589195, "$.xgafv", newJString(Xgafv))
  add(path_589194, "region", newJString(region))
  if body != nil:
    body_589196 = body
  add(query_589195, "prettyPrint", newJBool(prettyPrint))
  add(query_589195, "bearer_token", newJString(bearerToken))
  result = call_589193.call(path_589194, query_589195, nil, nil, body_589196)

var dataprocProjectsRegionsJobsCancel* = Call_DataprocProjectsRegionsJobsCancel_589172(
    name: "dataprocProjectsRegionsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsRegionsJobsCancel_589173, base: "/",
    url: url_DataprocProjectsRegionsJobsCancel_589174, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsList_589197 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsJobsList_589199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs:list")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsList_589198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists regions/{region}/jobs in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589200 = path.getOrDefault("projectId")
  valid_589200 = validateParameter(valid_589200, JString, required = true,
                                 default = nil)
  if valid_589200 != nil:
    section.add "projectId", valid_589200
  var valid_589201 = path.getOrDefault("region")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "region", valid_589201
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589202 = query.getOrDefault("upload_protocol")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "upload_protocol", valid_589202
  var valid_589203 = query.getOrDefault("fields")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "fields", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("pp")
  valid_589206 = validateParameter(valid_589206, JBool, required = false,
                                 default = newJBool(true))
  if valid_589206 != nil:
    section.add "pp", valid_589206
  var valid_589207 = query.getOrDefault("oauth_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "oauth_token", valid_589207
  var valid_589208 = query.getOrDefault("uploadType")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "uploadType", valid_589208
  var valid_589209 = query.getOrDefault("callback")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "callback", valid_589209
  var valid_589210 = query.getOrDefault("access_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "access_token", valid_589210
  var valid_589211 = query.getOrDefault("key")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "key", valid_589211
  var valid_589212 = query.getOrDefault("$.xgafv")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("1"))
  if valid_589212 != nil:
    section.add "$.xgafv", valid_589212
  var valid_589213 = query.getOrDefault("prettyPrint")
  valid_589213 = validateParameter(valid_589213, JBool, required = false,
                                 default = newJBool(true))
  if valid_589213 != nil:
    section.add "prettyPrint", valid_589213
  var valid_589214 = query.getOrDefault("bearer_token")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "bearer_token", valid_589214
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

proc call*(call_589216: Call_DataprocProjectsRegionsJobsList_589197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists regions/{region}/jobs in a project.
  ## 
  let valid = call_589216.validator(path, query, header, formData, body)
  let scheme = call_589216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589216.url(scheme.get, call_589216.host, call_589216.base,
                         call_589216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589216, url, valid)

proc call*(call_589217: Call_DataprocProjectsRegionsJobsList_589197;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsList
  ## Lists regions/{region}/jobs in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589218 = newJObject()
  var query_589219 = newJObject()
  var body_589220 = newJObject()
  add(query_589219, "upload_protocol", newJString(uploadProtocol))
  add(query_589219, "fields", newJString(fields))
  add(query_589219, "quotaUser", newJString(quotaUser))
  add(query_589219, "alt", newJString(alt))
  add(query_589219, "pp", newJBool(pp))
  add(query_589219, "oauth_token", newJString(oauthToken))
  add(query_589219, "uploadType", newJString(uploadType))
  add(query_589219, "callback", newJString(callback))
  add(query_589219, "access_token", newJString(accessToken))
  add(query_589219, "key", newJString(key))
  add(path_589218, "projectId", newJString(projectId))
  add(query_589219, "$.xgafv", newJString(Xgafv))
  add(path_589218, "region", newJString(region))
  if body != nil:
    body_589220 = body
  add(query_589219, "prettyPrint", newJBool(prettyPrint))
  add(query_589219, "bearer_token", newJString(bearerToken))
  result = call_589217.call(path_589218, query_589219, nil, nil, body_589220)

var dataprocProjectsRegionsJobsList* = Call_DataprocProjectsRegionsJobsList_589197(
    name: "dataprocProjectsRegionsJobsList", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs:list",
    validator: validate_DataprocProjectsRegionsJobsList_589198, base: "/",
    url: url_DataprocProjectsRegionsJobsList_589199, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsSubmit_589221 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsRegionsJobsSubmit_589223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs:submit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsSubmit_589222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a job to a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589224 = path.getOrDefault("projectId")
  valid_589224 = validateParameter(valid_589224, JString, required = true,
                                 default = nil)
  if valid_589224 != nil:
    section.add "projectId", valid_589224
  var valid_589225 = path.getOrDefault("region")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "region", valid_589225
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589226 = query.getOrDefault("upload_protocol")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "upload_protocol", valid_589226
  var valid_589227 = query.getOrDefault("fields")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "fields", valid_589227
  var valid_589228 = query.getOrDefault("quotaUser")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "quotaUser", valid_589228
  var valid_589229 = query.getOrDefault("alt")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("json"))
  if valid_589229 != nil:
    section.add "alt", valid_589229
  var valid_589230 = query.getOrDefault("pp")
  valid_589230 = validateParameter(valid_589230, JBool, required = false,
                                 default = newJBool(true))
  if valid_589230 != nil:
    section.add "pp", valid_589230
  var valid_589231 = query.getOrDefault("oauth_token")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "oauth_token", valid_589231
  var valid_589232 = query.getOrDefault("uploadType")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "uploadType", valid_589232
  var valid_589233 = query.getOrDefault("callback")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "callback", valid_589233
  var valid_589234 = query.getOrDefault("access_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "access_token", valid_589234
  var valid_589235 = query.getOrDefault("key")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "key", valid_589235
  var valid_589236 = query.getOrDefault("$.xgafv")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = newJString("1"))
  if valid_589236 != nil:
    section.add "$.xgafv", valid_589236
  var valid_589237 = query.getOrDefault("prettyPrint")
  valid_589237 = validateParameter(valid_589237, JBool, required = false,
                                 default = newJBool(true))
  if valid_589237 != nil:
    section.add "prettyPrint", valid_589237
  var valid_589238 = query.getOrDefault("bearer_token")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "bearer_token", valid_589238
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

proc call*(call_589240: Call_DataprocProjectsRegionsJobsSubmit_589221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_589240.validator(path, query, header, formData, body)
  let scheme = call_589240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589240.url(scheme.get, call_589240.host, call_589240.base,
                         call_589240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589240, url, valid)

proc call*(call_589241: Call_DataprocProjectsRegionsJobsSubmit_589221;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsSubmit
  ## Submits a job to a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589242 = newJObject()
  var query_589243 = newJObject()
  var body_589244 = newJObject()
  add(query_589243, "upload_protocol", newJString(uploadProtocol))
  add(query_589243, "fields", newJString(fields))
  add(query_589243, "quotaUser", newJString(quotaUser))
  add(query_589243, "alt", newJString(alt))
  add(query_589243, "pp", newJBool(pp))
  add(query_589243, "oauth_token", newJString(oauthToken))
  add(query_589243, "uploadType", newJString(uploadType))
  add(query_589243, "callback", newJString(callback))
  add(query_589243, "access_token", newJString(accessToken))
  add(query_589243, "key", newJString(key))
  add(path_589242, "projectId", newJString(projectId))
  add(query_589243, "$.xgafv", newJString(Xgafv))
  add(path_589242, "region", newJString(region))
  if body != nil:
    body_589244 = body
  add(query_589243, "prettyPrint", newJBool(prettyPrint))
  add(query_589243, "bearer_token", newJString(bearerToken))
  result = call_589241.call(path_589242, query_589243, nil, nil, body_589244)

var dataprocProjectsRegionsJobsSubmit* = Call_DataprocProjectsRegionsJobsSubmit_589221(
    name: "dataprocProjectsRegionsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs:submit",
    validator: validate_DataprocProjectsRegionsJobsSubmit_589222, base: "/",
    url: url_DataprocProjectsRegionsJobsSubmit_589223, schemes: {Scheme.Https})
type
  Call_DataprocOperationsList_589245 = ref object of OpenApiRestCall_588441
proc url_DataprocOperationsList_589247(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsList_589246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The operation collection name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589248 = path.getOrDefault("name")
  valid_589248 = validateParameter(valid_589248, JString, required = true,
                                 default = nil)
  if valid_589248 != nil:
    section.add "name", valid_589248
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard List page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard List page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Required A JSON object that contains filters for the list operation, in the format {"key1":"value1","key2":"value2", ..., }. Possible keys include project_id, cluster_name, and operation_state_matcher.If project_id is set, requests the list of operations that belong to the specified Google Cloud Platform project ID. This key is required.If cluster_name is set, requests the list of operations that were submitted to the specified cluster name. This key is optional.If operation_state_matcher is set, requests the list of operations that match one of the following status options: ALL, ACTIVE, or NON_ACTIVE.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589249 = query.getOrDefault("upload_protocol")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "upload_protocol", valid_589249
  var valid_589250 = query.getOrDefault("fields")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "fields", valid_589250
  var valid_589251 = query.getOrDefault("pageToken")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "pageToken", valid_589251
  var valid_589252 = query.getOrDefault("quotaUser")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "quotaUser", valid_589252
  var valid_589253 = query.getOrDefault("alt")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = newJString("json"))
  if valid_589253 != nil:
    section.add "alt", valid_589253
  var valid_589254 = query.getOrDefault("pp")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "pp", valid_589254
  var valid_589255 = query.getOrDefault("oauth_token")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "oauth_token", valid_589255
  var valid_589256 = query.getOrDefault("uploadType")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "uploadType", valid_589256
  var valid_589257 = query.getOrDefault("callback")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "callback", valid_589257
  var valid_589258 = query.getOrDefault("access_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "access_token", valid_589258
  var valid_589259 = query.getOrDefault("key")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "key", valid_589259
  var valid_589260 = query.getOrDefault("$.xgafv")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("1"))
  if valid_589260 != nil:
    section.add "$.xgafv", valid_589260
  var valid_589261 = query.getOrDefault("pageSize")
  valid_589261 = validateParameter(valid_589261, JInt, required = false, default = nil)
  if valid_589261 != nil:
    section.add "pageSize", valid_589261
  var valid_589262 = query.getOrDefault("prettyPrint")
  valid_589262 = validateParameter(valid_589262, JBool, required = false,
                                 default = newJBool(true))
  if valid_589262 != nil:
    section.add "prettyPrint", valid_589262
  var valid_589263 = query.getOrDefault("filter")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "filter", valid_589263
  var valid_589264 = query.getOrDefault("bearer_token")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "bearer_token", valid_589264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589265: Call_DataprocOperationsList_589245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  let valid = call_589265.validator(path, query, header, formData, body)
  let scheme = call_589265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589265.url(scheme.get, call_589265.host, call_589265.base,
                         call_589265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589265, url, valid)

proc call*(call_589266: Call_DataprocOperationsList_589245; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; filter: string = "";
          bearerToken: string = ""): Recallable =
  ## dataprocOperationsList
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard List page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The operation collection name.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard List page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Required A JSON object that contains filters for the list operation, in the format {"key1":"value1","key2":"value2", ..., }. Possible keys include project_id, cluster_name, and operation_state_matcher.If project_id is set, requests the list of operations that belong to the specified Google Cloud Platform project ID. This key is required.If cluster_name is set, requests the list of operations that were submitted to the specified cluster name. This key is optional.If operation_state_matcher is set, requests the list of operations that match one of the following status options: ALL, ACTIVE, or NON_ACTIVE.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589267 = newJObject()
  var query_589268 = newJObject()
  add(query_589268, "upload_protocol", newJString(uploadProtocol))
  add(query_589268, "fields", newJString(fields))
  add(query_589268, "pageToken", newJString(pageToken))
  add(query_589268, "quotaUser", newJString(quotaUser))
  add(path_589267, "name", newJString(name))
  add(query_589268, "alt", newJString(alt))
  add(query_589268, "pp", newJBool(pp))
  add(query_589268, "oauth_token", newJString(oauthToken))
  add(query_589268, "uploadType", newJString(uploadType))
  add(query_589268, "callback", newJString(callback))
  add(query_589268, "access_token", newJString(accessToken))
  add(query_589268, "key", newJString(key))
  add(query_589268, "$.xgafv", newJString(Xgafv))
  add(query_589268, "pageSize", newJInt(pageSize))
  add(query_589268, "prettyPrint", newJBool(prettyPrint))
  add(query_589268, "filter", newJString(filter))
  add(query_589268, "bearer_token", newJString(bearerToken))
  result = call_589266.call(path_589267, query_589268, nil, nil, nil)

var dataprocOperationsList* = Call_DataprocOperationsList_589245(
    name: "dataprocOperationsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_DataprocOperationsList_589246, base: "/",
    url: url_DataprocOperationsList_589247, schemes: {Scheme.Https})
type
  Call_DataprocOperationsDelete_589269 = ref object of OpenApiRestCall_588441
proc url_DataprocOperationsDelete_589271(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsDelete_589270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. It indicates the client is no longer interested in the operation result. It does not cancel the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589272 = path.getOrDefault("name")
  valid_589272 = validateParameter(valid_589272, JString, required = true,
                                 default = nil)
  if valid_589272 != nil:
    section.add "name", valid_589272
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589273 = query.getOrDefault("upload_protocol")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "upload_protocol", valid_589273
  var valid_589274 = query.getOrDefault("fields")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "fields", valid_589274
  var valid_589275 = query.getOrDefault("quotaUser")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "quotaUser", valid_589275
  var valid_589276 = query.getOrDefault("alt")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = newJString("json"))
  if valid_589276 != nil:
    section.add "alt", valid_589276
  var valid_589277 = query.getOrDefault("pp")
  valid_589277 = validateParameter(valid_589277, JBool, required = false,
                                 default = newJBool(true))
  if valid_589277 != nil:
    section.add "pp", valid_589277
  var valid_589278 = query.getOrDefault("oauth_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "oauth_token", valid_589278
  var valid_589279 = query.getOrDefault("uploadType")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "uploadType", valid_589279
  var valid_589280 = query.getOrDefault("callback")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "callback", valid_589280
  var valid_589281 = query.getOrDefault("access_token")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "access_token", valid_589281
  var valid_589282 = query.getOrDefault("key")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "key", valid_589282
  var valid_589283 = query.getOrDefault("$.xgafv")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = newJString("1"))
  if valid_589283 != nil:
    section.add "$.xgafv", valid_589283
  var valid_589284 = query.getOrDefault("prettyPrint")
  valid_589284 = validateParameter(valid_589284, JBool, required = false,
                                 default = newJBool(true))
  if valid_589284 != nil:
    section.add "prettyPrint", valid_589284
  var valid_589285 = query.getOrDefault("bearer_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "bearer_token", valid_589285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589286: Call_DataprocOperationsDelete_589269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. It indicates the client is no longer interested in the operation result. It does not cancel the operation.
  ## 
  let valid = call_589286.validator(path, query, header, formData, body)
  let scheme = call_589286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589286.url(scheme.get, call_589286.host, call_589286.base,
                         call_589286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589286, url, valid)

proc call*(call_589287: Call_DataprocOperationsDelete_589269; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocOperationsDelete
  ## Deletes a long-running operation. It indicates the client is no longer interested in the operation result. It does not cancel the operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589288 = newJObject()
  var query_589289 = newJObject()
  add(query_589289, "upload_protocol", newJString(uploadProtocol))
  add(query_589289, "fields", newJString(fields))
  add(query_589289, "quotaUser", newJString(quotaUser))
  add(path_589288, "name", newJString(name))
  add(query_589289, "alt", newJString(alt))
  add(query_589289, "pp", newJBool(pp))
  add(query_589289, "oauth_token", newJString(oauthToken))
  add(query_589289, "uploadType", newJString(uploadType))
  add(query_589289, "callback", newJString(callback))
  add(query_589289, "access_token", newJString(accessToken))
  add(query_589289, "key", newJString(key))
  add(query_589289, "$.xgafv", newJString(Xgafv))
  add(query_589289, "prettyPrint", newJBool(prettyPrint))
  add(query_589289, "bearer_token", newJString(bearerToken))
  result = call_589287.call(path_589288, query_589289, nil, nil, nil)

var dataprocOperationsDelete* = Call_DataprocOperationsDelete_589269(
    name: "dataprocOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_DataprocOperationsDelete_589270, base: "/",
    url: url_DataprocOperationsDelete_589271, schemes: {Scheme.Https})
type
  Call_DataprocOperationsCancel_589290 = ref object of OpenApiRestCall_588441
proc url_DataprocOperationsCancel_589292(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsCancel_589291(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients may use Operations.GetOperation or other methods to check whether the cancellation succeeded or the operation completed despite cancellation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589293 = path.getOrDefault("name")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "name", valid_589293
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589294 = query.getOrDefault("upload_protocol")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "upload_protocol", valid_589294
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("quotaUser")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "quotaUser", valid_589296
  var valid_589297 = query.getOrDefault("alt")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("json"))
  if valid_589297 != nil:
    section.add "alt", valid_589297
  var valid_589298 = query.getOrDefault("pp")
  valid_589298 = validateParameter(valid_589298, JBool, required = false,
                                 default = newJBool(true))
  if valid_589298 != nil:
    section.add "pp", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("uploadType")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "uploadType", valid_589300
  var valid_589301 = query.getOrDefault("callback")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "callback", valid_589301
  var valid_589302 = query.getOrDefault("access_token")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "access_token", valid_589302
  var valid_589303 = query.getOrDefault("key")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "key", valid_589303
  var valid_589304 = query.getOrDefault("$.xgafv")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("1"))
  if valid_589304 != nil:
    section.add "$.xgafv", valid_589304
  var valid_589305 = query.getOrDefault("prettyPrint")
  valid_589305 = validateParameter(valid_589305, JBool, required = false,
                                 default = newJBool(true))
  if valid_589305 != nil:
    section.add "prettyPrint", valid_589305
  var valid_589306 = query.getOrDefault("bearer_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "bearer_token", valid_589306
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

proc call*(call_589308: Call_DataprocOperationsCancel_589290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients may use Operations.GetOperation or other methods to check whether the cancellation succeeded or the operation completed despite cancellation.
  ## 
  let valid = call_589308.validator(path, query, header, formData, body)
  let scheme = call_589308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589308.url(scheme.get, call_589308.host, call_589308.base,
                         call_589308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589308, url, valid)

proc call*(call_589309: Call_DataprocOperationsCancel_589290; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients may use Operations.GetOperation or other methods to check whether the cancellation succeeded or the operation completed despite cancellation.
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
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589310 = newJObject()
  var query_589311 = newJObject()
  var body_589312 = newJObject()
  add(query_589311, "upload_protocol", newJString(uploadProtocol))
  add(query_589311, "fields", newJString(fields))
  add(query_589311, "quotaUser", newJString(quotaUser))
  add(path_589310, "name", newJString(name))
  add(query_589311, "alt", newJString(alt))
  add(query_589311, "pp", newJBool(pp))
  add(query_589311, "oauth_token", newJString(oauthToken))
  add(query_589311, "uploadType", newJString(uploadType))
  add(query_589311, "callback", newJString(callback))
  add(query_589311, "access_token", newJString(accessToken))
  add(query_589311, "key", newJString(key))
  add(query_589311, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589312 = body
  add(query_589311, "prettyPrint", newJBool(prettyPrint))
  add(query_589311, "bearer_token", newJString(bearerToken))
  result = call_589309.call(path_589310, query_589311, nil, nil, body_589312)

var dataprocOperationsCancel* = Call_DataprocOperationsCancel_589290(
    name: "dataprocOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}:cancel",
    validator: validate_DataprocOperationsCancel_589291, base: "/",
    url: url_DataprocOperationsCancel_589292, schemes: {Scheme.Https})
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
