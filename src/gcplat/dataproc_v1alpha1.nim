
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
  Call_DataprocProjectsRegionsClustersCreate_579971 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsClustersCreate_579973(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersCreate_579972(path: JsonNode;
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
  var valid_579974 = path.getOrDefault("projectId")
  valid_579974 = validateParameter(valid_579974, JString, required = true,
                                 default = nil)
  if valid_579974 != nil:
    section.add "projectId", valid_579974
  var valid_579975 = path.getOrDefault("region")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "region", valid_579975
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
  var valid_579976 = query.getOrDefault("upload_protocol")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "upload_protocol", valid_579976
  var valid_579977 = query.getOrDefault("fields")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "fields", valid_579977
  var valid_579978 = query.getOrDefault("quotaUser")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "quotaUser", valid_579978
  var valid_579979 = query.getOrDefault("alt")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("json"))
  if valid_579979 != nil:
    section.add "alt", valid_579979
  var valid_579980 = query.getOrDefault("pp")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "pp", valid_579980
  var valid_579981 = query.getOrDefault("oauth_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "oauth_token", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("callback")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "callback", valid_579983
  var valid_579984 = query.getOrDefault("access_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "access_token", valid_579984
  var valid_579985 = query.getOrDefault("key")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "key", valid_579985
  var valid_579986 = query.getOrDefault("$.xgafv")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("1"))
  if valid_579986 != nil:
    section.add "$.xgafv", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
  var valid_579988 = query.getOrDefault("bearer_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "bearer_token", valid_579988
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

proc call*(call_579990: Call_DataprocProjectsRegionsClustersCreate_579971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to create a cluster in a project.
  ## 
  let valid = call_579990.validator(path, query, header, formData, body)
  let scheme = call_579990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579990.url(scheme.get, call_579990.host, call_579990.base,
                         call_579990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579990, url, valid)

proc call*(call_579991: Call_DataprocProjectsRegionsClustersCreate_579971;
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
  var path_579992 = newJObject()
  var query_579993 = newJObject()
  var body_579994 = newJObject()
  add(query_579993, "upload_protocol", newJString(uploadProtocol))
  add(query_579993, "fields", newJString(fields))
  add(query_579993, "quotaUser", newJString(quotaUser))
  add(query_579993, "alt", newJString(alt))
  add(query_579993, "pp", newJBool(pp))
  add(query_579993, "oauth_token", newJString(oauthToken))
  add(query_579993, "uploadType", newJString(uploadType))
  add(query_579993, "callback", newJString(callback))
  add(query_579993, "access_token", newJString(accessToken))
  add(query_579993, "key", newJString(key))
  add(path_579992, "projectId", newJString(projectId))
  add(query_579993, "$.xgafv", newJString(Xgafv))
  add(path_579992, "region", newJString(region))
  if body != nil:
    body_579994 = body
  add(query_579993, "prettyPrint", newJBool(prettyPrint))
  add(query_579993, "bearer_token", newJString(bearerToken))
  result = call_579991.call(path_579992, query_579993, nil, nil, body_579994)

var dataprocProjectsRegionsClustersCreate* = Call_DataprocProjectsRegionsClustersCreate_579971(
    name: "dataprocProjectsRegionsClustersCreate", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersCreate_579972, base: "/",
    url: url_DataprocProjectsRegionsClustersCreate_579973, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersList_579677 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsClustersList_579679(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersList_579678(path: JsonNode;
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
  var valid_579805 = path.getOrDefault("projectId")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "projectId", valid_579805
  var valid_579806 = path.getOrDefault("region")
  valid_579806 = validateParameter(valid_579806, JString, required = true,
                                 default = nil)
  if valid_579806 != nil:
    section.add "region", valid_579806
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
  var valid_579807 = query.getOrDefault("upload_protocol")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "upload_protocol", valid_579807
  var valid_579808 = query.getOrDefault("fields")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "fields", valid_579808
  var valid_579809 = query.getOrDefault("pageToken")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "pageToken", valid_579809
  var valid_579810 = query.getOrDefault("quotaUser")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "quotaUser", valid_579810
  var valid_579824 = query.getOrDefault("alt")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = newJString("json"))
  if valid_579824 != nil:
    section.add "alt", valid_579824
  var valid_579825 = query.getOrDefault("pp")
  valid_579825 = validateParameter(valid_579825, JBool, required = false,
                                 default = newJBool(true))
  if valid_579825 != nil:
    section.add "pp", valid_579825
  var valid_579826 = query.getOrDefault("oauth_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "oauth_token", valid_579826
  var valid_579827 = query.getOrDefault("uploadType")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "uploadType", valid_579827
  var valid_579828 = query.getOrDefault("callback")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "callback", valid_579828
  var valid_579829 = query.getOrDefault("access_token")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "access_token", valid_579829
  var valid_579830 = query.getOrDefault("key")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "key", valid_579830
  var valid_579831 = query.getOrDefault("$.xgafv")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = newJString("1"))
  if valid_579831 != nil:
    section.add "$.xgafv", valid_579831
  var valid_579832 = query.getOrDefault("pageSize")
  valid_579832 = validateParameter(valid_579832, JInt, required = false, default = nil)
  if valid_579832 != nil:
    section.add "pageSize", valid_579832
  var valid_579833 = query.getOrDefault("prettyPrint")
  valid_579833 = validateParameter(valid_579833, JBool, required = false,
                                 default = newJBool(true))
  if valid_579833 != nil:
    section.add "prettyPrint", valid_579833
  var valid_579834 = query.getOrDefault("filter")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "filter", valid_579834
  var valid_579835 = query.getOrDefault("bearer_token")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "bearer_token", valid_579835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579858: Call_DataprocProjectsRegionsClustersList_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request a list of all regions/{region}/clusters in a project.
  ## 
  let valid = call_579858.validator(path, query, header, formData, body)
  let scheme = call_579858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579858.url(scheme.get, call_579858.host, call_579858.base,
                         call_579858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579858, url, valid)

proc call*(call_579929: Call_DataprocProjectsRegionsClustersList_579677;
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
  var path_579930 = newJObject()
  var query_579932 = newJObject()
  add(query_579932, "upload_protocol", newJString(uploadProtocol))
  add(query_579932, "fields", newJString(fields))
  add(query_579932, "pageToken", newJString(pageToken))
  add(query_579932, "quotaUser", newJString(quotaUser))
  add(query_579932, "alt", newJString(alt))
  add(query_579932, "pp", newJBool(pp))
  add(query_579932, "oauth_token", newJString(oauthToken))
  add(query_579932, "uploadType", newJString(uploadType))
  add(query_579932, "callback", newJString(callback))
  add(query_579932, "access_token", newJString(accessToken))
  add(query_579932, "key", newJString(key))
  add(path_579930, "projectId", newJString(projectId))
  add(query_579932, "$.xgafv", newJString(Xgafv))
  add(path_579930, "region", newJString(region))
  add(query_579932, "pageSize", newJInt(pageSize))
  add(query_579932, "prettyPrint", newJBool(prettyPrint))
  add(query_579932, "filter", newJString(filter))
  add(query_579932, "bearer_token", newJString(bearerToken))
  result = call_579929.call(path_579930, query_579932, nil, nil, nil)

var dataprocProjectsRegionsClustersList* = Call_DataprocProjectsRegionsClustersList_579677(
    name: "dataprocProjectsRegionsClustersList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters",
    validator: validate_DataprocProjectsRegionsClustersList_579678, base: "/",
    url: url_DataprocProjectsRegionsClustersList_579679, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersGet_579995 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsClustersGet_579997(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsClustersGet_579996(path: JsonNode;
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
  var valid_579998 = path.getOrDefault("clusterName")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "clusterName", valid_579998
  var valid_579999 = path.getOrDefault("projectId")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = nil)
  if valid_579999 != nil:
    section.add "projectId", valid_579999
  var valid_580000 = path.getOrDefault("region")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "region", valid_580000
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
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("pp")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "pp", valid_580005
  var valid_580006 = query.getOrDefault("oauth_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "oauth_token", valid_580006
  var valid_580007 = query.getOrDefault("uploadType")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "uploadType", valid_580007
  var valid_580008 = query.getOrDefault("callback")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "callback", valid_580008
  var valid_580009 = query.getOrDefault("access_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "access_token", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("$.xgafv")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("1"))
  if valid_580011 != nil:
    section.add "$.xgafv", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  var valid_580013 = query.getOrDefault("bearer_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "bearer_token", valid_580013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580014: Call_DataprocProjectsRegionsClustersGet_579995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to get the resource representation for a cluster in a project.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_DataprocProjectsRegionsClustersGet_579995;
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
  var path_580016 = newJObject()
  var query_580017 = newJObject()
  add(path_580016, "clusterName", newJString(clusterName))
  add(query_580017, "upload_protocol", newJString(uploadProtocol))
  add(query_580017, "fields", newJString(fields))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "pp", newJBool(pp))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(query_580017, "uploadType", newJString(uploadType))
  add(query_580017, "callback", newJString(callback))
  add(query_580017, "access_token", newJString(accessToken))
  add(query_580017, "key", newJString(key))
  add(path_580016, "projectId", newJString(projectId))
  add(query_580017, "$.xgafv", newJString(Xgafv))
  add(path_580016, "region", newJString(region))
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  add(query_580017, "bearer_token", newJString(bearerToken))
  result = call_580015.call(path_580016, query_580017, nil, nil, nil)

var dataprocProjectsRegionsClustersGet* = Call_DataprocProjectsRegionsClustersGet_579995(
    name: "dataprocProjectsRegionsClustersGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersGet_579996, base: "/",
    url: url_DataprocProjectsRegionsClustersGet_579997, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersPatch_580041 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsClustersPatch_580043(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersPatch_580042(path: JsonNode;
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
  var valid_580044 = path.getOrDefault("clusterName")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "clusterName", valid_580044
  var valid_580045 = path.getOrDefault("projectId")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "projectId", valid_580045
  var valid_580046 = path.getOrDefault("region")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "region", valid_580046
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
  var valid_580047 = query.getOrDefault("upload_protocol")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "upload_protocol", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("quotaUser")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "quotaUser", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("pp")
  valid_580051 = validateParameter(valid_580051, JBool, required = false,
                                 default = newJBool(true))
  if valid_580051 != nil:
    section.add "pp", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("uploadType")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "uploadType", valid_580053
  var valid_580054 = query.getOrDefault("callback")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "callback", valid_580054
  var valid_580055 = query.getOrDefault("access_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "access_token", valid_580055
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("$.xgafv")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("1"))
  if valid_580057 != nil:
    section.add "$.xgafv", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  var valid_580059 = query.getOrDefault("updateMask")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "updateMask", valid_580059
  var valid_580060 = query.getOrDefault("bearer_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "bearer_token", valid_580060
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

proc call*(call_580062: Call_DataprocProjectsRegionsClustersPatch_580041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to update a cluster in a project.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_DataprocProjectsRegionsClustersPatch_580041;
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
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  var body_580066 = newJObject()
  add(path_580064, "clusterName", newJString(clusterName))
  add(query_580065, "upload_protocol", newJString(uploadProtocol))
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "pp", newJBool(pp))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "uploadType", newJString(uploadType))
  add(query_580065, "callback", newJString(callback))
  add(query_580065, "access_token", newJString(accessToken))
  add(query_580065, "key", newJString(key))
  add(path_580064, "projectId", newJString(projectId))
  add(query_580065, "$.xgafv", newJString(Xgafv))
  add(path_580064, "region", newJString(region))
  if body != nil:
    body_580066 = body
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "updateMask", newJString(updateMask))
  add(query_580065, "bearer_token", newJString(bearerToken))
  result = call_580063.call(path_580064, query_580065, nil, nil, body_580066)

var dataprocProjectsRegionsClustersPatch* = Call_DataprocProjectsRegionsClustersPatch_580041(
    name: "dataprocProjectsRegionsClustersPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersPatch_580042, base: "/",
    url: url_DataprocProjectsRegionsClustersPatch_580043, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsClustersDelete_580018 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsClustersDelete_580020(protocol: Scheme;
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

proc validate_DataprocProjectsRegionsClustersDelete_580019(path: JsonNode;
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
  var valid_580021 = path.getOrDefault("clusterName")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "clusterName", valid_580021
  var valid_580022 = path.getOrDefault("projectId")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "projectId", valid_580022
  var valid_580023 = path.getOrDefault("region")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "region", valid_580023
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
  var valid_580024 = query.getOrDefault("upload_protocol")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "upload_protocol", valid_580024
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("pp")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "pp", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("callback")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "callback", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("prettyPrint")
  valid_580035 = validateParameter(valid_580035, JBool, required = false,
                                 default = newJBool(true))
  if valid_580035 != nil:
    section.add "prettyPrint", valid_580035
  var valid_580036 = query.getOrDefault("bearer_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "bearer_token", valid_580036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580037: Call_DataprocProjectsRegionsClustersDelete_580018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request to delete a cluster in a project.
  ## 
  let valid = call_580037.validator(path, query, header, formData, body)
  let scheme = call_580037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580037.url(scheme.get, call_580037.host, call_580037.base,
                         call_580037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580037, url, valid)

proc call*(call_580038: Call_DataprocProjectsRegionsClustersDelete_580018;
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
  var path_580039 = newJObject()
  var query_580040 = newJObject()
  add(path_580039, "clusterName", newJString(clusterName))
  add(query_580040, "upload_protocol", newJString(uploadProtocol))
  add(query_580040, "fields", newJString(fields))
  add(query_580040, "quotaUser", newJString(quotaUser))
  add(query_580040, "alt", newJString(alt))
  add(query_580040, "pp", newJBool(pp))
  add(query_580040, "oauth_token", newJString(oauthToken))
  add(query_580040, "uploadType", newJString(uploadType))
  add(query_580040, "callback", newJString(callback))
  add(query_580040, "access_token", newJString(accessToken))
  add(query_580040, "key", newJString(key))
  add(path_580039, "projectId", newJString(projectId))
  add(query_580040, "$.xgafv", newJString(Xgafv))
  add(path_580039, "region", newJString(region))
  add(query_580040, "prettyPrint", newJBool(prettyPrint))
  add(query_580040, "bearer_token", newJString(bearerToken))
  result = call_580038.call(path_580039, query_580040, nil, nil, nil)

var dataprocProjectsRegionsClustersDelete* = Call_DataprocProjectsRegionsClustersDelete_580018(
    name: "dataprocProjectsRegionsClustersDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/clusters/{clusterName}",
    validator: validate_DataprocProjectsRegionsClustersDelete_580019, base: "/",
    url: url_DataprocProjectsRegionsClustersDelete_580020, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsGet_580067 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsJobsGet_580069(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsGet_580068(path: JsonNode;
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
  var valid_580070 = path.getOrDefault("jobId")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "jobId", valid_580070
  var valid_580071 = path.getOrDefault("projectId")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "projectId", valid_580071
  var valid_580072 = path.getOrDefault("region")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "region", valid_580072
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
  var valid_580073 = query.getOrDefault("upload_protocol")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "upload_protocol", valid_580073
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("pp")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "pp", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("callback")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "callback", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("key")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "key", valid_580082
  var valid_580083 = query.getOrDefault("$.xgafv")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("1"))
  if valid_580083 != nil:
    section.add "$.xgafv", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  var valid_580085 = query.getOrDefault("bearer_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "bearer_token", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_DataprocProjectsRegionsJobsGet_580067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the resource representation for a job in a project.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_DataprocProjectsRegionsJobsGet_580067; jobId: string;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "pp", newJBool(pp))
  add(path_580088, "jobId", newJString(jobId))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "callback", newJString(callback))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "key", newJString(key))
  add(path_580088, "projectId", newJString(projectId))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  add(path_580088, "region", newJString(region))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "bearer_token", newJString(bearerToken))
  result = call_580087.call(path_580088, query_580089, nil, nil, nil)

var dataprocProjectsRegionsJobsGet* = Call_DataprocProjectsRegionsJobsGet_580067(
    name: "dataprocProjectsRegionsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsGet_580068, base: "/",
    url: url_DataprocProjectsRegionsJobsGet_580069, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsPatch_580113 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsJobsPatch_580115(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsPatch_580114(path: JsonNode;
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
  var valid_580116 = path.getOrDefault("jobId")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "jobId", valid_580116
  var valid_580117 = path.getOrDefault("projectId")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "projectId", valid_580117
  var valid_580118 = path.getOrDefault("region")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "region", valid_580118
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
  var valid_580119 = query.getOrDefault("upload_protocol")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "upload_protocol", valid_580119
  var valid_580120 = query.getOrDefault("fields")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "fields", valid_580120
  var valid_580121 = query.getOrDefault("quotaUser")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "quotaUser", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("pp")
  valid_580123 = validateParameter(valid_580123, JBool, required = false,
                                 default = newJBool(true))
  if valid_580123 != nil:
    section.add "pp", valid_580123
  var valid_580124 = query.getOrDefault("oauth_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "oauth_token", valid_580124
  var valid_580125 = query.getOrDefault("uploadType")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "uploadType", valid_580125
  var valid_580126 = query.getOrDefault("callback")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "callback", valid_580126
  var valid_580127 = query.getOrDefault("access_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "access_token", valid_580127
  var valid_580128 = query.getOrDefault("key")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "key", valid_580128
  var valid_580129 = query.getOrDefault("$.xgafv")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("1"))
  if valid_580129 != nil:
    section.add "$.xgafv", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
  var valid_580131 = query.getOrDefault("updateMask")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "updateMask", valid_580131
  var valid_580132 = query.getOrDefault("bearer_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "bearer_token", valid_580132
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

proc call*(call_580134: Call_DataprocProjectsRegionsJobsPatch_580113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job in a project.
  ## 
  let valid = call_580134.validator(path, query, header, formData, body)
  let scheme = call_580134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580134.url(scheme.get, call_580134.host, call_580134.base,
                         call_580134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580134, url, valid)

proc call*(call_580135: Call_DataprocProjectsRegionsJobsPatch_580113;
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
  var path_580136 = newJObject()
  var query_580137 = newJObject()
  var body_580138 = newJObject()
  add(query_580137, "upload_protocol", newJString(uploadProtocol))
  add(query_580137, "fields", newJString(fields))
  add(query_580137, "quotaUser", newJString(quotaUser))
  add(query_580137, "alt", newJString(alt))
  add(query_580137, "pp", newJBool(pp))
  add(path_580136, "jobId", newJString(jobId))
  add(query_580137, "oauth_token", newJString(oauthToken))
  add(query_580137, "uploadType", newJString(uploadType))
  add(query_580137, "callback", newJString(callback))
  add(query_580137, "access_token", newJString(accessToken))
  add(query_580137, "key", newJString(key))
  add(path_580136, "projectId", newJString(projectId))
  add(query_580137, "$.xgafv", newJString(Xgafv))
  add(path_580136, "region", newJString(region))
  if body != nil:
    body_580138 = body
  add(query_580137, "prettyPrint", newJBool(prettyPrint))
  add(query_580137, "updateMask", newJString(updateMask))
  add(query_580137, "bearer_token", newJString(bearerToken))
  result = call_580135.call(path_580136, query_580137, nil, nil, body_580138)

var dataprocProjectsRegionsJobsPatch* = Call_DataprocProjectsRegionsJobsPatch_580113(
    name: "dataprocProjectsRegionsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsPatch_580114, base: "/",
    url: url_DataprocProjectsRegionsJobsPatch_580115, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsDelete_580090 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsJobsDelete_580092(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsDelete_580091(path: JsonNode;
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
  var valid_580093 = path.getOrDefault("jobId")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "jobId", valid_580093
  var valid_580094 = path.getOrDefault("projectId")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "projectId", valid_580094
  var valid_580095 = path.getOrDefault("region")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "region", valid_580095
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
  var valid_580096 = query.getOrDefault("upload_protocol")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "upload_protocol", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("pp")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "pp", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("uploadType")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "uploadType", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("$.xgafv")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("1"))
  if valid_580106 != nil:
    section.add "$.xgafv", valid_580106
  var valid_580107 = query.getOrDefault("prettyPrint")
  valid_580107 = validateParameter(valid_580107, JBool, required = false,
                                 default = newJBool(true))
  if valid_580107 != nil:
    section.add "prettyPrint", valid_580107
  var valid_580108 = query.getOrDefault("bearer_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "bearer_token", valid_580108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580109: Call_DataprocProjectsRegionsJobsDelete_580090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the job from the project. If the job is active, the delete fails, and the response returns FAILED_PRECONDITION.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_DataprocProjectsRegionsJobsDelete_580090;
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
  var path_580111 = newJObject()
  var query_580112 = newJObject()
  add(query_580112, "upload_protocol", newJString(uploadProtocol))
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "pp", newJBool(pp))
  add(path_580111, "jobId", newJString(jobId))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "uploadType", newJString(uploadType))
  add(query_580112, "callback", newJString(callback))
  add(query_580112, "access_token", newJString(accessToken))
  add(query_580112, "key", newJString(key))
  add(path_580111, "projectId", newJString(projectId))
  add(query_580112, "$.xgafv", newJString(Xgafv))
  add(path_580111, "region", newJString(region))
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  add(query_580112, "bearer_token", newJString(bearerToken))
  result = call_580110.call(path_580111, query_580112, nil, nil, nil)

var dataprocProjectsRegionsJobsDelete* = Call_DataprocProjectsRegionsJobsDelete_580090(
    name: "dataprocProjectsRegionsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}",
    validator: validate_DataprocProjectsRegionsJobsDelete_580091, base: "/",
    url: url_DataprocProjectsRegionsJobsDelete_580092, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsCancel_580139 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsJobsCancel_580141(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsCancel_580140(path: JsonNode;
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
  var valid_580142 = path.getOrDefault("jobId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "jobId", valid_580142
  var valid_580143 = path.getOrDefault("projectId")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "projectId", valid_580143
  var valid_580144 = path.getOrDefault("region")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "region", valid_580144
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
  var valid_580145 = query.getOrDefault("upload_protocol")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "upload_protocol", valid_580145
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("pp")
  valid_580149 = validateParameter(valid_580149, JBool, required = false,
                                 default = newJBool(true))
  if valid_580149 != nil:
    section.add "pp", valid_580149
  var valid_580150 = query.getOrDefault("oauth_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "oauth_token", valid_580150
  var valid_580151 = query.getOrDefault("uploadType")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "uploadType", valid_580151
  var valid_580152 = query.getOrDefault("callback")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "callback", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("$.xgafv")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("1"))
  if valid_580155 != nil:
    section.add "$.xgafv", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
  var valid_580157 = query.getOrDefault("bearer_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "bearer_token", valid_580157
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

proc call*(call_580159: Call_DataprocProjectsRegionsJobsCancel_580139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a job cancellation request. To access the job resource after cancellation, call regions/{region}/jobs:list or regions/{region}/jobs:get.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_DataprocProjectsRegionsJobsCancel_580139;
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
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(query_580162, "upload_protocol", newJString(uploadProtocol))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "pp", newJBool(pp))
  add(path_580161, "jobId", newJString(jobId))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "uploadType", newJString(uploadType))
  add(query_580162, "callback", newJString(callback))
  add(query_580162, "access_token", newJString(accessToken))
  add(query_580162, "key", newJString(key))
  add(path_580161, "projectId", newJString(projectId))
  add(query_580162, "$.xgafv", newJString(Xgafv))
  add(path_580161, "region", newJString(region))
  if body != nil:
    body_580163 = body
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  add(query_580162, "bearer_token", newJString(bearerToken))
  result = call_580160.call(path_580161, query_580162, nil, nil, body_580163)

var dataprocProjectsRegionsJobsCancel* = Call_DataprocProjectsRegionsJobsCancel_580139(
    name: "dataprocProjectsRegionsJobsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs/{jobId}:cancel",
    validator: validate_DataprocProjectsRegionsJobsCancel_580140, base: "/",
    url: url_DataprocProjectsRegionsJobsCancel_580141, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsList_580164 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsJobsList_580166(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsList_580165(path: JsonNode;
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
  var valid_580167 = path.getOrDefault("projectId")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "projectId", valid_580167
  var valid_580168 = path.getOrDefault("region")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "region", valid_580168
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
  var valid_580169 = query.getOrDefault("upload_protocol")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "upload_protocol", valid_580169
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("alt")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("json"))
  if valid_580172 != nil:
    section.add "alt", valid_580172
  var valid_580173 = query.getOrDefault("pp")
  valid_580173 = validateParameter(valid_580173, JBool, required = false,
                                 default = newJBool(true))
  if valid_580173 != nil:
    section.add "pp", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("uploadType")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "uploadType", valid_580175
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
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
  var valid_580181 = query.getOrDefault("bearer_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "bearer_token", valid_580181
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

proc call*(call_580183: Call_DataprocProjectsRegionsJobsList_580164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists regions/{region}/jobs in a project.
  ## 
  let valid = call_580183.validator(path, query, header, formData, body)
  let scheme = call_580183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580183.url(scheme.get, call_580183.host, call_580183.base,
                         call_580183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580183, url, valid)

proc call*(call_580184: Call_DataprocProjectsRegionsJobsList_580164;
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
  var path_580185 = newJObject()
  var query_580186 = newJObject()
  var body_580187 = newJObject()
  add(query_580186, "upload_protocol", newJString(uploadProtocol))
  add(query_580186, "fields", newJString(fields))
  add(query_580186, "quotaUser", newJString(quotaUser))
  add(query_580186, "alt", newJString(alt))
  add(query_580186, "pp", newJBool(pp))
  add(query_580186, "oauth_token", newJString(oauthToken))
  add(query_580186, "uploadType", newJString(uploadType))
  add(query_580186, "callback", newJString(callback))
  add(query_580186, "access_token", newJString(accessToken))
  add(query_580186, "key", newJString(key))
  add(path_580185, "projectId", newJString(projectId))
  add(query_580186, "$.xgafv", newJString(Xgafv))
  add(path_580185, "region", newJString(region))
  if body != nil:
    body_580187 = body
  add(query_580186, "prettyPrint", newJBool(prettyPrint))
  add(query_580186, "bearer_token", newJString(bearerToken))
  result = call_580184.call(path_580185, query_580186, nil, nil, body_580187)

var dataprocProjectsRegionsJobsList* = Call_DataprocProjectsRegionsJobsList_580164(
    name: "dataprocProjectsRegionsJobsList", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs:list",
    validator: validate_DataprocProjectsRegionsJobsList_580165, base: "/",
    url: url_DataprocProjectsRegionsJobsList_580166, schemes: {Scheme.Https})
type
  Call_DataprocProjectsRegionsJobsSubmit_580188 = ref object of OpenApiRestCall_579408
proc url_DataprocProjectsRegionsJobsSubmit_580190(protocol: Scheme; host: string;
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

proc validate_DataprocProjectsRegionsJobsSubmit_580189(path: JsonNode;
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
  var valid_580191 = path.getOrDefault("projectId")
  valid_580191 = validateParameter(valid_580191, JString, required = true,
                                 default = nil)
  if valid_580191 != nil:
    section.add "projectId", valid_580191
  var valid_580192 = path.getOrDefault("region")
  valid_580192 = validateParameter(valid_580192, JString, required = true,
                                 default = nil)
  if valid_580192 != nil:
    section.add "region", valid_580192
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
  var valid_580193 = query.getOrDefault("upload_protocol")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "upload_protocol", valid_580193
  var valid_580194 = query.getOrDefault("fields")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "fields", valid_580194
  var valid_580195 = query.getOrDefault("quotaUser")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "quotaUser", valid_580195
  var valid_580196 = query.getOrDefault("alt")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("json"))
  if valid_580196 != nil:
    section.add "alt", valid_580196
  var valid_580197 = query.getOrDefault("pp")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(true))
  if valid_580197 != nil:
    section.add "pp", valid_580197
  var valid_580198 = query.getOrDefault("oauth_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "oauth_token", valid_580198
  var valid_580199 = query.getOrDefault("uploadType")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "uploadType", valid_580199
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
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("$.xgafv")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("1"))
  if valid_580203 != nil:
    section.add "$.xgafv", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  var valid_580205 = query.getOrDefault("bearer_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "bearer_token", valid_580205
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

proc call*(call_580207: Call_DataprocProjectsRegionsJobsSubmit_580188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Submits a job to a cluster.
  ## 
  let valid = call_580207.validator(path, query, header, formData, body)
  let scheme = call_580207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580207.url(scheme.get, call_580207.host, call_580207.base,
                         call_580207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580207, url, valid)

proc call*(call_580208: Call_DataprocProjectsRegionsJobsSubmit_580188;
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
  var path_580209 = newJObject()
  var query_580210 = newJObject()
  var body_580211 = newJObject()
  add(query_580210, "upload_protocol", newJString(uploadProtocol))
  add(query_580210, "fields", newJString(fields))
  add(query_580210, "quotaUser", newJString(quotaUser))
  add(query_580210, "alt", newJString(alt))
  add(query_580210, "pp", newJBool(pp))
  add(query_580210, "oauth_token", newJString(oauthToken))
  add(query_580210, "uploadType", newJString(uploadType))
  add(query_580210, "callback", newJString(callback))
  add(query_580210, "access_token", newJString(accessToken))
  add(query_580210, "key", newJString(key))
  add(path_580209, "projectId", newJString(projectId))
  add(query_580210, "$.xgafv", newJString(Xgafv))
  add(path_580209, "region", newJString(region))
  if body != nil:
    body_580211 = body
  add(query_580210, "prettyPrint", newJBool(prettyPrint))
  add(query_580210, "bearer_token", newJString(bearerToken))
  result = call_580208.call(path_580209, query_580210, nil, nil, body_580211)

var dataprocProjectsRegionsJobsSubmit* = Call_DataprocProjectsRegionsJobsSubmit_580188(
    name: "dataprocProjectsRegionsJobsSubmit", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com",
    route: "/v1alpha1/projects/{projectId}/regions/{region}/jobs:submit",
    validator: validate_DataprocProjectsRegionsJobsSubmit_580189, base: "/",
    url: url_DataprocProjectsRegionsJobsSubmit_580190, schemes: {Scheme.Https})
type
  Call_DataprocOperationsList_580212 = ref object of OpenApiRestCall_579408
proc url_DataprocOperationsList_580214(protocol: Scheme; host: string; base: string;
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

proc validate_DataprocOperationsList_580213(path: JsonNode; query: JsonNode;
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
  var valid_580215 = path.getOrDefault("name")
  valid_580215 = validateParameter(valid_580215, JString, required = true,
                                 default = nil)
  if valid_580215 != nil:
    section.add "name", valid_580215
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
  var valid_580216 = query.getOrDefault("upload_protocol")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "upload_protocol", valid_580216
  var valid_580217 = query.getOrDefault("fields")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "fields", valid_580217
  var valid_580218 = query.getOrDefault("pageToken")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "pageToken", valid_580218
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
  var valid_580221 = query.getOrDefault("pp")
  valid_580221 = validateParameter(valid_580221, JBool, required = false,
                                 default = newJBool(true))
  if valid_580221 != nil:
    section.add "pp", valid_580221
  var valid_580222 = query.getOrDefault("oauth_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "oauth_token", valid_580222
  var valid_580223 = query.getOrDefault("uploadType")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "uploadType", valid_580223
  var valid_580224 = query.getOrDefault("callback")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "callback", valid_580224
  var valid_580225 = query.getOrDefault("access_token")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "access_token", valid_580225
  var valid_580226 = query.getOrDefault("key")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "key", valid_580226
  var valid_580227 = query.getOrDefault("$.xgafv")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("1"))
  if valid_580227 != nil:
    section.add "$.xgafv", valid_580227
  var valid_580228 = query.getOrDefault("pageSize")
  valid_580228 = validateParameter(valid_580228, JInt, required = false, default = nil)
  if valid_580228 != nil:
    section.add "pageSize", valid_580228
  var valid_580229 = query.getOrDefault("prettyPrint")
  valid_580229 = validateParameter(valid_580229, JBool, required = false,
                                 default = newJBool(true))
  if valid_580229 != nil:
    section.add "prettyPrint", valid_580229
  var valid_580230 = query.getOrDefault("filter")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "filter", valid_580230
  var valid_580231 = query.getOrDefault("bearer_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "bearer_token", valid_580231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580232: Call_DataprocOperationsList_580212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_DataprocOperationsList_580212; name: string;
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
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  add(query_580235, "upload_protocol", newJString(uploadProtocol))
  add(query_580235, "fields", newJString(fields))
  add(query_580235, "pageToken", newJString(pageToken))
  add(query_580235, "quotaUser", newJString(quotaUser))
  add(path_580234, "name", newJString(name))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "pp", newJBool(pp))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "uploadType", newJString(uploadType))
  add(query_580235, "callback", newJString(callback))
  add(query_580235, "access_token", newJString(accessToken))
  add(query_580235, "key", newJString(key))
  add(query_580235, "$.xgafv", newJString(Xgafv))
  add(query_580235, "pageSize", newJInt(pageSize))
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  add(query_580235, "filter", newJString(filter))
  add(query_580235, "bearer_token", newJString(bearerToken))
  result = call_580233.call(path_580234, query_580235, nil, nil, nil)

var dataprocOperationsList* = Call_DataprocOperationsList_580212(
    name: "dataprocOperationsList", meth: HttpMethod.HttpGet,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_DataprocOperationsList_580213, base: "/",
    url: url_DataprocOperationsList_580214, schemes: {Scheme.Https})
type
  Call_DataprocOperationsDelete_580236 = ref object of OpenApiRestCall_579408
proc url_DataprocOperationsDelete_580238(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsDelete_580237(path: JsonNode; query: JsonNode;
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
  var valid_580239 = path.getOrDefault("name")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "name", valid_580239
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
  var valid_580240 = query.getOrDefault("upload_protocol")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "upload_protocol", valid_580240
  var valid_580241 = query.getOrDefault("fields")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "fields", valid_580241
  var valid_580242 = query.getOrDefault("quotaUser")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "quotaUser", valid_580242
  var valid_580243 = query.getOrDefault("alt")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("json"))
  if valid_580243 != nil:
    section.add "alt", valid_580243
  var valid_580244 = query.getOrDefault("pp")
  valid_580244 = validateParameter(valid_580244, JBool, required = false,
                                 default = newJBool(true))
  if valid_580244 != nil:
    section.add "pp", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("uploadType")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "uploadType", valid_580246
  var valid_580247 = query.getOrDefault("callback")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "callback", valid_580247
  var valid_580248 = query.getOrDefault("access_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "access_token", valid_580248
  var valid_580249 = query.getOrDefault("key")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "key", valid_580249
  var valid_580250 = query.getOrDefault("$.xgafv")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("1"))
  if valid_580250 != nil:
    section.add "$.xgafv", valid_580250
  var valid_580251 = query.getOrDefault("prettyPrint")
  valid_580251 = validateParameter(valid_580251, JBool, required = false,
                                 default = newJBool(true))
  if valid_580251 != nil:
    section.add "prettyPrint", valid_580251
  var valid_580252 = query.getOrDefault("bearer_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "bearer_token", valid_580252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580253: Call_DataprocOperationsDelete_580236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. It indicates the client is no longer interested in the operation result. It does not cancel the operation.
  ## 
  let valid = call_580253.validator(path, query, header, formData, body)
  let scheme = call_580253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580253.url(scheme.get, call_580253.host, call_580253.base,
                         call_580253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580253, url, valid)

proc call*(call_580254: Call_DataprocOperationsDelete_580236; name: string;
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
  var path_580255 = newJObject()
  var query_580256 = newJObject()
  add(query_580256, "upload_protocol", newJString(uploadProtocol))
  add(query_580256, "fields", newJString(fields))
  add(query_580256, "quotaUser", newJString(quotaUser))
  add(path_580255, "name", newJString(name))
  add(query_580256, "alt", newJString(alt))
  add(query_580256, "pp", newJBool(pp))
  add(query_580256, "oauth_token", newJString(oauthToken))
  add(query_580256, "uploadType", newJString(uploadType))
  add(query_580256, "callback", newJString(callback))
  add(query_580256, "access_token", newJString(accessToken))
  add(query_580256, "key", newJString(key))
  add(query_580256, "$.xgafv", newJString(Xgafv))
  add(query_580256, "prettyPrint", newJBool(prettyPrint))
  add(query_580256, "bearer_token", newJString(bearerToken))
  result = call_580254.call(path_580255, query_580256, nil, nil, nil)

var dataprocOperationsDelete* = Call_DataprocOperationsDelete_580236(
    name: "dataprocOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_DataprocOperationsDelete_580237, base: "/",
    url: url_DataprocOperationsDelete_580238, schemes: {Scheme.Https})
type
  Call_DataprocOperationsCancel_580257 = ref object of OpenApiRestCall_579408
proc url_DataprocOperationsCancel_580259(protocol: Scheme; host: string;
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

proc validate_DataprocOperationsCancel_580258(path: JsonNode; query: JsonNode;
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
  var valid_580260 = path.getOrDefault("name")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "name", valid_580260
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
  var valid_580261 = query.getOrDefault("upload_protocol")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "upload_protocol", valid_580261
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("alt")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("json"))
  if valid_580264 != nil:
    section.add "alt", valid_580264
  var valid_580265 = query.getOrDefault("pp")
  valid_580265 = validateParameter(valid_580265, JBool, required = false,
                                 default = newJBool(true))
  if valid_580265 != nil:
    section.add "pp", valid_580265
  var valid_580266 = query.getOrDefault("oauth_token")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "oauth_token", valid_580266
  var valid_580267 = query.getOrDefault("uploadType")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "uploadType", valid_580267
  var valid_580268 = query.getOrDefault("callback")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "callback", valid_580268
  var valid_580269 = query.getOrDefault("access_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "access_token", valid_580269
  var valid_580270 = query.getOrDefault("key")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "key", valid_580270
  var valid_580271 = query.getOrDefault("$.xgafv")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("1"))
  if valid_580271 != nil:
    section.add "$.xgafv", valid_580271
  var valid_580272 = query.getOrDefault("prettyPrint")
  valid_580272 = validateParameter(valid_580272, JBool, required = false,
                                 default = newJBool(true))
  if valid_580272 != nil:
    section.add "prettyPrint", valid_580272
  var valid_580273 = query.getOrDefault("bearer_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "bearer_token", valid_580273
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

proc call*(call_580275: Call_DataprocOperationsCancel_580257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients may use Operations.GetOperation or other methods to check whether the cancellation succeeded or the operation completed despite cancellation.
  ## 
  let valid = call_580275.validator(path, query, header, formData, body)
  let scheme = call_580275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580275.url(scheme.get, call_580275.host, call_580275.base,
                         call_580275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580275, url, valid)

proc call*(call_580276: Call_DataprocOperationsCancel_580257; name: string;
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
  var path_580277 = newJObject()
  var query_580278 = newJObject()
  var body_580279 = newJObject()
  add(query_580278, "upload_protocol", newJString(uploadProtocol))
  add(query_580278, "fields", newJString(fields))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(path_580277, "name", newJString(name))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "pp", newJBool(pp))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(query_580278, "uploadType", newJString(uploadType))
  add(query_580278, "callback", newJString(callback))
  add(query_580278, "access_token", newJString(accessToken))
  add(query_580278, "key", newJString(key))
  add(query_580278, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580279 = body
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  add(query_580278, "bearer_token", newJString(bearerToken))
  result = call_580276.call(path_580277, query_580278, nil, nil, body_580279)

var dataprocOperationsCancel* = Call_DataprocOperationsCancel_580257(
    name: "dataprocOperationsCancel", meth: HttpMethod.HttpPost,
    host: "dataproc.googleapis.com", route: "/v1alpha1/{name}:cancel",
    validator: validate_DataprocOperationsCancel_580258, base: "/",
    url: url_DataprocOperationsCancel_580259, schemes: {Scheme.Https})
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
