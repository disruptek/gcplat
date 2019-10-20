
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "dataproc"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataprocProjectsRegionsClustersCreate_578911 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsClustersCreate_578913(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersCreate_578912(path: JsonNode;
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
  var valid_578914 = path.getOrDefault("projectId")
  valid_578914 = validateParameter(valid_578914, JString, required = true,
                                 default = nil)
  if valid_578914 != nil:
    section.add "projectId", valid_578914
  var valid_578915 = path.getOrDefault("region")
  valid_578915 = validateParameter(valid_578915, JString, required = true,
                                 default = nil)
  if valid_578915 != nil:
    section.add "region", valid_578915
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
  ##   requestId: JString
  ##            : Optional. A unique id used to identify the request. If the server receives two CreateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578916 = query.getOrDefault("key")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "key", valid_578916
  var valid_578917 = query.getOrDefault("prettyPrint")
  valid_578917 = validateParameter(valid_578917, JBool, required = false,
                                 default = newJBool(true))
  if valid_578917 != nil:
    section.add "prettyPrint", valid_578917
  var valid_578918 = query.getOrDefault("oauth_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "oauth_token", valid_578918
  var valid_578919 = query.getOrDefault("$.xgafv")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("1"))
  if valid_578919 != nil:
    section.add "$.xgafv", valid_578919
  var valid_578920 = query.getOrDefault("alt")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("json"))
  if valid_578920 != nil:
    section.add "alt", valid_578920
  var valid_578921 = query.getOrDefault("uploadType")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "uploadType", valid_578921
  var valid_578922 = query.getOrDefault("quotaUser")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "quotaUser", valid_578922
  var valid_578923 = query.getOrDefault("callback")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "callback", valid_578923
  var valid_578924 = query.getOrDefault("requestId")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "requestId", valid_578924
  var valid_578925 = query.getOrDefault("fields")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "fields", valid_578925
  var valid_578926 = query.getOrDefault("access_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "access_token", valid_578926
  var valid_578927 = query.getOrDefault("upload_protocol")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "upload_protocol", valid_578927
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

proc call*(call_578929: Call_DataprocProjectsRegionsClustersCreate_578911;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_578929.validator(path, query, header, formData, body)
  let scheme = call_578929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578929.url(scheme.get, call_578929.host, call_578929.base,
                         call_578929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578929, url, valid)

proc call*(call_578930: Call_DataprocProjectsRegionsClustersCreate_578911;
          projectId: string; region: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; requestId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersCreate
  ## Creates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   requestId: string
  ##            : Optional. A unique id used to identify the request. If the server receives two CreateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578931 = newJObject()
  var query_578932 = newJObject()
  var body_578933 = newJObject()
  add(query_578932, "key", newJString(key))
  add(query_578932, "prettyPrint", newJBool(prettyPrint))
  add(query_578932, "oauth_token", newJString(oauthToken))
  add(path_578931, "projectId", newJString(projectId))
  add(query_578932, "$.xgafv", newJString(Xgafv))
  add(query_578932, "alt", newJString(alt))
  add(query_578932, "uploadType", newJString(uploadType))
  add(query_578932, "quotaUser", newJString(quotaUser))
  add(path_578931, "region", newJString(region))
  if body != nil:
    body_578933 = body
  add(query_578932, "callback", newJString(callback))
  add(query_578932, "requestId", newJString(requestId))
  add(query_578932, "fields", newJString(fields))
  add(query_578932, "access_token", newJString(accessToken))
  add(query_578932, "upload_protocol", newJString(uploadProtocol))
  result = call_578930.call(path_578931, query_578932, nil, nil, body_578933)

var dataprocProjectsRegionsClustersCreate* = Call_DataprocProjectsRegionsClustersCreate_578911(
    name: "dataprocProjectsRegionsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersCreate_578912, base: "/",
    url: url_DataprocProjectsRegionsClustersCreate_578913, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersList_578619 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsClustersList_578621(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersList_578620(path: JsonNode;
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
  var valid_578747 = path.getOrDefault("projectId")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "projectId", valid_578747
  var valid_578748 = path.getOrDefault("region")
  valid_578748 = validateParameter(valid_578748, JString, required = true,
                                 default = nil)
  if valid_578748 != nil:
    section.add "region", valid_578748
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
  ##           : Optional. The standard List page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Optional. A filter constraining the clusters to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is one of status.state, clusterName, or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be one of the following: ACTIVE, INACTIVE, CREATING, RUNNING, ERROR, DELETING, or UPDATING. ACTIVE contains the CREATING, UPDATING, and RUNNING states. INACTIVE contains the DELETING and ERROR states. clusterName is the name of the cluster provided at creation time. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND clusterName = mycluster AND labels.env = staging AND labels.starred = *
  ##   pageToken: JString
  ##            : Optional. The standard List page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578749 = query.getOrDefault("key")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "key", valid_578749
  var valid_578763 = query.getOrDefault("prettyPrint")
  valid_578763 = validateParameter(valid_578763, JBool, required = false,
                                 default = newJBool(true))
  if valid_578763 != nil:
    section.add "prettyPrint", valid_578763
  var valid_578764 = query.getOrDefault("oauth_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "oauth_token", valid_578764
  var valid_578765 = query.getOrDefault("$.xgafv")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("1"))
  if valid_578765 != nil:
    section.add "$.xgafv", valid_578765
  var valid_578766 = query.getOrDefault("pageSize")
  valid_578766 = validateParameter(valid_578766, JInt, required = false, default = nil)
  if valid_578766 != nil:
    section.add "pageSize", valid_578766
  var valid_578767 = query.getOrDefault("alt")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = newJString("json"))
  if valid_578767 != nil:
    section.add "alt", valid_578767
  var valid_578768 = query.getOrDefault("uploadType")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "uploadType", valid_578768
  var valid_578769 = query.getOrDefault("quotaUser")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "quotaUser", valid_578769
  var valid_578770 = query.getOrDefault("filter")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "filter", valid_578770
  var valid_578771 = query.getOrDefault("pageToken")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "pageToken", valid_578771
  var valid_578772 = query.getOrDefault("callback")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "callback", valid_578772
  var valid_578773 = query.getOrDefault("fields")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "fields", valid_578773
  var valid_578774 = query.getOrDefault("access_token")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "access_token", valid_578774
  var valid_578775 = query.getOrDefault("upload_protocol")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "upload_protocol", valid_578775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578798: Call_DataprocProjectsRegionsClustersList_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all regions/{region}/clusters in a project.
  ## 
  let valid = call_578798.validator(path, query, header, formData, body)
  let scheme = call_578798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578798.url(scheme.get, call_578798.host, call_578798.base,
                         call_578798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578798, url, valid)

proc call*(call_578869: Call_DataprocProjectsRegionsClustersList_578619;
          projectId: string; region: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersList
  ## Lists all regions/{region}/clusters in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The standard List page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   filter: string
  ##         : Optional. A filter constraining the clusters to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is one of status.state, clusterName, or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be one of the following: ACTIVE, INACTIVE, CREATING, RUNNING, ERROR, DELETING, or UPDATING. ACTIVE contains the CREATING, UPDATING, and RUNNING states. INACTIVE contains the DELETING and ERROR states. clusterName is the name of the cluster provided at creation time. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND clusterName = mycluster AND labels.env = staging AND labels.starred = *
  ##   pageToken: string
  ##            : Optional. The standard List page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578870 = newJObject()
  var query_578872 = newJObject()
  add(query_578872, "key", newJString(key))
  add(query_578872, "prettyPrint", newJBool(prettyPrint))
  add(query_578872, "oauth_token", newJString(oauthToken))
  add(path_578870, "projectId", newJString(projectId))
  add(query_578872, "$.xgafv", newJString(Xgafv))
  add(query_578872, "pageSize", newJInt(pageSize))
  add(query_578872, "alt", newJString(alt))
  add(query_578872, "uploadType", newJString(uploadType))
  add(query_578872, "quotaUser", newJString(quotaUser))
  add(path_578870, "region", newJString(region))
  add(query_578872, "filter", newJString(filter))
  add(query_578872, "pageToken", newJString(pageToken))
  add(query_578872, "callback", newJString(callback))
  add(query_578872, "fields", newJString(fields))
  add(query_578872, "access_token", newJString(accessToken))
  add(query_578872, "upload_protocol", newJString(uploadProtocol))
  result = call_578869.call(path_578870, query_578872, nil, nil, nil)

var dataprocProjectsRegionsClustersList* = Call_DataprocProjectsRegionsClustersList_578619(
    name: "dataprocProjectsRegionsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersList_578620, base: "/",
    url: url_DataprocProjectsRegionsClustersList_578621, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersGet_578934 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsClustersGet_578936(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersGet_578935(path: JsonNode;
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
  var valid_578937 = path.getOrDefault("clusterName")
  valid_578937 = validateParameter(valid_578937, JString, required = true,
                                 default = nil)
  if valid_578937 != nil:
    section.add "clusterName", valid_578937
  var valid_578938 = path.getOrDefault("projectId")
  valid_578938 = validateParameter(valid_578938, JString, required = true,
                                 default = nil)
  if valid_578938 != nil:
    section.add "projectId", valid_578938
  var valid_578939 = path.getOrDefault("region")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "region", valid_578939
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
  var valid_578940 = query.getOrDefault("key")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "key", valid_578940
  var valid_578941 = query.getOrDefault("prettyPrint")
  valid_578941 = validateParameter(valid_578941, JBool, required = false,
                                 default = newJBool(true))
  if valid_578941 != nil:
    section.add "prettyPrint", valid_578941
  var valid_578942 = query.getOrDefault("oauth_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "oauth_token", valid_578942
  var valid_578943 = query.getOrDefault("$.xgafv")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = newJString("1"))
  if valid_578943 != nil:
    section.add "$.xgafv", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("uploadType")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "uploadType", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("callback")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "callback", valid_578947
  var valid_578948 = query.getOrDefault("fields")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "fields", valid_578948
  var valid_578949 = query.getOrDefault("access_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "access_token", valid_578949
  var valid_578950 = query.getOrDefault("upload_protocol")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "upload_protocol", valid_578950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578951: Call_DataprocProjectsRegionsClustersGet_578934;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_578951.validator(path, query, header, formData, body)
  let scheme = call_578951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578951.url(scheme.get, call_578951.host, call_578951.base,
                         call_578951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578951, url, valid)

proc call*(call_578952: Call_DataprocProjectsRegionsClustersGet_578934;
          clusterName: string; projectId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersGet
  ## Gets the resource representation for a cluster in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578953 = newJObject()
  var query_578954 = newJObject()
  add(query_578954, "key", newJString(key))
  add(path_578953, "clusterName", newJString(clusterName))
  add(query_578954, "prettyPrint", newJBool(prettyPrint))
  add(query_578954, "oauth_token", newJString(oauthToken))
  add(path_578953, "projectId", newJString(projectId))
  add(query_578954, "$.xgafv", newJString(Xgafv))
  add(query_578954, "alt", newJString(alt))
  add(query_578954, "uploadType", newJString(uploadType))
  add(query_578954, "quotaUser", newJString(quotaUser))
  add(path_578953, "region", newJString(region))
  add(query_578954, "callback", newJString(callback))
  add(query_578954, "fields", newJString(fields))
  add(query_578954, "access_token", newJString(accessToken))
  add(query_578954, "upload_protocol", newJString(uploadProtocol))
  result = call_578952.call(path_578953, query_578954, nil, nil, nil)

var dataprocProjectsRegionsClustersGet* = Call_DataprocProjectsRegionsClustersGet_578934(
    name: "dataprocProjectsRegionsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersGet_578935, base: "/",
    url: url_DataprocProjectsRegionsClustersGet_578936, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersPatch_578978 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsClustersPatch_578980(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersPatch_578979(path: JsonNode;
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
  var valid_578981 = path.getOrDefault("clusterName")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "clusterName", valid_578981
  var valid_578982 = path.getOrDefault("projectId")
  valid_578982 = validateParameter(valid_578982, JString, required = true,
                                 default = nil)
  if valid_578982 != nil:
    section.add "projectId", valid_578982
  var valid_578983 = path.getOrDefault("region")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "region", valid_578983
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   gracefulDecommissionTimeout: JString
  ##                              : Optional. Timeout for graceful YARN decomissioning. Graceful decommissioning allows removing nodes from the cluster without interrupting jobs in progress. Timeout specifies how long to wait for jobs in progress to finish before forcefully removing nodes (and potentially interrupting jobs). Default timeout is 0 (for forceful decommission), and the maximum allowed timeout is 1 day.Only supported on Dataproc image versions 1.2 and higher.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   callback: JString
  ##           : JSONP
  ##   requestId: JString
  ##            : Optional. A unique id used to identify the request. If the server receives two UpdateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("gracefulDecommissionTimeout")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "gracefulDecommissionTimeout", valid_578987
  var valid_578988 = query.getOrDefault("$.xgafv")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("1"))
  if valid_578988 != nil:
    section.add "$.xgafv", valid_578988
  var valid_578989 = query.getOrDefault("alt")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = newJString("json"))
  if valid_578989 != nil:
    section.add "alt", valid_578989
  var valid_578990 = query.getOrDefault("uploadType")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "uploadType", valid_578990
  var valid_578991 = query.getOrDefault("quotaUser")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "quotaUser", valid_578991
  var valid_578992 = query.getOrDefault("updateMask")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "updateMask", valid_578992
  var valid_578993 = query.getOrDefault("callback")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "callback", valid_578993
  var valid_578994 = query.getOrDefault("requestId")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "requestId", valid_578994
  var valid_578995 = query.getOrDefault("fields")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "fields", valid_578995
  var valid_578996 = query.getOrDefault("access_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "access_token", valid_578996
  var valid_578997 = query.getOrDefault("upload_protocol")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "upload_protocol", valid_578997
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

proc call*(call_578999: Call_DataprocProjectsRegionsClustersPatch_578978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_DataprocProjectsRegionsClustersPatch_578978;
          clusterName: string; projectId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          gracefulDecommissionTimeout: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          requestId: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersPatch
  ## Updates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   gracefulDecommissionTimeout: string
  ##                              : Optional. Timeout for graceful YARN decomissioning. Graceful decommissioning allows removing nodes from the cluster without interrupting jobs in progress. Timeout specifies how long to wait for jobs in progress to finish before forcefully removing nodes (and potentially interrupting jobs). Default timeout is 0 (for forceful decommission), and the maximum allowed timeout is 1 day.Only supported on Dataproc image versions 1.2 and higher.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   requestId: string
  ##            : Optional. A unique id used to identify the request. If the server receives two UpdateClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  var body_579003 = newJObject()
  add(query_579002, "key", newJString(key))
  add(path_579001, "clusterName", newJString(clusterName))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "gracefulDecommissionTimeout",
      newJString(gracefulDecommissionTimeout))
  add(path_579001, "projectId", newJString(projectId))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(query_579002, "updateMask", newJString(updateMask))
  add(path_579001, "region", newJString(region))
  if body != nil:
    body_579003 = body
  add(query_579002, "callback", newJString(callback))
  add(query_579002, "requestId", newJString(requestId))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, body_579003)

var dataprocProjectsRegionsClustersPatch* = Call_DataprocProjectsRegionsClustersPatch_578978(
    name: "dataprocProjectsRegionsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersPatch_578979, base: "/",
    url: url_DataprocProjectsRegionsClustersPatch_578980, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDelete_578955 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsClustersDelete_578957(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersDelete_578956(path: JsonNode;
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
  var valid_578958 = path.getOrDefault("clusterName")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "clusterName", valid_578958
  var valid_578959 = path.getOrDefault("projectId")
  valid_578959 = validateParameter(valid_578959, JString, required = true,
                                 default = nil)
  if valid_578959 != nil:
    section.add "projectId", valid_578959
  var valid_578960 = path.getOrDefault("region")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "region", valid_578960
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
  ##   clusterUuid: JString
  ##              : Optional. Specifying the cluster_uuid means the RPC should fail (with error NOT_FOUND) if cluster with specified UUID does not exist.
  ##   callback: JString
  ##           : JSONP
  ##   requestId: JString
  ##            : Optional. A unique id used to identify the request. If the server receives two DeleteClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578961 = query.getOrDefault("key")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "key", valid_578961
  var valid_578962 = query.getOrDefault("prettyPrint")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(true))
  if valid_578962 != nil:
    section.add "prettyPrint", valid_578962
  var valid_578963 = query.getOrDefault("oauth_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "oauth_token", valid_578963
  var valid_578964 = query.getOrDefault("$.xgafv")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("1"))
  if valid_578964 != nil:
    section.add "$.xgafv", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("uploadType")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "uploadType", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("clusterUuid")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "clusterUuid", valid_578968
  var valid_578969 = query.getOrDefault("callback")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "callback", valid_578969
  var valid_578970 = query.getOrDefault("requestId")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "requestId", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578974: Call_DataprocProjectsRegionsClustersDelete_578955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_DataprocProjectsRegionsClustersDelete_578955;
          clusterName: string; projectId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          clusterUuid: string = ""; callback: string = ""; requestId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersDelete
  ## Deletes a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   clusterUuid: string
  ##              : Optional. Specifying the cluster_uuid means the RPC should fail (with error NOT_FOUND) if cluster with specified UUID does not exist.
  ##   callback: string
  ##           : JSONP
  ##   requestId: string
  ##            : Optional. A unique id used to identify the request. If the server receives two DeleteClusterRequest requests with the same id, then the second request will be ignored and the first google.longrunning.Operation created and stored in the backend is returned.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578976 = newJObject()
  var query_578977 = newJObject()
  add(query_578977, "key", newJString(key))
  add(path_578976, "clusterName", newJString(clusterName))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(path_578976, "projectId", newJString(projectId))
  add(query_578977, "$.xgafv", newJString(Xgafv))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "uploadType", newJString(uploadType))
  add(query_578977, "quotaUser", newJString(quotaUser))
  add(path_578976, "region", newJString(region))
  add(query_578977, "clusterUuid", newJString(clusterUuid))
  add(query_578977, "callback", newJString(callback))
  add(query_578977, "requestId", newJString(requestId))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "access_token", newJString(accessToken))
  add(query_578977, "upload_protocol", newJString(uploadProtocol))
  result = call_578975.call(path_578976, query_578977, nil, nil, nil)

var dataprocProjectsRegionsClustersDelete* = Call_DataprocProjectsRegionsClustersDelete_578955(
    name: "dataprocProjectsRegionsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersDelete_578956, base: "/",
    url: url_DataprocProjectsRegionsClustersDelete_578957, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDiagnose_579004 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsClustersDiagnose_579006(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersDiagnose_579005(path: JsonNode;
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
  var valid_579007 = path.getOrDefault("clusterName")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "clusterName", valid_579007
  var valid_579008 = path.getOrDefault("projectId")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "projectId", valid_579008
  var valid_579009 = path.getOrDefault("region")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "region", valid_579009
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
  var valid_579010 = query.getOrDefault("key")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "key", valid_579010
  var valid_579011 = query.getOrDefault("prettyPrint")
  valid_579011 = validateParameter(valid_579011, JBool, required = false,
                                 default = newJBool(true))
  if valid_579011 != nil:
    section.add "prettyPrint", valid_579011
  var valid_579012 = query.getOrDefault("oauth_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "oauth_token", valid_579012
  var valid_579013 = query.getOrDefault("$.xgafv")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("1"))
  if valid_579013 != nil:
    section.add "$.xgafv", valid_579013
  var valid_579014 = query.getOrDefault("alt")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("json"))
  if valid_579014 != nil:
    section.add "alt", valid_579014
  var valid_579015 = query.getOrDefault("uploadType")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "uploadType", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("callback")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "callback", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  var valid_579019 = query.getOrDefault("access_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "access_token", valid_579019
  var valid_579020 = query.getOrDefault("upload_protocol")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "upload_protocol", valid_579020
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

proc call*(call_579022: Call_DataprocProjectsRegionsClustersDiagnose_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. The returned Operation.metadata will be ClusterOperationMetadata. After the operation completes, Operation.response contains DiagnoseClusterResults.
  ## 
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_DataprocProjectsRegionsClustersDiagnose_579004;
          clusterName: string; projectId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersDiagnose
  ## Gets cluster diagnostic information. The returned Operation.metadata will be ClusterOperationMetadata. After the operation completes, Operation.response contains DiagnoseClusterResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clusterName: string (required)
  ##              : Required. The cluster name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579024 = newJObject()
  var query_579025 = newJObject()
  var body_579026 = newJObject()
  add(query_579025, "key", newJString(key))
  add(path_579024, "clusterName", newJString(clusterName))
  add(query_579025, "prettyPrint", newJBool(prettyPrint))
  add(query_579025, "oauth_token", newJString(oauthToken))
  add(path_579024, "projectId", newJString(projectId))
  add(query_579025, "$.xgafv", newJString(Xgafv))
  add(query_579025, "alt", newJString(alt))
  add(query_579025, "uploadType", newJString(uploadType))
  add(query_579025, "quotaUser", newJString(quotaUser))
  add(path_579024, "region", newJString(region))
  if body != nil:
    body_579026 = body
  add(query_579025, "callback", newJString(callback))
  add(query_579025, "fields", newJString(fields))
  add(query_579025, "access_token", newJString(accessToken))
  add(query_579025, "upload_protocol", newJString(uploadProtocol))
  result = call_579023.call(path_579024, query_579025, nil, nil, body_579026)

var dataprocProjectsRegionsClustersDiagnose* = Call_DataprocProjectsRegionsClustersDiagnose_579004(
    name: "dataprocProjectsRegionsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsRegionsClustersDiagnose_579005, base: "/",
    url: url_DataprocProjectsRegionsClustersDiagnose_579006,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsList_579027 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsJobsList_579029(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsList_579028(path: JsonNode;
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
  var valid_579030 = path.getOrDefault("projectId")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "projectId", valid_579030
  var valid_579031 = path.getOrDefault("region")
  valid_579031 = validateParameter(valid_579031, JString, required = true,
                                 default = nil)
  if valid_579031 != nil:
    section.add "region", valid_579031
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
  ##           : Optional. The number of results to return in each response.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Optional. A filter constraining the jobs to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is status.state or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be either ACTIVE or NON_ACTIVE. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND labels.env = staging AND labels.starred = *
  ##   pageToken: JString
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
  ##   jobStateMatcher: JString
  ##                  : Optional. Specifies enumerated categories of jobs to list. (default = match ALL jobs).If filter is provided, jobStateMatcher will be ignored.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clusterName: JString
  ##              : Optional. If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  section = newJObject()
  var valid_579032 = query.getOrDefault("key")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "key", valid_579032
  var valid_579033 = query.getOrDefault("prettyPrint")
  valid_579033 = validateParameter(valid_579033, JBool, required = false,
                                 default = newJBool(true))
  if valid_579033 != nil:
    section.add "prettyPrint", valid_579033
  var valid_579034 = query.getOrDefault("oauth_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "oauth_token", valid_579034
  var valid_579035 = query.getOrDefault("$.xgafv")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = newJString("1"))
  if valid_579035 != nil:
    section.add "$.xgafv", valid_579035
  var valid_579036 = query.getOrDefault("pageSize")
  valid_579036 = validateParameter(valid_579036, JInt, required = false, default = nil)
  if valid_579036 != nil:
    section.add "pageSize", valid_579036
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
  var valid_579040 = query.getOrDefault("filter")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "filter", valid_579040
  var valid_579041 = query.getOrDefault("pageToken")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "pageToken", valid_579041
  var valid_579042 = query.getOrDefault("jobStateMatcher")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("ALL"))
  if valid_579042 != nil:
    section.add "jobStateMatcher", valid_579042
  var valid_579043 = query.getOrDefault("callback")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "callback", valid_579043
  var valid_579044 = query.getOrDefault("fields")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "fields", valid_579044
  var valid_579045 = query.getOrDefault("access_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "access_token", valid_579045
  var valid_579046 = query.getOrDefault("upload_protocol")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "upload_protocol", valid_579046
  var valid_579047 = query.getOrDefault("clusterName")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "clusterName", valid_579047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579048: Call_DataprocProjectsRegionsJobsList_579027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists regions/{region}/jobs in a project.
  ## 
  let valid = call_579048.validator(path, query, header, formData, body)
  let scheme = call_579048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579048.url(scheme.get, call_579048.host, call_579048.base,
                         call_579048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579048, url, valid)

proc call*(call_579049: Call_DataprocProjectsRegionsJobsList_579027;
          projectId: string; region: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; jobStateMatcher: string = "ALL";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clusterName: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsList
  ## Lists regions/{region}/jobs in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The number of results to return in each response.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   filter: string
  ##         : Optional. A filter constraining the jobs to list. Filters are case-sensitive and have the following syntax:field = value AND field = value ...where field is status.state or labels.[KEY], and [KEY] is a label key. value can be * to match all values. status.state can be either ACTIVE or NON_ACTIVE. Only the logical AND operator is supported; space-separated items are treated as having an implicit AND operator.Example filter:status.state = ACTIVE AND labels.env = staging AND labels.starred = *
  ##   pageToken: string
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
  ##   jobStateMatcher: string
  ##                  : Optional. Specifies enumerated categories of jobs to list. (default = match ALL jobs).If filter is provided, jobStateMatcher will be ignored.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clusterName: string
  ##              : Optional. If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  var path_579050 = newJObject()
  var query_579051 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(path_579050, "projectId", newJString(projectId))
  add(query_579051, "$.xgafv", newJString(Xgafv))
  add(query_579051, "pageSize", newJInt(pageSize))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "uploadType", newJString(uploadType))
  add(query_579051, "quotaUser", newJString(quotaUser))
  add(path_579050, "region", newJString(region))
  add(query_579051, "filter", newJString(filter))
  add(query_579051, "pageToken", newJString(pageToken))
  add(query_579051, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_579051, "callback", newJString(callback))
  add(query_579051, "fields", newJString(fields))
  add(query_579051, "access_token", newJString(accessToken))
  add(query_579051, "upload_protocol", newJString(uploadProtocol))
  add(query_579051, "clusterName", newJString(clusterName))
  result = call_579049.call(path_579050, query_579051, nil, nil, nil)

var dataprocProjectsRegionsJobsList* = Call_DataprocProjectsRegionsJobsList_579027(
    name: "dataprocProjectsRegionsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs",
    validator: validate_DataprocProjectsRegionsJobsList_579028, base: "/",
    url: url_DataprocProjectsRegionsJobsList_579029, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsGet_579052 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsJobsGet_579054(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsGet_579053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579055 = path.getOrDefault("projectId")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "projectId", valid_579055
  var valid_579056 = path.getOrDefault("jobId")
  valid_579056 = validateParameter(valid_579056, JString, required = true,
                                 default = nil)
  if valid_579056 != nil:
    section.add "jobId", valid_579056
  var valid_579057 = path.getOrDefault("region")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "region", valid_579057
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
  var valid_579058 = query.getOrDefault("key")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "key", valid_579058
  var valid_579059 = query.getOrDefault("prettyPrint")
  valid_579059 = validateParameter(valid_579059, JBool, required = false,
                                 default = newJBool(true))
  if valid_579059 != nil:
    section.add "prettyPrint", valid_579059
  var valid_579060 = query.getOrDefault("oauth_token")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "oauth_token", valid_579060
  var valid_579061 = query.getOrDefault("$.xgafv")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("1"))
  if valid_579061 != nil:
    section.add "$.xgafv", valid_579061
  var valid_579062 = query.getOrDefault("alt")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("json"))
  if valid_579062 != nil:
    section.add "alt", valid_579062
  var valid_579063 = query.getOrDefault("uploadType")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "uploadType", valid_579063
  var valid_579064 = query.getOrDefault("quotaUser")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "quotaUser", valid_579064
  var valid_579065 = query.getOrDefault("callback")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "callback", valid_579065
  var valid_579066 = query.getOrDefault("fields")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "fields", valid_579066
  var valid_579067 = query.getOrDefault("access_token")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "access_token", valid_579067
  var valid_579068 = query.getOrDefault("upload_protocol")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "upload_protocol", valid_579068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579069: Call_DataprocProjectsRegionsJobsGet_579052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_579069.validator(path, query, header, formData, body)
  let scheme = call_579069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579069.url(scheme.get, call_579069.host, call_579069.base,
                         call_579069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579069, url, valid)

proc call*(call_579070: Call_DataprocProjectsRegionsJobsGet_579052;
          projectId: string; jobId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsGet
  ## Gets the resource representation for a job in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required. The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579071 = newJObject()
  var query_579072 = newJObject()
  add(query_579072, "key", newJString(key))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(path_579071, "projectId", newJString(projectId))
  add(path_579071, "jobId", newJString(jobId))
  add(query_579072, "$.xgafv", newJString(Xgafv))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "uploadType", newJString(uploadType))
  add(query_579072, "quotaUser", newJString(quotaUser))
  add(path_579071, "region", newJString(region))
  add(query_579072, "callback", newJString(callback))
  add(query_579072, "fields", newJString(fields))
  add(query_579072, "access_token", newJString(accessToken))
  add(query_579072, "upload_protocol", newJString(uploadProtocol))
  result = call_579070.call(path_579071, query_579072, nil, nil, nil)

var dataprocProjectsRegionsJobsGet* = Call_DataprocProjectsRegionsJobsGet_579052(
    name: "dataprocProjectsRegionsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsGet_579053, base: "/",
    url: url_DataprocProjectsRegionsJobsGet_579054, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsPatch_579094 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsJobsPatch_579096(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsPatch_579095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579097 = path.getOrDefault("projectId")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "projectId", valid_579097
  var valid_579098 = path.getOrDefault("jobId")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "jobId", valid_579098
  var valid_579099 = path.getOrDefault("region")
  valid_579099 = validateParameter(valid_579099, JString, required = true,
                                 default = nil)
  if valid_579099 != nil:
    section.add "region", valid_579099
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
  ##   updateMask: JString
  ##             : Required. Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579100 = query.getOrDefault("key")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "key", valid_579100
  var valid_579101 = query.getOrDefault("prettyPrint")
  valid_579101 = validateParameter(valid_579101, JBool, required = false,
                                 default = newJBool(true))
  if valid_579101 != nil:
    section.add "prettyPrint", valid_579101
  var valid_579102 = query.getOrDefault("oauth_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "oauth_token", valid_579102
  var valid_579103 = query.getOrDefault("$.xgafv")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("1"))
  if valid_579103 != nil:
    section.add "$.xgafv", valid_579103
  var valid_579104 = query.getOrDefault("alt")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("json"))
  if valid_579104 != nil:
    section.add "alt", valid_579104
  var valid_579105 = query.getOrDefault("uploadType")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "uploadType", valid_579105
  var valid_579106 = query.getOrDefault("quotaUser")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "quotaUser", valid_579106
  var valid_579107 = query.getOrDefault("updateMask")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "updateMask", valid_579107
  var valid_579108 = query.getOrDefault("callback")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "callback", valid_579108
  var valid_579109 = query.getOrDefault("fields")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "fields", valid_579109
  var valid_579110 = query.getOrDefault("access_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "access_token", valid_579110
  var valid_579111 = query.getOrDefault("upload_protocol")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "upload_protocol", valid_579111
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

proc call*(call_579113: Call_DataprocProjectsRegionsJobsPatch_579094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_579113.validator(path, query, header, formData, body)
  let scheme = call_579113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579113.url(scheme.get, call_579113.host, call_579113.base,
                         call_579113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579113, url, valid)

proc call*(call_579114: Call_DataprocProjectsRegionsJobsPatch_579094;
          projectId: string; jobId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsPatch
  ## Updates a job in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required. The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Required. Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579115 = newJObject()
  var query_579116 = newJObject()
  var body_579117 = newJObject()
  add(query_579116, "key", newJString(key))
  add(query_579116, "prettyPrint", newJBool(prettyPrint))
  add(query_579116, "oauth_token", newJString(oauthToken))
  add(path_579115, "projectId", newJString(projectId))
  add(path_579115, "jobId", newJString(jobId))
  add(query_579116, "$.xgafv", newJString(Xgafv))
  add(query_579116, "alt", newJString(alt))
  add(query_579116, "uploadType", newJString(uploadType))
  add(query_579116, "quotaUser", newJString(quotaUser))
  add(query_579116, "updateMask", newJString(updateMask))
  add(path_579115, "region", newJString(region))
  if body != nil:
    body_579117 = body
  add(query_579116, "callback", newJString(callback))
  add(query_579116, "fields", newJString(fields))
  add(query_579116, "access_token", newJString(accessToken))
  add(query_579116, "upload_protocol", newJString(uploadProtocol))
  result = call_579114.call(path_579115, query_579116, nil, nil, body_579117)

var dataprocProjectsRegionsJobsPatch* = Call_DataprocProjectsRegionsJobsPatch_579094(
    name: "dataprocProjectsRegionsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsPatch_579095, base: "/",
    url: url_DataprocProjectsRegionsJobsPatch_579096, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsDelete_579073 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsJobsDelete_579075(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsDelete_579074(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579076 = path.getOrDefault("projectId")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "projectId", valid_579076
  var valid_579077 = path.getOrDefault("jobId")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "jobId", valid_579077
  var valid_579078 = path.getOrDefault("region")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "region", valid_579078
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
  var valid_579079 = query.getOrDefault("key")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "key", valid_579079
  var valid_579080 = query.getOrDefault("prettyPrint")
  valid_579080 = validateParameter(valid_579080, JBool, required = false,
                                 default = newJBool(true))
  if valid_579080 != nil:
    section.add "prettyPrint", valid_579080
  var valid_579081 = query.getOrDefault("oauth_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "oauth_token", valid_579081
  var valid_579082 = query.getOrDefault("$.xgafv")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("1"))
  if valid_579082 != nil:
    section.add "$.xgafv", valid_579082
  var valid_579083 = query.getOrDefault("alt")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("json"))
  if valid_579083 != nil:
    section.add "alt", valid_579083
  var valid_579084 = query.getOrDefault("uploadType")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "uploadType", valid_579084
  var valid_579085 = query.getOrDefault("quotaUser")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "quotaUser", valid_579085
  var valid_579086 = query.getOrDefault("callback")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "callback", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
  var valid_579088 = query.getOrDefault("access_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "access_token", valid_579088
  var valid_579089 = query.getOrDefault("upload_protocol")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "upload_protocol", valid_579089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579090: Call_DataprocProjectsRegionsJobsDelete_579073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_DataprocProjectsRegionsJobsDelete_579073;
          projectId: string; jobId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsDelete
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required. The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579092 = newJObject()
  var query_579093 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(path_579092, "projectId", newJString(projectId))
  add(path_579092, "jobId", newJString(jobId))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "quotaUser", newJString(quotaUser))
  add(path_579092, "region", newJString(region))
  add(query_579093, "callback", newJString(callback))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, nil)

var dataprocProjectsRegionsJobsDelete* = Call_DataprocProjectsRegionsJobsDelete_579073(
    name: "dataprocProjectsRegionsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsDelete_579074, base: "/",
    url: url_DataprocProjectsRegionsJobsDelete_579075, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsCancel_579118 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsJobsCancel_579120(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsCancel_579119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required. The job ID.
  ##   region: JString (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579121 = path.getOrDefault("projectId")
  valid_579121 = validateParameter(valid_579121, JString, required = true,
                                 default = nil)
  if valid_579121 != nil:
    section.add "projectId", valid_579121
  var valid_579122 = path.getOrDefault("jobId")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "jobId", valid_579122
  var valid_579123 = path.getOrDefault("region")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "region", valid_579123
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
  var valid_579124 = query.getOrDefault("key")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "key", valid_579124
  var valid_579125 = query.getOrDefault("prettyPrint")
  valid_579125 = validateParameter(valid_579125, JBool, required = false,
                                 default = newJBool(true))
  if valid_579125 != nil:
    section.add "prettyPrint", valid_579125
  var valid_579126 = query.getOrDefault("oauth_token")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "oauth_token", valid_579126
  var valid_579127 = query.getOrDefault("$.xgafv")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = newJString("1"))
  if valid_579127 != nil:
    section.add "$.xgafv", valid_579127
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("uploadType")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "uploadType", valid_579129
  var valid_579130 = query.getOrDefault("quotaUser")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "quotaUser", valid_579130
  var valid_579131 = query.getOrDefault("callback")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "callback", valid_579131
  var valid_579132 = query.getOrDefault("fields")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "fields", valid_579132
  var valid_579133 = query.getOrDefault("access_token")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "access_token", valid_579133
  var valid_579134 = query.getOrDefault("upload_protocol")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "upload_protocol", valid_579134
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

proc call*(call_579136: Call_DataprocProjectsRegionsJobsCancel_579118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ## 
  let valid = call_579136.validator(path, query, header, formData, body)
  let scheme = call_579136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579136.url(scheme.get, call_579136.host, call_579136.base,
                         call_579136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579136, url, valid)

proc call*(call_579137: Call_DataprocProjectsRegionsJobsCancel_579118;
          projectId: string; jobId: string; region: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsCancel
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required. The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579138 = newJObject()
  var query_579139 = newJObject()
  var body_579140 = newJObject()
  add(query_579139, "key", newJString(key))
  add(query_579139, "prettyPrint", newJBool(prettyPrint))
  add(query_579139, "oauth_token", newJString(oauthToken))
  add(path_579138, "projectId", newJString(projectId))
  add(path_579138, "jobId", newJString(jobId))
  add(query_579139, "$.xgafv", newJString(Xgafv))
  add(query_579139, "alt", newJString(alt))
  add(query_579139, "uploadType", newJString(uploadType))
  add(query_579139, "quotaUser", newJString(quotaUser))
  add(path_579138, "region", newJString(region))
  if body != nil:
    body_579140 = body
  add(query_579139, "callback", newJString(callback))
  add(query_579139, "fields", newJString(fields))
  add(query_579139, "access_token", newJString(accessToken))
  add(query_579139, "upload_protocol", newJString(uploadProtocol))
  result = call_579137.call(path_579138, query_579139, nil, nil, body_579140)

var dataprocProjectsRegionsJobsCancel* = Call_DataprocProjectsRegionsJobsCancel_579118(
    name: "dataprocProjectsRegionsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsRegionsJobsCancel_579119, base: "/",
    url: url_DataprocProjectsRegionsJobsCancel_579120, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsSubmit_579141 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsJobsSubmit_579143(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsSubmit_579142(path: JsonNode;
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
  var valid_579144 = path.getOrDefault("projectId")
  valid_579144 = validateParameter(valid_579144, JString, required = true,
                                 default = nil)
  if valid_579144 != nil:
    section.add "projectId", valid_579144
  var valid_579145 = path.getOrDefault("region")
  valid_579145 = validateParameter(valid_579145, JString, required = true,
                                 default = nil)
  if valid_579145 != nil:
    section.add "region", valid_579145
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
  var valid_579146 = query.getOrDefault("key")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "key", valid_579146
  var valid_579147 = query.getOrDefault("prettyPrint")
  valid_579147 = validateParameter(valid_579147, JBool, required = false,
                                 default = newJBool(true))
  if valid_579147 != nil:
    section.add "prettyPrint", valid_579147
  var valid_579148 = query.getOrDefault("oauth_token")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "oauth_token", valid_579148
  var valid_579149 = query.getOrDefault("$.xgafv")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = newJString("1"))
  if valid_579149 != nil:
    section.add "$.xgafv", valid_579149
  var valid_579150 = query.getOrDefault("alt")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("json"))
  if valid_579150 != nil:
    section.add "alt", valid_579150
  var valid_579151 = query.getOrDefault("uploadType")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "uploadType", valid_579151
  var valid_579152 = query.getOrDefault("quotaUser")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "quotaUser", valid_579152
  var valid_579153 = query.getOrDefault("callback")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "callback", valid_579153
  var valid_579154 = query.getOrDefault("fields")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "fields", valid_579154
  var valid_579155 = query.getOrDefault("access_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "access_token", valid_579155
  var valid_579156 = query.getOrDefault("upload_protocol")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "upload_protocol", valid_579156
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

proc call*(call_579158: Call_DataprocProjectsRegionsJobsSubmit_579141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_579158.validator(path, query, header, formData, body)
  let scheme = call_579158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579158.url(scheme.get, call_579158.host, call_579158.base,
                         call_579158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579158, url, valid)

proc call*(call_579159: Call_DataprocProjectsRegionsJobsSubmit_579141;
          projectId: string; region: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsSubmit
  ## Submits a job to a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   region: string (required)
  ##         : Required. The Cloud Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579160 = newJObject()
  var query_579161 = newJObject()
  var body_579162 = newJObject()
  add(query_579161, "key", newJString(key))
  add(query_579161, "prettyPrint", newJBool(prettyPrint))
  add(query_579161, "oauth_token", newJString(oauthToken))
  add(path_579160, "projectId", newJString(projectId))
  add(query_579161, "$.xgafv", newJString(Xgafv))
  add(query_579161, "alt", newJString(alt))
  add(query_579161, "uploadType", newJString(uploadType))
  add(query_579161, "quotaUser", newJString(quotaUser))
  add(path_579160, "region", newJString(region))
  if body != nil:
    body_579162 = body
  add(query_579161, "callback", newJString(callback))
  add(query_579161, "fields", newJString(fields))
  add(query_579161, "access_token", newJString(accessToken))
  add(query_579161, "upload_protocol", newJString(uploadProtocol))
  result = call_579159.call(path_579160, query_579161, nil, nil, body_579162)

var dataprocProjectsRegionsJobsSubmit* = Call_DataprocProjectsRegionsJobsSubmit_579141(
    name: "dataprocProjectsRegionsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs:submit",
    validator: validate_DataprocProjectsRegionsJobsSubmit_579142, base: "/",
    url: url_DataprocProjectsRegionsJobsSubmit_579143, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_579185 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesUpdate_579187(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesUpdate_579186(
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
  var valid_579188 = path.getOrDefault("name")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "name", valid_579188
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("$.xgafv")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("1"))
  if valid_579192 != nil:
    section.add "$.xgafv", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("uploadType")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "uploadType", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("callback")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "callback", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
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

proc call*(call_579201: Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_579185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates (replaces) workflow template. The updated template must contain version that matches the current server version.
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_579185;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesUpdate
  ## Updates (replaces) workflow template. The updated template must contain version that matches the current server version.
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
  ##       : Output only. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates, the resource name of the  template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates, the resource name of the  template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  var body_579205 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "$.xgafv", newJString(Xgafv))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "uploadType", newJString(uploadType))
  add(query_579204, "quotaUser", newJString(quotaUser))
  add(path_579203, "name", newJString(name))
  if body != nil:
    body_579205 = body
  add(query_579204, "callback", newJString(callback))
  add(query_579204, "fields", newJString(fields))
  add(query_579204, "access_token", newJString(accessToken))
  add(query_579204, "upload_protocol", newJString(uploadProtocol))
  result = call_579202.call(path_579203, query_579204, nil, nil, body_579205)

var dataprocProjectsRegionsWorkflowTemplatesUpdate* = Call_DataprocProjectsRegionsWorkflowTemplatesUpdate_579185(
    name: "dataprocProjectsRegionsWorkflowTemplatesUpdate",
    meth: HttpMethod.HttpPut, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesUpdate_579186,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesUpdate_579187,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesGet_579163 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesGet_579165(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesGet_579164(path: JsonNode;
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
  var valid_579166 = path.getOrDefault("name")
  valid_579166 = validateParameter(valid_579166, JString, required = true,
                                 default = nil)
  if valid_579166 != nil:
    section.add "name", valid_579166
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   version: JInt
  ##          : Optional. The version of workflow template to retrieve. Only previously instantiated versions can be retrieved.If unspecified, retrieves the current version.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579167 = query.getOrDefault("key")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "key", valid_579167
  var valid_579168 = query.getOrDefault("prettyPrint")
  valid_579168 = validateParameter(valid_579168, JBool, required = false,
                                 default = newJBool(true))
  if valid_579168 != nil:
    section.add "prettyPrint", valid_579168
  var valid_579169 = query.getOrDefault("oauth_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "oauth_token", valid_579169
  var valid_579170 = query.getOrDefault("$.xgafv")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = newJString("1"))
  if valid_579170 != nil:
    section.add "$.xgafv", valid_579170
  var valid_579171 = query.getOrDefault("pageSize")
  valid_579171 = validateParameter(valid_579171, JInt, required = false, default = nil)
  if valid_579171 != nil:
    section.add "pageSize", valid_579171
  var valid_579172 = query.getOrDefault("alt")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("json"))
  if valid_579172 != nil:
    section.add "alt", valid_579172
  var valid_579173 = query.getOrDefault("uploadType")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "uploadType", valid_579173
  var valid_579174 = query.getOrDefault("version")
  valid_579174 = validateParameter(valid_579174, JInt, required = false, default = nil)
  if valid_579174 != nil:
    section.add "version", valid_579174
  var valid_579175 = query.getOrDefault("quotaUser")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "quotaUser", valid_579175
  var valid_579176 = query.getOrDefault("pageToken")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "pageToken", valid_579176
  var valid_579177 = query.getOrDefault("callback")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "callback", valid_579177
  var valid_579178 = query.getOrDefault("fields")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "fields", valid_579178
  var valid_579179 = query.getOrDefault("access_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "access_token", valid_579179
  var valid_579180 = query.getOrDefault("upload_protocol")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "upload_protocol", valid_579180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579181: Call_DataprocProjectsRegionsWorkflowTemplatesGet_579163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the latest workflow template.Can retrieve previously instantiated template by specifying optional version parameter.
  ## 
  let valid = call_579181.validator(path, query, header, formData, body)
  let scheme = call_579181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579181.url(scheme.get, call_579181.host, call_579181.base,
                         call_579181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579181, url, valid)

proc call*(call_579182: Call_DataprocProjectsRegionsWorkflowTemplatesGet_579163;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; version: int = 0;
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesGet
  ## Retrieves the latest workflow template.Can retrieve previously instantiated template by specifying optional version parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   version: int
  ##          : Optional. The version of workflow template to retrieve. Only previously instantiated versions can be retrieved.If unspecified, retrieves the current version.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.get, the resource name of the  template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.get, the resource name of the  template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579183 = newJObject()
  var query_579184 = newJObject()
  add(query_579184, "key", newJString(key))
  add(query_579184, "prettyPrint", newJBool(prettyPrint))
  add(query_579184, "oauth_token", newJString(oauthToken))
  add(query_579184, "$.xgafv", newJString(Xgafv))
  add(query_579184, "pageSize", newJInt(pageSize))
  add(query_579184, "alt", newJString(alt))
  add(query_579184, "uploadType", newJString(uploadType))
  add(query_579184, "version", newJInt(version))
  add(query_579184, "quotaUser", newJString(quotaUser))
  add(path_579183, "name", newJString(name))
  add(query_579184, "pageToken", newJString(pageToken))
  add(query_579184, "callback", newJString(callback))
  add(query_579184, "fields", newJString(fields))
  add(query_579184, "access_token", newJString(accessToken))
  add(query_579184, "upload_protocol", newJString(uploadProtocol))
  result = call_579182.call(path_579183, query_579184, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesGet* = Call_DataprocProjectsRegionsWorkflowTemplatesGet_579163(
    name: "dataprocProjectsRegionsWorkflowTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesGet_579164,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesGet_579165,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesDelete_579206 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesDelete_579208(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesDelete_579207(
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
  var valid_579209 = path.getOrDefault("name")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "name", valid_579209
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
  ##   version: JInt
  ##          : Optional. The version of workflow template to delete. If specified, will only delete the template if the current server version matches specified version.
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
  var valid_579210 = query.getOrDefault("key")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "key", valid_579210
  var valid_579211 = query.getOrDefault("prettyPrint")
  valid_579211 = validateParameter(valid_579211, JBool, required = false,
                                 default = newJBool(true))
  if valid_579211 != nil:
    section.add "prettyPrint", valid_579211
  var valid_579212 = query.getOrDefault("oauth_token")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "oauth_token", valid_579212
  var valid_579213 = query.getOrDefault("$.xgafv")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("1"))
  if valid_579213 != nil:
    section.add "$.xgafv", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("uploadType")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "uploadType", valid_579215
  var valid_579216 = query.getOrDefault("version")
  valid_579216 = validateParameter(valid_579216, JInt, required = false, default = nil)
  if valid_579216 != nil:
    section.add "version", valid_579216
  var valid_579217 = query.getOrDefault("quotaUser")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "quotaUser", valid_579217
  var valid_579218 = query.getOrDefault("callback")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "callback", valid_579218
  var valid_579219 = query.getOrDefault("fields")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "fields", valid_579219
  var valid_579220 = query.getOrDefault("access_token")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "access_token", valid_579220
  var valid_579221 = query.getOrDefault("upload_protocol")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "upload_protocol", valid_579221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579222: Call_DataprocProjectsRegionsWorkflowTemplatesDelete_579206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a workflow template. It does not cancel in-progress workflows.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_DataprocProjectsRegionsWorkflowTemplatesDelete_579206;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; version: int = 0; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesDelete
  ## Deletes a workflow template. It does not cancel in-progress workflows.
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
  ##   version: int
  ##          : Optional. The version of workflow template to delete. If specified, will only delete the template if the current server version matches specified version.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.delete, the resource name of the template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.instantiate, the resource name  of the template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "$.xgafv", newJString(Xgafv))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "uploadType", newJString(uploadType))
  add(query_579225, "version", newJInt(version))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(path_579224, "name", newJString(name))
  add(query_579225, "callback", newJString(callback))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "access_token", newJString(accessToken))
  add(query_579225, "upload_protocol", newJString(uploadProtocol))
  result = call_579223.call(path_579224, query_579225, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesDelete* = Call_DataprocProjectsRegionsWorkflowTemplatesDelete_579206(
    name: "dataprocProjectsRegionsWorkflowTemplatesDelete",
    meth: HttpMethod.HttpDelete, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesDelete_579207,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesDelete_579208,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsOperationsCancel_579226 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsOperationsCancel_579228(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsOperationsCancel_579227(path: JsonNode;
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
  var valid_579229 = path.getOrDefault("name")
  valid_579229 = validateParameter(valid_579229, JString, required = true,
                                 default = nil)
  if valid_579229 != nil:
    section.add "name", valid_579229
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
  var valid_579230 = query.getOrDefault("key")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "key", valid_579230
  var valid_579231 = query.getOrDefault("prettyPrint")
  valid_579231 = validateParameter(valid_579231, JBool, required = false,
                                 default = newJBool(true))
  if valid_579231 != nil:
    section.add "prettyPrint", valid_579231
  var valid_579232 = query.getOrDefault("oauth_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "oauth_token", valid_579232
  var valid_579233 = query.getOrDefault("$.xgafv")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("1"))
  if valid_579233 != nil:
    section.add "$.xgafv", valid_579233
  var valid_579234 = query.getOrDefault("alt")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("json"))
  if valid_579234 != nil:
    section.add "alt", valid_579234
  var valid_579235 = query.getOrDefault("uploadType")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "uploadType", valid_579235
  var valid_579236 = query.getOrDefault("quotaUser")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "quotaUser", valid_579236
  var valid_579237 = query.getOrDefault("callback")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "callback", valid_579237
  var valid_579238 = query.getOrDefault("fields")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "fields", valid_579238
  var valid_579239 = query.getOrDefault("access_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "access_token", valid_579239
  var valid_579240 = query.getOrDefault("upload_protocol")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "upload_protocol", valid_579240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579241: Call_DataprocProjectsRegionsOperationsCancel_579226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_579241.validator(path, query, header, formData, body)
  let scheme = call_579241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579241.url(scheme.get, call_579241.host, call_579241.base,
                         call_579241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579241, url, valid)

proc call*(call_579242: Call_DataprocProjectsRegionsOperationsCancel_579226;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579243 = newJObject()
  var query_579244 = newJObject()
  add(query_579244, "key", newJString(key))
  add(query_579244, "prettyPrint", newJBool(prettyPrint))
  add(query_579244, "oauth_token", newJString(oauthToken))
  add(query_579244, "$.xgafv", newJString(Xgafv))
  add(query_579244, "alt", newJString(alt))
  add(query_579244, "uploadType", newJString(uploadType))
  add(query_579244, "quotaUser", newJString(quotaUser))
  add(path_579243, "name", newJString(name))
  add(query_579244, "callback", newJString(callback))
  add(query_579244, "fields", newJString(fields))
  add(query_579244, "access_token", newJString(accessToken))
  add(query_579244, "upload_protocol", newJString(uploadProtocol))
  result = call_579242.call(path_579243, query_579244, nil, nil, nil)

var dataprocProjectsRegionsOperationsCancel* = Call_DataprocProjectsRegionsOperationsCancel_579226(
    name: "dataprocProjectsRegionsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/{name}:cancel",
    validator: validate_DataprocProjectsRegionsOperationsCancel_579227, base: "/",
    url: url_DataprocProjectsRegionsOperationsCancel_579228,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579245 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579247(
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579246(
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
  var valid_579248 = path.getOrDefault("name")
  valid_579248 = validateParameter(valid_579248, JString, required = true,
                                 default = nil)
  if valid_579248 != nil:
    section.add "name", valid_579248
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
  var valid_579249 = query.getOrDefault("key")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "key", valid_579249
  var valid_579250 = query.getOrDefault("prettyPrint")
  valid_579250 = validateParameter(valid_579250, JBool, required = false,
                                 default = newJBool(true))
  if valid_579250 != nil:
    section.add "prettyPrint", valid_579250
  var valid_579251 = query.getOrDefault("oauth_token")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "oauth_token", valid_579251
  var valid_579252 = query.getOrDefault("$.xgafv")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = newJString("1"))
  if valid_579252 != nil:
    section.add "$.xgafv", valid_579252
  var valid_579253 = query.getOrDefault("alt")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("json"))
  if valid_579253 != nil:
    section.add "alt", valid_579253
  var valid_579254 = query.getOrDefault("uploadType")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "uploadType", valid_579254
  var valid_579255 = query.getOrDefault("quotaUser")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "quotaUser", valid_579255
  var valid_579256 = query.getOrDefault("callback")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "callback", valid_579256
  var valid_579257 = query.getOrDefault("fields")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "fields", valid_579257
  var valid_579258 = query.getOrDefault("access_token")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "access_token", valid_579258
  var valid_579259 = query.getOrDefault("upload_protocol")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "upload_protocol", valid_579259
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

proc call*(call_579261: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_579261.validator(path, query, header, formData, body)
  let scheme = call_579261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579261.url(scheme.get, call_579261.host, call_579261.base,
                         call_579261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579261, url, valid)

proc call*(call_579262: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579245;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesInstantiate
  ## Instantiates a template and begins execution.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
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
  ##       : Required. The resource name of the workflow template, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates.instantiate, the resource name of the template has the following format:  projects/{project_id}/regions/{region}/workflowTemplates/{template_id}
  ## For projects.locations.workflowTemplates.instantiate, the resource name  of the template has the following format:  projects/{project_id}/locations/{location}/workflowTemplates/{template_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579263 = newJObject()
  var query_579264 = newJObject()
  var body_579265 = newJObject()
  add(query_579264, "key", newJString(key))
  add(query_579264, "prettyPrint", newJBool(prettyPrint))
  add(query_579264, "oauth_token", newJString(oauthToken))
  add(query_579264, "$.xgafv", newJString(Xgafv))
  add(query_579264, "alt", newJString(alt))
  add(query_579264, "uploadType", newJString(uploadType))
  add(query_579264, "quotaUser", newJString(quotaUser))
  add(path_579263, "name", newJString(name))
  if body != nil:
    body_579265 = body
  add(query_579264, "callback", newJString(callback))
  add(query_579264, "fields", newJString(fields))
  add(query_579264, "access_token", newJString(accessToken))
  add(query_579264, "upload_protocol", newJString(uploadProtocol))
  result = call_579262.call(path_579263, query_579264, nil, nil, body_579265)

var dataprocProjectsRegionsWorkflowTemplatesInstantiate* = Call_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579245(
    name: "dataprocProjectsRegionsWorkflowTemplatesInstantiate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}:instantiate",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579246,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesInstantiate_579247,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_579287 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsAutoscalingPoliciesCreate_579289(
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

proc validate_DataprocProjectsRegionsAutoscalingPoliciesCreate_579288(
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
  var valid_579290 = path.getOrDefault("parent")
  valid_579290 = validateParameter(valid_579290, JString, required = true,
                                 default = nil)
  if valid_579290 != nil:
    section.add "parent", valid_579290
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
  var valid_579291 = query.getOrDefault("key")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "key", valid_579291
  var valid_579292 = query.getOrDefault("prettyPrint")
  valid_579292 = validateParameter(valid_579292, JBool, required = false,
                                 default = newJBool(true))
  if valid_579292 != nil:
    section.add "prettyPrint", valid_579292
  var valid_579293 = query.getOrDefault("oauth_token")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "oauth_token", valid_579293
  var valid_579294 = query.getOrDefault("$.xgafv")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = newJString("1"))
  if valid_579294 != nil:
    section.add "$.xgafv", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("uploadType")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "uploadType", valid_579296
  var valid_579297 = query.getOrDefault("quotaUser")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "quotaUser", valid_579297
  var valid_579298 = query.getOrDefault("callback")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "callback", valid_579298
  var valid_579299 = query.getOrDefault("fields")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "fields", valid_579299
  var valid_579300 = query.getOrDefault("access_token")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "access_token", valid_579300
  var valid_579301 = query.getOrDefault("upload_protocol")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "upload_protocol", valid_579301
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

proc call*(call_579303: Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_579287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new autoscaling policy.
  ## 
  let valid = call_579303.validator(path, query, header, formData, body)
  let scheme = call_579303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579303.url(scheme.get, call_579303.host, call_579303.base,
                         call_579303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579303, url, valid)

proc call*(call_579304: Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_579287;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsAutoscalingPoliciesCreate
  ## Creates new autoscaling policy.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The "resource name" of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.create, the resource name  has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.autoscalingPolicies.create, the resource name  has the following format:  projects/{project_id}/locations/{location}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579305 = newJObject()
  var query_579306 = newJObject()
  var body_579307 = newJObject()
  add(query_579306, "key", newJString(key))
  add(query_579306, "prettyPrint", newJBool(prettyPrint))
  add(query_579306, "oauth_token", newJString(oauthToken))
  add(query_579306, "$.xgafv", newJString(Xgafv))
  add(query_579306, "alt", newJString(alt))
  add(query_579306, "uploadType", newJString(uploadType))
  add(query_579306, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579307 = body
  add(query_579306, "callback", newJString(callback))
  add(path_579305, "parent", newJString(parent))
  add(query_579306, "fields", newJString(fields))
  add(query_579306, "access_token", newJString(accessToken))
  add(query_579306, "upload_protocol", newJString(uploadProtocol))
  result = call_579304.call(path_579305, query_579306, nil, nil, body_579307)

var dataprocProjectsRegionsAutoscalingPoliciesCreate* = Call_DataprocProjectsRegionsAutoscalingPoliciesCreate_579287(
    name: "dataprocProjectsRegionsAutoscalingPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsRegionsAutoscalingPoliciesCreate_579288,
    base: "/", url: url_DataprocProjectsRegionsAutoscalingPoliciesCreate_579289,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsAutoscalingPoliciesList_579266 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsAutoscalingPoliciesList_579268(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsAutoscalingPoliciesList_579267(
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
  var valid_579269 = path.getOrDefault("parent")
  valid_579269 = validateParameter(valid_579269, JString, required = true,
                                 default = nil)
  if valid_579269 != nil:
    section.add "parent", valid_579269
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
  ##           : Optional. The maximum number of results to return in each response. Must be less than or equal to 1000. Defaults to 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579270 = query.getOrDefault("key")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "key", valid_579270
  var valid_579271 = query.getOrDefault("prettyPrint")
  valid_579271 = validateParameter(valid_579271, JBool, required = false,
                                 default = newJBool(true))
  if valid_579271 != nil:
    section.add "prettyPrint", valid_579271
  var valid_579272 = query.getOrDefault("oauth_token")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "oauth_token", valid_579272
  var valid_579273 = query.getOrDefault("$.xgafv")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("1"))
  if valid_579273 != nil:
    section.add "$.xgafv", valid_579273
  var valid_579274 = query.getOrDefault("pageSize")
  valid_579274 = validateParameter(valid_579274, JInt, required = false, default = nil)
  if valid_579274 != nil:
    section.add "pageSize", valid_579274
  var valid_579275 = query.getOrDefault("alt")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("json"))
  if valid_579275 != nil:
    section.add "alt", valid_579275
  var valid_579276 = query.getOrDefault("uploadType")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "uploadType", valid_579276
  var valid_579277 = query.getOrDefault("quotaUser")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "quotaUser", valid_579277
  var valid_579278 = query.getOrDefault("pageToken")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "pageToken", valid_579278
  var valid_579279 = query.getOrDefault("callback")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "callback", valid_579279
  var valid_579280 = query.getOrDefault("fields")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "fields", valid_579280
  var valid_579281 = query.getOrDefault("access_token")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "access_token", valid_579281
  var valid_579282 = query.getOrDefault("upload_protocol")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "upload_protocol", valid_579282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579283: Call_DataprocProjectsRegionsAutoscalingPoliciesList_579266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists autoscaling policies in the project.
  ## 
  let valid = call_579283.validator(path, query, header, formData, body)
  let scheme = call_579283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579283.url(scheme.get, call_579283.host, call_579283.base,
                         call_579283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579283, url, valid)

proc call*(call_579284: Call_DataprocProjectsRegionsAutoscalingPoliciesList_579266;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsAutoscalingPoliciesList
  ## Lists autoscaling policies in the project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return in each response. Must be less than or equal to 1000. Defaults to 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The "resource name" of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.autoscalingPolicies.list, the resource name  of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.autoscalingPolicies.list, the resource name  of the location has the following format:  projects/{project_id}/locations/{location}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579285 = newJObject()
  var query_579286 = newJObject()
  add(query_579286, "key", newJString(key))
  add(query_579286, "prettyPrint", newJBool(prettyPrint))
  add(query_579286, "oauth_token", newJString(oauthToken))
  add(query_579286, "$.xgafv", newJString(Xgafv))
  add(query_579286, "pageSize", newJInt(pageSize))
  add(query_579286, "alt", newJString(alt))
  add(query_579286, "uploadType", newJString(uploadType))
  add(query_579286, "quotaUser", newJString(quotaUser))
  add(query_579286, "pageToken", newJString(pageToken))
  add(query_579286, "callback", newJString(callback))
  add(path_579285, "parent", newJString(parent))
  add(query_579286, "fields", newJString(fields))
  add(query_579286, "access_token", newJString(accessToken))
  add(query_579286, "upload_protocol", newJString(uploadProtocol))
  result = call_579284.call(path_579285, query_579286, nil, nil, nil)

var dataprocProjectsRegionsAutoscalingPoliciesList* = Call_DataprocProjectsRegionsAutoscalingPoliciesList_579266(
    name: "dataprocProjectsRegionsAutoscalingPoliciesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsRegionsAutoscalingPoliciesList_579267,
    base: "/", url: url_DataprocProjectsRegionsAutoscalingPoliciesList_579268,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesCreate_579329 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesCreate_579331(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesCreate_579330(
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
  var valid_579332 = path.getOrDefault("parent")
  valid_579332 = validateParameter(valid_579332, JString, required = true,
                                 default = nil)
  if valid_579332 != nil:
    section.add "parent", valid_579332
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
  var valid_579333 = query.getOrDefault("key")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "key", valid_579333
  var valid_579334 = query.getOrDefault("prettyPrint")
  valid_579334 = validateParameter(valid_579334, JBool, required = false,
                                 default = newJBool(true))
  if valid_579334 != nil:
    section.add "prettyPrint", valid_579334
  var valid_579335 = query.getOrDefault("oauth_token")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "oauth_token", valid_579335
  var valid_579336 = query.getOrDefault("$.xgafv")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = newJString("1"))
  if valid_579336 != nil:
    section.add "$.xgafv", valid_579336
  var valid_579337 = query.getOrDefault("alt")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = newJString("json"))
  if valid_579337 != nil:
    section.add "alt", valid_579337
  var valid_579338 = query.getOrDefault("uploadType")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "uploadType", valid_579338
  var valid_579339 = query.getOrDefault("quotaUser")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "quotaUser", valid_579339
  var valid_579340 = query.getOrDefault("callback")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "callback", valid_579340
  var valid_579341 = query.getOrDefault("fields")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "fields", valid_579341
  var valid_579342 = query.getOrDefault("access_token")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "access_token", valid_579342
  var valid_579343 = query.getOrDefault("upload_protocol")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "upload_protocol", valid_579343
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

proc call*(call_579345: Call_DataprocProjectsRegionsWorkflowTemplatesCreate_579329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new workflow template.
  ## 
  let valid = call_579345.validator(path, query, header, formData, body)
  let scheme = call_579345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579345.url(scheme.get, call_579345.host, call_579345.base,
                         call_579345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579345, url, valid)

proc call*(call_579346: Call_DataprocProjectsRegionsWorkflowTemplatesCreate_579329;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesCreate
  ## Creates new workflow template.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,create, the resource name of the  region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.create, the resource name of  the location has the following format:  projects/{project_id}/locations/{location}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579347 = newJObject()
  var query_579348 = newJObject()
  var body_579349 = newJObject()
  add(query_579348, "key", newJString(key))
  add(query_579348, "prettyPrint", newJBool(prettyPrint))
  add(query_579348, "oauth_token", newJString(oauthToken))
  add(query_579348, "$.xgafv", newJString(Xgafv))
  add(query_579348, "alt", newJString(alt))
  add(query_579348, "uploadType", newJString(uploadType))
  add(query_579348, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579349 = body
  add(query_579348, "callback", newJString(callback))
  add(path_579347, "parent", newJString(parent))
  add(query_579348, "fields", newJString(fields))
  add(query_579348, "access_token", newJString(accessToken))
  add(query_579348, "upload_protocol", newJString(uploadProtocol))
  result = call_579346.call(path_579347, query_579348, nil, nil, body_579349)

var dataprocProjectsRegionsWorkflowTemplatesCreate* = Call_DataprocProjectsRegionsWorkflowTemplatesCreate_579329(
    name: "dataprocProjectsRegionsWorkflowTemplatesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesCreate_579330,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesCreate_579331,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesList_579308 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesList_579310(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesList_579309(path: JsonNode;
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
  var valid_579311 = path.getOrDefault("parent")
  valid_579311 = validateParameter(valid_579311, JString, required = true,
                                 default = nil)
  if valid_579311 != nil:
    section.add "parent", valid_579311
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
  ##           : Optional. The maximum number of results to return in each response.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579312 = query.getOrDefault("key")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "key", valid_579312
  var valid_579313 = query.getOrDefault("prettyPrint")
  valid_579313 = validateParameter(valid_579313, JBool, required = false,
                                 default = newJBool(true))
  if valid_579313 != nil:
    section.add "prettyPrint", valid_579313
  var valid_579314 = query.getOrDefault("oauth_token")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "oauth_token", valid_579314
  var valid_579315 = query.getOrDefault("$.xgafv")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = newJString("1"))
  if valid_579315 != nil:
    section.add "$.xgafv", valid_579315
  var valid_579316 = query.getOrDefault("pageSize")
  valid_579316 = validateParameter(valid_579316, JInt, required = false, default = nil)
  if valid_579316 != nil:
    section.add "pageSize", valid_579316
  var valid_579317 = query.getOrDefault("alt")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = newJString("json"))
  if valid_579317 != nil:
    section.add "alt", valid_579317
  var valid_579318 = query.getOrDefault("uploadType")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "uploadType", valid_579318
  var valid_579319 = query.getOrDefault("quotaUser")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "quotaUser", valid_579319
  var valid_579320 = query.getOrDefault("pageToken")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "pageToken", valid_579320
  var valid_579321 = query.getOrDefault("callback")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "callback", valid_579321
  var valid_579322 = query.getOrDefault("fields")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "fields", valid_579322
  var valid_579323 = query.getOrDefault("access_token")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "access_token", valid_579323
  var valid_579324 = query.getOrDefault("upload_protocol")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "upload_protocol", valid_579324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579325: Call_DataprocProjectsRegionsWorkflowTemplatesList_579308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists workflows that match the specified filter in the request.
  ## 
  let valid = call_579325.validator(path, query, header, formData, body)
  let scheme = call_579325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579325.url(scheme.get, call_579325.host, call_579325.base,
                         call_579325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579325, url, valid)

proc call*(call_579326: Call_DataprocProjectsRegionsWorkflowTemplatesList_579308;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesList
  ## Lists workflows that match the specified filter in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return in each response.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. The page token, returned by a previous call, to request the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,list, the resource  name of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.list, the  resource name of the location has the following format:  projects/{project_id}/locations/{location}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579327 = newJObject()
  var query_579328 = newJObject()
  add(query_579328, "key", newJString(key))
  add(query_579328, "prettyPrint", newJBool(prettyPrint))
  add(query_579328, "oauth_token", newJString(oauthToken))
  add(query_579328, "$.xgafv", newJString(Xgafv))
  add(query_579328, "pageSize", newJInt(pageSize))
  add(query_579328, "alt", newJString(alt))
  add(query_579328, "uploadType", newJString(uploadType))
  add(query_579328, "quotaUser", newJString(quotaUser))
  add(query_579328, "pageToken", newJString(pageToken))
  add(query_579328, "callback", newJString(callback))
  add(path_579327, "parent", newJString(parent))
  add(query_579328, "fields", newJString(fields))
  add(query_579328, "access_token", newJString(accessToken))
  add(query_579328, "upload_protocol", newJString(uploadProtocol))
  result = call_579326.call(path_579327, query_579328, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesList* = Call_DataprocProjectsRegionsWorkflowTemplatesList_579308(
    name: "dataprocProjectsRegionsWorkflowTemplatesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesList_579309,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesList_579310,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579350 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579352(
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579351(
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
  var valid_579353 = path.getOrDefault("parent")
  valid_579353 = validateParameter(valid_579353, JString, required = true,
                                 default = nil)
  if valid_579353 != nil:
    section.add "parent", valid_579353
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
  ##   instanceId: JString
  ##             : Deprecated. Please use request_id field instead.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   requestId: JString
  ##            : Optional. A tag that prevents multiple concurrent workflow instances with the same tag from running. This mitigates risk of concurrent instances started due to retries.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The tag must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579354 = query.getOrDefault("key")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "key", valid_579354
  var valid_579355 = query.getOrDefault("prettyPrint")
  valid_579355 = validateParameter(valid_579355, JBool, required = false,
                                 default = newJBool(true))
  if valid_579355 != nil:
    section.add "prettyPrint", valid_579355
  var valid_579356 = query.getOrDefault("oauth_token")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "oauth_token", valid_579356
  var valid_579357 = query.getOrDefault("$.xgafv")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = newJString("1"))
  if valid_579357 != nil:
    section.add "$.xgafv", valid_579357
  var valid_579358 = query.getOrDefault("instanceId")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "instanceId", valid_579358
  var valid_579359 = query.getOrDefault("alt")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = newJString("json"))
  if valid_579359 != nil:
    section.add "alt", valid_579359
  var valid_579360 = query.getOrDefault("uploadType")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "uploadType", valid_579360
  var valid_579361 = query.getOrDefault("quotaUser")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "quotaUser", valid_579361
  var valid_579362 = query.getOrDefault("callback")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "callback", valid_579362
  var valid_579363 = query.getOrDefault("requestId")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "requestId", valid_579363
  var valid_579364 = query.getOrDefault("fields")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "fields", valid_579364
  var valid_579365 = query.getOrDefault("access_token")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "access_token", valid_579365
  var valid_579366 = query.getOrDefault("upload_protocol")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "upload_protocol", valid_579366
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

proc call*(call_579368: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.This method is equivalent to executing the sequence CreateWorkflowTemplate, InstantiateWorkflowTemplate, DeleteWorkflowTemplate.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_579368.validator(path, query, header, formData, body)
  let scheme = call_579368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579368.url(scheme.get, call_579368.host, call_579368.base,
                         call_579368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579368, url, valid)

proc call*(call_579369: Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579350;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; instanceId: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; requestId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesInstantiateInline
  ## Instantiates a template and begins execution.This method is equivalent to executing the sequence CreateWorkflowTemplate, InstantiateWorkflowTemplate, DeleteWorkflowTemplate.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   instanceId: string
  ##             : Deprecated. Please use request_id field instead.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the region or location, as described in https://cloud.google.com/apis/design/resource_names.
  ## For projects.regions.workflowTemplates,instantiateinline, the resource  name of the region has the following format:  projects/{project_id}/regions/{region}
  ## For projects.locations.workflowTemplates.instantiateinline, the  resource name of the location has the following format:  projects/{project_id}/locations/{location}
  ##   requestId: string
  ##            : Optional. A tag that prevents multiple concurrent workflow instances with the same tag from running. This mitigates risk of concurrent instances started due to retries.It is recommended to always set this value to a UUID (https://en.wikipedia.org/wiki/Universally_unique_identifier).The tag must contain only letters (a-z, A-Z), numbers (0-9), underscores (_), and hyphens (-). The maximum length is 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579370 = newJObject()
  var query_579371 = newJObject()
  var body_579372 = newJObject()
  add(query_579371, "key", newJString(key))
  add(query_579371, "prettyPrint", newJBool(prettyPrint))
  add(query_579371, "oauth_token", newJString(oauthToken))
  add(query_579371, "$.xgafv", newJString(Xgafv))
  add(query_579371, "instanceId", newJString(instanceId))
  add(query_579371, "alt", newJString(alt))
  add(query_579371, "uploadType", newJString(uploadType))
  add(query_579371, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579372 = body
  add(query_579371, "callback", newJString(callback))
  add(path_579370, "parent", newJString(parent))
  add(query_579371, "requestId", newJString(requestId))
  add(query_579371, "fields", newJString(fields))
  add(query_579371, "access_token", newJString(accessToken))
  add(query_579371, "upload_protocol", newJString(uploadProtocol))
  result = call_579369.call(path_579370, query_579371, nil, nil, body_579372)

var dataprocProjectsRegionsWorkflowTemplatesInstantiateInline* = Call_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579350(
    name: "dataprocProjectsRegionsWorkflowTemplatesInstantiateInline",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates:instantiateInline", validator: validate_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579351,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesInstantiateInline_579352,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579373 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579375(
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579374(
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
  var valid_579376 = path.getOrDefault("resource")
  valid_579376 = validateParameter(valid_579376, JString, required = true,
                                 default = nil)
  if valid_579376 != nil:
    section.add "resource", valid_579376
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.Valid values are 0, 1, and 3. Requests specifying an invalid value will be rejected.Requests for policies with any conditional bindings must specify version 3. Policies without any conditional bindings may specify any valid value or leave the field unset.
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
  var valid_579377 = query.getOrDefault("key")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "key", valid_579377
  var valid_579378 = query.getOrDefault("prettyPrint")
  valid_579378 = validateParameter(valid_579378, JBool, required = false,
                                 default = newJBool(true))
  if valid_579378 != nil:
    section.add "prettyPrint", valid_579378
  var valid_579379 = query.getOrDefault("oauth_token")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "oauth_token", valid_579379
  var valid_579380 = query.getOrDefault("$.xgafv")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = newJString("1"))
  if valid_579380 != nil:
    section.add "$.xgafv", valid_579380
  var valid_579381 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579381 = validateParameter(valid_579381, JInt, required = false, default = nil)
  if valid_579381 != nil:
    section.add "options.requestedPolicyVersion", valid_579381
  var valid_579382 = query.getOrDefault("alt")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = newJString("json"))
  if valid_579382 != nil:
    section.add "alt", valid_579382
  var valid_579383 = query.getOrDefault("uploadType")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "uploadType", valid_579383
  var valid_579384 = query.getOrDefault("quotaUser")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "quotaUser", valid_579384
  var valid_579385 = query.getOrDefault("callback")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "callback", valid_579385
  var valid_579386 = query.getOrDefault("fields")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "fields", valid_579386
  var valid_579387 = query.getOrDefault("access_token")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "access_token", valid_579387
  var valid_579388 = query.getOrDefault("upload_protocol")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "upload_protocol", valid_579388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579389: Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. Returns an empty policy if the resource exists and does not have a policy set.
  ## 
  let valid = call_579389.validator(path, query, header, formData, body)
  let scheme = call_579389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579389.url(scheme.get, call_579389.host, call_579389.base,
                         call_579389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579389, url, valid)

proc call*(call_579390: Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579373;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesGetIamPolicy
  ## Gets the access control policy for a resource. Returns an empty policy if the resource exists and does not have a policy set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.Valid values are 0, 1, and 3. Requests specifying an invalid value will be rejected.Requests for policies with any conditional bindings must specify version 3. Policies without any conditional bindings may specify any valid value or leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested. See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579391 = newJObject()
  var query_579392 = newJObject()
  add(query_579392, "key", newJString(key))
  add(query_579392, "prettyPrint", newJBool(prettyPrint))
  add(query_579392, "oauth_token", newJString(oauthToken))
  add(query_579392, "$.xgafv", newJString(Xgafv))
  add(query_579392, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579392, "alt", newJString(alt))
  add(query_579392, "uploadType", newJString(uploadType))
  add(query_579392, "quotaUser", newJString(quotaUser))
  add(path_579391, "resource", newJString(resource))
  add(query_579392, "callback", newJString(callback))
  add(query_579392, "fields", newJString(fields))
  add(query_579392, "access_token", newJString(accessToken))
  add(query_579392, "upload_protocol", newJString(uploadProtocol))
  result = call_579390.call(path_579391, query_579392, nil, nil, nil)

var dataprocProjectsRegionsWorkflowTemplatesGetIamPolicy* = Call_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579373(
    name: "dataprocProjectsRegionsWorkflowTemplatesGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:getIamPolicy",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579374,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesGetIamPolicy_579375,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579393 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579395(
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579394(
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
  var valid_579396 = path.getOrDefault("resource")
  valid_579396 = validateParameter(valid_579396, JString, required = true,
                                 default = nil)
  if valid_579396 != nil:
    section.add "resource", valid_579396
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
  var valid_579397 = query.getOrDefault("key")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "key", valid_579397
  var valid_579398 = query.getOrDefault("prettyPrint")
  valid_579398 = validateParameter(valid_579398, JBool, required = false,
                                 default = newJBool(true))
  if valid_579398 != nil:
    section.add "prettyPrint", valid_579398
  var valid_579399 = query.getOrDefault("oauth_token")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "oauth_token", valid_579399
  var valid_579400 = query.getOrDefault("$.xgafv")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = newJString("1"))
  if valid_579400 != nil:
    section.add "$.xgafv", valid_579400
  var valid_579401 = query.getOrDefault("alt")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = newJString("json"))
  if valid_579401 != nil:
    section.add "alt", valid_579401
  var valid_579402 = query.getOrDefault("uploadType")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "uploadType", valid_579402
  var valid_579403 = query.getOrDefault("quotaUser")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "quotaUser", valid_579403
  var valid_579404 = query.getOrDefault("callback")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "callback", valid_579404
  var valid_579405 = query.getOrDefault("fields")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "fields", valid_579405
  var valid_579406 = query.getOrDefault("access_token")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "access_token", valid_579406
  var valid_579407 = query.getOrDefault("upload_protocol")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "upload_protocol", valid_579407
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

proc call*(call_579409: Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_579409.validator(path, query, header, formData, body)
  let scheme = call_579409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579409.url(scheme.get, call_579409.host, call_579409.base,
                         call_579409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579409, url, valid)

proc call*(call_579410: Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579393;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified. See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579411 = newJObject()
  var query_579412 = newJObject()
  var body_579413 = newJObject()
  add(query_579412, "key", newJString(key))
  add(query_579412, "prettyPrint", newJBool(prettyPrint))
  add(query_579412, "oauth_token", newJString(oauthToken))
  add(query_579412, "$.xgafv", newJString(Xgafv))
  add(query_579412, "alt", newJString(alt))
  add(query_579412, "uploadType", newJString(uploadType))
  add(query_579412, "quotaUser", newJString(quotaUser))
  add(path_579411, "resource", newJString(resource))
  if body != nil:
    body_579413 = body
  add(query_579412, "callback", newJString(callback))
  add(query_579412, "fields", newJString(fields))
  add(query_579412, "access_token", newJString(accessToken))
  add(query_579412, "upload_protocol", newJString(uploadProtocol))
  result = call_579410.call(path_579411, query_579412, nil, nil, body_579413)

var dataprocProjectsRegionsWorkflowTemplatesSetIamPolicy* = Call_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579393(
    name: "dataprocProjectsRegionsWorkflowTemplatesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:setIamPolicy",
    validator: validate_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579394,
    base: "/", url: url_DataprocProjectsRegionsWorkflowTemplatesSetIamPolicy_579395,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579414 = ref object of OpenApiRestCall_578348
proc url_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579416(
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

proc validate_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579415(
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
  var valid_579417 = path.getOrDefault("resource")
  valid_579417 = validateParameter(valid_579417, JString, required = true,
                                 default = nil)
  if valid_579417 != nil:
    section.add "resource", valid_579417
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
  var valid_579418 = query.getOrDefault("key")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "key", valid_579418
  var valid_579419 = query.getOrDefault("prettyPrint")
  valid_579419 = validateParameter(valid_579419, JBool, required = false,
                                 default = newJBool(true))
  if valid_579419 != nil:
    section.add "prettyPrint", valid_579419
  var valid_579420 = query.getOrDefault("oauth_token")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "oauth_token", valid_579420
  var valid_579421 = query.getOrDefault("$.xgafv")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = newJString("1"))
  if valid_579421 != nil:
    section.add "$.xgafv", valid_579421
  var valid_579422 = query.getOrDefault("alt")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = newJString("json"))
  if valid_579422 != nil:
    section.add "alt", valid_579422
  var valid_579423 = query.getOrDefault("uploadType")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "uploadType", valid_579423
  var valid_579424 = query.getOrDefault("quotaUser")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "quotaUser", valid_579424
  var valid_579425 = query.getOrDefault("callback")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "callback", valid_579425
  var valid_579426 = query.getOrDefault("fields")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "fields", valid_579426
  var valid_579427 = query.getOrDefault("access_token")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "access_token", valid_579427
  var valid_579428 = query.getOrDefault("upload_protocol")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "upload_protocol", valid_579428
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

proc call*(call_579430: Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource. If the resource does not exist, this will return an empty set of permissions, not a NOT_FOUND error.Note: This operation is designed to be used for building permission-aware UIs and command-line tools, not for authorization checking. This operation may "fail open" without warning.
  ## 
  let valid = call_579430.validator(path, query, header, formData, body)
  let scheme = call_579430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579430.url(scheme.get, call_579430.host, call_579430.base,
                         call_579430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579430, url, valid)

proc call*(call_579431: Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579414;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataprocProjectsRegionsWorkflowTemplatesTestIamPermissions
  ## Returns permissions that a caller has on the specified resource. If the resource does not exist, this will return an empty set of permissions, not a NOT_FOUND error.Note: This operation is designed to be used for building permission-aware UIs and command-line tools, not for authorization checking. This operation may "fail open" without warning.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested. See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579432 = newJObject()
  var query_579433 = newJObject()
  var body_579434 = newJObject()
  add(query_579433, "key", newJString(key))
  add(query_579433, "prettyPrint", newJBool(prettyPrint))
  add(query_579433, "oauth_token", newJString(oauthToken))
  add(query_579433, "$.xgafv", newJString(Xgafv))
  add(query_579433, "alt", newJString(alt))
  add(query_579433, "uploadType", newJString(uploadType))
  add(query_579433, "quotaUser", newJString(quotaUser))
  add(path_579432, "resource", newJString(resource))
  if body != nil:
    body_579434 = body
  add(query_579433, "callback", newJString(callback))
  add(query_579433, "fields", newJString(fields))
  add(query_579433, "access_token", newJString(accessToken))
  add(query_579433, "upload_protocol", newJString(uploadProtocol))
  result = call_579431.call(path_579432, query_579433, nil, nil, body_579434)

var dataprocProjectsRegionsWorkflowTemplatesTestIamPermissions* = Call_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579414(
    name: "dataprocProjectsRegionsWorkflowTemplatesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:testIamPermissions", validator: validate_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579415,
    base: "/",
    url: url_DataprocProjectsRegionsWorkflowTemplatesTestIamPermissions_579416,
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
