
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
  Call_DataprocProjectsRegionsClustersCreate_578904 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsClustersCreate_578906(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersCreate_578905(path: JsonNode;
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
  var valid_578907 = path.getOrDefault("projectId")
  valid_578907 = validateParameter(valid_578907, JString, required = true,
                                 default = nil)
  if valid_578907 != nil:
    section.add "projectId", valid_578907
  var valid_578908 = path.getOrDefault("region")
  valid_578908 = validateParameter(valid_578908, JString, required = true,
                                 default = nil)
  if valid_578908 != nil:
    section.add "region", valid_578908
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
  var valid_578909 = query.getOrDefault("key")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "key", valid_578909
  var valid_578910 = query.getOrDefault("pp")
  valid_578910 = validateParameter(valid_578910, JBool, required = false,
                                 default = newJBool(true))
  if valid_578910 != nil:
    section.add "pp", valid_578910
  var valid_578911 = query.getOrDefault("prettyPrint")
  valid_578911 = validateParameter(valid_578911, JBool, required = false,
                                 default = newJBool(true))
  if valid_578911 != nil:
    section.add "prettyPrint", valid_578911
  var valid_578912 = query.getOrDefault("oauth_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "oauth_token", valid_578912
  var valid_578913 = query.getOrDefault("$.xgafv")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = newJString("1"))
  if valid_578913 != nil:
    section.add "$.xgafv", valid_578913
  var valid_578914 = query.getOrDefault("bearer_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "bearer_token", valid_578914
  var valid_578915 = query.getOrDefault("uploadType")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "uploadType", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("upload_protocol")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "upload_protocol", valid_578920
  var valid_578921 = query.getOrDefault("access_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "access_token", valid_578921
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

proc call*(call_578923: Call_DataprocProjectsRegionsClustersCreate_578904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to create a cluster in a project.
  ## 
  let valid = call_578923.validator(path, query, header, formData, body)
  let scheme = call_578923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578923.url(scheme.get, call_578923.host, call_578923.base,
                         call_578923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578923, url, valid)

proc call*(call_578924: Call_DataprocProjectsRegionsClustersCreate_578904;
          projectId: string; region: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersCreate
  ## Request to create a cluster in a project.
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578925 = newJObject()
  var query_578926 = newJObject()
  var body_578927 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "pp", newJBool(pp))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(path_578925, "projectId", newJString(projectId))
  add(query_578926, "$.xgafv", newJString(Xgafv))
  add(query_578926, "bearer_token", newJString(bearerToken))
  add(query_578926, "uploadType", newJString(uploadType))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "quotaUser", newJString(quotaUser))
  add(path_578925, "region", newJString(region))
  if body != nil:
    body_578927 = body
  add(query_578926, "callback", newJString(callback))
  add(query_578926, "fields", newJString(fields))
  add(query_578926, "upload_protocol", newJString(uploadProtocol))
  add(query_578926, "access_token", newJString(accessToken))
  result = call_578924.call(path_578925, query_578926, nil, nil, body_578927)

var dataprocProjectsRegionsClustersCreate* = Call_DataprocProjectsRegionsClustersCreate_578904(
    name: "dataprocProjectsRegionsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersCreate_578905, base: "/",
    url: url_DataprocProjectsRegionsClustersCreate_578906, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersList_578610 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsClustersList_578612(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersList_578611(path: JsonNode;
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
  var valid_578738 = path.getOrDefault("projectId")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "projectId", valid_578738
  var valid_578739 = path.getOrDefault("region")
  valid_578739 = validateParameter(valid_578739, JString, required = true,
                                 default = nil)
  if valid_578739 != nil:
    section.add "region", valid_578739
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
  ##   filter: JString
  ##         : Optional A filter constraining which clusters to list. Valid filters contain label terms such as: labels.key1 = val1 AND (-labels.k2 = val2 OR labels.k3 = val3)
  ##   pageToken: JString
  ##            : The standard List page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578740 = query.getOrDefault("key")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "key", valid_578740
  var valid_578754 = query.getOrDefault("pp")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "pp", valid_578754
  var valid_578755 = query.getOrDefault("prettyPrint")
  valid_578755 = validateParameter(valid_578755, JBool, required = false,
                                 default = newJBool(true))
  if valid_578755 != nil:
    section.add "prettyPrint", valid_578755
  var valid_578756 = query.getOrDefault("oauth_token")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "oauth_token", valid_578756
  var valid_578757 = query.getOrDefault("$.xgafv")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("1"))
  if valid_578757 != nil:
    section.add "$.xgafv", valid_578757
  var valid_578758 = query.getOrDefault("bearer_token")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "bearer_token", valid_578758
  var valid_578759 = query.getOrDefault("pageSize")
  valid_578759 = validateParameter(valid_578759, JInt, required = false, default = nil)
  if valid_578759 != nil:
    section.add "pageSize", valid_578759
  var valid_578760 = query.getOrDefault("uploadType")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "uploadType", valid_578760
  var valid_578761 = query.getOrDefault("alt")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = newJString("json"))
  if valid_578761 != nil:
    section.add "alt", valid_578761
  var valid_578762 = query.getOrDefault("quotaUser")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "quotaUser", valid_578762
  var valid_578763 = query.getOrDefault("filter")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "filter", valid_578763
  var valid_578764 = query.getOrDefault("pageToken")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "pageToken", valid_578764
  var valid_578765 = query.getOrDefault("callback")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "callback", valid_578765
  var valid_578766 = query.getOrDefault("fields")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "fields", valid_578766
  var valid_578767 = query.getOrDefault("upload_protocol")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "upload_protocol", valid_578767
  var valid_578768 = query.getOrDefault("access_token")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "access_token", valid_578768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578791: Call_DataprocProjectsRegionsClustersList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request a list of all regions/{region}/clusters in a project.
  ## 
  let valid = call_578791.validator(path, query, header, formData, body)
  let scheme = call_578791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578791.url(scheme.get, call_578791.host, call_578791.base,
                         call_578791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578791, url, valid)

proc call*(call_578862: Call_DataprocProjectsRegionsClustersList_578610;
          projectId: string; region: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; pageSize: int = 0; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersList
  ## Request a list of all regions/{region}/clusters in a project.
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   filter: string
  ##         : Optional A filter constraining which clusters to list. Valid filters contain label terms such as: labels.key1 = val1 AND (-labels.k2 = val2 OR labels.k3 = val3)
  ##   pageToken: string
  ##            : The standard List page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578863 = newJObject()
  var query_578865 = newJObject()
  add(query_578865, "key", newJString(key))
  add(query_578865, "pp", newJBool(pp))
  add(query_578865, "prettyPrint", newJBool(prettyPrint))
  add(query_578865, "oauth_token", newJString(oauthToken))
  add(path_578863, "projectId", newJString(projectId))
  add(query_578865, "$.xgafv", newJString(Xgafv))
  add(query_578865, "bearer_token", newJString(bearerToken))
  add(query_578865, "pageSize", newJInt(pageSize))
  add(query_578865, "uploadType", newJString(uploadType))
  add(query_578865, "alt", newJString(alt))
  add(query_578865, "quotaUser", newJString(quotaUser))
  add(path_578863, "region", newJString(region))
  add(query_578865, "filter", newJString(filter))
  add(query_578865, "pageToken", newJString(pageToken))
  add(query_578865, "callback", newJString(callback))
  add(query_578865, "fields", newJString(fields))
  add(query_578865, "upload_protocol", newJString(uploadProtocol))
  add(query_578865, "access_token", newJString(accessToken))
  result = call_578862.call(path_578863, query_578865, nil, nil, nil)

var dataprocProjectsRegionsClustersList* = Call_DataprocProjectsRegionsClustersList_578610(
    name: "dataprocProjectsRegionsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersList_578611, base: "/",
    url: url_DataprocProjectsRegionsClustersList_578612, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersGet_578928 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsClustersGet_578930(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersGet_578929(path: JsonNode;
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
  var valid_578931 = path.getOrDefault("clusterName")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "clusterName", valid_578931
  var valid_578932 = path.getOrDefault("projectId")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "projectId", valid_578932
  var valid_578933 = path.getOrDefault("region")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "region", valid_578933
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
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("pp")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "pp", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("$.xgafv")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("1"))
  if valid_578938 != nil:
    section.add "$.xgafv", valid_578938
  var valid_578939 = query.getOrDefault("bearer_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "bearer_token", valid_578939
  var valid_578940 = query.getOrDefault("uploadType")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "uploadType", valid_578940
  var valid_578941 = query.getOrDefault("alt")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("json"))
  if valid_578941 != nil:
    section.add "alt", valid_578941
  var valid_578942 = query.getOrDefault("quotaUser")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "quotaUser", valid_578942
  var valid_578943 = query.getOrDefault("callback")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "callback", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  var valid_578945 = query.getOrDefault("upload_protocol")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "upload_protocol", valid_578945
  var valid_578946 = query.getOrDefault("access_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "access_token", valid_578946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578947: Call_DataprocProjectsRegionsClustersGet_578928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to get the resource representation for a cluster in a project.
  ## 
  let valid = call_578947.validator(path, query, header, formData, body)
  let scheme = call_578947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578947.url(scheme.get, call_578947.host, call_578947.base,
                         call_578947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578947, url, valid)

proc call*(call_578948: Call_DataprocProjectsRegionsClustersGet_578928;
          clusterName: string; projectId: string; region: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersGet
  ## Request to get the resource representation for a cluster in a project.
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578949 = newJObject()
  var query_578950 = newJObject()
  add(query_578950, "key", newJString(key))
  add(query_578950, "pp", newJBool(pp))
  add(query_578950, "prettyPrint", newJBool(prettyPrint))
  add(query_578950, "oauth_token", newJString(oauthToken))
  add(path_578949, "clusterName", newJString(clusterName))
  add(path_578949, "projectId", newJString(projectId))
  add(query_578950, "$.xgafv", newJString(Xgafv))
  add(query_578950, "bearer_token", newJString(bearerToken))
  add(query_578950, "uploadType", newJString(uploadType))
  add(query_578950, "alt", newJString(alt))
  add(query_578950, "quotaUser", newJString(quotaUser))
  add(path_578949, "region", newJString(region))
  add(query_578950, "callback", newJString(callback))
  add(query_578950, "fields", newJString(fields))
  add(query_578950, "upload_protocol", newJString(uploadProtocol))
  add(query_578950, "access_token", newJString(accessToken))
  result = call_578948.call(path_578949, query_578950, nil, nil, nil)

var dataprocProjectsRegionsClustersGet* = Call_DataprocProjectsRegionsClustersGet_578928(
    name: "dataprocProjectsRegionsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersGet_578929, base: "/",
    url: url_DataprocProjectsRegionsClustersGet_578930, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersPatch_578974 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsClustersPatch_578976(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersPatch_578975(path: JsonNode;
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
  var valid_578977 = path.getOrDefault("clusterName")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "clusterName", valid_578977
  var valid_578978 = path.getOrDefault("projectId")
  valid_578978 = validateParameter(valid_578978, JString, required = true,
                                 default = nil)
  if valid_578978 != nil:
    section.add "projectId", valid_578978
  var valid_578979 = path.getOrDefault("region")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "region", valid_578979
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
  ##             : Required Specifies the path, relative to <code>Cluster</code>, of the field to update. For example, to change the number of workers in a cluster to 5, the <code>update_mask</code> parameter would be specified as <code>"configuration.worker_configuration.num_instances,"</code> and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "configuration":{
  ##     "workerConfiguration":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> Currently, <code>configuration.worker_configuration.num_instances</code> is the only field that can be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578980 = query.getOrDefault("key")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "key", valid_578980
  var valid_578981 = query.getOrDefault("pp")
  valid_578981 = validateParameter(valid_578981, JBool, required = false,
                                 default = newJBool(true))
  if valid_578981 != nil:
    section.add "pp", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("$.xgafv")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("1"))
  if valid_578984 != nil:
    section.add "$.xgafv", valid_578984
  var valid_578985 = query.getOrDefault("bearer_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "bearer_token", valid_578985
  var valid_578986 = query.getOrDefault("uploadType")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "uploadType", valid_578986
  var valid_578987 = query.getOrDefault("alt")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("json"))
  if valid_578987 != nil:
    section.add "alt", valid_578987
  var valid_578988 = query.getOrDefault("quotaUser")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "quotaUser", valid_578988
  var valid_578989 = query.getOrDefault("updateMask")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "updateMask", valid_578989
  var valid_578990 = query.getOrDefault("callback")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "callback", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  var valid_578992 = query.getOrDefault("upload_protocol")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "upload_protocol", valid_578992
  var valid_578993 = query.getOrDefault("access_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "access_token", valid_578993
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

proc call*(call_578995: Call_DataprocProjectsRegionsClustersPatch_578974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to update a cluster in a project.
  ## 
  let valid = call_578995.validator(path, query, header, formData, body)
  let scheme = call_578995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578995.url(scheme.get, call_578995.host, call_578995.base,
                         call_578995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578995, url, valid)

proc call*(call_578996: Call_DataprocProjectsRegionsClustersPatch_578974;
          clusterName: string; projectId: string; region: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersPatch
  ## Request to update a cluster in a project.
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
  ##             : Required Specifies the path, relative to <code>Cluster</code>, of the field to update. For example, to change the number of workers in a cluster to 5, the <code>update_mask</code> parameter would be specified as <code>"configuration.worker_configuration.num_instances,"</code> and the PATCH request body would specify the new value, as follows:
  ## {
  ##   "configuration":{
  ##     "workerConfiguration":{
  ##       "numInstances":"5"
  ##     }
  ##   }
  ## }
  ## <strong>Note:</strong> Currently, <code>configuration.worker_configuration.num_instances</code> is the only field that can be updated.
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578997 = newJObject()
  var query_578998 = newJObject()
  var body_578999 = newJObject()
  add(query_578998, "key", newJString(key))
  add(query_578998, "pp", newJBool(pp))
  add(query_578998, "prettyPrint", newJBool(prettyPrint))
  add(query_578998, "oauth_token", newJString(oauthToken))
  add(path_578997, "clusterName", newJString(clusterName))
  add(path_578997, "projectId", newJString(projectId))
  add(query_578998, "$.xgafv", newJString(Xgafv))
  add(query_578998, "bearer_token", newJString(bearerToken))
  add(query_578998, "uploadType", newJString(uploadType))
  add(query_578998, "alt", newJString(alt))
  add(query_578998, "quotaUser", newJString(quotaUser))
  add(query_578998, "updateMask", newJString(updateMask))
  add(path_578997, "region", newJString(region))
  if body != nil:
    body_578999 = body
  add(query_578998, "callback", newJString(callback))
  add(query_578998, "fields", newJString(fields))
  add(query_578998, "upload_protocol", newJString(uploadProtocol))
  add(query_578998, "access_token", newJString(accessToken))
  result = call_578996.call(path_578997, query_578998, nil, nil, body_578999)

var dataprocProjectsRegionsClustersPatch* = Call_DataprocProjectsRegionsClustersPatch_578974(
    name: "dataprocProjectsRegionsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersPatch_578975, base: "/",
    url: url_DataprocProjectsRegionsClustersPatch_578976, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDelete_578951 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsClustersDelete_578953(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersDelete_578952(path: JsonNode;
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
  var valid_578954 = path.getOrDefault("clusterName")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "clusterName", valid_578954
  var valid_578955 = path.getOrDefault("projectId")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "projectId", valid_578955
  var valid_578956 = path.getOrDefault("region")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "region", valid_578956
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
  var valid_578957 = query.getOrDefault("key")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "key", valid_578957
  var valid_578958 = query.getOrDefault("pp")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "pp", valid_578958
  var valid_578959 = query.getOrDefault("prettyPrint")
  valid_578959 = validateParameter(valid_578959, JBool, required = false,
                                 default = newJBool(true))
  if valid_578959 != nil:
    section.add "prettyPrint", valid_578959
  var valid_578960 = query.getOrDefault("oauth_token")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "oauth_token", valid_578960
  var valid_578961 = query.getOrDefault("$.xgafv")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("1"))
  if valid_578961 != nil:
    section.add "$.xgafv", valid_578961
  var valid_578962 = query.getOrDefault("bearer_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "bearer_token", valid_578962
  var valid_578963 = query.getOrDefault("uploadType")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "uploadType", valid_578963
  var valid_578964 = query.getOrDefault("alt")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("json"))
  if valid_578964 != nil:
    section.add "alt", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  var valid_578968 = query.getOrDefault("upload_protocol")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "upload_protocol", valid_578968
  var valid_578969 = query.getOrDefault("access_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "access_token", valid_578969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578970: Call_DataprocProjectsRegionsClustersDelete_578951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to delete a cluster in a project.
  ## 
  let valid = call_578970.validator(path, query, header, formData, body)
  let scheme = call_578970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578970.url(scheme.get, call_578970.host, call_578970.base,
                         call_578970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578970, url, valid)

proc call*(call_578971: Call_DataprocProjectsRegionsClustersDelete_578951;
          clusterName: string; projectId: string; region: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsClustersDelete
  ## Request to delete a cluster in a project.
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578972 = newJObject()
  var query_578973 = newJObject()
  add(query_578973, "key", newJString(key))
  add(query_578973, "pp", newJBool(pp))
  add(query_578973, "prettyPrint", newJBool(prettyPrint))
  add(query_578973, "oauth_token", newJString(oauthToken))
  add(path_578972, "clusterName", newJString(clusterName))
  add(path_578972, "projectId", newJString(projectId))
  add(query_578973, "$.xgafv", newJString(Xgafv))
  add(query_578973, "bearer_token", newJString(bearerToken))
  add(query_578973, "uploadType", newJString(uploadType))
  add(query_578973, "alt", newJString(alt))
  add(query_578973, "quotaUser", newJString(quotaUser))
  add(path_578972, "region", newJString(region))
  add(query_578973, "callback", newJString(callback))
  add(query_578973, "fields", newJString(fields))
  add(query_578973, "upload_protocol", newJString(uploadProtocol))
  add(query_578973, "access_token", newJString(accessToken))
  result = call_578971.call(path_578972, query_578973, nil, nil, nil)

var dataprocProjectsRegionsClustersDelete* = Call_DataprocProjectsRegionsClustersDelete_578951(
    name: "dataprocProjectsRegionsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersDelete_578952, base: "/",
    url: url_DataprocProjectsRegionsClustersDelete_578953, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsGet_579000 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsJobsGet_579002(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsGet_579001(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579003 = path.getOrDefault("projectId")
  valid_579003 = validateParameter(valid_579003, JString, required = true,
                                 default = nil)
  if valid_579003 != nil:
    section.add "projectId", valid_579003
  var valid_579004 = path.getOrDefault("jobId")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "jobId", valid_579004
  var valid_579005 = path.getOrDefault("region")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "region", valid_579005
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
  var valid_579006 = query.getOrDefault("key")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "key", valid_579006
  var valid_579007 = query.getOrDefault("pp")
  valid_579007 = validateParameter(valid_579007, JBool, required = false,
                                 default = newJBool(true))
  if valid_579007 != nil:
    section.add "pp", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("$.xgafv")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("1"))
  if valid_579010 != nil:
    section.add "$.xgafv", valid_579010
  var valid_579011 = query.getOrDefault("bearer_token")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "bearer_token", valid_579011
  var valid_579012 = query.getOrDefault("uploadType")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "uploadType", valid_579012
  var valid_579013 = query.getOrDefault("alt")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("json"))
  if valid_579013 != nil:
    section.add "alt", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("callback")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "callback", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("upload_protocol")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "upload_protocol", valid_579017
  var valid_579018 = query.getOrDefault("access_token")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "access_token", valid_579018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579019: Call_DataprocProjectsRegionsJobsGet_579000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_DataprocProjectsRegionsJobsGet_579000;
          projectId: string; jobId: string; region: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsGet
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "pp", newJBool(pp))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(path_579021, "projectId", newJString(projectId))
  add(path_579021, "jobId", newJString(jobId))
  add(query_579022, "$.xgafv", newJString(Xgafv))
  add(query_579022, "bearer_token", newJString(bearerToken))
  add(query_579022, "uploadType", newJString(uploadType))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(path_579021, "region", newJString(region))
  add(query_579022, "callback", newJString(callback))
  add(query_579022, "fields", newJString(fields))
  add(query_579022, "upload_protocol", newJString(uploadProtocol))
  add(query_579022, "access_token", newJString(accessToken))
  result = call_579020.call(path_579021, query_579022, nil, nil, nil)

var dataprocProjectsRegionsJobsGet* = Call_DataprocProjectsRegionsJobsGet_579000(
    name: "dataprocProjectsRegionsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsGet_579001, base: "/",
    url: url_DataprocProjectsRegionsJobsGet_579002, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsPatch_579046 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsJobsPatch_579048(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsPatch_579047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579049 = path.getOrDefault("projectId")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "projectId", valid_579049
  var valid_579050 = path.getOrDefault("jobId")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = nil)
  if valid_579050 != nil:
    section.add "jobId", valid_579050
  var valid_579051 = path.getOrDefault("region")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "region", valid_579051
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
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("pp")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "pp", valid_579053
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
  var valid_579057 = query.getOrDefault("bearer_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "bearer_token", valid_579057
  var valid_579058 = query.getOrDefault("uploadType")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "uploadType", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("quotaUser")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "quotaUser", valid_579060
  var valid_579061 = query.getOrDefault("updateMask")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "updateMask", valid_579061
  var valid_579062 = query.getOrDefault("callback")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "callback", valid_579062
  var valid_579063 = query.getOrDefault("fields")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "fields", valid_579063
  var valid_579064 = query.getOrDefault("upload_protocol")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "upload_protocol", valid_579064
  var valid_579065 = query.getOrDefault("access_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "access_token", valid_579065
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

proc call*(call_579067: Call_DataprocProjectsRegionsJobsPatch_579046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_579067.validator(path, query, header, formData, body)
  let scheme = call_579067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579067.url(scheme.get, call_579067.host, call_579067.base,
                         call_579067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579067, url, valid)

proc call*(call_579068: Call_DataprocProjectsRegionsJobsPatch_579046;
          projectId: string; jobId: string; region: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsPatch
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579069 = newJObject()
  var query_579070 = newJObject()
  var body_579071 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "pp", newJBool(pp))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(path_579069, "projectId", newJString(projectId))
  add(path_579069, "jobId", newJString(jobId))
  add(query_579070, "$.xgafv", newJString(Xgafv))
  add(query_579070, "bearer_token", newJString(bearerToken))
  add(query_579070, "uploadType", newJString(uploadType))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "quotaUser", newJString(quotaUser))
  add(query_579070, "updateMask", newJString(updateMask))
  add(path_579069, "region", newJString(region))
  if body != nil:
    body_579071 = body
  add(query_579070, "callback", newJString(callback))
  add(query_579070, "fields", newJString(fields))
  add(query_579070, "upload_protocol", newJString(uploadProtocol))
  add(query_579070, "access_token", newJString(accessToken))
  result = call_579068.call(path_579069, query_579070, nil, nil, body_579071)

var dataprocProjectsRegionsJobsPatch* = Call_DataprocProjectsRegionsJobsPatch_579046(
    name: "dataprocProjectsRegionsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsPatch_579047, base: "/",
    url: url_DataprocProjectsRegionsJobsPatch_579048, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsDelete_579023 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsJobsDelete_579025(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsDelete_579024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579026 = path.getOrDefault("projectId")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "projectId", valid_579026
  var valid_579027 = path.getOrDefault("jobId")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "jobId", valid_579027
  var valid_579028 = path.getOrDefault("region")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "region", valid_579028
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
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("pp")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "pp", valid_579030
  var valid_579031 = query.getOrDefault("prettyPrint")
  valid_579031 = validateParameter(valid_579031, JBool, required = false,
                                 default = newJBool(true))
  if valid_579031 != nil:
    section.add "prettyPrint", valid_579031
  var valid_579032 = query.getOrDefault("oauth_token")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "oauth_token", valid_579032
  var valid_579033 = query.getOrDefault("$.xgafv")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("1"))
  if valid_579033 != nil:
    section.add "$.xgafv", valid_579033
  var valid_579034 = query.getOrDefault("bearer_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "bearer_token", valid_579034
  var valid_579035 = query.getOrDefault("uploadType")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "uploadType", valid_579035
  var valid_579036 = query.getOrDefault("alt")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("json"))
  if valid_579036 != nil:
    section.add "alt", valid_579036
  var valid_579037 = query.getOrDefault("quotaUser")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "quotaUser", valid_579037
  var valid_579038 = query.getOrDefault("callback")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "callback", valid_579038
  var valid_579039 = query.getOrDefault("fields")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "fields", valid_579039
  var valid_579040 = query.getOrDefault("upload_protocol")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "upload_protocol", valid_579040
  var valid_579041 = query.getOrDefault("access_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "access_token", valid_579041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579042: Call_DataprocProjectsRegionsJobsDelete_579023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_579042.validator(path, query, header, formData, body)
  let scheme = call_579042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579042.url(scheme.get, call_579042.host, call_579042.base,
                         call_579042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579042, url, valid)

proc call*(call_579043: Call_DataprocProjectsRegionsJobsDelete_579023;
          projectId: string; jobId: string; region: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsDelete
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579044 = newJObject()
  var query_579045 = newJObject()
  add(query_579045, "key", newJString(key))
  add(query_579045, "pp", newJBool(pp))
  add(query_579045, "prettyPrint", newJBool(prettyPrint))
  add(query_579045, "oauth_token", newJString(oauthToken))
  add(path_579044, "projectId", newJString(projectId))
  add(path_579044, "jobId", newJString(jobId))
  add(query_579045, "$.xgafv", newJString(Xgafv))
  add(query_579045, "bearer_token", newJString(bearerToken))
  add(query_579045, "uploadType", newJString(uploadType))
  add(query_579045, "alt", newJString(alt))
  add(query_579045, "quotaUser", newJString(quotaUser))
  add(path_579044, "region", newJString(region))
  add(query_579045, "callback", newJString(callback))
  add(query_579045, "fields", newJString(fields))
  add(query_579045, "upload_protocol", newJString(uploadProtocol))
  add(query_579045, "access_token", newJString(accessToken))
  result = call_579043.call(path_579044, query_579045, nil, nil, nil)

var dataprocProjectsRegionsJobsDelete* = Call_DataprocProjectsRegionsJobsDelete_579023(
    name: "dataprocProjectsRegionsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsDelete_579024, base: "/",
    url: url_DataprocProjectsRegionsJobsDelete_579025, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsCancel_579072 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsJobsCancel_579074(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsCancel_579073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs:list or regions/{region}/jobs:get.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   region: JString (required)
  ##         : Required The Dataproc region in which to handle the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579075 = path.getOrDefault("projectId")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "projectId", valid_579075
  var valid_579076 = path.getOrDefault("jobId")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "jobId", valid_579076
  var valid_579077 = path.getOrDefault("region")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "region", valid_579077
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
  var valid_579078 = query.getOrDefault("key")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "key", valid_579078
  var valid_579079 = query.getOrDefault("pp")
  valid_579079 = validateParameter(valid_579079, JBool, required = false,
                                 default = newJBool(true))
  if valid_579079 != nil:
    section.add "pp", valid_579079
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
  var valid_579083 = query.getOrDefault("bearer_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "bearer_token", valid_579083
  var valid_579084 = query.getOrDefault("uploadType")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "uploadType", valid_579084
  var valid_579085 = query.getOrDefault("alt")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = newJString("json"))
  if valid_579085 != nil:
    section.add "alt", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("callback")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "callback", valid_579087
  var valid_579088 = query.getOrDefault("fields")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "fields", valid_579088
  var valid_579089 = query.getOrDefault("upload_protocol")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "upload_protocol", valid_579089
  var valid_579090 = query.getOrDefault("access_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "access_token", valid_579090
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

proc call*(call_579092: Call_DataprocProjectsRegionsJobsCancel_579072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs:list or regions/{region}/jobs:get.
  ## 
  let valid = call_579092.validator(path, query, header, formData, body)
  let scheme = call_579092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579092.url(scheme.get, call_579092.host, call_579092.base,
                         call_579092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579092, url, valid)

proc call*(call_579093: Call_DataprocProjectsRegionsJobsCancel_579072;
          projectId: string; jobId: string; region: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; uploadType: string = "";
          alt: string = "json"; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsCancel
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs:list or regions/{region}/jobs:get.
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579094 = newJObject()
  var query_579095 = newJObject()
  var body_579096 = newJObject()
  add(query_579095, "key", newJString(key))
  add(query_579095, "pp", newJBool(pp))
  add(query_579095, "prettyPrint", newJBool(prettyPrint))
  add(query_579095, "oauth_token", newJString(oauthToken))
  add(path_579094, "projectId", newJString(projectId))
  add(path_579094, "jobId", newJString(jobId))
  add(query_579095, "$.xgafv", newJString(Xgafv))
  add(query_579095, "bearer_token", newJString(bearerToken))
  add(query_579095, "uploadType", newJString(uploadType))
  add(query_579095, "alt", newJString(alt))
  add(query_579095, "quotaUser", newJString(quotaUser))
  add(path_579094, "region", newJString(region))
  if body != nil:
    body_579096 = body
  add(query_579095, "callback", newJString(callback))
  add(query_579095, "fields", newJString(fields))
  add(query_579095, "upload_protocol", newJString(uploadProtocol))
  add(query_579095, "access_token", newJString(accessToken))
  result = call_579093.call(path_579094, query_579095, nil, nil, body_579096)

var dataprocProjectsRegionsJobsCancel* = Call_DataprocProjectsRegionsJobsCancel_579072(
    name: "dataprocProjectsRegionsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsRegionsJobsCancel_579073, base: "/",
    url: url_DataprocProjectsRegionsJobsCancel_579074, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsList_579097 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsJobsList_579099(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsList_579098(path: JsonNode;
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
  var valid_579100 = path.getOrDefault("projectId")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "projectId", valid_579100
  var valid_579101 = path.getOrDefault("region")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "region", valid_579101
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
  var valid_579102 = query.getOrDefault("key")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "key", valid_579102
  var valid_579103 = query.getOrDefault("pp")
  valid_579103 = validateParameter(valid_579103, JBool, required = false,
                                 default = newJBool(true))
  if valid_579103 != nil:
    section.add "pp", valid_579103
  var valid_579104 = query.getOrDefault("prettyPrint")
  valid_579104 = validateParameter(valid_579104, JBool, required = false,
                                 default = newJBool(true))
  if valid_579104 != nil:
    section.add "prettyPrint", valid_579104
  var valid_579105 = query.getOrDefault("oauth_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "oauth_token", valid_579105
  var valid_579106 = query.getOrDefault("$.xgafv")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("1"))
  if valid_579106 != nil:
    section.add "$.xgafv", valid_579106
  var valid_579107 = query.getOrDefault("bearer_token")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "bearer_token", valid_579107
  var valid_579108 = query.getOrDefault("uploadType")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "uploadType", valid_579108
  var valid_579109 = query.getOrDefault("alt")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("json"))
  if valid_579109 != nil:
    section.add "alt", valid_579109
  var valid_579110 = query.getOrDefault("quotaUser")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "quotaUser", valid_579110
  var valid_579111 = query.getOrDefault("callback")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "callback", valid_579111
  var valid_579112 = query.getOrDefault("fields")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "fields", valid_579112
  var valid_579113 = query.getOrDefault("upload_protocol")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "upload_protocol", valid_579113
  var valid_579114 = query.getOrDefault("access_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "access_token", valid_579114
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

proc call*(call_579116: Call_DataprocProjectsRegionsJobsList_579097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists regions/{region}/jobs in a project.
  ## 
  let valid = call_579116.validator(path, query, header, formData, body)
  let scheme = call_579116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579116.url(scheme.get, call_579116.host, call_579116.base,
                         call_579116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579116, url, valid)

proc call*(call_579117: Call_DataprocProjectsRegionsJobsList_579097;
          projectId: string; region: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsList
  ## Lists regions/{region}/jobs in a project.
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579118 = newJObject()
  var query_579119 = newJObject()
  var body_579120 = newJObject()
  add(query_579119, "key", newJString(key))
  add(query_579119, "pp", newJBool(pp))
  add(query_579119, "prettyPrint", newJBool(prettyPrint))
  add(query_579119, "oauth_token", newJString(oauthToken))
  add(path_579118, "projectId", newJString(projectId))
  add(query_579119, "$.xgafv", newJString(Xgafv))
  add(query_579119, "bearer_token", newJString(bearerToken))
  add(query_579119, "uploadType", newJString(uploadType))
  add(query_579119, "alt", newJString(alt))
  add(query_579119, "quotaUser", newJString(quotaUser))
  add(path_579118, "region", newJString(region))
  if body != nil:
    body_579120 = body
  add(query_579119, "callback", newJString(callback))
  add(query_579119, "fields", newJString(fields))
  add(query_579119, "upload_protocol", newJString(uploadProtocol))
  add(query_579119, "access_token", newJString(accessToken))
  result = call_579117.call(path_579118, query_579119, nil, nil, body_579120)

var dataprocProjectsRegionsJobsList* = Call_DataprocProjectsRegionsJobsList_579097(
    name: "dataprocProjectsRegionsJobsList", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs:list",
    validator: validate_DataprocProjectsRegionsJobsList_579098, base: "/",
    url: url_DataprocProjectsRegionsJobsList_579099, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsSubmit_579121 = ref object of OpenApiRestCall_578339
proc url_DataprocProjectsRegionsJobsSubmit_579123(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsSubmit_579122(path: JsonNode;
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
  var valid_579124 = path.getOrDefault("projectId")
  valid_579124 = validateParameter(valid_579124, JString, required = true,
                                 default = nil)
  if valid_579124 != nil:
    section.add "projectId", valid_579124
  var valid_579125 = path.getOrDefault("region")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "region", valid_579125
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
  var valid_579126 = query.getOrDefault("key")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "key", valid_579126
  var valid_579127 = query.getOrDefault("pp")
  valid_579127 = validateParameter(valid_579127, JBool, required = false,
                                 default = newJBool(true))
  if valid_579127 != nil:
    section.add "pp", valid_579127
  var valid_579128 = query.getOrDefault("prettyPrint")
  valid_579128 = validateParameter(valid_579128, JBool, required = false,
                                 default = newJBool(true))
  if valid_579128 != nil:
    section.add "prettyPrint", valid_579128
  var valid_579129 = query.getOrDefault("oauth_token")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "oauth_token", valid_579129
  var valid_579130 = query.getOrDefault("$.xgafv")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("1"))
  if valid_579130 != nil:
    section.add "$.xgafv", valid_579130
  var valid_579131 = query.getOrDefault("bearer_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "bearer_token", valid_579131
  var valid_579132 = query.getOrDefault("uploadType")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "uploadType", valid_579132
  var valid_579133 = query.getOrDefault("alt")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("json"))
  if valid_579133 != nil:
    section.add "alt", valid_579133
  var valid_579134 = query.getOrDefault("quotaUser")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "quotaUser", valid_579134
  var valid_579135 = query.getOrDefault("callback")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "callback", valid_579135
  var valid_579136 = query.getOrDefault("fields")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "fields", valid_579136
  var valid_579137 = query.getOrDefault("upload_protocol")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "upload_protocol", valid_579137
  var valid_579138 = query.getOrDefault("access_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "access_token", valid_579138
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

proc call*(call_579140: Call_DataprocProjectsRegionsJobsSubmit_579121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_579140.validator(path, query, header, formData, body)
  let scheme = call_579140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579140.url(scheme.get, call_579140.host, call_579140.base,
                         call_579140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579140, url, valid)

proc call*(call_579141: Call_DataprocProjectsRegionsJobsSubmit_579121;
          projectId: string; region: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocProjectsRegionsJobsSubmit
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
  ##   region: string (required)
  ##         : Required The Dataproc region in which to handle the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579142 = newJObject()
  var query_579143 = newJObject()
  var body_579144 = newJObject()
  add(query_579143, "key", newJString(key))
  add(query_579143, "pp", newJBool(pp))
  add(query_579143, "prettyPrint", newJBool(prettyPrint))
  add(query_579143, "oauth_token", newJString(oauthToken))
  add(path_579142, "projectId", newJString(projectId))
  add(query_579143, "$.xgafv", newJString(Xgafv))
  add(query_579143, "bearer_token", newJString(bearerToken))
  add(query_579143, "uploadType", newJString(uploadType))
  add(query_579143, "alt", newJString(alt))
  add(query_579143, "quotaUser", newJString(quotaUser))
  add(path_579142, "region", newJString(region))
  if body != nil:
    body_579144 = body
  add(query_579143, "callback", newJString(callback))
  add(query_579143, "fields", newJString(fields))
  add(query_579143, "upload_protocol", newJString(uploadProtocol))
  add(query_579143, "access_token", newJString(accessToken))
  result = call_579141.call(path_579142, query_579143, nil, nil, body_579144)

var dataprocProjectsRegionsJobsSubmit* = Call_DataprocProjectsRegionsJobsSubmit_579121(
    name: "dataprocProjectsRegionsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs:submit",
    validator: validate_DataprocProjectsRegionsJobsSubmit_579122, base: "/",
    url: url_DataprocProjectsRegionsJobsSubmit_579123, schemes: {Scheme.Https})
type
  Call_DataprocOperationsList_579145 = ref object of OpenApiRestCall_578339
proc url_DataprocOperationsList_579147(protocol: Scheme; host: string; base: string;
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

proc validate_DataprocOperationsList_579146(path: JsonNode; query: JsonNode;
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
  var valid_579148 = path.getOrDefault("name")
  valid_579148 = validateParameter(valid_579148, JString, required = true,
                                 default = nil)
  if valid_579148 != nil:
    section.add "name", valid_579148
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
  ##   filter: JString
  ##         : Required A JSON object that contains filters for the list operation, in the format {"key1":"value1","key2":"value2", ..., }. Possible keys include project_id, cluster_name, and operation_state_matcher.If project_id is set, requests the list of operations that belong to the specified Google Cloud Platform project ID. This key is required.If cluster_name is set, requests the list of operations that were submitted to the specified cluster name. This key is optional.If operation_state_matcher is set, requests the list of operations that match one of the following status options: ALL, ACTIVE, or NON_ACTIVE.
  ##   pageToken: JString
  ##            : The standard List page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579149 = query.getOrDefault("key")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "key", valid_579149
  var valid_579150 = query.getOrDefault("pp")
  valid_579150 = validateParameter(valid_579150, JBool, required = false,
                                 default = newJBool(true))
  if valid_579150 != nil:
    section.add "pp", valid_579150
  var valid_579151 = query.getOrDefault("prettyPrint")
  valid_579151 = validateParameter(valid_579151, JBool, required = false,
                                 default = newJBool(true))
  if valid_579151 != nil:
    section.add "prettyPrint", valid_579151
  var valid_579152 = query.getOrDefault("oauth_token")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "oauth_token", valid_579152
  var valid_579153 = query.getOrDefault("$.xgafv")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = newJString("1"))
  if valid_579153 != nil:
    section.add "$.xgafv", valid_579153
  var valid_579154 = query.getOrDefault("bearer_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "bearer_token", valid_579154
  var valid_579155 = query.getOrDefault("pageSize")
  valid_579155 = validateParameter(valid_579155, JInt, required = false, default = nil)
  if valid_579155 != nil:
    section.add "pageSize", valid_579155
  var valid_579156 = query.getOrDefault("uploadType")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "uploadType", valid_579156
  var valid_579157 = query.getOrDefault("alt")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = newJString("json"))
  if valid_579157 != nil:
    section.add "alt", valid_579157
  var valid_579158 = query.getOrDefault("quotaUser")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "quotaUser", valid_579158
  var valid_579159 = query.getOrDefault("filter")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "filter", valid_579159
  var valid_579160 = query.getOrDefault("pageToken")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "pageToken", valid_579160
  var valid_579161 = query.getOrDefault("callback")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "callback", valid_579161
  var valid_579162 = query.getOrDefault("fields")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "fields", valid_579162
  var valid_579163 = query.getOrDefault("upload_protocol")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "upload_protocol", valid_579163
  var valid_579164 = query.getOrDefault("access_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "access_token", valid_579164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579165: Call_DataprocOperationsList_579145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  let valid = call_579165.validator(path, query, header, formData, body)
  let scheme = call_579165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579165.url(scheme.get, call_579165.host, call_579165.base,
                         call_579165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579165, url, valid)

proc call*(call_579166: Call_DataprocOperationsList_579145; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocOperationsList
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
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
  ##   pageSize: int
  ##           : The standard List page size.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The operation collection name.
  ##   filter: string
  ##         : Required A JSON object that contains filters for the list operation, in the format {"key1":"value1","key2":"value2", ..., }. Possible keys include project_id, cluster_name, and operation_state_matcher.If project_id is set, requests the list of operations that belong to the specified Google Cloud Platform project ID. This key is required.If cluster_name is set, requests the list of operations that were submitted to the specified cluster name. This key is optional.If operation_state_matcher is set, requests the list of operations that match one of the following status options: ALL, ACTIVE, or NON_ACTIVE.
  ##   pageToken: string
  ##            : The standard List page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579167 = newJObject()
  var query_579168 = newJObject()
  add(query_579168, "key", newJString(key))
  add(query_579168, "pp", newJBool(pp))
  add(query_579168, "prettyPrint", newJBool(prettyPrint))
  add(query_579168, "oauth_token", newJString(oauthToken))
  add(query_579168, "$.xgafv", newJString(Xgafv))
  add(query_579168, "bearer_token", newJString(bearerToken))
  add(query_579168, "pageSize", newJInt(pageSize))
  add(query_579168, "uploadType", newJString(uploadType))
  add(query_579168, "alt", newJString(alt))
  add(query_579168, "quotaUser", newJString(quotaUser))
  add(path_579167, "name", newJString(name))
  add(query_579168, "filter", newJString(filter))
  add(query_579168, "pageToken", newJString(pageToken))
  add(query_579168, "callback", newJString(callback))
  add(query_579168, "fields", newJString(fields))
  add(query_579168, "upload_protocol", newJString(uploadProtocol))
  add(query_579168, "access_token", newJString(accessToken))
  result = call_579166.call(path_579167, query_579168, nil, nil, nil)

var dataprocOperationsList* = Call_DataprocOperationsList_579145(
    name: "dataprocOperationsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_DataprocOperationsList_579146, base: "/",
    url: url_DataprocOperationsList_579147, schemes: {Scheme.Https})
type
  Call_DataprocOperationsDelete_579169 = ref object of OpenApiRestCall_578339
proc url_DataprocOperationsDelete_579171(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsDelete_579170(path: JsonNode; query: JsonNode;
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
  var valid_579172 = path.getOrDefault("name")
  valid_579172 = validateParameter(valid_579172, JString, required = true,
                                 default = nil)
  if valid_579172 != nil:
    section.add "name", valid_579172
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
  var valid_579173 = query.getOrDefault("key")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "key", valid_579173
  var valid_579174 = query.getOrDefault("pp")
  valid_579174 = validateParameter(valid_579174, JBool, required = false,
                                 default = newJBool(true))
  if valid_579174 != nil:
    section.add "pp", valid_579174
  var valid_579175 = query.getOrDefault("prettyPrint")
  valid_579175 = validateParameter(valid_579175, JBool, required = false,
                                 default = newJBool(true))
  if valid_579175 != nil:
    section.add "prettyPrint", valid_579175
  var valid_579176 = query.getOrDefault("oauth_token")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "oauth_token", valid_579176
  var valid_579177 = query.getOrDefault("$.xgafv")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("1"))
  if valid_579177 != nil:
    section.add "$.xgafv", valid_579177
  var valid_579178 = query.getOrDefault("bearer_token")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "bearer_token", valid_579178
  var valid_579179 = query.getOrDefault("uploadType")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "uploadType", valid_579179
  var valid_579180 = query.getOrDefault("alt")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("json"))
  if valid_579180 != nil:
    section.add "alt", valid_579180
  var valid_579181 = query.getOrDefault("quotaUser")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "quotaUser", valid_579181
  var valid_579182 = query.getOrDefault("callback")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "callback", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  var valid_579184 = query.getOrDefault("upload_protocol")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "upload_protocol", valid_579184
  var valid_579185 = query.getOrDefault("access_token")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "access_token", valid_579185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579186: Call_DataprocOperationsDelete_579169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. It indicates the client is no longer interested in the operation result. It does not cancel the operation.
  ## 
  let valid = call_579186.validator(path, query, header, formData, body)
  let scheme = call_579186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579186.url(scheme.get, call_579186.host, call_579186.base,
                         call_579186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579186, url, valid)

proc call*(call_579187: Call_DataprocOperationsDelete_579169; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## dataprocOperationsDelete
  ## Deletes a long-running operation. It indicates the client is no longer interested in the operation result. It does not cancel the operation.
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
  var path_579188 = newJObject()
  var query_579189 = newJObject()
  add(query_579189, "key", newJString(key))
  add(query_579189, "pp", newJBool(pp))
  add(query_579189, "prettyPrint", newJBool(prettyPrint))
  add(query_579189, "oauth_token", newJString(oauthToken))
  add(query_579189, "$.xgafv", newJString(Xgafv))
  add(query_579189, "bearer_token", newJString(bearerToken))
  add(query_579189, "uploadType", newJString(uploadType))
  add(query_579189, "alt", newJString(alt))
  add(query_579189, "quotaUser", newJString(quotaUser))
  add(path_579188, "name", newJString(name))
  add(query_579189, "callback", newJString(callback))
  add(query_579189, "fields", newJString(fields))
  add(query_579189, "upload_protocol", newJString(uploadProtocol))
  add(query_579189, "access_token", newJString(accessToken))
  result = call_579187.call(path_579188, query_579189, nil, nil, nil)

var dataprocOperationsDelete* = Call_DataprocOperationsDelete_579169(
    name: "dataprocOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_DataprocOperationsDelete_579170, base: "/",
    url: url_DataprocOperationsDelete_579171, schemes: {Scheme.Https})
type
  Call_DataprocOperationsCancel_579190 = ref object of OpenApiRestCall_578339
proc url_DataprocOperationsCancel_579192(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsCancel_579191(path: JsonNode; query: JsonNode;
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
  var valid_579193 = path.getOrDefault("name")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "name", valid_579193
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
  var valid_579194 = query.getOrDefault("key")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "key", valid_579194
  var valid_579195 = query.getOrDefault("pp")
  valid_579195 = validateParameter(valid_579195, JBool, required = false,
                                 default = newJBool(true))
  if valid_579195 != nil:
    section.add "pp", valid_579195
  var valid_579196 = query.getOrDefault("prettyPrint")
  valid_579196 = validateParameter(valid_579196, JBool, required = false,
                                 default = newJBool(true))
  if valid_579196 != nil:
    section.add "prettyPrint", valid_579196
  var valid_579197 = query.getOrDefault("oauth_token")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "oauth_token", valid_579197
  var valid_579198 = query.getOrDefault("$.xgafv")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("1"))
  if valid_579198 != nil:
    section.add "$.xgafv", valid_579198
  var valid_579199 = query.getOrDefault("bearer_token")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "bearer_token", valid_579199
  var valid_579200 = query.getOrDefault("uploadType")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "uploadType", valid_579200
  var valid_579201 = query.getOrDefault("alt")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = newJString("json"))
  if valid_579201 != nil:
    section.add "alt", valid_579201
  var valid_579202 = query.getOrDefault("quotaUser")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "quotaUser", valid_579202
  var valid_579203 = query.getOrDefault("callback")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "callback", valid_579203
  var valid_579204 = query.getOrDefault("fields")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "fields", valid_579204
  var valid_579205 = query.getOrDefault("upload_protocol")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "upload_protocol", valid_579205
  var valid_579206 = query.getOrDefault("access_token")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "access_token", valid_579206
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

proc call*(call_579208: Call_DataprocOperationsCancel_579190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients may use Operations.GetOperation or other methods to check whether the cancellation succeeded or the operation completed despite cancellation.
  ## 
  let valid = call_579208.validator(path, query, header, formData, body)
  let scheme = call_579208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579208.url(scheme.get, call_579208.host, call_579208.base,
                         call_579208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579208, url, valid)

proc call*(call_579209: Call_DataprocOperationsCancel_579190; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## dataprocOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients may use Operations.GetOperation or other methods to check whether the cancellation succeeded or the operation completed despite cancellation.
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
  var path_579210 = newJObject()
  var query_579211 = newJObject()
  var body_579212 = newJObject()
  add(query_579211, "key", newJString(key))
  add(query_579211, "pp", newJBool(pp))
  add(query_579211, "prettyPrint", newJBool(prettyPrint))
  add(query_579211, "oauth_token", newJString(oauthToken))
  add(query_579211, "$.xgafv", newJString(Xgafv))
  add(query_579211, "bearer_token", newJString(bearerToken))
  add(query_579211, "uploadType", newJString(uploadType))
  add(query_579211, "alt", newJString(alt))
  add(query_579211, "quotaUser", newJString(quotaUser))
  add(path_579210, "name", newJString(name))
  if body != nil:
    body_579212 = body
  add(query_579211, "callback", newJString(callback))
  add(query_579211, "fields", newJString(fields))
  add(query_579211, "upload_protocol", newJString(uploadProtocol))
  add(query_579211, "access_token", newJString(accessToken))
  result = call_579209.call(path_579210, query_579211, nil, nil, body_579212)

var dataprocOperationsCancel* = Call_DataprocOperationsCancel_579190(
    name: "dataprocOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}:cancel",
    validator: validate_DataprocOperationsCancel_579191, base: "/",
    url: url_DataprocOperationsCancel_579192, schemes: {Scheme.Https})
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
