
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
  gcpServiceName = "dataproc"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataprocProjectsClustersCreate_579970 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsClustersCreate_579972(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersCreate_579971(path: JsonNode;
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
  var valid_579973 = path.getOrDefault("projectId")
  valid_579973 = validateParameter(valid_579973, JString, required = true,
                                 default = nil)
  if valid_579973 != nil:
    section.add "projectId", valid_579973
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
  var valid_579974 = query.getOrDefault("upload_protocol")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "upload_protocol", valid_579974
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
  var valid_579976 = query.getOrDefault("quotaUser")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "quotaUser", valid_579976
  var valid_579977 = query.getOrDefault("alt")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("json"))
  if valid_579977 != nil:
    section.add "alt", valid_579977
  var valid_579978 = query.getOrDefault("pp")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "pp", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("uploadType")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "uploadType", valid_579980
  var valid_579981 = query.getOrDefault("callback")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "callback", valid_579981
  var valid_579982 = query.getOrDefault("access_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "access_token", valid_579982
  var valid_579983 = query.getOrDefault("key")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "key", valid_579983
  var valid_579984 = query.getOrDefault("$.xgafv")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("1"))
  if valid_579984 != nil:
    section.add "$.xgafv", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  var valid_579986 = query.getOrDefault("bearer_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "bearer_token", valid_579986
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

proc call*(call_579988: Call_DataprocProjectsClustersCreate_579970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a cluster in a project.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_DataprocProjectsClustersCreate_579970;
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
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  var body_579992 = newJObject()
  add(query_579991, "upload_protocol", newJString(uploadProtocol))
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "pp", newJBool(pp))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "uploadType", newJString(uploadType))
  add(query_579991, "callback", newJString(callback))
  add(query_579991, "access_token", newJString(accessToken))
  add(query_579991, "key", newJString(key))
  add(path_579990, "projectId", newJString(projectId))
  add(query_579991, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579992 = body
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  add(query_579991, "bearer_token", newJString(bearerToken))
  result = call_579989.call(path_579990, query_579991, nil, nil, body_579992)

var dataprocProjectsClustersCreate* = Call_DataprocProjectsClustersCreate_579970(
    name: "dataprocProjectsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersCreate_579971, base: "/",
    url: url_DataprocProjectsClustersCreate_579972, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersList_579677 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsClustersList_579679(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579824 = query.getOrDefault("pp")
  valid_579824 = validateParameter(valid_579824, JBool, required = false,
                                 default = newJBool(true))
  if valid_579824 != nil:
    section.add "pp", valid_579824
  var valid_579825 = query.getOrDefault("oauth_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "oauth_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("callback")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "callback", valid_579827
  var valid_579828 = query.getOrDefault("access_token")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "access_token", valid_579828
  var valid_579829 = query.getOrDefault("key")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "key", valid_579829
  var valid_579830 = query.getOrDefault("$.xgafv")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = newJString("1"))
  if valid_579830 != nil:
    section.add "$.xgafv", valid_579830
  var valid_579831 = query.getOrDefault("pageSize")
  valid_579831 = validateParameter(valid_579831, JInt, required = false, default = nil)
  if valid_579831 != nil:
    section.add "pageSize", valid_579831
  var valid_579832 = query.getOrDefault("prettyPrint")
  valid_579832 = validateParameter(valid_579832, JBool, required = false,
                                 default = newJBool(true))
  if valid_579832 != nil:
    section.add "prettyPrint", valid_579832
  var valid_579833 = query.getOrDefault("filter")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "filter", valid_579833
  var valid_579834 = query.getOrDefault("bearer_token")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "bearer_token", valid_579834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579857: Call_DataprocProjectsClustersList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all clusters in a project.
  ## 
  let valid = call_579857.validator(path, query, header, formData, body)
  let scheme = call_579857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579857.url(scheme.get, call_579857.host, call_579857.base,
                         call_579857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579857, url, valid)

proc call*(call_579928: Call_DataprocProjectsClustersList_579677;
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
  var path_579929 = newJObject()
  var query_579931 = newJObject()
  add(query_579931, "upload_protocol", newJString(uploadProtocol))
  add(query_579931, "fields", newJString(fields))
  add(query_579931, "pageToken", newJString(pageToken))
  add(query_579931, "quotaUser", newJString(quotaUser))
  add(query_579931, "alt", newJString(alt))
  add(query_579931, "pp", newJBool(pp))
  add(query_579931, "oauth_token", newJString(oauthToken))
  add(query_579931, "uploadType", newJString(uploadType))
  add(query_579931, "callback", newJString(callback))
  add(query_579931, "access_token", newJString(accessToken))
  add(query_579931, "key", newJString(key))
  add(path_579929, "projectId", newJString(projectId))
  add(query_579931, "$.xgafv", newJString(Xgafv))
  add(query_579931, "pageSize", newJInt(pageSize))
  add(query_579931, "prettyPrint", newJBool(prettyPrint))
  add(query_579931, "filter", newJString(filter))
  add(query_579931, "bearer_token", newJString(bearerToken))
  result = call_579928.call(path_579929, query_579931, nil, nil, nil)

var dataprocProjectsClustersList* = Call_DataprocProjectsClustersList_579677(
    name: "dataprocProjectsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters",
    validator: validate_DataprocProjectsClustersList_579678, base: "/",
    url: url_DataprocProjectsClustersList_579679, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersGet_579993 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsClustersGet_579995(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersGet_579994(path: JsonNode; query: JsonNode;
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
  var valid_579996 = path.getOrDefault("clusterName")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "clusterName", valid_579996
  var valid_579997 = path.getOrDefault("projectId")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "projectId", valid_579997
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
  var valid_579998 = query.getOrDefault("upload_protocol")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "upload_protocol", valid_579998
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("pp")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "pp", valid_580002
  var valid_580003 = query.getOrDefault("oauth_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "oauth_token", valid_580003
  var valid_580004 = query.getOrDefault("uploadType")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "uploadType", valid_580004
  var valid_580005 = query.getOrDefault("callback")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "callback", valid_580005
  var valid_580006 = query.getOrDefault("access_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "access_token", valid_580006
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("$.xgafv")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("1"))
  if valid_580008 != nil:
    section.add "$.xgafv", valid_580008
  var valid_580009 = query.getOrDefault("prettyPrint")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(true))
  if valid_580009 != nil:
    section.add "prettyPrint", valid_580009
  var valid_580010 = query.getOrDefault("bearer_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "bearer_token", valid_580010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580011: Call_DataprocProjectsClustersGet_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a cluster in a project.
  ## 
  let valid = call_580011.validator(path, query, header, formData, body)
  let scheme = call_580011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580011.url(scheme.get, call_580011.host, call_580011.base,
                         call_580011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580011, url, valid)

proc call*(call_580012: Call_DataprocProjectsClustersGet_579993;
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
  var path_580013 = newJObject()
  var query_580014 = newJObject()
  add(path_580013, "clusterName", newJString(clusterName))
  add(query_580014, "upload_protocol", newJString(uploadProtocol))
  add(query_580014, "fields", newJString(fields))
  add(query_580014, "quotaUser", newJString(quotaUser))
  add(query_580014, "alt", newJString(alt))
  add(query_580014, "pp", newJBool(pp))
  add(query_580014, "oauth_token", newJString(oauthToken))
  add(query_580014, "uploadType", newJString(uploadType))
  add(query_580014, "callback", newJString(callback))
  add(query_580014, "access_token", newJString(accessToken))
  add(query_580014, "key", newJString(key))
  add(path_580013, "projectId", newJString(projectId))
  add(query_580014, "$.xgafv", newJString(Xgafv))
  add(query_580014, "prettyPrint", newJBool(prettyPrint))
  add(query_580014, "bearer_token", newJString(bearerToken))
  result = call_580012.call(path_580013, query_580014, nil, nil, nil)

var dataprocProjectsClustersGet* = Call_DataprocProjectsClustersGet_579993(
    name: "dataprocProjectsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersGet_579994, base: "/",
    url: url_DataprocProjectsClustersGet_579995, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersPatch_580037 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsClustersPatch_580039(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersPatch_580038(path: JsonNode; query: JsonNode;
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
  var valid_580040 = path.getOrDefault("clusterName")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "clusterName", valid_580040
  var valid_580041 = path.getOrDefault("projectId")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "projectId", valid_580041
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
  var valid_580042 = query.getOrDefault("upload_protocol")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "upload_protocol", valid_580042
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("alt")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("json"))
  if valid_580045 != nil:
    section.add "alt", valid_580045
  var valid_580046 = query.getOrDefault("pp")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "pp", valid_580046
  var valid_580047 = query.getOrDefault("oauth_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "oauth_token", valid_580047
  var valid_580048 = query.getOrDefault("uploadType")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "uploadType", valid_580048
  var valid_580049 = query.getOrDefault("callback")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "callback", valid_580049
  var valid_580050 = query.getOrDefault("access_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "access_token", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("$.xgafv")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("1"))
  if valid_580052 != nil:
    section.add "$.xgafv", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  var valid_580054 = query.getOrDefault("updateMask")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "updateMask", valid_580054
  var valid_580055 = query.getOrDefault("bearer_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "bearer_token", valid_580055
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

proc call*(call_580057: Call_DataprocProjectsClustersPatch_580037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a cluster in a project.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_DataprocProjectsClustersPatch_580037;
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
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  var body_580061 = newJObject()
  add(path_580059, "clusterName", newJString(clusterName))
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "pp", newJBool(pp))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "key", newJString(key))
  add(path_580059, "projectId", newJString(projectId))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580061 = body
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  add(query_580060, "updateMask", newJString(updateMask))
  add(query_580060, "bearer_token", newJString(bearerToken))
  result = call_580058.call(path_580059, query_580060, nil, nil, body_580061)

var dataprocProjectsClustersPatch* = Call_DataprocProjectsClustersPatch_580037(
    name: "dataprocProjectsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersPatch_580038, base: "/",
    url: url_DataprocProjectsClustersPatch_580039, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDelete_580015 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsClustersDelete_580017(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersDelete_580016(path: JsonNode;
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
  var valid_580018 = path.getOrDefault("clusterName")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "clusterName", valid_580018
  var valid_580019 = path.getOrDefault("projectId")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "projectId", valid_580019
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
  var valid_580020 = query.getOrDefault("upload_protocol")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "upload_protocol", valid_580020
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("pp")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "pp", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("uploadType")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "uploadType", valid_580026
  var valid_580027 = query.getOrDefault("callback")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "callback", valid_580027
  var valid_580028 = query.getOrDefault("access_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "access_token", valid_580028
  var valid_580029 = query.getOrDefault("key")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "key", valid_580029
  var valid_580030 = query.getOrDefault("$.xgafv")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("1"))
  if valid_580030 != nil:
    section.add "$.xgafv", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(true))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  var valid_580032 = query.getOrDefault("bearer_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "bearer_token", valid_580032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580033: Call_DataprocProjectsClustersDelete_580015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a cluster in a project.
  ## 
  let valid = call_580033.validator(path, query, header, formData, body)
  let scheme = call_580033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580033.url(scheme.get, call_580033.host, call_580033.base,
                         call_580033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580033, url, valid)

proc call*(call_580034: Call_DataprocProjectsClustersDelete_580015;
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
  var path_580035 = newJObject()
  var query_580036 = newJObject()
  add(path_580035, "clusterName", newJString(clusterName))
  add(query_580036, "upload_protocol", newJString(uploadProtocol))
  add(query_580036, "fields", newJString(fields))
  add(query_580036, "quotaUser", newJString(quotaUser))
  add(query_580036, "alt", newJString(alt))
  add(query_580036, "pp", newJBool(pp))
  add(query_580036, "oauth_token", newJString(oauthToken))
  add(query_580036, "uploadType", newJString(uploadType))
  add(query_580036, "callback", newJString(callback))
  add(query_580036, "access_token", newJString(accessToken))
  add(query_580036, "key", newJString(key))
  add(path_580035, "projectId", newJString(projectId))
  add(query_580036, "$.xgafv", newJString(Xgafv))
  add(query_580036, "prettyPrint", newJBool(prettyPrint))
  add(query_580036, "bearer_token", newJString(bearerToken))
  result = call_580034.call(path_580035, query_580036, nil, nil, nil)

var dataprocProjectsClustersDelete* = Call_DataprocProjectsClustersDelete_580015(
    name: "dataprocProjectsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}",
    validator: validate_DataprocProjectsClustersDelete_580016, base: "/",
    url: url_DataprocProjectsClustersDelete_580017, schemes: {Scheme.Https})
type
  Call_DataprocProjectsClustersDiagnose_580062 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsClustersDiagnose_580064(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsClustersDiagnose_580063(path: JsonNode;
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
  var valid_580065 = path.getOrDefault("clusterName")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "clusterName", valid_580065
  var valid_580066 = path.getOrDefault("projectId")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "projectId", valid_580066
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
  var valid_580067 = query.getOrDefault("upload_protocol")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "upload_protocol", valid_580067
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("quotaUser")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "quotaUser", valid_580069
  var valid_580070 = query.getOrDefault("alt")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = newJString("json"))
  if valid_580070 != nil:
    section.add "alt", valid_580070
  var valid_580071 = query.getOrDefault("pp")
  valid_580071 = validateParameter(valid_580071, JBool, required = false,
                                 default = newJBool(true))
  if valid_580071 != nil:
    section.add "pp", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("uploadType")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "uploadType", valid_580073
  var valid_580074 = query.getOrDefault("callback")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "callback", valid_580074
  var valid_580075 = query.getOrDefault("access_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "access_token", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  var valid_580079 = query.getOrDefault("bearer_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "bearer_token", valid_580079
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

proc call*(call_580081: Call_DataprocProjectsClustersDiagnose_580062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets cluster diagnostic information. After the operation completes, the Operation.response field contains DiagnoseClusterOutputLocation.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_DataprocProjectsClustersDiagnose_580062;
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
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  var body_580085 = newJObject()
  add(path_580083, "clusterName", newJString(clusterName))
  add(query_580084, "upload_protocol", newJString(uploadProtocol))
  add(query_580084, "fields", newJString(fields))
  add(query_580084, "quotaUser", newJString(quotaUser))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "pp", newJBool(pp))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "uploadType", newJString(uploadType))
  add(query_580084, "callback", newJString(callback))
  add(query_580084, "access_token", newJString(accessToken))
  add(query_580084, "key", newJString(key))
  add(path_580083, "projectId", newJString(projectId))
  add(query_580084, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580085 = body
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  add(query_580084, "bearer_token", newJString(bearerToken))
  result = call_580082.call(path_580083, query_580084, nil, nil, body_580085)

var dataprocProjectsClustersDiagnose* = Call_DataprocProjectsClustersDiagnose_580062(
    name: "dataprocProjectsClustersDiagnose", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/clusters/{clusterName}:diagnose",
    validator: validate_DataprocProjectsClustersDiagnose_580063, base: "/",
    url: url_DataprocProjectsClustersDiagnose_580064, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsList_580086 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsJobsList_580088(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsList_580087(path: JsonNode; query: JsonNode;
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
  var valid_580089 = path.getOrDefault("projectId")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = nil)
  if valid_580089 != nil:
    section.add "projectId", valid_580089
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
  var valid_580090 = query.getOrDefault("upload_protocol")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "upload_protocol", valid_580090
  var valid_580091 = query.getOrDefault("fields")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "fields", valid_580091
  var valid_580092 = query.getOrDefault("pageToken")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "pageToken", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("pp")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "pp", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("uploadType")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "uploadType", valid_580097
  var valid_580098 = query.getOrDefault("callback")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "callback", valid_580098
  var valid_580099 = query.getOrDefault("access_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "access_token", valid_580099
  var valid_580100 = query.getOrDefault("jobStateMatcher")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("ALL"))
  if valid_580100 != nil:
    section.add "jobStateMatcher", valid_580100
  var valid_580101 = query.getOrDefault("key")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "key", valid_580101
  var valid_580102 = query.getOrDefault("$.xgafv")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("1"))
  if valid_580102 != nil:
    section.add "$.xgafv", valid_580102
  var valid_580103 = query.getOrDefault("pageSize")
  valid_580103 = validateParameter(valid_580103, JInt, required = false, default = nil)
  if valid_580103 != nil:
    section.add "pageSize", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
  var valid_580105 = query.getOrDefault("filter")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "filter", valid_580105
  var valid_580106 = query.getOrDefault("clusterName")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "clusterName", valid_580106
  var valid_580107 = query.getOrDefault("bearer_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "bearer_token", valid_580107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580108: Call_DataprocProjectsJobsList_580086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs in a project.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_DataprocProjectsJobsList_580086; projectId: string;
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
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  add(query_580111, "upload_protocol", newJString(uploadProtocol))
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "pageToken", newJString(pageToken))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "pp", newJBool(pp))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "uploadType", newJString(uploadType))
  add(query_580111, "callback", newJString(callback))
  add(query_580111, "access_token", newJString(accessToken))
  add(query_580111, "jobStateMatcher", newJString(jobStateMatcher))
  add(query_580111, "key", newJString(key))
  add(path_580110, "projectId", newJString(projectId))
  add(query_580111, "$.xgafv", newJString(Xgafv))
  add(query_580111, "pageSize", newJInt(pageSize))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  add(query_580111, "filter", newJString(filter))
  add(query_580111, "clusterName", newJString(clusterName))
  add(query_580111, "bearer_token", newJString(bearerToken))
  result = call_580109.call(path_580110, query_580111, nil, nil, nil)

var dataprocProjectsJobsList* = Call_DataprocProjectsJobsList_580086(
    name: "dataprocProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/projects/{projectId}/jobs",
    validator: validate_DataprocProjectsJobsList_580087, base: "/",
    url: url_DataprocProjectsJobsList_580088, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsGet_580112 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsJobsGet_580114(protocol: Scheme; host: string; base: string;
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

proc validate_DataprocProjectsJobsGet_580113(path: JsonNode; query: JsonNode;
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
  var valid_580115 = path.getOrDefault("jobId")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "jobId", valid_580115
  var valid_580116 = path.getOrDefault("projectId")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "projectId", valid_580116
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
  var valid_580117 = query.getOrDefault("upload_protocol")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "upload_protocol", valid_580117
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("pp")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "pp", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  var valid_580123 = query.getOrDefault("uploadType")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "uploadType", valid_580123
  var valid_580124 = query.getOrDefault("callback")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "callback", valid_580124
  var valid_580125 = query.getOrDefault("access_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "access_token", valid_580125
  var valid_580126 = query.getOrDefault("key")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "key", valid_580126
  var valid_580127 = query.getOrDefault("$.xgafv")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("1"))
  if valid_580127 != nil:
    section.add "$.xgafv", valid_580127
  var valid_580128 = query.getOrDefault("prettyPrint")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(true))
  if valid_580128 != nil:
    section.add "prettyPrint", valid_580128
  var valid_580129 = query.getOrDefault("bearer_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "bearer_token", valid_580129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580130: Call_DataprocProjectsJobsGet_580112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_580130.validator(path, query, header, formData, body)
  let scheme = call_580130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580130.url(scheme.get, call_580130.host, call_580130.base,
                         call_580130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580130, url, valid)

proc call*(call_580131: Call_DataprocProjectsJobsGet_580112; jobId: string;
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
  var path_580132 = newJObject()
  var query_580133 = newJObject()
  add(query_580133, "upload_protocol", newJString(uploadProtocol))
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "quotaUser", newJString(quotaUser))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "pp", newJBool(pp))
  add(path_580132, "jobId", newJString(jobId))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "uploadType", newJString(uploadType))
  add(query_580133, "callback", newJString(callback))
  add(query_580133, "access_token", newJString(accessToken))
  add(query_580133, "key", newJString(key))
  add(path_580132, "projectId", newJString(projectId))
  add(query_580133, "$.xgafv", newJString(Xgafv))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  add(query_580133, "bearer_token", newJString(bearerToken))
  result = call_580131.call(path_580132, query_580133, nil, nil, nil)

var dataprocProjectsJobsGet* = Call_DataprocProjectsJobsGet_580112(
    name: "dataprocProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsGet_580113, base: "/",
    url: url_DataprocProjectsJobsGet_580114, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsPatch_580156 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsJobsPatch_580158(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsPatch_580157(path: JsonNode; query: JsonNode;
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
  var valid_580159 = path.getOrDefault("jobId")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "jobId", valid_580159
  var valid_580160 = path.getOrDefault("projectId")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "projectId", valid_580160
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
  var valid_580161 = query.getOrDefault("upload_protocol")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "upload_protocol", valid_580161
  var valid_580162 = query.getOrDefault("fields")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "fields", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("pp")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "pp", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("uploadType")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "uploadType", valid_580167
  var valid_580168 = query.getOrDefault("callback")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "callback", valid_580168
  var valid_580169 = query.getOrDefault("access_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "access_token", valid_580169
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
  var valid_580173 = query.getOrDefault("updateMask")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "updateMask", valid_580173
  var valid_580174 = query.getOrDefault("bearer_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "bearer_token", valid_580174
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

proc call*(call_580176: Call_DataprocProjectsJobsPatch_580156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_DataprocProjectsJobsPatch_580156; jobId: string;
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
  var path_580178 = newJObject()
  var query_580179 = newJObject()
  var body_580180 = newJObject()
  add(query_580179, "upload_protocol", newJString(uploadProtocol))
  add(query_580179, "fields", newJString(fields))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "pp", newJBool(pp))
  add(path_580178, "jobId", newJString(jobId))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "uploadType", newJString(uploadType))
  add(query_580179, "callback", newJString(callback))
  add(query_580179, "access_token", newJString(accessToken))
  add(query_580179, "key", newJString(key))
  add(path_580178, "projectId", newJString(projectId))
  add(query_580179, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580180 = body
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  add(query_580179, "updateMask", newJString(updateMask))
  add(query_580179, "bearer_token", newJString(bearerToken))
  result = call_580177.call(path_580178, query_580179, nil, nil, body_580180)

var dataprocProjectsJobsPatch* = Call_DataprocProjectsJobsPatch_580156(
    name: "dataprocProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsPatch_580157, base: "/",
    url: url_DataprocProjectsJobsPatch_580158, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsDelete_580134 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsJobsDelete_580136(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsDelete_580135(path: JsonNode; query: JsonNode;
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
  var valid_580137 = path.getOrDefault("jobId")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "jobId", valid_580137
  var valid_580138 = path.getOrDefault("projectId")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "projectId", valid_580138
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
  var valid_580139 = query.getOrDefault("upload_protocol")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "upload_protocol", valid_580139
  var valid_580140 = query.getOrDefault("fields")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "fields", valid_580140
  var valid_580141 = query.getOrDefault("quotaUser")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "quotaUser", valid_580141
  var valid_580142 = query.getOrDefault("alt")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("json"))
  if valid_580142 != nil:
    section.add "alt", valid_580142
  var valid_580143 = query.getOrDefault("pp")
  valid_580143 = validateParameter(valid_580143, JBool, required = false,
                                 default = newJBool(true))
  if valid_580143 != nil:
    section.add "pp", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("uploadType")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "uploadType", valid_580145
  var valid_580146 = query.getOrDefault("callback")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "callback", valid_580146
  var valid_580147 = query.getOrDefault("access_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "access_token", valid_580147
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
  var valid_580151 = query.getOrDefault("bearer_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "bearer_token", valid_580151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580152: Call_DataprocProjectsJobsDelete_580134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_580152.validator(path, query, header, formData, body)
  let scheme = call_580152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580152.url(scheme.get, call_580152.host, call_580152.base,
                         call_580152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580152, url, valid)

proc call*(call_580153: Call_DataprocProjectsJobsDelete_580134; jobId: string;
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
  var path_580154 = newJObject()
  var query_580155 = newJObject()
  add(query_580155, "upload_protocol", newJString(uploadProtocol))
  add(query_580155, "fields", newJString(fields))
  add(query_580155, "quotaUser", newJString(quotaUser))
  add(query_580155, "alt", newJString(alt))
  add(query_580155, "pp", newJBool(pp))
  add(path_580154, "jobId", newJString(jobId))
  add(query_580155, "oauth_token", newJString(oauthToken))
  add(query_580155, "uploadType", newJString(uploadType))
  add(query_580155, "callback", newJString(callback))
  add(query_580155, "access_token", newJString(accessToken))
  add(query_580155, "key", newJString(key))
  add(path_580154, "projectId", newJString(projectId))
  add(query_580155, "$.xgafv", newJString(Xgafv))
  add(query_580155, "prettyPrint", newJBool(prettyPrint))
  add(query_580155, "bearer_token", newJString(bearerToken))
  result = call_580153.call(path_580154, query_580155, nil, nil, nil)

var dataprocProjectsJobsDelete* = Call_DataprocProjectsJobsDelete_580134(
    name: "dataprocProjectsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataprocProjectsJobsDelete_580135, base: "/",
    url: url_DataprocProjectsJobsDelete_580136, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsCancel_580181 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsJobsCancel_580183(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsCancel_580182(path: JsonNode; query: JsonNode;
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
  var valid_580184 = path.getOrDefault("jobId")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "jobId", valid_580184
  var valid_580185 = path.getOrDefault("projectId")
  valid_580185 = validateParameter(valid_580185, JString, required = true,
                                 default = nil)
  if valid_580185 != nil:
    section.add "projectId", valid_580185
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
  var valid_580186 = query.getOrDefault("upload_protocol")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "upload_protocol", valid_580186
  var valid_580187 = query.getOrDefault("fields")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "fields", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("alt")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = newJString("json"))
  if valid_580189 != nil:
    section.add "alt", valid_580189
  var valid_580190 = query.getOrDefault("pp")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "pp", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("uploadType")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "uploadType", valid_580192
  var valid_580193 = query.getOrDefault("callback")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "callback", valid_580193
  var valid_580194 = query.getOrDefault("access_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "access_token", valid_580194
  var valid_580195 = query.getOrDefault("key")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "key", valid_580195
  var valid_580196 = query.getOrDefault("$.xgafv")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("1"))
  if valid_580196 != nil:
    section.add "$.xgafv", valid_580196
  var valid_580197 = query.getOrDefault("prettyPrint")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(true))
  if valid_580197 != nil:
    section.add "prettyPrint", valid_580197
  var valid_580198 = query.getOrDefault("bearer_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "bearer_token", valid_580198
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

proc call*(call_580200: Call_DataprocProjectsJobsCancel_580181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call jobs.list or jobs.get.
  ## 
  let valid = call_580200.validator(path, query, header, formData, body)
  let scheme = call_580200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580200.url(scheme.get, call_580200.host, call_580200.base,
                         call_580200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580200, url, valid)

proc call*(call_580201: Call_DataprocProjectsJobsCancel_580181; jobId: string;
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
  var path_580202 = newJObject()
  var query_580203 = newJObject()
  var body_580204 = newJObject()
  add(query_580203, "upload_protocol", newJString(uploadProtocol))
  add(query_580203, "fields", newJString(fields))
  add(query_580203, "quotaUser", newJString(quotaUser))
  add(query_580203, "alt", newJString(alt))
  add(query_580203, "pp", newJBool(pp))
  add(path_580202, "jobId", newJString(jobId))
  add(query_580203, "oauth_token", newJString(oauthToken))
  add(query_580203, "uploadType", newJString(uploadType))
  add(query_580203, "callback", newJString(callback))
  add(query_580203, "access_token", newJString(accessToken))
  add(query_580203, "key", newJString(key))
  add(path_580202, "projectId", newJString(projectId))
  add(query_580203, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580204 = body
  add(query_580203, "prettyPrint", newJBool(prettyPrint))
  add(query_580203, "bearer_token", newJString(bearerToken))
  result = call_580201.call(path_580202, query_580203, nil, nil, body_580204)

var dataprocProjectsJobsCancel* = Call_DataprocProjectsJobsCancel_580181(
    name: "dataprocProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsJobsCancel_580182, base: "/",
    url: url_DataprocProjectsJobsCancel_580183, schemes: {Scheme.Https})
type
  Call_DataprocProjectsJobsSubmit_580205 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsJobsSubmit_580207(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsJobsSubmit_580206(path: JsonNode; query: JsonNode;
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
  var valid_580208 = path.getOrDefault("projectId")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "projectId", valid_580208
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
  var valid_580209 = query.getOrDefault("upload_protocol")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "upload_protocol", valid_580209
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("quotaUser")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "quotaUser", valid_580211
  var valid_580212 = query.getOrDefault("alt")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("json"))
  if valid_580212 != nil:
    section.add "alt", valid_580212
  var valid_580213 = query.getOrDefault("pp")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "pp", valid_580213
  var valid_580214 = query.getOrDefault("oauth_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "oauth_token", valid_580214
  var valid_580215 = query.getOrDefault("uploadType")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "uploadType", valid_580215
  var valid_580216 = query.getOrDefault("callback")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "callback", valid_580216
  var valid_580217 = query.getOrDefault("access_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "access_token", valid_580217
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("$.xgafv")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = newJString("1"))
  if valid_580219 != nil:
    section.add "$.xgafv", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  var valid_580221 = query.getOrDefault("bearer_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "bearer_token", valid_580221
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

proc call*(call_580223: Call_DataprocProjectsJobsSubmit_580205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_580223.validator(path, query, header, formData, body)
  let scheme = call_580223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580223.url(scheme.get, call_580223.host, call_580223.base,
                         call_580223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580223, url, valid)

proc call*(call_580224: Call_DataprocProjectsJobsSubmit_580205; projectId: string;
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
  var path_580225 = newJObject()
  var query_580226 = newJObject()
  var body_580227 = newJObject()
  add(query_580226, "upload_protocol", newJString(uploadProtocol))
  add(query_580226, "fields", newJString(fields))
  add(query_580226, "quotaUser", newJString(quotaUser))
  add(query_580226, "alt", newJString(alt))
  add(query_580226, "pp", newJBool(pp))
  add(query_580226, "oauth_token", newJString(oauthToken))
  add(query_580226, "uploadType", newJString(uploadType))
  add(query_580226, "callback", newJString(callback))
  add(query_580226, "access_token", newJString(accessToken))
  add(query_580226, "key", newJString(key))
  add(path_580225, "projectId", newJString(projectId))
  add(query_580226, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580227 = body
  add(query_580226, "prettyPrint", newJBool(prettyPrint))
  add(query_580226, "bearer_token", newJString(bearerToken))
  result = call_580224.call(path_580225, query_580226, nil, nil, body_580227)

var dataprocProjectsJobsSubmit* = Call_DataprocProjectsJobsSubmit_580205(
    name: "dataprocProjectsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1beta1/projects/{projectId}/jobs:submit",
    validator: validate_DataprocProjectsJobsSubmit_580206, base: "/",
    url: url_DataprocProjectsJobsSubmit_580207, schemes: {Scheme.Https})
type
  Call_DataprocOperationsGet_580228 = ref object of OpenApiRestCall_579408
proc url_DataprocOperationsGet_580230(protocol: Scheme; host: string; base: string;
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

proc validate_DataprocOperationsGet_580229(path: JsonNode; query: JsonNode;
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
  var valid_580231 = path.getOrDefault("name")
  valid_580231 = validateParameter(valid_580231, JString, required = true,
                                 default = nil)
  if valid_580231 != nil:
    section.add "name", valid_580231
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
  var valid_580232 = query.getOrDefault("upload_protocol")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "upload_protocol", valid_580232
  var valid_580233 = query.getOrDefault("fields")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "fields", valid_580233
  var valid_580234 = query.getOrDefault("quotaUser")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "quotaUser", valid_580234
  var valid_580235 = query.getOrDefault("alt")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = newJString("json"))
  if valid_580235 != nil:
    section.add "alt", valid_580235
  var valid_580236 = query.getOrDefault("pp")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "pp", valid_580236
  var valid_580237 = query.getOrDefault("oauth_token")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "oauth_token", valid_580237
  var valid_580238 = query.getOrDefault("uploadType")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "uploadType", valid_580238
  var valid_580239 = query.getOrDefault("callback")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "callback", valid_580239
  var valid_580240 = query.getOrDefault("access_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "access_token", valid_580240
  var valid_580241 = query.getOrDefault("key")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "key", valid_580241
  var valid_580242 = query.getOrDefault("$.xgafv")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = newJString("1"))
  if valid_580242 != nil:
    section.add "$.xgafv", valid_580242
  var valid_580243 = query.getOrDefault("prettyPrint")
  valid_580243 = validateParameter(valid_580243, JBool, required = false,
                                 default = newJBool(true))
  if valid_580243 != nil:
    section.add "prettyPrint", valid_580243
  var valid_580244 = query.getOrDefault("bearer_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "bearer_token", valid_580244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580245: Call_DataprocOperationsGet_580228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_580245.validator(path, query, header, formData, body)
  let scheme = call_580245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580245.url(scheme.get, call_580245.host, call_580245.base,
                         call_580245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580245, url, valid)

proc call*(call_580246: Call_DataprocOperationsGet_580228; name: string;
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
  var path_580247 = newJObject()
  var query_580248 = newJObject()
  add(query_580248, "upload_protocol", newJString(uploadProtocol))
  add(query_580248, "fields", newJString(fields))
  add(query_580248, "quotaUser", newJString(quotaUser))
  add(path_580247, "name", newJString(name))
  add(query_580248, "alt", newJString(alt))
  add(query_580248, "pp", newJBool(pp))
  add(query_580248, "oauth_token", newJString(oauthToken))
  add(query_580248, "uploadType", newJString(uploadType))
  add(query_580248, "callback", newJString(callback))
  add(query_580248, "access_token", newJString(accessToken))
  add(query_580248, "key", newJString(key))
  add(query_580248, "$.xgafv", newJString(Xgafv))
  add(query_580248, "prettyPrint", newJBool(prettyPrint))
  add(query_580248, "bearer_token", newJString(bearerToken))
  result = call_580246.call(path_580247, query_580248, nil, nil, nil)

var dataprocOperationsGet* = Call_DataprocOperationsGet_580228(
    name: "dataprocOperationsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsGet_580229, base: "/",
    url: url_DataprocOperationsGet_580230, schemes: {Scheme.Https})
type
  Call_DataprocOperationsDelete_580249 = ref object of OpenApiRestCall_579408
proc url_DataprocOperationsDelete_580251(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsDelete_580250(path: JsonNode; query: JsonNode;
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
  var valid_580252 = path.getOrDefault("name")
  valid_580252 = validateParameter(valid_580252, JString, required = true,
                                 default = nil)
  if valid_580252 != nil:
    section.add "name", valid_580252
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
  var valid_580253 = query.getOrDefault("upload_protocol")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "upload_protocol", valid_580253
  var valid_580254 = query.getOrDefault("fields")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "fields", valid_580254
  var valid_580255 = query.getOrDefault("quotaUser")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "quotaUser", valid_580255
  var valid_580256 = query.getOrDefault("alt")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = newJString("json"))
  if valid_580256 != nil:
    section.add "alt", valid_580256
  var valid_580257 = query.getOrDefault("pp")
  valid_580257 = validateParameter(valid_580257, JBool, required = false,
                                 default = newJBool(true))
  if valid_580257 != nil:
    section.add "pp", valid_580257
  var valid_580258 = query.getOrDefault("oauth_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "oauth_token", valid_580258
  var valid_580259 = query.getOrDefault("uploadType")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "uploadType", valid_580259
  var valid_580260 = query.getOrDefault("callback")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "callback", valid_580260
  var valid_580261 = query.getOrDefault("access_token")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "access_token", valid_580261
  var valid_580262 = query.getOrDefault("key")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "key", valid_580262
  var valid_580263 = query.getOrDefault("$.xgafv")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("1"))
  if valid_580263 != nil:
    section.add "$.xgafv", valid_580263
  var valid_580264 = query.getOrDefault("prettyPrint")
  valid_580264 = validateParameter(valid_580264, JBool, required = false,
                                 default = newJBool(true))
  if valid_580264 != nil:
    section.add "prettyPrint", valid_580264
  var valid_580265 = query.getOrDefault("bearer_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "bearer_token", valid_580265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580266: Call_DataprocOperationsDelete_580249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is no longer interested in the operation result. It does not cancel the operation. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  let valid = call_580266.validator(path, query, header, formData, body)
  let scheme = call_580266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580266.url(scheme.get, call_580266.host, call_580266.base,
                         call_580266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580266, url, valid)

proc call*(call_580267: Call_DataprocOperationsDelete_580249; name: string;
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
  var path_580268 = newJObject()
  var query_580269 = newJObject()
  add(query_580269, "upload_protocol", newJString(uploadProtocol))
  add(query_580269, "fields", newJString(fields))
  add(query_580269, "quotaUser", newJString(quotaUser))
  add(path_580268, "name", newJString(name))
  add(query_580269, "alt", newJString(alt))
  add(query_580269, "pp", newJBool(pp))
  add(query_580269, "oauth_token", newJString(oauthToken))
  add(query_580269, "uploadType", newJString(uploadType))
  add(query_580269, "callback", newJString(callback))
  add(query_580269, "access_token", newJString(accessToken))
  add(query_580269, "key", newJString(key))
  add(query_580269, "$.xgafv", newJString(Xgafv))
  add(query_580269, "prettyPrint", newJBool(prettyPrint))
  add(query_580269, "bearer_token", newJString(bearerToken))
  result = call_580267.call(path_580268, query_580269, nil, nil, nil)

var dataprocOperationsDelete* = Call_DataprocOperationsDelete_580249(
    name: "dataprocOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_DataprocOperationsDelete_580250, base: "/",
    url: url_DataprocOperationsDelete_580251, schemes: {Scheme.Https})
type
  Call_DataprocOperationsCancel_580270 = ref object of OpenApiRestCall_579408
proc url_DataprocOperationsCancel_580272(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsCancel_580271(path: JsonNode; query: JsonNode;
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
  var valid_580273 = path.getOrDefault("name")
  valid_580273 = validateParameter(valid_580273, JString, required = true,
                                 default = nil)
  if valid_580273 != nil:
    section.add "name", valid_580273
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
  var valid_580274 = query.getOrDefault("upload_protocol")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "upload_protocol", valid_580274
  var valid_580275 = query.getOrDefault("fields")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "fields", valid_580275
  var valid_580276 = query.getOrDefault("quotaUser")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "quotaUser", valid_580276
  var valid_580277 = query.getOrDefault("alt")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = newJString("json"))
  if valid_580277 != nil:
    section.add "alt", valid_580277
  var valid_580278 = query.getOrDefault("pp")
  valid_580278 = validateParameter(valid_580278, JBool, required = false,
                                 default = newJBool(true))
  if valid_580278 != nil:
    section.add "pp", valid_580278
  var valid_580279 = query.getOrDefault("oauth_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "oauth_token", valid_580279
  var valid_580280 = query.getOrDefault("uploadType")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "uploadType", valid_580280
  var valid_580281 = query.getOrDefault("callback")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "callback", valid_580281
  var valid_580282 = query.getOrDefault("access_token")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "access_token", valid_580282
  var valid_580283 = query.getOrDefault("key")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "key", valid_580283
  var valid_580284 = query.getOrDefault("$.xgafv")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("1"))
  if valid_580284 != nil:
    section.add "$.xgafv", valid_580284
  var valid_580285 = query.getOrDefault("prettyPrint")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(true))
  if valid_580285 != nil:
    section.add "prettyPrint", valid_580285
  var valid_580286 = query.getOrDefault("bearer_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "bearer_token", valid_580286
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

proc call*(call_580288: Call_DataprocOperationsCancel_580270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use operations.get or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation.
  ## 
  let valid = call_580288.validator(path, query, header, formData, body)
  let scheme = call_580288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580288.url(scheme.get, call_580288.host, call_580288.base,
                         call_580288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580288, url, valid)

proc call*(call_580289: Call_DataprocOperationsCancel_580270; name: string;
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
  var path_580290 = newJObject()
  var query_580291 = newJObject()
  var body_580292 = newJObject()
  add(query_580291, "upload_protocol", newJString(uploadProtocol))
  add(query_580291, "fields", newJString(fields))
  add(query_580291, "quotaUser", newJString(quotaUser))
  add(path_580290, "name", newJString(name))
  add(query_580291, "alt", newJString(alt))
  add(query_580291, "pp", newJBool(pp))
  add(query_580291, "oauth_token", newJString(oauthToken))
  add(query_580291, "uploadType", newJString(uploadType))
  add(query_580291, "callback", newJString(callback))
  add(query_580291, "access_token", newJString(accessToken))
  add(query_580291, "key", newJString(key))
  add(query_580291, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580292 = body
  add(query_580291, "prettyPrint", newJBool(prettyPrint))
  add(query_580291, "bearer_token", newJString(bearerToken))
  result = call_580289.call(path_580290, query_580291, nil, nil, body_580292)

var dataprocOperationsCancel* = Call_DataprocOperationsCancel_580270(
    name: "dataprocOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_DataprocOperationsCancel_580271, base: "/",
    url: url_DataprocOperationsCancel_580272, schemes: {Scheme.Https})
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
