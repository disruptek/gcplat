
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Dataproc
## version: v1beta2
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  Call_DataprocProjectsRegionsClustersCreate_589011 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsClustersCreate_589013(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersCreate_589012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589014 = path.getOrDefault("projectId")
  valid_589014 = validateParameter(valid_589014, JString, required = true,
                                 default = nil)
  if valid_589014 != nil:
    section.add "projectId", valid_589014
  var valid_589015 = path.getOrDefault("region")
  valid_589015 = validateParameter(valid_589015, JString, required = true,
                                 default = nil)
  if valid_589015 != nil:
    section.add "region", valid_589015
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : Optional. A unique id used to identify the request. If the server receives two CreateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
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
  var valid_589016 = query.getOrDefault("upload_protocol")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "upload_protocol", valid_589016
  var valid_589017 = query.getOrDefault("fields")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "fields", valid_589017
  var valid_589018 = query.getOrDefault("requestId")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "requestId", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("callback")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "callback", valid_589022
  var valid_589023 = query.getOrDefault("access_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "access_token", valid_589023
  var valid_589024 = query.getOrDefault("uploadType")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "uploadType", valid_589024
  var valid_589025 = query.getOrDefault("key")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "key", valid_589025
  var valid_589026 = query.getOrDefault("$.xgafv")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("1"))
  if valid_589026 != nil:
    section.add "$.xgafv", valid_589026
  var valid_589027 = query.getOrDefault("prettyPrint")
  valid_589027 = validateParameter(valid_589027, JBool, required = false,
                                 default = newJBool(true))
  if valid_589027 != nil:
    section.add "prettyPrint", valid_589027
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

proc call*(call_589029: Call_DataprocProjectsRegionsClustersCreate_589011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_589029.validator(path, query, header, formData, body)
  let scheme = call_589029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589029.url(scheme.get, call_589029.host, call_589029.base,
                         call_589029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589029, url, valid)

proc call*(call_589030: Call_DataprocProjectsRegionsClustersCreate_589011;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; requestId: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsClustersCreate
  ## Creates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : Optional. A unique id used to identify the request. If the server receives two CreateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
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
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589031 = newJObject()
  var query_589032 = newJObject()
  var body_589033 = newJObject()
  add(query_589032, "upload_protocol", newJString(uploadProtocol))
  add(query_589032, "fields", newJString(fields))
  add(query_589032, "requestId", newJString(requestId))
  add(query_589032, "quotaUser", newJString(quotaUser))
  add(query_589032, "alt", newJString(alt))
  add(query_589032, "oauth_token", newJString(oauthToken))
  add(query_589032, "callback", newJString(callback))
  add(query_589032, "access_token", newJString(accessToken))
  add(query_589032, "uploadType", newJString(uploadType))
  add(query_589032, "key", newJString(key))
  add(path_589031, "projectId", newJString(projectId))
  add(query_589032, "$.xgafv", newJString(Xgafv))
  add(path_589031, "region", newJString(region))
  if body != nil:
    body_589033 = body
  add(query_589032, "prettyPrint", newJBool(prettyPrint))
  result = call_589030.call(path_589031, query_589032, nil, nil, body_589033)

var dataprocProjectsRegionsClustersCreate* = Call_DataprocProjectsRegionsClustersCreate_589011(
    name: "dataprocProjectsRegionsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersCreate_589012, base: "/",
    url: url_DataprocProjectsRegionsClustersCreate_589013, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersList_588719 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsClustersList_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersList_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all regions/{region}/clusters in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_588847 = path.getOrDefault("projectId")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "projectId", valid_588847
  var valid_588848 = path.getOrDefault("region")
  valid_588848 = validateParameter(valid_588848, JString, required = true,
                                 default = nil)
  if valid_588848 != nil:
    section.add "region", valid_588848
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The standard List page token.
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
  ##           : Optional. The standard List page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. A filter constraining the clusters to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is one of status.state, clusterName, or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be one of the following: ACTIVE, INACTIVE, CREATING, RUNNING, ERROR, DELETING, or UPDATING. ACTIVE contains the CREATING, UPDATING, and RUNNING states. INACTIVE contains the DELETING and ERROR states. clusterName is the name of the cluster provided at creation time. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND clusterName = mycluster AND labels.env = staging AND labels.starred = *
  section = newJObject()
  var valid_588849 = query.getOrDefault("upload_protocol")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "upload_protocol", valid_588849
  var valid_588850 = query.getOrDefault("fields")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "fields", valid_588850
  var valid_588851 = query.getOrDefault("pageToken")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "pageToken", valid_588851
  var valid_588852 = query.getOrDefault("quotaUser")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "quotaUser", valid_588852
  var valid_588866 = query.getOrDefault("alt")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = newJString("json"))
  if valid_588866 != nil:
    section.add "alt", valid_588866
  var valid_588867 = query.getOrDefault("oauth_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "oauth_token", valid_588867
  var valid_588868 = query.getOrDefault("callback")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "callback", valid_588868
  var valid_588869 = query.getOrDefault("access_token")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "access_token", valid_588869
  var valid_588870 = query.getOrDefault("uploadType")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "uploadType", valid_588870
  var valid_588871 = query.getOrDefault("key")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "key", valid_588871
  var valid_588872 = query.getOrDefault("$.xgafv")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = newJString("1"))
  if valid_588872 != nil:
    section.add "$.xgafv", valid_588872
  var valid_588873 = query.getOrDefault("pageSize")
  valid_588873 = validateParameter(valid_588873, JInt, required = false, default = nil)
  if valid_588873 != nil:
    section.add "pageSize", valid_588873
  var valid_588874 = query.getOrDefault("prettyPrint")
  valid_588874 = validateParameter(valid_588874, JBool, required = false,
                                 default = newJBool(true))
  if valid_588874 != nil:
    section.add "prettyPrint", valid_588874
  var valid_588875 = query.getOrDefault("filter")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = nil)
  if valid_588875 != nil:
    section.add "filter", valid_588875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588898: Call_DataprocProjectsRegionsClustersList_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all regions/{region}/clusters in a project.
  ## 
  let valid = call_588898.validator(path, query, header, formData, body)
  let scheme = call_588898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588898.url(scheme.get, call_588898.host, call_588898.base,
                         call_588898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588898, url, valid)

proc call*(call_588969: Call_DataprocProjectsRegionsClustersList_588719;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersList
  ## Lists all regions/{region}/clusters in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The standard List page token.
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
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   pageSize: int
  ##           : Optional. The standard List page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. A filter constraining the clusters to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is one of status.state, clusterName, or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be one of the following: ACTIVE, INACTIVE, CREATING, RUNNING, ERROR, DELETING, or UPDATING. ACTIVE contains the CREATING, UPDATING, and RUNNING states. INACTIVE contains the DELETING and ERROR states. clusterName is the name of the cluster provided at creation time. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND clusterName = mycluster AND labels.env = staging AND labels.starred = *
  var path_588970 = newJObject()
  var query_588972 = newJObject()
  add(query_588972, "upload_protocol", newJString(uploadProtocol))
  add(query_588972, "fields", newJString(fields))
  add(query_588972, "pageToken", newJString(pageToken))
  add(query_588972, "quotaUser", newJString(quotaUser))
  add(query_588972, "alt", newJString(alt))
  add(query_588972, "oauth_token", newJString(oauthToken))
  add(query_588972, "callback", newJString(callback))
  add(query_588972, "access_token", newJString(accessToken))
  add(query_588972, "uploadType", newJString(uploadType))
  add(query_588972, "key", newJString(key))
  add(path_588970, "projectId", newJString(projectId))
  add(query_588972, "$.xgafv", newJString(Xgafv))
  add(path_588970, "region", newJString(region))
  add(query_588972, "pageSize", newJInt(pageSize))
  add(query_588972, "prettyPrint", newJBool(prettyPrint))
  add(query_588972, "filter", newJString(filter))
  result = call_588969.call(path_588970, query_588972, nil, nil, nil)

var dataprocProjectsRegionsClustersList* = Call_DataprocProjectsRegionsClustersList_588719(
    name: "dataprocProjectsRegionsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersList_588720, base: "/",
    url: url_DataprocProjectsRegionsClustersList_588721, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersGet_589034 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsClustersGet_589036(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersGet_589035(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required. The cluster name.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_589037 = path.getOrDefault("clusterName")
  valid_589037 = validateParameter(valid_589037, JString, required = true,
                                 default = nil)
  if valid_589037 != nil:
    section.add "clusterName", valid_589037
  var valid_589038 = path.getOrDefault("projectId")
  valid_589038 = validateParameter(valid_589038, JString, required = true,
                                 default = nil)
  if valid_589038 != nil:
    section.add "projectId", valid_589038
  var valid_589039 = path.getOrDefault("region")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "region", valid_589039
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
  var valid_589040 = query.getOrDefault("upload_protocol")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "upload_protocol", valid_589040
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("callback")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "callback", valid_589045
  var valid_589046 = query.getOrDefault("access_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "access_token", valid_589046
  var valid_589047 = query.getOrDefault("uploadType")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "uploadType", valid_589047
  var valid_589048 = query.getOrDefault("key")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "key", valid_589048
  var valid_589049 = query.getOrDefault("$.xgafv")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("1"))
  if valid_589049 != nil:
    section.add "$.xgafv", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589051: Call_DataprocProjectsRegionsClustersGet_589034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_589051.validator(path, query, header, formData, body)
  let scheme = call_589051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589051.url(scheme.get, call_589051.host, call_589051.base,
                         call_589051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589051, url, valid)

proc call*(call_589052: Call_DataprocProjectsRegionsClustersGet_589034;
          clusterName: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsClustersGet
  ## Gets the resource representation for a cluster in a project.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
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
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589053 = newJObject()
  var query_589054 = newJObject()
  add(path_589053, "clusterName", newJString(clusterName))
  add(query_589054, "upload_protocol", newJString(uploadProtocol))
  add(query_589054, "fields", newJString(fields))
  add(query_589054, "quotaUser", newJString(quotaUser))
  add(query_589054, "alt", newJString(alt))
  add(query_589054, "oauth_token", newJString(oauthToken))
  add(query_589054, "callback", newJString(callback))
  add(query_589054, "access_token", newJString(accessToken))
  add(query_589054, "uploadType", newJString(uploadType))
  add(query_589054, "key", newJString(key))
  add(path_589053, "projectId", newJString(projectId))
  add(query_589054, "$.xgafv", newJString(Xgafv))
  add(path_589053, "region", newJString(region))
  add(query_589054, "prettyPrint", newJBool(prettyPrint))
  result = call_589052.call(path_589053, query_589054, nil, nil, nil)

var dataprocProjectsRegionsClustersGet* = Call_DataprocProjectsRegionsClustersGet_589034(
    name: "dataprocProjectsRegionsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersGet_589035, base: "/",
    url: url_DataprocProjectsRegionsClustersGet_589036, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersPatch_589078 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsClustersPatch_589080(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersPatch_589079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required. The cluster name.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project the cluster belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_589081 = path.getOrDefault("clusterName")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "clusterName", valid_589081
  var valid_589082 = path.getOrDefault("projectId")
  valid_589082 = validateParameter(valid_589082, JString, required = true,
                                 default = nil)
  if valid_589082 != nil:
    section.add "projectId", valid_589082
  var valid_589083 = path.getOrDefault("region")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "region", valid_589083
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : Optional. A unique id used to identify the request. If the server receives two UpdateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
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
  ##   gracefulDecommissionTimeout: JString
  ##                              : Optional. Timeout for graceful YARN decomissioning. Graceful decommissioning allows removing nodes from the cluster without interrupting jobs in progress. Timeout specifies how long to wait for jobs in progress to finish before forcefully removing nodes (and potentially interrupting jobs). Default timeout is 0 (for forceful decommission), and the maximum allowed timeout is 1 day.Only supported on Dataproc image versions 1.2 and higher.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Required. Specifies the path, relative to Cluster, of the field to update. For example, to change the number of workers in a cluster to 5, the update_mask parameter would be specified as config.worker_config.num_instances, and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "config":{
  ##     "workerConfig":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## Similarly, to change the number of preemptible workers in a cluster to 5, the update_mask parameter would be config.secondary_worker_config.num_instances, and the PATCH request body would be set as follows:
  ## {
  ##   "config":{
  ##     "secondaryWorkerConfig":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> currently only the following fields can be updated:
  ## <table>
  ## <tr>
  ## <td><strong>Mask</strong></td><td><strong>Purpose</strong></td>
  ## </tr>
  ## <tr>
  ## <td>labels</td><td>Updates labels</td>
  ## </tr>
  ## <tr>
  ## <td>config.worker_config.num_instances</td><td>Resize primary worker
  ## group</td>
  ## </tr>
  ## <tr>
  ## <td>config.secondary_worker_config.num_instances</td><td>Resize secondary
  ## worker group</td>
  ## </tr>
  ## <tr>
  ## <td>config.lifecycle_config.auto_delete_ttl</td><td>Reset MAX TTL
  ## duration</td>
  ## </tr>
  ## <tr>
  ## <td>config.lifecycle_config.auto_delete_time</td><td>Update MAX TTL
  ## deletion timestamp</td>
  ## </tr>
  ## <tr>
  ## <td>config.lifecycle_config.idle_delete_ttl</td><td>Update Idle TTL
  ## duration</td>
  ## </tr>
  ## <tr>
  ## <td>config.autoscaling_config.policy_uri</td><td>Use, stop using, or change
  ## autoscaling policies</td>
  ## </tr>
  ## </table>
  section = newJObject()
  var valid_589084 = query.getOrDefault("upload_protocol")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "upload_protocol", valid_589084
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("requestId")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "requestId", valid_589086
  var valid_589087 = query.getOrDefault("quotaUser")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "quotaUser", valid_589087
  var valid_589088 = query.getOrDefault("alt")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = newJString("json"))
  if valid_589088 != nil:
    section.add "alt", valid_589088
  var valid_589089 = query.getOrDefault("oauth_token")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "oauth_token", valid_589089
  var valid_589090 = query.getOrDefault("callback")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "callback", valid_589090
  var valid_589091 = query.getOrDefault("access_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "access_token", valid_589091
  var valid_589092 = query.getOrDefault("uploadType")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "uploadType", valid_589092
  var valid_589093 = query.getOrDefault("gracefulDecommissionTimeout")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "gracefulDecommissionTimeout", valid_589093
  var valid_589094 = query.getOrDefault("key")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "key", valid_589094
  var valid_589095 = query.getOrDefault("$.xgafv")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("1"))
  if valid_589095 != nil:
    section.add "$.xgafv", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  var valid_589097 = query.getOrDefault("updateMask")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "updateMask", valid_589097
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

proc call*(call_589099: Call_DataprocProjectsRegionsClustersPatch_589078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_DataprocProjectsRegionsClustersPatch_589078;
          clusterName: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; requestId: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          gracefulDecommissionTimeout: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersPatch
  ## Updates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : Optional. A unique id used to identify the request. If the server receives two UpdateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
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
  ##   gracefulDecommissionTimeout: string
  ##                              : Optional. Timeout for graceful YARN decomissioning. Graceful decommissioning allows removing nodes from the cluster without interrupting jobs in progress. Timeout specifies how long to wait for jobs in progress to finish before forcefully removing nodes (and potentially interrupting jobs). Default timeout is 0 (for forceful decommission), and the maximum allowed timeout is 1 day.Only supported on Dataproc image versions 1.2 and higher.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required. Specifies the path, relative to Cluster, of the field to update. For example, to change the number of workers in a cluster to 5, the update_mask parameter would be specified as config.worker_config.num_instances, and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "config":{
  ##     "workerConfig":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## Similarly, to change the number of preemptible workers in a cluster to 5, the update_mask parameter would be config.secondary_worker_config.num_instances, and the PATCH request body would be set as follows:
  ## {
  ##   "config":{
  ##     "secondaryWorkerConfig":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> currently only the following fields can be updated:
  ## <table>
  ## <tr>
  ## <td><strong>Mask</strong></td><td><strong>Purpose</strong></td>
  ## </tr>
  ## <tr>
  ## <td>labels</td><td>Updates labels</td>
  ## </tr>
  ## <tr>
  ## <td>config.worker_config.num_instances</td><td>Resize primary worker
  ## group</td>
  ## </tr>
  ## <tr>
  ## <td>config.secondary_worker_config.num_instances</td><td>Resize secondary
  ## worker group</td>
  ## </tr>
  ## <tr>
  ## <td>config.lifecycle_config.auto_delete_ttl</td><td>Reset MAX TTL
  ## duration</td>
  ## </tr>
  ## <tr>
  ## <td>config.lifecycle_config.auto_delete_time</td><td>Update MAX TTL
  ## deletion timestamp</td>
  ## </tr>
  ## <tr>
  ## <td>config.lifecycle_config.idle_delete_ttl</td><td>Update Idle TTL
  ## duration</td>
  ## </tr>
  ## <tr>
  ## <td>config.autoscaling_config.policy_uri</td><td>Use, stop using, or change
  ## autoscaling policies</td>
  ## </tr>
  ## </table>
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  var body_589103 = newJObject()
  add(path_589101, "clusterName", newJString(clusterName))
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "requestId", newJString(requestId))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "gracefulDecommissionTimeout",
      newJString(gracefulDecommissionTimeout))
  add(query_589102, "key", newJString(key))
  add(path_589101, "projectId", newJString(projectId))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  add(path_589101, "region", newJString(region))
  if body != nil:
    body_589103 = body
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  add(query_589102, "updateMask", newJString(updateMask))
  result = call_589100.call(path_589101, query_589102, nil, nil, body_589103)

var dataprocProjectsRegionsClustersPatch* = Call_DataprocProjectsRegionsClustersPatch_589078(
    name: "dataprocProjectsRegionsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersPatch_589079, base: "/",
    url: url_DataprocProjectsRegionsClustersPatch_589080, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDelete_589055 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsClustersDelete_589057(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersDelete_589056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required. The cluster name.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_589058 = path.getOrDefault("clusterName")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "clusterName", valid_589058
  var valid_589059 = path.getOrDefault("projectId")
  valid_589059 = validateParameter(valid_589059, JString, required = true,
                                 default = nil)
  if valid_589059 != nil:
    section.add "projectId", valid_589059
  var valid_589060 = path.getOrDefault("region")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "region", valid_589060
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : Optional. A unique id used to identify the request. If the server receives two DeleteClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   clusterUuid: JString
  ##              : Optional. Specifying the cluster_uuid means the RPC should fail (with error NOT_FOUND) if cluster with specified UUID does not exist.
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
  var valid_589061 = query.getOrDefault("upload_protocol")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "upload_protocol", valid_589061
  var valid_589062 = query.getOrDefault("fields")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "fields", valid_589062
  var valid_589063 = query.getOrDefault("requestId")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "requestId", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("clusterUuid")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "clusterUuid", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("callback")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "callback", valid_589068
  var valid_589069 = query.getOrDefault("access_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "access_token", valid_589069
  var valid_589070 = query.getOrDefault("uploadType")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "uploadType", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("$.xgafv")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("1"))
  if valid_589072 != nil:
    section.add "$.xgafv", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589074: Call_DataprocProjectsRegionsClustersDelete_589055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_589074.validator(path, query, header, formData, body)
  let scheme = call_589074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589074.url(scheme.get, call_589074.host, call_589074.base,
                         call_589074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589074, url, valid)

proc call*(call_589075: Call_DataprocProjectsRegionsClustersDelete_589055;
          clusterName: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; requestId: string = "";
          quotaUser: string = ""; alt: string = "json"; clusterUuid: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsClustersDelete
  ## Deletes a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : Optional. A unique id used to identify the request. If the server receives two DeleteClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   clusterUuid: string
  ##              : Optional. Specifying the cluster_uuid means the RPC should fail (with error NOT_FOUND) if cluster with specified UUID does not exist.
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
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589076 = newJObject()
  var query_589077 = newJObject()
  add(path_589076, "clusterName", newJString(clusterName))
  add(query_589077, "upload_protocol", newJString(uploadProtocol))
  add(query_589077, "fields", newJString(fields))
  add(query_589077, "requestId", newJString(requestId))
  add(query_589077, "quotaUser", newJString(quotaUser))
  add(query_589077, "alt", newJString(alt))
  add(query_589077, "clusterUuid", newJString(clusterUuid))
  add(query_589077, "oauth_token", newJString(oauthToken))
  add(query_589077, "callback", newJString(callback))
  add(query_589077, "access_token", newJString(accessToken))
  add(query_589077, "uploadType", newJString(uploadType))
  add(query_589077, "key", newJString(key))
  add(path_589076, "projectId", newJString(projectId))
  add(query_589077, "$.xgafv", newJString(Xgafv))
  add(path_589076, "region", newJString(region))
  add(query_589077, "prettyPrint", newJBool(prettyPrint))
  result = call_589075.call(path_589076, query_589077, nil, nil, nil)

var dataprocProjectsRegionsClustersDelete* = Call_DataprocProjectsRegionsClustersDelete_589055(
    name: "dataprocProjectsRegionsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersDelete_589056, base: "/",
    url: url_DataprocProjectsRegionsClustersDelete_589057, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDiagnose_589104 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsClustersDiagnose_589106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: ":diagnose")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsClustersDiagnose_589105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets cluster diagnostic information. The returned Operation.metadata will be ClusterOperationMetadata. After the operation completes, Operation.response contains DiagnoseClusterResults.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required. The cluster name.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_589107 = path.getOrDefault("clusterName")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "clusterName", valid_589107
  var valid_589108 = path.getOrDefault("projectId")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "projectId", valid_589108
  var valid_589109 = path.getOrDefault("region")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "region", valid_589109
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
  var valid_589110 = query.getOrDefault("upload_protocol")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "upload_protocol", valid_589110
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("callback")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "callback", valid_589115
  var valid_589116 = query.getOrDefault("access_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "access_token", valid_589116
  var valid_589117 = query.getOrDefault("uploadType")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "uploadType", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("$.xgafv")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("1"))
  if valid_589119 != nil:
    section.add "$.xgafv", valid_589119
  var valid_589120 = query.getOrDefault("prettyPrint")
  valid_589120 = validateParameter(valid_589120, JBool, required = false,
                                 default = newJBool(true))
  if valid_589120 != nil:
    section.add "prettyPrint", valid_589120
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

proc call*(call_589122: Call_DataprocProjectsRegionsClustersDiagnose_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. The returned Operation.metadata will be ClusterOperationMetadata. After the operation completes, Operation.response contains DiagnoseClusterResults.
  ## 
  let valid = call_589122.validator(path, query, header, formData, body)
  let scheme = call_589122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589122.url(scheme.get, call_589122.host, call_589122.base,
                         call_589122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589122, url, valid)

proc call*(call_589123: Call_DataprocProjectsRegionsClustersDiagnose_589104;
          clusterName: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsClustersDiagnose
  ## Gets cluster diagnostic information. The returned Operation.metadata will be ClusterOperationMetadata. After the operation completes, Operation.response contains DiagnoseClusterResults.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
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
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589124 = newJObject()
  var query_589125 = newJObject()
  var body_589126 = newJObject()
  add(path_589124, "clusterName", newJString(clusterName))
  add(query_589125, "upload_protocol", newJString(uploadProtocol))
  add(query_589125, "fields", newJString(fields))
  add(query_589125, "quotaUser", newJString(quotaUser))
  add(query_589125, "alt", newJString(alt))
  add(query_589125, "oauth_token", newJString(oauthToken))
  add(query_589125, "callback", newJString(callback))
  add(query_589125, "access_token", newJString(accessToken))
  add(query_589125, "uploadType", newJString(uploadType))
  add(query_589125, "key", newJString(key))
  add(path_589124, "projectId", newJString(projectId))
  add(query_589125, "$.xgafv", newJString(Xgafv))
  add(path_589124, "region", newJString(region))
  if body != nil:
    body_589126 = body
  add(query_589125, "prettyPrint", newJBool(prettyPrint))
  result = call_589123.call(path_589124, query_589125, nil, nil, body_589126)

var dataprocProjectsRegionsClustersDiagnose* = Call_DataprocProjectsRegionsClustersDiagnose_589104(
    name: "dataprocProjectsRegionsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsRegionsClustersDiagnose_589105, base: "/",
    url: url_DataprocProjectsRegionsClustersDiagnose_589106,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsList_589127 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsJobsList_589129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsList_589128(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists regions/{region}/jobs in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589130 = path.getOrDefault("projectId")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "projectId", valid_589130
  var valid_589131 = path.getOrDefault("region")
  valid_589131 = validateParameter(valid_589131, JString, required = true,
                                 default = nil)
  if valid_589131 != nil:
    section.add "region", valid_589131
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
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
  ##   jobStateMatcher: JString
  ##                  : Optional. Specifies enumerated categories of jobs to list. (default = match ALL jobs).If filter is provided, jobStateMatcher will be ignored.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The number of results to return in each response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. A filter constraining the jobs to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is status.state or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be either ACTIVE or NON_ACTIVE. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND labels.env = staging AND labels.starred = *
  ##   clusterName: JString
  ##              : Optional. If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  section = newJObject()
  var valid_589132 = query.getOrDefault("upload_protocol")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "upload_protocol", valid_589132
  var valid_589133 = query.getOrDefault("fields")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "fields", valid_589133
  var valid_589134 = query.getOrDefault("pageToken")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "pageToken", valid_589134
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
  var valid_589141 = query.getOrDefault("jobStateMatcher")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = newJString("ALL"))
  if valid_589141 != nil:
    section.add "jobStateMatcher", valid_589141
  var valid_589142 = query.getOrDefault("key")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "key", valid_589142
  var valid_589143 = query.getOrDefault("$.xgafv")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("1"))
  if valid_589143 != nil:
    section.add "$.xgafv", valid_589143
  var valid_589144 = query.getOrDefault("pageSize")
  valid_589144 = validateParameter(valid_589144, JInt, required = false, default = nil)
  if valid_589144 != nil:
    section.add "pageSize", valid_589144
  var valid_589145 = query.getOrDefault("prettyPrint")
  valid_589145 = validateParameter(valid_589145, JBool, required = false,
                                 default = newJBool(true))
  if valid_589145 != nil:
    section.add "prettyPrint", valid_589145
  var valid_589146 = query.getOrDefault("filter")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "filter", valid_589146
  var valid_589147 = query.getOrDefault("clusterName")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "clusterName", valid_589147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589148: Call_DataprocProjectsRegionsJobsList_589127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists regions/{region}/jobs in a project.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_DataprocProjectsRegionsJobsList_589127;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          jobStateMatcher: string = "ALL"; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; filter: string = "";
          clusterName: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsList
  ## Lists regions/{region}/jobs in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
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
  ##   jobStateMatcher: string
  ##                  : Optional. Specifies enumerated categories of jobs to list. (default = match ALL jobs).If filter is provided, jobStateMatcher will be ignored.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   pageSize: int
  ##           : Optional. The number of results to return in each response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. A filter constraining the jobs to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is status.state or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be either ACTIVE or NON_ACTIVE. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND labels.env = staging AND labels.starred = *
  ##   clusterName: string
  ##              : Optional. If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  add(query_589151, "upload_protocol", newJString(uploadProtocol))
  add(query_589151, "fields", newJString(fields))
  add(query_589151, "pageToken", newJString(pageToken))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(query_589151, "alt", newJString(alt))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(query_589151, "callback", newJString(callback))
  add(query_589151, "access_token", newJString(accessToken))
  add(query_589151, "uploadType", newJString(uploadType))
  add(query_589151, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_589151, "key", newJString(key))
  add(path_589150, "projectId", newJString(projectId))
  add(query_589151, "$.xgafv", newJString(Xgafv))
  add(path_589150, "region", newJString(region))
  add(query_589151, "pageSize", newJInt(pageSize))
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  add(query_589151, "filter", newJString(filter))
  add(query_589151, "clusterName", newJString(clusterName))
  result = call_589149.call(path_589150, query_589151, nil, nil, nil)

var dataprocProjectsRegionsJobsList* = Call_DataprocProjectsRegionsJobsList_589127(
    name: "dataprocProjectsRegionsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs",
    validator: validate_DataprocProjectsRegionsJobsList_589128, base: "/",
    url: url_DataprocProjectsRegionsJobsList_589129, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsGet_589152 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsJobsGet_589154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsGet_589153(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589155 = path.getOrDefault("jobId")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "jobId", valid_589155
  var valid_589156 = path.getOrDefault("projectId")
  valid_589156 = validateParameter(valid_589156, JString, required = true,
                                 default = nil)
  if valid_589156 != nil:
    section.add "projectId", valid_589156
  var valid_589157 = path.getOrDefault("region")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "region", valid_589157
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
  var valid_589158 = query.getOrDefault("upload_protocol")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "upload_protocol", valid_589158
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("quotaUser")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "quotaUser", valid_589160
  var valid_589161 = query.getOrDefault("alt")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = newJString("json"))
  if valid_589161 != nil:
    section.add "alt", valid_589161
  var valid_589162 = query.getOrDefault("oauth_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "oauth_token", valid_589162
  var valid_589163 = query.getOrDefault("callback")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "callback", valid_589163
  var valid_589164 = query.getOrDefault("access_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "access_token", valid_589164
  var valid_589165 = query.getOrDefault("uploadType")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "uploadType", valid_589165
  var valid_589166 = query.getOrDefault("key")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "key", valid_589166
  var valid_589167 = query.getOrDefault("$.xgafv")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("1"))
  if valid_589167 != nil:
    section.add "$.xgafv", valid_589167
  var valid_589168 = query.getOrDefault("prettyPrint")
  valid_589168 = validateParameter(valid_589168, JBool, required = false,
                                 default = newJBool(true))
  if valid_589168 != nil:
    section.add "prettyPrint", valid_589168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589169: Call_DataprocProjectsRegionsJobsGet_589152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_589169.validator(path, query, header, formData, body)
  let scheme = call_589169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589169.url(scheme.get, call_589169.host, call_589169.base,
                         call_589169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589169, url, valid)

proc call*(call_589170: Call_DataprocProjectsRegionsJobsGet_589152; jobId: string;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
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
  ##   jobId: string (required)
  ##        : Required. The job ID.
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
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589171 = newJObject()
  var query_589172 = newJObject()
  add(query_589172, "upload_protocol", newJString(uploadProtocol))
  add(query_589172, "fields", newJString(fields))
  add(query_589172, "quotaUser", newJString(quotaUser))
  add(query_589172, "alt", newJString(alt))
  add(path_589171, "jobId", newJString(jobId))
  add(query_589172, "oauth_token", newJString(oauthToken))
  add(query_589172, "callback", newJString(callback))
  add(query_589172, "access_token", newJString(accessToken))
  add(query_589172, "uploadType", newJString(uploadType))
  add(query_589172, "key", newJString(key))
  add(path_589171, "projectId", newJString(projectId))
  add(query_589172, "$.xgafv", newJString(Xgafv))
  add(path_589171, "region", newJString(region))
  add(query_589172, "prettyPrint", newJBool(prettyPrint))
  result = call_589170.call(path_589171, query_589172, nil, nil, nil)

var dataprocProjectsRegionsJobsGet* = Call_DataprocProjectsRegionsJobsGet_589152(
    name: "dataprocProjectsRegionsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsGet_589153, base: "/",
    url: url_DataprocProjectsRegionsJobsGet_589154, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsPatch_589194 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsJobsPatch_589196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsPatch_589195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589197 = path.getOrDefault("jobId")
  valid_589197 = validateParameter(valid_589197, JString, required = true,
                                 default = nil)
  if valid_589197 != nil:
    section.add "jobId", valid_589197
  var valid_589198 = path.getOrDefault("projectId")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "projectId", valid_589198
  var valid_589199 = path.getOrDefault("region")
  valid_589199 = validateParameter(valid_589199, JString, required = true,
                                 default = nil)
  if valid_589199 != nil:
    section.add "region", valid_589199
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
  ##   updateMask: JString
  ##             : Required. Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  section = newJObject()
  var valid_589200 = query.getOrDefault("upload_protocol")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "upload_protocol", valid_589200
  var valid_589201 = query.getOrDefault("fields")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "fields", valid_589201
  var valid_589202 = query.getOrDefault("quotaUser")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "quotaUser", valid_589202
  var valid_589203 = query.getOrDefault("alt")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = newJString("json"))
  if valid_589203 != nil:
    section.add "alt", valid_589203
  var valid_589204 = query.getOrDefault("oauth_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "oauth_token", valid_589204
  var valid_589205 = query.getOrDefault("callback")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "callback", valid_589205
  var valid_589206 = query.getOrDefault("access_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "access_token", valid_589206
  var valid_589207 = query.getOrDefault("uploadType")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "uploadType", valid_589207
  var valid_589208 = query.getOrDefault("key")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "key", valid_589208
  var valid_589209 = query.getOrDefault("$.xgafv")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("1"))
  if valid_589209 != nil:
    section.add "$.xgafv", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
  var valid_589211 = query.getOrDefault("updateMask")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "updateMask", valid_589211
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

proc call*(call_589213: Call_DataprocProjectsRegionsJobsPatch_589194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_589213.validator(path, query, header, formData, body)
  let scheme = call_589213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589213.url(scheme.get, call_589213.host, call_589213.base,
                         call_589213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589213, url, valid)

proc call*(call_589214: Call_DataprocProjectsRegionsJobsPatch_589194;
          jobId: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
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
  ##   jobId: string (required)
  ##        : Required. The job ID.
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
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required. Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  var path_589215 = newJObject()
  var query_589216 = newJObject()
  var body_589217 = newJObject()
  add(query_589216, "upload_protocol", newJString(uploadProtocol))
  add(query_589216, "fields", newJString(fields))
  add(query_589216, "quotaUser", newJString(quotaUser))
  add(query_589216, "alt", newJString(alt))
  add(path_589215, "jobId", newJString(jobId))
  add(query_589216, "oauth_token", newJString(oauthToken))
  add(query_589216, "callback", newJString(callback))
  add(query_589216, "access_token", newJString(accessToken))
  add(query_589216, "uploadType", newJString(uploadType))
  add(query_589216, "key", newJString(key))
  add(path_589215, "projectId", newJString(projectId))
  add(query_589216, "$.xgafv", newJString(Xgafv))
  add(path_589215, "region", newJString(region))
  if body != nil:
    body_589217 = body
  add(query_589216, "prettyPrint", newJBool(prettyPrint))
  add(query_589216, "updateMask", newJString(updateMask))
  result = call_589214.call(path_589215, query_589216, nil, nil, body_589217)

var dataprocProjectsRegionsJobsPatch* = Call_DataprocProjectsRegionsJobsPatch_589194(
    name: "dataprocProjectsRegionsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsPatch_589195, base: "/",
    url: url_DataprocProjectsRegionsJobsPatch_589196, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsDelete_589173 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsJobsDelete_589175(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsDelete_589174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589176 = path.getOrDefault("jobId")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "jobId", valid_589176
  var valid_589177 = path.getOrDefault("projectId")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "projectId", valid_589177
  var valid_589178 = path.getOrDefault("region")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "region", valid_589178
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
  var valid_589179 = query.getOrDefault("upload_protocol")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "upload_protocol", valid_589179
  var valid_589180 = query.getOrDefault("fields")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "fields", valid_589180
  var valid_589181 = query.getOrDefault("quotaUser")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "quotaUser", valid_589181
  var valid_589182 = query.getOrDefault("alt")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = newJString("json"))
  if valid_589182 != nil:
    section.add "alt", valid_589182
  var valid_589183 = query.getOrDefault("oauth_token")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "oauth_token", valid_589183
  var valid_589184 = query.getOrDefault("callback")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "callback", valid_589184
  var valid_589185 = query.getOrDefault("access_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "access_token", valid_589185
  var valid_589186 = query.getOrDefault("uploadType")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "uploadType", valid_589186
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589190: Call_DataprocProjectsRegionsJobsDelete_589173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_589190.validator(path, query, header, formData, body)
  let scheme = call_589190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589190.url(scheme.get, call_589190.host, call_589190.base,
                         call_589190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589190, url, valid)

proc call*(call_589191: Call_DataprocProjectsRegionsJobsDelete_589173;
          jobId: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
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
  ##   jobId: string (required)
  ##        : Required. The job ID.
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
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589192 = newJObject()
  var query_589193 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(path_589192, "jobId", newJString(jobId))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(query_589193, "key", newJString(key))
  add(path_589192, "projectId", newJString(projectId))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  add(path_589192, "region", newJString(region))
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  result = call_589191.call(path_589192, query_589193, nil, nil, nil)

var dataprocProjectsRegionsJobsDelete* = Call_DataprocProjectsRegionsJobsDelete_589173(
    name: "dataprocProjectsRegionsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsDelete_589174, base: "/",
    url: url_DataprocProjectsRegionsJobsDelete_589175, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsCancel_589218 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsJobsCancel_589220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
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

proc validate_DataprocProjectsRegionsJobsCancel_589219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589221 = path.getOrDefault("jobId")
  valid_589221 = validateParameter(valid_589221, JString, required = true,
                                 default = nil)
  if valid_589221 != nil:
    section.add "jobId", valid_589221
  var valid_589222 = path.getOrDefault("projectId")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = nil)
  if valid_589222 != nil:
    section.add "projectId", valid_589222
  var valid_589223 = path.getOrDefault("region")
  valid_589223 = validateParameter(valid_589223, JString, required = true,
                                 default = nil)
  if valid_589223 != nil:
    section.add "region", valid_589223
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
  var valid_589224 = query.getOrDefault("upload_protocol")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "upload_protocol", valid_589224
  var valid_589225 = query.getOrDefault("fields")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "fields", valid_589225
  var valid_589226 = query.getOrDefault("quotaUser")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "quotaUser", valid_589226
  var valid_589227 = query.getOrDefault("alt")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = newJString("json"))
  if valid_589227 != nil:
    section.add "alt", valid_589227
  var valid_589228 = query.getOrDefault("oauth_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "oauth_token", valid_589228
  var valid_589229 = query.getOrDefault("callback")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "callback", valid_589229
  var valid_589230 = query.getOrDefault("access_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "access_token", valid_589230
  var valid_589231 = query.getOrDefault("uploadType")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "uploadType", valid_589231
  var valid_589232 = query.getOrDefault("key")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "key", valid_589232
  var valid_589233 = query.getOrDefault("$.xgafv")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("1"))
  if valid_589233 != nil:
    section.add "$.xgafv", valid_589233
  var valid_589234 = query.getOrDefault("prettyPrint")
  valid_589234 = validateParameter(valid_589234, JBool, required = false,
                                 default = newJBool(true))
  if valid_589234 != nil:
    section.add "prettyPrint", valid_589234
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

proc call*(call_589236: Call_DataprocProjectsRegionsJobsCancel_589218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ## 
  let valid = call_589236.validator(path, query, header, formData, body)
  let scheme = call_589236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589236.url(scheme.get, call_589236.host, call_589236.base,
                         call_589236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589236, url, valid)

proc call*(call_589237: Call_DataprocProjectsRegionsJobsCancel_589218;
          jobId: string; projectId: string; region: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsJobsCancel
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : Required. The job ID.
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
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589238 = newJObject()
  var query_589239 = newJObject()
  var body_589240 = newJObject()
  add(query_589239, "upload_protocol", newJString(uploadProtocol))
  add(query_589239, "fields", newJString(fields))
  add(query_589239, "quotaUser", newJString(quotaUser))
  add(query_589239, "alt", newJString(alt))
  add(path_589238, "jobId", newJString(jobId))
  add(query_589239, "oauth_token", newJString(oauthToken))
  add(query_589239, "callback", newJString(callback))
  add(query_589239, "access_token", newJString(accessToken))
  add(query_589239, "uploadType", newJString(uploadType))
  add(query_589239, "key", newJString(key))
  add(path_589238, "projectId", newJString(projectId))
  add(query_589239, "$.xgafv", newJString(Xgafv))
  add(path_589238, "region", newJString(region))
  if body != nil:
    body_589240 = body
  add(query_589239, "prettyPrint", newJBool(prettyPrint))
  result = call_589237.call(path_589238, query_589239, nil, nil, body_589240)

var dataprocProjectsRegionsJobsCancel* = Call_DataprocProjectsRegionsJobsCancel_589218(
    name: "dataprocProjectsRegionsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsRegionsJobsCancel_589219, base: "/",
    url: url_DataprocProjectsRegionsJobsCancel_589220, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsSubmit_589241 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsJobsSubmit_589243(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/jobs:submit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsJobsSubmit_589242(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a job to a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589244 = path.getOrDefault("projectId")
  valid_589244 = validateParameter(valid_589244, JString, required = true,
                                 default = nil)
  if valid_589244 != nil:
    section.add "projectId", valid_589244
  var valid_589245 = path.getOrDefault("region")
  valid_589245 = validateParameter(valid_589245, JString, required = true,
                                 default = nil)
  if valid_589245 != nil:
    section.add "region", valid_589245
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
  var valid_589246 = query.getOrDefault("upload_protocol")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "upload_protocol", valid_589246
  var valid_589247 = query.getOrDefault("fields")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "fields", valid_589247
  var valid_589248 = query.getOrDefault("quotaUser")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "quotaUser", valid_589248
  var valid_589249 = query.getOrDefault("alt")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = newJString("json"))
  if valid_589249 != nil:
    section.add "alt", valid_589249
  var valid_589250 = query.getOrDefault("oauth_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "oauth_token", valid_589250
  var valid_589251 = query.getOrDefault("callback")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "callback", valid_589251
  var valid_589252 = query.getOrDefault("access_token")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "access_token", valid_589252
  var valid_589253 = query.getOrDefault("uploadType")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "uploadType", valid_589253
  var valid_589254 = query.getOrDefault("key")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "key", valid_589254
  var valid_589255 = query.getOrDefault("$.xgafv")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = newJString("1"))
  if valid_589255 != nil:
    section.add "$.xgafv", valid_589255
  var valid_589256 = query.getOrDefault("prettyPrint")
  valid_589256 = validateParameter(valid_589256, JBool, required = false,
                                 default = newJBool(true))
  if valid_589256 != nil:
    section.add "prettyPrint", valid_589256
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

proc call*(call_589258: Call_DataprocProjectsRegionsJobsSubmit_589241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_589258.validator(path, query, header, formData, body)
  let scheme = call_589258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589258.url(scheme.get, call_589258.host, call_589258.base,
                         call_589258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589258, url, valid)

proc call*(call_589259: Call_DataprocProjectsRegionsJobsSubmit_589241;
          projectId: string; region: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589260 = newJObject()
  var query_589261 = newJObject()
  var body_589262 = newJObject()
  add(query_589261, "upload_protocol", newJString(uploadProtocol))
  add(query_589261, "fields", newJString(fields))
  add(query_589261, "quotaUser", newJString(quotaUser))
  add(query_589261, "alt", newJString(alt))
  add(query_589261, "oauth_token", newJString(oauthToken))
  add(query_589261, "callback", newJString(callback))
  add(query_589261, "access_token", newJString(accessToken))
  add(query_589261, "uploadType", newJString(uploadType))
  add(query_589261, "key", newJString(key))
  add(path_589260, "projectId", newJString(projectId))
  add(query_589261, "$.xgafv", newJString(Xgafv))
  add(path_589260, "region", newJString(region))
  if body != nil:
    body_589262 = body
  add(query_589261, "prettyPrint", newJBool(prettyPrint))
  result = call_589259.call(path_589260, query_589261, nil, nil, body_589262)

var dataprocProjectsRegionsJobsSubmit* = Call_DataprocProjectsRegionsJobsSubmit_589241(
    name: "dataprocProjectsRegionsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs:submit",
    validator: validate_DataprocProjectsRegionsJobsSubmit_589242, base: "/",
    url: url_DataprocProjectsRegionsJobsSubmit_589243, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_589285 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesUpdate_589287(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesUpdate_589286(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates (replaces) workflow template. The updated template must contain version that matches the current server version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates, the resource name of the  template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates, the resource name of the  template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589288 = path.getOrDefault("name")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "name", valid_589288
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
  var valid_589289 = query.getOrDefault("upload_protocol")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "upload_protocol", valid_589289
  var valid_589290 = query.getOrDefault("fields")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "fields", valid_589290
  var valid_589291 = query.getOrDefault("quotaUser")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "quotaUser", valid_589291
  var valid_589292 = query.getOrDefault("alt")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("json"))
  if valid_589292 != nil:
    section.add "alt", valid_589292
  var valid_589293 = query.getOrDefault("oauth_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "oauth_token", valid_589293
  var valid_589294 = query.getOrDefault("callback")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "callback", valid_589294
  var valid_589295 = query.getOrDefault("access_token")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "access_token", valid_589295
  var valid_589296 = query.getOrDefault("uploadType")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "uploadType", valid_589296
  var valid_589297 = query.getOrDefault("key")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "key", valid_589297
  var valid_589298 = query.getOrDefault("$.xgafv")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("1"))
  if valid_589298 != nil:
    section.add "$.xgafv", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
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

proc call*(call_589301: Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_589285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates (replaces) workflow template. The updated template must contain version that matches the current server version.
  ## 
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_589285;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesUpdate
  ## Updates (replaces) workflow template. The updated template must contain version that matches the current server version.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates, the resource name of the  template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates, the resource name of the  template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
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
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  var body_589305 = newJObject()
  add(query_589304, "upload_protocol", newJString(uploadProtocol))
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(path_589303, "name", newJString(name))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "callback", newJString(callback))
  add(query_589304, "access_token", newJString(accessToken))
  add(query_589304, "uploadType", newJString(uploadType))
  add(query_589304, "key", newJString(key))
  add(query_589304, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589305 = body
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  result = call_589302.call(path_589303, query_589304, nil, nil, body_589305)

var dataprocProjectsRegionsWorkflowTemplatesUpdate* = Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_589285(
    name: "dataprocProjectsRegionsWorkflowTemplatesUpdate",
    meth: HttpMethod.HttpPut, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesUpdate_589286,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesUpdate_589287,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesGet_589263 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesGet_589265(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesGet_589264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the latest workflow template.Can retrieve previously instantiated template by specifying optional version parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.get, the resource name of the  template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.get, the resource name of the  template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589266 = path.getOrDefault("name")
  valid_589266 = validateParameter(valid_589266, JString, required = true,
                                 default = nil)
  if valid_589266 != nil:
    section.add "name", valid_589266
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
  ##   version: JInt
  ##          : Optional. The version of workflow template to retrieve. Only previously instantiated versions can be retrieved.If unspecified, retrieves the current version.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589267 = query.getOrDefault("upload_protocol")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "upload_protocol", valid_589267
  var valid_589268 = query.getOrDefault("fields")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "fields", valid_589268
  var valid_589269 = query.getOrDefault("pageToken")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "pageToken", valid_589269
  var valid_589270 = query.getOrDefault("quotaUser")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "quotaUser", valid_589270
  var valid_589271 = query.getOrDefault("alt")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("json"))
  if valid_589271 != nil:
    section.add "alt", valid_589271
  var valid_589272 = query.getOrDefault("oauth_token")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "oauth_token", valid_589272
  var valid_589273 = query.getOrDefault("callback")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "callback", valid_589273
  var valid_589274 = query.getOrDefault("access_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "access_token", valid_589274
  var valid_589275 = query.getOrDefault("uploadType")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "uploadType", valid_589275
  var valid_589276 = query.getOrDefault("key")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "key", valid_589276
  var valid_589277 = query.getOrDefault("$.xgafv")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("1"))
  if valid_589277 != nil:
    section.add "$.xgafv", valid_589277
  var valid_589278 = query.getOrDefault("pageSize")
  valid_589278 = validateParameter(valid_589278, JInt, required = false, default = nil)
  if valid_589278 != nil:
    section.add "pageSize", valid_589278
  var valid_589279 = query.getOrDefault("version")
  valid_589279 = validateParameter(valid_589279, JInt, required = false, default = nil)
  if valid_589279 != nil:
    section.add "version", valid_589279
  var valid_589280 = query.getOrDefault("prettyPrint")
  valid_589280 = validateParameter(valid_589280, JBool, required = false,
                                 default = newJBool(true))
  if valid_589280 != nil:
    section.add "prettyPrint", valid_589280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589281: Call_DataprocProjectsRegionsWorkflowTemplatesGet_589263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the latest workflow template.Can retrieve previously instantiated template by specifying optional version parameter.
  ## 
  let valid = call_589281.validator(path, query, header, formData, body)
  let scheme = call_589281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589281.url(scheme.get, call_589281.host, call_589281.base,
                         call_589281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589281, url, valid)

proc call*(call_589282: Call_DataprocProjectsRegionsWorkflowTemplatesGet_589263;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          version: int = 0; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesGet
  ## Retrieves the latest workflow template.Can retrieve previously instantiated template by specifying optional version parameter.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.get, the resource name of the  template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.get, the resource name of the  template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
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
  ##   version: int
  ##          : Optional. The version of workflow template to retrieve. Only previously instantiated versions can be retrieved.If unspecified, retrieves the current version.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589283 = newJObject()
  var query_589284 = newJObject()
  add(query_589284, "upload_protocol", newJString(uploadProtocol))
  add(query_589284, "fields", newJString(fields))
  add(query_589284, "pageToken", newJString(pageToken))
  add(query_589284, "quotaUser", newJString(quotaUser))
  add(path_589283, "name", newJString(name))
  add(query_589284, "alt", newJString(alt))
  add(query_589284, "oauth_token", newJString(oauthToken))
  add(query_589284, "callback", newJString(callback))
  add(query_589284, "access_token", newJString(accessToken))
  add(query_589284, "uploadType", newJString(uploadType))
  add(query_589284, "key", newJString(key))
  add(query_589284, "$.xgafv", newJString(Xgafv))
  add(query_589284, "pageSize", newJInt(pageSize))
  add(query_589284, "version", newJInt(version))
  add(query_589284, "prettyPrint", newJBool(prettyPrint))
  result = call_589282.call(path_589283, query_589284, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesGet* = Call_DataprocProjectsRegionsWorkflowTemplatesGet_589263(
    name: "dataprocProjectsRegionsWorkflowTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesGet_589264,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesGet_589265,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesDelete_589306 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesDelete_589308(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesDelete_589307(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a workflow template. It does not cancel in-progress workflows.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.delete, the resource name of the template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.instantiate, the resource name  of the template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589309 = path.getOrDefault("name")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "name", valid_589309
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
  ##   version: JInt
  ##          : Optional. The version of workflow template to delete. If specified, will only delete the template if the current server version matches specified version.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589310 = query.getOrDefault("upload_protocol")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "upload_protocol", valid_589310
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("callback")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "callback", valid_589315
  var valid_589316 = query.getOrDefault("access_token")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "access_token", valid_589316
  var valid_589317 = query.getOrDefault("uploadType")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "uploadType", valid_589317
  var valid_589318 = query.getOrDefault("key")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "key", valid_589318
  var valid_589319 = query.getOrDefault("$.xgafv")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("1"))
  if valid_589319 != nil:
    section.add "$.xgafv", valid_589319
  var valid_589320 = query.getOrDefault("version")
  valid_589320 = validateParameter(valid_589320, JInt, required = false, default = nil)
  if valid_589320 != nil:
    section.add "version", valid_589320
  var valid_589321 = query.getOrDefault("prettyPrint")
  valid_589321 = validateParameter(valid_589321, JBool, required = false,
                                 default = newJBool(true))
  if valid_589321 != nil:
    section.add "prettyPrint", valid_589321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589322: Call_DataprocProjectsRegionsWorkflowTemplatesDelete_589306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a workflow template. It does not cancel in-progress workflows.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_DataprocProjectsRegionsWorkflowTemplatesDelete_589306;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; version: int = 0; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesDelete
  ## Deletes a workflow template. It does not cancel in-progress workflows.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.delete, the resource name of the template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.instantiate, the resource name  of the template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
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
  ##   version: int
  ##          : Optional. The version of workflow template to delete. If specified, will only delete the template if the current server version matches specified version.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589324 = newJObject()
  var query_589325 = newJObject()
  add(query_589325, "upload_protocol", newJString(uploadProtocol))
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(path_589324, "name", newJString(name))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(query_589325, "callback", newJString(callback))
  add(query_589325, "access_token", newJString(accessToken))
  add(query_589325, "uploadType", newJString(uploadType))
  add(query_589325, "key", newJString(key))
  add(query_589325, "$.xgafv", newJString(Xgafv))
  add(query_589325, "version", newJInt(version))
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  result = call_589323.call(path_589324, query_589325, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesDelete* = Call_DataprocProjectsRegionsWorkflowTemplatesDelete_589306(
    name: "dataprocProjectsRegionsWorkflowTemplatesDelete",
    meth: HttpMethod.HttpDelete, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesDelete_589307,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesDelete_589308,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsOperationsCancel_589326 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsOperationsCancel_589328(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsOperationsCancel_589327(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589329 = path.getOrDefault("name")
  valid_589329 = validateParameter(valid_589329, JString, required = true,
                                 default = nil)
  if valid_589329 != nil:
    section.add "name", valid_589329
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
  var valid_589330 = query.getOrDefault("upload_protocol")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "upload_protocol", valid_589330
  var valid_589331 = query.getOrDefault("fields")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "fields", valid_589331
  var valid_589332 = query.getOrDefault("quotaUser")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "quotaUser", valid_589332
  var valid_589333 = query.getOrDefault("alt")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("json"))
  if valid_589333 != nil:
    section.add "alt", valid_589333
  var valid_589334 = query.getOrDefault("oauth_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "oauth_token", valid_589334
  var valid_589335 = query.getOrDefault("callback")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "callback", valid_589335
  var valid_589336 = query.getOrDefault("access_token")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "access_token", valid_589336
  var valid_589337 = query.getOrDefault("uploadType")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "uploadType", valid_589337
  var valid_589338 = query.getOrDefault("key")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "key", valid_589338
  var valid_589339 = query.getOrDefault("$.xgafv")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = newJString("1"))
  if valid_589339 != nil:
    section.add "$.xgafv", valid_589339
  var valid_589340 = query.getOrDefault("prettyPrint")
  valid_589340 = validateParameter(valid_589340, JBool, required = false,
                                 default = newJBool(true))
  if valid_589340 != nil:
    section.add "prettyPrint", valid_589340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589341: Call_DataprocProjectsRegionsOperationsCancel_589326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_589341.validator(path, query, header, formData, body)
  let scheme = call_589341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589341.url(scheme.get, call_589341.host, call_589341.base,
                         call_589341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589341, url, valid)

proc call*(call_589342: Call_DataprocProjectsRegionsOperationsCancel_589326;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589343 = newJObject()
  var query_589344 = newJObject()
  add(query_589344, "upload_protocol", newJString(uploadProtocol))
  add(query_589344, "fields", newJString(fields))
  add(query_589344, "quotaUser", newJString(quotaUser))
  add(path_589343, "name", newJString(name))
  add(query_589344, "alt", newJString(alt))
  add(query_589344, "oauth_token", newJString(oauthToken))
  add(query_589344, "callback", newJString(callback))
  add(query_589344, "access_token", newJString(accessToken))
  add(query_589344, "uploadType", newJString(uploadType))
  add(query_589344, "key", newJString(key))
  add(query_589344, "$.xgafv", newJString(Xgafv))
  add(query_589344, "prettyPrint", newJBool(prettyPrint))
  result = call_589342.call(path_589343, query_589344, nil, nil, nil)

var dataprocProjectsRegionsOperationsCancel* = Call_DataprocProjectsRegionsOperationsCancel_589326(
    name: "dataprocProjectsRegionsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/{name}:cancel",
    validator: validate_DataprocProjectsRegionsOperationsCancel_589327, base: "/",
    url: url_DataprocProjectsRegionsOperationsCancel_589328,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589345 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589347(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":instantiate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589346(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Instantiates a template and begins execution.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.instantiate, the resource name of the template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.instantiate, the resource name  of the template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589348 = path.getOrDefault("name")
  valid_589348 = validateParameter(valid_589348, JString, required = true,
                                 default = nil)
  if valid_589348 != nil:
    section.add "name", valid_589348
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
  var valid_589349 = query.getOrDefault("upload_protocol")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "upload_protocol", valid_589349
  var valid_589350 = query.getOrDefault("fields")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "fields", valid_589350
  var valid_589351 = query.getOrDefault("quotaUser")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "quotaUser", valid_589351
  var valid_589352 = query.getOrDefault("alt")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = newJString("json"))
  if valid_589352 != nil:
    section.add "alt", valid_589352
  var valid_589353 = query.getOrDefault("oauth_token")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "oauth_token", valid_589353
  var valid_589354 = query.getOrDefault("callback")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "callback", valid_589354
  var valid_589355 = query.getOrDefault("access_token")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "access_token", valid_589355
  var valid_589356 = query.getOrDefault("uploadType")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "uploadType", valid_589356
  var valid_589357 = query.getOrDefault("key")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "key", valid_589357
  var valid_589358 = query.getOrDefault("$.xgafv")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = newJString("1"))
  if valid_589358 != nil:
    section.add "$.xgafv", valid_589358
  var valid_589359 = query.getOrDefault("prettyPrint")
  valid_589359 = validateParameter(valid_589359, JBool, required = false,
                                 default = newJBool(true))
  if valid_589359 != nil:
    section.add "prettyPrint", valid_589359
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

proc call*(call_589361: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_589361.validator(path, query, header, formData, body)
  let scheme = call_589361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589361.url(scheme.get, call_589361.host, call_589361.base,
                         call_589361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589361, url, valid)

proc call*(call_589362: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589345;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesInstantiate
  ## Instantiates a template and begins execution.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.instantiate, the resource name of the template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.instantiate, the resource name  of the template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
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
  var path_589363 = newJObject()
  var query_589364 = newJObject()
  var body_589365 = newJObject()
  add(query_589364, "upload_protocol", newJString(uploadProtocol))
  add(query_589364, "fields", newJString(fields))
  add(query_589364, "quotaUser", newJString(quotaUser))
  add(path_589363, "name", newJString(name))
  add(query_589364, "alt", newJString(alt))
  add(query_589364, "oauth_token", newJString(oauthToken))
  add(query_589364, "callback", newJString(callback))
  add(query_589364, "access_token", newJString(accessToken))
  add(query_589364, "uploadType", newJString(uploadType))
  add(query_589364, "key", newJString(key))
  add(query_589364, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589365 = body
  add(query_589364, "prettyPrint", newJBool(prettyPrint))
  result = call_589362.call(path_589363, query_589364, nil, nil, body_589365)

var dataprocProjectsRegionsWorkflowTemplatesInstantiate* = Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589345(
    name: "dataprocProjectsRegionsWorkflowTemplatesInstantiate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}:instantiate",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589346,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesInstantiate_589347,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_589387 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsAutoscalingPoliciesCreate_589389(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autoscalingPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsAutoscalingPoliciesCreate_589388(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates new autoscaling policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The "resource name" of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.create, the resource name  has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.autoscalingPolicies.create, the resource name  has the following format:  projects/{project_id}/locations/{location}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589390 = path.getOrDefault("parent")
  valid_589390 = validateParameter(valid_589390, JString, required = true,
                                 default = nil)
  if valid_589390 != nil:
    section.add "parent", valid_589390
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
  var valid_589391 = query.getOrDefault("upload_protocol")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "upload_protocol", valid_589391
  var valid_589392 = query.getOrDefault("fields")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "fields", valid_589392
  var valid_589393 = query.getOrDefault("quotaUser")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "quotaUser", valid_589393
  var valid_589394 = query.getOrDefault("alt")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = newJString("json"))
  if valid_589394 != nil:
    section.add "alt", valid_589394
  var valid_589395 = query.getOrDefault("oauth_token")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "oauth_token", valid_589395
  var valid_589396 = query.getOrDefault("callback")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "callback", valid_589396
  var valid_589397 = query.getOrDefault("access_token")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "access_token", valid_589397
  var valid_589398 = query.getOrDefault("uploadType")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "uploadType", valid_589398
  var valid_589399 = query.getOrDefault("key")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "key", valid_589399
  var valid_589400 = query.getOrDefault("$.xgafv")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = newJString("1"))
  if valid_589400 != nil:
    section.add "$.xgafv", valid_589400
  var valid_589401 = query.getOrDefault("prettyPrint")
  valid_589401 = validateParameter(valid_589401, JBool, required = false,
                                 default = newJBool(true))
  if valid_589401 != nil:
    section.add "prettyPrint", valid_589401
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

proc call*(call_589403: Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_589387;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new autoscaling policy.
  ## 
  let valid = call_589403.validator(path, query, header, formData, body)
  let scheme = call_589403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589403.url(scheme.get, call_589403.host, call_589403.base,
                         call_589403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589403, url, valid)

proc call*(call_589404: Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_589387;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsAutoscalingPoliciesCreate
  ## Creates new autoscaling policy.
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
  ##   parent: string (required)
  ##         : Required. The "resource name" of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.create, the resource name  has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.autoscalingPolicies.create, the resource name  has the following format:  projects/{project_id}/locations/{location}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589405 = newJObject()
  var query_589406 = newJObject()
  var body_589407 = newJObject()
  add(query_589406, "upload_protocol", newJString(uploadProtocol))
  add(query_589406, "fields", newJString(fields))
  add(query_589406, "quotaUser", newJString(quotaUser))
  add(query_589406, "alt", newJString(alt))
  add(query_589406, "oauth_token", newJString(oauthToken))
  add(query_589406, "callback", newJString(callback))
  add(query_589406, "access_token", newJString(accessToken))
  add(query_589406, "uploadType", newJString(uploadType))
  add(path_589405, "parent", newJString(parent))
  add(query_589406, "key", newJString(key))
  add(query_589406, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589407 = body
  add(query_589406, "prettyPrint", newJBool(prettyPrint))
  result = call_589404.call(path_589405, query_589406, nil, nil, body_589407)

var dataprocProjectsRegionsAutoscalingPoliciesCreate* = Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_589387(
    name: "dataprocProjectsRegionsAutoscalingPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsRegionsAutoscalingPoliciesCreate_589388,
    base: "/", url: url_DataprocProjectsRegionsAutoscalingPoliciesCreate_589389,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsAutoscalingPoliciesList_589366 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsAutoscalingPoliciesList_589368(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autoscalingPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsAutoscalingPoliciesList_589367(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists autoscaling policies in the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The "resource name" of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.list, the resource name  of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.autoscalingPolicies.list, the resource name  of the location has the following format:  projects/{project_id}/locations/{location}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589369 = path.getOrDefault("parent")
  valid_589369 = validateParameter(valid_589369, JString, required = true,
                                 default = nil)
  if valid_589369 != nil:
    section.add "parent", valid_589369
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
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
  ##           : Optional. The maximum number of results to return in each response. Must be less than or equal to 1000. Defaults to 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589370 = query.getOrDefault("upload_protocol")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "upload_protocol", valid_589370
  var valid_589371 = query.getOrDefault("fields")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "fields", valid_589371
  var valid_589372 = query.getOrDefault("pageToken")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "pageToken", valid_589372
  var valid_589373 = query.getOrDefault("quotaUser")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "quotaUser", valid_589373
  var valid_589374 = query.getOrDefault("alt")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = newJString("json"))
  if valid_589374 != nil:
    section.add "alt", valid_589374
  var valid_589375 = query.getOrDefault("oauth_token")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "oauth_token", valid_589375
  var valid_589376 = query.getOrDefault("callback")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "callback", valid_589376
  var valid_589377 = query.getOrDefault("access_token")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "access_token", valid_589377
  var valid_589378 = query.getOrDefault("uploadType")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "uploadType", valid_589378
  var valid_589379 = query.getOrDefault("key")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "key", valid_589379
  var valid_589380 = query.getOrDefault("$.xgafv")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = newJString("1"))
  if valid_589380 != nil:
    section.add "$.xgafv", valid_589380
  var valid_589381 = query.getOrDefault("pageSize")
  valid_589381 = validateParameter(valid_589381, JInt, required = false, default = nil)
  if valid_589381 != nil:
    section.add "pageSize", valid_589381
  var valid_589382 = query.getOrDefault("prettyPrint")
  valid_589382 = validateParameter(valid_589382, JBool, required = false,
                                 default = newJBool(true))
  if valid_589382 != nil:
    section.add "prettyPrint", valid_589382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589383: Call_DataprocProjectsRegionsAutoscalingPoliciesList_589366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists autoscaling policies in the project.
  ## 
  let valid = call_589383.validator(path, query, header, formData, body)
  let scheme = call_589383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589383.url(scheme.get, call_589383.host, call_589383.base,
                         call_589383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589383, url, valid)

proc call*(call_589384: Call_DataprocProjectsRegionsAutoscalingPoliciesList_589366;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsAutoscalingPoliciesList
  ## Lists autoscaling policies in the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
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
  ##   parent: string (required)
  ##         : Required. The "resource name" of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.list, the resource name  of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.autoscalingPolicies.list, the resource name  of the location has the following format:  projects/{project_id}/locations/{location}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return in each response. Must be less than or equal to 1000. Defaults to 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589385 = newJObject()
  var query_589386 = newJObject()
  add(query_589386, "upload_protocol", newJString(uploadProtocol))
  add(query_589386, "fields", newJString(fields))
  add(query_589386, "pageToken", newJString(pageToken))
  add(query_589386, "quotaUser", newJString(quotaUser))
  add(query_589386, "alt", newJString(alt))
  add(query_589386, "oauth_token", newJString(oauthToken))
  add(query_589386, "callback", newJString(callback))
  add(query_589386, "access_token", newJString(accessToken))
  add(query_589386, "uploadType", newJString(uploadType))
  add(path_589385, "parent", newJString(parent))
  add(query_589386, "key", newJString(key))
  add(query_589386, "$.xgafv", newJString(Xgafv))
  add(query_589386, "pageSize", newJInt(pageSize))
  add(query_589386, "prettyPrint", newJBool(prettyPrint))
  result = call_589384.call(path_589385, query_589386, nil, nil, nil)

var dataprocProjectsRegionsAutoscalingPoliciesList* = Call_DataprocProjectsRegionsAutoscalingPoliciesList_589366(
    name: "dataprocProjectsRegionsAutoscalingPoliciesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsRegionsAutoscalingPoliciesList_589367,
    base: "/", url: url_DataprocProjectsRegionsAutoscalingPoliciesList_589368,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesCreate_589429 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesCreate_589431(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/workflowTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesCreate_589430(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates new workflow template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,create, the resource name of the  region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.create, the resource name of  the location has the following format:  projects/{project_id}/locations/{location}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589432 = path.getOrDefault("parent")
  valid_589432 = validateParameter(valid_589432, JString, required = true,
                                 default = nil)
  if valid_589432 != nil:
    section.add "parent", valid_589432
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
  var valid_589433 = query.getOrDefault("upload_protocol")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "upload_protocol", valid_589433
  var valid_589434 = query.getOrDefault("fields")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "fields", valid_589434
  var valid_589435 = query.getOrDefault("quotaUser")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "quotaUser", valid_589435
  var valid_589436 = query.getOrDefault("alt")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = newJString("json"))
  if valid_589436 != nil:
    section.add "alt", valid_589436
  var valid_589437 = query.getOrDefault("oauth_token")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "oauth_token", valid_589437
  var valid_589438 = query.getOrDefault("callback")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "callback", valid_589438
  var valid_589439 = query.getOrDefault("access_token")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "access_token", valid_589439
  var valid_589440 = query.getOrDefault("uploadType")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "uploadType", valid_589440
  var valid_589441 = query.getOrDefault("key")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "key", valid_589441
  var valid_589442 = query.getOrDefault("$.xgafv")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = newJString("1"))
  if valid_589442 != nil:
    section.add "$.xgafv", valid_589442
  var valid_589443 = query.getOrDefault("prettyPrint")
  valid_589443 = validateParameter(valid_589443, JBool, required = false,
                                 default = newJBool(true))
  if valid_589443 != nil:
    section.add "prettyPrint", valid_589443
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

proc call*(call_589445: Call_DataprocProjectsRegionsWorkflowTemplatesCreate_589429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new workflow template.
  ## 
  let valid = call_589445.validator(path, query, header, formData, body)
  let scheme = call_589445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589445.url(scheme.get, call_589445.host, call_589445.base,
                         call_589445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589445, url, valid)

proc call*(call_589446: Call_DataprocProjectsRegionsWorkflowTemplatesCreate_589429;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesCreate
  ## Creates new workflow template.
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
  ##   parent: string (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,create, the resource name of the  region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.create, the resource name of  the location has the following format:  projects/{project_id}/locations/{location}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589447 = newJObject()
  var query_589448 = newJObject()
  var body_589449 = newJObject()
  add(query_589448, "upload_protocol", newJString(uploadProtocol))
  add(query_589448, "fields", newJString(fields))
  add(query_589448, "quotaUser", newJString(quotaUser))
  add(query_589448, "alt", newJString(alt))
  add(query_589448, "oauth_token", newJString(oauthToken))
  add(query_589448, "callback", newJString(callback))
  add(query_589448, "access_token", newJString(accessToken))
  add(query_589448, "uploadType", newJString(uploadType))
  add(path_589447, "parent", newJString(parent))
  add(query_589448, "key", newJString(key))
  add(query_589448, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589449 = body
  add(query_589448, "prettyPrint", newJBool(prettyPrint))
  result = call_589446.call(path_589447, query_589448, nil, nil, body_589449)

var dataprocProjectsRegionsWorkflowTemplatesCreate* = Call_DataprocProjectsRegionsWorkflowTemplatesCreate_589429(
    name: "dataprocProjectsRegionsWorkflowTemplatesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesCreate_589430,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesCreate_589431,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesList_589408 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesList_589410(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/workflowTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesList_589409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists workflows that match the specified filter in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,list, the resource  name of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.list, the  resource name of the location has the following format:  projects/{project_id}/locations/{location}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589411 = path.getOrDefault("parent")
  valid_589411 = validateParameter(valid_589411, JString, required = true,
                                 default = nil)
  if valid_589411 != nil:
    section.add "parent", valid_589411
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
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
  ##           : Optional. The maximum number of results to return in each response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589412 = query.getOrDefault("upload_protocol")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "upload_protocol", valid_589412
  var valid_589413 = query.getOrDefault("fields")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "fields", valid_589413
  var valid_589414 = query.getOrDefault("pageToken")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "pageToken", valid_589414
  var valid_589415 = query.getOrDefault("quotaUser")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "quotaUser", valid_589415
  var valid_589416 = query.getOrDefault("alt")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = newJString("json"))
  if valid_589416 != nil:
    section.add "alt", valid_589416
  var valid_589417 = query.getOrDefault("oauth_token")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "oauth_token", valid_589417
  var valid_589418 = query.getOrDefault("callback")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "callback", valid_589418
  var valid_589419 = query.getOrDefault("access_token")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "access_token", valid_589419
  var valid_589420 = query.getOrDefault("uploadType")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "uploadType", valid_589420
  var valid_589421 = query.getOrDefault("key")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "key", valid_589421
  var valid_589422 = query.getOrDefault("$.xgafv")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = newJString("1"))
  if valid_589422 != nil:
    section.add "$.xgafv", valid_589422
  var valid_589423 = query.getOrDefault("pageSize")
  valid_589423 = validateParameter(valid_589423, JInt, required = false, default = nil)
  if valid_589423 != nil:
    section.add "pageSize", valid_589423
  var valid_589424 = query.getOrDefault("prettyPrint")
  valid_589424 = validateParameter(valid_589424, JBool, required = false,
                                 default = newJBool(true))
  if valid_589424 != nil:
    section.add "prettyPrint", valid_589424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589425: Call_DataprocProjectsRegionsWorkflowTemplatesList_589408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists workflows that match the specified filter in the request.
  ## 
  let valid = call_589425.validator(path, query, header, formData, body)
  let scheme = call_589425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589425.url(scheme.get, call_589425.host, call_589425.base,
                         call_589425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589425, url, valid)

proc call*(call_589426: Call_DataprocProjectsRegionsWorkflowTemplatesList_589408;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesList
  ## Lists workflows that match the specified filter in the request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
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
  ##   parent: string (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,list, the resource  name of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.list, the  resource name of the location has the following format:  projects/{project_id}/locations/{location}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return in each response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589427 = newJObject()
  var query_589428 = newJObject()
  add(query_589428, "upload_protocol", newJString(uploadProtocol))
  add(query_589428, "fields", newJString(fields))
  add(query_589428, "pageToken", newJString(pageToken))
  add(query_589428, "quotaUser", newJString(quotaUser))
  add(query_589428, "alt", newJString(alt))
  add(query_589428, "oauth_token", newJString(oauthToken))
  add(query_589428, "callback", newJString(callback))
  add(query_589428, "access_token", newJString(accessToken))
  add(query_589428, "uploadType", newJString(uploadType))
  add(path_589427, "parent", newJString(parent))
  add(query_589428, "key", newJString(key))
  add(query_589428, "$.xgafv", newJString(Xgafv))
  add(query_589428, "pageSize", newJInt(pageSize))
  add(query_589428, "prettyPrint", newJBool(prettyPrint))
  result = call_589426.call(path_589427, query_589428, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesList* = Call_DataprocProjectsRegionsWorkflowTemplatesList_589408(
    name: "dataprocProjectsRegionsWorkflowTemplatesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesList_589409,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesList_589410,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589450 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589452(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/workflowTemplates:instantiateInline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589451(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Instantiates a template and begins execution.This method is equivalent to executing the sequence CreateWorkflowTemplate, InstantiateWorkflowTemplate, DeleteWorkflowTemplate.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,instantiateinline, the resource  name of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.instantiateinline, the  resource name of the location has the following format:  projects/{project_id}/locations/{location}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589453 = path.getOrDefault("parent")
  valid_589453 = validateParameter(valid_589453, JString, required = true,
                                 default = nil)
  if valid_589453 != nil:
    section.add "parent", valid_589453
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : Optional. A tag that prevents multiple concurrent workflow instances with the same tag from running. This mitigates risk of concurrent instances started due to retries.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The tag must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
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
  ##   instanceId: JString
  ##             : Deprecated. Please use request_id field instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589454 = query.getOrDefault("upload_protocol")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "upload_protocol", valid_589454
  var valid_589455 = query.getOrDefault("fields")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "fields", valid_589455
  var valid_589456 = query.getOrDefault("requestId")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "requestId", valid_589456
  var valid_589457 = query.getOrDefault("quotaUser")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "quotaUser", valid_589457
  var valid_589458 = query.getOrDefault("alt")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = newJString("json"))
  if valid_589458 != nil:
    section.add "alt", valid_589458
  var valid_589459 = query.getOrDefault("oauth_token")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "oauth_token", valid_589459
  var valid_589460 = query.getOrDefault("callback")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "callback", valid_589460
  var valid_589461 = query.getOrDefault("access_token")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "access_token", valid_589461
  var valid_589462 = query.getOrDefault("uploadType")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "uploadType", valid_589462
  var valid_589463 = query.getOrDefault("key")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "key", valid_589463
  var valid_589464 = query.getOrDefault("$.xgafv")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = newJString("1"))
  if valid_589464 != nil:
    section.add "$.xgafv", valid_589464
  var valid_589465 = query.getOrDefault("instanceId")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "instanceId", valid_589465
  var valid_589466 = query.getOrDefault("prettyPrint")
  valid_589466 = validateParameter(valid_589466, JBool, required = false,
                                 default = newJBool(true))
  if valid_589466 != nil:
    section.add "prettyPrint", valid_589466
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

proc call*(call_589468: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.This method is equivalent to executing the sequence CreateWorkflowTemplate, InstantiateWorkflowTemplate, DeleteWorkflowTemplate.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_589468.validator(path, query, header, formData, body)
  let scheme = call_589468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589468.url(scheme.get, call_589468.host, call_589468.base,
                         call_589468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589468, url, valid)

proc call*(call_589469: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589450;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          instanceId: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesInstantiateInline
  ## Instantiates a template and begins execution.This method is equivalent to executing the sequence CreateWorkflowTemplate, InstantiateWorkflowTemplate, DeleteWorkflowTemplate.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : Optional. A tag that prevents multiple concurrent workflow instances with the same tag from running. This mitigates risk of concurrent instances started due to retries.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The tag must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
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
  ##   parent: string (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,instantiateinline, the resource  name of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.instantiateinline, the  resource name of the location has the following format:  projects/{project_id}/locations/{location}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   instanceId: string
  ##             : Deprecated. Please use request_id field instead.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589470 = newJObject()
  var query_589471 = newJObject()
  var body_589472 = newJObject()
  add(query_589471, "upload_protocol", newJString(uploadProtocol))
  add(query_589471, "fields", newJString(fields))
  add(query_589471, "requestId", newJString(requestId))
  add(query_589471, "quotaUser", newJString(quotaUser))
  add(query_589471, "alt", newJString(alt))
  add(query_589471, "oauth_token", newJString(oauthToken))
  add(query_589471, "callback", newJString(callback))
  add(query_589471, "access_token", newJString(accessToken))
  add(query_589471, "uploadType", newJString(uploadType))
  add(path_589470, "parent", newJString(parent))
  add(query_589471, "key", newJString(key))
  add(query_589471, "$.xgafv", newJString(Xgafv))
  add(query_589471, "instanceId", newJString(instanceId))
  if body != nil:
    body_589472 = body
  add(query_589471, "prettyPrint", newJBool(prettyPrint))
  result = call_589469.call(path_589470, query_589471, nil, nil, body_589472)

var dataprocProjectsRegionsWorkflowTemplatesInstantiateInline* = Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589450(
    name: "dataprocProjectsRegionsWorkflowTemplatesInstantiateInline",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates:instantiateInline", validator: validate_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589451,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_589452,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589473 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589475(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589474(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource. Returns an empty policy if the resource exists and does not have a policy set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested. See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589476 = path.getOrDefault("resource")
  valid_589476 = validateParameter(valid_589476, JString, required = true,
                                 default = nil)
  if valid_589476 != nil:
    section.add "resource", valid_589476
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.Valid values are 0, 1, and 3. Requests specifying an invalid value will be rejected.Requests for policies with any conditional bindings must specify version 3. Policies without any conditional bindings may specify any valid value or leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589477 = query.getOrDefault("upload_protocol")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "upload_protocol", valid_589477
  var valid_589478 = query.getOrDefault("fields")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "fields", valid_589478
  var valid_589479 = query.getOrDefault("quotaUser")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "quotaUser", valid_589479
  var valid_589480 = query.getOrDefault("alt")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = newJString("json"))
  if valid_589480 != nil:
    section.add "alt", valid_589480
  var valid_589481 = query.getOrDefault("oauth_token")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "oauth_token", valid_589481
  var valid_589482 = query.getOrDefault("callback")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "callback", valid_589482
  var valid_589483 = query.getOrDefault("access_token")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "access_token", valid_589483
  var valid_589484 = query.getOrDefault("uploadType")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "uploadType", valid_589484
  var valid_589485 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589485 = validateParameter(valid_589485, JInt, required = false, default = nil)
  if valid_589485 != nil:
    section.add "options.requestedPolicyVersion", valid_589485
  var valid_589486 = query.getOrDefault("key")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "key", valid_589486
  var valid_589487 = query.getOrDefault("$.xgafv")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = newJString("1"))
  if valid_589487 != nil:
    section.add "$.xgafv", valid_589487
  var valid_589488 = query.getOrDefault("prettyPrint")
  valid_589488 = validateParameter(valid_589488, JBool, required = false,
                                 default = newJBool(true))
  if valid_589488 != nil:
    section.add "prettyPrint", valid_589488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589489: Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589473;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. Returns an empty policy if the resource exists and does not have a policy set.
  ## 
  let valid = call_589489.validator(path, query, header, formData, body)
  let scheme = call_589489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589489.url(scheme.get, call_589489.host, call_589489.base,
                         call_589489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589489, url, valid)

proc call*(call_589490: Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589473;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesGetIamPolicy
  ## Gets the access control policy for a resource. Returns an empty policy if the resource exists and does not have a policy set.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.Valid values are 0, 1, and 3. Requests specifying an invalid value will be rejected.Requests for policies with any conditional bindings must specify version 3. Policies without any conditional bindings may specify any valid value or leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested. See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589491 = newJObject()
  var query_589492 = newJObject()
  add(query_589492, "upload_protocol", newJString(uploadProtocol))
  add(query_589492, "fields", newJString(fields))
  add(query_589492, "quotaUser", newJString(quotaUser))
  add(query_589492, "alt", newJString(alt))
  add(query_589492, "oauth_token", newJString(oauthToken))
  add(query_589492, "callback", newJString(callback))
  add(query_589492, "access_token", newJString(accessToken))
  add(query_589492, "uploadType", newJString(uploadType))
  add(query_589492, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589492, "key", newJString(key))
  add(query_589492, "$.xgafv", newJString(Xgafv))
  add(path_589491, "resource", newJString(resource))
  add(query_589492, "prettyPrint", newJBool(prettyPrint))
  result = call_589490.call(path_589491, query_589492, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesGetIamPolicy* = Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589473(
    name: "dataprocProjectsRegionsWorkflowTemplatesGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:getIamPolicy",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589474,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_589475,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589493 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589495(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589494(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified. See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589496 = path.getOrDefault("resource")
  valid_589496 = validateParameter(valid_589496, JString, required = true,
                                 default = nil)
  if valid_589496 != nil:
    section.add "resource", valid_589496
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
  var valid_589497 = query.getOrDefault("upload_protocol")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "upload_protocol", valid_589497
  var valid_589498 = query.getOrDefault("fields")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "fields", valid_589498
  var valid_589499 = query.getOrDefault("quotaUser")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "quotaUser", valid_589499
  var valid_589500 = query.getOrDefault("alt")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = newJString("json"))
  if valid_589500 != nil:
    section.add "alt", valid_589500
  var valid_589501 = query.getOrDefault("oauth_token")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "oauth_token", valid_589501
  var valid_589502 = query.getOrDefault("callback")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "callback", valid_589502
  var valid_589503 = query.getOrDefault("access_token")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "access_token", valid_589503
  var valid_589504 = query.getOrDefault("uploadType")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "uploadType", valid_589504
  var valid_589505 = query.getOrDefault("key")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "key", valid_589505
  var valid_589506 = query.getOrDefault("$.xgafv")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = newJString("1"))
  if valid_589506 != nil:
    section.add "$.xgafv", valid_589506
  var valid_589507 = query.getOrDefault("prettyPrint")
  valid_589507 = validateParameter(valid_589507, JBool, required = false,
                                 default = newJBool(true))
  if valid_589507 != nil:
    section.add "prettyPrint", valid_589507
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

proc call*(call_589509: Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_589509.validator(path, query, header, formData, body)
  let scheme = call_589509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589509.url(scheme.get, call_589509.host, call_589509.base,
                         call_589509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589509, url, valid)

proc call*(call_589510: Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589493;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified. See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589511 = newJObject()
  var query_589512 = newJObject()
  var body_589513 = newJObject()
  add(query_589512, "upload_protocol", newJString(uploadProtocol))
  add(query_589512, "fields", newJString(fields))
  add(query_589512, "quotaUser", newJString(quotaUser))
  add(query_589512, "alt", newJString(alt))
  add(query_589512, "oauth_token", newJString(oauthToken))
  add(query_589512, "callback", newJString(callback))
  add(query_589512, "access_token", newJString(accessToken))
  add(query_589512, "uploadType", newJString(uploadType))
  add(query_589512, "key", newJString(key))
  add(query_589512, "$.xgafv", newJString(Xgafv))
  add(path_589511, "resource", newJString(resource))
  if body != nil:
    body_589513 = body
  add(query_589512, "prettyPrint", newJBool(prettyPrint))
  result = call_589510.call(path_589511, query_589512, nil, nil, body_589513)

var dataprocProjectsRegionsWorkflowTemplatesSetIamPolicy* = Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589493(
    name: "dataprocProjectsRegionsWorkflowTemplatesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:setIamPolicy",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589494,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_589495,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589514 = ref object of OpenApiRestCall_588450
proc url_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589516(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589515(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource. If the resource does not exist, this will return an empty set of permissions, not a NOT_FOUND error.Note: This operation is designed to be used for building permission-aware UIs and command-line tools, not for authorization checking. This operation may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested. See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589517 = path.getOrDefault("resource")
  valid_589517 = validateParameter(valid_589517, JString, required = true,
                                 default = nil)
  if valid_589517 != nil:
    section.add "resource", valid_589517
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
  var valid_589518 = query.getOrDefault("upload_protocol")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "upload_protocol", valid_589518
  var valid_589519 = query.getOrDefault("fields")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "fields", valid_589519
  var valid_589520 = query.getOrDefault("quotaUser")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "quotaUser", valid_589520
  var valid_589521 = query.getOrDefault("alt")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = newJString("json"))
  if valid_589521 != nil:
    section.add "alt", valid_589521
  var valid_589522 = query.getOrDefault("oauth_token")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "oauth_token", valid_589522
  var valid_589523 = query.getOrDefault("callback")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "callback", valid_589523
  var valid_589524 = query.getOrDefault("access_token")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "access_token", valid_589524
  var valid_589525 = query.getOrDefault("uploadType")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "uploadType", valid_589525
  var valid_589526 = query.getOrDefault("key")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "key", valid_589526
  var valid_589527 = query.getOrDefault("$.xgafv")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = newJString("1"))
  if valid_589527 != nil:
    section.add "$.xgafv", valid_589527
  var valid_589528 = query.getOrDefault("prettyPrint")
  valid_589528 = validateParameter(valid_589528, JBool, required = false,
                                 default = newJBool(true))
  if valid_589528 != nil:
    section.add "prettyPrint", valid_589528
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

proc call*(call_589530: Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589514;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource. If the resource does not exist, this will return an empty set of permissions, not a NOT_FOUND error.Note: This operation is designed to be used for building permission-aware UIs and command-line tools, not for authorization checking. This operation may "fail open" without warning.
  ## 
  let valid = call_589530.validator(path, query, header, formData, body)
  let scheme = call_589530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589530.url(scheme.get, call_589530.host, call_589530.base,
                         call_589530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589530, url, valid)

proc call*(call_589531: Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589514;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesTestIamPermissions
  ## Returns permissions that a caller has on the specified resource. If the resource does not exist, this will return an empty set of permissions, not a NOT_FOUND error.Note: This operation is designed to be used for building permission-aware UIs and command-line tools, not for authorization checking. This operation may "fail open" without warning.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested. See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589532 = newJObject()
  var query_589533 = newJObject()
  var body_589534 = newJObject()
  add(query_589533, "upload_protocol", newJString(uploadProtocol))
  add(query_589533, "fields", newJString(fields))
  add(query_589533, "quotaUser", newJString(quotaUser))
  add(query_589533, "alt", newJString(alt))
  add(query_589533, "oauth_token", newJString(oauthToken))
  add(query_589533, "callback", newJString(callback))
  add(query_589533, "access_token", newJString(accessToken))
  add(query_589533, "uploadType", newJString(uploadType))
  add(query_589533, "key", newJString(key))
  add(query_589533, "$.xgafv", newJString(Xgafv))
  add(path_589532, "resource", newJString(resource))
  if body != nil:
    body_589534 = body
  add(query_589533, "prettyPrint", newJBool(prettyPrint))
  result = call_589531.call(path_589532, query_589533, nil, nil, body_589534)

var dataprocProjectsRegionsWorkflowTemplatesTestIamPermissions* = Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589514(
    name: "dataprocProjectsRegionsWorkflowTemplatesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:testIamPermissions", validator: validate_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589515,
    base: "/",
    url: url_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_589516,
    schemes: {Scheme.Https})
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
