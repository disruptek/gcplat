
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Monitoring
## version: v2beta2
## termsOfService: (not provided)
## license: (not provided)
## 
## Accesses Google Cloud Monitoring data.
## 
## https://cloud.google.com/monitoring/v2beta2/
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudmonitoring"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudmonitoringMetricDescriptorsCreate_579982 = ref object of OpenApiRestCall_579424
proc url_CloudmonitoringMetricDescriptorsCreate_579984(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/metricDescriptors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudmonitoringMetricDescriptorsCreate_579983(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project id. The value can be the numeric project ID or string-based project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579985 = path.getOrDefault("project")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "project", valid_579985
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("userIp")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "userIp", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
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

proc call*(call_579994: Call_CloudmonitoringMetricDescriptorsCreate_579982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new metric.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_CloudmonitoringMetricDescriptorsCreate_579982;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudmonitoringMetricDescriptorsCreate
  ## Create a new metric.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project id. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  var body_579998 = newJObject()
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "userIp", newJString(userIp))
  add(query_579997, "key", newJString(key))
  add(path_579996, "project", newJString(project))
  if body != nil:
    body_579998 = body
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  result = call_579995.call(path_579996, query_579997, nil, nil, body_579998)

var cloudmonitoringMetricDescriptorsCreate* = Call_CloudmonitoringMetricDescriptorsCreate_579982(
    name: "cloudmonitoringMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsCreate_579983,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsCreate_579984,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsList_579692 = ref object of OpenApiRestCall_579424
proc url_CloudmonitoringMetricDescriptorsList_579694(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/metricDescriptors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudmonitoringMetricDescriptorsList_579693(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List metric descriptors that match the query. If the query is not set, then all of the metric descriptors will be returned. Large responses will be paginated, use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project id. The value can be the numeric project ID or string-based project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579820 = path.getOrDefault("project")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "project", valid_579820
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : The query used to search against existing metrics. Separate keywords with a space; the service joins all keywords with AND, meaning that all keywords must match for a metric to be returned. If this field is omitted, all metrics are returned. If an empty string is passed with this field, no metrics are returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   count: JInt
  ##        : Maximum number of metric descriptors per page. Used for pagination. If not specified, count = 100.
  section = newJObject()
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
  var valid_579838 = query.getOrDefault("query")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "query", valid_579838
  var valid_579839 = query.getOrDefault("oauth_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "oauth_token", valid_579839
  var valid_579840 = query.getOrDefault("userIp")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "userIp", valid_579840
  var valid_579841 = query.getOrDefault("key")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "key", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
  var valid_579844 = query.getOrDefault("count")
  valid_579844 = validateParameter(valid_579844, JInt, required = false,
                                 default = newJInt(100))
  if valid_579844 != nil:
    section.add "count", valid_579844
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

proc call*(call_579868: Call_CloudmonitoringMetricDescriptorsList_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List metric descriptors that match the query. If the query is not set, then all of the metric descriptors will be returned. Large responses will be paginated, use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_579868.validator(path, query, header, formData, body)
  let scheme = call_579868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579868.url(scheme.get, call_579868.host, call_579868.base,
                         call_579868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579868, url, valid)

proc call*(call_579939: Call_CloudmonitoringMetricDescriptorsList_579692;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; count: int = 100): Recallable =
  ## cloudmonitoringMetricDescriptorsList
  ## List metric descriptors that match the query. If the query is not set, then all of the metric descriptors will be returned. Large responses will be paginated, use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : The query used to search against existing metrics. Separate keywords with a space; the service joins all keywords with AND, meaning that all keywords must match for a metric to be returned. If this field is omitted, all metrics are returned. If an empty string is passed with this field, no metrics are returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project id. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   count: int
  ##        : Maximum number of metric descriptors per page. Used for pagination. If not specified, count = 100.
  var path_579940 = newJObject()
  var query_579942 = newJObject()
  var body_579943 = newJObject()
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "pageToken", newJString(pageToken))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "query", newJString(query))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "key", newJString(key))
  add(path_579940, "project", newJString(project))
  if body != nil:
    body_579943 = body
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "count", newJInt(count))
  result = call_579939.call(path_579940, query_579942, nil, nil, body_579943)

var cloudmonitoringMetricDescriptorsList* = Call_CloudmonitoringMetricDescriptorsList_579692(
    name: "cloudmonitoringMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsList_579693,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsList_579694, schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsDelete_579999 = ref object of OpenApiRestCall_579424
proc url_CloudmonitoringMetricDescriptorsDelete_580001(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "metric" in path, "`metric` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/metricDescriptors/"),
               (kind: VariableSegment, value: "metric")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudmonitoringMetricDescriptorsDelete_580000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metric: JString (required)
  ##         : Name of the metric.
  ##   project: JString (required)
  ##          : The project ID to which the metric belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `metric` field"
  var valid_580002 = path.getOrDefault("metric")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "metric", valid_580002
  var valid_580003 = path.getOrDefault("project")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "project", valid_580003
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("alt")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("json"))
  if valid_580006 != nil:
    section.add "alt", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("userIp")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "userIp", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("prettyPrint")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "prettyPrint", valid_580010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580011: Call_CloudmonitoringMetricDescriptorsDelete_579999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an existing metric.
  ## 
  let valid = call_580011.validator(path, query, header, formData, body)
  let scheme = call_580011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580011.url(scheme.get, call_580011.host, call_580011.base,
                         call_580011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580011, url, valid)

proc call*(call_580012: Call_CloudmonitoringMetricDescriptorsDelete_579999;
          metric: string; project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## cloudmonitoringMetricDescriptorsDelete
  ## Delete an existing metric.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   metric: string (required)
  ##         : Name of the metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID to which the metric belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580013 = newJObject()
  var query_580014 = newJObject()
  add(query_580014, "fields", newJString(fields))
  add(query_580014, "quotaUser", newJString(quotaUser))
  add(query_580014, "alt", newJString(alt))
  add(query_580014, "oauth_token", newJString(oauthToken))
  add(query_580014, "userIp", newJString(userIp))
  add(path_580013, "metric", newJString(metric))
  add(query_580014, "key", newJString(key))
  add(path_580013, "project", newJString(project))
  add(query_580014, "prettyPrint", newJBool(prettyPrint))
  result = call_580012.call(path_580013, query_580014, nil, nil, nil)

var cloudmonitoringMetricDescriptorsDelete* = Call_CloudmonitoringMetricDescriptorsDelete_579999(
    name: "cloudmonitoringMetricDescriptorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors/{metric}",
    validator: validate_CloudmonitoringMetricDescriptorsDelete_580000,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsDelete_580001,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesList_580015 = ref object of OpenApiRestCall_579424
proc url_CloudmonitoringTimeseriesList_580017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "metric" in path, "`metric` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/timeseries/"),
               (kind: VariableSegment, value: "metric")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudmonitoringTimeseriesList_580016(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the data points of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metric: JString (required)
  ##         : Metric names are protocol-free URLs as listed in the Supported Metrics page. For example, compute.googleapis.com/instance/disk/read_ops_count.
  ##   project: JString (required)
  ##          : The project ID to which this time series belongs. The value can be the numeric project ID or string-based project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `metric` field"
  var valid_580018 = path.getOrDefault("metric")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "metric", valid_580018
  var valid_580019 = path.getOrDefault("project")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "project", valid_580019
  result.add "path", section
  ## parameters in `query` object:
  ##   aggregator: JString
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   oldest: JString
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: JString
  ##      : Data format for the response.
  ##   timespan: JString
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JArray
  ##         : A collection of labels for the matching time series, which are represented as:  
  ## - key==value: key equals the value 
  ## - key=~value: key regex matches the value 
  ## - key!=value: key does not equal the value 
  ## - key!~value: key regex does not match the value  For example, to list all of the time series descriptors for the region us-central1, you could specify:
  ## label=cloud.googleapis.com%2Flocation=~us-central1.*
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   count: JInt
  ##        : Maximum number of data points per page, which is used for pagination of results.
  ##   youngest: JString (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   window: JString
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  section = newJObject()
  var valid_580020 = query.getOrDefault("aggregator")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("max"))
  if valid_580020 != nil:
    section.add "aggregator", valid_580020
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("pageToken")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "pageToken", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("oldest")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oldest", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("timespan")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "timespan", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("userIp")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "userIp", valid_580028
  var valid_580029 = query.getOrDefault("key")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "key", valid_580029
  var valid_580030 = query.getOrDefault("labels")
  valid_580030 = validateParameter(valid_580030, JArray, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "labels", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(true))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  var valid_580032 = query.getOrDefault("count")
  valid_580032 = validateParameter(valid_580032, JInt, required = false,
                                 default = newJInt(6000))
  if valid_580032 != nil:
    section.add "count", valid_580032
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_580033 = query.getOrDefault("youngest")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "youngest", valid_580033
  var valid_580034 = query.getOrDefault("window")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "window", valid_580034
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

proc call*(call_580036: Call_CloudmonitoringTimeseriesList_580015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the data points of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_CloudmonitoringTimeseriesList_580015; metric: string;
          project: string; youngest: string; aggregator: string = "max";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          oldest: string = ""; alt: string = "json"; timespan: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          labels: JsonNode = nil; body: JsonNode = nil; prettyPrint: bool = true;
          count: int = 6000; window: string = ""): Recallable =
  ## cloudmonitoringTimeseriesList
  ## List the data points of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ##   aggregator: string
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   oldest: string
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: string
  ##      : Data format for the response.
  ##   timespan: string
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   metric: string (required)
  ##         : Metric names are protocol-free URLs as listed in the Supported Metrics page. For example, compute.googleapis.com/instance/disk/read_ops_count.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JArray
  ##         : A collection of labels for the matching time series, which are represented as:  
  ## - key==value: key equals the value 
  ## - key=~value: key regex matches the value 
  ## - key!=value: key does not equal the value 
  ## - key!~value: key regex does not match the value  For example, to list all of the time series descriptors for the region us-central1, you could specify:
  ## label=cloud.googleapis.com%2Flocation=~us-central1.*
  ##   project: string (required)
  ##          : The project ID to which this time series belongs. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   count: int
  ##        : Maximum number of data points per page, which is used for pagination of results.
  ##   youngest: string (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   window: string
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  var body_580040 = newJObject()
  add(query_580039, "aggregator", newJString(aggregator))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "pageToken", newJString(pageToken))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(query_580039, "oldest", newJString(oldest))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "timespan", newJString(timespan))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "userIp", newJString(userIp))
  add(path_580038, "metric", newJString(metric))
  add(query_580039, "key", newJString(key))
  if labels != nil:
    query_580039.add "labels", labels
  add(path_580038, "project", newJString(project))
  if body != nil:
    body_580040 = body
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  add(query_580039, "count", newJInt(count))
  add(query_580039, "youngest", newJString(youngest))
  add(query_580039, "window", newJString(window))
  result = call_580037.call(path_580038, query_580039, nil, nil, body_580040)

var cloudmonitoringTimeseriesList* = Call_CloudmonitoringTimeseriesList_580015(
    name: "cloudmonitoringTimeseriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/timeseries/{metric}",
    validator: validate_CloudmonitoringTimeseriesList_580016,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesList_580017, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesWrite_580041 = ref object of OpenApiRestCall_579424
proc url_CloudmonitoringTimeseriesWrite_580043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/timeseries:write")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudmonitoringTimeseriesWrite_580042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Put data points to one or more time series for one or more metrics. If a time series does not exist, a new time series will be created. It is not allowed to write a time series point that is older than the existing youngest point of that time series. Points that are older than the existing youngest point of that time series will be discarded silently. Therefore, users should make sure that points of a time series are written sequentially in the order of their end time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID. The value can be the numeric project ID or string-based project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580044 = path.getOrDefault("project")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "project", valid_580044
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("userIp")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "userIp", valid_580049
  var valid_580050 = query.getOrDefault("key")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "key", valid_580050
  var valid_580051 = query.getOrDefault("prettyPrint")
  valid_580051 = validateParameter(valid_580051, JBool, required = false,
                                 default = newJBool(true))
  if valid_580051 != nil:
    section.add "prettyPrint", valid_580051
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

proc call*(call_580053: Call_CloudmonitoringTimeseriesWrite_580041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Put data points to one or more time series for one or more metrics. If a time series does not exist, a new time series will be created. It is not allowed to write a time series point that is older than the existing youngest point of that time series. Points that are older than the existing youngest point of that time series will be discarded silently. Therefore, users should make sure that points of a time series are written sequentially in the order of their end time.
  ## 
  let valid = call_580053.validator(path, query, header, formData, body)
  let scheme = call_580053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580053.url(scheme.get, call_580053.host, call_580053.base,
                         call_580053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580053, url, valid)

proc call*(call_580054: Call_CloudmonitoringTimeseriesWrite_580041;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudmonitoringTimeseriesWrite
  ## Put data points to one or more time series for one or more metrics. If a time series does not exist, a new time series will be created. It is not allowed to write a time series point that is older than the existing youngest point of that time series. Points that are older than the existing youngest point of that time series will be discarded silently. Therefore, users should make sure that points of a time series are written sequentially in the order of their end time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580055 = newJObject()
  var query_580056 = newJObject()
  var body_580057 = newJObject()
  add(query_580056, "fields", newJString(fields))
  add(query_580056, "quotaUser", newJString(quotaUser))
  add(query_580056, "alt", newJString(alt))
  add(query_580056, "oauth_token", newJString(oauthToken))
  add(query_580056, "userIp", newJString(userIp))
  add(query_580056, "key", newJString(key))
  add(path_580055, "project", newJString(project))
  if body != nil:
    body_580057 = body
  add(query_580056, "prettyPrint", newJBool(prettyPrint))
  result = call_580054.call(path_580055, query_580056, nil, nil, body_580057)

var cloudmonitoringTimeseriesWrite* = Call_CloudmonitoringTimeseriesWrite_580041(
    name: "cloudmonitoringTimeseriesWrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/timeseries:write",
    validator: validate_CloudmonitoringTimeseriesWrite_580042,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesWrite_580043, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesDescriptorsList_580058 = ref object of OpenApiRestCall_579424
proc url_CloudmonitoringTimeseriesDescriptorsList_580060(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "metric" in path, "`metric` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/timeseriesDescriptors/"),
               (kind: VariableSegment, value: "metric")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudmonitoringTimeseriesDescriptorsList_580059(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the descriptors of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metric: JString (required)
  ##         : Metric names are protocol-free URLs as listed in the Supported Metrics page. For example, compute.googleapis.com/instance/disk/read_ops_count.
  ##   project: JString (required)
  ##          : The project ID to which this time series belongs. The value can be the numeric project ID or string-based project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `metric` field"
  var valid_580061 = path.getOrDefault("metric")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = nil)
  if valid_580061 != nil:
    section.add "metric", valid_580061
  var valid_580062 = path.getOrDefault("project")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "project", valid_580062
  result.add "path", section
  ## parameters in `query` object:
  ##   aggregator: JString
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   oldest: JString
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: JString
  ##      : Data format for the response.
  ##   timespan: JString
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JArray
  ##         : A collection of labels for the matching time series, which are represented as:  
  ## - key==value: key equals the value 
  ## - key=~value: key regex matches the value 
  ## - key!=value: key does not equal the value 
  ## - key!~value: key regex does not match the value  For example, to list all of the time series descriptors for the region us-central1, you could specify:
  ## label=cloud.googleapis.com%2Flocation=~us-central1.*
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   count: JInt
  ##        : Maximum number of time series descriptors per page. Used for pagination. If not specified, count = 100.
  ##   youngest: JString (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   window: JString
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  section = newJObject()
  var valid_580063 = query.getOrDefault("aggregator")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("max"))
  if valid_580063 != nil:
    section.add "aggregator", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("pageToken")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "pageToken", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("oldest")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oldest", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("timespan")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "timespan", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("userIp")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "userIp", valid_580071
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("labels")
  valid_580073 = validateParameter(valid_580073, JArray, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "labels", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  var valid_580075 = query.getOrDefault("count")
  valid_580075 = validateParameter(valid_580075, JInt, required = false,
                                 default = newJInt(100))
  if valid_580075 != nil:
    section.add "count", valid_580075
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_580076 = query.getOrDefault("youngest")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "youngest", valid_580076
  var valid_580077 = query.getOrDefault("window")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "window", valid_580077
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

proc call*(call_580079: Call_CloudmonitoringTimeseriesDescriptorsList_580058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the descriptors of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_CloudmonitoringTimeseriesDescriptorsList_580058;
          metric: string; project: string; youngest: string;
          aggregator: string = "max"; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; oldest: string = ""; alt: string = "json";
          timespan: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; labels: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; count: int = 100; window: string = ""): Recallable =
  ## cloudmonitoringTimeseriesDescriptorsList
  ## List the descriptors of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ##   aggregator: string
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   oldest: string
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: string
  ##      : Data format for the response.
  ##   timespan: string
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   metric: string (required)
  ##         : Metric names are protocol-free URLs as listed in the Supported Metrics page. For example, compute.googleapis.com/instance/disk/read_ops_count.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JArray
  ##         : A collection of labels for the matching time series, which are represented as:  
  ## - key==value: key equals the value 
  ## - key=~value: key regex matches the value 
  ## - key!=value: key does not equal the value 
  ## - key!~value: key regex does not match the value  For example, to list all of the time series descriptors for the region us-central1, you could specify:
  ## label=cloud.googleapis.com%2Flocation=~us-central1.*
  ##   project: string (required)
  ##          : The project ID to which this time series belongs. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   count: int
  ##        : Maximum number of time series descriptors per page. Used for pagination. If not specified, count = 100.
  ##   youngest: string (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   window: string
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  var body_580083 = newJObject()
  add(query_580082, "aggregator", newJString(aggregator))
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "pageToken", newJString(pageToken))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(query_580082, "oldest", newJString(oldest))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "timespan", newJString(timespan))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "userIp", newJString(userIp))
  add(path_580081, "metric", newJString(metric))
  add(query_580082, "key", newJString(key))
  if labels != nil:
    query_580082.add "labels", labels
  add(path_580081, "project", newJString(project))
  if body != nil:
    body_580083 = body
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  add(query_580082, "count", newJInt(count))
  add(query_580082, "youngest", newJString(youngest))
  add(query_580082, "window", newJString(window))
  result = call_580080.call(path_580081, query_580082, nil, nil, body_580083)

var cloudmonitoringTimeseriesDescriptorsList* = Call_CloudmonitoringTimeseriesDescriptorsList_580058(
    name: "cloudmonitoringTimeseriesDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/timeseriesDescriptors/{metric}",
    validator: validate_CloudmonitoringTimeseriesDescriptorsList_580059,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesDescriptorsList_580060,
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
