
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "dataproc"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataprocProjectsRegionsClustersCreate_579982 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsClustersCreate_579984(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersCreate_579983(path: JsonNode;
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
  var valid_579985 = path.getOrDefault("projectId")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "projectId", valid_579985
  var valid_579986 = path.getOrDefault("region")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "region", valid_579986
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
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  var valid_579989 = query.getOrDefault("requestId")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "requestId", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
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

proc call*(call_580000: Call_DataprocProjectsRegionsClustersCreate_579982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_DataprocProjectsRegionsClustersCreate_579982;
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
  var path_580002 = newJObject()
  var query_580003 = newJObject()
  var body_580004 = newJObject()
  add(query_580003, "upload_protocol", newJString(uploadProtocol))
  add(query_580003, "fields", newJString(fields))
  add(query_580003, "requestId", newJString(requestId))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "callback", newJString(callback))
  add(query_580003, "access_token", newJString(accessToken))
  add(query_580003, "uploadType", newJString(uploadType))
  add(query_580003, "key", newJString(key))
  add(path_580002, "projectId", newJString(projectId))
  add(query_580003, "$.xgafv", newJString(Xgafv))
  add(path_580002, "region", newJString(region))
  if body != nil:
    body_580004 = body
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  result = call_580001.call(path_580002, query_580003, nil, nil, body_580004)

var dataprocProjectsRegionsClustersCreate* = Call_DataprocProjectsRegionsClustersCreate_579982(
    name: "dataprocProjectsRegionsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersCreate_579983, base: "/",
    url: url_DataprocProjectsRegionsClustersCreate_579984, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersList_579690 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsClustersList_579692(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersList_579691(path: JsonNode;
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
  var valid_579818 = path.getOrDefault("projectId")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "projectId", valid_579818
  var valid_579819 = path.getOrDefault("region")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "region", valid_579819
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
  var valid_579820 = query.getOrDefault("upload_protocol")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "upload_protocol", valid_579820
  var valid_579821 = query.getOrDefault("fields")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "fields", valid_579821
  var valid_579822 = query.getOrDefault("pageToken")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "pageToken", valid_579822
  var valid_579823 = query.getOrDefault("quotaUser")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "quotaUser", valid_579823
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("callback")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "callback", valid_579839
  var valid_579840 = query.getOrDefault("access_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "access_token", valid_579840
  var valid_579841 = query.getOrDefault("uploadType")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "uploadType", valid_579841
  var valid_579842 = query.getOrDefault("key")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "key", valid_579842
  var valid_579843 = query.getOrDefault("$.xgafv")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = newJString("1"))
  if valid_579843 != nil:
    section.add "$.xgafv", valid_579843
  var valid_579844 = query.getOrDefault("pageSize")
  valid_579844 = validateParameter(valid_579844, JInt, required = false, default = nil)
  if valid_579844 != nil:
    section.add "pageSize", valid_579844
  var valid_579845 = query.getOrDefault("prettyPrint")
  valid_579845 = validateParameter(valid_579845, JBool, required = false,
                                 default = newJBool(true))
  if valid_579845 != nil:
    section.add "prettyPrint", valid_579845
  var valid_579846 = query.getOrDefault("filter")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "filter", valid_579846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579869: Call_DataprocProjectsRegionsClustersList_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all regions/{region}/clusters in a project.
  ## 
  let valid = call_579869.validator(path, query, header, formData, body)
  let scheme = call_579869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579869.url(scheme.get, call_579869.host, call_579869.base,
                         call_579869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579869, url, valid)

proc call*(call_579940: Call_DataprocProjectsRegionsClustersList_579690;
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
  var path_579941 = newJObject()
  var query_579943 = newJObject()
  add(query_579943, "upload_protocol", newJString(uploadProtocol))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "pageToken", newJString(pageToken))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "callback", newJString(callback))
  add(query_579943, "access_token", newJString(accessToken))
  add(query_579943, "uploadType", newJString(uploadType))
  add(query_579943, "key", newJString(key))
  add(path_579941, "projectId", newJString(projectId))
  add(query_579943, "$.xgafv", newJString(Xgafv))
  add(path_579941, "region", newJString(region))
  add(query_579943, "pageSize", newJInt(pageSize))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "filter", newJString(filter))
  result = call_579940.call(path_579941, query_579943, nil, nil, nil)

var dataprocProjectsRegionsClustersList* = Call_DataprocProjectsRegionsClustersList_579690(
    name: "dataprocProjectsRegionsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersList_579691, base: "/",
    url: url_DataprocProjectsRegionsClustersList_579692, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersGet_580005 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsClustersGet_580007(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersGet_580006(path: JsonNode;
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
  var valid_580008 = path.getOrDefault("clusterName")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "clusterName", valid_580008
  var valid_580009 = path.getOrDefault("projectId")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "projectId", valid_580009
  var valid_580010 = path.getOrDefault("region")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "region", valid_580010
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
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("uploadType")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "uploadType", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_DataprocProjectsRegionsClustersGet_580005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_DataprocProjectsRegionsClustersGet_580005;
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(path_580024, "clusterName", newJString(clusterName))
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "callback", newJString(callback))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "uploadType", newJString(uploadType))
  add(query_580025, "key", newJString(key))
  add(path_580024, "projectId", newJString(projectId))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  add(path_580024, "region", newJString(region))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var dataprocProjectsRegionsClustersGet* = Call_DataprocProjectsRegionsClustersGet_580005(
    name: "dataprocProjectsRegionsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersGet_580006, base: "/",
    url: url_DataprocProjectsRegionsClustersGet_580007, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersPatch_580049 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsClustersPatch_580051(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersPatch_580050(path: JsonNode;
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
  var valid_580052 = path.getOrDefault("clusterName")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "clusterName", valid_580052
  var valid_580053 = path.getOrDefault("projectId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "projectId", valid_580053
  var valid_580054 = path.getOrDefault("region")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "region", valid_580054
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
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("requestId")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "requestId", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("callback")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "callback", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("uploadType")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "uploadType", valid_580063
  var valid_580064 = query.getOrDefault("gracefulDecommissionTimeout")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "gracefulDecommissionTimeout", valid_580064
  var valid_580065 = query.getOrDefault("key")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "key", valid_580065
  var valid_580066 = query.getOrDefault("$.xgafv")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("1"))
  if valid_580066 != nil:
    section.add "$.xgafv", valid_580066
  var valid_580067 = query.getOrDefault("prettyPrint")
  valid_580067 = validateParameter(valid_580067, JBool, required = false,
                                 default = newJBool(true))
  if valid_580067 != nil:
    section.add "prettyPrint", valid_580067
  var valid_580068 = query.getOrDefault("updateMask")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "updateMask", valid_580068
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

proc call*(call_580070: Call_DataprocProjectsRegionsClustersPatch_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_DataprocProjectsRegionsClustersPatch_580049;
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
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  var body_580074 = newJObject()
  add(path_580072, "clusterName", newJString(clusterName))
  add(query_580073, "upload_protocol", newJString(uploadProtocol))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "requestId", newJString(requestId))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "callback", newJString(callback))
  add(query_580073, "access_token", newJString(accessToken))
  add(query_580073, "uploadType", newJString(uploadType))
  add(query_580073, "gracefulDecommissionTimeout",
      newJString(gracefulDecommissionTimeout))
  add(query_580073, "key", newJString(key))
  add(path_580072, "projectId", newJString(projectId))
  add(query_580073, "$.xgafv", newJString(Xgafv))
  add(path_580072, "region", newJString(region))
  if body != nil:
    body_580074 = body
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  add(query_580073, "updateMask", newJString(updateMask))
  result = call_580071.call(path_580072, query_580073, nil, nil, body_580074)

var dataprocProjectsRegionsClustersPatch* = Call_DataprocProjectsRegionsClustersPatch_580049(
    name: "dataprocProjectsRegionsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersPatch_580050, base: "/",
    url: url_DataprocProjectsRegionsClustersPatch_580051, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDelete_580026 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsClustersDelete_580028(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersDelete_580027(path: JsonNode;
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
  var valid_580029 = path.getOrDefault("clusterName")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "clusterName", valid_580029
  var valid_580030 = path.getOrDefault("projectId")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "projectId", valid_580030
  var valid_580031 = path.getOrDefault("region")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "region", valid_580031
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
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("requestId")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "requestId", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("clusterUuid")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "clusterUuid", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("access_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "access_token", valid_580040
  var valid_580041 = query.getOrDefault("uploadType")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "uploadType", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("$.xgafv")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("1"))
  if valid_580043 != nil:
    section.add "$.xgafv", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580045: Call_DataprocProjectsRegionsClustersDelete_580026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_DataprocProjectsRegionsClustersDelete_580026;
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
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  add(path_580047, "clusterName", newJString(clusterName))
  add(query_580048, "upload_protocol", newJString(uploadProtocol))
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "requestId", newJString(requestId))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "clusterUuid", newJString(clusterUuid))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "callback", newJString(callback))
  add(query_580048, "access_token", newJString(accessToken))
  add(query_580048, "uploadType", newJString(uploadType))
  add(query_580048, "key", newJString(key))
  add(path_580047, "projectId", newJString(projectId))
  add(query_580048, "$.xgafv", newJString(Xgafv))
  add(path_580047, "region", newJString(region))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  result = call_580046.call(path_580047, query_580048, nil, nil, nil)

var dataprocProjectsRegionsClustersDelete* = Call_DataprocProjectsRegionsClustersDelete_580026(
    name: "dataprocProjectsRegionsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersDelete_580027, base: "/",
    url: url_DataprocProjectsRegionsClustersDelete_580028, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDiagnose_580075 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsClustersDiagnose_580077(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersDiagnose_580076(path: JsonNode;
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
  var valid_580078 = path.getOrDefault("clusterName")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "clusterName", valid_580078
  var valid_580079 = path.getOrDefault("projectId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "projectId", valid_580079
  var valid_580080 = path.getOrDefault("region")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "region", valid_580080
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
  var valid_580081 = query.getOrDefault("upload_protocol")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "upload_protocol", valid_580081
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("oauth_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "oauth_token", valid_580085
  var valid_580086 = query.getOrDefault("callback")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "callback", valid_580086
  var valid_580087 = query.getOrDefault("access_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "access_token", valid_580087
  var valid_580088 = query.getOrDefault("uploadType")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "uploadType", valid_580088
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("$.xgafv")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("1"))
  if valid_580090 != nil:
    section.add "$.xgafv", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
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

proc call*(call_580093: Call_DataprocProjectsRegionsClustersDiagnose_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. The returned Operation.metadata will be ClusterOperationMetadata. After the operation completes, Operation.response contains DiagnoseClusterResults.
  ## 
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_DataprocProjectsRegionsClustersDiagnose_580075;
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
  var path_580095 = newJObject()
  var query_580096 = newJObject()
  var body_580097 = newJObject()
  add(path_580095, "clusterName", newJString(clusterName))
  add(query_580096, "upload_protocol", newJString(uploadProtocol))
  add(query_580096, "fields", newJString(fields))
  add(query_580096, "quotaUser", newJString(quotaUser))
  add(query_580096, "alt", newJString(alt))
  add(query_580096, "oauth_token", newJString(oauthToken))
  add(query_580096, "callback", newJString(callback))
  add(query_580096, "access_token", newJString(accessToken))
  add(query_580096, "uploadType", newJString(uploadType))
  add(query_580096, "key", newJString(key))
  add(path_580095, "projectId", newJString(projectId))
  add(query_580096, "$.xgafv", newJString(Xgafv))
  add(path_580095, "region", newJString(region))
  if body != nil:
    body_580097 = body
  add(query_580096, "prettyPrint", newJBool(prettyPrint))
  result = call_580094.call(path_580095, query_580096, nil, nil, body_580097)

var dataprocProjectsRegionsClustersDiagnose* = Call_DataprocProjectsRegionsClustersDiagnose_580075(
    name: "dataprocProjectsRegionsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsRegionsClustersDiagnose_580076, base: "/",
    url: url_DataprocProjectsRegionsClustersDiagnose_580077,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsList_580098 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsJobsList_580100(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsList_580099(path: JsonNode;
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
  var valid_580101 = path.getOrDefault("projectId")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "projectId", valid_580101
  var valid_580102 = path.getOrDefault("region")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "region", valid_580102
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
  var valid_580103 = query.getOrDefault("upload_protocol")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "upload_protocol", valid_580103
  var valid_580104 = query.getOrDefault("fields")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "fields", valid_580104
  var valid_580105 = query.getOrDefault("pageToken")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "pageToken", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("callback")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "callback", valid_580109
  var valid_580110 = query.getOrDefault("access_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "access_token", valid_580110
  var valid_580111 = query.getOrDefault("uploadType")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "uploadType", valid_580111
  var valid_580112 = query.getOrDefault("jobStateMatcher")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("ALL"))
  if valid_580112 != nil:
    section.add "jobStateMatcher", valid_580112
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("$.xgafv")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("1"))
  if valid_580114 != nil:
    section.add "$.xgafv", valid_580114
  var valid_580115 = query.getOrDefault("pageSize")
  valid_580115 = validateParameter(valid_580115, JInt, required = false, default = nil)
  if valid_580115 != nil:
    section.add "pageSize", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
  var valid_580117 = query.getOrDefault("filter")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "filter", valid_580117
  var valid_580118 = query.getOrDefault("clusterName")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "clusterName", valid_580118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580119: Call_DataprocProjectsRegionsJobsList_580098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists regions/{region}/jobs in a project.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_DataprocProjectsRegionsJobsList_580098;
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
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  add(query_580122, "upload_protocol", newJString(uploadProtocol))
  add(query_580122, "fields", newJString(fields))
  add(query_580122, "pageToken", newJString(pageToken))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "callback", newJString(callback))
  add(query_580122, "access_token", newJString(accessToken))
  add(query_580122, "uploadType", newJString(uploadType))
  add(query_580122, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_580122, "key", newJString(key))
  add(path_580121, "projectId", newJString(projectId))
  add(query_580122, "$.xgafv", newJString(Xgafv))
  add(path_580121, "region", newJString(region))
  add(query_580122, "pageSize", newJInt(pageSize))
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  add(query_580122, "filter", newJString(filter))
  add(query_580122, "clusterName", newJString(clusterName))
  result = call_580120.call(path_580121, query_580122, nil, nil, nil)

var dataprocProjectsRegionsJobsList* = Call_DataprocProjectsRegionsJobsList_580098(
    name: "dataprocProjectsRegionsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs",
    validator: validate_DataprocProjectsRegionsJobsList_580099, base: "/",
    url: url_DataprocProjectsRegionsJobsList_580100, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsGet_580123 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsJobsGet_580125(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsGet_580124(path: JsonNode;
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
  var valid_580126 = path.getOrDefault("jobId")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "jobId", valid_580126
  var valid_580127 = path.getOrDefault("projectId")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "projectId", valid_580127
  var valid_580128 = path.getOrDefault("region")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "region", valid_580128
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
  var valid_580129 = query.getOrDefault("upload_protocol")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "upload_protocol", valid_580129
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("quotaUser")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "quotaUser", valid_580131
  var valid_580132 = query.getOrDefault("alt")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("json"))
  if valid_580132 != nil:
    section.add "alt", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("callback")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "callback", valid_580134
  var valid_580135 = query.getOrDefault("access_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "access_token", valid_580135
  var valid_580136 = query.getOrDefault("uploadType")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "uploadType", valid_580136
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("$.xgafv")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("1"))
  if valid_580138 != nil:
    section.add "$.xgafv", valid_580138
  var valid_580139 = query.getOrDefault("prettyPrint")
  valid_580139 = validateParameter(valid_580139, JBool, required = false,
                                 default = newJBool(true))
  if valid_580139 != nil:
    section.add "prettyPrint", valid_580139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580140: Call_DataprocProjectsRegionsJobsGet_580123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_580140.validator(path, query, header, formData, body)
  let scheme = call_580140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580140.url(scheme.get, call_580140.host, call_580140.base,
                         call_580140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580140, url, valid)

proc call*(call_580141: Call_DataprocProjectsRegionsJobsGet_580123; jobId: string;
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
  var path_580142 = newJObject()
  var query_580143 = newJObject()
  add(query_580143, "upload_protocol", newJString(uploadProtocol))
  add(query_580143, "fields", newJString(fields))
  add(query_580143, "quotaUser", newJString(quotaUser))
  add(query_580143, "alt", newJString(alt))
  add(path_580142, "jobId", newJString(jobId))
  add(query_580143, "oauth_token", newJString(oauthToken))
  add(query_580143, "callback", newJString(callback))
  add(query_580143, "access_token", newJString(accessToken))
  add(query_580143, "uploadType", newJString(uploadType))
  add(query_580143, "key", newJString(key))
  add(path_580142, "projectId", newJString(projectId))
  add(query_580143, "$.xgafv", newJString(Xgafv))
  add(path_580142, "region", newJString(region))
  add(query_580143, "prettyPrint", newJBool(prettyPrint))
  result = call_580141.call(path_580142, query_580143, nil, nil, nil)

var dataprocProjectsRegionsJobsGet* = Call_DataprocProjectsRegionsJobsGet_580123(
    name: "dataprocProjectsRegionsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsGet_580124, base: "/",
    url: url_DataprocProjectsRegionsJobsGet_580125, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsPatch_580165 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsJobsPatch_580167(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsPatch_580166(path: JsonNode;
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
  var valid_580168 = path.getOrDefault("jobId")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "jobId", valid_580168
  var valid_580169 = path.getOrDefault("projectId")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "projectId", valid_580169
  var valid_580170 = path.getOrDefault("region")
  valid_580170 = validateParameter(valid_580170, JString, required = true,
                                 default = nil)
  if valid_580170 != nil:
    section.add "region", valid_580170
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
  var valid_580171 = query.getOrDefault("upload_protocol")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "upload_protocol", valid_580171
  var valid_580172 = query.getOrDefault("fields")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "fields", valid_580172
  var valid_580173 = query.getOrDefault("quotaUser")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "quotaUser", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("oauth_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "oauth_token", valid_580175
  var valid_580176 = query.getOrDefault("callback")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "callback", valid_580176
  var valid_580177 = query.getOrDefault("access_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "access_token", valid_580177
  var valid_580178 = query.getOrDefault("uploadType")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "uploadType", valid_580178
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("$.xgafv")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("1"))
  if valid_580180 != nil:
    section.add "$.xgafv", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  var valid_580182 = query.getOrDefault("updateMask")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "updateMask", valid_580182
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

proc call*(call_580184: Call_DataprocProjectsRegionsJobsPatch_580165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_580184.validator(path, query, header, formData, body)
  let scheme = call_580184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580184.url(scheme.get, call_580184.host, call_580184.base,
                         call_580184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580184, url, valid)

proc call*(call_580185: Call_DataprocProjectsRegionsJobsPatch_580165;
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
  var path_580186 = newJObject()
  var query_580187 = newJObject()
  var body_580188 = newJObject()
  add(query_580187, "upload_protocol", newJString(uploadProtocol))
  add(query_580187, "fields", newJString(fields))
  add(query_580187, "quotaUser", newJString(quotaUser))
  add(query_580187, "alt", newJString(alt))
  add(path_580186, "jobId", newJString(jobId))
  add(query_580187, "oauth_token", newJString(oauthToken))
  add(query_580187, "callback", newJString(callback))
  add(query_580187, "access_token", newJString(accessToken))
  add(query_580187, "uploadType", newJString(uploadType))
  add(query_580187, "key", newJString(key))
  add(path_580186, "projectId", newJString(projectId))
  add(query_580187, "$.xgafv", newJString(Xgafv))
  add(path_580186, "region", newJString(region))
  if body != nil:
    body_580188 = body
  add(query_580187, "prettyPrint", newJBool(prettyPrint))
  add(query_580187, "updateMask", newJString(updateMask))
  result = call_580185.call(path_580186, query_580187, nil, nil, body_580188)

var dataprocProjectsRegionsJobsPatch* = Call_DataprocProjectsRegionsJobsPatch_580165(
    name: "dataprocProjectsRegionsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsPatch_580166, base: "/",
    url: url_DataprocProjectsRegionsJobsPatch_580167, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsDelete_580144 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsJobsDelete_580146(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsDelete_580145(path: JsonNode;
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
  var valid_580147 = path.getOrDefault("jobId")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "jobId", valid_580147
  var valid_580148 = path.getOrDefault("projectId")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "projectId", valid_580148
  var valid_580149 = path.getOrDefault("region")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "region", valid_580149
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
  var valid_580150 = query.getOrDefault("upload_protocol")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "upload_protocol", valid_580150
  var valid_580151 = query.getOrDefault("fields")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fields", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("oauth_token")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "oauth_token", valid_580154
  var valid_580155 = query.getOrDefault("callback")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "callback", valid_580155
  var valid_580156 = query.getOrDefault("access_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "access_token", valid_580156
  var valid_580157 = query.getOrDefault("uploadType")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "uploadType", valid_580157
  var valid_580158 = query.getOrDefault("key")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "key", valid_580158
  var valid_580159 = query.getOrDefault("$.xgafv")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("1"))
  if valid_580159 != nil:
    section.add "$.xgafv", valid_580159
  var valid_580160 = query.getOrDefault("prettyPrint")
  valid_580160 = validateParameter(valid_580160, JBool, required = false,
                                 default = newJBool(true))
  if valid_580160 != nil:
    section.add "prettyPrint", valid_580160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580161: Call_DataprocProjectsRegionsJobsDelete_580144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_580161.validator(path, query, header, formData, body)
  let scheme = call_580161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580161.url(scheme.get, call_580161.host, call_580161.base,
                         call_580161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580161, url, valid)

proc call*(call_580162: Call_DataprocProjectsRegionsJobsDelete_580144;
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
  var path_580163 = newJObject()
  var query_580164 = newJObject()
  add(query_580164, "upload_protocol", newJString(uploadProtocol))
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "alt", newJString(alt))
  add(path_580163, "jobId", newJString(jobId))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "callback", newJString(callback))
  add(query_580164, "access_token", newJString(accessToken))
  add(query_580164, "uploadType", newJString(uploadType))
  add(query_580164, "key", newJString(key))
  add(path_580163, "projectId", newJString(projectId))
  add(query_580164, "$.xgafv", newJString(Xgafv))
  add(path_580163, "region", newJString(region))
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  result = call_580162.call(path_580163, query_580164, nil, nil, nil)

var dataprocProjectsRegionsJobsDelete* = Call_DataprocProjectsRegionsJobsDelete_580144(
    name: "dataprocProjectsRegionsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsDelete_580145, base: "/",
    url: url_DataprocProjectsRegionsJobsDelete_580146, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsCancel_580189 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsJobsCancel_580191(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsCancel_580190(path: JsonNode;
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
  var valid_580192 = path.getOrDefault("jobId")
  valid_580192 = validateParameter(valid_580192, JString, required = true,
                                 default = nil)
  if valid_580192 != nil:
    section.add "jobId", valid_580192
  var valid_580193 = path.getOrDefault("projectId")
  valid_580193 = validateParameter(valid_580193, JString, required = true,
                                 default = nil)
  if valid_580193 != nil:
    section.add "projectId", valid_580193
  var valid_580194 = path.getOrDefault("region")
  valid_580194 = validateParameter(valid_580194, JString, required = true,
                                 default = nil)
  if valid_580194 != nil:
    section.add "region", valid_580194
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
  var valid_580195 = query.getOrDefault("upload_protocol")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "upload_protocol", valid_580195
  var valid_580196 = query.getOrDefault("fields")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "fields", valid_580196
  var valid_580197 = query.getOrDefault("quotaUser")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "quotaUser", valid_580197
  var valid_580198 = query.getOrDefault("alt")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("json"))
  if valid_580198 != nil:
    section.add "alt", valid_580198
  var valid_580199 = query.getOrDefault("oauth_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "oauth_token", valid_580199
  var valid_580200 = query.getOrDefault("callback")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "callback", valid_580200
  var valid_580201 = query.getOrDefault("access_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "access_token", valid_580201
  var valid_580202 = query.getOrDefault("uploadType")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "uploadType", valid_580202
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("$.xgafv")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("1"))
  if valid_580204 != nil:
    section.add "$.xgafv", valid_580204
  var valid_580205 = query.getOrDefault("prettyPrint")
  valid_580205 = validateParameter(valid_580205, JBool, required = false,
                                 default = newJBool(true))
  if valid_580205 != nil:
    section.add "prettyPrint", valid_580205
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

proc call*(call_580207: Call_DataprocProjectsRegionsJobsCancel_580189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ## 
  let valid = call_580207.validator(path, query, header, formData, body)
  let scheme = call_580207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580207.url(scheme.get, call_580207.host, call_580207.base,
                         call_580207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580207, url, valid)

proc call*(call_580208: Call_DataprocProjectsRegionsJobsCancel_580189;
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
  var path_580209 = newJObject()
  var query_580210 = newJObject()
  var body_580211 = newJObject()
  add(query_580210, "upload_protocol", newJString(uploadProtocol))
  add(query_580210, "fields", newJString(fields))
  add(query_580210, "quotaUser", newJString(quotaUser))
  add(query_580210, "alt", newJString(alt))
  add(path_580209, "jobId", newJString(jobId))
  add(query_580210, "oauth_token", newJString(oauthToken))
  add(query_580210, "callback", newJString(callback))
  add(query_580210, "access_token", newJString(accessToken))
  add(query_580210, "uploadType", newJString(uploadType))
  add(query_580210, "key", newJString(key))
  add(path_580209, "projectId", newJString(projectId))
  add(query_580210, "$.xgafv", newJString(Xgafv))
  add(path_580209, "region", newJString(region))
  if body != nil:
    body_580211 = body
  add(query_580210, "prettyPrint", newJBool(prettyPrint))
  result = call_580208.call(path_580209, query_580210, nil, nil, body_580211)

var dataprocProjectsRegionsJobsCancel* = Call_DataprocProjectsRegionsJobsCancel_580189(
    name: "dataprocProjectsRegionsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsRegionsJobsCancel_580190, base: "/",
    url: url_DataprocProjectsRegionsJobsCancel_580191, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsSubmit_580212 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsJobsSubmit_580214(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsSubmit_580213(path: JsonNode;
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
  var valid_580215 = path.getOrDefault("projectId")
  valid_580215 = validateParameter(valid_580215, JString, required = true,
                                 default = nil)
  if valid_580215 != nil:
    section.add "projectId", valid_580215
  var valid_580216 = path.getOrDefault("region")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "region", valid_580216
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
  var valid_580217 = query.getOrDefault("upload_protocol")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "upload_protocol", valid_580217
  var valid_580218 = query.getOrDefault("fields")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "fields", valid_580218
  var valid_580219 = query.getOrDefault("quotaUser")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "quotaUser", valid_580219
  var valid_580220 = query.getOrDefault("alt")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("json"))
  if valid_580220 != nil:
    section.add "alt", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("callback")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "callback", valid_580222
  var valid_580223 = query.getOrDefault("access_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "access_token", valid_580223
  var valid_580224 = query.getOrDefault("uploadType")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "uploadType", valid_580224
  var valid_580225 = query.getOrDefault("key")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "key", valid_580225
  var valid_580226 = query.getOrDefault("$.xgafv")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("1"))
  if valid_580226 != nil:
    section.add "$.xgafv", valid_580226
  var valid_580227 = query.getOrDefault("prettyPrint")
  valid_580227 = validateParameter(valid_580227, JBool, required = false,
                                 default = newJBool(true))
  if valid_580227 != nil:
    section.add "prettyPrint", valid_580227
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

proc call*(call_580229: Call_DataprocProjectsRegionsJobsSubmit_580212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_580229.validator(path, query, header, formData, body)
  let scheme = call_580229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580229.url(scheme.get, call_580229.host, call_580229.base,
                         call_580229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580229, url, valid)

proc call*(call_580230: Call_DataprocProjectsRegionsJobsSubmit_580212;
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
  var path_580231 = newJObject()
  var query_580232 = newJObject()
  var body_580233 = newJObject()
  add(query_580232, "upload_protocol", newJString(uploadProtocol))
  add(query_580232, "fields", newJString(fields))
  add(query_580232, "quotaUser", newJString(quotaUser))
  add(query_580232, "alt", newJString(alt))
  add(query_580232, "oauth_token", newJString(oauthToken))
  add(query_580232, "callback", newJString(callback))
  add(query_580232, "access_token", newJString(accessToken))
  add(query_580232, "uploadType", newJString(uploadType))
  add(query_580232, "key", newJString(key))
  add(path_580231, "projectId", newJString(projectId))
  add(query_580232, "$.xgafv", newJString(Xgafv))
  add(path_580231, "region", newJString(region))
  if body != nil:
    body_580233 = body
  add(query_580232, "prettyPrint", newJBool(prettyPrint))
  result = call_580230.call(path_580231, query_580232, nil, nil, body_580233)

var dataprocProjectsRegionsJobsSubmit* = Call_DataprocProjectsRegionsJobsSubmit_580212(
    name: "dataprocProjectsRegionsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs:submit",
    validator: validate_DataprocProjectsRegionsJobsSubmit_580213, base: "/",
    url: url_DataprocProjectsRegionsJobsSubmit_580214, schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580254 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580256(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580255(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates (replaces) autoscaling policy.Disabled check for update_mask, because all updates will be full replacements.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The "resource name" of the autoscaling policy, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies, the resource name of the  policy has the following format:  projects/{project_id}/regions/{region}/autoscalingPolicies/{policy_id}
  ## For projects.locations.autoscalingPolicies, the resource name of the  policy has the following format:  projects/{project_id}/locations/{location}/autoscalingPolicies/{policy_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580257 = path.getOrDefault("name")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "name", valid_580257
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
  var valid_580258 = query.getOrDefault("upload_protocol")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "upload_protocol", valid_580258
  var valid_580259 = query.getOrDefault("fields")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "fields", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("oauth_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "oauth_token", valid_580262
  var valid_580263 = query.getOrDefault("callback")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "callback", valid_580263
  var valid_580264 = query.getOrDefault("access_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "access_token", valid_580264
  var valid_580265 = query.getOrDefault("uploadType")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "uploadType", valid_580265
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("$.xgafv")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = newJString("1"))
  if valid_580267 != nil:
    section.add "$.xgafv", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
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

proc call*(call_580270: Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates (replaces) autoscaling policy.Disabled check for update_mask, because all updates will be full replacements.
  ## 
  let valid = call_580270.validator(path, query, header, formData, body)
  let scheme = call_580270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580270.url(scheme.get, call_580270.host, call_580270.base,
                         call_580270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580270, url, valid)

proc call*(call_580271: Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580254;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesUpdate
  ## Updates (replaces) autoscaling policy.Disabled check for update_mask, because all updates will be full replacements.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The "resource name" of the autoscaling policy, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies, the resource name of the  policy has the following format:  projects/{project_id}/regions/{region}/autoscalingPolicies/{policy_id}
  ## For projects.locations.autoscalingPolicies, the resource name of the  policy has the following format:  projects/{project_id}/locations/{location}/autoscalingPolicies/{policy_id}
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
  var path_580272 = newJObject()
  var query_580273 = newJObject()
  var body_580274 = newJObject()
  add(query_580273, "upload_protocol", newJString(uploadProtocol))
  add(query_580273, "fields", newJString(fields))
  add(query_580273, "quotaUser", newJString(quotaUser))
  add(path_580272, "name", newJString(name))
  add(query_580273, "alt", newJString(alt))
  add(query_580273, "oauth_token", newJString(oauthToken))
  add(query_580273, "callback", newJString(callback))
  add(query_580273, "access_token", newJString(accessToken))
  add(query_580273, "uploadType", newJString(uploadType))
  add(query_580273, "key", newJString(key))
  add(query_580273, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580274 = body
  add(query_580273, "prettyPrint", newJBool(prettyPrint))
  result = call_580271.call(path_580272, query_580273, nil, nil, body_580274)

var dataprocProjectsLocationsAutoscalingPoliciesUpdate* = Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580254(
    name: "dataprocProjectsLocationsAutoscalingPoliciesUpdate",
    meth: HttpMethod.HttpPut, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580255,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesUpdate_580256,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesGet_580234 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesGet_580236(protocol: Scheme;
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesGet_580235(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves autoscaling policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The "resource name" of the autoscaling policy, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.get, the resource name  of the policy has the following format:  projects/{project_id}/regions/{region}/autoscalingPolicies/{policy_id}
  ## For projects.locations.autoscalingPolicies.get, the resource name  of the policy has the following format:  projects/{project_id}/locations/{location}/autoscalingPolicies/{policy_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580237 = path.getOrDefault("name")
  valid_580237 = validateParameter(valid_580237, JString, required = true,
                                 default = nil)
  if valid_580237 != nil:
    section.add "name", valid_580237
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
  ##          : Optional. The version of workflow template to retrieve. Only previously instantiated versions can be retrieved.If unspecified, retrieves the current version.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580238 = query.getOrDefault("upload_protocol")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "upload_protocol", valid_580238
  var valid_580239 = query.getOrDefault("fields")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "fields", valid_580239
  var valid_580240 = query.getOrDefault("quotaUser")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "quotaUser", valid_580240
  var valid_580241 = query.getOrDefault("alt")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = newJString("json"))
  if valid_580241 != nil:
    section.add "alt", valid_580241
  var valid_580242 = query.getOrDefault("oauth_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "oauth_token", valid_580242
  var valid_580243 = query.getOrDefault("callback")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "callback", valid_580243
  var valid_580244 = query.getOrDefault("access_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "access_token", valid_580244
  var valid_580245 = query.getOrDefault("uploadType")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "uploadType", valid_580245
  var valid_580246 = query.getOrDefault("key")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "key", valid_580246
  var valid_580247 = query.getOrDefault("$.xgafv")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("1"))
  if valid_580247 != nil:
    section.add "$.xgafv", valid_580247
  var valid_580248 = query.getOrDefault("version")
  valid_580248 = validateParameter(valid_580248, JInt, required = false, default = nil)
  if valid_580248 != nil:
    section.add "version", valid_580248
  var valid_580249 = query.getOrDefault("prettyPrint")
  valid_580249 = validateParameter(valid_580249, JBool, required = false,
                                 default = newJBool(true))
  if valid_580249 != nil:
    section.add "prettyPrint", valid_580249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580250: Call_DataprocProjectsLocationsAutoscalingPoliciesGet_580234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves autoscaling policy.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_DataprocProjectsLocationsAutoscalingPoliciesGet_580234;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; version: int = 0; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesGet
  ## Retrieves autoscaling policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The "resource name" of the autoscaling policy, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.get, the resource name  of the policy has the following format:  projects/{project_id}/regions/{region}/autoscalingPolicies/{policy_id}
  ## For projects.locations.autoscalingPolicies.get, the resource name  of the policy has the following format:  projects/{project_id}/locations/{location}/autoscalingPolicies/{policy_id}
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
  ##          : Optional. The version of workflow template to retrieve. Only previously instantiated versions can be retrieved.If unspecified, retrieves the current version.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  add(query_580253, "upload_protocol", newJString(uploadProtocol))
  add(query_580253, "fields", newJString(fields))
  add(query_580253, "quotaUser", newJString(quotaUser))
  add(path_580252, "name", newJString(name))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "callback", newJString(callback))
  add(query_580253, "access_token", newJString(accessToken))
  add(query_580253, "uploadType", newJString(uploadType))
  add(query_580253, "key", newJString(key))
  add(query_580253, "$.xgafv", newJString(Xgafv))
  add(query_580253, "version", newJInt(version))
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  result = call_580251.call(path_580252, query_580253, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesGet* = Call_DataprocProjectsLocationsAutoscalingPoliciesGet_580234(
    name: "dataprocProjectsLocationsAutoscalingPoliciesGet",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesGet_580235,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesGet_580236,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_580275 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesDelete_580277(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesDelete_580276(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes an autoscaling policy. It is an error to delete an autoscaling policy that is in use by one or more clusters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The "resource name" of the autoscaling policy, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.delete, the resource name  of the policy has the following format:  projects/{project_id}/regions/{region}/autoscalingPolicies/{policy_id}
  ## For projects.locations.autoscalingPolicies.delete, the resource name  of the policy has the following format:  projects/{project_id}/locations/{location}/autoscalingPolicies/{policy_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580278 = path.getOrDefault("name")
  valid_580278 = validateParameter(valid_580278, JString, required = true,
                                 default = nil)
  if valid_580278 != nil:
    section.add "name", valid_580278
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
  var valid_580279 = query.getOrDefault("upload_protocol")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "upload_protocol", valid_580279
  var valid_580280 = query.getOrDefault("fields")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "fields", valid_580280
  var valid_580281 = query.getOrDefault("quotaUser")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "quotaUser", valid_580281
  var valid_580282 = query.getOrDefault("alt")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("json"))
  if valid_580282 != nil:
    section.add "alt", valid_580282
  var valid_580283 = query.getOrDefault("oauth_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "oauth_token", valid_580283
  var valid_580284 = query.getOrDefault("callback")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "callback", valid_580284
  var valid_580285 = query.getOrDefault("access_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "access_token", valid_580285
  var valid_580286 = query.getOrDefault("uploadType")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "uploadType", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("version")
  valid_580289 = validateParameter(valid_580289, JInt, required = false, default = nil)
  if valid_580289 != nil:
    section.add "version", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580291: Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_580275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an autoscaling policy. It is an error to delete an autoscaling policy that is in use by one or more clusters.
  ## 
  let valid = call_580291.validator(path, query, header, formData, body)
  let scheme = call_580291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580291.url(scheme.get, call_580291.host, call_580291.base,
                         call_580291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580291, url, valid)

proc call*(call_580292: Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_580275;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; version: int = 0; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesDelete
  ## Deletes an autoscaling policy. It is an error to delete an autoscaling policy that is in use by one or more clusters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The "resource name" of the autoscaling policy, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.delete, the resource name  of the policy has the following format:  projects/{project_id}/regions/{region}/autoscalingPolicies/{policy_id}
  ## For projects.locations.autoscalingPolicies.delete, the resource name  of the policy has the following format:  projects/{project_id}/locations/{location}/autoscalingPolicies/{policy_id}
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
  var path_580293 = newJObject()
  var query_580294 = newJObject()
  add(query_580294, "upload_protocol", newJString(uploadProtocol))
  add(query_580294, "fields", newJString(fields))
  add(query_580294, "quotaUser", newJString(quotaUser))
  add(path_580293, "name", newJString(name))
  add(query_580294, "alt", newJString(alt))
  add(query_580294, "oauth_token", newJString(oauthToken))
  add(query_580294, "callback", newJString(callback))
  add(query_580294, "access_token", newJString(accessToken))
  add(query_580294, "uploadType", newJString(uploadType))
  add(query_580294, "key", newJString(key))
  add(query_580294, "$.xgafv", newJString(Xgafv))
  add(query_580294, "version", newJInt(version))
  add(query_580294, "prettyPrint", newJBool(prettyPrint))
  result = call_580292.call(path_580293, query_580294, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesDelete* = Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_580275(
    name: "dataprocProjectsLocationsAutoscalingPoliciesDelete",
    meth: HttpMethod.HttpDelete, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesDelete_580276,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesDelete_580277,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsOperationsCancel_580295 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsRegionsOperationsCancel_580297(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsOperationsCancel_580296(path: JsonNode;
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
  var valid_580298 = path.getOrDefault("name")
  valid_580298 = validateParameter(valid_580298, JString, required = true,
                                 default = nil)
  if valid_580298 != nil:
    section.add "name", valid_580298
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
  var valid_580299 = query.getOrDefault("upload_protocol")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "upload_protocol", valid_580299
  var valid_580300 = query.getOrDefault("fields")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "fields", valid_580300
  var valid_580301 = query.getOrDefault("quotaUser")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "quotaUser", valid_580301
  var valid_580302 = query.getOrDefault("alt")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = newJString("json"))
  if valid_580302 != nil:
    section.add "alt", valid_580302
  var valid_580303 = query.getOrDefault("oauth_token")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "oauth_token", valid_580303
  var valid_580304 = query.getOrDefault("callback")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "callback", valid_580304
  var valid_580305 = query.getOrDefault("access_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "access_token", valid_580305
  var valid_580306 = query.getOrDefault("uploadType")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "uploadType", valid_580306
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("$.xgafv")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = newJString("1"))
  if valid_580308 != nil:
    section.add "$.xgafv", valid_580308
  var valid_580309 = query.getOrDefault("prettyPrint")
  valid_580309 = validateParameter(valid_580309, JBool, required = false,
                                 default = newJBool(true))
  if valid_580309 != nil:
    section.add "prettyPrint", valid_580309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580310: Call_DataprocProjectsRegionsOperationsCancel_580295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_580310.validator(path, query, header, formData, body)
  let scheme = call_580310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580310.url(scheme.get, call_580310.host, call_580310.base,
                         call_580310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580310, url, valid)

proc call*(call_580311: Call_DataprocProjectsRegionsOperationsCancel_580295;
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
  var path_580312 = newJObject()
  var query_580313 = newJObject()
  add(query_580313, "upload_protocol", newJString(uploadProtocol))
  add(query_580313, "fields", newJString(fields))
  add(query_580313, "quotaUser", newJString(quotaUser))
  add(path_580312, "name", newJString(name))
  add(query_580313, "alt", newJString(alt))
  add(query_580313, "oauth_token", newJString(oauthToken))
  add(query_580313, "callback", newJString(callback))
  add(query_580313, "access_token", newJString(accessToken))
  add(query_580313, "uploadType", newJString(uploadType))
  add(query_580313, "key", newJString(key))
  add(query_580313, "$.xgafv", newJString(Xgafv))
  add(query_580313, "prettyPrint", newJBool(prettyPrint))
  result = call_580311.call(path_580312, query_580313, nil, nil, nil)

var dataprocProjectsRegionsOperationsCancel* = Call_DataprocProjectsRegionsOperationsCancel_580295(
    name: "dataprocProjectsRegionsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/{name}:cancel",
    validator: validate_DataprocProjectsRegionsOperationsCancel_580296, base: "/",
    url: url_DataprocProjectsRegionsOperationsCancel_580297,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580314 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580316(
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

proc validate_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580315(
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
  var valid_580317 = path.getOrDefault("name")
  valid_580317 = validateParameter(valid_580317, JString, required = true,
                                 default = nil)
  if valid_580317 != nil:
    section.add "name", valid_580317
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
  var valid_580318 = query.getOrDefault("upload_protocol")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "upload_protocol", valid_580318
  var valid_580319 = query.getOrDefault("fields")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "fields", valid_580319
  var valid_580320 = query.getOrDefault("quotaUser")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "quotaUser", valid_580320
  var valid_580321 = query.getOrDefault("alt")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = newJString("json"))
  if valid_580321 != nil:
    section.add "alt", valid_580321
  var valid_580322 = query.getOrDefault("oauth_token")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "oauth_token", valid_580322
  var valid_580323 = query.getOrDefault("callback")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "callback", valid_580323
  var valid_580324 = query.getOrDefault("access_token")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "access_token", valid_580324
  var valid_580325 = query.getOrDefault("uploadType")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "uploadType", valid_580325
  var valid_580326 = query.getOrDefault("key")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "key", valid_580326
  var valid_580327 = query.getOrDefault("$.xgafv")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = newJString("1"))
  if valid_580327 != nil:
    section.add "$.xgafv", valid_580327
  var valid_580328 = query.getOrDefault("prettyPrint")
  valid_580328 = validateParameter(valid_580328, JBool, required = false,
                                 default = newJBool(true))
  if valid_580328 != nil:
    section.add "prettyPrint", valid_580328
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

proc call*(call_580330: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_580330.validator(path, query, header, formData, body)
  let scheme = call_580330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580330.url(scheme.get, call_580330.host, call_580330.base,
                         call_580330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580330, url, valid)

proc call*(call_580331: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580314;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsWorkflowTemplatesInstantiate
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
  var path_580332 = newJObject()
  var query_580333 = newJObject()
  var body_580334 = newJObject()
  add(query_580333, "upload_protocol", newJString(uploadProtocol))
  add(query_580333, "fields", newJString(fields))
  add(query_580333, "quotaUser", newJString(quotaUser))
  add(path_580332, "name", newJString(name))
  add(query_580333, "alt", newJString(alt))
  add(query_580333, "oauth_token", newJString(oauthToken))
  add(query_580333, "callback", newJString(callback))
  add(query_580333, "access_token", newJString(accessToken))
  add(query_580333, "uploadType", newJString(uploadType))
  add(query_580333, "key", newJString(key))
  add(query_580333, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580334 = body
  add(query_580333, "prettyPrint", newJBool(prettyPrint))
  result = call_580331.call(path_580332, query_580333, nil, nil, body_580334)

var dataprocProjectsLocationsWorkflowTemplatesInstantiate* = Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580314(
    name: "dataprocProjectsLocationsWorkflowTemplatesInstantiate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}:instantiate",
    validator: validate_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580315,
    base: "/", url: url_DataprocProjectsLocationsWorkflowTemplatesInstantiate_580316,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_580356 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesCreate_580358(
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesCreate_580357(
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
  var valid_580359 = path.getOrDefault("parent")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "parent", valid_580359
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
  var valid_580360 = query.getOrDefault("upload_protocol")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "upload_protocol", valid_580360
  var valid_580361 = query.getOrDefault("fields")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "fields", valid_580361
  var valid_580362 = query.getOrDefault("quotaUser")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "quotaUser", valid_580362
  var valid_580363 = query.getOrDefault("alt")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("json"))
  if valid_580363 != nil:
    section.add "alt", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("callback")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "callback", valid_580365
  var valid_580366 = query.getOrDefault("access_token")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "access_token", valid_580366
  var valid_580367 = query.getOrDefault("uploadType")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "uploadType", valid_580367
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("$.xgafv")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("1"))
  if valid_580369 != nil:
    section.add "$.xgafv", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
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

proc call*(call_580372: Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_580356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new autoscaling policy.
  ## 
  let valid = call_580372.validator(path, query, header, formData, body)
  let scheme = call_580372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580372.url(scheme.get, call_580372.host, call_580372.base,
                         call_580372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580372, url, valid)

proc call*(call_580373: Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_580356;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesCreate
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
  var path_580374 = newJObject()
  var query_580375 = newJObject()
  var body_580376 = newJObject()
  add(query_580375, "upload_protocol", newJString(uploadProtocol))
  add(query_580375, "fields", newJString(fields))
  add(query_580375, "quotaUser", newJString(quotaUser))
  add(query_580375, "alt", newJString(alt))
  add(query_580375, "oauth_token", newJString(oauthToken))
  add(query_580375, "callback", newJString(callback))
  add(query_580375, "access_token", newJString(accessToken))
  add(query_580375, "uploadType", newJString(uploadType))
  add(path_580374, "parent", newJString(parent))
  add(query_580375, "key", newJString(key))
  add(query_580375, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580376 = body
  add(query_580375, "prettyPrint", newJBool(prettyPrint))
  result = call_580373.call(path_580374, query_580375, nil, nil, body_580376)

var dataprocProjectsLocationsAutoscalingPoliciesCreate* = Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_580356(
    name: "dataprocProjectsLocationsAutoscalingPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesCreate_580357,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesCreate_580358,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesList_580335 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesList_580337(
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesList_580336(
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
  var valid_580338 = path.getOrDefault("parent")
  valid_580338 = validateParameter(valid_580338, JString, required = true,
                                 default = nil)
  if valid_580338 != nil:
    section.add "parent", valid_580338
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
  var valid_580339 = query.getOrDefault("upload_protocol")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "upload_protocol", valid_580339
  var valid_580340 = query.getOrDefault("fields")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "fields", valid_580340
  var valid_580341 = query.getOrDefault("pageToken")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "pageToken", valid_580341
  var valid_580342 = query.getOrDefault("quotaUser")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "quotaUser", valid_580342
  var valid_580343 = query.getOrDefault("alt")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = newJString("json"))
  if valid_580343 != nil:
    section.add "alt", valid_580343
  var valid_580344 = query.getOrDefault("oauth_token")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "oauth_token", valid_580344
  var valid_580345 = query.getOrDefault("callback")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "callback", valid_580345
  var valid_580346 = query.getOrDefault("access_token")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "access_token", valid_580346
  var valid_580347 = query.getOrDefault("uploadType")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "uploadType", valid_580347
  var valid_580348 = query.getOrDefault("key")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "key", valid_580348
  var valid_580349 = query.getOrDefault("$.xgafv")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = newJString("1"))
  if valid_580349 != nil:
    section.add "$.xgafv", valid_580349
  var valid_580350 = query.getOrDefault("pageSize")
  valid_580350 = validateParameter(valid_580350, JInt, required = false, default = nil)
  if valid_580350 != nil:
    section.add "pageSize", valid_580350
  var valid_580351 = query.getOrDefault("prettyPrint")
  valid_580351 = validateParameter(valid_580351, JBool, required = false,
                                 default = newJBool(true))
  if valid_580351 != nil:
    section.add "prettyPrint", valid_580351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580352: Call_DataprocProjectsLocationsAutoscalingPoliciesList_580335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists autoscaling policies in the project.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_DataprocProjectsLocationsAutoscalingPoliciesList_580335;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesList
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
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  add(query_580355, "upload_protocol", newJString(uploadProtocol))
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "pageToken", newJString(pageToken))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "callback", newJString(callback))
  add(query_580355, "access_token", newJString(accessToken))
  add(query_580355, "uploadType", newJString(uploadType))
  add(path_580354, "parent", newJString(parent))
  add(query_580355, "key", newJString(key))
  add(query_580355, "$.xgafv", newJString(Xgafv))
  add(query_580355, "pageSize", newJInt(pageSize))
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  result = call_580353.call(path_580354, query_580355, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesList* = Call_DataprocProjectsLocationsAutoscalingPoliciesList_580335(
    name: "dataprocProjectsLocationsAutoscalingPoliciesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesList_580336,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesList_580337,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesCreate_580398 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsWorkflowTemplatesCreate_580400(
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
               (kind: ConstantSegment, value: "/workflowTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsLocationsWorkflowTemplatesCreate_580399(
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
  var valid_580401 = path.getOrDefault("parent")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = nil)
  if valid_580401 != nil:
    section.add "parent", valid_580401
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
  var valid_580402 = query.getOrDefault("upload_protocol")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "upload_protocol", valid_580402
  var valid_580403 = query.getOrDefault("fields")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "fields", valid_580403
  var valid_580404 = query.getOrDefault("quotaUser")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "quotaUser", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("oauth_token")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "oauth_token", valid_580406
  var valid_580407 = query.getOrDefault("callback")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "callback", valid_580407
  var valid_580408 = query.getOrDefault("access_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "access_token", valid_580408
  var valid_580409 = query.getOrDefault("uploadType")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "uploadType", valid_580409
  var valid_580410 = query.getOrDefault("key")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "key", valid_580410
  var valid_580411 = query.getOrDefault("$.xgafv")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("1"))
  if valid_580411 != nil:
    section.add "$.xgafv", valid_580411
  var valid_580412 = query.getOrDefault("prettyPrint")
  valid_580412 = validateParameter(valid_580412, JBool, required = false,
                                 default = newJBool(true))
  if valid_580412 != nil:
    section.add "prettyPrint", valid_580412
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

proc call*(call_580414: Call_DataprocProjectsLocationsWorkflowTemplatesCreate_580398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new workflow template.
  ## 
  let valid = call_580414.validator(path, query, header, formData, body)
  let scheme = call_580414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580414.url(scheme.get, call_580414.host, call_580414.base,
                         call_580414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580414, url, valid)

proc call*(call_580415: Call_DataprocProjectsLocationsWorkflowTemplatesCreate_580398;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsWorkflowTemplatesCreate
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
  var path_580416 = newJObject()
  var query_580417 = newJObject()
  var body_580418 = newJObject()
  add(query_580417, "upload_protocol", newJString(uploadProtocol))
  add(query_580417, "fields", newJString(fields))
  add(query_580417, "quotaUser", newJString(quotaUser))
  add(query_580417, "alt", newJString(alt))
  add(query_580417, "oauth_token", newJString(oauthToken))
  add(query_580417, "callback", newJString(callback))
  add(query_580417, "access_token", newJString(accessToken))
  add(query_580417, "uploadType", newJString(uploadType))
  add(path_580416, "parent", newJString(parent))
  add(query_580417, "key", newJString(key))
  add(query_580417, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580418 = body
  add(query_580417, "prettyPrint", newJBool(prettyPrint))
  result = call_580415.call(path_580416, query_580417, nil, nil, body_580418)

var dataprocProjectsLocationsWorkflowTemplatesCreate* = Call_DataprocProjectsLocationsWorkflowTemplatesCreate_580398(
    name: "dataprocProjectsLocationsWorkflowTemplatesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsLocationsWorkflowTemplatesCreate_580399,
    base: "/", url: url_DataprocProjectsLocationsWorkflowTemplatesCreate_580400,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesList_580377 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsWorkflowTemplatesList_580379(protocol: Scheme;
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

proc validate_DataprocProjectsLocationsWorkflowTemplatesList_580378(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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
  var valid_580380 = path.getOrDefault("parent")
  valid_580380 = validateParameter(valid_580380, JString, required = true,
                                 default = nil)
  if valid_580380 != nil:
    section.add "parent", valid_580380
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
  var valid_580381 = query.getOrDefault("upload_protocol")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "upload_protocol", valid_580381
  var valid_580382 = query.getOrDefault("fields")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "fields", valid_580382
  var valid_580383 = query.getOrDefault("pageToken")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "pageToken", valid_580383
  var valid_580384 = query.getOrDefault("quotaUser")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "quotaUser", valid_580384
  var valid_580385 = query.getOrDefault("alt")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("json"))
  if valid_580385 != nil:
    section.add "alt", valid_580385
  var valid_580386 = query.getOrDefault("oauth_token")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "oauth_token", valid_580386
  var valid_580387 = query.getOrDefault("callback")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "callback", valid_580387
  var valid_580388 = query.getOrDefault("access_token")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "access_token", valid_580388
  var valid_580389 = query.getOrDefault("uploadType")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "uploadType", valid_580389
  var valid_580390 = query.getOrDefault("key")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "key", valid_580390
  var valid_580391 = query.getOrDefault("$.xgafv")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = newJString("1"))
  if valid_580391 != nil:
    section.add "$.xgafv", valid_580391
  var valid_580392 = query.getOrDefault("pageSize")
  valid_580392 = validateParameter(valid_580392, JInt, required = false, default = nil)
  if valid_580392 != nil:
    section.add "pageSize", valid_580392
  var valid_580393 = query.getOrDefault("prettyPrint")
  valid_580393 = validateParameter(valid_580393, JBool, required = false,
                                 default = newJBool(true))
  if valid_580393 != nil:
    section.add "prettyPrint", valid_580393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580394: Call_DataprocProjectsLocationsWorkflowTemplatesList_580377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists workflows that match the specified filter in the request.
  ## 
  let valid = call_580394.validator(path, query, header, formData, body)
  let scheme = call_580394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580394.url(scheme.get, call_580394.host, call_580394.base,
                         call_580394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580394, url, valid)

proc call*(call_580395: Call_DataprocProjectsLocationsWorkflowTemplatesList_580377;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsWorkflowTemplatesList
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
  var path_580396 = newJObject()
  var query_580397 = newJObject()
  add(query_580397, "upload_protocol", newJString(uploadProtocol))
  add(query_580397, "fields", newJString(fields))
  add(query_580397, "pageToken", newJString(pageToken))
  add(query_580397, "quotaUser", newJString(quotaUser))
  add(query_580397, "alt", newJString(alt))
  add(query_580397, "oauth_token", newJString(oauthToken))
  add(query_580397, "callback", newJString(callback))
  add(query_580397, "access_token", newJString(accessToken))
  add(query_580397, "uploadType", newJString(uploadType))
  add(path_580396, "parent", newJString(parent))
  add(query_580397, "key", newJString(key))
  add(query_580397, "$.xgafv", newJString(Xgafv))
  add(query_580397, "pageSize", newJInt(pageSize))
  add(query_580397, "prettyPrint", newJBool(prettyPrint))
  result = call_580395.call(path_580396, query_580397, nil, nil, nil)

var dataprocProjectsLocationsWorkflowTemplatesList* = Call_DataprocProjectsLocationsWorkflowTemplatesList_580377(
    name: "dataprocProjectsLocationsWorkflowTemplatesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsLocationsWorkflowTemplatesList_580378,
    base: "/", url: url_DataprocProjectsLocationsWorkflowTemplatesList_580379,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580419 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580421(
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

proc validate_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580420(
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
  var valid_580422 = path.getOrDefault("parent")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "parent", valid_580422
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
  var valid_580423 = query.getOrDefault("upload_protocol")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "upload_protocol", valid_580423
  var valid_580424 = query.getOrDefault("fields")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "fields", valid_580424
  var valid_580425 = query.getOrDefault("requestId")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "requestId", valid_580425
  var valid_580426 = query.getOrDefault("quotaUser")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "quotaUser", valid_580426
  var valid_580427 = query.getOrDefault("alt")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = newJString("json"))
  if valid_580427 != nil:
    section.add "alt", valid_580427
  var valid_580428 = query.getOrDefault("oauth_token")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "oauth_token", valid_580428
  var valid_580429 = query.getOrDefault("callback")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "callback", valid_580429
  var valid_580430 = query.getOrDefault("access_token")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "access_token", valid_580430
  var valid_580431 = query.getOrDefault("uploadType")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "uploadType", valid_580431
  var valid_580432 = query.getOrDefault("key")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "key", valid_580432
  var valid_580433 = query.getOrDefault("$.xgafv")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("1"))
  if valid_580433 != nil:
    section.add "$.xgafv", valid_580433
  var valid_580434 = query.getOrDefault("instanceId")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "instanceId", valid_580434
  var valid_580435 = query.getOrDefault("prettyPrint")
  valid_580435 = validateParameter(valid_580435, JBool, required = false,
                                 default = newJBool(true))
  if valid_580435 != nil:
    section.add "prettyPrint", valid_580435
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

proc call*(call_580437: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.This method is equivalent to executing the sequence CreateWorkflowTemplate, InstantiateWorkflowTemplate, DeleteWorkflowTemplate.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_580437.validator(path, query, header, formData, body)
  let scheme = call_580437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580437.url(scheme.get, call_580437.host, call_580437.base,
                         call_580437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580437, url, valid)

proc call*(call_580438: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580419;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          instanceId: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsWorkflowTemplatesInstantiateInline
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
  var path_580439 = newJObject()
  var query_580440 = newJObject()
  var body_580441 = newJObject()
  add(query_580440, "upload_protocol", newJString(uploadProtocol))
  add(query_580440, "fields", newJString(fields))
  add(query_580440, "requestId", newJString(requestId))
  add(query_580440, "quotaUser", newJString(quotaUser))
  add(query_580440, "alt", newJString(alt))
  add(query_580440, "oauth_token", newJString(oauthToken))
  add(query_580440, "callback", newJString(callback))
  add(query_580440, "access_token", newJString(accessToken))
  add(query_580440, "uploadType", newJString(uploadType))
  add(path_580439, "parent", newJString(parent))
  add(query_580440, "key", newJString(key))
  add(query_580440, "$.xgafv", newJString(Xgafv))
  add(query_580440, "instanceId", newJString(instanceId))
  if body != nil:
    body_580441 = body
  add(query_580440, "prettyPrint", newJBool(prettyPrint))
  result = call_580438.call(path_580439, query_580440, nil, nil, body_580441)

var dataprocProjectsLocationsWorkflowTemplatesInstantiateInline* = Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580419(
    name: "dataprocProjectsLocationsWorkflowTemplatesInstantiateInline",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates:instantiateInline", validator: validate_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580420,
    base: "/",
    url: url_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_580421,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580442 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580444(
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580443(
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
  var valid_580445 = path.getOrDefault("resource")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "resource", valid_580445
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
  var valid_580446 = query.getOrDefault("upload_protocol")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "upload_protocol", valid_580446
  var valid_580447 = query.getOrDefault("fields")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "fields", valid_580447
  var valid_580448 = query.getOrDefault("quotaUser")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "quotaUser", valid_580448
  var valid_580449 = query.getOrDefault("alt")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = newJString("json"))
  if valid_580449 != nil:
    section.add "alt", valid_580449
  var valid_580450 = query.getOrDefault("oauth_token")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "oauth_token", valid_580450
  var valid_580451 = query.getOrDefault("callback")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "callback", valid_580451
  var valid_580452 = query.getOrDefault("access_token")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "access_token", valid_580452
  var valid_580453 = query.getOrDefault("uploadType")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "uploadType", valid_580453
  var valid_580454 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580454 = validateParameter(valid_580454, JInt, required = false, default = nil)
  if valid_580454 != nil:
    section.add "options.requestedPolicyVersion", valid_580454
  var valid_580455 = query.getOrDefault("key")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "key", valid_580455
  var valid_580456 = query.getOrDefault("$.xgafv")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = newJString("1"))
  if valid_580456 != nil:
    section.add "$.xgafv", valid_580456
  var valid_580457 = query.getOrDefault("prettyPrint")
  valid_580457 = validateParameter(valid_580457, JBool, required = false,
                                 default = newJBool(true))
  if valid_580457 != nil:
    section.add "prettyPrint", valid_580457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580458: Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. Returns an empty policy if the resource exists and does not have a policy set.
  ## 
  let valid = call_580458.validator(path, query, header, formData, body)
  let scheme = call_580458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580458.url(scheme.get, call_580458.host, call_580458.base,
                         call_580458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580458, url, valid)

proc call*(call_580459: Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580442;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy
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
  var path_580460 = newJObject()
  var query_580461 = newJObject()
  add(query_580461, "upload_protocol", newJString(uploadProtocol))
  add(query_580461, "fields", newJString(fields))
  add(query_580461, "quotaUser", newJString(quotaUser))
  add(query_580461, "alt", newJString(alt))
  add(query_580461, "oauth_token", newJString(oauthToken))
  add(query_580461, "callback", newJString(callback))
  add(query_580461, "access_token", newJString(accessToken))
  add(query_580461, "uploadType", newJString(uploadType))
  add(query_580461, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580461, "key", newJString(key))
  add(query_580461, "$.xgafv", newJString(Xgafv))
  add(path_580460, "resource", newJString(resource))
  add(query_580461, "prettyPrint", newJBool(prettyPrint))
  result = call_580459.call(path_580460, query_580461, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy* = Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580442(
    name: "dataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:getIamPolicy", validator: validate_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580443,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_580444,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580462 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580464(
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580463(
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
  var valid_580465 = path.getOrDefault("resource")
  valid_580465 = validateParameter(valid_580465, JString, required = true,
                                 default = nil)
  if valid_580465 != nil:
    section.add "resource", valid_580465
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
  var valid_580466 = query.getOrDefault("upload_protocol")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "upload_protocol", valid_580466
  var valid_580467 = query.getOrDefault("fields")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "fields", valid_580467
  var valid_580468 = query.getOrDefault("quotaUser")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "quotaUser", valid_580468
  var valid_580469 = query.getOrDefault("alt")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = newJString("json"))
  if valid_580469 != nil:
    section.add "alt", valid_580469
  var valid_580470 = query.getOrDefault("oauth_token")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "oauth_token", valid_580470
  var valid_580471 = query.getOrDefault("callback")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "callback", valid_580471
  var valid_580472 = query.getOrDefault("access_token")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "access_token", valid_580472
  var valid_580473 = query.getOrDefault("uploadType")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "uploadType", valid_580473
  var valid_580474 = query.getOrDefault("key")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "key", valid_580474
  var valid_580475 = query.getOrDefault("$.xgafv")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = newJString("1"))
  if valid_580475 != nil:
    section.add "$.xgafv", valid_580475
  var valid_580476 = query.getOrDefault("prettyPrint")
  valid_580476 = validateParameter(valid_580476, JBool, required = false,
                                 default = newJBool(true))
  if valid_580476 != nil:
    section.add "prettyPrint", valid_580476
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

proc call*(call_580478: Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580462;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_580478.validator(path, query, header, formData, body)
  let scheme = call_580478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580478.url(scheme.get, call_580478.host, call_580478.base,
                         call_580478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580478, url, valid)

proc call*(call_580479: Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580462;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy
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
  var path_580480 = newJObject()
  var query_580481 = newJObject()
  var body_580482 = newJObject()
  add(query_580481, "upload_protocol", newJString(uploadProtocol))
  add(query_580481, "fields", newJString(fields))
  add(query_580481, "quotaUser", newJString(quotaUser))
  add(query_580481, "alt", newJString(alt))
  add(query_580481, "oauth_token", newJString(oauthToken))
  add(query_580481, "callback", newJString(callback))
  add(query_580481, "access_token", newJString(accessToken))
  add(query_580481, "uploadType", newJString(uploadType))
  add(query_580481, "key", newJString(key))
  add(query_580481, "$.xgafv", newJString(Xgafv))
  add(path_580480, "resource", newJString(resource))
  if body != nil:
    body_580482 = body
  add(query_580481, "prettyPrint", newJBool(prettyPrint))
  result = call_580479.call(path_580480, query_580481, nil, nil, body_580482)

var dataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy* = Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580462(
    name: "dataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:setIamPolicy", validator: validate_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580463,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_580464,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580483 = ref object of OpenApiRestCall_579421
proc url_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580485(
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580484(
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
  var valid_580486 = path.getOrDefault("resource")
  valid_580486 = validateParameter(valid_580486, JString, required = true,
                                 default = nil)
  if valid_580486 != nil:
    section.add "resource", valid_580486
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
  var valid_580487 = query.getOrDefault("upload_protocol")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "upload_protocol", valid_580487
  var valid_580488 = query.getOrDefault("fields")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "fields", valid_580488
  var valid_580489 = query.getOrDefault("quotaUser")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "quotaUser", valid_580489
  var valid_580490 = query.getOrDefault("alt")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = newJString("json"))
  if valid_580490 != nil:
    section.add "alt", valid_580490
  var valid_580491 = query.getOrDefault("oauth_token")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "oauth_token", valid_580491
  var valid_580492 = query.getOrDefault("callback")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "callback", valid_580492
  var valid_580493 = query.getOrDefault("access_token")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "access_token", valid_580493
  var valid_580494 = query.getOrDefault("uploadType")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "uploadType", valid_580494
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("$.xgafv")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("1"))
  if valid_580496 != nil:
    section.add "$.xgafv", valid_580496
  var valid_580497 = query.getOrDefault("prettyPrint")
  valid_580497 = validateParameter(valid_580497, JBool, required = false,
                                 default = newJBool(true))
  if valid_580497 != nil:
    section.add "prettyPrint", valid_580497
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

proc call*(call_580499: Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580483;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource. If the resource does not exist, this will return an empty set of permissions, not a NOT_FOUND error.Note: This operation is designed to be used for building permission-aware UIs and command-line tools, not for authorization checking. This operation may "fail open" without warning.
  ## 
  let valid = call_580499.validator(path, query, header, formData, body)
  let scheme = call_580499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580499.url(scheme.get, call_580499.host, call_580499.base,
                         call_580499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580499, url, valid)

proc call*(call_580500: Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580483;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions
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
  var path_580501 = newJObject()
  var query_580502 = newJObject()
  var body_580503 = newJObject()
  add(query_580502, "upload_protocol", newJString(uploadProtocol))
  add(query_580502, "fields", newJString(fields))
  add(query_580502, "quotaUser", newJString(quotaUser))
  add(query_580502, "alt", newJString(alt))
  add(query_580502, "oauth_token", newJString(oauthToken))
  add(query_580502, "callback", newJString(callback))
  add(query_580502, "access_token", newJString(accessToken))
  add(query_580502, "uploadType", newJString(uploadType))
  add(query_580502, "key", newJString(key))
  add(query_580502, "$.xgafv", newJString(Xgafv))
  add(path_580501, "resource", newJString(resource))
  if body != nil:
    body_580503 = body
  add(query_580502, "prettyPrint", newJBool(prettyPrint))
  result = call_580500.call(path_580501, query_580502, nil, nil, body_580503)

var dataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions* = Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580483(
    name: "dataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:testIamPermissions", validator: validate_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580484,
    base: "/",
    url: url_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_580485,
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
