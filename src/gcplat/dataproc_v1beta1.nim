
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  Call_DataprocProjectsClustersCreate_593970 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsClustersCreate_593972(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsClustersCreate_593971(path: JsonNode;
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
  var valid_593973 = path.getOrDefault("projectId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "projectId", valid_593973
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
  var valid_593974 = query.getOrDefault("upload_protocol")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "upload_protocol", valid_593974
  var valid_593975 = query.getOrDefault("fields")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "fields", valid_593975
  var valid_593976 = query.getOrDefault("quotaUser")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "quotaUser", valid_593976
  var valid_593977 = query.getOrDefault("alt")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = newJString("json"))
  if valid_593977 != nil:
    section.add "alt", valid_593977
  var valid_593978 = query.getOrDefault("pp")
  valid_593978 = validateParameter(valid_593978, JBool, required = false,
                                 default = newJBool(true))
  if valid_593978 != nil:
    section.add "pp", valid_593978
  var valid_593979 = query.getOrDefault("oauth_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "oauth_token", valid_593979
  var valid_593980 = query.getOrDefault("uploadType")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "uploadType", valid_593980
  var valid_593981 = query.getOrDefault("callback")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "callback", valid_593981
  var valid_593982 = query.getOrDefault("access_token")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "access_token", valid_593982
  var valid_593983 = query.getOrDefault("key")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "key", valid_593983
  var valid_593984 = query.getOrDefault("$.xgafv")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("1"))
  if valid_593984 != nil:
    section.add "$.xgafv", valid_593984
  var valid_593985 = query.getOrDefault("prettyPrint")
  valid_593985 = validateParameter(valid_593985, JBool, required = false,
                                 default = newJBool(true))
  if valid_593985 != nil:
    section.add "prettyPrint", valid_593985
  var valid_593986 = query.getOrDefault("bearer_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "bearer_token", valid_593986
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

proc call*(call_593988: Call_DataprocProjectsClustersCreate_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a cluster in a project.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_DataprocProjectsClustersCreate_593970;
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
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  var body_593992 = newJObject()
  add(query_593991, "upload_protocol", newJString(uploadProtocol))
  add(query_593991, "fields", newJString(fields))
  add(query_593991, "quotaUser", newJString(quotaUser))
  add(query_593991, "alt", newJString(alt))
  add(query_593991, "pp", newJBool(pp))
  add(query_593991, "oauth_token", newJString(oauthToken))
  add(query_593991, "uploadType", newJString(uploadType))
  add(query_593991, "callback", newJString(callback))
  add(query_593991, "access_token", newJString(accessToken))
  add(query_593991, "key", newJString(key))
  add(path_593990, "projectId", newJString(projectId))
  add(query_593991, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593992 = body
  add(query_593991, "prettyPrint", newJBool(prettyPrint))
  add(query_593991, "bearer_token", newJString(bearerToken))
  result = call_593989.call(path_593990, query_593991, nil, nil, body_593992)

var dataprocProjectsClustersCreate* = Call_DataprocProjectsClustersCreate_593970(
    name: "dataprocProjectsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersCreate_593971, base: "/",
    url: url_DataprocProjectsClustersCreate_593972, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersList_593677 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsClustersList_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsClustersList_593678(path: JsonNode; query: JsonNode;
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
  var valid_593805 = path.getOrDefault("projectId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "projectId", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("pageToken")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "pageToken", valid_593808
  var valid_593809 = query.getOrDefault("quotaUser")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "quotaUser", valid_593809
  var valid_593823 = query.getOrDefault("alt")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = newJString("json"))
  if valid_593823 != nil:
    section.add "alt", valid_593823
  var valid_593824 = query.getOrDefault("pp")
  valid_593824 = validateParameter(valid_593824, JBool, required = false,
                                 default = newJBool(true))
  if valid_593824 != nil:
    section.add "pp", valid_593824
  var valid_593825 = query.getOrDefault("oauth_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "oauth_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("callback")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "callback", valid_593827
  var valid_593828 = query.getOrDefault("access_token")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "access_token", valid_593828
  var valid_593829 = query.getOrDefault("key")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = nil)
  if valid_593829 != nil:
    section.add "key", valid_593829
  var valid_593830 = query.getOrDefault("$.xgafv")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = newJString("1"))
  if valid_593830 != nil:
    section.add "$.xgafv", valid_593830
  var valid_593831 = query.getOrDefault("pageSize")
  valid_593831 = validateParameter(valid_593831, JInt, required = false, default = nil)
  if valid_593831 != nil:
    section.add "pageSize", valid_593831
  var valid_593832 = query.getOrDefault("prettyPrint")
  valid_593832 = validateParameter(valid_593832, JBool, required = false,
                                 default = newJBool(true))
  if valid_593832 != nil:
    section.add "prettyPrint", valid_593832
  var valid_593833 = query.getOrDefault("filter")
  valid_593833 = validateParameter(valid_593833, JString, required = false,
                                 default = nil)
  if valid_593833 != nil:
    section.add "filter", valid_593833
  var valid_593834 = query.getOrDefault("bearer_token")
  valid_593834 = validateParameter(valid_593834, JString, required = false,
                                 default = nil)
  if valid_593834 != nil:
    section.add "bearer_token", valid_593834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593857: Call_DataprocProjectsClustersList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all clusters in a project.
  ## 
  let valid = call_593857.validator(path, query, header, formData, body)
  let scheme = call_593857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593857.url(scheme.get, call_593857.host, call_593857.base,
                         call_593857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593857, url, valid)

proc call*(call_593928: Call_DataprocProjectsClustersList_593677;
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
  var path_593929 = newJObject()
  var query_593931 = newJObject()
  add(query_593931, "upload_protocol", newJString(uploadProtocol))
  add(query_593931, "fields", newJString(fields))
  add(query_593931, "pageToken", newJString(pageToken))
  add(query_593931, "quotaUser", newJString(quotaUser))
  add(query_593931, "alt", newJString(alt))
  add(query_593931, "pp", newJBool(pp))
  add(query_593931, "oauth_token", newJString(oauthToken))
  add(query_593931, "uploadType", newJString(uploadType))
  add(query_593931, "callback", newJString(callback))
  add(query_593931, "access_token", newJString(accessToken))
  add(query_593931, "key", newJString(key))
  add(path_593929, "projectId", newJString(projectId))
  add(query_593931, "$.xgafv", newJString(Xgafv))
  add(query_593931, "pageSize", newJInt(pageSize))
  add(query_593931, "prettyPrint", newJBool(prettyPrint))
  add(query_593931, "filter", newJString(filter))
  add(query_593931, "bearer_token", newJString(bearerToken))
  result = call_593928.call(path_593929, query_593931, nil, nil, nil)

var dataprocProjectsClustersList* = Call_DataprocProjectsClustersList_593677(
    name: "dataprocProjectsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersList_593678, base: "/",
    url: url_DataprocProjectsClustersList_593679, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersGet_593993 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsClustersGet_593995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsClustersGet_593994(path: JsonNode; query: JsonNode;
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
  var valid_593996 = path.getOrDefault("clusterName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "clusterName", valid_593996
  var valid_593997 = path.getOrDefault("projectId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "projectId", valid_593997
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
  var valid_593998 = query.getOrDefault("upload_protocol")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "upload_protocol", valid_593998
  var valid_593999 = query.getOrDefault("fields")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "fields", valid_593999
  var valid_594000 = query.getOrDefault("quotaUser")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "quotaUser", valid_594000
  var valid_594001 = query.getOrDefault("alt")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("json"))
  if valid_594001 != nil:
    section.add "alt", valid_594001
  var valid_594002 = query.getOrDefault("pp")
  valid_594002 = validateParameter(valid_594002, JBool, required = false,
                                 default = newJBool(true))
  if valid_594002 != nil:
    section.add "pp", valid_594002
  var valid_594003 = query.getOrDefault("oauth_token")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "oauth_token", valid_594003
  var valid_594004 = query.getOrDefault("uploadType")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "uploadType", valid_594004
  var valid_594005 = query.getOrDefault("callback")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "callback", valid_594005
  var valid_594006 = query.getOrDefault("access_token")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "access_token", valid_594006
  var valid_594007 = query.getOrDefault("key")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "key", valid_594007
  var valid_594008 = query.getOrDefault("$.xgafv")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("1"))
  if valid_594008 != nil:
    section.add "$.xgafv", valid_594008
  var valid_594009 = query.getOrDefault("prettyPrint")
  valid_594009 = validateParameter(valid_594009, JBool, required = false,
                                 default = newJBool(true))
  if valid_594009 != nil:
    section.add "prettyPrint", valid_594009
  var valid_594010 = query.getOrDefault("bearer_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "bearer_token", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_DataprocProjectsClustersGet_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_DataprocProjectsClustersGet_593993;
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
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(path_594013, "clusterName", newJString(clusterName))
  add(query_594014, "upload_protocol", newJString(uploadProtocol))
  add(query_594014, "fields", newJString(fields))
  add(query_594014, "quotaUser", newJString(quotaUser))
  add(query_594014, "alt", newJString(alt))
  add(query_594014, "pp", newJBool(pp))
  add(query_594014, "oauth_token", newJString(oauthToken))
  add(query_594014, "uploadType", newJString(uploadType))
  add(query_594014, "callback", newJString(callback))
  add(query_594014, "access_token", newJString(accessToken))
  add(query_594014, "key", newJString(key))
  add(path_594013, "projectId", newJString(projectId))
  add(query_594014, "$.xgafv", newJString(Xgafv))
  add(query_594014, "prettyPrint", newJBool(prettyPrint))
  add(query_594014, "bearer_token", newJString(bearerToken))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var dataprocProjectsClustersGet* = Call_DataprocProjectsClustersGet_593993(
    name: "dataprocProjectsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersGet_593994, base: "/",
    url: url_DataprocProjectsClustersGet_593995, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersPatch_594037 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsClustersPatch_594039(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsClustersPatch_594038(path: JsonNode; query: JsonNode;
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
  var valid_594040 = path.getOrDefault("clusterName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "clusterName", valid_594040
  var valid_594041 = path.getOrDefault("projectId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "projectId", valid_594041
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
  var valid_594042 = query.getOrDefault("upload_protocol")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "upload_protocol", valid_594042
  var valid_594043 = query.getOrDefault("fields")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "fields", valid_594043
  var valid_594044 = query.getOrDefault("quotaUser")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "quotaUser", valid_594044
  var valid_594045 = query.getOrDefault("alt")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = newJString("json"))
  if valid_594045 != nil:
    section.add "alt", valid_594045
  var valid_594046 = query.getOrDefault("pp")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(true))
  if valid_594046 != nil:
    section.add "pp", valid_594046
  var valid_594047 = query.getOrDefault("oauth_token")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "oauth_token", valid_594047
  var valid_594048 = query.getOrDefault("uploadType")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "uploadType", valid_594048
  var valid_594049 = query.getOrDefault("callback")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "callback", valid_594049
  var valid_594050 = query.getOrDefault("access_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "access_token", valid_594050
  var valid_594051 = query.getOrDefault("key")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "key", valid_594051
  var valid_594052 = query.getOrDefault("$.xgafv")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("1"))
  if valid_594052 != nil:
    section.add "$.xgafv", valid_594052
  var valid_594053 = query.getOrDefault("prettyPrint")
  valid_594053 = validateParameter(valid_594053, JBool, required = false,
                                 default = newJBool(true))
  if valid_594053 != nil:
    section.add "prettyPrint", valid_594053
  var valid_594054 = query.getOrDefault("updateMask")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "updateMask", valid_594054
  var valid_594055 = query.getOrDefault("bearer_token")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "bearer_token", valid_594055
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

proc call*(call_594057: Call_DataprocProjectsClustersPatch_594037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a cluster in a project.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_DataprocProjectsClustersPatch_594037;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(path_594059, "clusterName", newJString(clusterName))
  add(query_594060, "upload_protocol", newJString(uploadProtocol))
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "pp", newJBool(pp))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "uploadType", newJString(uploadType))
  add(query_594060, "callback", newJString(callback))
  add(query_594060, "access_token", newJString(accessToken))
  add(query_594060, "key", newJString(key))
  add(path_594059, "projectId", newJString(projectId))
  add(query_594060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594061 = body
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  add(query_594060, "updateMask", newJString(updateMask))
  add(query_594060, "bearer_token", newJString(bearerToken))
  result = call_594058.call(path_594059, query_594060, nil, nil, body_594061)

var dataprocProjectsClustersPatch* = Call_DataprocProjectsClustersPatch_594037(
    name: "dataprocProjectsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersPatch_594038, base: "/",
    url: url_DataprocProjectsClustersPatch_594039, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDelete_594015 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsClustersDelete_594017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsClustersDelete_594016(path: JsonNode;
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
  var valid_594018 = path.getOrDefault("clusterName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "clusterName", valid_594018
  var valid_594019 = path.getOrDefault("projectId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "projectId", valid_594019
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
  var valid_594020 = query.getOrDefault("upload_protocol")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "upload_protocol", valid_594020
  var valid_594021 = query.getOrDefault("fields")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "fields", valid_594021
  var valid_594022 = query.getOrDefault("quotaUser")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "quotaUser", valid_594022
  var valid_594023 = query.getOrDefault("alt")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("json"))
  if valid_594023 != nil:
    section.add "alt", valid_594023
  var valid_594024 = query.getOrDefault("pp")
  valid_594024 = validateParameter(valid_594024, JBool, required = false,
                                 default = newJBool(true))
  if valid_594024 != nil:
    section.add "pp", valid_594024
  var valid_594025 = query.getOrDefault("oauth_token")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "oauth_token", valid_594025
  var valid_594026 = query.getOrDefault("uploadType")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "uploadType", valid_594026
  var valid_594027 = query.getOrDefault("callback")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "callback", valid_594027
  var valid_594028 = query.getOrDefault("access_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "access_token", valid_594028
  var valid_594029 = query.getOrDefault("key")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "key", valid_594029
  var valid_594030 = query.getOrDefault("$.xgafv")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = newJString("1"))
  if valid_594030 != nil:
    section.add "$.xgafv", valid_594030
  var valid_594031 = query.getOrDefault("prettyPrint")
  valid_594031 = validateParameter(valid_594031, JBool, required = false,
                                 default = newJBool(true))
  if valid_594031 != nil:
    section.add "prettyPrint", valid_594031
  var valid_594032 = query.getOrDefault("bearer_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "bearer_token", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_DataprocProjectsClustersDelete_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a cluster in a project.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_DataprocProjectsClustersDelete_594015;
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
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  add(path_594035, "clusterName", newJString(clusterName))
  add(query_594036, "upload_protocol", newJString(uploadProtocol))
  add(query_594036, "fields", newJString(fields))
  add(query_594036, "quotaUser", newJString(quotaUser))
  add(query_594036, "alt", newJString(alt))
  add(query_594036, "pp", newJBool(pp))
  add(query_594036, "oauth_token", newJString(oauthToken))
  add(query_594036, "uploadType", newJString(uploadType))
  add(query_594036, "callback", newJString(callback))
  add(query_594036, "access_token", newJString(accessToken))
  add(query_594036, "key", newJString(key))
  add(path_594035, "projectId", newJString(projectId))
  add(query_594036, "$.xgafv", newJString(Xgafv))
  add(query_594036, "prettyPrint", newJBool(prettyPrint))
  add(query_594036, "bearer_token", newJString(bearerToken))
  result = call_594034.call(path_594035, query_594036, nil, nil, nil)

var dataprocProjectsClustersDelete* = Call_DataprocProjectsClustersDelete_594015(
    name: "dataprocProjectsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersDelete_594016, base: "/",
    url: url_DataprocProjectsClustersDelete_594017, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDiagnose_594062 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsClustersDiagnose_594064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsClustersDiagnose_594063(path: JsonNode;
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
  var valid_594065 = path.getOrDefault("clusterName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "clusterName", valid_594065
  var valid_594066 = path.getOrDefault("projectId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "projectId", valid_594066
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
  var valid_594067 = query.getOrDefault("upload_protocol")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "upload_protocol", valid_594067
  var valid_594068 = query.getOrDefault("fields")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "fields", valid_594068
  var valid_594069 = query.getOrDefault("quotaUser")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "quotaUser", valid_594069
  var valid_594070 = query.getOrDefault("alt")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = newJString("json"))
  if valid_594070 != nil:
    section.add "alt", valid_594070
  var valid_594071 = query.getOrDefault("pp")
  valid_594071 = validateParameter(valid_594071, JBool, required = false,
                                 default = newJBool(true))
  if valid_594071 != nil:
    section.add "pp", valid_594071
  var valid_594072 = query.getOrDefault("oauth_token")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "oauth_token", valid_594072
  var valid_594073 = query.getOrDefault("uploadType")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "uploadType", valid_594073
  var valid_594074 = query.getOrDefault("callback")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "callback", valid_594074
  var valid_594075 = query.getOrDefault("access_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "access_token", valid_594075
  var valid_594076 = query.getOrDefault("key")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "key", valid_594076
  var valid_594077 = query.getOrDefault("$.xgafv")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("1"))
  if valid_594077 != nil:
    section.add "$.xgafv", valid_594077
  var valid_594078 = query.getOrDefault("prettyPrint")
  valid_594078 = validateParameter(valid_594078, JBool, required = false,
                                 default = newJBool(true))
  if valid_594078 != nil:
    section.add "prettyPrint", valid_594078
  var valid_594079 = query.getOrDefault("bearer_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "bearer_token", valid_594079
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

proc call*(call_594081: Call_DataprocProjectsClustersDiagnose_594062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. After the operation completes, the Operation.response field contains DiagnoseClusterOutputLocation.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_DataprocProjectsClustersDiagnose_594062;
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  var body_594085 = newJObject()
  add(path_594083, "clusterName", newJString(clusterName))
  add(query_594084, "upload_protocol", newJString(uploadProtocol))
  add(query_594084, "fields", newJString(fields))
  add(query_594084, "quotaUser", newJString(quotaUser))
  add(query_594084, "alt", newJString(alt))
  add(query_594084, "pp", newJBool(pp))
  add(query_594084, "oauth_token", newJString(oauthToken))
  add(query_594084, "uploadType", newJString(uploadType))
  add(query_594084, "callback", newJString(callback))
  add(query_594084, "access_token", newJString(accessToken))
  add(query_594084, "key", newJString(key))
  add(path_594083, "projectId", newJString(projectId))
  add(query_594084, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594085 = body
  add(query_594084, "prettyPrint", newJBool(prettyPrint))
  add(query_594084, "bearer_token", newJString(bearerToken))
  result = call_594082.call(path_594083, query_594084, nil, nil, body_594085)

var dataprocProjectsClustersDiagnose* = Call_DataprocProjectsClustersDiagnose_594062(
    name: "dataprocProjectsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsClustersDiagnose_594063, base: "/",
    url: url_DataprocProjectsClustersDiagnose_594064, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsList_594086 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsJobsList_594088(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsJobsList_594087(path: JsonNode; query: JsonNode;
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
  var valid_594089 = path.getOrDefault("projectId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "projectId", valid_594089
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
  var valid_594090 = query.getOrDefault("upload_protocol")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "upload_protocol", valid_594090
  var valid_594091 = query.getOrDefault("fields")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "fields", valid_594091
  var valid_594092 = query.getOrDefault("pageToken")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "pageToken", valid_594092
  var valid_594093 = query.getOrDefault("quotaUser")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "quotaUser", valid_594093
  var valid_594094 = query.getOrDefault("alt")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("json"))
  if valid_594094 != nil:
    section.add "alt", valid_594094
  var valid_594095 = query.getOrDefault("pp")
  valid_594095 = validateParameter(valid_594095, JBool, required = false,
                                 default = newJBool(true))
  if valid_594095 != nil:
    section.add "pp", valid_594095
  var valid_594096 = query.getOrDefault("oauth_token")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "oauth_token", valid_594096
  var valid_594097 = query.getOrDefault("uploadType")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "uploadType", valid_594097
  var valid_594098 = query.getOrDefault("callback")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "callback", valid_594098
  var valid_594099 = query.getOrDefault("access_token")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "access_token", valid_594099
  var valid_594100 = query.getOrDefault("jobStateMatcher")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("ALL"))
  if valid_594100 != nil:
    section.add "jobStateMatcher", valid_594100
  var valid_594101 = query.getOrDefault("key")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "key", valid_594101
  var valid_594102 = query.getOrDefault("$.xgafv")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = newJString("1"))
  if valid_594102 != nil:
    section.add "$.xgafv", valid_594102
  var valid_594103 = query.getOrDefault("pageSize")
  valid_594103 = validateParameter(valid_594103, JInt, required = false, default = nil)
  if valid_594103 != nil:
    section.add "pageSize", valid_594103
  var valid_594104 = query.getOrDefault("prettyPrint")
  valid_594104 = validateParameter(valid_594104, JBool, required = false,
                                 default = newJBool(true))
  if valid_594104 != nil:
    section.add "prettyPrint", valid_594104
  var valid_594105 = query.getOrDefault("filter")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "filter", valid_594105
  var valid_594106 = query.getOrDefault("clusterName")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "clusterName", valid_594106
  var valid_594107 = query.getOrDefault("bearer_token")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "bearer_token", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_DataprocProjectsJobsList_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs in a project.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_DataprocProjectsJobsList_594086; projectId: string;
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
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(query_594111, "upload_protocol", newJString(uploadProtocol))
  add(query_594111, "fields", newJString(fields))
  add(query_594111, "pageToken", newJString(pageToken))
  add(query_594111, "quotaUser", newJString(quotaUser))
  add(query_594111, "alt", newJString(alt))
  add(query_594111, "pp", newJBool(pp))
  add(query_594111, "oauth_token", newJString(oauthToken))
  add(query_594111, "uploadType", newJString(uploadType))
  add(query_594111, "callback", newJString(callback))
  add(query_594111, "access_token", newJString(accessToken))
  add(query_594111, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_594111, "key", newJString(key))
  add(path_594110, "projectId", newJString(projectId))
  add(query_594111, "$.xgafv", newJString(Xgafv))
  add(query_594111, "pageSize", newJInt(pageSize))
  add(query_594111, "prettyPrint", newJBool(prettyPrint))
  add(query_594111, "filter", newJString(filter))
  add(query_594111, "clusterName", newJString(clusterName))
  add(query_594111, "bearer_token", newJString(bearerToken))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var dataprocProjectsJobsList* = Call_DataprocProjectsJobsList_594086(
    name: "dataprocProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/projects/{projectId}/jobs",
    validator: validate_DataprocProjectsJobsList_594087, base: "/",
    url: url_DataprocProjectsJobsList_594088, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsGet_594112 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsJobsGet_594114(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsJobsGet_594113(path: JsonNode; query: JsonNode;
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
  var valid_594115 = path.getOrDefault("jobId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "jobId", valid_594115
  var valid_594116 = path.getOrDefault("projectId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "projectId", valid_594116
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
  var valid_594117 = query.getOrDefault("upload_protocol")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "upload_protocol", valid_594117
  var valid_594118 = query.getOrDefault("fields")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "fields", valid_594118
  var valid_594119 = query.getOrDefault("quotaUser")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "quotaUser", valid_594119
  var valid_594120 = query.getOrDefault("alt")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("json"))
  if valid_594120 != nil:
    section.add "alt", valid_594120
  var valid_594121 = query.getOrDefault("pp")
  valid_594121 = validateParameter(valid_594121, JBool, required = false,
                                 default = newJBool(true))
  if valid_594121 != nil:
    section.add "pp", valid_594121
  var valid_594122 = query.getOrDefault("oauth_token")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "oauth_token", valid_594122
  var valid_594123 = query.getOrDefault("uploadType")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "uploadType", valid_594123
  var valid_594124 = query.getOrDefault("callback")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "callback", valid_594124
  var valid_594125 = query.getOrDefault("access_token")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "access_token", valid_594125
  var valid_594126 = query.getOrDefault("key")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "key", valid_594126
  var valid_594127 = query.getOrDefault("$.xgafv")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = newJString("1"))
  if valid_594127 != nil:
    section.add "$.xgafv", valid_594127
  var valid_594128 = query.getOrDefault("prettyPrint")
  valid_594128 = validateParameter(valid_594128, JBool, required = false,
                                 default = newJBool(true))
  if valid_594128 != nil:
    section.add "prettyPrint", valid_594128
  var valid_594129 = query.getOrDefault("bearer_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "bearer_token", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_DataprocProjectsJobsGet_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_DataprocProjectsJobsGet_594112; jobId: string;
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
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(query_594133, "upload_protocol", newJString(uploadProtocol))
  add(query_594133, "fields", newJString(fields))
  add(query_594133, "quotaUser", newJString(quotaUser))
  add(query_594133, "alt", newJString(alt))
  add(query_594133, "pp", newJBool(pp))
  add(path_594132, "jobId", newJString(jobId))
  add(query_594133, "oauth_token", newJString(oauthToken))
  add(query_594133, "uploadType", newJString(uploadType))
  add(query_594133, "callback", newJString(callback))
  add(query_594133, "access_token", newJString(accessToken))
  add(query_594133, "key", newJString(key))
  add(path_594132, "projectId", newJString(projectId))
  add(query_594133, "$.xgafv", newJString(Xgafv))
  add(query_594133, "prettyPrint", newJBool(prettyPrint))
  add(query_594133, "bearer_token", newJString(bearerToken))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var dataprocProjectsJobsGet* = Call_DataprocProjectsJobsGet_594112(
    name: "dataprocProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsGet_594113, base: "/",
    url: url_DataprocProjectsJobsGet_594114, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsPatch_594156 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsJobsPatch_594158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsJobsPatch_594157(path: JsonNode; query: JsonNode;
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
  var valid_594159 = path.getOrDefault("jobId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "jobId", valid_594159
  var valid_594160 = path.getOrDefault("projectId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "projectId", valid_594160
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
  var valid_594161 = query.getOrDefault("upload_protocol")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "upload_protocol", valid_594161
  var valid_594162 = query.getOrDefault("fields")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "fields", valid_594162
  var valid_594163 = query.getOrDefault("quotaUser")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "quotaUser", valid_594163
  var valid_594164 = query.getOrDefault("alt")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = newJString("json"))
  if valid_594164 != nil:
    section.add "alt", valid_594164
  var valid_594165 = query.getOrDefault("pp")
  valid_594165 = validateParameter(valid_594165, JBool, required = false,
                                 default = newJBool(true))
  if valid_594165 != nil:
    section.add "pp", valid_594165
  var valid_594166 = query.getOrDefault("oauth_token")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "oauth_token", valid_594166
  var valid_594167 = query.getOrDefault("uploadType")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "uploadType", valid_594167
  var valid_594168 = query.getOrDefault("callback")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "callback", valid_594168
  var valid_594169 = query.getOrDefault("access_token")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "access_token", valid_594169
  var valid_594170 = query.getOrDefault("key")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "key", valid_594170
  var valid_594171 = query.getOrDefault("$.xgafv")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = newJString("1"))
  if valid_594171 != nil:
    section.add "$.xgafv", valid_594171
  var valid_594172 = query.getOrDefault("prettyPrint")
  valid_594172 = validateParameter(valid_594172, JBool, required = false,
                                 default = newJBool(true))
  if valid_594172 != nil:
    section.add "prettyPrint", valid_594172
  var valid_594173 = query.getOrDefault("updateMask")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "updateMask", valid_594173
  var valid_594174 = query.getOrDefault("bearer_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "bearer_token", valid_594174
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

proc call*(call_594176: Call_DataprocProjectsJobsPatch_594156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_DataprocProjectsJobsPatch_594156; jobId: string;
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
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  var body_594180 = newJObject()
  add(query_594179, "upload_protocol", newJString(uploadProtocol))
  add(query_594179, "fields", newJString(fields))
  add(query_594179, "quotaUser", newJString(quotaUser))
  add(query_594179, "alt", newJString(alt))
  add(query_594179, "pp", newJBool(pp))
  add(path_594178, "jobId", newJString(jobId))
  add(query_594179, "oauth_token", newJString(oauthToken))
  add(query_594179, "uploadType", newJString(uploadType))
  add(query_594179, "callback", newJString(callback))
  add(query_594179, "access_token", newJString(accessToken))
  add(query_594179, "key", newJString(key))
  add(path_594178, "projectId", newJString(projectId))
  add(query_594179, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594180 = body
  add(query_594179, "prettyPrint", newJBool(prettyPrint))
  add(query_594179, "updateMask", newJString(updateMask))
  add(query_594179, "bearer_token", newJString(bearerToken))
  result = call_594177.call(path_594178, query_594179, nil, nil, body_594180)

var dataprocProjectsJobsPatch* = Call_DataprocProjectsJobsPatch_594156(
    name: "dataprocProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsPatch_594157, base: "/",
    url: url_DataprocProjectsJobsPatch_594158, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsDelete_594134 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsJobsDelete_594136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsJobsDelete_594135(path: JsonNode; query: JsonNode;
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
  var valid_594137 = path.getOrDefault("jobId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "jobId", valid_594137
  var valid_594138 = path.getOrDefault("projectId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "projectId", valid_594138
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
  var valid_594139 = query.getOrDefault("upload_protocol")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "upload_protocol", valid_594139
  var valid_594140 = query.getOrDefault("fields")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "fields", valid_594140
  var valid_594141 = query.getOrDefault("quotaUser")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "quotaUser", valid_594141
  var valid_594142 = query.getOrDefault("alt")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = newJString("json"))
  if valid_594142 != nil:
    section.add "alt", valid_594142
  var valid_594143 = query.getOrDefault("pp")
  valid_594143 = validateParameter(valid_594143, JBool, required = false,
                                 default = newJBool(true))
  if valid_594143 != nil:
    section.add "pp", valid_594143
  var valid_594144 = query.getOrDefault("oauth_token")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "oauth_token", valid_594144
  var valid_594145 = query.getOrDefault("uploadType")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "uploadType", valid_594145
  var valid_594146 = query.getOrDefault("callback")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "callback", valid_594146
  var valid_594147 = query.getOrDefault("access_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "access_token", valid_594147
  var valid_594148 = query.getOrDefault("key")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "key", valid_594148
  var valid_594149 = query.getOrDefault("$.xgafv")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("1"))
  if valid_594149 != nil:
    section.add "$.xgafv", valid_594149
  var valid_594150 = query.getOrDefault("prettyPrint")
  valid_594150 = validateParameter(valid_594150, JBool, required = false,
                                 default = newJBool(true))
  if valid_594150 != nil:
    section.add "prettyPrint", valid_594150
  var valid_594151 = query.getOrDefault("bearer_token")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "bearer_token", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594152: Call_DataprocProjectsJobsDelete_594134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_DataprocProjectsJobsDelete_594134; jobId: string;
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
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  add(query_594155, "upload_protocol", newJString(uploadProtocol))
  add(query_594155, "fields", newJString(fields))
  add(query_594155, "quotaUser", newJString(quotaUser))
  add(query_594155, "alt", newJString(alt))
  add(query_594155, "pp", newJBool(pp))
  add(path_594154, "jobId", newJString(jobId))
  add(query_594155, "oauth_token", newJString(oauthToken))
  add(query_594155, "uploadType", newJString(uploadType))
  add(query_594155, "callback", newJString(callback))
  add(query_594155, "access_token", newJString(accessToken))
  add(query_594155, "key", newJString(key))
  add(path_594154, "projectId", newJString(projectId))
  add(query_594155, "$.xgafv", newJString(Xgafv))
  add(query_594155, "prettyPrint", newJBool(prettyPrint))
  add(query_594155, "bearer_token", newJString(bearerToken))
  result = call_594153.call(path_594154, query_594155, nil, nil, nil)

var dataprocProjectsJobsDelete* = Call_DataprocProjectsJobsDelete_594134(
    name: "dataprocProjectsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsDelete_594135, base: "/",
    url: url_DataprocProjectsJobsDelete_594136, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsCancel_594181 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsJobsCancel_594183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsJobsCancel_594182(path: JsonNode; query: JsonNode;
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
  var valid_594184 = path.getOrDefault("jobId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "jobId", valid_594184
  var valid_594185 = path.getOrDefault("projectId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "projectId", valid_594185
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
  var valid_594186 = query.getOrDefault("upload_protocol")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "upload_protocol", valid_594186
  var valid_594187 = query.getOrDefault("fields")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "fields", valid_594187
  var valid_594188 = query.getOrDefault("quotaUser")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "quotaUser", valid_594188
  var valid_594189 = query.getOrDefault("alt")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = newJString("json"))
  if valid_594189 != nil:
    section.add "alt", valid_594189
  var valid_594190 = query.getOrDefault("pp")
  valid_594190 = validateParameter(valid_594190, JBool, required = false,
                                 default = newJBool(true))
  if valid_594190 != nil:
    section.add "pp", valid_594190
  var valid_594191 = query.getOrDefault("oauth_token")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "oauth_token", valid_594191
  var valid_594192 = query.getOrDefault("uploadType")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "uploadType", valid_594192
  var valid_594193 = query.getOrDefault("callback")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "callback", valid_594193
  var valid_594194 = query.getOrDefault("access_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "access_token", valid_594194
  var valid_594195 = query.getOrDefault("key")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "key", valid_594195
  var valid_594196 = query.getOrDefault("$.xgafv")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = newJString("1"))
  if valid_594196 != nil:
    section.add "$.xgafv", valid_594196
  var valid_594197 = query.getOrDefault("prettyPrint")
  valid_594197 = validateParameter(valid_594197, JBool, required = false,
                                 default = newJBool(true))
  if valid_594197 != nil:
    section.add "prettyPrint", valid_594197
  var valid_594198 = query.getOrDefault("bearer_token")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "bearer_token", valid_594198
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

proc call*(call_594200: Call_DataprocProjectsJobsCancel_594181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
  ## 
  let valid = call_594200.validator(path, query, header, formData, body)
  let scheme = call_594200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594200.url(scheme.get, call_594200.host, call_594200.base,
                         call_594200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594200, url, valid)

proc call*(call_594201: Call_DataprocProjectsJobsCancel_594181; jobId: string;
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
  var path_594202 = newJObject()
  var query_594203 = newJObject()
  var body_594204 = newJObject()
  add(query_594203, "upload_protocol", newJString(uploadProtocol))
  add(query_594203, "fields", newJString(fields))
  add(query_594203, "quotaUser", newJString(quotaUser))
  add(query_594203, "alt", newJString(alt))
  add(query_594203, "pp", newJBool(pp))
  add(path_594202, "jobId", newJString(jobId))
  add(query_594203, "oauth_token", newJString(oauthToken))
  add(query_594203, "uploadType", newJString(uploadType))
  add(query_594203, "callback", newJString(callback))
  add(query_594203, "access_token", newJString(accessToken))
  add(query_594203, "key", newJString(key))
  add(path_594202, "projectId", newJString(projectId))
  add(query_594203, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594204 = body
  add(query_594203, "prettyPrint", newJBool(prettyPrint))
  add(query_594203, "bearer_token", newJString(bearerToken))
  result = call_594201.call(path_594202, query_594203, nil, nil, body_594204)

var dataprocProjectsJobsCancel* = Call_DataprocProjectsJobsCancel_594181(
    name: "dataprocProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsJobsCancel_594182, base: "/",
    url: url_DataprocProjectsJobsCancel_594183, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsSubmit_594205 = ref object of OpenApiRestCall_593408
proc url_DataprocProjectsJobsSubmit_594207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocProjectsJobsSubmit_594206(path: JsonNode; query: JsonNode;
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
  var valid_594208 = path.getOrDefault("projectId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "projectId", valid_594208
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
  var valid_594209 = query.getOrDefault("upload_protocol")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "upload_protocol", valid_594209
  var valid_594210 = query.getOrDefault("fields")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "fields", valid_594210
  var valid_594211 = query.getOrDefault("quotaUser")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "quotaUser", valid_594211
  var valid_594212 = query.getOrDefault("alt")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = newJString("json"))
  if valid_594212 != nil:
    section.add "alt", valid_594212
  var valid_594213 = query.getOrDefault("pp")
  valid_594213 = validateParameter(valid_594213, JBool, required = false,
                                 default = newJBool(true))
  if valid_594213 != nil:
    section.add "pp", valid_594213
  var valid_594214 = query.getOrDefault("oauth_token")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "oauth_token", valid_594214
  var valid_594215 = query.getOrDefault("uploadType")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "uploadType", valid_594215
  var valid_594216 = query.getOrDefault("callback")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "callback", valid_594216
  var valid_594217 = query.getOrDefault("access_token")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "access_token", valid_594217
  var valid_594218 = query.getOrDefault("key")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "key", valid_594218
  var valid_594219 = query.getOrDefault("$.xgafv")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = newJString("1"))
  if valid_594219 != nil:
    section.add "$.xgafv", valid_594219
  var valid_594220 = query.getOrDefault("prettyPrint")
  valid_594220 = validateParameter(valid_594220, JBool, required = false,
                                 default = newJBool(true))
  if valid_594220 != nil:
    section.add "prettyPrint", valid_594220
  var valid_594221 = query.getOrDefault("bearer_token")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "bearer_token", valid_594221
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

proc call*(call_594223: Call_DataprocProjectsJobsSubmit_594205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_DataprocProjectsJobsSubmit_594205; projectId: string;
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
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  var body_594227 = newJObject()
  add(query_594226, "upload_protocol", newJString(uploadProtocol))
  add(query_594226, "fields", newJString(fields))
  add(query_594226, "quotaUser", newJString(quotaUser))
  add(query_594226, "alt", newJString(alt))
  add(query_594226, "pp", newJBool(pp))
  add(query_594226, "oauth_token", newJString(oauthToken))
  add(query_594226, "uploadType", newJString(uploadType))
  add(query_594226, "callback", newJString(callback))
  add(query_594226, "access_token", newJString(accessToken))
  add(query_594226, "key", newJString(key))
  add(path_594225, "projectId", newJString(projectId))
  add(query_594226, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594227 = body
  add(query_594226, "prettyPrint", newJBool(prettyPrint))
  add(query_594226, "bearer_token", newJString(bearerToken))
  result = call_594224.call(path_594225, query_594226, nil, nil, body_594227)

var dataprocProjectsJobsSubmit* = Call_DataprocProjectsJobsSubmit_594205(
    name: "dataprocProjectsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs:submit",
    validator: validate_DataprocProjectsJobsSubmit_594206, base: "/",
    url: url_DataprocProjectsJobsSubmit_594207, schemes: {Scheme.Https})
type
  Call_DataprocOperationsGet_594228 = ref object of OpenApiRestCall_593408
proc url_DataprocOperationsGet_594230(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsGet_594229(path: JsonNode; query: JsonNode;
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
  var valid_594231 = path.getOrDefault("name")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "name", valid_594231
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
  var valid_594232 = query.getOrDefault("upload_protocol")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "upload_protocol", valid_594232
  var valid_594233 = query.getOrDefault("fields")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "fields", valid_594233
  var valid_594234 = query.getOrDefault("quotaUser")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "quotaUser", valid_594234
  var valid_594235 = query.getOrDefault("alt")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = newJString("json"))
  if valid_594235 != nil:
    section.add "alt", valid_594235
  var valid_594236 = query.getOrDefault("pp")
  valid_594236 = validateParameter(valid_594236, JBool, required = false,
                                 default = newJBool(true))
  if valid_594236 != nil:
    section.add "pp", valid_594236
  var valid_594237 = query.getOrDefault("oauth_token")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "oauth_token", valid_594237
  var valid_594238 = query.getOrDefault("uploadType")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "uploadType", valid_594238
  var valid_594239 = query.getOrDefault("callback")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "callback", valid_594239
  var valid_594240 = query.getOrDefault("access_token")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "access_token", valid_594240
  var valid_594241 = query.getOrDefault("key")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "key", valid_594241
  var valid_594242 = query.getOrDefault("$.xgafv")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = newJString("1"))
  if valid_594242 != nil:
    section.add "$.xgafv", valid_594242
  var valid_594243 = query.getOrDefault("prettyPrint")
  valid_594243 = validateParameter(valid_594243, JBool, required = false,
                                 default = newJBool(true))
  if valid_594243 != nil:
    section.add "prettyPrint", valid_594243
  var valid_594244 = query.getOrDefault("bearer_token")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "bearer_token", valid_594244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594245: Call_DataprocOperationsGet_594228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_594245.validator(path, query, header, formData, body)
  let scheme = call_594245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594245.url(scheme.get, call_594245.host, call_594245.base,
                         call_594245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594245, url, valid)

proc call*(call_594246: Call_DataprocOperationsGet_594228; name: string;
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
  var path_594247 = newJObject()
  var query_594248 = newJObject()
  add(query_594248, "upload_protocol", newJString(uploadProtocol))
  add(query_594248, "fields", newJString(fields))
  add(query_594248, "quotaUser", newJString(quotaUser))
  add(path_594247, "name", newJString(name))
  add(query_594248, "alt", newJString(alt))
  add(query_594248, "pp", newJBool(pp))
  add(query_594248, "oauth_token", newJString(oauthToken))
  add(query_594248, "uploadType", newJString(uploadType))
  add(query_594248, "callback", newJString(callback))
  add(query_594248, "access_token", newJString(accessToken))
  add(query_594248, "key", newJString(key))
  add(query_594248, "$.xgafv", newJString(Xgafv))
  add(query_594248, "prettyPrint", newJBool(prettyPrint))
  add(query_594248, "bearer_token", newJString(bearerToken))
  result = call_594246.call(path_594247, query_594248, nil, nil, nil)

var dataprocOperationsGet* = Call_DataprocOperationsGet_594228(
    name: "dataprocOperationsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsGet_594229, base: "/",
    url: url_DataprocOperationsGet_594230, schemes: {Scheme.Https})
type
  Call_DataprocOperationsDelete_594249 = ref object of OpenApiRestCall_593408
proc url_DataprocOperationsDelete_594251(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataprocOperationsDelete_594250(path: JsonNode; query: JsonNode;
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
  var valid_594252 = path.getOrDefault("name")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "name", valid_594252
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
  var valid_594253 = query.getOrDefault("upload_protocol")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "upload_protocol", valid_594253
  var valid_594254 = query.getOrDefault("fields")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "fields", valid_594254
  var valid_594255 = query.getOrDefault("quotaUser")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "quotaUser", valid_594255
  var valid_594256 = query.getOrDefault("alt")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = newJString("json"))
  if valid_594256 != nil:
    section.add "alt", valid_594256
  var valid_594257 = query.getOrDefault("pp")
  valid_594257 = validateParameter(valid_594257, JBool, required = false,
                                 default = newJBool(true))
  if valid_594257 != nil:
    section.add "pp", valid_594257
  var valid_594258 = query.getOrDefault("oauth_token")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "oauth_token", valid_594258
  var valid_594259 = query.getOrDefault("uploadType")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "uploadType", valid_594259
  var valid_594260 = query.getOrDefault("callback")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "callback", valid_594260
  var valid_594261 = query.getOrDefault("access_token")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "access_token", valid_594261
  var valid_594262 = query.getOrDefault("key")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "key", valid_594262
  var valid_594263 = query.getOrDefault("$.xgafv")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = newJString("1"))
  if valid_594263 != nil:
    section.add "$.xgafv", valid_594263
  var valid_594264 = query.getOrDefault("prettyPrint")
  valid_594264 = validateParameter(valid_594264, JBool, required = false,
                                 default = newJBool(true))
  if valid_594264 != nil:
    section.add "prettyPrint", valid_594264
  var valid_594265 = query.getOrDefault("bearer_token")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "bearer_token", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594266: Call_DataprocOperationsDelete_594249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is no longer interested in the operation result. It does not cancel the operation. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  let valid = call_594266.validator(path, query, header, formData, body)
  let scheme = call_594266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594266.url(scheme.get, call_594266.host, call_594266.base,
                         call_594266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594266, url, valid)

proc call*(call_594267: Call_DataprocOperationsDelete_594249; name: string;
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
  var path_594268 = newJObject()
  var query_594269 = newJObject()
  add(query_594269, "upload_protocol", newJString(uploadProtocol))
  add(query_594269, "fields", newJString(fields))
  add(query_594269, "quotaUser", newJString(quotaUser))
  add(path_594268, "name", newJString(name))
  add(query_594269, "alt", newJString(alt))
  add(query_594269, "pp", newJBool(pp))
  add(query_594269, "oauth_token", newJString(oauthToken))
  add(query_594269, "uploadType", newJString(uploadType))
  add(query_594269, "callback", newJString(callback))
  add(query_594269, "access_token", newJString(accessToken))
  add(query_594269, "key", newJString(key))
  add(query_594269, "$.xgafv", newJString(Xgafv))
  add(query_594269, "prettyPrint", newJBool(prettyPrint))
  add(query_594269, "bearer_token", newJString(bearerToken))
  result = call_594267.call(path_594268, query_594269, nil, nil, nil)

var dataprocOperationsDelete* = Call_DataprocOperationsDelete_594249(
    name: "dataprocOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsDelete_594250, base: "/",
    url: url_DataprocOperationsDelete_594251, schemes: {Scheme.Https})
type
  Call_DataprocOperationsCancel_594270 = ref object of OpenApiRestCall_593408
proc url_DataprocOperationsCancel_594272(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataprocOperationsCancel_594271(path: JsonNode; query: JsonNode;
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
  var valid_594273 = path.getOrDefault("name")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "name", valid_594273
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
  var valid_594274 = query.getOrDefault("upload_protocol")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "upload_protocol", valid_594274
  var valid_594275 = query.getOrDefault("fields")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "fields", valid_594275
  var valid_594276 = query.getOrDefault("quotaUser")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "quotaUser", valid_594276
  var valid_594277 = query.getOrDefault("alt")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = newJString("json"))
  if valid_594277 != nil:
    section.add "alt", valid_594277
  var valid_594278 = query.getOrDefault("pp")
  valid_594278 = validateParameter(valid_594278, JBool, required = false,
                                 default = newJBool(true))
  if valid_594278 != nil:
    section.add "pp", valid_594278
  var valid_594279 = query.getOrDefault("oauth_token")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "oauth_token", valid_594279
  var valid_594280 = query.getOrDefault("uploadType")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "uploadType", valid_594280
  var valid_594281 = query.getOrDefault("callback")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "callback", valid_594281
  var valid_594282 = query.getOrDefault("access_token")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "access_token", valid_594282
  var valid_594283 = query.getOrDefault("key")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "key", valid_594283
  var valid_594284 = query.getOrDefault("$.xgafv")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = newJString("1"))
  if valid_594284 != nil:
    section.add "$.xgafv", valid_594284
  var valid_594285 = query.getOrDefault("prettyPrint")
  valid_594285 = validateParameter(valid_594285, JBool, required = false,
                                 default = newJBool(true))
  if valid_594285 != nil:
    section.add "prettyPrint", valid_594285
  var valid_594286 = query.getOrDefault("bearer_token")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "bearer_token", valid_594286
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

proc call*(call_594288: Call_DataprocOperationsCancel_594270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use operations.get or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  let valid = call_594288.validator(path, query, header, formData, body)
  let scheme = call_594288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594288.url(scheme.get, call_594288.host, call_594288.base,
                         call_594288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594288, url, valid)

proc call*(call_594289: Call_DataprocOperationsCancel_594270; name: string;
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
  var path_594290 = newJObject()
  var query_594291 = newJObject()
  var body_594292 = newJObject()
  add(query_594291, "upload_protocol", newJString(uploadProtocol))
  add(query_594291, "fields", newJString(fields))
  add(query_594291, "quotaUser", newJString(quotaUser))
  add(path_594290, "name", newJString(name))
  add(query_594291, "alt", newJString(alt))
  add(query_594291, "pp", newJBool(pp))
  add(query_594291, "oauth_token", newJString(oauthToken))
  add(query_594291, "uploadType", newJString(uploadType))
  add(query_594291, "callback", newJString(callback))
  add(query_594291, "access_token", newJString(accessToken))
  add(query_594291, "key", newJString(key))
  add(query_594291, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594292 = body
  add(query_594291, "prettyPrint", newJBool(prettyPrint))
  add(query_594291, "bearer_token", newJString(bearerToken))
  result = call_594289.call(path_594290, query_594291, nil, nil, body_594292)

var dataprocOperationsCancel* = Call_DataprocOperationsCancel_594270(
    name: "dataprocOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_DataprocOperationsCancel_594271, base: "/",
    url: url_DataprocOperationsCancel_594272, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
