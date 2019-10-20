
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Analytics
## version: v2.4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Views and manages your Google Analytics data.
## 
## https://developers.google.com/analytics/
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
  gcpServiceName = "analytics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsDataGet_578626 = ref object of OpenApiRestCall_578355
proc url_AnalyticsDataGet_578628(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataGet_578627(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns Analytics report data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   segment: JString
  ##          : An Analytics advanced segment to be applied to the report data.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified to retrieve a valid Analytics report.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dimensions: JString
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to the report data.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   start-date: JString (required)
  ##             : Start date for fetching report data. All requests should specify a start date formatted as YYYY-MM-DD.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving report data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   end-date: JString (required)
  ##           : End date for fetching report data. All requests should specify an end date formatted as YYYY-MM-DD.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the report data.
  section = newJObject()
  var valid_578740 = query.getOrDefault("key")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "key", valid_578740
  var valid_578741 = query.getOrDefault("segment")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "segment", valid_578741
  var valid_578755 = query.getOrDefault("prettyPrint")
  valid_578755 = validateParameter(valid_578755, JBool, required = false,
                                 default = newJBool(false))
  if valid_578755 != nil:
    section.add "prettyPrint", valid_578755
  var valid_578756 = query.getOrDefault("oauth_token")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "oauth_token", valid_578756
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_578757 = query.getOrDefault("metrics")
  valid_578757 = validateParameter(valid_578757, JString, required = true,
                                 default = nil)
  if valid_578757 != nil:
    section.add "metrics", valid_578757
  var valid_578758 = query.getOrDefault("alt")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = newJString("atom"))
  if valid_578758 != nil:
    section.add "alt", valid_578758
  var valid_578759 = query.getOrDefault("userIp")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "userIp", valid_578759
  var valid_578760 = query.getOrDefault("quotaUser")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "quotaUser", valid_578760
  var valid_578761 = query.getOrDefault("dimensions")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "dimensions", valid_578761
  var valid_578762 = query.getOrDefault("start-index")
  valid_578762 = validateParameter(valid_578762, JInt, required = false, default = nil)
  if valid_578762 != nil:
    section.add "start-index", valid_578762
  var valid_578763 = query.getOrDefault("filters")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "filters", valid_578763
  var valid_578764 = query.getOrDefault("max-results")
  valid_578764 = validateParameter(valid_578764, JInt, required = false, default = nil)
  if valid_578764 != nil:
    section.add "max-results", valid_578764
  var valid_578765 = query.getOrDefault("start-date")
  valid_578765 = validateParameter(valid_578765, JString, required = true,
                                 default = nil)
  if valid_578765 != nil:
    section.add "start-date", valid_578765
  var valid_578766 = query.getOrDefault("ids")
  valid_578766 = validateParameter(valid_578766, JString, required = true,
                                 default = nil)
  if valid_578766 != nil:
    section.add "ids", valid_578766
  var valid_578767 = query.getOrDefault("end-date")
  valid_578767 = validateParameter(valid_578767, JString, required = true,
                                 default = nil)
  if valid_578767 != nil:
    section.add "end-date", valid_578767
  var valid_578768 = query.getOrDefault("fields")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "fields", valid_578768
  var valid_578769 = query.getOrDefault("sort")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "sort", valid_578769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578792: Call_AnalyticsDataGet_578626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics report data for a view (profile).
  ## 
  let valid = call_578792.validator(path, query, header, formData, body)
  let scheme = call_578792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578792.url(scheme.get, call_578792.host, call_578792.base,
                         call_578792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578792, url, valid)

proc call*(call_578863: Call_AnalyticsDataGet_578626; metrics: string;
          startDate: string; ids: string; endDate: string; key: string = "";
          segment: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "atom"; userIp: string = ""; quotaUser: string = "";
          dimensions: string = ""; startIndex: int = 0; filters: string = "";
          maxResults: int = 0; fields: string = ""; sort: string = ""): Recallable =
  ## analyticsDataGet
  ## Returns Analytics report data for a view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   segment: string
  ##          : An Analytics advanced segment to be applied to the report data.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   metrics: string (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified to retrieve a valid Analytics report.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dimensions: string
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to the report data.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   startDate: string (required)
  ##            : Start date for fetching report data. All requests should specify a start date formatted as YYYY-MM-DD.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving report data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   endDate: string (required)
  ##          : End date for fetching report data. All requests should specify an end date formatted as YYYY-MM-DD.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the report data.
  var query_578864 = newJObject()
  add(query_578864, "key", newJString(key))
  add(query_578864, "segment", newJString(segment))
  add(query_578864, "prettyPrint", newJBool(prettyPrint))
  add(query_578864, "oauth_token", newJString(oauthToken))
  add(query_578864, "metrics", newJString(metrics))
  add(query_578864, "alt", newJString(alt))
  add(query_578864, "userIp", newJString(userIp))
  add(query_578864, "quotaUser", newJString(quotaUser))
  add(query_578864, "dimensions", newJString(dimensions))
  add(query_578864, "start-index", newJInt(startIndex))
  add(query_578864, "filters", newJString(filters))
  add(query_578864, "max-results", newJInt(maxResults))
  add(query_578864, "start-date", newJString(startDate))
  add(query_578864, "ids", newJString(ids))
  add(query_578864, "end-date", newJString(endDate))
  add(query_578864, "fields", newJString(fields))
  add(query_578864, "sort", newJString(sort))
  result = call_578863.call(nil, query_578864, nil, nil, nil)

var analyticsDataGet* = Call_AnalyticsDataGet_578626(name: "analyticsDataGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/data",
    validator: validate_AnalyticsDataGet_578627, base: "/analytics/v2.4",
    url: url_AnalyticsDataGet_578628, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountsList_578904 = ref object of OpenApiRestCall_578355
proc url_AnalyticsManagementAccountsList_578906(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountsList_578905(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all accounts to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   start-index: JInt
  ##              : An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of accounts to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578907 = query.getOrDefault("key")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "key", valid_578907
  var valid_578908 = query.getOrDefault("prettyPrint")
  valid_578908 = validateParameter(valid_578908, JBool, required = false,
                                 default = newJBool(false))
  if valid_578908 != nil:
    section.add "prettyPrint", valid_578908
  var valid_578909 = query.getOrDefault("oauth_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "oauth_token", valid_578909
  var valid_578910 = query.getOrDefault("alt")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("atom"))
  if valid_578910 != nil:
    section.add "alt", valid_578910
  var valid_578911 = query.getOrDefault("userIp")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "userIp", valid_578911
  var valid_578912 = query.getOrDefault("quotaUser")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "quotaUser", valid_578912
  var valid_578913 = query.getOrDefault("start-index")
  valid_578913 = validateParameter(valid_578913, JInt, required = false, default = nil)
  if valid_578913 != nil:
    section.add "start-index", valid_578913
  var valid_578914 = query.getOrDefault("max-results")
  valid_578914 = validateParameter(valid_578914, JInt, required = false, default = nil)
  if valid_578914 != nil:
    section.add "max-results", valid_578914
  var valid_578915 = query.getOrDefault("fields")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "fields", valid_578915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578916: Call_AnalyticsManagementAccountsList_578904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all accounts to which the user has access.
  ## 
  let valid = call_578916.validator(path, query, header, formData, body)
  let scheme = call_578916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578916.url(scheme.get, call_578916.host, call_578916.base,
                         call_578916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578916, url, valid)

proc call*(call_578917: Call_AnalyticsManagementAccountsList_578904;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "atom"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementAccountsList
  ## Lists all accounts to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of accounts to include in this response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578918 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "userIp", newJString(userIp))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(query_578918, "start-index", newJInt(startIndex))
  add(query_578918, "max-results", newJInt(maxResults))
  add(query_578918, "fields", newJString(fields))
  result = call_578917.call(nil, query_578918, nil, nil, nil)

var analyticsManagementAccountsList* = Call_AnalyticsManagementAccountsList_578904(
    name: "analyticsManagementAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts",
    validator: validate_AnalyticsManagementAccountsList_578905,
    base: "/analytics/v2.4", url: url_AnalyticsManagementAccountsList_578906,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesList_578919 = ref object of OpenApiRestCall_578355
proc url_AnalyticsManagementWebpropertiesList_578921(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesList_578920(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists web properties to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve web properties for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578936 = path.getOrDefault("accountId")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "accountId", valid_578936
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of web properties to include in this response.
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
                                 default = newJBool(false))
  if valid_578938 != nil:
    section.add "prettyPrint", valid_578938
  var valid_578939 = query.getOrDefault("oauth_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "oauth_token", valid_578939
  var valid_578940 = query.getOrDefault("alt")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("atom"))
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
  var valid_578943 = query.getOrDefault("start-index")
  valid_578943 = validateParameter(valid_578943, JInt, required = false, default = nil)
  if valid_578943 != nil:
    section.add "start-index", valid_578943
  var valid_578944 = query.getOrDefault("max-results")
  valid_578944 = validateParameter(valid_578944, JInt, required = false, default = nil)
  if valid_578944 != nil:
    section.add "max-results", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_AnalyticsManagementWebpropertiesList_578919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web properties to which the user has access.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_AnalyticsManagementWebpropertiesList_578919;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "atom"; userIp: string = "";
          quotaUser: string = ""; startIndex: int = 0; maxResults: int = 0;
          fields: string = ""): Recallable =
  ## analyticsManagementWebpropertiesList
  ## Lists web properties to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of web properties to include in this response.
  ##   accountId: string (required)
  ##            : Account ID to retrieve web properties for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "userIp", newJString(userIp))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(query_578949, "start-index", newJInt(startIndex))
  add(query_578949, "max-results", newJInt(maxResults))
  add(path_578948, "accountId", newJString(accountId))
  add(query_578949, "fields", newJString(fields))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var analyticsManagementWebpropertiesList* = Call_AnalyticsManagementWebpropertiesList_578919(
    name: "analyticsManagementWebpropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesList_578920,
    base: "/analytics/v2.4", url: url_AnalyticsManagementWebpropertiesList_578921,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesList_578950 = ref object of OpenApiRestCall_578355
proc url_AnalyticsManagementProfilesList_578952(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesList_578951(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists views (profiles) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  ##   accountId: JString (required)
  ##            : Account ID for the views (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_578953 = path.getOrDefault("webPropertyId")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "webPropertyId", valid_578953
  var valid_578954 = path.getOrDefault("accountId")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "accountId", valid_578954
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of views (profiles) to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("prettyPrint")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(false))
  if valid_578956 != nil:
    section.add "prettyPrint", valid_578956
  var valid_578957 = query.getOrDefault("oauth_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "oauth_token", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("atom"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("userIp")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "userIp", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("start-index")
  valid_578961 = validateParameter(valid_578961, JInt, required = false, default = nil)
  if valid_578961 != nil:
    section.add "start-index", valid_578961
  var valid_578962 = query.getOrDefault("max-results")
  valid_578962 = validateParameter(valid_578962, JInt, required = false, default = nil)
  if valid_578962 != nil:
    section.add "max-results", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578964: Call_AnalyticsManagementProfilesList_578950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists views (profiles) to which the user has access.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_AnalyticsManagementProfilesList_578950;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "atom";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementProfilesList
  ## Lists views (profiles) to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of views (profiles) to include in this response.
  ##   accountId: string (required)
  ##            : Account ID for the views (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578966 = newJObject()
  var query_578967 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(path_578966, "webPropertyId", newJString(webPropertyId))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "userIp", newJString(userIp))
  add(query_578967, "quotaUser", newJString(quotaUser))
  add(query_578967, "start-index", newJInt(startIndex))
  add(query_578967, "max-results", newJInt(maxResults))
  add(path_578966, "accountId", newJString(accountId))
  add(query_578967, "fields", newJString(fields))
  result = call_578965.call(path_578966, query_578967, nil, nil, nil)

var analyticsManagementProfilesList* = Call_AnalyticsManagementProfilesList_578950(
    name: "analyticsManagementProfilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesList_578951,
    base: "/analytics/v2.4", url: url_AnalyticsManagementProfilesList_578952,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsList_578968 = ref object of OpenApiRestCall_578355
proc url_AnalyticsManagementGoalsList_578970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsList_578969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists goals to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_578971 = path.getOrDefault("webPropertyId")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "webPropertyId", valid_578971
  var valid_578972 = path.getOrDefault("profileId")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "profileId", valid_578972
  var valid_578973 = path.getOrDefault("accountId")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "accountId", valid_578973
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   start-index: JInt
  ##              : An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of goals to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(false))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("atom"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("userIp")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "userIp", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("start-index")
  valid_578980 = validateParameter(valid_578980, JInt, required = false, default = nil)
  if valid_578980 != nil:
    section.add "start-index", valid_578980
  var valid_578981 = query.getOrDefault("max-results")
  valid_578981 = validateParameter(valid_578981, JInt, required = false, default = nil)
  if valid_578981 != nil:
    section.add "max-results", valid_578981
  var valid_578982 = query.getOrDefault("fields")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "fields", valid_578982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578983: Call_AnalyticsManagementGoalsList_578968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists goals to which the user has access.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_AnalyticsManagementGoalsList_578968;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "atom"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementGoalsList
  ## Lists goals to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of goals to include in this response.
  ##   accountId: string (required)
  ##            : Account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578985 = newJObject()
  var query_578986 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(path_578985, "webPropertyId", newJString(webPropertyId))
  add(path_578985, "profileId", newJString(profileId))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "userIp", newJString(userIp))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(query_578986, "start-index", newJInt(startIndex))
  add(query_578986, "max-results", newJInt(maxResults))
  add(path_578985, "accountId", newJString(accountId))
  add(query_578986, "fields", newJString(fields))
  result = call_578984.call(path_578985, query_578986, nil, nil, nil)

var analyticsManagementGoalsList* = Call_AnalyticsManagementGoalsList_578968(
    name: "analyticsManagementGoalsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsList_578969,
    base: "/analytics/v2.4", url: url_AnalyticsManagementGoalsList_578970,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementSegmentsList_578987 = ref object of OpenApiRestCall_578355
proc url_AnalyticsManagementSegmentsList_578989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementSegmentsList_578988(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists advanced segments to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   start-index: JInt
  ##              : An index of the first advanced segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of advanced segments to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(false))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("atom"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("userIp")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "userIp", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("start-index")
  valid_578996 = validateParameter(valid_578996, JInt, required = false, default = nil)
  if valid_578996 != nil:
    section.add "start-index", valid_578996
  var valid_578997 = query.getOrDefault("max-results")
  valid_578997 = validateParameter(valid_578997, JInt, required = false, default = nil)
  if valid_578997 != nil:
    section.add "max-results", valid_578997
  var valid_578998 = query.getOrDefault("fields")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "fields", valid_578998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578999: Call_AnalyticsManagementSegmentsList_578987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists advanced segments to which the user has access.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_AnalyticsManagementSegmentsList_578987;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "atom"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementSegmentsList
  ## Lists advanced segments to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first advanced segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of advanced segments to include in this response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579001 = newJObject()
  add(query_579001, "key", newJString(key))
  add(query_579001, "prettyPrint", newJBool(prettyPrint))
  add(query_579001, "oauth_token", newJString(oauthToken))
  add(query_579001, "alt", newJString(alt))
  add(query_579001, "userIp", newJString(userIp))
  add(query_579001, "quotaUser", newJString(quotaUser))
  add(query_579001, "start-index", newJInt(startIndex))
  add(query_579001, "max-results", newJInt(maxResults))
  add(query_579001, "fields", newJString(fields))
  result = call_579000.call(nil, query_579001, nil, nil, nil)

var analyticsManagementSegmentsList* = Call_AnalyticsManagementSegmentsList_578987(
    name: "analyticsManagementSegmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/segments",
    validator: validate_AnalyticsManagementSegmentsList_578988,
    base: "/analytics/v2.4", url: url_AnalyticsManagementSegmentsList_578989,
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
