
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudmonitoringMetricDescriptorsCreate_597982 = ref object of OpenApiRestCall_597424
proc url_CloudmonitoringMetricDescriptorsCreate_597984(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudmonitoringMetricDescriptorsCreate_597983(path: JsonNode;
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
  var valid_597985 = path.getOrDefault("project")
  valid_597985 = validateParameter(valid_597985, JString, required = true,
                                 default = nil)
  if valid_597985 != nil:
    section.add "project", valid_597985
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
  var valid_597986 = query.getOrDefault("fields")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "fields", valid_597986
  var valid_597987 = query.getOrDefault("quotaUser")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "quotaUser", valid_597987
  var valid_597988 = query.getOrDefault("alt")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = newJString("json"))
  if valid_597988 != nil:
    section.add "alt", valid_597988
  var valid_597989 = query.getOrDefault("oauth_token")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "oauth_token", valid_597989
  var valid_597990 = query.getOrDefault("userIp")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "userIp", valid_597990
  var valid_597991 = query.getOrDefault("key")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "key", valid_597991
  var valid_597992 = query.getOrDefault("prettyPrint")
  valid_597992 = validateParameter(valid_597992, JBool, required = false,
                                 default = newJBool(true))
  if valid_597992 != nil:
    section.add "prettyPrint", valid_597992
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

proc call*(call_597994: Call_CloudmonitoringMetricDescriptorsCreate_597982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new metric.
  ## 
  let valid = call_597994.validator(path, query, header, formData, body)
  let scheme = call_597994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597994.url(scheme.get, call_597994.host, call_597994.base,
                         call_597994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597994, url, valid)

proc call*(call_597995: Call_CloudmonitoringMetricDescriptorsCreate_597982;
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
  var path_597996 = newJObject()
  var query_597997 = newJObject()
  var body_597998 = newJObject()
  add(query_597997, "fields", newJString(fields))
  add(query_597997, "quotaUser", newJString(quotaUser))
  add(query_597997, "alt", newJString(alt))
  add(query_597997, "oauth_token", newJString(oauthToken))
  add(query_597997, "userIp", newJString(userIp))
  add(query_597997, "key", newJString(key))
  add(path_597996, "project", newJString(project))
  if body != nil:
    body_597998 = body
  add(query_597997, "prettyPrint", newJBool(prettyPrint))
  result = call_597995.call(path_597996, query_597997, nil, nil, body_597998)

var cloudmonitoringMetricDescriptorsCreate* = Call_CloudmonitoringMetricDescriptorsCreate_597982(
    name: "cloudmonitoringMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsCreate_597983,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsCreate_597984,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsList_597692 = ref object of OpenApiRestCall_597424
proc url_CloudmonitoringMetricDescriptorsList_597694(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudmonitoringMetricDescriptorsList_597693(path: JsonNode;
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
  var valid_597820 = path.getOrDefault("project")
  valid_597820 = validateParameter(valid_597820, JString, required = true,
                                 default = nil)
  if valid_597820 != nil:
    section.add "project", valid_597820
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
  var valid_597821 = query.getOrDefault("fields")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "fields", valid_597821
  var valid_597822 = query.getOrDefault("pageToken")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "pageToken", valid_597822
  var valid_597823 = query.getOrDefault("quotaUser")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "quotaUser", valid_597823
  var valid_597837 = query.getOrDefault("alt")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = newJString("json"))
  if valid_597837 != nil:
    section.add "alt", valid_597837
  var valid_597838 = query.getOrDefault("query")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "query", valid_597838
  var valid_597839 = query.getOrDefault("oauth_token")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "oauth_token", valid_597839
  var valid_597840 = query.getOrDefault("userIp")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "userIp", valid_597840
  var valid_597841 = query.getOrDefault("key")
  valid_597841 = validateParameter(valid_597841, JString, required = false,
                                 default = nil)
  if valid_597841 != nil:
    section.add "key", valid_597841
  var valid_597842 = query.getOrDefault("prettyPrint")
  valid_597842 = validateParameter(valid_597842, JBool, required = false,
                                 default = newJBool(true))
  if valid_597842 != nil:
    section.add "prettyPrint", valid_597842
  var valid_597844 = query.getOrDefault("count")
  valid_597844 = validateParameter(valid_597844, JInt, required = false,
                                 default = newJInt(100))
  if valid_597844 != nil:
    section.add "count", valid_597844
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

proc call*(call_597868: Call_CloudmonitoringMetricDescriptorsList_597692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List metric descriptors that match the query. If the query is not set, then all of the metric descriptors will be returned. Large responses will be paginated, use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_597868.validator(path, query, header, formData, body)
  let scheme = call_597868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597868.url(scheme.get, call_597868.host, call_597868.base,
                         call_597868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597868, url, valid)

proc call*(call_597939: Call_CloudmonitoringMetricDescriptorsList_597692;
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
  var path_597940 = newJObject()
  var query_597942 = newJObject()
  var body_597943 = newJObject()
  add(query_597942, "fields", newJString(fields))
  add(query_597942, "pageToken", newJString(pageToken))
  add(query_597942, "quotaUser", newJString(quotaUser))
  add(query_597942, "alt", newJString(alt))
  add(query_597942, "query", newJString(query))
  add(query_597942, "oauth_token", newJString(oauthToken))
  add(query_597942, "userIp", newJString(userIp))
  add(query_597942, "key", newJString(key))
  add(path_597940, "project", newJString(project))
  if body != nil:
    body_597943 = body
  add(query_597942, "prettyPrint", newJBool(prettyPrint))
  add(query_597942, "count", newJInt(count))
  result = call_597939.call(path_597940, query_597942, nil, nil, body_597943)

var cloudmonitoringMetricDescriptorsList* = Call_CloudmonitoringMetricDescriptorsList_597692(
    name: "cloudmonitoringMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsList_597693,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsList_597694, schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsDelete_597999 = ref object of OpenApiRestCall_597424
proc url_CloudmonitoringMetricDescriptorsDelete_598001(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudmonitoringMetricDescriptorsDelete_598000(path: JsonNode;
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
  var valid_598002 = path.getOrDefault("metric")
  valid_598002 = validateParameter(valid_598002, JString, required = true,
                                 default = nil)
  if valid_598002 != nil:
    section.add "metric", valid_598002
  var valid_598003 = path.getOrDefault("project")
  valid_598003 = validateParameter(valid_598003, JString, required = true,
                                 default = nil)
  if valid_598003 != nil:
    section.add "project", valid_598003
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
  var valid_598004 = query.getOrDefault("fields")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "fields", valid_598004
  var valid_598005 = query.getOrDefault("quotaUser")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "quotaUser", valid_598005
  var valid_598006 = query.getOrDefault("alt")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = newJString("json"))
  if valid_598006 != nil:
    section.add "alt", valid_598006
  var valid_598007 = query.getOrDefault("oauth_token")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "oauth_token", valid_598007
  var valid_598008 = query.getOrDefault("userIp")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "userIp", valid_598008
  var valid_598009 = query.getOrDefault("key")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "key", valid_598009
  var valid_598010 = query.getOrDefault("prettyPrint")
  valid_598010 = validateParameter(valid_598010, JBool, required = false,
                                 default = newJBool(true))
  if valid_598010 != nil:
    section.add "prettyPrint", valid_598010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598011: Call_CloudmonitoringMetricDescriptorsDelete_597999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an existing metric.
  ## 
  let valid = call_598011.validator(path, query, header, formData, body)
  let scheme = call_598011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598011.url(scheme.get, call_598011.host, call_598011.base,
                         call_598011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598011, url, valid)

proc call*(call_598012: Call_CloudmonitoringMetricDescriptorsDelete_597999;
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
  var path_598013 = newJObject()
  var query_598014 = newJObject()
  add(query_598014, "fields", newJString(fields))
  add(query_598014, "quotaUser", newJString(quotaUser))
  add(query_598014, "alt", newJString(alt))
  add(query_598014, "oauth_token", newJString(oauthToken))
  add(query_598014, "userIp", newJString(userIp))
  add(path_598013, "metric", newJString(metric))
  add(query_598014, "key", newJString(key))
  add(path_598013, "project", newJString(project))
  add(query_598014, "prettyPrint", newJBool(prettyPrint))
  result = call_598012.call(path_598013, query_598014, nil, nil, nil)

var cloudmonitoringMetricDescriptorsDelete* = Call_CloudmonitoringMetricDescriptorsDelete_597999(
    name: "cloudmonitoringMetricDescriptorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors/{metric}",
    validator: validate_CloudmonitoringMetricDescriptorsDelete_598000,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsDelete_598001,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesList_598015 = ref object of OpenApiRestCall_597424
proc url_CloudmonitoringTimeseriesList_598017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudmonitoringTimeseriesList_598016(path: JsonNode; query: JsonNode;
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
  var valid_598018 = path.getOrDefault("metric")
  valid_598018 = validateParameter(valid_598018, JString, required = true,
                                 default = nil)
  if valid_598018 != nil:
    section.add "metric", valid_598018
  var valid_598019 = path.getOrDefault("project")
  valid_598019 = validateParameter(valid_598019, JString, required = true,
                                 default = nil)
  if valid_598019 != nil:
    section.add "project", valid_598019
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
  var valid_598020 = query.getOrDefault("aggregator")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = newJString("max"))
  if valid_598020 != nil:
    section.add "aggregator", valid_598020
  var valid_598021 = query.getOrDefault("fields")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "fields", valid_598021
  var valid_598022 = query.getOrDefault("pageToken")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "pageToken", valid_598022
  var valid_598023 = query.getOrDefault("quotaUser")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "quotaUser", valid_598023
  var valid_598024 = query.getOrDefault("oldest")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "oldest", valid_598024
  var valid_598025 = query.getOrDefault("alt")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = newJString("json"))
  if valid_598025 != nil:
    section.add "alt", valid_598025
  var valid_598026 = query.getOrDefault("timespan")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "timespan", valid_598026
  var valid_598027 = query.getOrDefault("oauth_token")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "oauth_token", valid_598027
  var valid_598028 = query.getOrDefault("userIp")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "userIp", valid_598028
  var valid_598029 = query.getOrDefault("key")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "key", valid_598029
  var valid_598030 = query.getOrDefault("labels")
  valid_598030 = validateParameter(valid_598030, JArray, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "labels", valid_598030
  var valid_598031 = query.getOrDefault("prettyPrint")
  valid_598031 = validateParameter(valid_598031, JBool, required = false,
                                 default = newJBool(true))
  if valid_598031 != nil:
    section.add "prettyPrint", valid_598031
  var valid_598032 = query.getOrDefault("count")
  valid_598032 = validateParameter(valid_598032, JInt, required = false,
                                 default = newJInt(6000))
  if valid_598032 != nil:
    section.add "count", valid_598032
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_598033 = query.getOrDefault("youngest")
  valid_598033 = validateParameter(valid_598033, JString, required = true,
                                 default = nil)
  if valid_598033 != nil:
    section.add "youngest", valid_598033
  var valid_598034 = query.getOrDefault("window")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "window", valid_598034
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

proc call*(call_598036: Call_CloudmonitoringTimeseriesList_598015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the data points of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_598036.validator(path, query, header, formData, body)
  let scheme = call_598036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598036.url(scheme.get, call_598036.host, call_598036.base,
                         call_598036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598036, url, valid)

proc call*(call_598037: Call_CloudmonitoringTimeseriesList_598015; metric: string;
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
  var path_598038 = newJObject()
  var query_598039 = newJObject()
  var body_598040 = newJObject()
  add(query_598039, "aggregator", newJString(aggregator))
  add(query_598039, "fields", newJString(fields))
  add(query_598039, "pageToken", newJString(pageToken))
  add(query_598039, "quotaUser", newJString(quotaUser))
  add(query_598039, "oldest", newJString(oldest))
  add(query_598039, "alt", newJString(alt))
  add(query_598039, "timespan", newJString(timespan))
  add(query_598039, "oauth_token", newJString(oauthToken))
  add(query_598039, "userIp", newJString(userIp))
  add(path_598038, "metric", newJString(metric))
  add(query_598039, "key", newJString(key))
  if labels != nil:
    query_598039.add "labels", labels
  add(path_598038, "project", newJString(project))
  if body != nil:
    body_598040 = body
  add(query_598039, "prettyPrint", newJBool(prettyPrint))
  add(query_598039, "count", newJInt(count))
  add(query_598039, "youngest", newJString(youngest))
  add(query_598039, "window", newJString(window))
  result = call_598037.call(path_598038, query_598039, nil, nil, body_598040)

var cloudmonitoringTimeseriesList* = Call_CloudmonitoringTimeseriesList_598015(
    name: "cloudmonitoringTimeseriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/timeseries/{metric}",
    validator: validate_CloudmonitoringTimeseriesList_598016,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesList_598017, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesWrite_598041 = ref object of OpenApiRestCall_597424
proc url_CloudmonitoringTimeseriesWrite_598043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudmonitoringTimeseriesWrite_598042(path: JsonNode;
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
  var valid_598044 = path.getOrDefault("project")
  valid_598044 = validateParameter(valid_598044, JString, required = true,
                                 default = nil)
  if valid_598044 != nil:
    section.add "project", valid_598044
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
  var valid_598045 = query.getOrDefault("fields")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "fields", valid_598045
  var valid_598046 = query.getOrDefault("quotaUser")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "quotaUser", valid_598046
  var valid_598047 = query.getOrDefault("alt")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = newJString("json"))
  if valid_598047 != nil:
    section.add "alt", valid_598047
  var valid_598048 = query.getOrDefault("oauth_token")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "oauth_token", valid_598048
  var valid_598049 = query.getOrDefault("userIp")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "userIp", valid_598049
  var valid_598050 = query.getOrDefault("key")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "key", valid_598050
  var valid_598051 = query.getOrDefault("prettyPrint")
  valid_598051 = validateParameter(valid_598051, JBool, required = false,
                                 default = newJBool(true))
  if valid_598051 != nil:
    section.add "prettyPrint", valid_598051
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

proc call*(call_598053: Call_CloudmonitoringTimeseriesWrite_598041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Put data points to one or more time series for one or more metrics. If a time series does not exist, a new time series will be created. It is not allowed to write a time series point that is older than the existing youngest point of that time series. Points that are older than the existing youngest point of that time series will be discarded silently. Therefore, users should make sure that points of a time series are written sequentially in the order of their end time.
  ## 
  let valid = call_598053.validator(path, query, header, formData, body)
  let scheme = call_598053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598053.url(scheme.get, call_598053.host, call_598053.base,
                         call_598053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598053, url, valid)

proc call*(call_598054: Call_CloudmonitoringTimeseriesWrite_598041;
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
  var path_598055 = newJObject()
  var query_598056 = newJObject()
  var body_598057 = newJObject()
  add(query_598056, "fields", newJString(fields))
  add(query_598056, "quotaUser", newJString(quotaUser))
  add(query_598056, "alt", newJString(alt))
  add(query_598056, "oauth_token", newJString(oauthToken))
  add(query_598056, "userIp", newJString(userIp))
  add(query_598056, "key", newJString(key))
  add(path_598055, "project", newJString(project))
  if body != nil:
    body_598057 = body
  add(query_598056, "prettyPrint", newJBool(prettyPrint))
  result = call_598054.call(path_598055, query_598056, nil, nil, body_598057)

var cloudmonitoringTimeseriesWrite* = Call_CloudmonitoringTimeseriesWrite_598041(
    name: "cloudmonitoringTimeseriesWrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/timeseries:write",
    validator: validate_CloudmonitoringTimeseriesWrite_598042,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesWrite_598043, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesDescriptorsList_598058 = ref object of OpenApiRestCall_597424
proc url_CloudmonitoringTimeseriesDescriptorsList_598060(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudmonitoringTimeseriesDescriptorsList_598059(path: JsonNode;
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
  var valid_598061 = path.getOrDefault("metric")
  valid_598061 = validateParameter(valid_598061, JString, required = true,
                                 default = nil)
  if valid_598061 != nil:
    section.add "metric", valid_598061
  var valid_598062 = path.getOrDefault("project")
  valid_598062 = validateParameter(valid_598062, JString, required = true,
                                 default = nil)
  if valid_598062 != nil:
    section.add "project", valid_598062
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
  var valid_598063 = query.getOrDefault("aggregator")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = newJString("max"))
  if valid_598063 != nil:
    section.add "aggregator", valid_598063
  var valid_598064 = query.getOrDefault("fields")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "fields", valid_598064
  var valid_598065 = query.getOrDefault("pageToken")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "pageToken", valid_598065
  var valid_598066 = query.getOrDefault("quotaUser")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "quotaUser", valid_598066
  var valid_598067 = query.getOrDefault("oldest")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "oldest", valid_598067
  var valid_598068 = query.getOrDefault("alt")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = newJString("json"))
  if valid_598068 != nil:
    section.add "alt", valid_598068
  var valid_598069 = query.getOrDefault("timespan")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "timespan", valid_598069
  var valid_598070 = query.getOrDefault("oauth_token")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "oauth_token", valid_598070
  var valid_598071 = query.getOrDefault("userIp")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "userIp", valid_598071
  var valid_598072 = query.getOrDefault("key")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "key", valid_598072
  var valid_598073 = query.getOrDefault("labels")
  valid_598073 = validateParameter(valid_598073, JArray, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "labels", valid_598073
  var valid_598074 = query.getOrDefault("prettyPrint")
  valid_598074 = validateParameter(valid_598074, JBool, required = false,
                                 default = newJBool(true))
  if valid_598074 != nil:
    section.add "prettyPrint", valid_598074
  var valid_598075 = query.getOrDefault("count")
  valid_598075 = validateParameter(valid_598075, JInt, required = false,
                                 default = newJInt(100))
  if valid_598075 != nil:
    section.add "count", valid_598075
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_598076 = query.getOrDefault("youngest")
  valid_598076 = validateParameter(valid_598076, JString, required = true,
                                 default = nil)
  if valid_598076 != nil:
    section.add "youngest", valid_598076
  var valid_598077 = query.getOrDefault("window")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "window", valid_598077
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

proc call*(call_598079: Call_CloudmonitoringTimeseriesDescriptorsList_598058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the descriptors of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_598079.validator(path, query, header, formData, body)
  let scheme = call_598079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598079.url(scheme.get, call_598079.host, call_598079.base,
                         call_598079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598079, url, valid)

proc call*(call_598080: Call_CloudmonitoringTimeseriesDescriptorsList_598058;
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
  var path_598081 = newJObject()
  var query_598082 = newJObject()
  var body_598083 = newJObject()
  add(query_598082, "aggregator", newJString(aggregator))
  add(query_598082, "fields", newJString(fields))
  add(query_598082, "pageToken", newJString(pageToken))
  add(query_598082, "quotaUser", newJString(quotaUser))
  add(query_598082, "oldest", newJString(oldest))
  add(query_598082, "alt", newJString(alt))
  add(query_598082, "timespan", newJString(timespan))
  add(query_598082, "oauth_token", newJString(oauthToken))
  add(query_598082, "userIp", newJString(userIp))
  add(path_598081, "metric", newJString(metric))
  add(query_598082, "key", newJString(key))
  if labels != nil:
    query_598082.add "labels", labels
  add(path_598081, "project", newJString(project))
  if body != nil:
    body_598083 = body
  add(query_598082, "prettyPrint", newJBool(prettyPrint))
  add(query_598082, "count", newJInt(count))
  add(query_598082, "youngest", newJString(youngest))
  add(query_598082, "window", newJString(window))
  result = call_598080.call(path_598081, query_598082, nil, nil, body_598083)

var cloudmonitoringTimeseriesDescriptorsList* = Call_CloudmonitoringTimeseriesDescriptorsList_598058(
    name: "cloudmonitoringTimeseriesDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/timeseriesDescriptors/{metric}",
    validator: validate_CloudmonitoringTimeseriesDescriptorsList_598059,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesDescriptorsList_598060,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
