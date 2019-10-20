
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Dataproc
## version: v1beta1
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
  gcpServiceName = "dataproc"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataprocProjectsClustersCreate_578903 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsClustersCreate_578905(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsClustersCreate_578904(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578906 = path.getOrDefault("projectId")
  valid_578906 = validateParameter(valid_578906, JString, required = true,
                                 default = nil)
  if valid_578906 != nil:
    section.add "projectId", valid_578906
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578907 = query.getOrDefault("key")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "key", valid_578907
  var valid_578908 = query.getOrDefault("pp")
  valid_578908 = validateParameter(valid_578908, JBool, required = false,
                                 default = newJBool(true))
  if valid_578908 != nil:
    section.add "pp", valid_578908
  var valid_578909 = query.getOrDefault("prettyPrint")
  valid_578909 = validateParameter(valid_578909, JBool, required = false,
                                 default = newJBool(true))
  if valid_578909 != nil:
    section.add "prettyPrint", valid_578909
  var valid_578910 = query.getOrDefault("oauth_token")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "oauth_token", valid_578910
  var valid_578911 = query.getOrDefault("$.xgafv")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("1"))
  if valid_578911 != nil:
    section.add "$.xgafv", valid_578911
  var valid_578912 = query.getOrDefault("bearer_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "bearer_token", valid_578912
  var valid_578913 = query.getOrDefault("uploadType")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "uploadType", valid_578913
  var valid_578914 = query.getOrDefault("alt")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("json"))
  if valid_578914 != nil:
    section.add "alt", valid_578914
  var valid_578915 = query.getOrDefault("quotaUser")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "quotaUser", valid_578915
  var valid_578916 = query.getOrDefault("callback")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "callback", valid_578916
  var valid_578917 = query.getOrDefault("fields")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "fields", valid_578917
  var valid_578918 = query.getOrDefault("upload_protocol")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "upload_protocol", valid_578918
  var valid_578919 = query.getOrDefault("access_token")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "access_token", valid_578919
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

proc call*(call_578921: Call_DataprocProjectsClustersCreate_578903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a cluster in a project.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_DataprocProjectsClustersCreate_578903;
          projectId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsClustersCreate
  ## Creates a cluster in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578923 = newJObject()
  var query_578924 = newJObject()
  var body_578925 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "pp", newJBool(pp))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(path_578923, "projectId", newJString(projectId))
  add(query_578924, "$.xgafv", newJString(Xgafv))
  add(query_578924, "bearer_token", newJString(bearerToken))
  add(query_578924, "uploadType", newJString(uploadType))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578925 = body
  add(query_578924, "callback", newJString(callback))
  add(query_578924, "fields", newJString(fields))
  add(query_578924, "upload_protocol", newJString(uploadProtocol))
  add(query_578924, "access_token", newJString(accessToken))
  result = call_578922.call(path_578923, query_578924, nil, nil, body_578925)

var dataprocProjectsClustersCreate* = Call_DataprocProjectsClustersCreate_578903(
    name: "dataprocProjectsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersCreate_578904, base: "/",
    url: url_DataprocProjectsClustersCreate_578905, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersList_578610 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsClustersList_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsClustersList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all clusters in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : The standard List page size.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The standard List page token.
  ##   filter: JString
  ##         : Optional A filter constraining which clusters to list. Valid filters contain label terms such as: labels.key1 = val1 AND (-labels.k2 = val2 OR labels.k3 = val3)
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("pp")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "pp", valid_578753
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("$.xgafv")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("1"))
  if valid_578756 != nil:
    section.add "$.xgafv", valid_578756
  var valid_578757 = query.getOrDefault("bearer_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "bearer_token", valid_578757
  var valid_578758 = query.getOrDefault("pageSize")
  valid_578758 = validateParameter(valid_578758, JInt, required = false, default = nil)
  if valid_578758 != nil:
    section.add "pageSize", valid_578758
  var valid_578759 = query.getOrDefault("uploadType")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "uploadType", valid_578759
  var valid_578760 = query.getOrDefault("alt")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = newJString("json"))
  if valid_578760 != nil:
    section.add "alt", valid_578760
  var valid_578761 = query.getOrDefault("quotaUser")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "quotaUser", valid_578761
  var valid_578762 = query.getOrDefault("pageToken")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "pageToken", valid_578762
  var valid_578763 = query.getOrDefault("filter")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "filter", valid_578763
  var valid_578764 = query.getOrDefault("callback")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "callback", valid_578764
  var valid_578765 = query.getOrDefault("fields")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "fields", valid_578765
  var valid_578766 = query.getOrDefault("upload_protocol")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "upload_protocol", valid_578766
  var valid_578767 = query.getOrDefault("access_token")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "access_token", valid_578767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578790: Call_DataprocProjectsClustersList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all clusters in a project.
  ## 
  let valid = call_578790.validator(path, query, header, formData, body)
  let scheme = call_578790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578790.url(scheme.get, call_578790.host, call_578790.base,
                         call_578790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578790, url, valid)

proc call*(call_578861: Call_DataprocProjectsClustersList_578610;
          projectId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; pageToken: string = ""; filter: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocProjectsClustersList
  ## Lists all clusters in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : The standard List page size.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The standard List page token.
  ##   filter: string
  ##         : Optional A filter constraining which clusters to list. Valid filters contain label terms such as: labels.key1 = val1 AND (-labels.k2 = val2 OR labels.k3 = val3)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578862 = newJObject()
  var query_578864 = newJObject()
  add(query_578864, "key", newJString(key))
  add(query_578864, "pp", newJBool(pp))
  add(query_578864, "prettyPrint", newJBool(prettyPrint))
  add(query_578864, "oauth_token", newJString(oauthToken))
  add(path_578862, "projectId", newJString(projectId))
  add(query_578864, "$.xgafv", newJString(Xgafv))
  add(query_578864, "bearer_token", newJString(bearerToken))
  add(query_578864, "pageSize", newJInt(pageSize))
  add(query_578864, "uploadType", newJString(uploadType))
  add(query_578864, "alt", newJString(alt))
  add(query_578864, "quotaUser", newJString(quotaUser))
  add(query_578864, "pageToken", newJString(pageToken))
  add(query_578864, "filter", newJString(filter))
  add(query_578864, "callback", newJString(callback))
  add(query_578864, "fields", newJString(fields))
  add(query_578864, "upload_protocol", newJString(uploadProtocol))
  add(query_578864, "access_token", newJString(accessToken))
  result = call_578861.call(path_578862, query_578864, nil, nil, nil)

var dataprocProjectsClustersList* = Call_DataprocProjectsClustersList_578610(
    name: "dataprocProjectsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersList_578611, base: "/",
    url: url_DataprocProjectsClustersList_578612, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersGet_578926 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsClustersGet_578928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsClustersGet_578927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required The cluster name.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_578929 = path.getOrDefault("clusterName")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "clusterName", valid_578929
  var valid_578930 = path.getOrDefault("projectId")
  valid_578930 = validateParameter(valid_578930, JString, required = true,
                                 default = nil)
  if valid_578930 != nil:
    section.add "projectId", valid_578930
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578931 = query.getOrDefault("key")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "key", valid_578931
  var valid_578932 = query.getOrDefault("pp")
  valid_578932 = validateParameter(valid_578932, JBool, required = false,
                                 default = newJBool(true))
  if valid_578932 != nil:
    section.add "pp", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("$.xgafv")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("1"))
  if valid_578935 != nil:
    section.add "$.xgafv", valid_578935
  var valid_578936 = query.getOrDefault("bearer_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "bearer_token", valid_578936
  var valid_578937 = query.getOrDefault("uploadType")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "uploadType", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("callback")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "callback", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
  var valid_578942 = query.getOrDefault("upload_protocol")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "upload_protocol", valid_578942
  var valid_578943 = query.getOrDefault("access_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "access_token", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578944: Call_DataprocProjectsClustersGet_578926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_DataprocProjectsClustersGet_578926;
          clusterName: string; projectId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsClustersGet
  ## Gets the resource representation for a cluster in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   clusterName: string (required)
  ##              : Required The cluster name.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "pp", newJBool(pp))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(path_578946, "clusterName", newJString(clusterName))
  add(path_578946, "projectId", newJString(projectId))
  add(query_578947, "$.xgafv", newJString(Xgafv))
  add(query_578947, "bearer_token", newJString(bearerToken))
  add(query_578947, "uploadType", newJString(uploadType))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(query_578947, "callback", newJString(callback))
  add(query_578947, "fields", newJString(fields))
  add(query_578947, "upload_protocol", newJString(uploadProtocol))
  add(query_578947, "access_token", newJString(accessToken))
  result = call_578945.call(path_578946, query_578947, nil, nil, nil)

var dataprocProjectsClustersGet* = Call_DataprocProjectsClustersGet_578926(
    name: "dataprocProjectsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersGet_578927, base: "/",
    url: url_DataprocProjectsClustersGet_578928, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersPatch_578970 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsClustersPatch_578972(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsClustersPatch_578971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required The cluster name.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project the cluster belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_578973 = path.getOrDefault("clusterName")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "clusterName", valid_578973
  var valid_578974 = path.getOrDefault("projectId")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "projectId", valid_578974
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required Specifies the path, relative to <code>Cluster</code>, of the field to update. For example, to change the number of workers in a cluster to 5, the <code>update_mask</code> parameter would be specified as <code>configuration.worker_configuration.num_instances</code>, and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "configuration":{
  ##     "workerConfiguration":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## Similarly, to change the number of preemptible workers in a cluster to 5, the <code>update_mask</code> parameter would be <code>config.secondary_worker_config.num_instances</code>, and the PATCH request body would be set as follows:
  ## {
  ##   "config":{
  ##     "secondaryWorkerConfig":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> Currently, <code>config.worker_config.num_instances</code> and <code>config.secondary_worker_config.num_instances</code> are the only fields that can be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("pp")
  valid_578976 = validateParameter(valid_578976, JBool, required = false,
                                 default = newJBool(true))
  if valid_578976 != nil:
    section.add "pp", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("$.xgafv")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("1"))
  if valid_578979 != nil:
    section.add "$.xgafv", valid_578979
  var valid_578980 = query.getOrDefault("bearer_token")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "bearer_token", valid_578980
  var valid_578981 = query.getOrDefault("uploadType")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "uploadType", valid_578981
  var valid_578982 = query.getOrDefault("alt")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("json"))
  if valid_578982 != nil:
    section.add "alt", valid_578982
  var valid_578983 = query.getOrDefault("quotaUser")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "quotaUser", valid_578983
  var valid_578984 = query.getOrDefault("updateMask")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "updateMask", valid_578984
  var valid_578985 = query.getOrDefault("callback")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "callback", valid_578985
  var valid_578986 = query.getOrDefault("fields")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "fields", valid_578986
  var valid_578987 = query.getOrDefault("upload_protocol")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "upload_protocol", valid_578987
  var valid_578988 = query.getOrDefault("access_token")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "access_token", valid_578988
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

proc call*(call_578990: Call_DataprocProjectsClustersPatch_578970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a cluster in a project.
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_DataprocProjectsClustersPatch_578970;
          clusterName: string; projectId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocProjectsClustersPatch
  ## Updates a cluster in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   clusterName: string (required)
  ##              : Required The cluster name.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Required Specifies the path, relative to <code>Cluster</code>, of the field to update. For example, to change the number of workers in a cluster to 5, the <code>update_mask</code> parameter would be specified as <code>configuration.worker_configuration.num_instances</code>, and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "configuration":{
  ##     "workerConfiguration":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## Similarly, to change the number of preemptible workers in a cluster to 5, the <code>update_mask</code> parameter would be <code>config.secondary_worker_config.num_instances</code>, and the PATCH request body would be set as follows:
  ## {
  ##   "config":{
  ##     "secondaryWorkerConfig":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> Currently, <code>config.worker_config.num_instances</code> and <code>config.secondary_worker_config.num_instances</code> are the only fields that can be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  var body_578994 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "pp", newJBool(pp))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(path_578992, "clusterName", newJString(clusterName))
  add(path_578992, "projectId", newJString(projectId))
  add(query_578993, "$.xgafv", newJString(Xgafv))
  add(query_578993, "bearer_token", newJString(bearerToken))
  add(query_578993, "uploadType", newJString(uploadType))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "quotaUser", newJString(quotaUser))
  add(query_578993, "updateMask", newJString(updateMask))
  if body != nil:
    body_578994 = body
  add(query_578993, "callback", newJString(callback))
  add(query_578993, "fields", newJString(fields))
  add(query_578993, "upload_protocol", newJString(uploadProtocol))
  add(query_578993, "access_token", newJString(accessToken))
  result = call_578991.call(path_578992, query_578993, nil, nil, body_578994)

var dataprocProjectsClustersPatch* = Call_DataprocProjectsClustersPatch_578970(
    name: "dataprocProjectsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersPatch_578971, base: "/",
    url: url_DataprocProjectsClustersPatch_578972, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDelete_578948 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsClustersDelete_578950(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsClustersDelete_578949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a cluster in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required The cluster name.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_578951 = path.getOrDefault("clusterName")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "clusterName", valid_578951
  var valid_578952 = path.getOrDefault("projectId")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "projectId", valid_578952
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578953 = query.getOrDefault("key")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "key", valid_578953
  var valid_578954 = query.getOrDefault("pp")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(true))
  if valid_578954 != nil:
    section.add "pp", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("$.xgafv")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("1"))
  if valid_578957 != nil:
    section.add "$.xgafv", valid_578957
  var valid_578958 = query.getOrDefault("bearer_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "bearer_token", valid_578958
  var valid_578959 = query.getOrDefault("uploadType")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "uploadType", valid_578959
  var valid_578960 = query.getOrDefault("alt")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("json"))
  if valid_578960 != nil:
    section.add "alt", valid_578960
  var valid_578961 = query.getOrDefault("quotaUser")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "quotaUser", valid_578961
  var valid_578962 = query.getOrDefault("callback")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "callback", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
  var valid_578965 = query.getOrDefault("access_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "access_token", valid_578965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578966: Call_DataprocProjectsClustersDelete_578948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a cluster in a project.
  ## 
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_DataprocProjectsClustersDelete_578948;
          clusterName: string; projectId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsClustersDelete
  ## Deletes a cluster in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   clusterName: string (required)
  ##              : Required The cluster name.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578968 = newJObject()
  var query_578969 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "pp", newJBool(pp))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(path_578968, "clusterName", newJString(clusterName))
  add(path_578968, "projectId", newJString(projectId))
  add(query_578969, "$.xgafv", newJString(Xgafv))
  add(query_578969, "bearer_token", newJString(bearerToken))
  add(query_578969, "uploadType", newJString(uploadType))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "quotaUser", newJString(quotaUser))
  add(query_578969, "callback", newJString(callback))
  add(query_578969, "fields", newJString(fields))
  add(query_578969, "upload_protocol", newJString(uploadProtocol))
  add(query_578969, "access_token", newJString(accessToken))
  result = call_578967.call(path_578968, query_578969, nil, nil, nil)

var dataprocProjectsClustersDelete* = Call_DataprocProjectsClustersDelete_578948(
    name: "dataprocProjectsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersDelete_578949, base: "/",
    url: url_DataprocProjectsClustersDelete_578950, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDiagnose_578995 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsClustersDiagnose_578997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: ":diagnose")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsClustersDiagnose_578996(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets cluster diagnostic information. After the operation completes, the Operation.response field contains DiagnoseClusterOutputLocation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : Required The cluster name.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_578998 = path.getOrDefault("clusterName")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "clusterName", valid_578998
  var valid_578999 = path.getOrDefault("projectId")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "projectId", valid_578999
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579000 = query.getOrDefault("key")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "key", valid_579000
  var valid_579001 = query.getOrDefault("pp")
  valid_579001 = validateParameter(valid_579001, JBool, required = false,
                                 default = newJBool(true))
  if valid_579001 != nil:
    section.add "pp", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("$.xgafv")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("1"))
  if valid_579004 != nil:
    section.add "$.xgafv", valid_579004
  var valid_579005 = query.getOrDefault("bearer_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "bearer_token", valid_579005
  var valid_579006 = query.getOrDefault("uploadType")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "uploadType", valid_579006
  var valid_579007 = query.getOrDefault("alt")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("json"))
  if valid_579007 != nil:
    section.add "alt", valid_579007
  var valid_579008 = query.getOrDefault("quotaUser")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "quotaUser", valid_579008
  var valid_579009 = query.getOrDefault("callback")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "callback", valid_579009
  var valid_579010 = query.getOrDefault("fields")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "fields", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
  var valid_579012 = query.getOrDefault("access_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "access_token", valid_579012
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

proc call*(call_579014: Call_DataprocProjectsClustersDiagnose_578995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. After the operation completes, the Operation.response field contains DiagnoseClusterOutputLocation.
  ## 
  let valid = call_579014.validator(path, query, header, formData, body)
  let scheme = call_579014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579014.url(scheme.get, call_579014.host, call_579014.base,
                         call_579014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579014, url, valid)

proc call*(call_579015: Call_DataprocProjectsClustersDiagnose_578995;
          clusterName: string; projectId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsClustersDiagnose
  ## Gets cluster diagnostic information. After the operation completes, the Operation.response field contains DiagnoseClusterOutputLocation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   clusterName: string (required)
  ##              : Required The cluster name.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the cluster belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579016 = newJObject()
  var query_579017 = newJObject()
  var body_579018 = newJObject()
  add(query_579017, "key", newJString(key))
  add(query_579017, "pp", newJBool(pp))
  add(query_579017, "prettyPrint", newJBool(prettyPrint))
  add(query_579017, "oauth_token", newJString(oauthToken))
  add(path_579016, "clusterName", newJString(clusterName))
  add(path_579016, "projectId", newJString(projectId))
  add(query_579017, "$.xgafv", newJString(Xgafv))
  add(query_579017, "bearer_token", newJString(bearerToken))
  add(query_579017, "uploadType", newJString(uploadType))
  add(query_579017, "alt", newJString(alt))
  add(query_579017, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579018 = body
  add(query_579017, "callback", newJString(callback))
  add(query_579017, "fields", newJString(fields))
  add(query_579017, "upload_protocol", newJString(uploadProtocol))
  add(query_579017, "access_token", newJString(accessToken))
  result = call_579015.call(path_579016, query_579017, nil, nil, body_579018)

var dataprocProjectsClustersDiagnose* = Call_DataprocProjectsClustersDiagnose_578995(
    name: "dataprocProjectsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsClustersDiagnose_578996, base: "/",
    url: url_DataprocProjectsClustersDiagnose_578997, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsList_579019 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsJobsList_579021(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsJobsList_579020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579022 = path.getOrDefault("projectId")
  valid_579022 = validateParameter(valid_579022, JString, required = true,
                                 default = nil)
  if valid_579022 != nil:
    section.add "projectId", valid_579022
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional The number of results to return in each response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional The page token, returned by a previous call, to request the next page of results.
  ##   filter: JString
  ##         : Optional A filter constraining which jobs to list. Valid filters contain job state and label terms such as: labels.key1 = val1 AND (labels.k2 = val2 OR labels.k3 = val3)
  ##   jobStateMatcher: JString
  ##                  : Optional Specifies enumerated categories of jobs to list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   clusterName: JString
  ##              : Optional If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  section = newJObject()
  var valid_579023 = query.getOrDefault("key")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "key", valid_579023
  var valid_579024 = query.getOrDefault("pp")
  valid_579024 = validateParameter(valid_579024, JBool, required = false,
                                 default = newJBool(true))
  if valid_579024 != nil:
    section.add "pp", valid_579024
  var valid_579025 = query.getOrDefault("prettyPrint")
  valid_579025 = validateParameter(valid_579025, JBool, required = false,
                                 default = newJBool(true))
  if valid_579025 != nil:
    section.add "prettyPrint", valid_579025
  var valid_579026 = query.getOrDefault("oauth_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "oauth_token", valid_579026
  var valid_579027 = query.getOrDefault("$.xgafv")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = newJString("1"))
  if valid_579027 != nil:
    section.add "$.xgafv", valid_579027
  var valid_579028 = query.getOrDefault("bearer_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "bearer_token", valid_579028
  var valid_579029 = query.getOrDefault("pageSize")
  valid_579029 = validateParameter(valid_579029, JInt, required = false, default = nil)
  if valid_579029 != nil:
    section.add "pageSize", valid_579029
  var valid_579030 = query.getOrDefault("uploadType")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "uploadType", valid_579030
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("pageToken")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "pageToken", valid_579033
  var valid_579034 = query.getOrDefault("filter")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "filter", valid_579034
  var valid_579035 = query.getOrDefault("jobStateMatcher")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = newJString("ALL"))
  if valid_579035 != nil:
    section.add "jobStateMatcher", valid_579035
  var valid_579036 = query.getOrDefault("callback")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "callback", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  var valid_579038 = query.getOrDefault("upload_protocol")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "upload_protocol", valid_579038
  var valid_579039 = query.getOrDefault("access_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "access_token", valid_579039
  var valid_579040 = query.getOrDefault("clusterName")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "clusterName", valid_579040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579041: Call_DataprocProjectsJobsList_579019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs in a project.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_DataprocProjectsJobsList_579019; projectId: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; pageToken: string = ""; filter: string = "";
          jobStateMatcher: string = "ALL"; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = "";
          clusterName: string = ""): Recallable =
  ## dataprocProjectsJobsList
  ## Lists jobs in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional The number of results to return in each response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional The page token, returned by a previous call, to request the next page of results.
  ##   filter: string
  ##         : Optional A filter constraining which jobs to list. Valid filters contain job state and label terms such as: labels.key1 = val1 AND (labels.k2 = val2 OR labels.k3 = val3)
  ##   jobStateMatcher: string
  ##                  : Optional Specifies enumerated categories of jobs to list.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clusterName: string
  ##              : Optional If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "pp", newJBool(pp))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(path_579043, "projectId", newJString(projectId))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(query_579044, "bearer_token", newJString(bearerToken))
  add(query_579044, "pageSize", newJInt(pageSize))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(query_579044, "pageToken", newJString(pageToken))
  add(query_579044, "filter", newJString(filter))
  add(query_579044, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_579044, "callback", newJString(callback))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "clusterName", newJString(clusterName))
  result = call_579042.call(path_579043, query_579044, nil, nil, nil)

var dataprocProjectsJobsList* = Call_DataprocProjectsJobsList_579019(
    name: "dataprocProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/projects/{projectId}/jobs",
    validator: validate_DataprocProjectsJobsList_579020, base: "/",
    url: url_DataprocProjectsJobsList_579021, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsGet_579045 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsJobsGet_579047(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsJobsGet_579046(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579048 = path.getOrDefault("projectId")
  valid_579048 = validateParameter(valid_579048, JString, required = true,
                                 default = nil)
  if valid_579048 != nil:
    section.add "projectId", valid_579048
  var valid_579049 = path.getOrDefault("jobId")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "jobId", valid_579049
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579050 = query.getOrDefault("key")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "key", valid_579050
  var valid_579051 = query.getOrDefault("pp")
  valid_579051 = validateParameter(valid_579051, JBool, required = false,
                                 default = newJBool(true))
  if valid_579051 != nil:
    section.add "pp", valid_579051
  var valid_579052 = query.getOrDefault("prettyPrint")
  valid_579052 = validateParameter(valid_579052, JBool, required = false,
                                 default = newJBool(true))
  if valid_579052 != nil:
    section.add "prettyPrint", valid_579052
  var valid_579053 = query.getOrDefault("oauth_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "oauth_token", valid_579053
  var valid_579054 = query.getOrDefault("$.xgafv")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("1"))
  if valid_579054 != nil:
    section.add "$.xgafv", valid_579054
  var valid_579055 = query.getOrDefault("bearer_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "bearer_token", valid_579055
  var valid_579056 = query.getOrDefault("uploadType")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "uploadType", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("quotaUser")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "quotaUser", valid_579058
  var valid_579059 = query.getOrDefault("callback")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "callback", valid_579059
  var valid_579060 = query.getOrDefault("fields")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "fields", valid_579060
  var valid_579061 = query.getOrDefault("upload_protocol")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "upload_protocol", valid_579061
  var valid_579062 = query.getOrDefault("access_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "access_token", valid_579062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579063: Call_DataprocProjectsJobsGet_579045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_579063.validator(path, query, header, formData, body)
  let scheme = call_579063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579063.url(scheme.get, call_579063.host, call_579063.base,
                         call_579063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579063, url, valid)

proc call*(call_579064: Call_DataprocProjectsJobsGet_579045; projectId: string;
          jobId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocProjectsJobsGet
  ## Gets the resource representation for a job in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579065 = newJObject()
  var query_579066 = newJObject()
  add(query_579066, "key", newJString(key))
  add(query_579066, "pp", newJBool(pp))
  add(query_579066, "prettyPrint", newJBool(prettyPrint))
  add(query_579066, "oauth_token", newJString(oauthToken))
  add(path_579065, "projectId", newJString(projectId))
  add(path_579065, "jobId", newJString(jobId))
  add(query_579066, "$.xgafv", newJString(Xgafv))
  add(query_579066, "bearer_token", newJString(bearerToken))
  add(query_579066, "uploadType", newJString(uploadType))
  add(query_579066, "alt", newJString(alt))
  add(query_579066, "quotaUser", newJString(quotaUser))
  add(query_579066, "callback", newJString(callback))
  add(query_579066, "fields", newJString(fields))
  add(query_579066, "upload_protocol", newJString(uploadProtocol))
  add(query_579066, "access_token", newJString(accessToken))
  result = call_579064.call(path_579065, query_579066, nil, nil, nil)

var dataprocProjectsJobsGet* = Call_DataprocProjectsJobsGet_579045(
    name: "dataprocProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsGet_579046, base: "/",
    url: url_DataprocProjectsJobsGet_579047, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsPatch_579089 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsJobsPatch_579091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsJobsPatch_579090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579092 = path.getOrDefault("projectId")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "projectId", valid_579092
  var valid_579093 = path.getOrDefault("jobId")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "jobId", valid_579093
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579094 = query.getOrDefault("key")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "key", valid_579094
  var valid_579095 = query.getOrDefault("pp")
  valid_579095 = validateParameter(valid_579095, JBool, required = false,
                                 default = newJBool(true))
  if valid_579095 != nil:
    section.add "pp", valid_579095
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
  var valid_579099 = query.getOrDefault("bearer_token")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "bearer_token", valid_579099
  var valid_579100 = query.getOrDefault("uploadType")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "uploadType", valid_579100
  var valid_579101 = query.getOrDefault("alt")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = newJString("json"))
  if valid_579101 != nil:
    section.add "alt", valid_579101
  var valid_579102 = query.getOrDefault("quotaUser")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "quotaUser", valid_579102
  var valid_579103 = query.getOrDefault("updateMask")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "updateMask", valid_579103
  var valid_579104 = query.getOrDefault("callback")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "callback", valid_579104
  var valid_579105 = query.getOrDefault("fields")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "fields", valid_579105
  var valid_579106 = query.getOrDefault("upload_protocol")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "upload_protocol", valid_579106
  var valid_579107 = query.getOrDefault("access_token")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "access_token", valid_579107
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

proc call*(call_579109: Call_DataprocProjectsJobsPatch_579089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_579109.validator(path, query, header, formData, body)
  let scheme = call_579109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579109.url(scheme.get, call_579109.host, call_579109.base,
                         call_579109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579109, url, valid)

proc call*(call_579110: Call_DataprocProjectsJobsPatch_579089; projectId: string;
          jobId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsJobsPatch
  ## Updates a job in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Required Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579111 = newJObject()
  var query_579112 = newJObject()
  var body_579113 = newJObject()
  add(query_579112, "key", newJString(key))
  add(query_579112, "pp", newJBool(pp))
  add(query_579112, "prettyPrint", newJBool(prettyPrint))
  add(query_579112, "oauth_token", newJString(oauthToken))
  add(path_579111, "projectId", newJString(projectId))
  add(path_579111, "jobId", newJString(jobId))
  add(query_579112, "$.xgafv", newJString(Xgafv))
  add(query_579112, "bearer_token", newJString(bearerToken))
  add(query_579112, "uploadType", newJString(uploadType))
  add(query_579112, "alt", newJString(alt))
  add(query_579112, "quotaUser", newJString(quotaUser))
  add(query_579112, "updateMask", newJString(updateMask))
  if body != nil:
    body_579113 = body
  add(query_579112, "callback", newJString(callback))
  add(query_579112, "fields", newJString(fields))
  add(query_579112, "upload_protocol", newJString(uploadProtocol))
  add(query_579112, "access_token", newJString(accessToken))
  result = call_579110.call(path_579111, query_579112, nil, nil, body_579113)

var dataprocProjectsJobsPatch* = Call_DataprocProjectsJobsPatch_579089(
    name: "dataprocProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsPatch_579090, base: "/",
    url: url_DataprocProjectsJobsPatch_579091, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsDelete_579067 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsJobsDelete_579069(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsJobsDelete_579068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579070 = path.getOrDefault("projectId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "projectId", valid_579070
  var valid_579071 = path.getOrDefault("jobId")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "jobId", valid_579071
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579072 = query.getOrDefault("key")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "key", valid_579072
  var valid_579073 = query.getOrDefault("pp")
  valid_579073 = validateParameter(valid_579073, JBool, required = false,
                                 default = newJBool(true))
  if valid_579073 != nil:
    section.add "pp", valid_579073
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
  var valid_579077 = query.getOrDefault("bearer_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "bearer_token", valid_579077
  var valid_579078 = query.getOrDefault("uploadType")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "uploadType", valid_579078
  var valid_579079 = query.getOrDefault("alt")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("json"))
  if valid_579079 != nil:
    section.add "alt", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("callback")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "callback", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  var valid_579083 = query.getOrDefault("upload_protocol")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "upload_protocol", valid_579083
  var valid_579084 = query.getOrDefault("access_token")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "access_token", valid_579084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579085: Call_DataprocProjectsJobsDelete_579067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_DataprocProjectsJobsDelete_579067; projectId: string;
          jobId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocProjectsJobsDelete
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "pp", newJBool(pp))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(path_579087, "projectId", newJString(projectId))
  add(path_579087, "jobId", newJString(jobId))
  add(query_579088, "$.xgafv", newJString(Xgafv))
  add(query_579088, "bearer_token", newJString(bearerToken))
  add(query_579088, "uploadType", newJString(uploadType))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(query_579088, "callback", newJString(callback))
  add(query_579088, "fields", newJString(fields))
  add(query_579088, "upload_protocol", newJString(uploadProtocol))
  add(query_579088, "access_token", newJString(accessToken))
  result = call_579086.call(path_579087, query_579088, nil, nil, nil)

var dataprocProjectsJobsDelete* = Call_DataprocProjectsJobsDelete_579067(
    name: "dataprocProjectsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsDelete_579068, base: "/",
    url: url_DataprocProjectsJobsDelete_579069, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsCancel_579114 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsJobsCancel_579116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsJobsCancel_579115(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579117 = path.getOrDefault("projectId")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "projectId", valid_579117
  var valid_579118 = path.getOrDefault("jobId")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "jobId", valid_579118
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579119 = query.getOrDefault("key")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "key", valid_579119
  var valid_579120 = query.getOrDefault("pp")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(true))
  if valid_579120 != nil:
    section.add "pp", valid_579120
  var valid_579121 = query.getOrDefault("prettyPrint")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(true))
  if valid_579121 != nil:
    section.add "prettyPrint", valid_579121
  var valid_579122 = query.getOrDefault("oauth_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "oauth_token", valid_579122
  var valid_579123 = query.getOrDefault("$.xgafv")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("1"))
  if valid_579123 != nil:
    section.add "$.xgafv", valid_579123
  var valid_579124 = query.getOrDefault("bearer_token")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "bearer_token", valid_579124
  var valid_579125 = query.getOrDefault("uploadType")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "uploadType", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("callback")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "callback", valid_579128
  var valid_579129 = query.getOrDefault("fields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "fields", valid_579129
  var valid_579130 = query.getOrDefault("upload_protocol")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "upload_protocol", valid_579130
  var valid_579131 = query.getOrDefault("access_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "access_token", valid_579131
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

proc call*(call_579133: Call_DataprocProjectsJobsCancel_579114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_DataprocProjectsJobsCancel_579114; projectId: string;
          jobId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsJobsCancel
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : Required The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  var body_579137 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "pp", newJBool(pp))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(path_579135, "projectId", newJString(projectId))
  add(path_579135, "jobId", newJString(jobId))
  add(query_579136, "$.xgafv", newJString(Xgafv))
  add(query_579136, "bearer_token", newJString(bearerToken))
  add(query_579136, "uploadType", newJString(uploadType))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579137 = body
  add(query_579136, "callback", newJString(callback))
  add(query_579136, "fields", newJString(fields))
  add(query_579136, "upload_protocol", newJString(uploadProtocol))
  add(query_579136, "access_token", newJString(accessToken))
  result = call_579134.call(path_579135, query_579136, nil, nil, body_579137)

var dataprocProjectsJobsCancel* = Call_DataprocProjectsJobsCancel_579114(
    name: "dataprocProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsJobsCancel_579115, base: "/",
    url: url_DataprocProjectsJobsCancel_579116, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsSubmit_579138 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsJobsSubmit_579140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs:submit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocProjectsJobsSubmit_579139(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits a job to a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579141 = path.getOrDefault("projectId")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "projectId", valid_579141
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("pp")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "pp", valid_579143
  var valid_579144 = query.getOrDefault("prettyPrint")
  valid_579144 = validateParameter(valid_579144, JBool, required = false,
                                 default = newJBool(true))
  if valid_579144 != nil:
    section.add "prettyPrint", valid_579144
  var valid_579145 = query.getOrDefault("oauth_token")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "oauth_token", valid_579145
  var valid_579146 = query.getOrDefault("$.xgafv")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("1"))
  if valid_579146 != nil:
    section.add "$.xgafv", valid_579146
  var valid_579147 = query.getOrDefault("bearer_token")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "bearer_token", valid_579147
  var valid_579148 = query.getOrDefault("uploadType")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "uploadType", valid_579148
  var valid_579149 = query.getOrDefault("alt")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = newJString("json"))
  if valid_579149 != nil:
    section.add "alt", valid_579149
  var valid_579150 = query.getOrDefault("quotaUser")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "quotaUser", valid_579150
  var valid_579151 = query.getOrDefault("callback")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "callback", valid_579151
  var valid_579152 = query.getOrDefault("fields")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "fields", valid_579152
  var valid_579153 = query.getOrDefault("upload_protocol")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "upload_protocol", valid_579153
  var valid_579154 = query.getOrDefault("access_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "access_token", valid_579154
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

proc call*(call_579156: Call_DataprocProjectsJobsSubmit_579138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_579156.validator(path, query, header, formData, body)
  let scheme = call_579156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579156.url(scheme.get, call_579156.host, call_579156.base,
                         call_579156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579156, url, valid)

proc call*(call_579157: Call_DataprocProjectsJobsSubmit_579138; projectId: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsJobsSubmit
  ## Submits a job to a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579158 = newJObject()
  var query_579159 = newJObject()
  var body_579160 = newJObject()
  add(query_579159, "key", newJString(key))
  add(query_579159, "pp", newJBool(pp))
  add(query_579159, "prettyPrint", newJBool(prettyPrint))
  add(query_579159, "oauth_token", newJString(oauthToken))
  add(path_579158, "projectId", newJString(projectId))
  add(query_579159, "$.xgafv", newJString(Xgafv))
  add(query_579159, "bearer_token", newJString(bearerToken))
  add(query_579159, "uploadType", newJString(uploadType))
  add(query_579159, "alt", newJString(alt))
  add(query_579159, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579160 = body
  add(query_579159, "callback", newJString(callback))
  add(query_579159, "fields", newJString(fields))
  add(query_579159, "upload_protocol", newJString(uploadProtocol))
  add(query_579159, "access_token", newJString(accessToken))
  result = call_579157.call(path_579158, query_579159, nil, nil, body_579160)

var dataprocProjectsJobsSubmit* = Call_DataprocProjectsJobsSubmit_579138(
    name: "dataprocProjectsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs:submit",
    validator: validate_DataprocProjectsJobsSubmit_579139, base: "/",
    url: url_DataprocProjectsJobsSubmit_579140, schemes: {Scheme.Https})
type
  Call_DataprocOperationsGet_579161 = ref object of OpenApiRestCall_578339
proc url_DataprocOperationsGet_579163(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsGet_579162(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579164 = path.getOrDefault("name")
  valid_579164 = validateParameter(valid_579164, JString, required = true,
                                 default = nil)
  if valid_579164 != nil:
    section.add "name", valid_579164
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579165 = query.getOrDefault("key")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "key", valid_579165
  var valid_579166 = query.getOrDefault("pp")
  valid_579166 = validateParameter(valid_579166, JBool, required = false,
                                 default = newJBool(true))
  if valid_579166 != nil:
    section.add "pp", valid_579166
  var valid_579167 = query.getOrDefault("prettyPrint")
  valid_579167 = validateParameter(valid_579167, JBool, required = false,
                                 default = newJBool(true))
  if valid_579167 != nil:
    section.add "prettyPrint", valid_579167
  var valid_579168 = query.getOrDefault("oauth_token")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "oauth_token", valid_579168
  var valid_579169 = query.getOrDefault("$.xgafv")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = newJString("1"))
  if valid_579169 != nil:
    section.add "$.xgafv", valid_579169
  var valid_579170 = query.getOrDefault("bearer_token")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "bearer_token", valid_579170
  var valid_579171 = query.getOrDefault("uploadType")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "uploadType", valid_579171
  var valid_579172 = query.getOrDefault("alt")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("json"))
  if valid_579172 != nil:
    section.add "alt", valid_579172
  var valid_579173 = query.getOrDefault("quotaUser")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "quotaUser", valid_579173
  var valid_579174 = query.getOrDefault("callback")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "callback", valid_579174
  var valid_579175 = query.getOrDefault("fields")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "fields", valid_579175
  var valid_579176 = query.getOrDefault("upload_protocol")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "upload_protocol", valid_579176
  var valid_579177 = query.getOrDefault("access_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "access_token", valid_579177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579178: Call_DataprocOperationsGet_579161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_579178.validator(path, query, header, formData, body)
  let scheme = call_579178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579178.url(scheme.get, call_579178.host, call_579178.base,
                         call_579178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579178, url, valid)

proc call*(call_579179: Call_DataprocOperationsGet_579161; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocOperationsGet
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579180 = newJObject()
  var query_579181 = newJObject()
  add(query_579181, "key", newJString(key))
  add(query_579181, "pp", newJBool(pp))
  add(query_579181, "prettyPrint", newJBool(prettyPrint))
  add(query_579181, "oauth_token", newJString(oauthToken))
  add(query_579181, "$.xgafv", newJString(Xgafv))
  add(query_579181, "bearer_token", newJString(bearerToken))
  add(query_579181, "uploadType", newJString(uploadType))
  add(query_579181, "alt", newJString(alt))
  add(query_579181, "quotaUser", newJString(quotaUser))
  add(path_579180, "name", newJString(name))
  add(query_579181, "callback", newJString(callback))
  add(query_579181, "fields", newJString(fields))
  add(query_579181, "upload_protocol", newJString(uploadProtocol))
  add(query_579181, "access_token", newJString(accessToken))
  result = call_579179.call(path_579180, query_579181, nil, nil, nil)

var dataprocOperationsGet* = Call_DataprocOperationsGet_579161(
    name: "dataprocOperationsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsGet_579162, base: "/",
    url: url_DataprocOperationsGet_579163, schemes: {Scheme.Https})
type
  Call_DataprocOperationsDelete_579182 = ref object of OpenApiRestCall_578339
proc url_DataprocOperationsDelete_579184(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsDelete_579183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is no longer interested in the operation result. It does not cancel the operation. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579185 = path.getOrDefault("name")
  valid_579185 = validateParameter(valid_579185, JString, required = true,
                                 default = nil)
  if valid_579185 != nil:
    section.add "name", valid_579185
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579186 = query.getOrDefault("key")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "key", valid_579186
  var valid_579187 = query.getOrDefault("pp")
  valid_579187 = validateParameter(valid_579187, JBool, required = false,
                                 default = newJBool(true))
  if valid_579187 != nil:
    section.add "pp", valid_579187
  var valid_579188 = query.getOrDefault("prettyPrint")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(true))
  if valid_579188 != nil:
    section.add "prettyPrint", valid_579188
  var valid_579189 = query.getOrDefault("oauth_token")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "oauth_token", valid_579189
  var valid_579190 = query.getOrDefault("$.xgafv")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = newJString("1"))
  if valid_579190 != nil:
    section.add "$.xgafv", valid_579190
  var valid_579191 = query.getOrDefault("bearer_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "bearer_token", valid_579191
  var valid_579192 = query.getOrDefault("uploadType")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "uploadType", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("quotaUser")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "quotaUser", valid_579194
  var valid_579195 = query.getOrDefault("callback")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "callback", valid_579195
  var valid_579196 = query.getOrDefault("fields")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "fields", valid_579196
  var valid_579197 = query.getOrDefault("upload_protocol")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "upload_protocol", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579199: Call_DataprocOperationsDelete_579182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is no longer interested in the operation result. It does not cancel the operation. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  let valid = call_579199.validator(path, query, header, formData, body)
  let scheme = call_579199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579199.url(scheme.get, call_579199.host, call_579199.base,
                         call_579199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579199, url, valid)

proc call*(call_579200: Call_DataprocOperationsDelete_579182; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is no longer interested in the operation result. It does not cancel the operation. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579201 = newJObject()
  var query_579202 = newJObject()
  add(query_579202, "key", newJString(key))
  add(query_579202, "pp", newJBool(pp))
  add(query_579202, "prettyPrint", newJBool(prettyPrint))
  add(query_579202, "oauth_token", newJString(oauthToken))
  add(query_579202, "$.xgafv", newJString(Xgafv))
  add(query_579202, "bearer_token", newJString(bearerToken))
  add(query_579202, "uploadType", newJString(uploadType))
  add(query_579202, "alt", newJString(alt))
  add(query_579202, "quotaUser", newJString(quotaUser))
  add(path_579201, "name", newJString(name))
  add(query_579202, "callback", newJString(callback))
  add(query_579202, "fields", newJString(fields))
  add(query_579202, "upload_protocol", newJString(uploadProtocol))
  add(query_579202, "access_token", newJString(accessToken))
  result = call_579200.call(path_579201, query_579202, nil, nil, nil)

var dataprocOperationsDelete* = Call_DataprocOperationsDelete_579182(
    name: "dataprocOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsDelete_579183, base: "/",
    url: url_DataprocOperationsDelete_579184, schemes: {Scheme.Https})
type
  Call_DataprocOperationsCancel_579203 = ref object of OpenApiRestCall_578339
proc url_DataprocOperationsCancel_579205(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsCancel_579204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use operations.get or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579206 = path.getOrDefault("name")
  valid_579206 = validateParameter(valid_579206, JString, required = true,
                                 default = nil)
  if valid_579206 != nil:
    section.add "name", valid_579206
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579207 = query.getOrDefault("key")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "key", valid_579207
  var valid_579208 = query.getOrDefault("pp")
  valid_579208 = validateParameter(valid_579208, JBool, required = false,
                                 default = newJBool(true))
  if valid_579208 != nil:
    section.add "pp", valid_579208
  var valid_579209 = query.getOrDefault("prettyPrint")
  valid_579209 = validateParameter(valid_579209, JBool, required = false,
                                 default = newJBool(true))
  if valid_579209 != nil:
    section.add "prettyPrint", valid_579209
  var valid_579210 = query.getOrDefault("oauth_token")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "oauth_token", valid_579210
  var valid_579211 = query.getOrDefault("$.xgafv")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = newJString("1"))
  if valid_579211 != nil:
    section.add "$.xgafv", valid_579211
  var valid_579212 = query.getOrDefault("bearer_token")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "bearer_token", valid_579212
  var valid_579213 = query.getOrDefault("uploadType")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "uploadType", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("quotaUser")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "quotaUser", valid_579215
  var valid_579216 = query.getOrDefault("callback")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "callback", valid_579216
  var valid_579217 = query.getOrDefault("fields")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "fields", valid_579217
  var valid_579218 = query.getOrDefault("upload_protocol")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "upload_protocol", valid_579218
  var valid_579219 = query.getOrDefault("access_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "access_token", valid_579219
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

proc call*(call_579221: Call_DataprocOperationsCancel_579203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use operations.get or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  let valid = call_579221.validator(path, query, header, formData, body)
  let scheme = call_579221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579221.url(scheme.get, call_579221.host, call_579221.base,
                         call_579221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579221, url, valid)

proc call*(call_579222: Call_DataprocOperationsCancel_579203; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use operations.get or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579223 = newJObject()
  var query_579224 = newJObject()
  var body_579225 = newJObject()
  add(query_579224, "key", newJString(key))
  add(query_579224, "pp", newJBool(pp))
  add(query_579224, "prettyPrint", newJBool(prettyPrint))
  add(query_579224, "oauth_token", newJString(oauthToken))
  add(query_579224, "$.xgafv", newJString(Xgafv))
  add(query_579224, "bearer_token", newJString(bearerToken))
  add(query_579224, "uploadType", newJString(uploadType))
  add(query_579224, "alt", newJString(alt))
  add(query_579224, "quotaUser", newJString(quotaUser))
  add(path_579223, "name", newJString(name))
  if body != nil:
    body_579225 = body
  add(query_579224, "callback", newJString(callback))
  add(query_579224, "fields", newJString(fields))
  add(query_579224, "upload_protocol", newJString(uploadProtocol))
  add(query_579224, "access_token", newJString(accessToken))
  result = call_579222.call(path_579223, query_579224, nil, nil, body_579225)

var dataprocOperationsCancel* = Call_DataprocOperationsCancel_579203(
    name: "dataprocOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_DataprocOperationsCancel_579204, base: "/",
    url: url_DataprocOperationsCancel_579205, schemes: {Scheme.Https})
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
