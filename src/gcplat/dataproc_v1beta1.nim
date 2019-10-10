
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
  Call_DataprocProjectsClustersCreate_589003 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsClustersCreate_589005(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersCreate_589004(path: JsonNode;
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
  var valid_589006 = path.getOrDefault("projectId")
  valid_589006 = validateParameter(valid_589006, JString, required = true,
                                 default = nil)
  if valid_589006 != nil:
    section.add "projectId", valid_589006
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
  var valid_589007 = query.getOrDefault("upload_protocol")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "upload_protocol", valid_589007
  var valid_589008 = query.getOrDefault("fields")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "fields", valid_589008
  var valid_589009 = query.getOrDefault("quotaUser")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "quotaUser", valid_589009
  var valid_589010 = query.getOrDefault("alt")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = newJString("json"))
  if valid_589010 != nil:
    section.add "alt", valid_589010
  var valid_589011 = query.getOrDefault("pp")
  valid_589011 = validateParameter(valid_589011, JBool, required = false,
                                 default = newJBool(true))
  if valid_589011 != nil:
    section.add "pp", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("uploadType")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "uploadType", valid_589013
  var valid_589014 = query.getOrDefault("callback")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "callback", valid_589014
  var valid_589015 = query.getOrDefault("access_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "access_token", valid_589015
  var valid_589016 = query.getOrDefault("key")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "key", valid_589016
  var valid_589017 = query.getOrDefault("$.xgafv")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("1"))
  if valid_589017 != nil:
    section.add "$.xgafv", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
  var valid_589019 = query.getOrDefault("bearer_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "bearer_token", valid_589019
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

proc call*(call_589021: Call_DataprocProjectsClustersCreate_589003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a cluster in a project.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_DataprocProjectsClustersCreate_589003;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsClustersCreate
  ## Creates a cluster in a project.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589023 = newJObject()
  var query_589024 = newJObject()
  var body_589025 = newJObject()
  add(query_589024, "upload_protocol", newJString(uploadProtocol))
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "pp", newJBool(pp))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(query_589024, "uploadType", newJString(uploadType))
  add(query_589024, "callback", newJString(callback))
  add(query_589024, "access_token", newJString(accessToken))
  add(query_589024, "key", newJString(key))
  add(path_589023, "projectId", newJString(projectId))
  add(query_589024, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589025 = body
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  add(query_589024, "bearer_token", newJString(bearerToken))
  result = call_589022.call(path_589023, query_589024, nil, nil, body_589025)

var dataprocProjectsClustersCreate* = Call_DataprocProjectsClustersCreate_589003(
    name: "dataprocProjectsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersCreate_589004, base: "/",
    url: url_DataprocProjectsClustersCreate_589005, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersList_588710 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsClustersList_588712(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588857 = query.getOrDefault("pp")
  valid_588857 = validateParameter(valid_588857, JBool, required = false,
                                 default = newJBool(true))
  if valid_588857 != nil:
    section.add "pp", valid_588857
  var valid_588858 = query.getOrDefault("oauth_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "oauth_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("callback")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "callback", valid_588860
  var valid_588861 = query.getOrDefault("access_token")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "access_token", valid_588861
  var valid_588862 = query.getOrDefault("key")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = nil)
  if valid_588862 != nil:
    section.add "key", valid_588862
  var valid_588863 = query.getOrDefault("$.xgafv")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("1"))
  if valid_588863 != nil:
    section.add "$.xgafv", valid_588863
  var valid_588864 = query.getOrDefault("pageSize")
  valid_588864 = validateParameter(valid_588864, JInt, required = false, default = nil)
  if valid_588864 != nil:
    section.add "pageSize", valid_588864
  var valid_588865 = query.getOrDefault("prettyPrint")
  valid_588865 = validateParameter(valid_588865, JBool, required = false,
                                 default = newJBool(true))
  if valid_588865 != nil:
    section.add "prettyPrint", valid_588865
  var valid_588866 = query.getOrDefault("filter")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "filter", valid_588866
  var valid_588867 = query.getOrDefault("bearer_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "bearer_token", valid_588867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588890: Call_DataprocProjectsClustersList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all clusters in a project.
  ## 
  let valid = call_588890.validator(path, query, header, formData, body)
  let scheme = call_588890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588890.url(scheme.get, call_588890.host, call_588890.base,
                         call_588890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588890, url, valid)

proc call*(call_588961: Call_DataprocProjectsClustersList_588710;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""; bearerToken: string = ""): Recallable =
  ## dataprocProjectsClustersList
  ## Lists all clusters in a project.
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
  ##   pageSize: int
  ##           : The standard List page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional A filter constraining which clusters to list. Valid filters contain label terms such as: labels.key1 = val1 AND (-labels.k2 = val2 OR labels.k3 = val3)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_588962 = newJObject()
  var query_588964 = newJObject()
  add(query_588964, "upload_protocol", newJString(uploadProtocol))
  add(query_588964, "fields", newJString(fields))
  add(query_588964, "pageToken", newJString(pageToken))
  add(query_588964, "quotaUser", newJString(quotaUser))
  add(query_588964, "alt", newJString(alt))
  add(query_588964, "pp", newJBool(pp))
  add(query_588964, "oauth_token", newJString(oauthToken))
  add(query_588964, "uploadType", newJString(uploadType))
  add(query_588964, "callback", newJString(callback))
  add(query_588964, "access_token", newJString(accessToken))
  add(query_588964, "key", newJString(key))
  add(path_588962, "projectId", newJString(projectId))
  add(query_588964, "$.xgafv", newJString(Xgafv))
  add(query_588964, "pageSize", newJInt(pageSize))
  add(query_588964, "prettyPrint", newJBool(prettyPrint))
  add(query_588964, "filter", newJString(filter))
  add(query_588964, "bearer_token", newJString(bearerToken))
  result = call_588961.call(path_588962, query_588964, nil, nil, nil)

var dataprocProjectsClustersList* = Call_DataprocProjectsClustersList_588710(
    name: "dataprocProjectsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersList_588711, base: "/",
    url: url_DataprocProjectsClustersList_588712, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersGet_589026 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsClustersGet_589028(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersGet_589027(path: JsonNode; query: JsonNode;
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
  var valid_589029 = path.getOrDefault("clusterName")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "clusterName", valid_589029
  var valid_589030 = path.getOrDefault("projectId")
  valid_589030 = validateParameter(valid_589030, JString, required = true,
                                 default = nil)
  if valid_589030 != nil:
    section.add "projectId", valid_589030
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
  var valid_589031 = query.getOrDefault("upload_protocol")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "upload_protocol", valid_589031
  var valid_589032 = query.getOrDefault("fields")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "fields", valid_589032
  var valid_589033 = query.getOrDefault("quotaUser")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "quotaUser", valid_589033
  var valid_589034 = query.getOrDefault("alt")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("json"))
  if valid_589034 != nil:
    section.add "alt", valid_589034
  var valid_589035 = query.getOrDefault("pp")
  valid_589035 = validateParameter(valid_589035, JBool, required = false,
                                 default = newJBool(true))
  if valid_589035 != nil:
    section.add "pp", valid_589035
  var valid_589036 = query.getOrDefault("oauth_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "oauth_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("callback")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "callback", valid_589038
  var valid_589039 = query.getOrDefault("access_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "access_token", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("$.xgafv")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("1"))
  if valid_589041 != nil:
    section.add "$.xgafv", valid_589041
  var valid_589042 = query.getOrDefault("prettyPrint")
  valid_589042 = validateParameter(valid_589042, JBool, required = false,
                                 default = newJBool(true))
  if valid_589042 != nil:
    section.add "prettyPrint", valid_589042
  var valid_589043 = query.getOrDefault("bearer_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "bearer_token", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_DataprocProjectsClustersGet_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_DataprocProjectsClustersGet_589026;
          clusterName: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsClustersGet
  ## Gets the resource representation for a cluster in a project.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(path_589046, "clusterName", newJString(clusterName))
  add(query_589047, "upload_protocol", newJString(uploadProtocol))
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "pp", newJBool(pp))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "uploadType", newJString(uploadType))
  add(query_589047, "callback", newJString(callback))
  add(query_589047, "access_token", newJString(accessToken))
  add(query_589047, "key", newJString(key))
  add(path_589046, "projectId", newJString(projectId))
  add(query_589047, "$.xgafv", newJString(Xgafv))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  add(query_589047, "bearer_token", newJString(bearerToken))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var dataprocProjectsClustersGet* = Call_DataprocProjectsClustersGet_589026(
    name: "dataprocProjectsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersGet_589027, base: "/",
    url: url_DataprocProjectsClustersGet_589028, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersPatch_589070 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsClustersPatch_589072(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersPatch_589071(path: JsonNode; query: JsonNode;
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
  var valid_589073 = path.getOrDefault("clusterName")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "clusterName", valid_589073
  var valid_589074 = path.getOrDefault("projectId")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "projectId", valid_589074
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589075 = query.getOrDefault("upload_protocol")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "upload_protocol", valid_589075
  var valid_589076 = query.getOrDefault("fields")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "fields", valid_589076
  var valid_589077 = query.getOrDefault("quotaUser")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "quotaUser", valid_589077
  var valid_589078 = query.getOrDefault("alt")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("json"))
  if valid_589078 != nil:
    section.add "alt", valid_589078
  var valid_589079 = query.getOrDefault("pp")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "pp", valid_589079
  var valid_589080 = query.getOrDefault("oauth_token")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "oauth_token", valid_589080
  var valid_589081 = query.getOrDefault("uploadType")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "uploadType", valid_589081
  var valid_589082 = query.getOrDefault("callback")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "callback", valid_589082
  var valid_589083 = query.getOrDefault("access_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "access_token", valid_589083
  var valid_589084 = query.getOrDefault("key")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "key", valid_589084
  var valid_589085 = query.getOrDefault("$.xgafv")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("1"))
  if valid_589085 != nil:
    section.add "$.xgafv", valid_589085
  var valid_589086 = query.getOrDefault("prettyPrint")
  valid_589086 = validateParameter(valid_589086, JBool, required = false,
                                 default = newJBool(true))
  if valid_589086 != nil:
    section.add "prettyPrint", valid_589086
  var valid_589087 = query.getOrDefault("updateMask")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "updateMask", valid_589087
  var valid_589088 = query.getOrDefault("bearer_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "bearer_token", valid_589088
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

proc call*(call_589090: Call_DataprocProjectsClustersPatch_589070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a cluster in a project.
  ## 
  let valid = call_589090.validator(path, query, header, formData, body)
  let scheme = call_589090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589090.url(scheme.get, call_589090.host, call_589090.base,
                         call_589090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589090, url, valid)

proc call*(call_589091: Call_DataprocProjectsClustersPatch_589070;
          clusterName: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""; bearerToken: string = ""): Recallable =
  ## dataprocProjectsClustersPatch
  ## Updates a cluster in a project.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589092 = newJObject()
  var query_589093 = newJObject()
  var body_589094 = newJObject()
  add(path_589092, "clusterName", newJString(clusterName))
  add(query_589093, "upload_protocol", newJString(uploadProtocol))
  add(query_589093, "fields", newJString(fields))
  add(query_589093, "quotaUser", newJString(quotaUser))
  add(query_589093, "alt", newJString(alt))
  add(query_589093, "pp", newJBool(pp))
  add(query_589093, "oauth_token", newJString(oauthToken))
  add(query_589093, "uploadType", newJString(uploadType))
  add(query_589093, "callback", newJString(callback))
  add(query_589093, "access_token", newJString(accessToken))
  add(query_589093, "key", newJString(key))
  add(path_589092, "projectId", newJString(projectId))
  add(query_589093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589094 = body
  add(query_589093, "prettyPrint", newJBool(prettyPrint))
  add(query_589093, "updateMask", newJString(updateMask))
  add(query_589093, "bearer_token", newJString(bearerToken))
  result = call_589091.call(path_589092, query_589093, nil, nil, body_589094)

var dataprocProjectsClustersPatch* = Call_DataprocProjectsClustersPatch_589070(
    name: "dataprocProjectsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersPatch_589071, base: "/",
    url: url_DataprocProjectsClustersPatch_589072, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDelete_589048 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsClustersDelete_589050(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersDelete_589049(path: JsonNode;
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
  var valid_589051 = path.getOrDefault("clusterName")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "clusterName", valid_589051
  var valid_589052 = path.getOrDefault("projectId")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "projectId", valid_589052
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
  var valid_589053 = query.getOrDefault("upload_protocol")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "upload_protocol", valid_589053
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("pp")
  valid_589057 = validateParameter(valid_589057, JBool, required = false,
                                 default = newJBool(true))
  if valid_589057 != nil:
    section.add "pp", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("callback")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "callback", valid_589060
  var valid_589061 = query.getOrDefault("access_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "access_token", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("$.xgafv")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("1"))
  if valid_589063 != nil:
    section.add "$.xgafv", valid_589063
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
  var valid_589065 = query.getOrDefault("bearer_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "bearer_token", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589066: Call_DataprocProjectsClustersDelete_589048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a cluster in a project.
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_DataprocProjectsClustersDelete_589048;
          clusterName: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsClustersDelete
  ## Deletes a cluster in a project.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589068 = newJObject()
  var query_589069 = newJObject()
  add(path_589068, "clusterName", newJString(clusterName))
  add(query_589069, "upload_protocol", newJString(uploadProtocol))
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(query_589069, "alt", newJString(alt))
  add(query_589069, "pp", newJBool(pp))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "uploadType", newJString(uploadType))
  add(query_589069, "callback", newJString(callback))
  add(query_589069, "access_token", newJString(accessToken))
  add(query_589069, "key", newJString(key))
  add(path_589068, "projectId", newJString(projectId))
  add(query_589069, "$.xgafv", newJString(Xgafv))
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  add(query_589069, "bearer_token", newJString(bearerToken))
  result = call_589067.call(path_589068, query_589069, nil, nil, nil)

var dataprocProjectsClustersDelete* = Call_DataprocProjectsClustersDelete_589048(
    name: "dataprocProjectsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersDelete_589049, base: "/",
    url: url_DataprocProjectsClustersDelete_589050, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDiagnose_589095 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsClustersDiagnose_589097(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersDiagnose_589096(path: JsonNode;
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
  var valid_589098 = path.getOrDefault("clusterName")
  valid_589098 = validateParameter(valid_589098, JString, required = true,
                                 default = nil)
  if valid_589098 != nil:
    section.add "clusterName", valid_589098
  var valid_589099 = path.getOrDefault("projectId")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "projectId", valid_589099
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
  var valid_589100 = query.getOrDefault("upload_protocol")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "upload_protocol", valid_589100
  var valid_589101 = query.getOrDefault("fields")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "fields", valid_589101
  var valid_589102 = query.getOrDefault("quotaUser")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "quotaUser", valid_589102
  var valid_589103 = query.getOrDefault("alt")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("json"))
  if valid_589103 != nil:
    section.add "alt", valid_589103
  var valid_589104 = query.getOrDefault("pp")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "pp", valid_589104
  var valid_589105 = query.getOrDefault("oauth_token")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "oauth_token", valid_589105
  var valid_589106 = query.getOrDefault("uploadType")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "uploadType", valid_589106
  var valid_589107 = query.getOrDefault("callback")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "callback", valid_589107
  var valid_589108 = query.getOrDefault("access_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "access_token", valid_589108
  var valid_589109 = query.getOrDefault("key")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "key", valid_589109
  var valid_589110 = query.getOrDefault("$.xgafv")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("1"))
  if valid_589110 != nil:
    section.add "$.xgafv", valid_589110
  var valid_589111 = query.getOrDefault("prettyPrint")
  valid_589111 = validateParameter(valid_589111, JBool, required = false,
                                 default = newJBool(true))
  if valid_589111 != nil:
    section.add "prettyPrint", valid_589111
  var valid_589112 = query.getOrDefault("bearer_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "bearer_token", valid_589112
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

proc call*(call_589114: Call_DataprocProjectsClustersDiagnose_589095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. After the operation completes, the Operation.response field contains DiagnoseClusterOutputLocation.
  ## 
  let valid = call_589114.validator(path, query, header, formData, body)
  let scheme = call_589114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589114.url(scheme.get, call_589114.host, call_589114.base,
                         call_589114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589114, url, valid)

proc call*(call_589115: Call_DataprocProjectsClustersDiagnose_589095;
          clusterName: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsClustersDiagnose
  ## Gets cluster diagnostic information. After the operation completes, the Operation.response field contains DiagnoseClusterOutputLocation.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589116 = newJObject()
  var query_589117 = newJObject()
  var body_589118 = newJObject()
  add(path_589116, "clusterName", newJString(clusterName))
  add(query_589117, "upload_protocol", newJString(uploadProtocol))
  add(query_589117, "fields", newJString(fields))
  add(query_589117, "quotaUser", newJString(quotaUser))
  add(query_589117, "alt", newJString(alt))
  add(query_589117, "pp", newJBool(pp))
  add(query_589117, "oauth_token", newJString(oauthToken))
  add(query_589117, "uploadType", newJString(uploadType))
  add(query_589117, "callback", newJString(callback))
  add(query_589117, "access_token", newJString(accessToken))
  add(query_589117, "key", newJString(key))
  add(path_589116, "projectId", newJString(projectId))
  add(query_589117, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589118 = body
  add(query_589117, "prettyPrint", newJBool(prettyPrint))
  add(query_589117, "bearer_token", newJString(bearerToken))
  result = call_589115.call(path_589116, query_589117, nil, nil, body_589118)

var dataprocProjectsClustersDiagnose* = Call_DataprocProjectsClustersDiagnose_589095(
    name: "dataprocProjectsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsClustersDiagnose_589096, base: "/",
    url: url_DataprocProjectsClustersDiagnose_589097, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsList_589119 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsJobsList_589121(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsList_589120(path: JsonNode; query: JsonNode;
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
  var valid_589122 = path.getOrDefault("projectId")
  valid_589122 = validateParameter(valid_589122, JString, required = true,
                                 default = nil)
  if valid_589122 != nil:
    section.add "projectId", valid_589122
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional The page token, returned by a previous call, to request the next page of results.
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
  ##   jobStateMatcher: JString
  ##                  : Optional Specifies enumerated categories of jobs to list.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional The number of results to return in each response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional A filter constraining which jobs to list. Valid filters contain job state and label terms such as: labels.key1 = val1 AND (labels.k2 = val2 OR labels.k3 = val3)
  ##   clusterName: JString
  ##              : Optional If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589123 = query.getOrDefault("upload_protocol")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "upload_protocol", valid_589123
  var valid_589124 = query.getOrDefault("fields")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "fields", valid_589124
  var valid_589125 = query.getOrDefault("pageToken")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "pageToken", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("pp")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "pp", valid_589128
  var valid_589129 = query.getOrDefault("oauth_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "oauth_token", valid_589129
  var valid_589130 = query.getOrDefault("uploadType")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "uploadType", valid_589130
  var valid_589131 = query.getOrDefault("callback")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "callback", valid_589131
  var valid_589132 = query.getOrDefault("access_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "access_token", valid_589132
  var valid_589133 = query.getOrDefault("jobStateMatcher")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("ALL"))
  if valid_589133 != nil:
    section.add "jobStateMatcher", valid_589133
  var valid_589134 = query.getOrDefault("key")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "key", valid_589134
  var valid_589135 = query.getOrDefault("$.xgafv")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = newJString("1"))
  if valid_589135 != nil:
    section.add "$.xgafv", valid_589135
  var valid_589136 = query.getOrDefault("pageSize")
  valid_589136 = validateParameter(valid_589136, JInt, required = false, default = nil)
  if valid_589136 != nil:
    section.add "pageSize", valid_589136
  var valid_589137 = query.getOrDefault("prettyPrint")
  valid_589137 = validateParameter(valid_589137, JBool, required = false,
                                 default = newJBool(true))
  if valid_589137 != nil:
    section.add "prettyPrint", valid_589137
  var valid_589138 = query.getOrDefault("filter")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "filter", valid_589138
  var valid_589139 = query.getOrDefault("clusterName")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "clusterName", valid_589139
  var valid_589140 = query.getOrDefault("bearer_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "bearer_token", valid_589140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589141: Call_DataprocProjectsJobsList_589119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs in a project.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_DataprocProjectsJobsList_589119; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; jobStateMatcher: string = "ALL"; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""; clusterName: string = ""; bearerToken: string = ""): Recallable =
  ## dataprocProjectsJobsList
  ## Lists jobs in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional The page token, returned by a previous call, to request the next page of results.
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
  ##   jobStateMatcher: string
  ##                  : Optional Specifies enumerated categories of jobs to list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional The number of results to return in each response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional A filter constraining which jobs to list. Valid filters contain job state and label terms such as: labels.key1 = val1 AND (labels.k2 = val2 OR labels.k3 = val3)
  ##   clusterName: string
  ##              : Optional If set, the returned jobs list includes only jobs that were submitted to the named cluster.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  add(query_589144, "upload_protocol", newJString(uploadProtocol))
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "pageToken", newJString(pageToken))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "pp", newJBool(pp))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "uploadType", newJString(uploadType))
  add(query_589144, "callback", newJString(callback))
  add(query_589144, "access_token", newJString(accessToken))
  add(query_589144, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_589144, "key", newJString(key))
  add(path_589143, "projectId", newJString(projectId))
  add(query_589144, "$.xgafv", newJString(Xgafv))
  add(query_589144, "pageSize", newJInt(pageSize))
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  add(query_589144, "filter", newJString(filter))
  add(query_589144, "clusterName", newJString(clusterName))
  add(query_589144, "bearer_token", newJString(bearerToken))
  result = call_589142.call(path_589143, query_589144, nil, nil, nil)

var dataprocProjectsJobsList* = Call_DataprocProjectsJobsList_589119(
    name: "dataprocProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/projects/{projectId}/jobs",
    validator: validate_DataprocProjectsJobsList_589120, base: "/",
    url: url_DataprocProjectsJobsList_589121, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsGet_589145 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsJobsGet_589147(protocol: Scheme; host: string; base: string;
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

proc validate_DataprocProjectsJobsGet_589146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the resource representation for a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589148 = path.getOrDefault("jobId")
  valid_589148 = validateParameter(valid_589148, JString, required = true,
                                 default = nil)
  if valid_589148 != nil:
    section.add "jobId", valid_589148
  var valid_589149 = path.getOrDefault("projectId")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "projectId", valid_589149
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
  var valid_589150 = query.getOrDefault("upload_protocol")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "upload_protocol", valid_589150
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("pp")
  valid_589154 = validateParameter(valid_589154, JBool, required = false,
                                 default = newJBool(true))
  if valid_589154 != nil:
    section.add "pp", valid_589154
  var valid_589155 = query.getOrDefault("oauth_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "oauth_token", valid_589155
  var valid_589156 = query.getOrDefault("uploadType")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "uploadType", valid_589156
  var valid_589157 = query.getOrDefault("callback")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "callback", valid_589157
  var valid_589158 = query.getOrDefault("access_token")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "access_token", valid_589158
  var valid_589159 = query.getOrDefault("key")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "key", valid_589159
  var valid_589160 = query.getOrDefault("$.xgafv")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("1"))
  if valid_589160 != nil:
    section.add "$.xgafv", valid_589160
  var valid_589161 = query.getOrDefault("prettyPrint")
  valid_589161 = validateParameter(valid_589161, JBool, required = false,
                                 default = newJBool(true))
  if valid_589161 != nil:
    section.add "prettyPrint", valid_589161
  var valid_589162 = query.getOrDefault("bearer_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "bearer_token", valid_589162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589163: Call_DataprocProjectsJobsGet_589145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_589163.validator(path, query, header, formData, body)
  let scheme = call_589163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589163.url(scheme.get, call_589163.host, call_589163.base,
                         call_589163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589163, url, valid)

proc call*(call_589164: Call_DataprocProjectsJobsGet_589145; jobId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsJobsGet
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589165 = newJObject()
  var query_589166 = newJObject()
  add(query_589166, "upload_protocol", newJString(uploadProtocol))
  add(query_589166, "fields", newJString(fields))
  add(query_589166, "quotaUser", newJString(quotaUser))
  add(query_589166, "alt", newJString(alt))
  add(query_589166, "pp", newJBool(pp))
  add(path_589165, "jobId", newJString(jobId))
  add(query_589166, "oauth_token", newJString(oauthToken))
  add(query_589166, "uploadType", newJString(uploadType))
  add(query_589166, "callback", newJString(callback))
  add(query_589166, "access_token", newJString(accessToken))
  add(query_589166, "key", newJString(key))
  add(path_589165, "projectId", newJString(projectId))
  add(query_589166, "$.xgafv", newJString(Xgafv))
  add(query_589166, "prettyPrint", newJBool(prettyPrint))
  add(query_589166, "bearer_token", newJString(bearerToken))
  result = call_589164.call(path_589165, query_589166, nil, nil, nil)

var dataprocProjectsJobsGet* = Call_DataprocProjectsJobsGet_589145(
    name: "dataprocProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsGet_589146, base: "/",
    url: url_DataprocProjectsJobsGet_589147, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsPatch_589189 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsJobsPatch_589191(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsPatch_589190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589192 = path.getOrDefault("jobId")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "jobId", valid_589192
  var valid_589193 = path.getOrDefault("projectId")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "projectId", valid_589193
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
  var valid_589194 = query.getOrDefault("upload_protocol")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "upload_protocol", valid_589194
  var valid_589195 = query.getOrDefault("fields")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "fields", valid_589195
  var valid_589196 = query.getOrDefault("quotaUser")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "quotaUser", valid_589196
  var valid_589197 = query.getOrDefault("alt")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("json"))
  if valid_589197 != nil:
    section.add "alt", valid_589197
  var valid_589198 = query.getOrDefault("pp")
  valid_589198 = validateParameter(valid_589198, JBool, required = false,
                                 default = newJBool(true))
  if valid_589198 != nil:
    section.add "pp", valid_589198
  var valid_589199 = query.getOrDefault("oauth_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "oauth_token", valid_589199
  var valid_589200 = query.getOrDefault("uploadType")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "uploadType", valid_589200
  var valid_589201 = query.getOrDefault("callback")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "callback", valid_589201
  var valid_589202 = query.getOrDefault("access_token")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "access_token", valid_589202
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
  var valid_589206 = query.getOrDefault("updateMask")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "updateMask", valid_589206
  var valid_589207 = query.getOrDefault("bearer_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "bearer_token", valid_589207
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

proc call*(call_589209: Call_DataprocProjectsJobsPatch_589189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_589209.validator(path, query, header, formData, body)
  let scheme = call_589209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589209.url(scheme.get, call_589209.host, call_589209.base,
                         call_589209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589209, url, valid)

proc call*(call_589210: Call_DataprocProjectsJobsPatch_589189; jobId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = "";
          bearerToken: string = ""): Recallable =
  ## dataprocProjectsJobsPatch
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required Specifies the path, relative to <code>Job</code>, of the field to update. For example, to update the labels of a Job the <code>update_mask</code> parameter would be specified as <code>labels</code>, and the PATCH request body would specify the new value. <strong>Note:</strong> Currently, <code>labels</code> is the only field that can be updated.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589211 = newJObject()
  var query_589212 = newJObject()
  var body_589213 = newJObject()
  add(query_589212, "upload_protocol", newJString(uploadProtocol))
  add(query_589212, "fields", newJString(fields))
  add(query_589212, "quotaUser", newJString(quotaUser))
  add(query_589212, "alt", newJString(alt))
  add(query_589212, "pp", newJBool(pp))
  add(path_589211, "jobId", newJString(jobId))
  add(query_589212, "oauth_token", newJString(oauthToken))
  add(query_589212, "uploadType", newJString(uploadType))
  add(query_589212, "callback", newJString(callback))
  add(query_589212, "access_token", newJString(accessToken))
  add(query_589212, "key", newJString(key))
  add(path_589211, "projectId", newJString(projectId))
  add(query_589212, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589213 = body
  add(query_589212, "prettyPrint", newJBool(prettyPrint))
  add(query_589212, "updateMask", newJString(updateMask))
  add(query_589212, "bearer_token", newJString(bearerToken))
  result = call_589210.call(path_589211, query_589212, nil, nil, body_589213)

var dataprocProjectsJobsPatch* = Call_DataprocProjectsJobsPatch_589189(
    name: "dataprocProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsPatch_589190, base: "/",
    url: url_DataprocProjectsJobsPatch_589191, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsDelete_589167 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsJobsDelete_589169(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsDelete_589168(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589170 = path.getOrDefault("jobId")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "jobId", valid_589170
  var valid_589171 = path.getOrDefault("projectId")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = nil)
  if valid_589171 != nil:
    section.add "projectId", valid_589171
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
  var valid_589172 = query.getOrDefault("upload_protocol")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "upload_protocol", valid_589172
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("quotaUser")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "quotaUser", valid_589174
  var valid_589175 = query.getOrDefault("alt")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("json"))
  if valid_589175 != nil:
    section.add "alt", valid_589175
  var valid_589176 = query.getOrDefault("pp")
  valid_589176 = validateParameter(valid_589176, JBool, required = false,
                                 default = newJBool(true))
  if valid_589176 != nil:
    section.add "pp", valid_589176
  var valid_589177 = query.getOrDefault("oauth_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "oauth_token", valid_589177
  var valid_589178 = query.getOrDefault("uploadType")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "uploadType", valid_589178
  var valid_589179 = query.getOrDefault("callback")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "callback", valid_589179
  var valid_589180 = query.getOrDefault("access_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "access_token", valid_589180
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
  var valid_589184 = query.getOrDefault("bearer_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "bearer_token", valid_589184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589185: Call_DataprocProjectsJobsDelete_589167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_589185.validator(path, query, header, formData, body)
  let scheme = call_589185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589185.url(scheme.get, call_589185.host, call_589185.base,
                         call_589185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589185, url, valid)

proc call*(call_589186: Call_DataprocProjectsJobsDelete_589167; jobId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsJobsDelete
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589187 = newJObject()
  var query_589188 = newJObject()
  add(query_589188, "upload_protocol", newJString(uploadProtocol))
  add(query_589188, "fields", newJString(fields))
  add(query_589188, "quotaUser", newJString(quotaUser))
  add(query_589188, "alt", newJString(alt))
  add(query_589188, "pp", newJBool(pp))
  add(path_589187, "jobId", newJString(jobId))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "uploadType", newJString(uploadType))
  add(query_589188, "callback", newJString(callback))
  add(query_589188, "access_token", newJString(accessToken))
  add(query_589188, "key", newJString(key))
  add(path_589187, "projectId", newJString(projectId))
  add(query_589188, "$.xgafv", newJString(Xgafv))
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  add(query_589188, "bearer_token", newJString(bearerToken))
  result = call_589186.call(path_589187, query_589188, nil, nil, nil)

var dataprocProjectsJobsDelete* = Call_DataprocProjectsJobsDelete_589167(
    name: "dataprocProjectsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsDelete_589168, base: "/",
    url: url_DataprocProjectsJobsDelete_589169, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsCancel_589214 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsJobsCancel_589216(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsCancel_589215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Required The job ID.
  ##   projectId: JString (required)
  ##            : Required The ID of the Google Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589217 = path.getOrDefault("jobId")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "jobId", valid_589217
  var valid_589218 = path.getOrDefault("projectId")
  valid_589218 = validateParameter(valid_589218, JString, required = true,
                                 default = nil)
  if valid_589218 != nil:
    section.add "projectId", valid_589218
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
  var valid_589219 = query.getOrDefault("upload_protocol")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "upload_protocol", valid_589219
  var valid_589220 = query.getOrDefault("fields")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "fields", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("alt")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("json"))
  if valid_589222 != nil:
    section.add "alt", valid_589222
  var valid_589223 = query.getOrDefault("pp")
  valid_589223 = validateParameter(valid_589223, JBool, required = false,
                                 default = newJBool(true))
  if valid_589223 != nil:
    section.add "pp", valid_589223
  var valid_589224 = query.getOrDefault("oauth_token")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "oauth_token", valid_589224
  var valid_589225 = query.getOrDefault("uploadType")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "uploadType", valid_589225
  var valid_589226 = query.getOrDefault("callback")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "callback", valid_589226
  var valid_589227 = query.getOrDefault("access_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "access_token", valid_589227
  var valid_589228 = query.getOrDefault("key")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "key", valid_589228
  var valid_589229 = query.getOrDefault("$.xgafv")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("1"))
  if valid_589229 != nil:
    section.add "$.xgafv", valid_589229
  var valid_589230 = query.getOrDefault("prettyPrint")
  valid_589230 = validateParameter(valid_589230, JBool, required = false,
                                 default = newJBool(true))
  if valid_589230 != nil:
    section.add "prettyPrint", valid_589230
  var valid_589231 = query.getOrDefault("bearer_token")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "bearer_token", valid_589231
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

proc call*(call_589233: Call_DataprocProjectsJobsCancel_589214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_DataprocProjectsJobsCancel_589214; jobId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsJobsCancel
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  var body_589237 = newJObject()
  add(query_589236, "upload_protocol", newJString(uploadProtocol))
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "pp", newJBool(pp))
  add(path_589235, "jobId", newJString(jobId))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "uploadType", newJString(uploadType))
  add(query_589236, "callback", newJString(callback))
  add(query_589236, "access_token", newJString(accessToken))
  add(query_589236, "key", newJString(key))
  add(path_589235, "projectId", newJString(projectId))
  add(query_589236, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589237 = body
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  add(query_589236, "bearer_token", newJString(bearerToken))
  result = call_589234.call(path_589235, query_589236, nil, nil, body_589237)

var dataprocProjectsJobsCancel* = Call_DataprocProjectsJobsCancel_589214(
    name: "dataprocProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsJobsCancel_589215, base: "/",
    url: url_DataprocProjectsJobsCancel_589216, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsSubmit_589238 = ref object of OpenApiRestCall_588441
proc url_DataprocProjectsJobsSubmit_589240(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsSubmit_589239(path: JsonNode; query: JsonNode;
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
  var valid_589241 = path.getOrDefault("projectId")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "projectId", valid_589241
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
  var valid_589242 = query.getOrDefault("upload_protocol")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "upload_protocol", valid_589242
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("quotaUser")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "quotaUser", valid_589244
  var valid_589245 = query.getOrDefault("alt")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("json"))
  if valid_589245 != nil:
    section.add "alt", valid_589245
  var valid_589246 = query.getOrDefault("pp")
  valid_589246 = validateParameter(valid_589246, JBool, required = false,
                                 default = newJBool(true))
  if valid_589246 != nil:
    section.add "pp", valid_589246
  var valid_589247 = query.getOrDefault("oauth_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "oauth_token", valid_589247
  var valid_589248 = query.getOrDefault("uploadType")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "uploadType", valid_589248
  var valid_589249 = query.getOrDefault("callback")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "callback", valid_589249
  var valid_589250 = query.getOrDefault("access_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "access_token", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("$.xgafv")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("1"))
  if valid_589252 != nil:
    section.add "$.xgafv", valid_589252
  var valid_589253 = query.getOrDefault("prettyPrint")
  valid_589253 = validateParameter(valid_589253, JBool, required = false,
                                 default = newJBool(true))
  if valid_589253 != nil:
    section.add "prettyPrint", valid_589253
  var valid_589254 = query.getOrDefault("bearer_token")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "bearer_token", valid_589254
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

proc call*(call_589256: Call_DataprocProjectsJobsSubmit_589238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_589256.validator(path, query, header, formData, body)
  let scheme = call_589256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589256.url(scheme.get, call_589256.host, call_589256.base,
                         call_589256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589256, url, valid)

proc call*(call_589257: Call_DataprocProjectsJobsSubmit_589238; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocProjectsJobsSubmit
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589258 = newJObject()
  var query_589259 = newJObject()
  var body_589260 = newJObject()
  add(query_589259, "upload_protocol", newJString(uploadProtocol))
  add(query_589259, "fields", newJString(fields))
  add(query_589259, "quotaUser", newJString(quotaUser))
  add(query_589259, "alt", newJString(alt))
  add(query_589259, "pp", newJBool(pp))
  add(query_589259, "oauth_token", newJString(oauthToken))
  add(query_589259, "uploadType", newJString(uploadType))
  add(query_589259, "callback", newJString(callback))
  add(query_589259, "access_token", newJString(accessToken))
  add(query_589259, "key", newJString(key))
  add(path_589258, "projectId", newJString(projectId))
  add(query_589259, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589260 = body
  add(query_589259, "prettyPrint", newJBool(prettyPrint))
  add(query_589259, "bearer_token", newJString(bearerToken))
  result = call_589257.call(path_589258, query_589259, nil, nil, body_589260)

var dataprocProjectsJobsSubmit* = Call_DataprocProjectsJobsSubmit_589238(
    name: "dataprocProjectsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs:submit",
    validator: validate_DataprocProjectsJobsSubmit_589239, base: "/",
    url: url_DataprocProjectsJobsSubmit_589240, schemes: {Scheme.Https})
type
  Call_DataprocOperationsGet_589261 = ref object of OpenApiRestCall_588441
proc url_DataprocOperationsGet_589263(protocol: Scheme; host: string; base: string;
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

proc validate_DataprocOperationsGet_589262(path: JsonNode; query: JsonNode;
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
  var valid_589264 = path.getOrDefault("name")
  valid_589264 = validateParameter(valid_589264, JString, required = true,
                                 default = nil)
  if valid_589264 != nil:
    section.add "name", valid_589264
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
  var valid_589265 = query.getOrDefault("upload_protocol")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "upload_protocol", valid_589265
  var valid_589266 = query.getOrDefault("fields")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "fields", valid_589266
  var valid_589267 = query.getOrDefault("quotaUser")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "quotaUser", valid_589267
  var valid_589268 = query.getOrDefault("alt")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = newJString("json"))
  if valid_589268 != nil:
    section.add "alt", valid_589268
  var valid_589269 = query.getOrDefault("pp")
  valid_589269 = validateParameter(valid_589269, JBool, required = false,
                                 default = newJBool(true))
  if valid_589269 != nil:
    section.add "pp", valid_589269
  var valid_589270 = query.getOrDefault("oauth_token")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "oauth_token", valid_589270
  var valid_589271 = query.getOrDefault("uploadType")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "uploadType", valid_589271
  var valid_589272 = query.getOrDefault("callback")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "callback", valid_589272
  var valid_589273 = query.getOrDefault("access_token")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "access_token", valid_589273
  var valid_589274 = query.getOrDefault("key")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "key", valid_589274
  var valid_589275 = query.getOrDefault("$.xgafv")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = newJString("1"))
  if valid_589275 != nil:
    section.add "$.xgafv", valid_589275
  var valid_589276 = query.getOrDefault("prettyPrint")
  valid_589276 = validateParameter(valid_589276, JBool, required = false,
                                 default = newJBool(true))
  if valid_589276 != nil:
    section.add "prettyPrint", valid_589276
  var valid_589277 = query.getOrDefault("bearer_token")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "bearer_token", valid_589277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589278: Call_DataprocOperationsGet_589261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_589278.validator(path, query, header, formData, body)
  let scheme = call_589278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589278.url(scheme.get, call_589278.host, call_589278.base,
                         call_589278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589278, url, valid)

proc call*(call_589279: Call_DataprocOperationsGet_589261; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocOperationsGet
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
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
  var path_589280 = newJObject()
  var query_589281 = newJObject()
  add(query_589281, "upload_protocol", newJString(uploadProtocol))
  add(query_589281, "fields", newJString(fields))
  add(query_589281, "quotaUser", newJString(quotaUser))
  add(path_589280, "name", newJString(name))
  add(query_589281, "alt", newJString(alt))
  add(query_589281, "pp", newJBool(pp))
  add(query_589281, "oauth_token", newJString(oauthToken))
  add(query_589281, "uploadType", newJString(uploadType))
  add(query_589281, "callback", newJString(callback))
  add(query_589281, "access_token", newJString(accessToken))
  add(query_589281, "key", newJString(key))
  add(query_589281, "$.xgafv", newJString(Xgafv))
  add(query_589281, "prettyPrint", newJBool(prettyPrint))
  add(query_589281, "bearer_token", newJString(bearerToken))
  result = call_589279.call(path_589280, query_589281, nil, nil, nil)

var dataprocOperationsGet* = Call_DataprocOperationsGet_589261(
    name: "dataprocOperationsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsGet_589262, base: "/",
    url: url_DataprocOperationsGet_589263, schemes: {Scheme.Https})
type
  Call_DataprocOperationsDelete_589282 = ref object of OpenApiRestCall_588441
proc url_DataprocOperationsDelete_589284(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsDelete_589283(path: JsonNode; query: JsonNode;
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
  var valid_589285 = path.getOrDefault("name")
  valid_589285 = validateParameter(valid_589285, JString, required = true,
                                 default = nil)
  if valid_589285 != nil:
    section.add "name", valid_589285
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
  var valid_589286 = query.getOrDefault("upload_protocol")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "upload_protocol", valid_589286
  var valid_589287 = query.getOrDefault("fields")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "fields", valid_589287
  var valid_589288 = query.getOrDefault("quotaUser")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "quotaUser", valid_589288
  var valid_589289 = query.getOrDefault("alt")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = newJString("json"))
  if valid_589289 != nil:
    section.add "alt", valid_589289
  var valid_589290 = query.getOrDefault("pp")
  valid_589290 = validateParameter(valid_589290, JBool, required = false,
                                 default = newJBool(true))
  if valid_589290 != nil:
    section.add "pp", valid_589290
  var valid_589291 = query.getOrDefault("oauth_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "oauth_token", valid_589291
  var valid_589292 = query.getOrDefault("uploadType")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "uploadType", valid_589292
  var valid_589293 = query.getOrDefault("callback")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "callback", valid_589293
  var valid_589294 = query.getOrDefault("access_token")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "access_token", valid_589294
  var valid_589295 = query.getOrDefault("key")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "key", valid_589295
  var valid_589296 = query.getOrDefault("$.xgafv")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("1"))
  if valid_589296 != nil:
    section.add "$.xgafv", valid_589296
  var valid_589297 = query.getOrDefault("prettyPrint")
  valid_589297 = validateParameter(valid_589297, JBool, required = false,
                                 default = newJBool(true))
  if valid_589297 != nil:
    section.add "prettyPrint", valid_589297
  var valid_589298 = query.getOrDefault("bearer_token")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "bearer_token", valid_589298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589299: Call_DataprocOperationsDelete_589282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is no longer interested in the operation result. It does not cancel the operation. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  let valid = call_589299.validator(path, query, header, formData, body)
  let scheme = call_589299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589299.url(scheme.get, call_589299.host, call_589299.base,
                         call_589299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589299, url, valid)

proc call*(call_589300: Call_DataprocOperationsDelete_589282; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## dataprocOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is no longer interested in the operation result. It does not cancel the operation. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
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
  var path_589301 = newJObject()
  var query_589302 = newJObject()
  add(query_589302, "upload_protocol", newJString(uploadProtocol))
  add(query_589302, "fields", newJString(fields))
  add(query_589302, "quotaUser", newJString(quotaUser))
  add(path_589301, "name", newJString(name))
  add(query_589302, "alt", newJString(alt))
  add(query_589302, "pp", newJBool(pp))
  add(query_589302, "oauth_token", newJString(oauthToken))
  add(query_589302, "uploadType", newJString(uploadType))
  add(query_589302, "callback", newJString(callback))
  add(query_589302, "access_token", newJString(accessToken))
  add(query_589302, "key", newJString(key))
  add(query_589302, "$.xgafv", newJString(Xgafv))
  add(query_589302, "prettyPrint", newJBool(prettyPrint))
  add(query_589302, "bearer_token", newJString(bearerToken))
  result = call_589300.call(path_589301, query_589302, nil, nil, nil)

var dataprocOperationsDelete* = Call_DataprocOperationsDelete_589282(
    name: "dataprocOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsDelete_589283, base: "/",
    url: url_DataprocOperationsDelete_589284, schemes: {Scheme.Https})
type
  Call_DataprocOperationsCancel_589303 = ref object of OpenApiRestCall_588441
proc url_DataprocOperationsCancel_589305(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsCancel_589304(path: JsonNode; query: JsonNode;
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
  var valid_589306 = path.getOrDefault("name")
  valid_589306 = validateParameter(valid_589306, JString, required = true,
                                 default = nil)
  if valid_589306 != nil:
    section.add "name", valid_589306
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
  var valid_589307 = query.getOrDefault("upload_protocol")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "upload_protocol", valid_589307
  var valid_589308 = query.getOrDefault("fields")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "fields", valid_589308
  var valid_589309 = query.getOrDefault("quotaUser")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "quotaUser", valid_589309
  var valid_589310 = query.getOrDefault("alt")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = newJString("json"))
  if valid_589310 != nil:
    section.add "alt", valid_589310
  var valid_589311 = query.getOrDefault("pp")
  valid_589311 = validateParameter(valid_589311, JBool, required = false,
                                 default = newJBool(true))
  if valid_589311 != nil:
    section.add "pp", valid_589311
  var valid_589312 = query.getOrDefault("oauth_token")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "oauth_token", valid_589312
  var valid_589313 = query.getOrDefault("uploadType")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "uploadType", valid_589313
  var valid_589314 = query.getOrDefault("callback")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "callback", valid_589314
  var valid_589315 = query.getOrDefault("access_token")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "access_token", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("$.xgafv")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("1"))
  if valid_589317 != nil:
    section.add "$.xgafv", valid_589317
  var valid_589318 = query.getOrDefault("prettyPrint")
  valid_589318 = validateParameter(valid_589318, JBool, required = false,
                                 default = newJBool(true))
  if valid_589318 != nil:
    section.add "prettyPrint", valid_589318
  var valid_589319 = query.getOrDefault("bearer_token")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "bearer_token", valid_589319
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

proc call*(call_589321: Call_DataprocOperationsCancel_589303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use operations.get or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  let valid = call_589321.validator(path, query, header, formData, body)
  let scheme = call_589321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589321.url(scheme.get, call_589321.host, call_589321.base,
                         call_589321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589321, url, valid)

proc call*(call_589322: Call_DataprocOperationsCancel_589303; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## dataprocOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use operations.get or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation.
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
  var path_589323 = newJObject()
  var query_589324 = newJObject()
  var body_589325 = newJObject()
  add(query_589324, "upload_protocol", newJString(uploadProtocol))
  add(query_589324, "fields", newJString(fields))
  add(query_589324, "quotaUser", newJString(quotaUser))
  add(path_589323, "name", newJString(name))
  add(query_589324, "alt", newJString(alt))
  add(query_589324, "pp", newJBool(pp))
  add(query_589324, "oauth_token", newJString(oauthToken))
  add(query_589324, "uploadType", newJString(uploadType))
  add(query_589324, "callback", newJString(callback))
  add(query_589324, "access_token", newJString(accessToken))
  add(query_589324, "key", newJString(key))
  add(query_589324, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589325 = body
  add(query_589324, "prettyPrint", newJBool(prettyPrint))
  add(query_589324, "bearer_token", newJString(bearerToken))
  result = call_589322.call(path_589323, query_589324, nil, nil, body_589325)

var dataprocOperationsCancel* = Call_DataprocOperationsCancel_589303(
    name: "dataprocOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_DataprocOperationsCancel_589304, base: "/",
    url: url_DataprocOperationsCancel_589305, schemes: {Scheme.Https})
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
