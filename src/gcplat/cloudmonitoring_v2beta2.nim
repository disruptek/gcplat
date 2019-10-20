
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudmonitoring"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudmonitoringMetricDescriptorsCreate_578915 = ref object of OpenApiRestCall_578355
proc url_CloudmonitoringMetricDescriptorsCreate_578917(protocol: Scheme;
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

proc validate_CloudmonitoringMetricDescriptorsCreate_578916(path: JsonNode;
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
  var valid_578918 = path.getOrDefault("project")
  valid_578918 = validateParameter(valid_578918, JString, required = true,
                                 default = nil)
  if valid_578918 != nil:
    section.add "project", valid_578918
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578919 = query.getOrDefault("key")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "key", valid_578919
  var valid_578920 = query.getOrDefault("prettyPrint")
  valid_578920 = validateParameter(valid_578920, JBool, required = false,
                                 default = newJBool(true))
  if valid_578920 != nil:
    section.add "prettyPrint", valid_578920
  var valid_578921 = query.getOrDefault("oauth_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "oauth_token", valid_578921
  var valid_578922 = query.getOrDefault("alt")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = newJString("json"))
  if valid_578922 != nil:
    section.add "alt", valid_578922
  var valid_578923 = query.getOrDefault("userIp")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "userIp", valid_578923
  var valid_578924 = query.getOrDefault("quotaUser")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "quotaUser", valid_578924
  var valid_578925 = query.getOrDefault("fields")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "fields", valid_578925
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

proc call*(call_578927: Call_CloudmonitoringMetricDescriptorsCreate_578915;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new metric.
  ## 
  let valid = call_578927.validator(path, query, header, formData, body)
  let scheme = call_578927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578927.url(scheme.get, call_578927.host, call_578927.base,
                         call_578927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578927, url, valid)

proc call*(call_578928: Call_CloudmonitoringMetricDescriptorsCreate_578915;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## cloudmonitoringMetricDescriptorsCreate
  ## Create a new metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : The project id. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578929 = newJObject()
  var query_578930 = newJObject()
  var body_578931 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "userIp", newJString(userIp))
  add(query_578930, "quotaUser", newJString(quotaUser))
  add(path_578929, "project", newJString(project))
  if body != nil:
    body_578931 = body
  add(query_578930, "fields", newJString(fields))
  result = call_578928.call(path_578929, query_578930, nil, nil, body_578931)

var cloudmonitoringMetricDescriptorsCreate* = Call_CloudmonitoringMetricDescriptorsCreate_578915(
    name: "cloudmonitoringMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsCreate_578916,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsCreate_578917,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsList_578625 = ref object of OpenApiRestCall_578355
proc url_CloudmonitoringMetricDescriptorsList_578627(protocol: Scheme;
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

proc validate_CloudmonitoringMetricDescriptorsList_578626(path: JsonNode;
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
  var valid_578753 = path.getOrDefault("project")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "project", valid_578753
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   count: JInt
  ##        : Maximum number of metric descriptors per page. Used for pagination. If not specified, count = 100.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   query: JString
  ##        : The query used to search against existing metrics. Separate keywords with a space; the service joins all keywords with AND, meaning that all keywords must match for a metric to be returned. If this field is omitted, all metrics are returned. If an empty string is passed with this field, no metrics are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578754 = query.getOrDefault("key")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "key", valid_578754
  var valid_578768 = query.getOrDefault("prettyPrint")
  valid_578768 = validateParameter(valid_578768, JBool, required = false,
                                 default = newJBool(true))
  if valid_578768 != nil:
    section.add "prettyPrint", valid_578768
  var valid_578769 = query.getOrDefault("oauth_token")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "oauth_token", valid_578769
  var valid_578771 = query.getOrDefault("count")
  valid_578771 = validateParameter(valid_578771, JInt, required = false,
                                 default = newJInt(100))
  if valid_578771 != nil:
    section.add "count", valid_578771
  var valid_578772 = query.getOrDefault("alt")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = newJString("json"))
  if valid_578772 != nil:
    section.add "alt", valid_578772
  var valid_578773 = query.getOrDefault("userIp")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "userIp", valid_578773
  var valid_578774 = query.getOrDefault("quotaUser")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "quotaUser", valid_578774
  var valid_578775 = query.getOrDefault("pageToken")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "pageToken", valid_578775
  var valid_578776 = query.getOrDefault("query")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "query", valid_578776
  var valid_578777 = query.getOrDefault("fields")
  valid_578777 = validateParameter(valid_578777, JString, required = false,
                                 default = nil)
  if valid_578777 != nil:
    section.add "fields", valid_578777
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

proc call*(call_578801: Call_CloudmonitoringMetricDescriptorsList_578625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List metric descriptors that match the query. If the query is not set, then all of the metric descriptors will be returned. Large responses will be paginated, use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_578801.validator(path, query, header, formData, body)
  let scheme = call_578801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578801.url(scheme.get, call_578801.host, call_578801.base,
                         call_578801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578801, url, valid)

proc call*(call_578872: Call_CloudmonitoringMetricDescriptorsList_578625;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; count: int = 100; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          body: JsonNode = nil; query: string = ""; fields: string = ""): Recallable =
  ## cloudmonitoringMetricDescriptorsList
  ## List metric descriptors that match the query. If the query is not set, then all of the metric descriptors will be returned. Large responses will be paginated, use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   count: int
  ##        : Maximum number of metric descriptors per page. Used for pagination. If not specified, count = 100.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   project: string (required)
  ##          : The project id. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   query: string
  ##        : The query used to search against existing metrics. Separate keywords with a space; the service joins all keywords with AND, meaning that all keywords must match for a metric to be returned. If this field is omitted, all metrics are returned. If an empty string is passed with this field, no metrics are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578873 = newJObject()
  var query_578875 = newJObject()
  var body_578876 = newJObject()
  add(query_578875, "key", newJString(key))
  add(query_578875, "prettyPrint", newJBool(prettyPrint))
  add(query_578875, "oauth_token", newJString(oauthToken))
  add(query_578875, "count", newJInt(count))
  add(query_578875, "alt", newJString(alt))
  add(query_578875, "userIp", newJString(userIp))
  add(query_578875, "quotaUser", newJString(quotaUser))
  add(query_578875, "pageToken", newJString(pageToken))
  add(path_578873, "project", newJString(project))
  if body != nil:
    body_578876 = body
  add(query_578875, "query", newJString(query))
  add(query_578875, "fields", newJString(fields))
  result = call_578872.call(path_578873, query_578875, nil, nil, body_578876)

var cloudmonitoringMetricDescriptorsList* = Call_CloudmonitoringMetricDescriptorsList_578625(
    name: "cloudmonitoringMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors",
    validator: validate_CloudmonitoringMetricDescriptorsList_578626,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsList_578627, schemes: {Scheme.Https})
type
  Call_CloudmonitoringMetricDescriptorsDelete_578932 = ref object of OpenApiRestCall_578355
proc url_CloudmonitoringMetricDescriptorsDelete_578934(protocol: Scheme;
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

proc validate_CloudmonitoringMetricDescriptorsDelete_578933(path: JsonNode;
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
  var valid_578935 = path.getOrDefault("metric")
  valid_578935 = validateParameter(valid_578935, JString, required = true,
                                 default = nil)
  if valid_578935 != nil:
    section.add "metric", valid_578935
  var valid_578936 = path.getOrDefault("project")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "project", valid_578936
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578937 = query.getOrDefault("key")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "key", valid_578937
  var valid_578938 = query.getOrDefault("prettyPrint")
  valid_578938 = validateParameter(valid_578938, JBool, required = false,
                                 default = newJBool(true))
  if valid_578938 != nil:
    section.add "prettyPrint", valid_578938
  var valid_578939 = query.getOrDefault("oauth_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "oauth_token", valid_578939
  var valid_578940 = query.getOrDefault("alt")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("json"))
  if valid_578940 != nil:
    section.add "alt", valid_578940
  var valid_578941 = query.getOrDefault("userIp")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "userIp", valid_578941
  var valid_578942 = query.getOrDefault("quotaUser")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "quotaUser", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578944: Call_CloudmonitoringMetricDescriptorsDelete_578932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an existing metric.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_CloudmonitoringMetricDescriptorsDelete_578932;
          metric: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## cloudmonitoringMetricDescriptorsDelete
  ## Delete an existing metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   metric: string (required)
  ##         : Name of the metric.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : The project ID to which the metric belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(path_578946, "metric", newJString(metric))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "userIp", newJString(userIp))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(path_578946, "project", newJString(project))
  add(query_578947, "fields", newJString(fields))
  result = call_578945.call(path_578946, query_578947, nil, nil, nil)

var cloudmonitoringMetricDescriptorsDelete* = Call_CloudmonitoringMetricDescriptorsDelete_578932(
    name: "cloudmonitoringMetricDescriptorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/metricDescriptors/{metric}",
    validator: validate_CloudmonitoringMetricDescriptorsDelete_578933,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringMetricDescriptorsDelete_578934,
    schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesList_578948 = ref object of OpenApiRestCall_578355
proc url_CloudmonitoringTimeseriesList_578950(protocol: Scheme; host: string;
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

proc validate_CloudmonitoringTimeseriesList_578949(path: JsonNode; query: JsonNode;
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
  var valid_578951 = path.getOrDefault("metric")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "metric", valid_578951
  var valid_578952 = path.getOrDefault("project")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "project", valid_578952
  result.add "path", section
  ## parameters in `query` object:
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   count: JInt
  ##        : Maximum number of data points per page, which is used for pagination of results.
  ##   window: JString
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ##   timespan: JString
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oldest: JString
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   youngest: JString (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   aggregator: JString
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578953 = query.getOrDefault("key")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "key", valid_578953
  var valid_578954 = query.getOrDefault("labels")
  valid_578954 = validateParameter(valid_578954, JArray, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "labels", valid_578954
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
  var valid_578957 = query.getOrDefault("count")
  valid_578957 = validateParameter(valid_578957, JInt, required = false,
                                 default = newJInt(6000))
  if valid_578957 != nil:
    section.add "count", valid_578957
  var valid_578958 = query.getOrDefault("window")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "window", valid_578958
  var valid_578959 = query.getOrDefault("timespan")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "timespan", valid_578959
  var valid_578960 = query.getOrDefault("oldest")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "oldest", valid_578960
  var valid_578961 = query.getOrDefault("alt")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("json"))
  if valid_578961 != nil:
    section.add "alt", valid_578961
  var valid_578962 = query.getOrDefault("userIp")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "userIp", valid_578962
  var valid_578963 = query.getOrDefault("quotaUser")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "quotaUser", valid_578963
  var valid_578964 = query.getOrDefault("pageToken")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "pageToken", valid_578964
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_578965 = query.getOrDefault("youngest")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "youngest", valid_578965
  var valid_578966 = query.getOrDefault("aggregator")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("max"))
  if valid_578966 != nil:
    section.add "aggregator", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
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

proc call*(call_578969: Call_CloudmonitoringTimeseriesList_578948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the data points of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_578969.validator(path, query, header, formData, body)
  let scheme = call_578969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578969.url(scheme.get, call_578969.host, call_578969.base,
                         call_578969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578969, url, valid)

proc call*(call_578970: Call_CloudmonitoringTimeseriesList_578948; metric: string;
          youngest: string; project: string; key: string = ""; labels: JsonNode = nil;
          prettyPrint: bool = true; oauthToken: string = ""; count: int = 6000;
          window: string = ""; timespan: string = ""; oldest: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; aggregator: string = "max"; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## cloudmonitoringTimeseriesList
  ## List the data points of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JArray
  ##         : A collection of labels for the matching time series, which are represented as:  
  ## - key==value: key equals the value 
  ## - key=~value: key regex matches the value 
  ## - key!=value: key does not equal the value 
  ## - key!~value: key regex does not match the value  For example, to list all of the time series descriptors for the region us-central1, you could specify:
  ## label=cloud.googleapis.com%2Flocation=~us-central1.*
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   metric: string (required)
  ##         : Metric names are protocol-free URLs as listed in the Supported Metrics page. For example, compute.googleapis.com/instance/disk/read_ops_count.
  ##   count: int
  ##        : Maximum number of data points per page, which is used for pagination of results.
  ##   window: string
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ##   timespan: string
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oldest: string
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   youngest: string (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   project: string (required)
  ##          : The project ID to which this time series belongs. The value can be the numeric project ID or string-based project name.
  ##   aggregator: string
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578971 = newJObject()
  var query_578972 = newJObject()
  var body_578973 = newJObject()
  add(query_578972, "key", newJString(key))
  if labels != nil:
    query_578972.add "labels", labels
  add(query_578972, "prettyPrint", newJBool(prettyPrint))
  add(query_578972, "oauth_token", newJString(oauthToken))
  add(path_578971, "metric", newJString(metric))
  add(query_578972, "count", newJInt(count))
  add(query_578972, "window", newJString(window))
  add(query_578972, "timespan", newJString(timespan))
  add(query_578972, "oldest", newJString(oldest))
  add(query_578972, "alt", newJString(alt))
  add(query_578972, "userIp", newJString(userIp))
  add(query_578972, "quotaUser", newJString(quotaUser))
  add(query_578972, "pageToken", newJString(pageToken))
  add(query_578972, "youngest", newJString(youngest))
  add(path_578971, "project", newJString(project))
  add(query_578972, "aggregator", newJString(aggregator))
  if body != nil:
    body_578973 = body
  add(query_578972, "fields", newJString(fields))
  result = call_578970.call(path_578971, query_578972, nil, nil, body_578973)

var cloudmonitoringTimeseriesList* = Call_CloudmonitoringTimeseriesList_578948(
    name: "cloudmonitoringTimeseriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/timeseries/{metric}",
    validator: validate_CloudmonitoringTimeseriesList_578949,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesList_578950, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesWrite_578974 = ref object of OpenApiRestCall_578355
proc url_CloudmonitoringTimeseriesWrite_578976(protocol: Scheme; host: string;
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

proc validate_CloudmonitoringTimeseriesWrite_578975(path: JsonNode;
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
  var valid_578977 = path.getOrDefault("project")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "project", valid_578977
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578978 = query.getOrDefault("key")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "key", valid_578978
  var valid_578979 = query.getOrDefault("prettyPrint")
  valid_578979 = validateParameter(valid_578979, JBool, required = false,
                                 default = newJBool(true))
  if valid_578979 != nil:
    section.add "prettyPrint", valid_578979
  var valid_578980 = query.getOrDefault("oauth_token")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "oauth_token", valid_578980
  var valid_578981 = query.getOrDefault("alt")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("json"))
  if valid_578981 != nil:
    section.add "alt", valid_578981
  var valid_578982 = query.getOrDefault("userIp")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "userIp", valid_578982
  var valid_578983 = query.getOrDefault("quotaUser")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "quotaUser", valid_578983
  var valid_578984 = query.getOrDefault("fields")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "fields", valid_578984
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

proc call*(call_578986: Call_CloudmonitoringTimeseriesWrite_578974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Put data points to one or more time series for one or more metrics. If a time series does not exist, a new time series will be created. It is not allowed to write a time series point that is older than the existing youngest point of that time series. Points that are older than the existing youngest point of that time series will be discarded silently. Therefore, users should make sure that points of a time series are written sequentially in the order of their end time.
  ## 
  let valid = call_578986.validator(path, query, header, formData, body)
  let scheme = call_578986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578986.url(scheme.get, call_578986.host, call_578986.base,
                         call_578986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578986, url, valid)

proc call*(call_578987: Call_CloudmonitoringTimeseriesWrite_578974;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## cloudmonitoringTimeseriesWrite
  ## Put data points to one or more time series for one or more metrics. If a time series does not exist, a new time series will be created. It is not allowed to write a time series point that is older than the existing youngest point of that time series. Points that are older than the existing youngest point of that time series will be discarded silently. Therefore, users should make sure that points of a time series are written sequentially in the order of their end time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : The project ID. The value can be the numeric project ID or string-based project name.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578988 = newJObject()
  var query_578989 = newJObject()
  var body_578990 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "userIp", newJString(userIp))
  add(query_578989, "quotaUser", newJString(quotaUser))
  add(path_578988, "project", newJString(project))
  if body != nil:
    body_578990 = body
  add(query_578989, "fields", newJString(fields))
  result = call_578987.call(path_578988, query_578989, nil, nil, body_578990)

var cloudmonitoringTimeseriesWrite* = Call_CloudmonitoringTimeseriesWrite_578974(
    name: "cloudmonitoringTimeseriesWrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/timeseries:write",
    validator: validate_CloudmonitoringTimeseriesWrite_578975,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesWrite_578976, schemes: {Scheme.Https})
type
  Call_CloudmonitoringTimeseriesDescriptorsList_578991 = ref object of OpenApiRestCall_578355
proc url_CloudmonitoringTimeseriesDescriptorsList_578993(protocol: Scheme;
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

proc validate_CloudmonitoringTimeseriesDescriptorsList_578992(path: JsonNode;
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
  var valid_578994 = path.getOrDefault("metric")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "metric", valid_578994
  var valid_578995 = path.getOrDefault("project")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "project", valid_578995
  result.add "path", section
  ## parameters in `query` object:
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   count: JInt
  ##        : Maximum number of time series descriptors per page. Used for pagination. If not specified, count = 100.
  ##   window: JString
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ##   timespan: JString
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oldest: JString
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   youngest: JString (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   aggregator: JString
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("labels")
  valid_578997 = validateParameter(valid_578997, JArray, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "labels", valid_578997
  var valid_578998 = query.getOrDefault("prettyPrint")
  valid_578998 = validateParameter(valid_578998, JBool, required = false,
                                 default = newJBool(true))
  if valid_578998 != nil:
    section.add "prettyPrint", valid_578998
  var valid_578999 = query.getOrDefault("oauth_token")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "oauth_token", valid_578999
  var valid_579000 = query.getOrDefault("count")
  valid_579000 = validateParameter(valid_579000, JInt, required = false,
                                 default = newJInt(100))
  if valid_579000 != nil:
    section.add "count", valid_579000
  var valid_579001 = query.getOrDefault("window")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "window", valid_579001
  var valid_579002 = query.getOrDefault("timespan")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "timespan", valid_579002
  var valid_579003 = query.getOrDefault("oldest")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oldest", valid_579003
  var valid_579004 = query.getOrDefault("alt")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("json"))
  if valid_579004 != nil:
    section.add "alt", valid_579004
  var valid_579005 = query.getOrDefault("userIp")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "userIp", valid_579005
  var valid_579006 = query.getOrDefault("quotaUser")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "quotaUser", valid_579006
  var valid_579007 = query.getOrDefault("pageToken")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "pageToken", valid_579007
  assert query != nil,
        "query argument is necessary due to required `youngest` field"
  var valid_579008 = query.getOrDefault("youngest")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "youngest", valid_579008
  var valid_579009 = query.getOrDefault("aggregator")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("max"))
  if valid_579009 != nil:
    section.add "aggregator", valid_579009
  var valid_579010 = query.getOrDefault("fields")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "fields", valid_579010
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

proc call*(call_579012: Call_CloudmonitoringTimeseriesDescriptorsList_578991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the descriptors of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ## 
  let valid = call_579012.validator(path, query, header, formData, body)
  let scheme = call_579012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579012.url(scheme.get, call_579012.host, call_579012.base,
                         call_579012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579012, url, valid)

proc call*(call_579013: Call_CloudmonitoringTimeseriesDescriptorsList_578991;
          metric: string; youngest: string; project: string; key: string = "";
          labels: JsonNode = nil; prettyPrint: bool = true; oauthToken: string = "";
          count: int = 100; window: string = ""; timespan: string = ""; oldest: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; aggregator: string = "max"; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## cloudmonitoringTimeseriesDescriptorsList
  ## List the descriptors of the time series that match the metric and labels values and that have data points in the interval. Large responses are paginated; use the nextPageToken returned in the response to request subsequent pages of results by setting the pageToken query parameter to the value of the nextPageToken.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JArray
  ##         : A collection of labels for the matching time series, which are represented as:  
  ## - key==value: key equals the value 
  ## - key=~value: key regex matches the value 
  ## - key!=value: key does not equal the value 
  ## - key!~value: key regex does not match the value  For example, to list all of the time series descriptors for the region us-central1, you could specify:
  ## label=cloud.googleapis.com%2Flocation=~us-central1.*
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   metric: string (required)
  ##         : Metric names are protocol-free URLs as listed in the Supported Metrics page. For example, compute.googleapis.com/instance/disk/read_ops_count.
  ##   count: int
  ##        : Maximum number of time series descriptors per page. Used for pagination. If not specified, count = 100.
  ##   window: string
  ##         : The sampling window. At most one data point will be returned for each window in the requested time interval. This parameter is only valid for non-cumulative metric types. Units:  
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ##   timespan: string
  ##           : Length of the time interval to query, which is an alternative way to declare the interval: (youngest - timespan, youngest]. The timespan and oldest parameters should not be used together. Units:  
  ## - s: second 
  ## - m: minute 
  ## - h: hour 
  ## - d: day 
  ## - w: week  Examples: 2s, 3m, 4w. Only one unit is allowed, for example: 2w3d is not allowed; you should use 17d instead.
  ## 
  ## If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest].
  ##   oldest: string
  ##         : Start of the time interval (exclusive), which is expressed as an RFC 3339 timestamp. If neither oldest nor timespan is specified, the default time interval will be (youngest - 4 hours, youngest]
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : The pagination token, which is used to page through large result sets. Set this value to the value of the nextPageToken to retrieve the next page of results.
  ##   youngest: string (required)
  ##           : End of the time interval (inclusive), which is expressed as an RFC 3339 timestamp.
  ##   project: string (required)
  ##          : The project ID to which this time series belongs. The value can be the numeric project ID or string-based project name.
  ##   aggregator: string
  ##             : The aggregation function that will reduce the data points in each window to a single point. This parameter is only valid for non-cumulative metrics with a value type of INT64 or DOUBLE.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579014 = newJObject()
  var query_579015 = newJObject()
  var body_579016 = newJObject()
  add(query_579015, "key", newJString(key))
  if labels != nil:
    query_579015.add "labels", labels
  add(query_579015, "prettyPrint", newJBool(prettyPrint))
  add(query_579015, "oauth_token", newJString(oauthToken))
  add(path_579014, "metric", newJString(metric))
  add(query_579015, "count", newJInt(count))
  add(query_579015, "window", newJString(window))
  add(query_579015, "timespan", newJString(timespan))
  add(query_579015, "oldest", newJString(oldest))
  add(query_579015, "alt", newJString(alt))
  add(query_579015, "userIp", newJString(userIp))
  add(query_579015, "quotaUser", newJString(quotaUser))
  add(query_579015, "pageToken", newJString(pageToken))
  add(query_579015, "youngest", newJString(youngest))
  add(path_579014, "project", newJString(project))
  add(query_579015, "aggregator", newJString(aggregator))
  if body != nil:
    body_579016 = body
  add(query_579015, "fields", newJString(fields))
  result = call_579013.call(path_579014, query_579015, nil, nil, body_579016)

var cloudmonitoringTimeseriesDescriptorsList* = Call_CloudmonitoringTimeseriesDescriptorsList_578991(
    name: "cloudmonitoringTimeseriesDescriptorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/timeseriesDescriptors/{metric}",
    validator: validate_CloudmonitoringTimeseriesDescriptorsList_578992,
    base: "/cloudmonitoring/v2beta2/projects",
    url: url_CloudmonitoringTimeseriesDescriptorsList_578993,
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
