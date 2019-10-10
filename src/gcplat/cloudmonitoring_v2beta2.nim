
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudmonitoring"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudmonitoringMetricDescriptorsCreate_589015 = ref object of OpenApiRestCall_588457
proc url_CloudmonitoringMetricDescriptorsCreate_589017(protocol: Scheme;
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

proc validate_CloudmonitoringMetricDescriptorsCreate_589016(path: JsonNode;
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
  var valid_589018 = path.getOrDefault("project")
  valid_589018 = validateParameter(valid_589018, JString, required = true,
                                 default = nil)
  if valid_589018 != nil:
    section.add "project", valid_589018
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
  var valid_589019 = query.getOrDefault("fields")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "fields", valid_589019
  var valid_589020 = query.getOrDefault("quotaUser")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "quotaUser", valid_589020
  var valid_589021 = query.getOrDefault("alt")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = newJString("json"))
  if valid_589021 != nil:
    section.add "alt", valid_589021
  var valid_589022 = query.getOrDefault("oauth_token")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "oauth_token", valid_589022
  var valid_589023 = query.getOrDefault("userIp")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "userIp", valid_589023
  var valid_589024 = query.getOrDefault("key")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "key", valid_589024
  var valid_589025 = query.getOrDefault("prettyPrint")
  valid_589025 = validateParameter(valid_589025, JBool, required = false,
                                 default = newJBool(true))
  if valid_589025 != nil:
    section.add "prettyPrint", valid_589025
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

proc call*(call_589027: Call_CloudmonitoringMetricDescriptorsCreate_589015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new metric.
  ## 
  let valid = call_589027.validator(path, query, header, formData, body)
  let scheme = call_589027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589027.url(scheme.get, call_589027.host, call_589027.base,
                         call_589027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589027, url, valid)

proc call*(call_589028: Call_CloudmonitoringMetricDescriptorsCreate_589015;
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
  var path_589029 = newJObject()
  var query_589030 = newJObject()
  var body_589031 = newJObject()
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(query_589030, "alt", newJString(alt))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "userIp", newJString(userIp))
  add(query_589030, "key", newJString(key))
  add(path_589029, "project", newJString(project))
  if body != nil:
    body_589031 = body
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  result = call_589028.call(path_589029, query_589030, nil, nil, body_589031)

var cloudmonitoringMetricDescriptorsCreate* = Call_CloudmonitoringMetricDescriptorsCreate_589015(
    name: "cloudmonitoringMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsCreate_589016,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsCreate_589017,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsList_588725 = ref object of OpenApiRestCall_588457
proc url_CloudmonitoringMetricDescriptorsList_588727(protocol: Scheme;
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

proc validate_CloudmonitoringMetricDescriptorsList_588726(path: JsonNode;
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
  var valid_588853 = path.getOrDefault("project")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "project", valid_588853
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
  var valid_588854 = query.getOrDefault("fields")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "fields", valid_588854
  var valid_588855 = query.getOrDefault("pageToken")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "pageToken", valid_588855
  var valid_588856 = query.getOrDefault("quotaUser")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "quotaUser", valid_588856
  var valid_588870 = query.getOrDefault("alt")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("json"))
  if valid_588870 != nil:
    section.add "alt", valid_588870
  var valid_588871 = query.getOrDefault("query")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "query", valid_588871
  var valid_588872 = query.getOrDefault("oauth_token")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "oauth_token", valid_588872
  var valid_588873 = query.getOrDefault("userIp")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "userIp", valid_588873
  var valid_588874 = query.getOrDefault("key")
  valid_588874 = validateParameter(valid_588874, JString, required = false,
                                 default = nil)
  if valid_588874 != nil:
    section.add "key", valid_588874
  var valid_588875 = query.getOrDefault("prettyPrint")
  valid_588875 = validateParameter(valid_588875, JBool, required = false,
                                 default = newJBool(true))
  if valid_588875 != nil:
    section.add "prettyPrint", valid_588875
  var valid_588877 = query.getOrDefault("count")
  valid_588877 = validateParameter(valid_588877, JInt, required = false,
                                 default = newJInt(100))
  if valid_588877 != nil:
    section.add "count", valid_588877
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

proc call*(call_588901: Call_CloudmonitoringMetricDescriptorsList_588725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List metric descriptors that match the query. If the query is not set, then all of the metric descriptors will be returned. Large responses will be paginated, use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_588901.validator(path, query, header, formData, body)
  let scheme = call_588901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588901.url(scheme.get, call_588901.host, call_588901.base,
                         call_588901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588901, url, valid)

proc call*(call_588972: Call_CloudmonitoringMetricDescriptorsList_588725;
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
  var path_588973 = newJObject()
  var query_588975 = newJObject()
  var body_588976 = newJObject()
  add(query_588975, "fields", newJString(fields))
  add(query_588975, "pageToken", newJString(pageToken))
  add(query_588975, "quotaUser", newJString(quotaUser))
  add(query_588975, "alt", newJString(alt))
  add(query_588975, "query", newJString(query))
  add(query_588975, "oauth_token", newJString(oauthToken))
  add(query_588975, "userIp", newJString(userIp))
  add(query_588975, "key", newJString(key))
  add(path_588973, "project", newJString(project))
  if body != nil:
    body_588976 = body
  add(query_588975, "prettyPrint", newJBool(prettyPrint))
  add(query_588975, "count", newJInt(count))
  result = call_588972.call(path_588973, query_588975, nil, nil, body_588976)

var cloudmonitoringMetricDescriptorsList* = Call_CloudmonitoringMetricDescriptorsList_588725(
    name: "cloudmonitoringMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsList_588726,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsList_588727, schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsDelete_589032 = ref object of OpenApiRestCall_588457
proc url_CloudmonitoringMetricDescriptorsDelete_589034(protocol: Scheme;
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

proc validate_CloudmonitoringMetricDescriptorsDelete_589033(path: JsonNode;
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
  var valid_589035 = path.getOrDefault("metric")
  valid_589035 = validateParameter(valid_589035, JString, required = true,
                                 default = nil)
  if valid_589035 != nil:
    section.add "metric", valid_589035
  var valid_589036 = path.getOrDefault("project")
  valid_589036 = validateParameter(valid_589036, JString, required = true,
                                 default = nil)
  if valid_589036 != nil:
    section.add "project", valid_589036
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
  var valid_589037 = query.getOrDefault("fields")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "fields", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("userIp")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "userIp", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_CloudmonitoringMetricDescriptorsDelete_589032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an existing metric.
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_CloudmonitoringMetricDescriptorsDelete_589032;
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
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "userIp", newJString(userIp))
  add(path_589046, "metric", newJString(metric))
  add(query_589047, "key", newJString(key))
  add(path_589046, "project", newJString(project))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var cloudmonitoringMetricDescriptorsDelete* = Call_CloudmonitoringMetricDescriptorsDelete_589032(
    name: "cloudmonitoringMetricDescriptorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors/{metric}",
    validator: validate_CloudmonitoringMetricDescriptorsDelete_589033,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsDelete_589034,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesList_589048 = ref object of OpenApiRestCall_588457
proc url_CloudmonitoringTimeseriesList_589050(protocol: Scheme; host: string;
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

proc validate_CloudmonitoringTimeseriesList_589049(path: JsonNode; query: JsonNode;
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
  var valid_589051 = path.getOrDefault("metric")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "metric", valid_589051
  var valid_589052 = path.getOrDefault("project")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "project", valid_589052
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
  var valid_589053 = query.getOrDefault("aggregator")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("max"))
  if valid_589053 != nil:
    section.add "aggregator", valid_589053
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("pageToken")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "pageToken", valid_589055
  var valid_589056 = query.getOrDefault("quotaUser")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "quotaUser", valid_589056
  var valid_589057 = query.getOrDefault("oldest")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oldest", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("timespan")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "timespan", valid_589059
  var valid_589060 = query.getOrDefault("oauth_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "oauth_token", valid_589060
  var valid_589061 = query.getOrDefault("userIp")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "userIp", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("labels")
  valid_589063 = validateParameter(valid_589063, JArray, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "labels", valid_589063
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
  var valid_589065 = query.getOrDefault("count")
  valid_589065 = validateParameter(valid_589065, JInt, required = false,
                                 default = newJInt(6000))
  if valid_589065 != nil:
    section.add "count", valid_589065
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_589066 = query.getOrDefault("youngest")
  valid_589066 = validateParameter(valid_589066, JString, required = true,
                                 default = nil)
  if valid_589066 != nil:
    section.add "youngest", valid_589066
  var valid_589067 = query.getOrDefault("window")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "window", valid_589067
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

proc call*(call_589069: Call_CloudmonitoringTimeseriesList_589048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the data points of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_589069.validator(path, query, header, formData, body)
  let scheme = call_589069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589069.url(scheme.get, call_589069.host, call_589069.base,
                         call_589069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589069, url, valid)

proc call*(call_589070: Call_CloudmonitoringTimeseriesList_589048; metric: string;
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
  var path_589071 = newJObject()
  var query_589072 = newJObject()
  var body_589073 = newJObject()
  add(query_589072, "aggregator", newJString(aggregator))
  add(query_589072, "fields", newJString(fields))
  add(query_589072, "pageToken", newJString(pageToken))
  add(query_589072, "quotaUser", newJString(quotaUser))
  add(query_589072, "oldest", newJString(oldest))
  add(query_589072, "alt", newJString(alt))
  add(query_589072, "timespan", newJString(timespan))
  add(query_589072, "oauth_token", newJString(oauthToken))
  add(query_589072, "userIp", newJString(userIp))
  add(path_589071, "metric", newJString(metric))
  add(query_589072, "key", newJString(key))
  if labels != nil:
    query_589072.add "labels", labels
  add(path_589071, "project", newJString(project))
  if body != nil:
    body_589073 = body
  add(query_589072, "prettyPrint", newJBool(prettyPrint))
  add(query_589072, "count", newJInt(count))
  add(query_589072, "youngest", newJString(youngest))
  add(query_589072, "window", newJString(window))
  result = call_589070.call(path_589071, query_589072, nil, nil, body_589073)

var cloudmonitoringTimeseriesList* = Call_CloudmonitoringTimeseriesList_589048(
    name: "cloudmonitoringTimeseriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/timeseries/{metric}",
    validator: validate_CloudmonitoringTimeseriesList_589049,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesList_589050, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesWrite_589074 = ref object of OpenApiRestCall_588457
proc url_CloudmonitoringTimeseriesWrite_589076(protocol: Scheme; host: string;
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

proc validate_CloudmonitoringTimeseriesWrite_589075(path: JsonNode;
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
  var valid_589077 = path.getOrDefault("project")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "project", valid_589077
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
  var valid_589078 = query.getOrDefault("fields")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "fields", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("userIp")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "userIp", valid_589082
  var valid_589083 = query.getOrDefault("key")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "key", valid_589083
  var valid_589084 = query.getOrDefault("prettyPrint")
  valid_589084 = validateParameter(valid_589084, JBool, required = false,
                                 default = newJBool(true))
  if valid_589084 != nil:
    section.add "prettyPrint", valid_589084
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

proc call*(call_589086: Call_CloudmonitoringTimeseriesWrite_589074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Put data points to one or more time series for one or more metrics. If a time series does not exist, a new time series will be created. It is not allowed to write a time series point that is older than the existing youngest point of that time series. Points that are older than the existing youngest point of that time series will be discarded silently. Therefore, users should make sure that points of a time series are written sequentially in the order of their end time.
  ## 
  let valid = call_589086.validator(path, query, header, formData, body)
  let scheme = call_589086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589086.url(scheme.get, call_589086.host, call_589086.base,
                         call_589086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589086, url, valid)

proc call*(call_589087: Call_CloudmonitoringTimeseriesWrite_589074;
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
  var path_589088 = newJObject()
  var query_589089 = newJObject()
  var body_589090 = newJObject()
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "userIp", newJString(userIp))
  add(query_589089, "key", newJString(key))
  add(path_589088, "project", newJString(project))
  if body != nil:
    body_589090 = body
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  result = call_589087.call(path_589088, query_589089, nil, nil, body_589090)

var cloudmonitoringTimeseriesWrite* = Call_CloudmonitoringTimeseriesWrite_589074(
    name: "cloudmonitoringTimeseriesWrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/timeseries:write",
    validator: validate_CloudmonitoringTimeseriesWrite_589075,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesWrite_589076, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesDescriptorsList_589091 = ref object of OpenApiRestCall_588457
proc url_CloudmonitoringTimeseriesDescriptorsList_589093(protocol: Scheme;
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

proc validate_CloudmonitoringTimeseriesDescriptorsList_589092(path: JsonNode;
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
  var valid_589094 = path.getOrDefault("metric")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "metric", valid_589094
  var valid_589095 = path.getOrDefault("project")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "project", valid_589095
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
  var valid_589096 = query.getOrDefault("aggregator")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("max"))
  if valid_589096 != nil:
    section.add "aggregator", valid_589096
  var valid_589097 = query.getOrDefault("fields")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "fields", valid_589097
  var valid_589098 = query.getOrDefault("pageToken")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "pageToken", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("oldest")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "oldest", valid_589100
  var valid_589101 = query.getOrDefault("alt")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("json"))
  if valid_589101 != nil:
    section.add "alt", valid_589101
  var valid_589102 = query.getOrDefault("timespan")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "timespan", valid_589102
  var valid_589103 = query.getOrDefault("oauth_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "oauth_token", valid_589103
  var valid_589104 = query.getOrDefault("userIp")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "userIp", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("labels")
  valid_589106 = validateParameter(valid_589106, JArray, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "labels", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  var valid_589108 = query.getOrDefault("count")
  valid_589108 = validateParameter(valid_589108, JInt, required = false,
                                 default = newJInt(100))
  if valid_589108 != nil:
    section.add "count", valid_589108
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_589109 = query.getOrDefault("youngest")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "youngest", valid_589109
  var valid_589110 = query.getOrDefault("window")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "window", valid_589110
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

proc call*(call_589112: Call_CloudmonitoringTimeseriesDescriptorsList_589091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the descriptors of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_589112.validator(path, query, header, formData, body)
  let scheme = call_589112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589112.url(scheme.get, call_589112.host, call_589112.base,
                         call_589112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589112, url, valid)

proc call*(call_589113: Call_CloudmonitoringTimeseriesDescriptorsList_589091;
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
  var path_589114 = newJObject()
  var query_589115 = newJObject()
  var body_589116 = newJObject()
  add(query_589115, "aggregator", newJString(aggregator))
  add(query_589115, "fields", newJString(fields))
  add(query_589115, "pageToken", newJString(pageToken))
  add(query_589115, "quotaUser", newJString(quotaUser))
  add(query_589115, "oldest", newJString(oldest))
  add(query_589115, "alt", newJString(alt))
  add(query_589115, "timespan", newJString(timespan))
  add(query_589115, "oauth_token", newJString(oauthToken))
  add(query_589115, "userIp", newJString(userIp))
  add(path_589114, "metric", newJString(metric))
  add(query_589115, "key", newJString(key))
  if labels != nil:
    query_589115.add "labels", labels
  add(path_589114, "project", newJString(project))
  if body != nil:
    body_589116 = body
  add(query_589115, "prettyPrint", newJBool(prettyPrint))
  add(query_589115, "count", newJInt(count))
  add(query_589115, "youngest", newJString(youngest))
  add(query_589115, "window", newJString(window))
  result = call_589113.call(path_589114, query_589115, nil, nil, body_589116)

var cloudmonitoringTimeseriesDescriptorsList* = Call_CloudmonitoringTimeseriesDescriptorsList_589091(
    name: "cloudmonitoringTimeseriesDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/timeseriesDescriptors/{metric}",
    validator: validate_CloudmonitoringTimeseriesDescriptorsList_589092,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesDescriptorsList_589093,
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
