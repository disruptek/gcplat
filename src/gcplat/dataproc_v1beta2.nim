
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataprocProjectsRegionsClustersCreate_593982 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsClustersCreate_593984(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsClustersCreate_593983(path: JsonNode;
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
  var valid_593985 = path.getOrDefault("projectId")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "projectId", valid_593985
  var valid_593986 = path.getOrDefault("region")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "region", valid_593986
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
  var valid_593987 = query.getOrDefault("upload_protocol")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "upload_protocol", valid_593987
  var valid_593988 = query.getOrDefault("fields")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "fields", valid_593988
  var valid_593989 = query.getOrDefault("requestId")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "requestId", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
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

proc call*(call_594000: Call_DataprocProjectsRegionsClustersCreate_593982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_DataprocProjectsRegionsClustersCreate_593982;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  var body_594004 = newJObject()
  add(query_594003, "upload_protocol", newJString(uploadProtocol))
  add(query_594003, "fields", newJString(fields))
  add(query_594003, "requestId", newJString(requestId))
  add(query_594003, "quotaUser", newJString(quotaUser))
  add(query_594003, "alt", newJString(alt))
  add(query_594003, "oauth_token", newJString(oauthToken))
  add(query_594003, "callback", newJString(callback))
  add(query_594003, "access_token", newJString(accessToken))
  add(query_594003, "uploadType", newJString(uploadType))
  add(query_594003, "key", newJString(key))
  add(path_594002, "projectId", newJString(projectId))
  add(query_594003, "$.xgafv", newJString(Xgafv))
  add(path_594002, "region", newJString(region))
  if body != nil:
    body_594004 = body
  add(query_594003, "prettyPrint", newJBool(prettyPrint))
  result = call_594001.call(path_594002, query_594003, nil, nil, body_594004)

var dataprocProjectsRegionsClustersCreate* = Call_DataprocProjectsRegionsClustersCreate_593982(
    name: "dataprocProjectsRegionsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersCreate_593983, base: "/",
    url: url_DataprocProjectsRegionsClustersCreate_593984, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersList_593690 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsClustersList_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsClustersList_593691(path: JsonNode;
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
  var valid_593818 = path.getOrDefault("projectId")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "projectId", valid_593818
  var valid_593819 = path.getOrDefault("region")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "region", valid_593819
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
  var valid_593820 = query.getOrDefault("upload_protocol")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "upload_protocol", valid_593820
  var valid_593821 = query.getOrDefault("fields")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "fields", valid_593821
  var valid_593822 = query.getOrDefault("pageToken")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "pageToken", valid_593822
  var valid_593823 = query.getOrDefault("quotaUser")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "quotaUser", valid_593823
  var valid_593837 = query.getOrDefault("alt")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = newJString("json"))
  if valid_593837 != nil:
    section.add "alt", valid_593837
  var valid_593838 = query.getOrDefault("oauth_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "oauth_token", valid_593838
  var valid_593839 = query.getOrDefault("callback")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "callback", valid_593839
  var valid_593840 = query.getOrDefault("access_token")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "access_token", valid_593840
  var valid_593841 = query.getOrDefault("uploadType")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "uploadType", valid_593841
  var valid_593842 = query.getOrDefault("key")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "key", valid_593842
  var valid_593843 = query.getOrDefault("$.xgafv")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = newJString("1"))
  if valid_593843 != nil:
    section.add "$.xgafv", valid_593843
  var valid_593844 = query.getOrDefault("pageSize")
  valid_593844 = validateParameter(valid_593844, JInt, required = false, default = nil)
  if valid_593844 != nil:
    section.add "pageSize", valid_593844
  var valid_593845 = query.getOrDefault("prettyPrint")
  valid_593845 = validateParameter(valid_593845, JBool, required = false,
                                 default = newJBool(true))
  if valid_593845 != nil:
    section.add "prettyPrint", valid_593845
  var valid_593846 = query.getOrDefault("filter")
  valid_593846 = validateParameter(valid_593846, JString, required = false,
                                 default = nil)
  if valid_593846 != nil:
    section.add "filter", valid_593846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593869: Call_DataprocProjectsRegionsClustersList_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all regions/{region}/clusters in a project.
  ## 
  let valid = call_593869.validator(path, query, header, formData, body)
  let scheme = call_593869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593869.url(scheme.get, call_593869.host, call_593869.base,
                         call_593869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593869, url, valid)

proc call*(call_593940: Call_DataprocProjectsRegionsClustersList_593690;
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
  var path_593941 = newJObject()
  var query_593943 = newJObject()
  add(query_593943, "upload_protocol", newJString(uploadProtocol))
  add(query_593943, "fields", newJString(fields))
  add(query_593943, "pageToken", newJString(pageToken))
  add(query_593943, "quotaUser", newJString(quotaUser))
  add(query_593943, "alt", newJString(alt))
  add(query_593943, "oauth_token", newJString(oauthToken))
  add(query_593943, "callback", newJString(callback))
  add(query_593943, "access_token", newJString(accessToken))
  add(query_593943, "uploadType", newJString(uploadType))
  add(query_593943, "key", newJString(key))
  add(path_593941, "projectId", newJString(projectId))
  add(query_593943, "$.xgafv", newJString(Xgafv))
  add(path_593941, "region", newJString(region))
  add(query_593943, "pageSize", newJInt(pageSize))
  add(query_593943, "prettyPrint", newJBool(prettyPrint))
  add(query_593943, "filter", newJString(filter))
  result = call_593940.call(path_593941, query_593943, nil, nil, nil)

var dataprocProjectsRegionsClustersList* = Call_DataprocProjectsRegionsClustersList_593690(
    name: "dataprocProjectsRegionsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersList_593691, base: "/",
    url: url_DataprocProjectsRegionsClustersList_593692, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersGet_594005 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsClustersGet_594007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsClustersGet_594006(path: JsonNode;
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
  var valid_594008 = path.getOrDefault("clusterName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "clusterName", valid_594008
  var valid_594009 = path.getOrDefault("projectId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "projectId", valid_594009
  var valid_594010 = path.getOrDefault("region")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "region", valid_594010
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
  var valid_594011 = query.getOrDefault("upload_protocol")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "upload_protocol", valid_594011
  var valid_594012 = query.getOrDefault("fields")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "fields", valid_594012
  var valid_594013 = query.getOrDefault("quotaUser")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "quotaUser", valid_594013
  var valid_594014 = query.getOrDefault("alt")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("json"))
  if valid_594014 != nil:
    section.add "alt", valid_594014
  var valid_594015 = query.getOrDefault("oauth_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "oauth_token", valid_594015
  var valid_594016 = query.getOrDefault("callback")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "callback", valid_594016
  var valid_594017 = query.getOrDefault("access_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "access_token", valid_594017
  var valid_594018 = query.getOrDefault("uploadType")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "uploadType", valid_594018
  var valid_594019 = query.getOrDefault("key")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "key", valid_594019
  var valid_594020 = query.getOrDefault("$.xgafv")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("1"))
  if valid_594020 != nil:
    section.add "$.xgafv", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_DataprocProjectsRegionsClustersGet_594005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_DataprocProjectsRegionsClustersGet_594005;
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(path_594024, "clusterName", newJString(clusterName))
  add(query_594025, "upload_protocol", newJString(uploadProtocol))
  add(query_594025, "fields", newJString(fields))
  add(query_594025, "quotaUser", newJString(quotaUser))
  add(query_594025, "alt", newJString(alt))
  add(query_594025, "oauth_token", newJString(oauthToken))
  add(query_594025, "callback", newJString(callback))
  add(query_594025, "access_token", newJString(accessToken))
  add(query_594025, "uploadType", newJString(uploadType))
  add(query_594025, "key", newJString(key))
  add(path_594024, "projectId", newJString(projectId))
  add(query_594025, "$.xgafv", newJString(Xgafv))
  add(path_594024, "region", newJString(region))
  add(query_594025, "prettyPrint", newJBool(prettyPrint))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var dataprocProjectsRegionsClustersGet* = Call_DataprocProjectsRegionsClustersGet_594005(
    name: "dataprocProjectsRegionsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersGet_594006, base: "/",
    url: url_DataprocProjectsRegionsClustersGet_594007, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersPatch_594049 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsClustersPatch_594051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsClustersPatch_594050(path: JsonNode;
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
  var valid_594052 = path.getOrDefault("clusterName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "clusterName", valid_594052
  var valid_594053 = path.getOrDefault("projectId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "projectId", valid_594053
  var valid_594054 = path.getOrDefault("region")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "region", valid_594054
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
  var valid_594055 = query.getOrDefault("upload_protocol")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "upload_protocol", valid_594055
  var valid_594056 = query.getOrDefault("fields")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "fields", valid_594056
  var valid_594057 = query.getOrDefault("requestId")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "requestId", valid_594057
  var valid_594058 = query.getOrDefault("quotaUser")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "quotaUser", valid_594058
  var valid_594059 = query.getOrDefault("alt")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("json"))
  if valid_594059 != nil:
    section.add "alt", valid_594059
  var valid_594060 = query.getOrDefault("oauth_token")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "oauth_token", valid_594060
  var valid_594061 = query.getOrDefault("callback")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "callback", valid_594061
  var valid_594062 = query.getOrDefault("access_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "access_token", valid_594062
  var valid_594063 = query.getOrDefault("uploadType")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "uploadType", valid_594063
  var valid_594064 = query.getOrDefault("gracefulDecommissionTimeout")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "gracefulDecommissionTimeout", valid_594064
  var valid_594065 = query.getOrDefault("key")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "key", valid_594065
  var valid_594066 = query.getOrDefault("$.xgafv")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = newJString("1"))
  if valid_594066 != nil:
    section.add "$.xgafv", valid_594066
  var valid_594067 = query.getOrDefault("prettyPrint")
  valid_594067 = validateParameter(valid_594067, JBool, required = false,
                                 default = newJBool(true))
  if valid_594067 != nil:
    section.add "prettyPrint", valid_594067
  var valid_594068 = query.getOrDefault("updateMask")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "updateMask", valid_594068
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

proc call*(call_594070: Call_DataprocProjectsRegionsClustersPatch_594049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_DataprocProjectsRegionsClustersPatch_594049;
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
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  var body_594074 = newJObject()
  add(path_594072, "clusterName", newJString(clusterName))
  add(query_594073, "upload_protocol", newJString(uploadProtocol))
  add(query_594073, "fields", newJString(fields))
  add(query_594073, "requestId", newJString(requestId))
  add(query_594073, "quotaUser", newJString(quotaUser))
  add(query_594073, "alt", newJString(alt))
  add(query_594073, "oauth_token", newJString(oauthToken))
  add(query_594073, "callback", newJString(callback))
  add(query_594073, "access_token", newJString(accessToken))
  add(query_594073, "uploadType", newJString(uploadType))
  add(query_594073, "gracefulDecommissionTimeout",
      newJString(gracefulDecommissionTimeout))
  add(query_594073, "key", newJString(key))
  add(path_594072, "projectId", newJString(projectId))
  add(query_594073, "$.xgafv", newJString(Xgafv))
  add(path_594072, "region", newJString(region))
  if body != nil:
    body_594074 = body
  add(query_594073, "prettyPrint", newJBool(prettyPrint))
  add(query_594073, "updateMask", newJString(updateMask))
  result = call_594071.call(path_594072, query_594073, nil, nil, body_594074)

var dataprocProjectsRegionsClustersPatch* = Call_DataprocProjectsRegionsClustersPatch_594049(
    name: "dataprocProjectsRegionsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersPatch_594050, base: "/",
    url: url_DataprocProjectsRegionsClustersPatch_594051, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDelete_594026 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsClustersDelete_594028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsClustersDelete_594027(path: JsonNode;
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
  var valid_594029 = path.getOrDefault("clusterName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "clusterName", valid_594029
  var valid_594030 = path.getOrDefault("projectId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "projectId", valid_594030
  var valid_594031 = path.getOrDefault("region")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "region", valid_594031
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
  var valid_594032 = query.getOrDefault("upload_protocol")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "upload_protocol", valid_594032
  var valid_594033 = query.getOrDefault("fields")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "fields", valid_594033
  var valid_594034 = query.getOrDefault("requestId")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "requestId", valid_594034
  var valid_594035 = query.getOrDefault("quotaUser")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "quotaUser", valid_594035
  var valid_594036 = query.getOrDefault("alt")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("json"))
  if valid_594036 != nil:
    section.add "alt", valid_594036
  var valid_594037 = query.getOrDefault("clusterUuid")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "clusterUuid", valid_594037
  var valid_594038 = query.getOrDefault("oauth_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "oauth_token", valid_594038
  var valid_594039 = query.getOrDefault("callback")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "callback", valid_594039
  var valid_594040 = query.getOrDefault("access_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "access_token", valid_594040
  var valid_594041 = query.getOrDefault("uploadType")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "uploadType", valid_594041
  var valid_594042 = query.getOrDefault("key")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "key", valid_594042
  var valid_594043 = query.getOrDefault("$.xgafv")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("1"))
  if valid_594043 != nil:
    section.add "$.xgafv", valid_594043
  var valid_594044 = query.getOrDefault("prettyPrint")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "prettyPrint", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_DataprocProjectsRegionsClustersDelete_594026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster in a project. The returned Operation.metadata will be ClusterOperationMetadata.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_DataprocProjectsRegionsClustersDelete_594026;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(path_594047, "clusterName", newJString(clusterName))
  add(query_594048, "upload_protocol", newJString(uploadProtocol))
  add(query_594048, "fields", newJString(fields))
  add(query_594048, "requestId", newJString(requestId))
  add(query_594048, "quotaUser", newJString(quotaUser))
  add(query_594048, "alt", newJString(alt))
  add(query_594048, "clusterUuid", newJString(clusterUuid))
  add(query_594048, "oauth_token", newJString(oauthToken))
  add(query_594048, "callback", newJString(callback))
  add(query_594048, "access_token", newJString(accessToken))
  add(query_594048, "uploadType", newJString(uploadType))
  add(query_594048, "key", newJString(key))
  add(path_594047, "projectId", newJString(projectId))
  add(query_594048, "$.xgafv", newJString(Xgafv))
  add(path_594047, "region", newJString(region))
  add(query_594048, "prettyPrint", newJBool(prettyPrint))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var dataprocProjectsRegionsClustersDelete* = Call_DataprocProjectsRegionsClustersDelete_594026(
    name: "dataprocProjectsRegionsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersDelete_594027, base: "/",
    url: url_DataprocProjectsRegionsClustersDelete_594028, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDiagnose_594075 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsClustersDiagnose_594077(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsClustersDiagnose_594076(path: JsonNode;
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
  var valid_594078 = path.getOrDefault("clusterName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "clusterName", valid_594078
  var valid_594079 = path.getOrDefault("projectId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "projectId", valid_594079
  var valid_594080 = path.getOrDefault("region")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "region", valid_594080
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
  var valid_594081 = query.getOrDefault("upload_protocol")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "upload_protocol", valid_594081
  var valid_594082 = query.getOrDefault("fields")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "fields", valid_594082
  var valid_594083 = query.getOrDefault("quotaUser")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "quotaUser", valid_594083
  var valid_594084 = query.getOrDefault("alt")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = newJString("json"))
  if valid_594084 != nil:
    section.add "alt", valid_594084
  var valid_594085 = query.getOrDefault("oauth_token")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "oauth_token", valid_594085
  var valid_594086 = query.getOrDefault("callback")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "callback", valid_594086
  var valid_594087 = query.getOrDefault("access_token")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "access_token", valid_594087
  var valid_594088 = query.getOrDefault("uploadType")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "uploadType", valid_594088
  var valid_594089 = query.getOrDefault("key")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "key", valid_594089
  var valid_594090 = query.getOrDefault("$.xgafv")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("1"))
  if valid_594090 != nil:
    section.add "$.xgafv", valid_594090
  var valid_594091 = query.getOrDefault("prettyPrint")
  valid_594091 = validateParameter(valid_594091, JBool, required = false,
                                 default = newJBool(true))
  if valid_594091 != nil:
    section.add "prettyPrint", valid_594091
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

proc call*(call_594093: Call_DataprocProjectsRegionsClustersDiagnose_594075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. The returned Operation.metadata will be ClusterOperationMetadata. After the operation completes, Operation.response contains DiagnoseClusterResults.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_DataprocProjectsRegionsClustersDiagnose_594075;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  var body_594097 = newJObject()
  add(path_594095, "clusterName", newJString(clusterName))
  add(query_594096, "upload_protocol", newJString(uploadProtocol))
  add(query_594096, "fields", newJString(fields))
  add(query_594096, "quotaUser", newJString(quotaUser))
  add(query_594096, "alt", newJString(alt))
  add(query_594096, "oauth_token", newJString(oauthToken))
  add(query_594096, "callback", newJString(callback))
  add(query_594096, "access_token", newJString(accessToken))
  add(query_594096, "uploadType", newJString(uploadType))
  add(query_594096, "key", newJString(key))
  add(path_594095, "projectId", newJString(projectId))
  add(query_594096, "$.xgafv", newJString(Xgafv))
  add(path_594095, "region", newJString(region))
  if body != nil:
    body_594097 = body
  add(query_594096, "prettyPrint", newJBool(prettyPrint))
  result = call_594094.call(path_594095, query_594096, nil, nil, body_594097)

var dataprocProjectsRegionsClustersDiagnose* = Call_DataprocProjectsRegionsClustersDiagnose_594075(
    name: "dataprocProjectsRegionsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsRegionsClustersDiagnose_594076, base: "/",
    url: url_DataprocProjectsRegionsClustersDiagnose_594077,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsList_594098 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsJobsList_594100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsJobsList_594099(path: JsonNode;
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
  var valid_594101 = path.getOrDefault("projectId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "projectId", valid_594101
  var valid_594102 = path.getOrDefault("region")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "region", valid_594102
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
  var valid_594103 = query.getOrDefault("upload_protocol")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "upload_protocol", valid_594103
  var valid_594104 = query.getOrDefault("fields")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "fields", valid_594104
  var valid_594105 = query.getOrDefault("pageToken")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "pageToken", valid_594105
  var valid_594106 = query.getOrDefault("quotaUser")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "quotaUser", valid_594106
  var valid_594107 = query.getOrDefault("alt")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("json"))
  if valid_594107 != nil:
    section.add "alt", valid_594107
  var valid_594108 = query.getOrDefault("oauth_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "oauth_token", valid_594108
  var valid_594109 = query.getOrDefault("callback")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "callback", valid_594109
  var valid_594110 = query.getOrDefault("access_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "access_token", valid_594110
  var valid_594111 = query.getOrDefault("uploadType")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "uploadType", valid_594111
  var valid_594112 = query.getOrDefault("jobStateMatcher")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("ALL"))
  if valid_594112 != nil:
    section.add "jobStateMatcher", valid_594112
  var valid_594113 = query.getOrDefault("key")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "key", valid_594113
  var valid_594114 = query.getOrDefault("$.xgafv")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("1"))
  if valid_594114 != nil:
    section.add "$.xgafv", valid_594114
  var valid_594115 = query.getOrDefault("pageSize")
  valid_594115 = validateParameter(valid_594115, JInt, required = false, default = nil)
  if valid_594115 != nil:
    section.add "pageSize", valid_594115
  var valid_594116 = query.getOrDefault("prettyPrint")
  valid_594116 = validateParameter(valid_594116, JBool, required = false,
                                 default = newJBool(true))
  if valid_594116 != nil:
    section.add "prettyPrint", valid_594116
  var valid_594117 = query.getOrDefault("filter")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "filter", valid_594117
  var valid_594118 = query.getOrDefault("clusterName")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "clusterName", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594119: Call_DataprocProjectsRegionsJobsList_594098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists regions/{region}/jobs in a project.
  ## 
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_DataprocProjectsRegionsJobsList_594098;
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
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  add(query_594122, "upload_protocol", newJString(uploadProtocol))
  add(query_594122, "fields", newJString(fields))
  add(query_594122, "pageToken", newJString(pageToken))
  add(query_594122, "quotaUser", newJString(quotaUser))
  add(query_594122, "alt", newJString(alt))
  add(query_594122, "oauth_token", newJString(oauthToken))
  add(query_594122, "callback", newJString(callback))
  add(query_594122, "access_token", newJString(accessToken))
  add(query_594122, "uploadType", newJString(uploadType))
  add(query_594122, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_594122, "key", newJString(key))
  add(path_594121, "projectId", newJString(projectId))
  add(query_594122, "$.xgafv", newJString(Xgafv))
  add(path_594121, "region", newJString(region))
  add(query_594122, "pageSize", newJInt(pageSize))
  add(query_594122, "prettyPrint", newJBool(prettyPrint))
  add(query_594122, "filter", newJString(filter))
  add(query_594122, "clusterName", newJString(clusterName))
  result = call_594120.call(path_594121, query_594122, nil, nil, nil)

var dataprocProjectsRegionsJobsList* = Call_DataprocProjectsRegionsJobsList_594098(
    name: "dataprocProjectsRegionsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs",
    validator: validate_DataprocProjectsRegionsJobsList_594099, base: "/",
    url: url_DataprocProjectsRegionsJobsList_594100, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsGet_594123 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsJobsGet_594125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsJobsGet_594124(path: JsonNode;
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
  var valid_594126 = path.getOrDefault("jobId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "jobId", valid_594126
  var valid_594127 = path.getOrDefault("projectId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "projectId", valid_594127
  var valid_594128 = path.getOrDefault("region")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "region", valid_594128
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
  var valid_594129 = query.getOrDefault("upload_protocol")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "upload_protocol", valid_594129
  var valid_594130 = query.getOrDefault("fields")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "fields", valid_594130
  var valid_594131 = query.getOrDefault("quotaUser")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "quotaUser", valid_594131
  var valid_594132 = query.getOrDefault("alt")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = newJString("json"))
  if valid_594132 != nil:
    section.add "alt", valid_594132
  var valid_594133 = query.getOrDefault("oauth_token")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "oauth_token", valid_594133
  var valid_594134 = query.getOrDefault("callback")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "callback", valid_594134
  var valid_594135 = query.getOrDefault("access_token")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "access_token", valid_594135
  var valid_594136 = query.getOrDefault("uploadType")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "uploadType", valid_594136
  var valid_594137 = query.getOrDefault("key")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "key", valid_594137
  var valid_594138 = query.getOrDefault("$.xgafv")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = newJString("1"))
  if valid_594138 != nil:
    section.add "$.xgafv", valid_594138
  var valid_594139 = query.getOrDefault("prettyPrint")
  valid_594139 = validateParameter(valid_594139, JBool, required = false,
                                 default = newJBool(true))
  if valid_594139 != nil:
    section.add "prettyPrint", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_DataprocProjectsRegionsJobsGet_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_DataprocProjectsRegionsJobsGet_594123; jobId: string;
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
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(query_594143, "upload_protocol", newJString(uploadProtocol))
  add(query_594143, "fields", newJString(fields))
  add(query_594143, "quotaUser", newJString(quotaUser))
  add(query_594143, "alt", newJString(alt))
  add(path_594142, "jobId", newJString(jobId))
  add(query_594143, "oauth_token", newJString(oauthToken))
  add(query_594143, "callback", newJString(callback))
  add(query_594143, "access_token", newJString(accessToken))
  add(query_594143, "uploadType", newJString(uploadType))
  add(query_594143, "key", newJString(key))
  add(path_594142, "projectId", newJString(projectId))
  add(query_594143, "$.xgafv", newJString(Xgafv))
  add(path_594142, "region", newJString(region))
  add(query_594143, "prettyPrint", newJBool(prettyPrint))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var dataprocProjectsRegionsJobsGet* = Call_DataprocProjectsRegionsJobsGet_594123(
    name: "dataprocProjectsRegionsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsGet_594124, base: "/",
    url: url_DataprocProjectsRegionsJobsGet_594125, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsPatch_594165 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsJobsPatch_594167(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsJobsPatch_594166(path: JsonNode;
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
  var valid_594168 = path.getOrDefault("jobId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "jobId", valid_594168
  var valid_594169 = path.getOrDefault("projectId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "projectId", valid_594169
  var valid_594170 = path.getOrDefault("region")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "region", valid_594170
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
  var valid_594171 = query.getOrDefault("upload_protocol")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "upload_protocol", valid_594171
  var valid_594172 = query.getOrDefault("fields")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "fields", valid_594172
  var valid_594173 = query.getOrDefault("quotaUser")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "quotaUser", valid_594173
  var valid_594174 = query.getOrDefault("alt")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = newJString("json"))
  if valid_594174 != nil:
    section.add "alt", valid_594174
  var valid_594175 = query.getOrDefault("oauth_token")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "oauth_token", valid_594175
  var valid_594176 = query.getOrDefault("callback")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "callback", valid_594176
  var valid_594177 = query.getOrDefault("access_token")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "access_token", valid_594177
  var valid_594178 = query.getOrDefault("uploadType")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "uploadType", valid_594178
  var valid_594179 = query.getOrDefault("key")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "key", valid_594179
  var valid_594180 = query.getOrDefault("$.xgafv")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = newJString("1"))
  if valid_594180 != nil:
    section.add "$.xgafv", valid_594180
  var valid_594181 = query.getOrDefault("prettyPrint")
  valid_594181 = validateParameter(valid_594181, JBool, required = false,
                                 default = newJBool(true))
  if valid_594181 != nil:
    section.add "prettyPrint", valid_594181
  var valid_594182 = query.getOrDefault("updateMask")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "updateMask", valid_594182
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

proc call*(call_594184: Call_DataprocProjectsRegionsJobsPatch_594165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_DataprocProjectsRegionsJobsPatch_594165;
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
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  var body_594188 = newJObject()
  add(query_594187, "upload_protocol", newJString(uploadProtocol))
  add(query_594187, "fields", newJString(fields))
  add(query_594187, "quotaUser", newJString(quotaUser))
  add(query_594187, "alt", newJString(alt))
  add(path_594186, "jobId", newJString(jobId))
  add(query_594187, "oauth_token", newJString(oauthToken))
  add(query_594187, "callback", newJString(callback))
  add(query_594187, "access_token", newJString(accessToken))
  add(query_594187, "uploadType", newJString(uploadType))
  add(query_594187, "key", newJString(key))
  add(path_594186, "projectId", newJString(projectId))
  add(query_594187, "$.xgafv", newJString(Xgafv))
  add(path_594186, "region", newJString(region))
  if body != nil:
    body_594188 = body
  add(query_594187, "prettyPrint", newJBool(prettyPrint))
  add(query_594187, "updateMask", newJString(updateMask))
  result = call_594185.call(path_594186, query_594187, nil, nil, body_594188)

var dataprocProjectsRegionsJobsPatch* = Call_DataprocProjectsRegionsJobsPatch_594165(
    name: "dataprocProjectsRegionsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsPatch_594166, base: "/",
    url: url_DataprocProjectsRegionsJobsPatch_594167, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsDelete_594144 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsJobsDelete_594146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsJobsDelete_594145(path: JsonNode;
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
  var valid_594147 = path.getOrDefault("jobId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "jobId", valid_594147
  var valid_594148 = path.getOrDefault("projectId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "projectId", valid_594148
  var valid_594149 = path.getOrDefault("region")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "region", valid_594149
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
  var valid_594150 = query.getOrDefault("upload_protocol")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "upload_protocol", valid_594150
  var valid_594151 = query.getOrDefault("fields")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "fields", valid_594151
  var valid_594152 = query.getOrDefault("quotaUser")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "quotaUser", valid_594152
  var valid_594153 = query.getOrDefault("alt")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = newJString("json"))
  if valid_594153 != nil:
    section.add "alt", valid_594153
  var valid_594154 = query.getOrDefault("oauth_token")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "oauth_token", valid_594154
  var valid_594155 = query.getOrDefault("callback")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "callback", valid_594155
  var valid_594156 = query.getOrDefault("access_token")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "access_token", valid_594156
  var valid_594157 = query.getOrDefault("uploadType")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "uploadType", valid_594157
  var valid_594158 = query.getOrDefault("key")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "key", valid_594158
  var valid_594159 = query.getOrDefault("$.xgafv")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = newJString("1"))
  if valid_594159 != nil:
    section.add "$.xgafv", valid_594159
  var valid_594160 = query.getOrDefault("prettyPrint")
  valid_594160 = validateParameter(valid_594160, JBool, required = false,
                                 default = newJBool(true))
  if valid_594160 != nil:
    section.add "prettyPrint", valid_594160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_DataprocProjectsRegionsJobsDelete_594144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_DataprocProjectsRegionsJobsDelete_594144;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  add(query_594164, "upload_protocol", newJString(uploadProtocol))
  add(query_594164, "fields", newJString(fields))
  add(query_594164, "quotaUser", newJString(quotaUser))
  add(query_594164, "alt", newJString(alt))
  add(path_594163, "jobId", newJString(jobId))
  add(query_594164, "oauth_token", newJString(oauthToken))
  add(query_594164, "callback", newJString(callback))
  add(query_594164, "access_token", newJString(accessToken))
  add(query_594164, "uploadType", newJString(uploadType))
  add(query_594164, "key", newJString(key))
  add(path_594163, "projectId", newJString(projectId))
  add(query_594164, "$.xgafv", newJString(Xgafv))
  add(path_594163, "region", newJString(region))
  add(query_594164, "prettyPrint", newJBool(prettyPrint))
  result = call_594162.call(path_594163, query_594164, nil, nil, nil)

var dataprocProjectsRegionsJobsDelete* = Call_DataprocProjectsRegionsJobsDelete_594144(
    name: "dataprocProjectsRegionsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsDelete_594145, base: "/",
    url: url_DataprocProjectsRegionsJobsDelete_594146, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsCancel_594189 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsJobsCancel_594191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsJobsCancel_594190(path: JsonNode;
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
  var valid_594192 = path.getOrDefault("jobId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "jobId", valid_594192
  var valid_594193 = path.getOrDefault("projectId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "projectId", valid_594193
  var valid_594194 = path.getOrDefault("region")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "region", valid_594194
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
  var valid_594195 = query.getOrDefault("upload_protocol")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "upload_protocol", valid_594195
  var valid_594196 = query.getOrDefault("fields")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "fields", valid_594196
  var valid_594197 = query.getOrDefault("quotaUser")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "quotaUser", valid_594197
  var valid_594198 = query.getOrDefault("alt")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = newJString("json"))
  if valid_594198 != nil:
    section.add "alt", valid_594198
  var valid_594199 = query.getOrDefault("oauth_token")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "oauth_token", valid_594199
  var valid_594200 = query.getOrDefault("callback")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "callback", valid_594200
  var valid_594201 = query.getOrDefault("access_token")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "access_token", valid_594201
  var valid_594202 = query.getOrDefault("uploadType")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "uploadType", valid_594202
  var valid_594203 = query.getOrDefault("key")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "key", valid_594203
  var valid_594204 = query.getOrDefault("$.xgafv")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = newJString("1"))
  if valid_594204 != nil:
    section.add "$.xgafv", valid_594204
  var valid_594205 = query.getOrDefault("prettyPrint")
  valid_594205 = validateParameter(valid_594205, JBool, required = false,
                                 default = newJBool(true))
  if valid_594205 != nil:
    section.add "prettyPrint", valid_594205
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

proc call*(call_594207: Call_DataprocProjectsRegionsJobsCancel_594189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs.list or regions/{region}/jobs.get.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_DataprocProjectsRegionsJobsCancel_594189;
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
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  var body_594211 = newJObject()
  add(query_594210, "upload_protocol", newJString(uploadProtocol))
  add(query_594210, "fields", newJString(fields))
  add(query_594210, "quotaUser", newJString(quotaUser))
  add(query_594210, "alt", newJString(alt))
  add(path_594209, "jobId", newJString(jobId))
  add(query_594210, "oauth_token", newJString(oauthToken))
  add(query_594210, "callback", newJString(callback))
  add(query_594210, "access_token", newJString(accessToken))
  add(query_594210, "uploadType", newJString(uploadType))
  add(query_594210, "key", newJString(key))
  add(path_594209, "projectId", newJString(projectId))
  add(query_594210, "$.xgafv", newJString(Xgafv))
  add(path_594209, "region", newJString(region))
  if body != nil:
    body_594211 = body
  add(query_594210, "prettyPrint", newJBool(prettyPrint))
  result = call_594208.call(path_594209, query_594210, nil, nil, body_594211)

var dataprocProjectsRegionsJobsCancel* = Call_DataprocProjectsRegionsJobsCancel_594189(
    name: "dataprocProjectsRegionsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/projects/{projectId}/regions/{region}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsRegionsJobsCancel_594190, base: "/",
    url: url_DataprocProjectsRegionsJobsCancel_594191, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsSubmit_594212 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsJobsSubmit_594214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsJobsSubmit_594213(path: JsonNode;
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
  var valid_594215 = path.getOrDefault("projectId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "projectId", valid_594215
  var valid_594216 = path.getOrDefault("region")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "region", valid_594216
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
  var valid_594217 = query.getOrDefault("upload_protocol")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "upload_protocol", valid_594217
  var valid_594218 = query.getOrDefault("fields")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "fields", valid_594218
  var valid_594219 = query.getOrDefault("quotaUser")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "quotaUser", valid_594219
  var valid_594220 = query.getOrDefault("alt")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = newJString("json"))
  if valid_594220 != nil:
    section.add "alt", valid_594220
  var valid_594221 = query.getOrDefault("oauth_token")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "oauth_token", valid_594221
  var valid_594222 = query.getOrDefault("callback")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "callback", valid_594222
  var valid_594223 = query.getOrDefault("access_token")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "access_token", valid_594223
  var valid_594224 = query.getOrDefault("uploadType")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "uploadType", valid_594224
  var valid_594225 = query.getOrDefault("key")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "key", valid_594225
  var valid_594226 = query.getOrDefault("$.xgafv")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = newJString("1"))
  if valid_594226 != nil:
    section.add "$.xgafv", valid_594226
  var valid_594227 = query.getOrDefault("prettyPrint")
  valid_594227 = validateParameter(valid_594227, JBool, required = false,
                                 default = newJBool(true))
  if valid_594227 != nil:
    section.add "prettyPrint", valid_594227
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

proc call*(call_594229: Call_DataprocProjectsRegionsJobsSubmit_594212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_DataprocProjectsRegionsJobsSubmit_594212;
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
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  var body_594233 = newJObject()
  add(query_594232, "upload_protocol", newJString(uploadProtocol))
  add(query_594232, "fields", newJString(fields))
  add(query_594232, "quotaUser", newJString(quotaUser))
  add(query_594232, "alt", newJString(alt))
  add(query_594232, "oauth_token", newJString(oauthToken))
  add(query_594232, "callback", newJString(callback))
  add(query_594232, "access_token", newJString(accessToken))
  add(query_594232, "uploadType", newJString(uploadType))
  add(query_594232, "key", newJString(key))
  add(path_594231, "projectId", newJString(projectId))
  add(query_594232, "$.xgafv", newJString(Xgafv))
  add(path_594231, "region", newJString(region))
  if body != nil:
    body_594233 = body
  add(query_594232, "prettyPrint", newJBool(prettyPrint))
  result = call_594230.call(path_594231, query_594232, nil, nil, body_594233)

var dataprocProjectsRegionsJobsSubmit* = Call_DataprocProjectsRegionsJobsSubmit_594212(
    name: "dataprocProjectsRegionsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta2/projects/{projectId}/regions/{region}/jobs:submit",
    validator: validate_DataprocProjectsRegionsJobsSubmit_594213, base: "/",
    url: url_DataprocProjectsRegionsJobsSubmit_594214, schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594254 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594256(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594255(
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
  var valid_594257 = path.getOrDefault("name")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "name", valid_594257
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
  var valid_594258 = query.getOrDefault("upload_protocol")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "upload_protocol", valid_594258
  var valid_594259 = query.getOrDefault("fields")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "fields", valid_594259
  var valid_594260 = query.getOrDefault("quotaUser")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "quotaUser", valid_594260
  var valid_594261 = query.getOrDefault("alt")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = newJString("json"))
  if valid_594261 != nil:
    section.add "alt", valid_594261
  var valid_594262 = query.getOrDefault("oauth_token")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "oauth_token", valid_594262
  var valid_594263 = query.getOrDefault("callback")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "callback", valid_594263
  var valid_594264 = query.getOrDefault("access_token")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "access_token", valid_594264
  var valid_594265 = query.getOrDefault("uploadType")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "uploadType", valid_594265
  var valid_594266 = query.getOrDefault("key")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "key", valid_594266
  var valid_594267 = query.getOrDefault("$.xgafv")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = newJString("1"))
  if valid_594267 != nil:
    section.add "$.xgafv", valid_594267
  var valid_594268 = query.getOrDefault("prettyPrint")
  valid_594268 = validateParameter(valid_594268, JBool, required = false,
                                 default = newJBool(true))
  if valid_594268 != nil:
    section.add "prettyPrint", valid_594268
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

proc call*(call_594270: Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates (replaces) autoscaling policy.Disabled check for update_mask, because all updates will be full replacements.
  ## 
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594254;
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
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  var body_594274 = newJObject()
  add(query_594273, "upload_protocol", newJString(uploadProtocol))
  add(query_594273, "fields", newJString(fields))
  add(query_594273, "quotaUser", newJString(quotaUser))
  add(path_594272, "name", newJString(name))
  add(query_594273, "alt", newJString(alt))
  add(query_594273, "oauth_token", newJString(oauthToken))
  add(query_594273, "callback", newJString(callback))
  add(query_594273, "access_token", newJString(accessToken))
  add(query_594273, "uploadType", newJString(uploadType))
  add(query_594273, "key", newJString(key))
  add(query_594273, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594274 = body
  add(query_594273, "prettyPrint", newJBool(prettyPrint))
  result = call_594271.call(path_594272, query_594273, nil, nil, body_594274)

var dataprocProjectsLocationsAutoscalingPoliciesUpdate* = Call_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594254(
    name: "dataprocProjectsLocationsAutoscalingPoliciesUpdate",
    meth: HttpMethod.HttpPut, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594255,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesUpdate_594256,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesGet_594234 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesGet_594236(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsLocationsAutoscalingPoliciesGet_594235(
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
  var valid_594237 = path.getOrDefault("name")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "name", valid_594237
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
  var valid_594238 = query.getOrDefault("upload_protocol")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "upload_protocol", valid_594238
  var valid_594239 = query.getOrDefault("fields")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "fields", valid_594239
  var valid_594240 = query.getOrDefault("quotaUser")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "quotaUser", valid_594240
  var valid_594241 = query.getOrDefault("alt")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = newJString("json"))
  if valid_594241 != nil:
    section.add "alt", valid_594241
  var valid_594242 = query.getOrDefault("oauth_token")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "oauth_token", valid_594242
  var valid_594243 = query.getOrDefault("callback")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "callback", valid_594243
  var valid_594244 = query.getOrDefault("access_token")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "access_token", valid_594244
  var valid_594245 = query.getOrDefault("uploadType")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "uploadType", valid_594245
  var valid_594246 = query.getOrDefault("key")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "key", valid_594246
  var valid_594247 = query.getOrDefault("$.xgafv")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = newJString("1"))
  if valid_594247 != nil:
    section.add "$.xgafv", valid_594247
  var valid_594248 = query.getOrDefault("version")
  valid_594248 = validateParameter(valid_594248, JInt, required = false, default = nil)
  if valid_594248 != nil:
    section.add "version", valid_594248
  var valid_594249 = query.getOrDefault("prettyPrint")
  valid_594249 = validateParameter(valid_594249, JBool, required = false,
                                 default = newJBool(true))
  if valid_594249 != nil:
    section.add "prettyPrint", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_DataprocProjectsLocationsAutoscalingPoliciesGet_594234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves autoscaling policy.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_DataprocProjectsLocationsAutoscalingPoliciesGet_594234;
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
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(query_594253, "upload_protocol", newJString(uploadProtocol))
  add(query_594253, "fields", newJString(fields))
  add(query_594253, "quotaUser", newJString(quotaUser))
  add(path_594252, "name", newJString(name))
  add(query_594253, "alt", newJString(alt))
  add(query_594253, "oauth_token", newJString(oauthToken))
  add(query_594253, "callback", newJString(callback))
  add(query_594253, "access_token", newJString(accessToken))
  add(query_594253, "uploadType", newJString(uploadType))
  add(query_594253, "key", newJString(key))
  add(query_594253, "$.xgafv", newJString(Xgafv))
  add(query_594253, "version", newJInt(version))
  add(query_594253, "prettyPrint", newJBool(prettyPrint))
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesGet* = Call_DataprocProjectsLocationsAutoscalingPoliciesGet_594234(
    name: "dataprocProjectsLocationsAutoscalingPoliciesGet",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesGet_594235,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesGet_594236,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_594275 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesDelete_594277(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsLocationsAutoscalingPoliciesDelete_594276(
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
  var valid_594278 = path.getOrDefault("name")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "name", valid_594278
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
  var valid_594279 = query.getOrDefault("upload_protocol")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "upload_protocol", valid_594279
  var valid_594280 = query.getOrDefault("fields")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "fields", valid_594280
  var valid_594281 = query.getOrDefault("quotaUser")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "quotaUser", valid_594281
  var valid_594282 = query.getOrDefault("alt")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = newJString("json"))
  if valid_594282 != nil:
    section.add "alt", valid_594282
  var valid_594283 = query.getOrDefault("oauth_token")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "oauth_token", valid_594283
  var valid_594284 = query.getOrDefault("callback")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "callback", valid_594284
  var valid_594285 = query.getOrDefault("access_token")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "access_token", valid_594285
  var valid_594286 = query.getOrDefault("uploadType")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "uploadType", valid_594286
  var valid_594287 = query.getOrDefault("key")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "key", valid_594287
  var valid_594288 = query.getOrDefault("$.xgafv")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = newJString("1"))
  if valid_594288 != nil:
    section.add "$.xgafv", valid_594288
  var valid_594289 = query.getOrDefault("version")
  valid_594289 = validateParameter(valid_594289, JInt, required = false, default = nil)
  if valid_594289 != nil:
    section.add "version", valid_594289
  var valid_594290 = query.getOrDefault("prettyPrint")
  valid_594290 = validateParameter(valid_594290, JBool, required = false,
                                 default = newJBool(true))
  if valid_594290 != nil:
    section.add "prettyPrint", valid_594290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594291: Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_594275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an autoscaling policy. It is an error to delete an autoscaling policy that is in use by one or more clusters.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_594275;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  add(query_594294, "upload_protocol", newJString(uploadProtocol))
  add(query_594294, "fields", newJString(fields))
  add(query_594294, "quotaUser", newJString(quotaUser))
  add(path_594293, "name", newJString(name))
  add(query_594294, "alt", newJString(alt))
  add(query_594294, "oauth_token", newJString(oauthToken))
  add(query_594294, "callback", newJString(callback))
  add(query_594294, "access_token", newJString(accessToken))
  add(query_594294, "uploadType", newJString(uploadType))
  add(query_594294, "key", newJString(key))
  add(query_594294, "$.xgafv", newJString(Xgafv))
  add(query_594294, "version", newJInt(version))
  add(query_594294, "prettyPrint", newJBool(prettyPrint))
  result = call_594292.call(path_594293, query_594294, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesDelete* = Call_DataprocProjectsLocationsAutoscalingPoliciesDelete_594275(
    name: "dataprocProjectsLocationsAutoscalingPoliciesDelete",
    meth: HttpMethod.HttpDelete, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesDelete_594276,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesDelete_594277,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsOperationsCancel_594295 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsRegionsOperationsCancel_594297(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsRegionsOperationsCancel_594296(path: JsonNode;
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
  var valid_594298 = path.getOrDefault("name")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "name", valid_594298
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
  var valid_594299 = query.getOrDefault("upload_protocol")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "upload_protocol", valid_594299
  var valid_594300 = query.getOrDefault("fields")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "fields", valid_594300
  var valid_594301 = query.getOrDefault("quotaUser")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "quotaUser", valid_594301
  var valid_594302 = query.getOrDefault("alt")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = newJString("json"))
  if valid_594302 != nil:
    section.add "alt", valid_594302
  var valid_594303 = query.getOrDefault("oauth_token")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "oauth_token", valid_594303
  var valid_594304 = query.getOrDefault("callback")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "callback", valid_594304
  var valid_594305 = query.getOrDefault("access_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "access_token", valid_594305
  var valid_594306 = query.getOrDefault("uploadType")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "uploadType", valid_594306
  var valid_594307 = query.getOrDefault("key")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "key", valid_594307
  var valid_594308 = query.getOrDefault("$.xgafv")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = newJString("1"))
  if valid_594308 != nil:
    section.add "$.xgafv", valid_594308
  var valid_594309 = query.getOrDefault("prettyPrint")
  valid_594309 = validateParameter(valid_594309, JBool, required = false,
                                 default = newJBool(true))
  if valid_594309 != nil:
    section.add "prettyPrint", valid_594309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594310: Call_DataprocProjectsRegionsOperationsCancel_594295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_594310.validator(path, query, header, formData, body)
  let scheme = call_594310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594310.url(scheme.get, call_594310.host, call_594310.base,
                         call_594310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594310, url, valid)

proc call*(call_594311: Call_DataprocProjectsRegionsOperationsCancel_594295;
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
  var path_594312 = newJObject()
  var query_594313 = newJObject()
  add(query_594313, "upload_protocol", newJString(uploadProtocol))
  add(query_594313, "fields", newJString(fields))
  add(query_594313, "quotaUser", newJString(quotaUser))
  add(path_594312, "name", newJString(name))
  add(query_594313, "alt", newJString(alt))
  add(query_594313, "oauth_token", newJString(oauthToken))
  add(query_594313, "callback", newJString(callback))
  add(query_594313, "access_token", newJString(accessToken))
  add(query_594313, "uploadType", newJString(uploadType))
  add(query_594313, "key", newJString(key))
  add(query_594313, "$.xgafv", newJString(Xgafv))
  add(query_594313, "prettyPrint", newJBool(prettyPrint))
  result = call_594311.call(path_594312, query_594313, nil, nil, nil)

var dataprocProjectsRegionsOperationsCancel* = Call_DataprocProjectsRegionsOperationsCancel_594295(
    name: "dataprocProjectsRegionsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta2/{name}:cancel",
    validator: validate_DataprocProjectsRegionsOperationsCancel_594296, base: "/",
    url: url_DataprocProjectsRegionsOperationsCancel_594297,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594314 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594316(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594315(
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
  var valid_594317 = path.getOrDefault("name")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "name", valid_594317
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
  var valid_594318 = query.getOrDefault("upload_protocol")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "upload_protocol", valid_594318
  var valid_594319 = query.getOrDefault("fields")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "fields", valid_594319
  var valid_594320 = query.getOrDefault("quotaUser")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "quotaUser", valid_594320
  var valid_594321 = query.getOrDefault("alt")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = newJString("json"))
  if valid_594321 != nil:
    section.add "alt", valid_594321
  var valid_594322 = query.getOrDefault("oauth_token")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "oauth_token", valid_594322
  var valid_594323 = query.getOrDefault("callback")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "callback", valid_594323
  var valid_594324 = query.getOrDefault("access_token")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "access_token", valid_594324
  var valid_594325 = query.getOrDefault("uploadType")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "uploadType", valid_594325
  var valid_594326 = query.getOrDefault("key")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "key", valid_594326
  var valid_594327 = query.getOrDefault("$.xgafv")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = newJString("1"))
  if valid_594327 != nil:
    section.add "$.xgafv", valid_594327
  var valid_594328 = query.getOrDefault("prettyPrint")
  valid_594328 = validateParameter(valid_594328, JBool, required = false,
                                 default = newJBool(true))
  if valid_594328 != nil:
    section.add "prettyPrint", valid_594328
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

proc call*(call_594330: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594314;
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
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  var body_594334 = newJObject()
  add(query_594333, "upload_protocol", newJString(uploadProtocol))
  add(query_594333, "fields", newJString(fields))
  add(query_594333, "quotaUser", newJString(quotaUser))
  add(path_594332, "name", newJString(name))
  add(query_594333, "alt", newJString(alt))
  add(query_594333, "oauth_token", newJString(oauthToken))
  add(query_594333, "callback", newJString(callback))
  add(query_594333, "access_token", newJString(accessToken))
  add(query_594333, "uploadType", newJString(uploadType))
  add(query_594333, "key", newJString(key))
  add(query_594333, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594334 = body
  add(query_594333, "prettyPrint", newJBool(prettyPrint))
  result = call_594331.call(path_594332, query_594333, nil, nil, body_594334)

var dataprocProjectsLocationsWorkflowTemplatesInstantiate* = Call_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594314(
    name: "dataprocProjectsLocationsWorkflowTemplatesInstantiate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{name}:instantiate",
    validator: validate_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594315,
    base: "/", url: url_DataprocProjectsLocationsWorkflowTemplatesInstantiate_594316,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_594356 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesCreate_594358(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesCreate_594357(
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
  var valid_594359 = path.getOrDefault("parent")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "parent", valid_594359
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
  var valid_594360 = query.getOrDefault("upload_protocol")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "upload_protocol", valid_594360
  var valid_594361 = query.getOrDefault("fields")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "fields", valid_594361
  var valid_594362 = query.getOrDefault("quotaUser")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "quotaUser", valid_594362
  var valid_594363 = query.getOrDefault("alt")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = newJString("json"))
  if valid_594363 != nil:
    section.add "alt", valid_594363
  var valid_594364 = query.getOrDefault("oauth_token")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "oauth_token", valid_594364
  var valid_594365 = query.getOrDefault("callback")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "callback", valid_594365
  var valid_594366 = query.getOrDefault("access_token")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "access_token", valid_594366
  var valid_594367 = query.getOrDefault("uploadType")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "uploadType", valid_594367
  var valid_594368 = query.getOrDefault("key")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "key", valid_594368
  var valid_594369 = query.getOrDefault("$.xgafv")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = newJString("1"))
  if valid_594369 != nil:
    section.add "$.xgafv", valid_594369
  var valid_594370 = query.getOrDefault("prettyPrint")
  valid_594370 = validateParameter(valid_594370, JBool, required = false,
                                 default = newJBool(true))
  if valid_594370 != nil:
    section.add "prettyPrint", valid_594370
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

proc call*(call_594372: Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_594356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new autoscaling policy.
  ## 
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_594356;
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
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  var body_594376 = newJObject()
  add(query_594375, "upload_protocol", newJString(uploadProtocol))
  add(query_594375, "fields", newJString(fields))
  add(query_594375, "quotaUser", newJString(quotaUser))
  add(query_594375, "alt", newJString(alt))
  add(query_594375, "oauth_token", newJString(oauthToken))
  add(query_594375, "callback", newJString(callback))
  add(query_594375, "access_token", newJString(accessToken))
  add(query_594375, "uploadType", newJString(uploadType))
  add(path_594374, "parent", newJString(parent))
  add(query_594375, "key", newJString(key))
  add(query_594375, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594376 = body
  add(query_594375, "prettyPrint", newJBool(prettyPrint))
  result = call_594373.call(path_594374, query_594375, nil, nil, body_594376)

var dataprocProjectsLocationsAutoscalingPoliciesCreate* = Call_DataprocProjectsLocationsAutoscalingPoliciesCreate_594356(
    name: "dataprocProjectsLocationsAutoscalingPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesCreate_594357,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesCreate_594358,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesList_594335 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesList_594337(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesList_594336(
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
  var valid_594338 = path.getOrDefault("parent")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "parent", valid_594338
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
  var valid_594339 = query.getOrDefault("upload_protocol")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "upload_protocol", valid_594339
  var valid_594340 = query.getOrDefault("fields")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "fields", valid_594340
  var valid_594341 = query.getOrDefault("pageToken")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "pageToken", valid_594341
  var valid_594342 = query.getOrDefault("quotaUser")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "quotaUser", valid_594342
  var valid_594343 = query.getOrDefault("alt")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = newJString("json"))
  if valid_594343 != nil:
    section.add "alt", valid_594343
  var valid_594344 = query.getOrDefault("oauth_token")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "oauth_token", valid_594344
  var valid_594345 = query.getOrDefault("callback")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "callback", valid_594345
  var valid_594346 = query.getOrDefault("access_token")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "access_token", valid_594346
  var valid_594347 = query.getOrDefault("uploadType")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "uploadType", valid_594347
  var valid_594348 = query.getOrDefault("key")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "key", valid_594348
  var valid_594349 = query.getOrDefault("$.xgafv")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = newJString("1"))
  if valid_594349 != nil:
    section.add "$.xgafv", valid_594349
  var valid_594350 = query.getOrDefault("pageSize")
  valid_594350 = validateParameter(valid_594350, JInt, required = false, default = nil)
  if valid_594350 != nil:
    section.add "pageSize", valid_594350
  var valid_594351 = query.getOrDefault("prettyPrint")
  valid_594351 = validateParameter(valid_594351, JBool, required = false,
                                 default = newJBool(true))
  if valid_594351 != nil:
    section.add "prettyPrint", valid_594351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594352: Call_DataprocProjectsLocationsAutoscalingPoliciesList_594335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists autoscaling policies in the project.
  ## 
  let valid = call_594352.validator(path, query, header, formData, body)
  let scheme = call_594352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594352.url(scheme.get, call_594352.host, call_594352.base,
                         call_594352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594352, url, valid)

proc call*(call_594353: Call_DataprocProjectsLocationsAutoscalingPoliciesList_594335;
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
  var path_594354 = newJObject()
  var query_594355 = newJObject()
  add(query_594355, "upload_protocol", newJString(uploadProtocol))
  add(query_594355, "fields", newJString(fields))
  add(query_594355, "pageToken", newJString(pageToken))
  add(query_594355, "quotaUser", newJString(quotaUser))
  add(query_594355, "alt", newJString(alt))
  add(query_594355, "oauth_token", newJString(oauthToken))
  add(query_594355, "callback", newJString(callback))
  add(query_594355, "access_token", newJString(accessToken))
  add(query_594355, "uploadType", newJString(uploadType))
  add(path_594354, "parent", newJString(parent))
  add(query_594355, "key", newJString(key))
  add(query_594355, "$.xgafv", newJString(Xgafv))
  add(query_594355, "pageSize", newJInt(pageSize))
  add(query_594355, "prettyPrint", newJBool(prettyPrint))
  result = call_594353.call(path_594354, query_594355, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesList* = Call_DataprocProjectsLocationsAutoscalingPoliciesList_594335(
    name: "dataprocProjectsLocationsAutoscalingPoliciesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/autoscalingPolicies",
    validator: validate_DataprocProjectsLocationsAutoscalingPoliciesList_594336,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesList_594337,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesCreate_594398 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsWorkflowTemplatesCreate_594400(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsWorkflowTemplatesCreate_594399(
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
  var valid_594401 = path.getOrDefault("parent")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "parent", valid_594401
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
  var valid_594402 = query.getOrDefault("upload_protocol")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "upload_protocol", valid_594402
  var valid_594403 = query.getOrDefault("fields")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "fields", valid_594403
  var valid_594404 = query.getOrDefault("quotaUser")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "quotaUser", valid_594404
  var valid_594405 = query.getOrDefault("alt")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = newJString("json"))
  if valid_594405 != nil:
    section.add "alt", valid_594405
  var valid_594406 = query.getOrDefault("oauth_token")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "oauth_token", valid_594406
  var valid_594407 = query.getOrDefault("callback")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "callback", valid_594407
  var valid_594408 = query.getOrDefault("access_token")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "access_token", valid_594408
  var valid_594409 = query.getOrDefault("uploadType")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = nil)
  if valid_594409 != nil:
    section.add "uploadType", valid_594409
  var valid_594410 = query.getOrDefault("key")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = nil)
  if valid_594410 != nil:
    section.add "key", valid_594410
  var valid_594411 = query.getOrDefault("$.xgafv")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = newJString("1"))
  if valid_594411 != nil:
    section.add "$.xgafv", valid_594411
  var valid_594412 = query.getOrDefault("prettyPrint")
  valid_594412 = validateParameter(valid_594412, JBool, required = false,
                                 default = newJBool(true))
  if valid_594412 != nil:
    section.add "prettyPrint", valid_594412
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

proc call*(call_594414: Call_DataprocProjectsLocationsWorkflowTemplatesCreate_594398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new workflow template.
  ## 
  let valid = call_594414.validator(path, query, header, formData, body)
  let scheme = call_594414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594414.url(scheme.get, call_594414.host, call_594414.base,
                         call_594414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594414, url, valid)

proc call*(call_594415: Call_DataprocProjectsLocationsWorkflowTemplatesCreate_594398;
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
  var path_594416 = newJObject()
  var query_594417 = newJObject()
  var body_594418 = newJObject()
  add(query_594417, "upload_protocol", newJString(uploadProtocol))
  add(query_594417, "fields", newJString(fields))
  add(query_594417, "quotaUser", newJString(quotaUser))
  add(query_594417, "alt", newJString(alt))
  add(query_594417, "oauth_token", newJString(oauthToken))
  add(query_594417, "callback", newJString(callback))
  add(query_594417, "access_token", newJString(accessToken))
  add(query_594417, "uploadType", newJString(uploadType))
  add(path_594416, "parent", newJString(parent))
  add(query_594417, "key", newJString(key))
  add(query_594417, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594418 = body
  add(query_594417, "prettyPrint", newJBool(prettyPrint))
  result = call_594415.call(path_594416, query_594417, nil, nil, body_594418)

var dataprocProjectsLocationsWorkflowTemplatesCreate* = Call_DataprocProjectsLocationsWorkflowTemplatesCreate_594398(
    name: "dataprocProjectsLocationsWorkflowTemplatesCreate",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsLocationsWorkflowTemplatesCreate_594399,
    base: "/", url: url_DataprocProjectsLocationsWorkflowTemplatesCreate_594400,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesList_594377 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsWorkflowTemplatesList_594379(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsWorkflowTemplatesList_594378(
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
  var valid_594380 = path.getOrDefault("parent")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "parent", valid_594380
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
  var valid_594381 = query.getOrDefault("upload_protocol")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "upload_protocol", valid_594381
  var valid_594382 = query.getOrDefault("fields")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "fields", valid_594382
  var valid_594383 = query.getOrDefault("pageToken")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "pageToken", valid_594383
  var valid_594384 = query.getOrDefault("quotaUser")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "quotaUser", valid_594384
  var valid_594385 = query.getOrDefault("alt")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = newJString("json"))
  if valid_594385 != nil:
    section.add "alt", valid_594385
  var valid_594386 = query.getOrDefault("oauth_token")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "oauth_token", valid_594386
  var valid_594387 = query.getOrDefault("callback")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "callback", valid_594387
  var valid_594388 = query.getOrDefault("access_token")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "access_token", valid_594388
  var valid_594389 = query.getOrDefault("uploadType")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "uploadType", valid_594389
  var valid_594390 = query.getOrDefault("key")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "key", valid_594390
  var valid_594391 = query.getOrDefault("$.xgafv")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = newJString("1"))
  if valid_594391 != nil:
    section.add "$.xgafv", valid_594391
  var valid_594392 = query.getOrDefault("pageSize")
  valid_594392 = validateParameter(valid_594392, JInt, required = false, default = nil)
  if valid_594392 != nil:
    section.add "pageSize", valid_594392
  var valid_594393 = query.getOrDefault("prettyPrint")
  valid_594393 = validateParameter(valid_594393, JBool, required = false,
                                 default = newJBool(true))
  if valid_594393 != nil:
    section.add "prettyPrint", valid_594393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_DataprocProjectsLocationsWorkflowTemplatesList_594377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists workflows that match the specified filter in the request.
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_DataprocProjectsLocationsWorkflowTemplatesList_594377;
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
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  add(query_594397, "upload_protocol", newJString(uploadProtocol))
  add(query_594397, "fields", newJString(fields))
  add(query_594397, "pageToken", newJString(pageToken))
  add(query_594397, "quotaUser", newJString(quotaUser))
  add(query_594397, "alt", newJString(alt))
  add(query_594397, "oauth_token", newJString(oauthToken))
  add(query_594397, "callback", newJString(callback))
  add(query_594397, "access_token", newJString(accessToken))
  add(query_594397, "uploadType", newJString(uploadType))
  add(path_594396, "parent", newJString(parent))
  add(query_594397, "key", newJString(key))
  add(query_594397, "$.xgafv", newJString(Xgafv))
  add(query_594397, "pageSize", newJInt(pageSize))
  add(query_594397, "prettyPrint", newJBool(prettyPrint))
  result = call_594395.call(path_594396, query_594397, nil, nil, nil)

var dataprocProjectsLocationsWorkflowTemplatesList* = Call_DataprocProjectsLocationsWorkflowTemplatesList_594377(
    name: "dataprocProjectsLocationsWorkflowTemplatesList",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates",
    validator: validate_DataprocProjectsLocationsWorkflowTemplatesList_594378,
    base: "/", url: url_DataprocProjectsLocationsWorkflowTemplatesList_594379,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594419 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594421(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594420(
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
  var valid_594422 = path.getOrDefault("parent")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "parent", valid_594422
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
  var valid_594423 = query.getOrDefault("upload_protocol")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "upload_protocol", valid_594423
  var valid_594424 = query.getOrDefault("fields")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "fields", valid_594424
  var valid_594425 = query.getOrDefault("requestId")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "requestId", valid_594425
  var valid_594426 = query.getOrDefault("quotaUser")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "quotaUser", valid_594426
  var valid_594427 = query.getOrDefault("alt")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = newJString("json"))
  if valid_594427 != nil:
    section.add "alt", valid_594427
  var valid_594428 = query.getOrDefault("oauth_token")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = nil)
  if valid_594428 != nil:
    section.add "oauth_token", valid_594428
  var valid_594429 = query.getOrDefault("callback")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = nil)
  if valid_594429 != nil:
    section.add "callback", valid_594429
  var valid_594430 = query.getOrDefault("access_token")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "access_token", valid_594430
  var valid_594431 = query.getOrDefault("uploadType")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "uploadType", valid_594431
  var valid_594432 = query.getOrDefault("key")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "key", valid_594432
  var valid_594433 = query.getOrDefault("$.xgafv")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = newJString("1"))
  if valid_594433 != nil:
    section.add "$.xgafv", valid_594433
  var valid_594434 = query.getOrDefault("instanceId")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "instanceId", valid_594434
  var valid_594435 = query.getOrDefault("prettyPrint")
  valid_594435 = validateParameter(valid_594435, JBool, required = false,
                                 default = newJBool(true))
  if valid_594435 != nil:
    section.add "prettyPrint", valid_594435
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

proc call*(call_594437: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Instantiates a template and begins execution.This method is equivalent to executing the sequence CreateWorkflowTemplate, InstantiateWorkflowTemplate, DeleteWorkflowTemplate.The returned Operation can be used to track execution of workflow by polling operations.get. The Operation will complete when entire workflow is finished.The running workflow can be aborted via operations.cancel. This will cause any inflight jobs to be cancelled and workflow-owned clusters to be deleted.The Operation.metadata will be WorkflowMetadata. Also see Using WorkflowMetadata.On successful completion, Operation.response will be Empty.
  ## 
  let valid = call_594437.validator(path, query, header, formData, body)
  let scheme = call_594437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594437.url(scheme.get, call_594437.host, call_594437.base,
                         call_594437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594437, url, valid)

proc call*(call_594438: Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594419;
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
  var path_594439 = newJObject()
  var query_594440 = newJObject()
  var body_594441 = newJObject()
  add(query_594440, "upload_protocol", newJString(uploadProtocol))
  add(query_594440, "fields", newJString(fields))
  add(query_594440, "requestId", newJString(requestId))
  add(query_594440, "quotaUser", newJString(quotaUser))
  add(query_594440, "alt", newJString(alt))
  add(query_594440, "oauth_token", newJString(oauthToken))
  add(query_594440, "callback", newJString(callback))
  add(query_594440, "access_token", newJString(accessToken))
  add(query_594440, "uploadType", newJString(uploadType))
  add(path_594439, "parent", newJString(parent))
  add(query_594440, "key", newJString(key))
  add(query_594440, "$.xgafv", newJString(Xgafv))
  add(query_594440, "instanceId", newJString(instanceId))
  if body != nil:
    body_594441 = body
  add(query_594440, "prettyPrint", newJBool(prettyPrint))
  result = call_594438.call(path_594439, query_594440, nil, nil, body_594441)

var dataprocProjectsLocationsWorkflowTemplatesInstantiateInline* = Call_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594419(
    name: "dataprocProjectsLocationsWorkflowTemplatesInstantiateInline",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{parent}/workflowTemplates:instantiateInline", validator: validate_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594420,
    base: "/",
    url: url_DataprocProjectsLocationsWorkflowTemplatesInstantiateInline_594421,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594442 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594444(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594443(
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
  var valid_594445 = path.getOrDefault("resource")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "resource", valid_594445
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
  var valid_594446 = query.getOrDefault("upload_protocol")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "upload_protocol", valid_594446
  var valid_594447 = query.getOrDefault("fields")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "fields", valid_594447
  var valid_594448 = query.getOrDefault("quotaUser")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "quotaUser", valid_594448
  var valid_594449 = query.getOrDefault("alt")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = newJString("json"))
  if valid_594449 != nil:
    section.add "alt", valid_594449
  var valid_594450 = query.getOrDefault("oauth_token")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "oauth_token", valid_594450
  var valid_594451 = query.getOrDefault("callback")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "callback", valid_594451
  var valid_594452 = query.getOrDefault("access_token")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "access_token", valid_594452
  var valid_594453 = query.getOrDefault("uploadType")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "uploadType", valid_594453
  var valid_594454 = query.getOrDefault("options.requestedPolicyVersion")
  valid_594454 = validateParameter(valid_594454, JInt, required = false, default = nil)
  if valid_594454 != nil:
    section.add "options.requestedPolicyVersion", valid_594454
  var valid_594455 = query.getOrDefault("key")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "key", valid_594455
  var valid_594456 = query.getOrDefault("$.xgafv")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = newJString("1"))
  if valid_594456 != nil:
    section.add "$.xgafv", valid_594456
  var valid_594457 = query.getOrDefault("prettyPrint")
  valid_594457 = validateParameter(valid_594457, JBool, required = false,
                                 default = newJBool(true))
  if valid_594457 != nil:
    section.add "prettyPrint", valid_594457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594458: Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. Returns an empty policy if the resource exists and does not have a policy set.
  ## 
  let valid = call_594458.validator(path, query, header, formData, body)
  let scheme = call_594458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594458.url(scheme.get, call_594458.host, call_594458.base,
                         call_594458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594458, url, valid)

proc call*(call_594459: Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594442;
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
  var path_594460 = newJObject()
  var query_594461 = newJObject()
  add(query_594461, "upload_protocol", newJString(uploadProtocol))
  add(query_594461, "fields", newJString(fields))
  add(query_594461, "quotaUser", newJString(quotaUser))
  add(query_594461, "alt", newJString(alt))
  add(query_594461, "oauth_token", newJString(oauthToken))
  add(query_594461, "callback", newJString(callback))
  add(query_594461, "access_token", newJString(accessToken))
  add(query_594461, "uploadType", newJString(uploadType))
  add(query_594461, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594461, "key", newJString(key))
  add(query_594461, "$.xgafv", newJString(Xgafv))
  add(path_594460, "resource", newJString(resource))
  add(query_594461, "prettyPrint", newJBool(prettyPrint))
  result = call_594459.call(path_594460, query_594461, nil, nil, nil)

var dataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy* = Call_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594442(
    name: "dataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:getIamPolicy", validator: validate_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594443,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesGetIamPolicy_594444,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594462 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594464(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594463(
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
  var valid_594465 = path.getOrDefault("resource")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "resource", valid_594465
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
  var valid_594466 = query.getOrDefault("upload_protocol")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "upload_protocol", valid_594466
  var valid_594467 = query.getOrDefault("fields")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "fields", valid_594467
  var valid_594468 = query.getOrDefault("quotaUser")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = nil)
  if valid_594468 != nil:
    section.add "quotaUser", valid_594468
  var valid_594469 = query.getOrDefault("alt")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = newJString("json"))
  if valid_594469 != nil:
    section.add "alt", valid_594469
  var valid_594470 = query.getOrDefault("oauth_token")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "oauth_token", valid_594470
  var valid_594471 = query.getOrDefault("callback")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "callback", valid_594471
  var valid_594472 = query.getOrDefault("access_token")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "access_token", valid_594472
  var valid_594473 = query.getOrDefault("uploadType")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "uploadType", valid_594473
  var valid_594474 = query.getOrDefault("key")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "key", valid_594474
  var valid_594475 = query.getOrDefault("$.xgafv")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = newJString("1"))
  if valid_594475 != nil:
    section.add "$.xgafv", valid_594475
  var valid_594476 = query.getOrDefault("prettyPrint")
  valid_594476 = validateParameter(valid_594476, JBool, required = false,
                                 default = newJBool(true))
  if valid_594476 != nil:
    section.add "prettyPrint", valid_594476
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

proc call*(call_594478: Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594462;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_594478.validator(path, query, header, formData, body)
  let scheme = call_594478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594478.url(scheme.get, call_594478.host, call_594478.base,
                         call_594478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594478, url, valid)

proc call*(call_594479: Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594462;
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
  var path_594480 = newJObject()
  var query_594481 = newJObject()
  var body_594482 = newJObject()
  add(query_594481, "upload_protocol", newJString(uploadProtocol))
  add(query_594481, "fields", newJString(fields))
  add(query_594481, "quotaUser", newJString(quotaUser))
  add(query_594481, "alt", newJString(alt))
  add(query_594481, "oauth_token", newJString(oauthToken))
  add(query_594481, "callback", newJString(callback))
  add(query_594481, "access_token", newJString(accessToken))
  add(query_594481, "uploadType", newJString(uploadType))
  add(query_594481, "key", newJString(key))
  add(query_594481, "$.xgafv", newJString(Xgafv))
  add(path_594480, "resource", newJString(resource))
  if body != nil:
    body_594482 = body
  add(query_594481, "prettyPrint", newJBool(prettyPrint))
  result = call_594479.call(path_594480, query_594481, nil, nil, body_594482)

var dataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy* = Call_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594462(
    name: "dataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:setIamPolicy", validator: validate_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594463,
    base: "/", url: url_DataprocProjectsLocationsAutoscalingPoliciesSetIamPolicy_594464,
    schemes: {Scheme.Https})
type
  Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594483 = ref object of OpenApiRestCall_593421
proc url_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594485(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594484(
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
  var valid_594486 = path.getOrDefault("resource")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "resource", valid_594486
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
  var valid_594487 = query.getOrDefault("upload_protocol")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = nil)
  if valid_594487 != nil:
    section.add "upload_protocol", valid_594487
  var valid_594488 = query.getOrDefault("fields")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "fields", valid_594488
  var valid_594489 = query.getOrDefault("quotaUser")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "quotaUser", valid_594489
  var valid_594490 = query.getOrDefault("alt")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = newJString("json"))
  if valid_594490 != nil:
    section.add "alt", valid_594490
  var valid_594491 = query.getOrDefault("oauth_token")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = nil)
  if valid_594491 != nil:
    section.add "oauth_token", valid_594491
  var valid_594492 = query.getOrDefault("callback")
  valid_594492 = validateParameter(valid_594492, JString, required = false,
                                 default = nil)
  if valid_594492 != nil:
    section.add "callback", valid_594492
  var valid_594493 = query.getOrDefault("access_token")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = nil)
  if valid_594493 != nil:
    section.add "access_token", valid_594493
  var valid_594494 = query.getOrDefault("uploadType")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "uploadType", valid_594494
  var valid_594495 = query.getOrDefault("key")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "key", valid_594495
  var valid_594496 = query.getOrDefault("$.xgafv")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = newJString("1"))
  if valid_594496 != nil:
    section.add "$.xgafv", valid_594496
  var valid_594497 = query.getOrDefault("prettyPrint")
  valid_594497 = validateParameter(valid_594497, JBool, required = false,
                                 default = newJBool(true))
  if valid_594497 != nil:
    section.add "prettyPrint", valid_594497
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

proc call*(call_594499: Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594483;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource. If the resource does not exist, this will return an empty set of permissions, not a NOT_FOUND error.Note: This operation is designed to be used for building permission-aware UIs and command-line tools, not for authorization checking. This operation may "fail open" without warning.
  ## 
  let valid = call_594499.validator(path, query, header, formData, body)
  let scheme = call_594499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594499.url(scheme.get, call_594499.host, call_594499.base,
                         call_594499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594499, url, valid)

proc call*(call_594500: Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594483;
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
  var path_594501 = newJObject()
  var query_594502 = newJObject()
  var body_594503 = newJObject()
  add(query_594502, "upload_protocol", newJString(uploadProtocol))
  add(query_594502, "fields", newJString(fields))
  add(query_594502, "quotaUser", newJString(quotaUser))
  add(query_594502, "alt", newJString(alt))
  add(query_594502, "oauth_token", newJString(oauthToken))
  add(query_594502, "callback", newJString(callback))
  add(query_594502, "access_token", newJString(accessToken))
  add(query_594502, "uploadType", newJString(uploadType))
  add(query_594502, "key", newJString(key))
  add(query_594502, "$.xgafv", newJString(Xgafv))
  add(path_594501, "resource", newJString(resource))
  if body != nil:
    body_594503 = body
  add(query_594502, "prettyPrint", newJBool(prettyPrint))
  result = call_594500.call(path_594501, query_594502, nil, nil, body_594503)

var dataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions* = Call_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594483(
    name: "dataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "dataproc.googleapis.com",
    route: "/v1beta2/{resource}:testIamPermissions", validator: validate_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594484,
    base: "/",
    url: url_DataprocProjectsLocationsAutoscalingPoliciesTestIamPermissions_594485,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
