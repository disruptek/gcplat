
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Google Analytics
## version: v3
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

  OpenApiRestCall_597437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597437): Option[Scheme] {.used.} =
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
  gcpServiceName = "analytics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsDataGaGet_597705 = ref object of OpenApiRestCall_597437
proc url_AnalyticsDataGaGet_597707(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsDataGaGet_597706(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns Analytics data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
  ##   segment: JString
  ##          : An Analytics segment to be applied to data.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   end-date: JString (required)
  ##           : End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
  ##   start-date: JString (required)
  ##             : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to Analytics data.
  ##   include-empty-rows: JBool
  ##                     : The response will include empty rows if this parameter is set to true, the default is true
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: JString
  ##                : The desired sampling level.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   output: JString
  ##         : The selected format for the response. Default format is JSON.
  section = newJObject()
  var valid_597819 = query.getOrDefault("fields")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "fields", valid_597819
  var valid_597820 = query.getOrDefault("quotaUser")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "quotaUser", valid_597820
  var valid_597834 = query.getOrDefault("alt")
  valid_597834 = validateParameter(valid_597834, JString, required = false,
                                 default = newJString("json"))
  if valid_597834 != nil:
    section.add "alt", valid_597834
  var valid_597835 = query.getOrDefault("sort")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = nil)
  if valid_597835 != nil:
    section.add "sort", valid_597835
  var valid_597836 = query.getOrDefault("segment")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "segment", valid_597836
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_597837 = query.getOrDefault("metrics")
  valid_597837 = validateParameter(valid_597837, JString, required = true,
                                 default = nil)
  if valid_597837 != nil:
    section.add "metrics", valid_597837
  var valid_597838 = query.getOrDefault("oauth_token")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "oauth_token", valid_597838
  var valid_597839 = query.getOrDefault("userIp")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "userIp", valid_597839
  var valid_597840 = query.getOrDefault("dimensions")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "dimensions", valid_597840
  var valid_597841 = query.getOrDefault("ids")
  valid_597841 = validateParameter(valid_597841, JString, required = true,
                                 default = nil)
  if valid_597841 != nil:
    section.add "ids", valid_597841
  var valid_597842 = query.getOrDefault("key")
  valid_597842 = validateParameter(valid_597842, JString, required = false,
                                 default = nil)
  if valid_597842 != nil:
    section.add "key", valid_597842
  var valid_597843 = query.getOrDefault("max-results")
  valid_597843 = validateParameter(valid_597843, JInt, required = false, default = nil)
  if valid_597843 != nil:
    section.add "max-results", valid_597843
  var valid_597844 = query.getOrDefault("end-date")
  valid_597844 = validateParameter(valid_597844, JString, required = true,
                                 default = nil)
  if valid_597844 != nil:
    section.add "end-date", valid_597844
  var valid_597845 = query.getOrDefault("start-date")
  valid_597845 = validateParameter(valid_597845, JString, required = true,
                                 default = nil)
  if valid_597845 != nil:
    section.add "start-date", valid_597845
  var valid_597846 = query.getOrDefault("filters")
  valid_597846 = validateParameter(valid_597846, JString, required = false,
                                 default = nil)
  if valid_597846 != nil:
    section.add "filters", valid_597846
  var valid_597847 = query.getOrDefault("include-empty-rows")
  valid_597847 = validateParameter(valid_597847, JBool, required = false, default = nil)
  if valid_597847 != nil:
    section.add "include-empty-rows", valid_597847
  var valid_597848 = query.getOrDefault("start-index")
  valid_597848 = validateParameter(valid_597848, JInt, required = false, default = nil)
  if valid_597848 != nil:
    section.add "start-index", valid_597848
  var valid_597849 = query.getOrDefault("samplingLevel")
  valid_597849 = validateParameter(valid_597849, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_597849 != nil:
    section.add "samplingLevel", valid_597849
  var valid_597850 = query.getOrDefault("prettyPrint")
  valid_597850 = validateParameter(valid_597850, JBool, required = false,
                                 default = newJBool(false))
  if valid_597850 != nil:
    section.add "prettyPrint", valid_597850
  var valid_597851 = query.getOrDefault("output")
  valid_597851 = validateParameter(valid_597851, JString, required = false,
                                 default = newJString("dataTable"))
  if valid_597851 != nil:
    section.add "output", valid_597851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597874: Call_AnalyticsDataGaGet_597705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics data for a view (profile).
  ## 
  let valid = call_597874.validator(path, query, header, formData, body)
  let scheme = call_597874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597874.url(scheme.get, call_597874.host, call_597874.base,
                         call_597874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597874, url, valid)

proc call*(call_597945: Call_AnalyticsDataGaGet_597705; metrics: string; ids: string;
          endDate: string; startDate: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: string = "";
          segment: string = ""; oauthToken: string = ""; userIp: string = "";
          dimensions: string = ""; key: string = ""; maxResults: int = 0;
          filters: string = ""; includeEmptyRows: bool = false; startIndex: int = 0;
          samplingLevel: string = "DEFAULT"; prettyPrint: bool = false;
          output: string = "dataTable"): Recallable =
  ## analyticsDataGaGet
  ## Returns Analytics data for a view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
  ##   segment: string
  ##          : An Analytics segment to be applied to data.
  ##   metrics: string (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   endDate: string (required)
  ##          : End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
  ##   startDate: string (required)
  ##            : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to Analytics data.
  ##   includeEmptyRows: bool
  ##                   : The response will include empty rows if this parameter is set to true, the default is true
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: string
  ##                : The desired sampling level.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   output: string
  ##         : The selected format for the response. Default format is JSON.
  var query_597946 = newJObject()
  add(query_597946, "fields", newJString(fields))
  add(query_597946, "quotaUser", newJString(quotaUser))
  add(query_597946, "alt", newJString(alt))
  add(query_597946, "sort", newJString(sort))
  add(query_597946, "segment", newJString(segment))
  add(query_597946, "metrics", newJString(metrics))
  add(query_597946, "oauth_token", newJString(oauthToken))
  add(query_597946, "userIp", newJString(userIp))
  add(query_597946, "dimensions", newJString(dimensions))
  add(query_597946, "ids", newJString(ids))
  add(query_597946, "key", newJString(key))
  add(query_597946, "max-results", newJInt(maxResults))
  add(query_597946, "end-date", newJString(endDate))
  add(query_597946, "start-date", newJString(startDate))
  add(query_597946, "filters", newJString(filters))
  add(query_597946, "include-empty-rows", newJBool(includeEmptyRows))
  add(query_597946, "start-index", newJInt(startIndex))
  add(query_597946, "samplingLevel", newJString(samplingLevel))
  add(query_597946, "prettyPrint", newJBool(prettyPrint))
  add(query_597946, "output", newJString(output))
  result = call_597945.call(nil, query_597946, nil, nil, nil)

var analyticsDataGaGet* = Call_AnalyticsDataGaGet_597705(
    name: "analyticsDataGaGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/ga",
    validator: validate_AnalyticsDataGaGet_597706, base: "/analytics/v3",
    url: url_AnalyticsDataGaGet_597707, schemes: {Scheme.Https})
type
  Call_AnalyticsDataMcfGet_597986 = ref object of OpenApiRestCall_597437
proc url_AnalyticsDataMcfGet_597988(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsDataMcfGet_597987(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the Analytics data.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Multi-Channel Funnels metrics. E.g., 'mcf:totalConversions,mcf:totalConversionValue'. At least one metric must be specified.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of Multi-Channel Funnels dimensions. E.g., 'mcf:source,mcf:medium'.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   end-date: JString (required)
  ##           : End date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   start-date: JString (required)
  ##             : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to the Analytics data.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: JString
  ##                : The desired sampling level.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597989 = query.getOrDefault("fields")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "fields", valid_597989
  var valid_597990 = query.getOrDefault("quotaUser")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "quotaUser", valid_597990
  var valid_597991 = query.getOrDefault("alt")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = newJString("json"))
  if valid_597991 != nil:
    section.add "alt", valid_597991
  var valid_597992 = query.getOrDefault("sort")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "sort", valid_597992
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_597993 = query.getOrDefault("metrics")
  valid_597993 = validateParameter(valid_597993, JString, required = true,
                                 default = nil)
  if valid_597993 != nil:
    section.add "metrics", valid_597993
  var valid_597994 = query.getOrDefault("oauth_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "oauth_token", valid_597994
  var valid_597995 = query.getOrDefault("userIp")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "userIp", valid_597995
  var valid_597996 = query.getOrDefault("dimensions")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "dimensions", valid_597996
  var valid_597997 = query.getOrDefault("ids")
  valid_597997 = validateParameter(valid_597997, JString, required = true,
                                 default = nil)
  if valid_597997 != nil:
    section.add "ids", valid_597997
  var valid_597998 = query.getOrDefault("key")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "key", valid_597998
  var valid_597999 = query.getOrDefault("max-results")
  valid_597999 = validateParameter(valid_597999, JInt, required = false, default = nil)
  if valid_597999 != nil:
    section.add "max-results", valid_597999
  var valid_598000 = query.getOrDefault("end-date")
  valid_598000 = validateParameter(valid_598000, JString, required = true,
                                 default = nil)
  if valid_598000 != nil:
    section.add "end-date", valid_598000
  var valid_598001 = query.getOrDefault("start-date")
  valid_598001 = validateParameter(valid_598001, JString, required = true,
                                 default = nil)
  if valid_598001 != nil:
    section.add "start-date", valid_598001
  var valid_598002 = query.getOrDefault("filters")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "filters", valid_598002
  var valid_598003 = query.getOrDefault("start-index")
  valid_598003 = validateParameter(valid_598003, JInt, required = false, default = nil)
  if valid_598003 != nil:
    section.add "start-index", valid_598003
  var valid_598004 = query.getOrDefault("samplingLevel")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_598004 != nil:
    section.add "samplingLevel", valid_598004
  var valid_598005 = query.getOrDefault("prettyPrint")
  valid_598005 = validateParameter(valid_598005, JBool, required = false,
                                 default = newJBool(false))
  if valid_598005 != nil:
    section.add "prettyPrint", valid_598005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598006: Call_AnalyticsDataMcfGet_597986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ## 
  let valid = call_598006.validator(path, query, header, formData, body)
  let scheme = call_598006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598006.url(scheme.get, call_598006.host, call_598006.base,
                         call_598006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598006, url, valid)

proc call*(call_598007: Call_AnalyticsDataMcfGet_597986; metrics: string;
          ids: string; endDate: string; startDate: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: string = "";
          oauthToken: string = ""; userIp: string = ""; dimensions: string = "";
          key: string = ""; maxResults: int = 0; filters: string = ""; startIndex: int = 0;
          samplingLevel: string = "DEFAULT"; prettyPrint: bool = false): Recallable =
  ## analyticsDataMcfGet
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the Analytics data.
  ##   metrics: string (required)
  ##          : A comma-separated list of Multi-Channel Funnels metrics. E.g., 'mcf:totalConversions,mcf:totalConversionValue'. At least one metric must be specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of Multi-Channel Funnels dimensions. E.g., 'mcf:source,mcf:medium'.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   endDate: string (required)
  ##          : End date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   startDate: string (required)
  ##            : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to the Analytics data.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: string
  ##                : The desired sampling level.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598008 = newJObject()
  add(query_598008, "fields", newJString(fields))
  add(query_598008, "quotaUser", newJString(quotaUser))
  add(query_598008, "alt", newJString(alt))
  add(query_598008, "sort", newJString(sort))
  add(query_598008, "metrics", newJString(metrics))
  add(query_598008, "oauth_token", newJString(oauthToken))
  add(query_598008, "userIp", newJString(userIp))
  add(query_598008, "dimensions", newJString(dimensions))
  add(query_598008, "ids", newJString(ids))
  add(query_598008, "key", newJString(key))
  add(query_598008, "max-results", newJInt(maxResults))
  add(query_598008, "end-date", newJString(endDate))
  add(query_598008, "start-date", newJString(startDate))
  add(query_598008, "filters", newJString(filters))
  add(query_598008, "start-index", newJInt(startIndex))
  add(query_598008, "samplingLevel", newJString(samplingLevel))
  add(query_598008, "prettyPrint", newJBool(prettyPrint))
  result = call_598007.call(nil, query_598008, nil, nil, nil)

var analyticsDataMcfGet* = Call_AnalyticsDataMcfGet_597986(
    name: "analyticsDataMcfGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/mcf",
    validator: validate_AnalyticsDataMcfGet_597987, base: "/analytics/v3",
    url: url_AnalyticsDataMcfGet_597988, schemes: {Scheme.Https})
type
  Call_AnalyticsDataRealtimeGet_598009 = ref object of OpenApiRestCall_597437
proc url_AnalyticsDataRealtimeGet_598011(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsDataRealtimeGet_598010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns real time data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for real time data.
  ##   metrics: JString (required)
  ##          : A comma-separated list of real time metrics. E.g., 'rt:activeUsers'. At least one metric must be specified.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of real time dimensions. E.g., 'rt:medium,rt:city'.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving real time data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to real time data.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("sort")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "sort", valid_598015
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_598016 = query.getOrDefault("metrics")
  valid_598016 = validateParameter(valid_598016, JString, required = true,
                                 default = nil)
  if valid_598016 != nil:
    section.add "metrics", valid_598016
  var valid_598017 = query.getOrDefault("oauth_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "oauth_token", valid_598017
  var valid_598018 = query.getOrDefault("userIp")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "userIp", valid_598018
  var valid_598019 = query.getOrDefault("dimensions")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "dimensions", valid_598019
  var valid_598020 = query.getOrDefault("ids")
  valid_598020 = validateParameter(valid_598020, JString, required = true,
                                 default = nil)
  if valid_598020 != nil:
    section.add "ids", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("max-results")
  valid_598022 = validateParameter(valid_598022, JInt, required = false, default = nil)
  if valid_598022 != nil:
    section.add "max-results", valid_598022
  var valid_598023 = query.getOrDefault("filters")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "filters", valid_598023
  var valid_598024 = query.getOrDefault("prettyPrint")
  valid_598024 = validateParameter(valid_598024, JBool, required = false,
                                 default = newJBool(false))
  if valid_598024 != nil:
    section.add "prettyPrint", valid_598024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598025: Call_AnalyticsDataRealtimeGet_598009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns real time data for a view (profile).
  ## 
  let valid = call_598025.validator(path, query, header, formData, body)
  let scheme = call_598025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598025.url(scheme.get, call_598025.host, call_598025.base,
                         call_598025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598025, url, valid)

proc call*(call_598026: Call_AnalyticsDataRealtimeGet_598009; metrics: string;
          ids: string; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sort: string = ""; oauthToken: string = ""; userIp: string = "";
          dimensions: string = ""; key: string = ""; maxResults: int = 0;
          filters: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsDataRealtimeGet
  ## Returns real time data for a view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for real time data.
  ##   metrics: string (required)
  ##          : A comma-separated list of real time metrics. E.g., 'rt:activeUsers'. At least one metric must be specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of real time dimensions. E.g., 'rt:medium,rt:city'.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving real time data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to real time data.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598027 = newJObject()
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "sort", newJString(sort))
  add(query_598027, "metrics", newJString(metrics))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "userIp", newJString(userIp))
  add(query_598027, "dimensions", newJString(dimensions))
  add(query_598027, "ids", newJString(ids))
  add(query_598027, "key", newJString(key))
  add(query_598027, "max-results", newJInt(maxResults))
  add(query_598027, "filters", newJString(filters))
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  result = call_598026.call(nil, query_598027, nil, nil, nil)

var analyticsDataRealtimeGet* = Call_AnalyticsDataRealtimeGet_598009(
    name: "analyticsDataRealtimeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/realtime",
    validator: validate_AnalyticsDataRealtimeGet_598010, base: "/analytics/v3",
    url: url_AnalyticsDataRealtimeGet_598011, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountSummariesList_598028 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementAccountSummariesList_598030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountSummariesList_598029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of account summaries to include in this response, where the largest acceptable value is 1000.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598031 = query.getOrDefault("fields")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "fields", valid_598031
  var valid_598032 = query.getOrDefault("quotaUser")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "quotaUser", valid_598032
  var valid_598033 = query.getOrDefault("alt")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = newJString("json"))
  if valid_598033 != nil:
    section.add "alt", valid_598033
  var valid_598034 = query.getOrDefault("oauth_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "oauth_token", valid_598034
  var valid_598035 = query.getOrDefault("userIp")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "userIp", valid_598035
  var valid_598036 = query.getOrDefault("key")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "key", valid_598036
  var valid_598037 = query.getOrDefault("max-results")
  valid_598037 = validateParameter(valid_598037, JInt, required = false, default = nil)
  if valid_598037 != nil:
    section.add "max-results", valid_598037
  var valid_598038 = query.getOrDefault("start-index")
  valid_598038 = validateParameter(valid_598038, JInt, required = false, default = nil)
  if valid_598038 != nil:
    section.add "start-index", valid_598038
  var valid_598039 = query.getOrDefault("prettyPrint")
  valid_598039 = validateParameter(valid_598039, JBool, required = false,
                                 default = newJBool(false))
  if valid_598039 != nil:
    section.add "prettyPrint", valid_598039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598040: Call_AnalyticsManagementAccountSummariesList_598028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ## 
  let valid = call_598040.validator(path, query, header, formData, body)
  let scheme = call_598040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598040.url(scheme.get, call_598040.host, call_598040.base,
                         call_598040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598040, url, valid)

proc call*(call_598041: Call_AnalyticsManagementAccountSummariesList_598028;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountSummariesList
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of account summaries to include in this response, where the largest acceptable value is 1000.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598042 = newJObject()
  add(query_598042, "fields", newJString(fields))
  add(query_598042, "quotaUser", newJString(quotaUser))
  add(query_598042, "alt", newJString(alt))
  add(query_598042, "oauth_token", newJString(oauthToken))
  add(query_598042, "userIp", newJString(userIp))
  add(query_598042, "key", newJString(key))
  add(query_598042, "max-results", newJInt(maxResults))
  add(query_598042, "start-index", newJInt(startIndex))
  add(query_598042, "prettyPrint", newJBool(prettyPrint))
  result = call_598041.call(nil, query_598042, nil, nil, nil)

var analyticsManagementAccountSummariesList* = Call_AnalyticsManagementAccountSummariesList_598028(
    name: "analyticsManagementAccountSummariesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accountSummaries",
    validator: validate_AnalyticsManagementAccountSummariesList_598029,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountSummariesList_598030,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountsList_598043 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementAccountsList_598045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountsList_598044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all accounts to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of accounts to include in this response.
  ##   start-index: JInt
  ##              : An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598046 = query.getOrDefault("fields")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "fields", valid_598046
  var valid_598047 = query.getOrDefault("quotaUser")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "quotaUser", valid_598047
  var valid_598048 = query.getOrDefault("alt")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = newJString("json"))
  if valid_598048 != nil:
    section.add "alt", valid_598048
  var valid_598049 = query.getOrDefault("oauth_token")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "oauth_token", valid_598049
  var valid_598050 = query.getOrDefault("userIp")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "userIp", valid_598050
  var valid_598051 = query.getOrDefault("key")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "key", valid_598051
  var valid_598052 = query.getOrDefault("max-results")
  valid_598052 = validateParameter(valid_598052, JInt, required = false, default = nil)
  if valid_598052 != nil:
    section.add "max-results", valid_598052
  var valid_598053 = query.getOrDefault("start-index")
  valid_598053 = validateParameter(valid_598053, JInt, required = false, default = nil)
  if valid_598053 != nil:
    section.add "start-index", valid_598053
  var valid_598054 = query.getOrDefault("prettyPrint")
  valid_598054 = validateParameter(valid_598054, JBool, required = false,
                                 default = newJBool(false))
  if valid_598054 != nil:
    section.add "prettyPrint", valid_598054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598055: Call_AnalyticsManagementAccountsList_598043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all accounts to which the user has access.
  ## 
  let valid = call_598055.validator(path, query, header, formData, body)
  let scheme = call_598055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598055.url(scheme.get, call_598055.host, call_598055.base,
                         call_598055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598055, url, valid)

proc call*(call_598056: Call_AnalyticsManagementAccountsList_598043;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountsList
  ## Lists all accounts to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of accounts to include in this response.
  ##   startIndex: int
  ##             : An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598057 = newJObject()
  add(query_598057, "fields", newJString(fields))
  add(query_598057, "quotaUser", newJString(quotaUser))
  add(query_598057, "alt", newJString(alt))
  add(query_598057, "oauth_token", newJString(oauthToken))
  add(query_598057, "userIp", newJString(userIp))
  add(query_598057, "key", newJString(key))
  add(query_598057, "max-results", newJInt(maxResults))
  add(query_598057, "start-index", newJInt(startIndex))
  add(query_598057, "prettyPrint", newJBool(prettyPrint))
  result = call_598056.call(nil, query_598057, nil, nil, nil)

var analyticsManagementAccountsList* = Call_AnalyticsManagementAccountsList_598043(
    name: "analyticsManagementAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts",
    validator: validate_AnalyticsManagementAccountsList_598044,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountsList_598045,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksInsert_598089 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementAccountUserLinksInsert_598091(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksInsert_598090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new user to the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598092 = path.getOrDefault("accountId")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "accountId", valid_598092
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598093 = query.getOrDefault("fields")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "fields", valid_598093
  var valid_598094 = query.getOrDefault("quotaUser")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "quotaUser", valid_598094
  var valid_598095 = query.getOrDefault("alt")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = newJString("json"))
  if valid_598095 != nil:
    section.add "alt", valid_598095
  var valid_598096 = query.getOrDefault("oauth_token")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "oauth_token", valid_598096
  var valid_598097 = query.getOrDefault("userIp")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "userIp", valid_598097
  var valid_598098 = query.getOrDefault("key")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "key", valid_598098
  var valid_598099 = query.getOrDefault("prettyPrint")
  valid_598099 = validateParameter(valid_598099, JBool, required = false,
                                 default = newJBool(false))
  if valid_598099 != nil:
    section.add "prettyPrint", valid_598099
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

proc call*(call_598101: Call_AnalyticsManagementAccountUserLinksInsert_598089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given account.
  ## 
  let valid = call_598101.validator(path, query, header, formData, body)
  let scheme = call_598101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598101.url(scheme.get, call_598101.host, call_598101.base,
                         call_598101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598101, url, valid)

proc call*(call_598102: Call_AnalyticsManagementAccountUserLinksInsert_598089;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksInsert
  ## Adds a new user to the given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598103 = newJObject()
  var query_598104 = newJObject()
  var body_598105 = newJObject()
  add(query_598104, "fields", newJString(fields))
  add(query_598104, "quotaUser", newJString(quotaUser))
  add(query_598104, "alt", newJString(alt))
  add(query_598104, "oauth_token", newJString(oauthToken))
  add(path_598103, "accountId", newJString(accountId))
  add(query_598104, "userIp", newJString(userIp))
  add(query_598104, "key", newJString(key))
  if body != nil:
    body_598105 = body
  add(query_598104, "prettyPrint", newJBool(prettyPrint))
  result = call_598102.call(path_598103, query_598104, nil, nil, body_598105)

var analyticsManagementAccountUserLinksInsert* = Call_AnalyticsManagementAccountUserLinksInsert_598089(
    name: "analyticsManagementAccountUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksInsert_598090,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksInsert_598091,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksList_598058 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementAccountUserLinksList_598060(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksList_598059(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists account-user links for a given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the user links for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598075 = path.getOrDefault("accountId")
  valid_598075 = validateParameter(valid_598075, JString, required = true,
                                 default = nil)
  if valid_598075 != nil:
    section.add "accountId", valid_598075
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of account-user links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first account-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598076 = query.getOrDefault("fields")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "fields", valid_598076
  var valid_598077 = query.getOrDefault("quotaUser")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "quotaUser", valid_598077
  var valid_598078 = query.getOrDefault("alt")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = newJString("json"))
  if valid_598078 != nil:
    section.add "alt", valid_598078
  var valid_598079 = query.getOrDefault("oauth_token")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "oauth_token", valid_598079
  var valid_598080 = query.getOrDefault("userIp")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "userIp", valid_598080
  var valid_598081 = query.getOrDefault("key")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "key", valid_598081
  var valid_598082 = query.getOrDefault("max-results")
  valid_598082 = validateParameter(valid_598082, JInt, required = false, default = nil)
  if valid_598082 != nil:
    section.add "max-results", valid_598082
  var valid_598083 = query.getOrDefault("start-index")
  valid_598083 = validateParameter(valid_598083, JInt, required = false, default = nil)
  if valid_598083 != nil:
    section.add "start-index", valid_598083
  var valid_598084 = query.getOrDefault("prettyPrint")
  valid_598084 = validateParameter(valid_598084, JBool, required = false,
                                 default = newJBool(false))
  if valid_598084 != nil:
    section.add "prettyPrint", valid_598084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598085: Call_AnalyticsManagementAccountUserLinksList_598058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account-user links for a given account.
  ## 
  let valid = call_598085.validator(path, query, header, formData, body)
  let scheme = call_598085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598085.url(scheme.get, call_598085.host, call_598085.base,
                         call_598085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598085, url, valid)

proc call*(call_598086: Call_AnalyticsManagementAccountUserLinksList_598058;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksList
  ## Lists account-user links for a given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the user links for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of account-user links to include in this response.
  ##   startIndex: int
  ##             : An index of the first account-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598087 = newJObject()
  var query_598088 = newJObject()
  add(query_598088, "fields", newJString(fields))
  add(query_598088, "quotaUser", newJString(quotaUser))
  add(query_598088, "alt", newJString(alt))
  add(query_598088, "oauth_token", newJString(oauthToken))
  add(path_598087, "accountId", newJString(accountId))
  add(query_598088, "userIp", newJString(userIp))
  add(query_598088, "key", newJString(key))
  add(query_598088, "max-results", newJInt(maxResults))
  add(query_598088, "start-index", newJInt(startIndex))
  add(query_598088, "prettyPrint", newJBool(prettyPrint))
  result = call_598086.call(path_598087, query_598088, nil, nil, nil)

var analyticsManagementAccountUserLinksList* = Call_AnalyticsManagementAccountUserLinksList_598058(
    name: "analyticsManagementAccountUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksList_598059,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksList_598060,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksUpdate_598106 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementAccountUserLinksUpdate_598108(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksUpdate_598107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to update the account-user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the account-user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598109 = path.getOrDefault("accountId")
  valid_598109 = validateParameter(valid_598109, JString, required = true,
                                 default = nil)
  if valid_598109 != nil:
    section.add "accountId", valid_598109
  var valid_598110 = path.getOrDefault("linkId")
  valid_598110 = validateParameter(valid_598110, JString, required = true,
                                 default = nil)
  if valid_598110 != nil:
    section.add "linkId", valid_598110
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598111 = query.getOrDefault("fields")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "fields", valid_598111
  var valid_598112 = query.getOrDefault("quotaUser")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "quotaUser", valid_598112
  var valid_598113 = query.getOrDefault("alt")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = newJString("json"))
  if valid_598113 != nil:
    section.add "alt", valid_598113
  var valid_598114 = query.getOrDefault("oauth_token")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "oauth_token", valid_598114
  var valid_598115 = query.getOrDefault("userIp")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "userIp", valid_598115
  var valid_598116 = query.getOrDefault("key")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "key", valid_598116
  var valid_598117 = query.getOrDefault("prettyPrint")
  valid_598117 = validateParameter(valid_598117, JBool, required = false,
                                 default = newJBool(false))
  if valid_598117 != nil:
    section.add "prettyPrint", valid_598117
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

proc call*(call_598119: Call_AnalyticsManagementAccountUserLinksUpdate_598106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given account.
  ## 
  let valid = call_598119.validator(path, query, header, formData, body)
  let scheme = call_598119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598119.url(scheme.get, call_598119.host, call_598119.base,
                         call_598119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598119, url, valid)

proc call*(call_598120: Call_AnalyticsManagementAccountUserLinksUpdate_598106;
          accountId: string; linkId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksUpdate
  ## Updates permissions for an existing user on the given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the account-user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to update the account-user link for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598121 = newJObject()
  var query_598122 = newJObject()
  var body_598123 = newJObject()
  add(query_598122, "fields", newJString(fields))
  add(query_598122, "quotaUser", newJString(quotaUser))
  add(query_598122, "alt", newJString(alt))
  add(query_598122, "oauth_token", newJString(oauthToken))
  add(path_598121, "accountId", newJString(accountId))
  add(query_598122, "userIp", newJString(userIp))
  add(query_598122, "key", newJString(key))
  add(path_598121, "linkId", newJString(linkId))
  if body != nil:
    body_598123 = body
  add(query_598122, "prettyPrint", newJBool(prettyPrint))
  result = call_598120.call(path_598121, query_598122, nil, nil, body_598123)

var analyticsManagementAccountUserLinksUpdate* = Call_AnalyticsManagementAccountUserLinksUpdate_598106(
    name: "analyticsManagementAccountUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksUpdate_598107,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksUpdate_598108,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksDelete_598124 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementAccountUserLinksDelete_598126(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksDelete_598125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a user from the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598127 = path.getOrDefault("accountId")
  valid_598127 = validateParameter(valid_598127, JString, required = true,
                                 default = nil)
  if valid_598127 != nil:
    section.add "accountId", valid_598127
  var valid_598128 = path.getOrDefault("linkId")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = nil)
  if valid_598128 != nil:
    section.add "linkId", valid_598128
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598129 = query.getOrDefault("fields")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "fields", valid_598129
  var valid_598130 = query.getOrDefault("quotaUser")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "quotaUser", valid_598130
  var valid_598131 = query.getOrDefault("alt")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = newJString("json"))
  if valid_598131 != nil:
    section.add "alt", valid_598131
  var valid_598132 = query.getOrDefault("oauth_token")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "oauth_token", valid_598132
  var valid_598133 = query.getOrDefault("userIp")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "userIp", valid_598133
  var valid_598134 = query.getOrDefault("key")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "key", valid_598134
  var valid_598135 = query.getOrDefault("prettyPrint")
  valid_598135 = validateParameter(valid_598135, JBool, required = false,
                                 default = newJBool(false))
  if valid_598135 != nil:
    section.add "prettyPrint", valid_598135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598136: Call_AnalyticsManagementAccountUserLinksDelete_598124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given account.
  ## 
  let valid = call_598136.validator(path, query, header, formData, body)
  let scheme = call_598136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598136.url(scheme.get, call_598136.host, call_598136.base,
                         call_598136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598136, url, valid)

proc call*(call_598137: Call_AnalyticsManagementAccountUserLinksDelete_598124;
          accountId: string; linkId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksDelete
  ## Removes a user from the given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598138 = newJObject()
  var query_598139 = newJObject()
  add(query_598139, "fields", newJString(fields))
  add(query_598139, "quotaUser", newJString(quotaUser))
  add(query_598139, "alt", newJString(alt))
  add(query_598139, "oauth_token", newJString(oauthToken))
  add(path_598138, "accountId", newJString(accountId))
  add(query_598139, "userIp", newJString(userIp))
  add(query_598139, "key", newJString(key))
  add(path_598138, "linkId", newJString(linkId))
  add(query_598139, "prettyPrint", newJBool(prettyPrint))
  result = call_598137.call(path_598138, query_598139, nil, nil, nil)

var analyticsManagementAccountUserLinksDelete* = Call_AnalyticsManagementAccountUserLinksDelete_598124(
    name: "analyticsManagementAccountUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksDelete_598125,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksDelete_598126,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersInsert_598157 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementFiltersInsert_598159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersInsert_598158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create filter for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598160 = path.getOrDefault("accountId")
  valid_598160 = validateParameter(valid_598160, JString, required = true,
                                 default = nil)
  if valid_598160 != nil:
    section.add "accountId", valid_598160
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598161 = query.getOrDefault("fields")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "fields", valid_598161
  var valid_598162 = query.getOrDefault("quotaUser")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "quotaUser", valid_598162
  var valid_598163 = query.getOrDefault("alt")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = newJString("json"))
  if valid_598163 != nil:
    section.add "alt", valid_598163
  var valid_598164 = query.getOrDefault("oauth_token")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "oauth_token", valid_598164
  var valid_598165 = query.getOrDefault("userIp")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "userIp", valid_598165
  var valid_598166 = query.getOrDefault("key")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "key", valid_598166
  var valid_598167 = query.getOrDefault("prettyPrint")
  valid_598167 = validateParameter(valid_598167, JBool, required = false,
                                 default = newJBool(false))
  if valid_598167 != nil:
    section.add "prettyPrint", valid_598167
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

proc call*(call_598169: Call_AnalyticsManagementFiltersInsert_598157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new filter.
  ## 
  let valid = call_598169.validator(path, query, header, formData, body)
  let scheme = call_598169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598169.url(scheme.get, call_598169.host, call_598169.base,
                         call_598169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598169, url, valid)

proc call*(call_598170: Call_AnalyticsManagementFiltersInsert_598157;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersInsert
  ## Create a new filter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create filter for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598171 = newJObject()
  var query_598172 = newJObject()
  var body_598173 = newJObject()
  add(query_598172, "fields", newJString(fields))
  add(query_598172, "quotaUser", newJString(quotaUser))
  add(query_598172, "alt", newJString(alt))
  add(query_598172, "oauth_token", newJString(oauthToken))
  add(path_598171, "accountId", newJString(accountId))
  add(query_598172, "userIp", newJString(userIp))
  add(query_598172, "key", newJString(key))
  if body != nil:
    body_598173 = body
  add(query_598172, "prettyPrint", newJBool(prettyPrint))
  result = call_598170.call(path_598171, query_598172, nil, nil, body_598173)

var analyticsManagementFiltersInsert* = Call_AnalyticsManagementFiltersInsert_598157(
    name: "analyticsManagementFiltersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersInsert_598158,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersInsert_598159,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersList_598140 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementFiltersList_598142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersList_598141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all filters for an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve filters for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598143 = path.getOrDefault("accountId")
  valid_598143 = validateParameter(valid_598143, JString, required = true,
                                 default = nil)
  if valid_598143 != nil:
    section.add "accountId", valid_598143
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of filters to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598144 = query.getOrDefault("fields")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "fields", valid_598144
  var valid_598145 = query.getOrDefault("quotaUser")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "quotaUser", valid_598145
  var valid_598146 = query.getOrDefault("alt")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = newJString("json"))
  if valid_598146 != nil:
    section.add "alt", valid_598146
  var valid_598147 = query.getOrDefault("oauth_token")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "oauth_token", valid_598147
  var valid_598148 = query.getOrDefault("userIp")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "userIp", valid_598148
  var valid_598149 = query.getOrDefault("key")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "key", valid_598149
  var valid_598150 = query.getOrDefault("max-results")
  valid_598150 = validateParameter(valid_598150, JInt, required = false, default = nil)
  if valid_598150 != nil:
    section.add "max-results", valid_598150
  var valid_598151 = query.getOrDefault("start-index")
  valid_598151 = validateParameter(valid_598151, JInt, required = false, default = nil)
  if valid_598151 != nil:
    section.add "start-index", valid_598151
  var valid_598152 = query.getOrDefault("prettyPrint")
  valid_598152 = validateParameter(valid_598152, JBool, required = false,
                                 default = newJBool(false))
  if valid_598152 != nil:
    section.add "prettyPrint", valid_598152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598153: Call_AnalyticsManagementFiltersList_598140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all filters for an account
  ## 
  let valid = call_598153.validator(path, query, header, formData, body)
  let scheme = call_598153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598153.url(scheme.get, call_598153.host, call_598153.base,
                         call_598153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598153, url, valid)

proc call*(call_598154: Call_AnalyticsManagementFiltersList_598140;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersList
  ## Lists all filters for an account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve filters for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of filters to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598155 = newJObject()
  var query_598156 = newJObject()
  add(query_598156, "fields", newJString(fields))
  add(query_598156, "quotaUser", newJString(quotaUser))
  add(query_598156, "alt", newJString(alt))
  add(query_598156, "oauth_token", newJString(oauthToken))
  add(path_598155, "accountId", newJString(accountId))
  add(query_598156, "userIp", newJString(userIp))
  add(query_598156, "key", newJString(key))
  add(query_598156, "max-results", newJInt(maxResults))
  add(query_598156, "start-index", newJInt(startIndex))
  add(query_598156, "prettyPrint", newJBool(prettyPrint))
  result = call_598154.call(path_598155, query_598156, nil, nil, nil)

var analyticsManagementFiltersList* = Call_AnalyticsManagementFiltersList_598140(
    name: "analyticsManagementFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersList_598141,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersList_598142,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersUpdate_598190 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementFiltersUpdate_598192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersUpdate_598191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the filter belongs.
  ##   filterId: JString (required)
  ##           : ID of the filter to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598193 = path.getOrDefault("accountId")
  valid_598193 = validateParameter(valid_598193, JString, required = true,
                                 default = nil)
  if valid_598193 != nil:
    section.add "accountId", valid_598193
  var valid_598194 = path.getOrDefault("filterId")
  valid_598194 = validateParameter(valid_598194, JString, required = true,
                                 default = nil)
  if valid_598194 != nil:
    section.add "filterId", valid_598194
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598195 = query.getOrDefault("fields")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "fields", valid_598195
  var valid_598196 = query.getOrDefault("quotaUser")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "quotaUser", valid_598196
  var valid_598197 = query.getOrDefault("alt")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = newJString("json"))
  if valid_598197 != nil:
    section.add "alt", valid_598197
  var valid_598198 = query.getOrDefault("oauth_token")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "oauth_token", valid_598198
  var valid_598199 = query.getOrDefault("userIp")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "userIp", valid_598199
  var valid_598200 = query.getOrDefault("key")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "key", valid_598200
  var valid_598201 = query.getOrDefault("prettyPrint")
  valid_598201 = validateParameter(valid_598201, JBool, required = false,
                                 default = newJBool(false))
  if valid_598201 != nil:
    section.add "prettyPrint", valid_598201
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

proc call*(call_598203: Call_AnalyticsManagementFiltersUpdate_598190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter.
  ## 
  let valid = call_598203.validator(path, query, header, formData, body)
  let scheme = call_598203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598203.url(scheme.get, call_598203.host, call_598203.base,
                         call_598203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598203, url, valid)

proc call*(call_598204: Call_AnalyticsManagementFiltersUpdate_598190;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersUpdate
  ## Updates an existing filter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the filter belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : ID of the filter to be updated.
  var path_598205 = newJObject()
  var query_598206 = newJObject()
  var body_598207 = newJObject()
  add(query_598206, "fields", newJString(fields))
  add(query_598206, "quotaUser", newJString(quotaUser))
  add(query_598206, "alt", newJString(alt))
  add(query_598206, "oauth_token", newJString(oauthToken))
  add(path_598205, "accountId", newJString(accountId))
  add(query_598206, "userIp", newJString(userIp))
  add(query_598206, "key", newJString(key))
  if body != nil:
    body_598207 = body
  add(query_598206, "prettyPrint", newJBool(prettyPrint))
  add(path_598205, "filterId", newJString(filterId))
  result = call_598204.call(path_598205, query_598206, nil, nil, body_598207)

var analyticsManagementFiltersUpdate* = Call_AnalyticsManagementFiltersUpdate_598190(
    name: "analyticsManagementFiltersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersUpdate_598191,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersUpdate_598192,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersGet_598174 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementFiltersGet_598176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersGet_598175(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns filters to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve filters for.
  ##   filterId: JString (required)
  ##           : Filter ID to retrieve filters for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598177 = path.getOrDefault("accountId")
  valid_598177 = validateParameter(valid_598177, JString, required = true,
                                 default = nil)
  if valid_598177 != nil:
    section.add "accountId", valid_598177
  var valid_598178 = path.getOrDefault("filterId")
  valid_598178 = validateParameter(valid_598178, JString, required = true,
                                 default = nil)
  if valid_598178 != nil:
    section.add "filterId", valid_598178
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598179 = query.getOrDefault("fields")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "fields", valid_598179
  var valid_598180 = query.getOrDefault("quotaUser")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "quotaUser", valid_598180
  var valid_598181 = query.getOrDefault("alt")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = newJString("json"))
  if valid_598181 != nil:
    section.add "alt", valid_598181
  var valid_598182 = query.getOrDefault("oauth_token")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "oauth_token", valid_598182
  var valid_598183 = query.getOrDefault("userIp")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "userIp", valid_598183
  var valid_598184 = query.getOrDefault("key")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "key", valid_598184
  var valid_598185 = query.getOrDefault("prettyPrint")
  valid_598185 = validateParameter(valid_598185, JBool, required = false,
                                 default = newJBool(false))
  if valid_598185 != nil:
    section.add "prettyPrint", valid_598185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598186: Call_AnalyticsManagementFiltersGet_598174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns filters to which the user has access.
  ## 
  let valid = call_598186.validator(path, query, header, formData, body)
  let scheme = call_598186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598186.url(scheme.get, call_598186.host, call_598186.base,
                         call_598186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598186, url, valid)

proc call*(call_598187: Call_AnalyticsManagementFiltersGet_598174;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersGet
  ## Returns filters to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve filters for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : Filter ID to retrieve filters for.
  var path_598188 = newJObject()
  var query_598189 = newJObject()
  add(query_598189, "fields", newJString(fields))
  add(query_598189, "quotaUser", newJString(quotaUser))
  add(query_598189, "alt", newJString(alt))
  add(query_598189, "oauth_token", newJString(oauthToken))
  add(path_598188, "accountId", newJString(accountId))
  add(query_598189, "userIp", newJString(userIp))
  add(query_598189, "key", newJString(key))
  add(query_598189, "prettyPrint", newJBool(prettyPrint))
  add(path_598188, "filterId", newJString(filterId))
  result = call_598187.call(path_598188, query_598189, nil, nil, nil)

var analyticsManagementFiltersGet* = Call_AnalyticsManagementFiltersGet_598174(
    name: "analyticsManagementFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersGet_598175,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersGet_598176,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersPatch_598224 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementFiltersPatch_598226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersPatch_598225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing filter. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the filter belongs.
  ##   filterId: JString (required)
  ##           : ID of the filter to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598227 = path.getOrDefault("accountId")
  valid_598227 = validateParameter(valid_598227, JString, required = true,
                                 default = nil)
  if valid_598227 != nil:
    section.add "accountId", valid_598227
  var valid_598228 = path.getOrDefault("filterId")
  valid_598228 = validateParameter(valid_598228, JString, required = true,
                                 default = nil)
  if valid_598228 != nil:
    section.add "filterId", valid_598228
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598229 = query.getOrDefault("fields")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "fields", valid_598229
  var valid_598230 = query.getOrDefault("quotaUser")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "quotaUser", valid_598230
  var valid_598231 = query.getOrDefault("alt")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = newJString("json"))
  if valid_598231 != nil:
    section.add "alt", valid_598231
  var valid_598232 = query.getOrDefault("oauth_token")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "oauth_token", valid_598232
  var valid_598233 = query.getOrDefault("userIp")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = nil)
  if valid_598233 != nil:
    section.add "userIp", valid_598233
  var valid_598234 = query.getOrDefault("key")
  valid_598234 = validateParameter(valid_598234, JString, required = false,
                                 default = nil)
  if valid_598234 != nil:
    section.add "key", valid_598234
  var valid_598235 = query.getOrDefault("prettyPrint")
  valid_598235 = validateParameter(valid_598235, JBool, required = false,
                                 default = newJBool(false))
  if valid_598235 != nil:
    section.add "prettyPrint", valid_598235
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

proc call*(call_598237: Call_AnalyticsManagementFiltersPatch_598224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter. This method supports patch semantics.
  ## 
  let valid = call_598237.validator(path, query, header, formData, body)
  let scheme = call_598237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598237.url(scheme.get, call_598237.host, call_598237.base,
                         call_598237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598237, url, valid)

proc call*(call_598238: Call_AnalyticsManagementFiltersPatch_598224;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersPatch
  ## Updates an existing filter. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the filter belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : ID of the filter to be updated.
  var path_598239 = newJObject()
  var query_598240 = newJObject()
  var body_598241 = newJObject()
  add(query_598240, "fields", newJString(fields))
  add(query_598240, "quotaUser", newJString(quotaUser))
  add(query_598240, "alt", newJString(alt))
  add(query_598240, "oauth_token", newJString(oauthToken))
  add(path_598239, "accountId", newJString(accountId))
  add(query_598240, "userIp", newJString(userIp))
  add(query_598240, "key", newJString(key))
  if body != nil:
    body_598241 = body
  add(query_598240, "prettyPrint", newJBool(prettyPrint))
  add(path_598239, "filterId", newJString(filterId))
  result = call_598238.call(path_598239, query_598240, nil, nil, body_598241)

var analyticsManagementFiltersPatch* = Call_AnalyticsManagementFiltersPatch_598224(
    name: "analyticsManagementFiltersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersPatch_598225,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersPatch_598226,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersDelete_598208 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementFiltersDelete_598210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersDelete_598209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to delete the filter for.
  ##   filterId: JString (required)
  ##           : ID of the filter to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598211 = path.getOrDefault("accountId")
  valid_598211 = validateParameter(valid_598211, JString, required = true,
                                 default = nil)
  if valid_598211 != nil:
    section.add "accountId", valid_598211
  var valid_598212 = path.getOrDefault("filterId")
  valid_598212 = validateParameter(valid_598212, JString, required = true,
                                 default = nil)
  if valid_598212 != nil:
    section.add "filterId", valid_598212
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598213 = query.getOrDefault("fields")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "fields", valid_598213
  var valid_598214 = query.getOrDefault("quotaUser")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "quotaUser", valid_598214
  var valid_598215 = query.getOrDefault("alt")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = newJString("json"))
  if valid_598215 != nil:
    section.add "alt", valid_598215
  var valid_598216 = query.getOrDefault("oauth_token")
  valid_598216 = validateParameter(valid_598216, JString, required = false,
                                 default = nil)
  if valid_598216 != nil:
    section.add "oauth_token", valid_598216
  var valid_598217 = query.getOrDefault("userIp")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "userIp", valid_598217
  var valid_598218 = query.getOrDefault("key")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = nil)
  if valid_598218 != nil:
    section.add "key", valid_598218
  var valid_598219 = query.getOrDefault("prettyPrint")
  valid_598219 = validateParameter(valid_598219, JBool, required = false,
                                 default = newJBool(false))
  if valid_598219 != nil:
    section.add "prettyPrint", valid_598219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598220: Call_AnalyticsManagementFiltersDelete_598208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a filter.
  ## 
  let valid = call_598220.validator(path, query, header, formData, body)
  let scheme = call_598220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598220.url(scheme.get, call_598220.host, call_598220.base,
                         call_598220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598220, url, valid)

proc call*(call_598221: Call_AnalyticsManagementFiltersDelete_598208;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersDelete
  ## Delete a filter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the filter for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : ID of the filter to be deleted.
  var path_598222 = newJObject()
  var query_598223 = newJObject()
  add(query_598223, "fields", newJString(fields))
  add(query_598223, "quotaUser", newJString(quotaUser))
  add(query_598223, "alt", newJString(alt))
  add(query_598223, "oauth_token", newJString(oauthToken))
  add(path_598222, "accountId", newJString(accountId))
  add(query_598223, "userIp", newJString(userIp))
  add(query_598223, "key", newJString(key))
  add(query_598223, "prettyPrint", newJBool(prettyPrint))
  add(path_598222, "filterId", newJString(filterId))
  result = call_598221.call(path_598222, query_598223, nil, nil, nil)

var analyticsManagementFiltersDelete* = Call_AnalyticsManagementFiltersDelete_598208(
    name: "analyticsManagementFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersDelete_598209,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersDelete_598210,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesInsert_598259 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertiesInsert_598261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementWebpropertiesInsert_598260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the web property for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598262 = path.getOrDefault("accountId")
  valid_598262 = validateParameter(valid_598262, JString, required = true,
                                 default = nil)
  if valid_598262 != nil:
    section.add "accountId", valid_598262
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598263 = query.getOrDefault("fields")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "fields", valid_598263
  var valid_598264 = query.getOrDefault("quotaUser")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "quotaUser", valid_598264
  var valid_598265 = query.getOrDefault("alt")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = newJString("json"))
  if valid_598265 != nil:
    section.add "alt", valid_598265
  var valid_598266 = query.getOrDefault("oauth_token")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "oauth_token", valid_598266
  var valid_598267 = query.getOrDefault("userIp")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "userIp", valid_598267
  var valid_598268 = query.getOrDefault("key")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "key", valid_598268
  var valid_598269 = query.getOrDefault("prettyPrint")
  valid_598269 = validateParameter(valid_598269, JBool, required = false,
                                 default = newJBool(false))
  if valid_598269 != nil:
    section.add "prettyPrint", valid_598269
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

proc call*(call_598271: Call_AnalyticsManagementWebpropertiesInsert_598259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ## 
  let valid = call_598271.validator(path, query, header, formData, body)
  let scheme = call_598271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598271.url(scheme.get, call_598271.host, call_598271.base,
                         call_598271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598271, url, valid)

proc call*(call_598272: Call_AnalyticsManagementWebpropertiesInsert_598259;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesInsert
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the web property for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598273 = newJObject()
  var query_598274 = newJObject()
  var body_598275 = newJObject()
  add(query_598274, "fields", newJString(fields))
  add(query_598274, "quotaUser", newJString(quotaUser))
  add(query_598274, "alt", newJString(alt))
  add(query_598274, "oauth_token", newJString(oauthToken))
  add(path_598273, "accountId", newJString(accountId))
  add(query_598274, "userIp", newJString(userIp))
  add(query_598274, "key", newJString(key))
  if body != nil:
    body_598275 = body
  add(query_598274, "prettyPrint", newJBool(prettyPrint))
  result = call_598272.call(path_598273, query_598274, nil, nil, body_598275)

var analyticsManagementWebpropertiesInsert* = Call_AnalyticsManagementWebpropertiesInsert_598259(
    name: "analyticsManagementWebpropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesInsert_598260,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesInsert_598261,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesList_598242 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertiesList_598244(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementWebpropertiesList_598243(path: JsonNode;
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
  var valid_598245 = path.getOrDefault("accountId")
  valid_598245 = validateParameter(valid_598245, JString, required = true,
                                 default = nil)
  if valid_598245 != nil:
    section.add "accountId", valid_598245
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of web properties to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598246 = query.getOrDefault("fields")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "fields", valid_598246
  var valid_598247 = query.getOrDefault("quotaUser")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "quotaUser", valid_598247
  var valid_598248 = query.getOrDefault("alt")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = newJString("json"))
  if valid_598248 != nil:
    section.add "alt", valid_598248
  var valid_598249 = query.getOrDefault("oauth_token")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "oauth_token", valid_598249
  var valid_598250 = query.getOrDefault("userIp")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "userIp", valid_598250
  var valid_598251 = query.getOrDefault("key")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "key", valid_598251
  var valid_598252 = query.getOrDefault("max-results")
  valid_598252 = validateParameter(valid_598252, JInt, required = false, default = nil)
  if valid_598252 != nil:
    section.add "max-results", valid_598252
  var valid_598253 = query.getOrDefault("start-index")
  valid_598253 = validateParameter(valid_598253, JInt, required = false, default = nil)
  if valid_598253 != nil:
    section.add "start-index", valid_598253
  var valid_598254 = query.getOrDefault("prettyPrint")
  valid_598254 = validateParameter(valid_598254, JBool, required = false,
                                 default = newJBool(false))
  if valid_598254 != nil:
    section.add "prettyPrint", valid_598254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598255: Call_AnalyticsManagementWebpropertiesList_598242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web properties to which the user has access.
  ## 
  let valid = call_598255.validator(path, query, header, formData, body)
  let scheme = call_598255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598255.url(scheme.get, call_598255.host, call_598255.base,
                         call_598255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598255, url, valid)

proc call*(call_598256: Call_AnalyticsManagementWebpropertiesList_598242;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesList
  ## Lists web properties to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve web properties for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of web properties to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598257 = newJObject()
  var query_598258 = newJObject()
  add(query_598258, "fields", newJString(fields))
  add(query_598258, "quotaUser", newJString(quotaUser))
  add(query_598258, "alt", newJString(alt))
  add(query_598258, "oauth_token", newJString(oauthToken))
  add(path_598257, "accountId", newJString(accountId))
  add(query_598258, "userIp", newJString(userIp))
  add(query_598258, "key", newJString(key))
  add(query_598258, "max-results", newJInt(maxResults))
  add(query_598258, "start-index", newJInt(startIndex))
  add(query_598258, "prettyPrint", newJBool(prettyPrint))
  result = call_598256.call(path_598257, query_598258, nil, nil, nil)

var analyticsManagementWebpropertiesList* = Call_AnalyticsManagementWebpropertiesList_598242(
    name: "analyticsManagementWebpropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesList_598243,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesList_598244,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesUpdate_598292 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertiesUpdate_598294(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesUpdate_598293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the web property belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598295 = path.getOrDefault("accountId")
  valid_598295 = validateParameter(valid_598295, JString, required = true,
                                 default = nil)
  if valid_598295 != nil:
    section.add "accountId", valid_598295
  var valid_598296 = path.getOrDefault("webPropertyId")
  valid_598296 = validateParameter(valid_598296, JString, required = true,
                                 default = nil)
  if valid_598296 != nil:
    section.add "webPropertyId", valid_598296
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598297 = query.getOrDefault("fields")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "fields", valid_598297
  var valid_598298 = query.getOrDefault("quotaUser")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "quotaUser", valid_598298
  var valid_598299 = query.getOrDefault("alt")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = newJString("json"))
  if valid_598299 != nil:
    section.add "alt", valid_598299
  var valid_598300 = query.getOrDefault("oauth_token")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "oauth_token", valid_598300
  var valid_598301 = query.getOrDefault("userIp")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "userIp", valid_598301
  var valid_598302 = query.getOrDefault("key")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "key", valid_598302
  var valid_598303 = query.getOrDefault("prettyPrint")
  valid_598303 = validateParameter(valid_598303, JBool, required = false,
                                 default = newJBool(false))
  if valid_598303 != nil:
    section.add "prettyPrint", valid_598303
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

proc call*(call_598305: Call_AnalyticsManagementWebpropertiesUpdate_598292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property.
  ## 
  let valid = call_598305.validator(path, query, header, formData, body)
  let scheme = call_598305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598305.url(scheme.get, call_598305.host, call_598305.base,
                         call_598305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598305, url, valid)

proc call*(call_598306: Call_AnalyticsManagementWebpropertiesUpdate_598292;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesUpdate
  ## Updates an existing web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the web property belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598307 = newJObject()
  var query_598308 = newJObject()
  var body_598309 = newJObject()
  add(query_598308, "fields", newJString(fields))
  add(query_598308, "quotaUser", newJString(quotaUser))
  add(query_598308, "alt", newJString(alt))
  add(query_598308, "oauth_token", newJString(oauthToken))
  add(path_598307, "accountId", newJString(accountId))
  add(query_598308, "userIp", newJString(userIp))
  add(path_598307, "webPropertyId", newJString(webPropertyId))
  add(query_598308, "key", newJString(key))
  if body != nil:
    body_598309 = body
  add(query_598308, "prettyPrint", newJBool(prettyPrint))
  result = call_598306.call(path_598307, query_598308, nil, nil, body_598309)

var analyticsManagementWebpropertiesUpdate* = Call_AnalyticsManagementWebpropertiesUpdate_598292(
    name: "analyticsManagementWebpropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesUpdate_598293,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesUpdate_598294,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesGet_598276 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertiesGet_598278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesGet_598277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a web property to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the web property for.
  ##   webPropertyId: JString (required)
  ##                : ID to retrieve the web property for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598279 = path.getOrDefault("accountId")
  valid_598279 = validateParameter(valid_598279, JString, required = true,
                                 default = nil)
  if valid_598279 != nil:
    section.add "accountId", valid_598279
  var valid_598280 = path.getOrDefault("webPropertyId")
  valid_598280 = validateParameter(valid_598280, JString, required = true,
                                 default = nil)
  if valid_598280 != nil:
    section.add "webPropertyId", valid_598280
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598281 = query.getOrDefault("fields")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "fields", valid_598281
  var valid_598282 = query.getOrDefault("quotaUser")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "quotaUser", valid_598282
  var valid_598283 = query.getOrDefault("alt")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = newJString("json"))
  if valid_598283 != nil:
    section.add "alt", valid_598283
  var valid_598284 = query.getOrDefault("oauth_token")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "oauth_token", valid_598284
  var valid_598285 = query.getOrDefault("userIp")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "userIp", valid_598285
  var valid_598286 = query.getOrDefault("key")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "key", valid_598286
  var valid_598287 = query.getOrDefault("prettyPrint")
  valid_598287 = validateParameter(valid_598287, JBool, required = false,
                                 default = newJBool(false))
  if valid_598287 != nil:
    section.add "prettyPrint", valid_598287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598288: Call_AnalyticsManagementWebpropertiesGet_598276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web property to which the user has access.
  ## 
  let valid = call_598288.validator(path, query, header, formData, body)
  let scheme = call_598288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598288.url(scheme.get, call_598288.host, call_598288.base,
                         call_598288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598288, url, valid)

proc call*(call_598289: Call_AnalyticsManagementWebpropertiesGet_598276;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesGet
  ## Gets a web property to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the web property for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : ID to retrieve the web property for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598290 = newJObject()
  var query_598291 = newJObject()
  add(query_598291, "fields", newJString(fields))
  add(query_598291, "quotaUser", newJString(quotaUser))
  add(query_598291, "alt", newJString(alt))
  add(query_598291, "oauth_token", newJString(oauthToken))
  add(path_598290, "accountId", newJString(accountId))
  add(query_598291, "userIp", newJString(userIp))
  add(path_598290, "webPropertyId", newJString(webPropertyId))
  add(query_598291, "key", newJString(key))
  add(query_598291, "prettyPrint", newJBool(prettyPrint))
  result = call_598289.call(path_598290, query_598291, nil, nil, nil)

var analyticsManagementWebpropertiesGet* = Call_AnalyticsManagementWebpropertiesGet_598276(
    name: "analyticsManagementWebpropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesGet_598277,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesGet_598278,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesPatch_598310 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertiesPatch_598312(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesPatch_598311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web property. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the web property belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598313 = path.getOrDefault("accountId")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "accountId", valid_598313
  var valid_598314 = path.getOrDefault("webPropertyId")
  valid_598314 = validateParameter(valid_598314, JString, required = true,
                                 default = nil)
  if valid_598314 != nil:
    section.add "webPropertyId", valid_598314
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598315 = query.getOrDefault("fields")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "fields", valid_598315
  var valid_598316 = query.getOrDefault("quotaUser")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "quotaUser", valid_598316
  var valid_598317 = query.getOrDefault("alt")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = newJString("json"))
  if valid_598317 != nil:
    section.add "alt", valid_598317
  var valid_598318 = query.getOrDefault("oauth_token")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "oauth_token", valid_598318
  var valid_598319 = query.getOrDefault("userIp")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "userIp", valid_598319
  var valid_598320 = query.getOrDefault("key")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "key", valid_598320
  var valid_598321 = query.getOrDefault("prettyPrint")
  valid_598321 = validateParameter(valid_598321, JBool, required = false,
                                 default = newJBool(false))
  if valid_598321 != nil:
    section.add "prettyPrint", valid_598321
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

proc call*(call_598323: Call_AnalyticsManagementWebpropertiesPatch_598310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property. This method supports patch semantics.
  ## 
  let valid = call_598323.validator(path, query, header, formData, body)
  let scheme = call_598323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598323.url(scheme.get, call_598323.host, call_598323.base,
                         call_598323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598323, url, valid)

proc call*(call_598324: Call_AnalyticsManagementWebpropertiesPatch_598310;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesPatch
  ## Updates an existing web property. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the web property belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598325 = newJObject()
  var query_598326 = newJObject()
  var body_598327 = newJObject()
  add(query_598326, "fields", newJString(fields))
  add(query_598326, "quotaUser", newJString(quotaUser))
  add(query_598326, "alt", newJString(alt))
  add(query_598326, "oauth_token", newJString(oauthToken))
  add(path_598325, "accountId", newJString(accountId))
  add(query_598326, "userIp", newJString(userIp))
  add(path_598325, "webPropertyId", newJString(webPropertyId))
  add(query_598326, "key", newJString(key))
  if body != nil:
    body_598327 = body
  add(query_598326, "prettyPrint", newJBool(prettyPrint))
  result = call_598324.call(path_598325, query_598326, nil, nil, body_598327)

var analyticsManagementWebpropertiesPatch* = Call_AnalyticsManagementWebpropertiesPatch_598310(
    name: "analyticsManagementWebpropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesPatch_598311,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesPatch_598312,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDataSourcesList_598328 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomDataSourcesList_598330(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDataSourcesList_598329(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List custom data sources to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id for the custom data sources to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the custom data sources to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598331 = path.getOrDefault("accountId")
  valid_598331 = validateParameter(valid_598331, JString, required = true,
                                 default = nil)
  if valid_598331 != nil:
    section.add "accountId", valid_598331
  var valid_598332 = path.getOrDefault("webPropertyId")
  valid_598332 = validateParameter(valid_598332, JString, required = true,
                                 default = nil)
  if valid_598332 != nil:
    section.add "webPropertyId", valid_598332
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of custom data sources to include in this response.
  ##   start-index: JInt
  ##              : A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598333 = query.getOrDefault("fields")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "fields", valid_598333
  var valid_598334 = query.getOrDefault("quotaUser")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "quotaUser", valid_598334
  var valid_598335 = query.getOrDefault("alt")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = newJString("json"))
  if valid_598335 != nil:
    section.add "alt", valid_598335
  var valid_598336 = query.getOrDefault("oauth_token")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "oauth_token", valid_598336
  var valid_598337 = query.getOrDefault("userIp")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "userIp", valid_598337
  var valid_598338 = query.getOrDefault("key")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "key", valid_598338
  var valid_598339 = query.getOrDefault("max-results")
  valid_598339 = validateParameter(valid_598339, JInt, required = false, default = nil)
  if valid_598339 != nil:
    section.add "max-results", valid_598339
  var valid_598340 = query.getOrDefault("start-index")
  valid_598340 = validateParameter(valid_598340, JInt, required = false, default = nil)
  if valid_598340 != nil:
    section.add "start-index", valid_598340
  var valid_598341 = query.getOrDefault("prettyPrint")
  valid_598341 = validateParameter(valid_598341, JBool, required = false,
                                 default = newJBool(false))
  if valid_598341 != nil:
    section.add "prettyPrint", valid_598341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598342: Call_AnalyticsManagementCustomDataSourcesList_598328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List custom data sources to which the user has access.
  ## 
  let valid = call_598342.validator(path, query, header, formData, body)
  let scheme = call_598342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598342.url(scheme.get, call_598342.host, call_598342.base,
                         call_598342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598342, url, valid)

proc call*(call_598343: Call_AnalyticsManagementCustomDataSourcesList_598328;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDataSourcesList
  ## List custom data sources to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the custom data sources to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the custom data sources to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of custom data sources to include in this response.
  ##   startIndex: int
  ##             : A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598344 = newJObject()
  var query_598345 = newJObject()
  add(query_598345, "fields", newJString(fields))
  add(query_598345, "quotaUser", newJString(quotaUser))
  add(query_598345, "alt", newJString(alt))
  add(query_598345, "oauth_token", newJString(oauthToken))
  add(path_598344, "accountId", newJString(accountId))
  add(query_598345, "userIp", newJString(userIp))
  add(path_598344, "webPropertyId", newJString(webPropertyId))
  add(query_598345, "key", newJString(key))
  add(query_598345, "max-results", newJInt(maxResults))
  add(query_598345, "start-index", newJInt(startIndex))
  add(query_598345, "prettyPrint", newJBool(prettyPrint))
  result = call_598343.call(path_598344, query_598345, nil, nil, nil)

var analyticsManagementCustomDataSourcesList* = Call_AnalyticsManagementCustomDataSourcesList_598328(
    name: "analyticsManagementCustomDataSourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources",
    validator: validate_AnalyticsManagementCustomDataSourcesList_598329,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDataSourcesList_598330,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsDeleteUploadData_598346 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUploadsDeleteUploadData_598348(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/deleteUploadData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsDeleteUploadData_598347(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete data associated with a previous upload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id for the uploads to be deleted.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the uploads to be deleted.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for the uploads to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598349 = path.getOrDefault("accountId")
  valid_598349 = validateParameter(valid_598349, JString, required = true,
                                 default = nil)
  if valid_598349 != nil:
    section.add "accountId", valid_598349
  var valid_598350 = path.getOrDefault("webPropertyId")
  valid_598350 = validateParameter(valid_598350, JString, required = true,
                                 default = nil)
  if valid_598350 != nil:
    section.add "webPropertyId", valid_598350
  var valid_598351 = path.getOrDefault("customDataSourceId")
  valid_598351 = validateParameter(valid_598351, JString, required = true,
                                 default = nil)
  if valid_598351 != nil:
    section.add "customDataSourceId", valid_598351
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598352 = query.getOrDefault("fields")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "fields", valid_598352
  var valid_598353 = query.getOrDefault("quotaUser")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "quotaUser", valid_598353
  var valid_598354 = query.getOrDefault("alt")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = newJString("json"))
  if valid_598354 != nil:
    section.add "alt", valid_598354
  var valid_598355 = query.getOrDefault("oauth_token")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "oauth_token", valid_598355
  var valid_598356 = query.getOrDefault("userIp")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = nil)
  if valid_598356 != nil:
    section.add "userIp", valid_598356
  var valid_598357 = query.getOrDefault("key")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "key", valid_598357
  var valid_598358 = query.getOrDefault("prettyPrint")
  valid_598358 = validateParameter(valid_598358, JBool, required = false,
                                 default = newJBool(false))
  if valid_598358 != nil:
    section.add "prettyPrint", valid_598358
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

proc call*(call_598360: Call_AnalyticsManagementUploadsDeleteUploadData_598346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete data associated with a previous upload.
  ## 
  let valid = call_598360.validator(path, query, header, formData, body)
  let scheme = call_598360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598360.url(scheme.get, call_598360.host, call_598360.base,
                         call_598360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598360, url, valid)

proc call*(call_598361: Call_AnalyticsManagementUploadsDeleteUploadData_598346;
          accountId: string; webPropertyId: string; customDataSourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsDeleteUploadData
  ## Delete data associated with a previous upload.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the uploads to be deleted.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the uploads to be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for the uploads to be deleted.
  var path_598362 = newJObject()
  var query_598363 = newJObject()
  var body_598364 = newJObject()
  add(query_598363, "fields", newJString(fields))
  add(query_598363, "quotaUser", newJString(quotaUser))
  add(query_598363, "alt", newJString(alt))
  add(query_598363, "oauth_token", newJString(oauthToken))
  add(path_598362, "accountId", newJString(accountId))
  add(query_598363, "userIp", newJString(userIp))
  add(path_598362, "webPropertyId", newJString(webPropertyId))
  add(query_598363, "key", newJString(key))
  if body != nil:
    body_598364 = body
  add(query_598363, "prettyPrint", newJBool(prettyPrint))
  add(path_598362, "customDataSourceId", newJString(customDataSourceId))
  result = call_598361.call(path_598362, query_598363, nil, nil, body_598364)

var analyticsManagementUploadsDeleteUploadData* = Call_AnalyticsManagementUploadsDeleteUploadData_598346(
    name: "analyticsManagementUploadsDeleteUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/deleteUploadData",
    validator: validate_AnalyticsManagementUploadsDeleteUploadData_598347,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsDeleteUploadData_598348,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsUploadData_598384 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUploadsUploadData_598386(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/uploads")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsUploadData_598385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload data for a custom data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id associated with the upload.
  ##   webPropertyId: JString (required)
  ##                : Web property UA-string associated with the upload.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id to which the data being uploaded belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598387 = path.getOrDefault("accountId")
  valid_598387 = validateParameter(valid_598387, JString, required = true,
                                 default = nil)
  if valid_598387 != nil:
    section.add "accountId", valid_598387
  var valid_598388 = path.getOrDefault("webPropertyId")
  valid_598388 = validateParameter(valid_598388, JString, required = true,
                                 default = nil)
  if valid_598388 != nil:
    section.add "webPropertyId", valid_598388
  var valid_598389 = path.getOrDefault("customDataSourceId")
  valid_598389 = validateParameter(valid_598389, JString, required = true,
                                 default = nil)
  if valid_598389 != nil:
    section.add "customDataSourceId", valid_598389
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598390 = query.getOrDefault("fields")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "fields", valid_598390
  var valid_598391 = query.getOrDefault("quotaUser")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "quotaUser", valid_598391
  var valid_598392 = query.getOrDefault("alt")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = newJString("json"))
  if valid_598392 != nil:
    section.add "alt", valid_598392
  var valid_598393 = query.getOrDefault("oauth_token")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "oauth_token", valid_598393
  var valid_598394 = query.getOrDefault("userIp")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = nil)
  if valid_598394 != nil:
    section.add "userIp", valid_598394
  var valid_598395 = query.getOrDefault("key")
  valid_598395 = validateParameter(valid_598395, JString, required = false,
                                 default = nil)
  if valid_598395 != nil:
    section.add "key", valid_598395
  var valid_598396 = query.getOrDefault("prettyPrint")
  valid_598396 = validateParameter(valid_598396, JBool, required = false,
                                 default = newJBool(false))
  if valid_598396 != nil:
    section.add "prettyPrint", valid_598396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598397: Call_AnalyticsManagementUploadsUploadData_598384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload data for a custom data source.
  ## 
  let valid = call_598397.validator(path, query, header, formData, body)
  let scheme = call_598397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598397.url(scheme.get, call_598397.host, call_598397.base,
                         call_598397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598397, url, valid)

proc call*(call_598398: Call_AnalyticsManagementUploadsUploadData_598384;
          accountId: string; webPropertyId: string; customDataSourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsUploadData
  ## Upload data for a custom data source.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id associated with the upload.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property UA-string associated with the upload.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id to which the data being uploaded belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598399 = newJObject()
  var query_598400 = newJObject()
  add(query_598400, "fields", newJString(fields))
  add(query_598400, "quotaUser", newJString(quotaUser))
  add(query_598400, "alt", newJString(alt))
  add(query_598400, "oauth_token", newJString(oauthToken))
  add(path_598399, "accountId", newJString(accountId))
  add(query_598400, "userIp", newJString(userIp))
  add(path_598399, "webPropertyId", newJString(webPropertyId))
  add(query_598400, "key", newJString(key))
  add(path_598399, "customDataSourceId", newJString(customDataSourceId))
  add(query_598400, "prettyPrint", newJBool(prettyPrint))
  result = call_598398.call(path_598399, query_598400, nil, nil, nil)

var analyticsManagementUploadsUploadData* = Call_AnalyticsManagementUploadsUploadData_598384(
    name: "analyticsManagementUploadsUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsUploadData_598385,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsUploadData_598386,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsList_598365 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUploadsList_598367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/uploads")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsList_598366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List uploads to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id for the uploads to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the uploads to retrieve.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for uploads to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598368 = path.getOrDefault("accountId")
  valid_598368 = validateParameter(valid_598368, JString, required = true,
                                 default = nil)
  if valid_598368 != nil:
    section.add "accountId", valid_598368
  var valid_598369 = path.getOrDefault("webPropertyId")
  valid_598369 = validateParameter(valid_598369, JString, required = true,
                                 default = nil)
  if valid_598369 != nil:
    section.add "webPropertyId", valid_598369
  var valid_598370 = path.getOrDefault("customDataSourceId")
  valid_598370 = validateParameter(valid_598370, JString, required = true,
                                 default = nil)
  if valid_598370 != nil:
    section.add "customDataSourceId", valid_598370
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of uploads to include in this response.
  ##   start-index: JInt
  ##              : A 1-based index of the first upload to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598371 = query.getOrDefault("fields")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "fields", valid_598371
  var valid_598372 = query.getOrDefault("quotaUser")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "quotaUser", valid_598372
  var valid_598373 = query.getOrDefault("alt")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = newJString("json"))
  if valid_598373 != nil:
    section.add "alt", valid_598373
  var valid_598374 = query.getOrDefault("oauth_token")
  valid_598374 = validateParameter(valid_598374, JString, required = false,
                                 default = nil)
  if valid_598374 != nil:
    section.add "oauth_token", valid_598374
  var valid_598375 = query.getOrDefault("userIp")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "userIp", valid_598375
  var valid_598376 = query.getOrDefault("key")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "key", valid_598376
  var valid_598377 = query.getOrDefault("max-results")
  valid_598377 = validateParameter(valid_598377, JInt, required = false, default = nil)
  if valid_598377 != nil:
    section.add "max-results", valid_598377
  var valid_598378 = query.getOrDefault("start-index")
  valid_598378 = validateParameter(valid_598378, JInt, required = false, default = nil)
  if valid_598378 != nil:
    section.add "start-index", valid_598378
  var valid_598379 = query.getOrDefault("prettyPrint")
  valid_598379 = validateParameter(valid_598379, JBool, required = false,
                                 default = newJBool(false))
  if valid_598379 != nil:
    section.add "prettyPrint", valid_598379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598380: Call_AnalyticsManagementUploadsList_598365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_598380.validator(path, query, header, formData, body)
  let scheme = call_598380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598380.url(scheme.get, call_598380.host, call_598380.base,
                         call_598380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598380, url, valid)

proc call*(call_598381: Call_AnalyticsManagementUploadsList_598365;
          accountId: string; webPropertyId: string; customDataSourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsList
  ## List uploads to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the uploads to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the uploads to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of uploads to include in this response.
  ##   startIndex: int
  ##             : A 1-based index of the first upload to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for uploads to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598382 = newJObject()
  var query_598383 = newJObject()
  add(query_598383, "fields", newJString(fields))
  add(query_598383, "quotaUser", newJString(quotaUser))
  add(query_598383, "alt", newJString(alt))
  add(query_598383, "oauth_token", newJString(oauthToken))
  add(path_598382, "accountId", newJString(accountId))
  add(query_598383, "userIp", newJString(userIp))
  add(path_598382, "webPropertyId", newJString(webPropertyId))
  add(query_598383, "key", newJString(key))
  add(query_598383, "max-results", newJInt(maxResults))
  add(query_598383, "start-index", newJInt(startIndex))
  add(path_598382, "customDataSourceId", newJString(customDataSourceId))
  add(query_598383, "prettyPrint", newJBool(prettyPrint))
  result = call_598381.call(path_598382, query_598383, nil, nil, nil)

var analyticsManagementUploadsList* = Call_AnalyticsManagementUploadsList_598365(
    name: "analyticsManagementUploadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsList_598366,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsList_598367,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsGet_598401 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUploadsGet_598403(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  assert "uploadId" in path, "`uploadId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/uploads/"),
               (kind: VariableSegment, value: "uploadId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsGet_598402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List uploads to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uploadId: JString (required)
  ##           : Upload Id to retrieve.
  ##   accountId: JString (required)
  ##            : Account Id for the upload to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the upload to retrieve.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for upload to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uploadId` field"
  var valid_598404 = path.getOrDefault("uploadId")
  valid_598404 = validateParameter(valid_598404, JString, required = true,
                                 default = nil)
  if valid_598404 != nil:
    section.add "uploadId", valid_598404
  var valid_598405 = path.getOrDefault("accountId")
  valid_598405 = validateParameter(valid_598405, JString, required = true,
                                 default = nil)
  if valid_598405 != nil:
    section.add "accountId", valid_598405
  var valid_598406 = path.getOrDefault("webPropertyId")
  valid_598406 = validateParameter(valid_598406, JString, required = true,
                                 default = nil)
  if valid_598406 != nil:
    section.add "webPropertyId", valid_598406
  var valid_598407 = path.getOrDefault("customDataSourceId")
  valid_598407 = validateParameter(valid_598407, JString, required = true,
                                 default = nil)
  if valid_598407 != nil:
    section.add "customDataSourceId", valid_598407
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598408 = query.getOrDefault("fields")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "fields", valid_598408
  var valid_598409 = query.getOrDefault("quotaUser")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "quotaUser", valid_598409
  var valid_598410 = query.getOrDefault("alt")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = newJString("json"))
  if valid_598410 != nil:
    section.add "alt", valid_598410
  var valid_598411 = query.getOrDefault("oauth_token")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = nil)
  if valid_598411 != nil:
    section.add "oauth_token", valid_598411
  var valid_598412 = query.getOrDefault("userIp")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "userIp", valid_598412
  var valid_598413 = query.getOrDefault("key")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "key", valid_598413
  var valid_598414 = query.getOrDefault("prettyPrint")
  valid_598414 = validateParameter(valid_598414, JBool, required = false,
                                 default = newJBool(false))
  if valid_598414 != nil:
    section.add "prettyPrint", valid_598414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598415: Call_AnalyticsManagementUploadsGet_598401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_598415.validator(path, query, header, formData, body)
  let scheme = call_598415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598415.url(scheme.get, call_598415.host, call_598415.base,
                         call_598415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598415, url, valid)

proc call*(call_598416: Call_AnalyticsManagementUploadsGet_598401;
          uploadId: string; accountId: string; webPropertyId: string;
          customDataSourceId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsGet
  ## List uploads to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadId: string (required)
  ##           : Upload Id to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the upload to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the upload to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for upload to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598417 = newJObject()
  var query_598418 = newJObject()
  add(query_598418, "fields", newJString(fields))
  add(path_598417, "uploadId", newJString(uploadId))
  add(query_598418, "quotaUser", newJString(quotaUser))
  add(query_598418, "alt", newJString(alt))
  add(query_598418, "oauth_token", newJString(oauthToken))
  add(path_598417, "accountId", newJString(accountId))
  add(query_598418, "userIp", newJString(userIp))
  add(path_598417, "webPropertyId", newJString(webPropertyId))
  add(query_598418, "key", newJString(key))
  add(path_598417, "customDataSourceId", newJString(customDataSourceId))
  add(query_598418, "prettyPrint", newJBool(prettyPrint))
  result = call_598416.call(path_598417, query_598418, nil, nil, nil)

var analyticsManagementUploadsGet* = Call_AnalyticsManagementUploadsGet_598401(
    name: "analyticsManagementUploadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads/{uploadId}",
    validator: validate_AnalyticsManagementUploadsGet_598402,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsGet_598403,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsInsert_598437 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomDimensionsInsert_598439(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsInsert_598438(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new custom dimension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to create.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598440 = path.getOrDefault("accountId")
  valid_598440 = validateParameter(valid_598440, JString, required = true,
                                 default = nil)
  if valid_598440 != nil:
    section.add "accountId", valid_598440
  var valid_598441 = path.getOrDefault("webPropertyId")
  valid_598441 = validateParameter(valid_598441, JString, required = true,
                                 default = nil)
  if valid_598441 != nil:
    section.add "webPropertyId", valid_598441
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598442 = query.getOrDefault("fields")
  valid_598442 = validateParameter(valid_598442, JString, required = false,
                                 default = nil)
  if valid_598442 != nil:
    section.add "fields", valid_598442
  var valid_598443 = query.getOrDefault("quotaUser")
  valid_598443 = validateParameter(valid_598443, JString, required = false,
                                 default = nil)
  if valid_598443 != nil:
    section.add "quotaUser", valid_598443
  var valid_598444 = query.getOrDefault("alt")
  valid_598444 = validateParameter(valid_598444, JString, required = false,
                                 default = newJString("json"))
  if valid_598444 != nil:
    section.add "alt", valid_598444
  var valid_598445 = query.getOrDefault("oauth_token")
  valid_598445 = validateParameter(valid_598445, JString, required = false,
                                 default = nil)
  if valid_598445 != nil:
    section.add "oauth_token", valid_598445
  var valid_598446 = query.getOrDefault("userIp")
  valid_598446 = validateParameter(valid_598446, JString, required = false,
                                 default = nil)
  if valid_598446 != nil:
    section.add "userIp", valid_598446
  var valid_598447 = query.getOrDefault("key")
  valid_598447 = validateParameter(valid_598447, JString, required = false,
                                 default = nil)
  if valid_598447 != nil:
    section.add "key", valid_598447
  var valid_598448 = query.getOrDefault("prettyPrint")
  valid_598448 = validateParameter(valid_598448, JBool, required = false,
                                 default = newJBool(false))
  if valid_598448 != nil:
    section.add "prettyPrint", valid_598448
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

proc call*(call_598450: Call_AnalyticsManagementCustomDimensionsInsert_598437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom dimension.
  ## 
  let valid = call_598450.validator(path, query, header, formData, body)
  let scheme = call_598450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598450.url(scheme.get, call_598450.host, call_598450.base,
                         call_598450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598450, url, valid)

proc call*(call_598451: Call_AnalyticsManagementCustomDimensionsInsert_598437;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsInsert
  ## Create a new custom dimension.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to create.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to create.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598452 = newJObject()
  var query_598453 = newJObject()
  var body_598454 = newJObject()
  add(query_598453, "fields", newJString(fields))
  add(query_598453, "quotaUser", newJString(quotaUser))
  add(query_598453, "alt", newJString(alt))
  add(query_598453, "oauth_token", newJString(oauthToken))
  add(path_598452, "accountId", newJString(accountId))
  add(query_598453, "userIp", newJString(userIp))
  add(path_598452, "webPropertyId", newJString(webPropertyId))
  add(query_598453, "key", newJString(key))
  if body != nil:
    body_598454 = body
  add(query_598453, "prettyPrint", newJBool(prettyPrint))
  result = call_598451.call(path_598452, query_598453, nil, nil, body_598454)

var analyticsManagementCustomDimensionsInsert* = Call_AnalyticsManagementCustomDimensionsInsert_598437(
    name: "analyticsManagementCustomDimensionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsInsert_598438,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsInsert_598439,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsList_598419 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomDimensionsList_598421(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsList_598420(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists custom dimensions to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimensions to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimensions to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598422 = path.getOrDefault("accountId")
  valid_598422 = validateParameter(valid_598422, JString, required = true,
                                 default = nil)
  if valid_598422 != nil:
    section.add "accountId", valid_598422
  var valid_598423 = path.getOrDefault("webPropertyId")
  valid_598423 = validateParameter(valid_598423, JString, required = true,
                                 default = nil)
  if valid_598423 != nil:
    section.add "webPropertyId", valid_598423
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of custom dimensions to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598424 = query.getOrDefault("fields")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = nil)
  if valid_598424 != nil:
    section.add "fields", valid_598424
  var valid_598425 = query.getOrDefault("quotaUser")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = nil)
  if valid_598425 != nil:
    section.add "quotaUser", valid_598425
  var valid_598426 = query.getOrDefault("alt")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = newJString("json"))
  if valid_598426 != nil:
    section.add "alt", valid_598426
  var valid_598427 = query.getOrDefault("oauth_token")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "oauth_token", valid_598427
  var valid_598428 = query.getOrDefault("userIp")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = nil)
  if valid_598428 != nil:
    section.add "userIp", valid_598428
  var valid_598429 = query.getOrDefault("key")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "key", valid_598429
  var valid_598430 = query.getOrDefault("max-results")
  valid_598430 = validateParameter(valid_598430, JInt, required = false, default = nil)
  if valid_598430 != nil:
    section.add "max-results", valid_598430
  var valid_598431 = query.getOrDefault("start-index")
  valid_598431 = validateParameter(valid_598431, JInt, required = false, default = nil)
  if valid_598431 != nil:
    section.add "start-index", valid_598431
  var valid_598432 = query.getOrDefault("prettyPrint")
  valid_598432 = validateParameter(valid_598432, JBool, required = false,
                                 default = newJBool(false))
  if valid_598432 != nil:
    section.add "prettyPrint", valid_598432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598433: Call_AnalyticsManagementCustomDimensionsList_598419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom dimensions to which the user has access.
  ## 
  let valid = call_598433.validator(path, query, header, formData, body)
  let scheme = call_598433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598433.url(scheme.get, call_598433.host, call_598433.base,
                         call_598433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598433, url, valid)

proc call*(call_598434: Call_AnalyticsManagementCustomDimensionsList_598419;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsList
  ## Lists custom dimensions to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimensions to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimensions to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of custom dimensions to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598435 = newJObject()
  var query_598436 = newJObject()
  add(query_598436, "fields", newJString(fields))
  add(query_598436, "quotaUser", newJString(quotaUser))
  add(query_598436, "alt", newJString(alt))
  add(query_598436, "oauth_token", newJString(oauthToken))
  add(path_598435, "accountId", newJString(accountId))
  add(query_598436, "userIp", newJString(userIp))
  add(path_598435, "webPropertyId", newJString(webPropertyId))
  add(query_598436, "key", newJString(key))
  add(query_598436, "max-results", newJInt(maxResults))
  add(query_598436, "start-index", newJInt(startIndex))
  add(query_598436, "prettyPrint", newJBool(prettyPrint))
  result = call_598434.call(path_598435, query_598436, nil, nil, nil)

var analyticsManagementCustomDimensionsList* = Call_AnalyticsManagementCustomDimensionsList_598419(
    name: "analyticsManagementCustomDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsList_598420,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsList_598421,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsUpdate_598472 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomDimensionsUpdate_598474(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDimensionId" in path,
        "`customDimensionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions/"),
               (kind: VariableSegment, value: "customDimensionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsUpdate_598473(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom dimension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDimensionId: JString (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDimensionId` field"
  var valid_598475 = path.getOrDefault("customDimensionId")
  valid_598475 = validateParameter(valid_598475, JString, required = true,
                                 default = nil)
  if valid_598475 != nil:
    section.add "customDimensionId", valid_598475
  var valid_598476 = path.getOrDefault("accountId")
  valid_598476 = validateParameter(valid_598476, JString, required = true,
                                 default = nil)
  if valid_598476 != nil:
    section.add "accountId", valid_598476
  var valid_598477 = path.getOrDefault("webPropertyId")
  valid_598477 = validateParameter(valid_598477, JString, required = true,
                                 default = nil)
  if valid_598477 != nil:
    section.add "webPropertyId", valid_598477
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598478 = query.getOrDefault("fields")
  valid_598478 = validateParameter(valid_598478, JString, required = false,
                                 default = nil)
  if valid_598478 != nil:
    section.add "fields", valid_598478
  var valid_598479 = query.getOrDefault("quotaUser")
  valid_598479 = validateParameter(valid_598479, JString, required = false,
                                 default = nil)
  if valid_598479 != nil:
    section.add "quotaUser", valid_598479
  var valid_598480 = query.getOrDefault("alt")
  valid_598480 = validateParameter(valid_598480, JString, required = false,
                                 default = newJString("json"))
  if valid_598480 != nil:
    section.add "alt", valid_598480
  var valid_598481 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_598481 = validateParameter(valid_598481, JBool, required = false,
                                 default = newJBool(false))
  if valid_598481 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_598481
  var valid_598482 = query.getOrDefault("oauth_token")
  valid_598482 = validateParameter(valid_598482, JString, required = false,
                                 default = nil)
  if valid_598482 != nil:
    section.add "oauth_token", valid_598482
  var valid_598483 = query.getOrDefault("userIp")
  valid_598483 = validateParameter(valid_598483, JString, required = false,
                                 default = nil)
  if valid_598483 != nil:
    section.add "userIp", valid_598483
  var valid_598484 = query.getOrDefault("key")
  valid_598484 = validateParameter(valid_598484, JString, required = false,
                                 default = nil)
  if valid_598484 != nil:
    section.add "key", valid_598484
  var valid_598485 = query.getOrDefault("prettyPrint")
  valid_598485 = validateParameter(valid_598485, JBool, required = false,
                                 default = newJBool(false))
  if valid_598485 != nil:
    section.add "prettyPrint", valid_598485
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

proc call*(call_598487: Call_AnalyticsManagementCustomDimensionsUpdate_598472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension.
  ## 
  let valid = call_598487.validator(path, query, header, formData, body)
  let scheme = call_598487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598487.url(scheme.get, call_598487.host, call_598487.base,
                         call_598487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598487, url, valid)

proc call*(call_598488: Call_AnalyticsManagementCustomDimensionsUpdate_598472;
          customDimensionId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsUpdate
  ## Updates an existing custom dimension.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDimensionId: string (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598489 = newJObject()
  var query_598490 = newJObject()
  var body_598491 = newJObject()
  add(query_598490, "fields", newJString(fields))
  add(path_598489, "customDimensionId", newJString(customDimensionId))
  add(query_598490, "quotaUser", newJString(quotaUser))
  add(query_598490, "alt", newJString(alt))
  add(query_598490, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_598490, "oauth_token", newJString(oauthToken))
  add(path_598489, "accountId", newJString(accountId))
  add(query_598490, "userIp", newJString(userIp))
  add(path_598489, "webPropertyId", newJString(webPropertyId))
  add(query_598490, "key", newJString(key))
  if body != nil:
    body_598491 = body
  add(query_598490, "prettyPrint", newJBool(prettyPrint))
  result = call_598488.call(path_598489, query_598490, nil, nil, body_598491)

var analyticsManagementCustomDimensionsUpdate* = Call_AnalyticsManagementCustomDimensionsUpdate_598472(
    name: "analyticsManagementCustomDimensionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsUpdate_598473,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsUpdate_598474,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsGet_598455 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomDimensionsGet_598457(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDimensionId" in path,
        "`customDimensionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions/"),
               (kind: VariableSegment, value: "customDimensionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsGet_598456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a custom dimension to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDimensionId: JString (required)
  ##                    : The ID of the custom dimension to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDimensionId` field"
  var valid_598458 = path.getOrDefault("customDimensionId")
  valid_598458 = validateParameter(valid_598458, JString, required = true,
                                 default = nil)
  if valid_598458 != nil:
    section.add "customDimensionId", valid_598458
  var valid_598459 = path.getOrDefault("accountId")
  valid_598459 = validateParameter(valid_598459, JString, required = true,
                                 default = nil)
  if valid_598459 != nil:
    section.add "accountId", valid_598459
  var valid_598460 = path.getOrDefault("webPropertyId")
  valid_598460 = validateParameter(valid_598460, JString, required = true,
                                 default = nil)
  if valid_598460 != nil:
    section.add "webPropertyId", valid_598460
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598461 = query.getOrDefault("fields")
  valid_598461 = validateParameter(valid_598461, JString, required = false,
                                 default = nil)
  if valid_598461 != nil:
    section.add "fields", valid_598461
  var valid_598462 = query.getOrDefault("quotaUser")
  valid_598462 = validateParameter(valid_598462, JString, required = false,
                                 default = nil)
  if valid_598462 != nil:
    section.add "quotaUser", valid_598462
  var valid_598463 = query.getOrDefault("alt")
  valid_598463 = validateParameter(valid_598463, JString, required = false,
                                 default = newJString("json"))
  if valid_598463 != nil:
    section.add "alt", valid_598463
  var valid_598464 = query.getOrDefault("oauth_token")
  valid_598464 = validateParameter(valid_598464, JString, required = false,
                                 default = nil)
  if valid_598464 != nil:
    section.add "oauth_token", valid_598464
  var valid_598465 = query.getOrDefault("userIp")
  valid_598465 = validateParameter(valid_598465, JString, required = false,
                                 default = nil)
  if valid_598465 != nil:
    section.add "userIp", valid_598465
  var valid_598466 = query.getOrDefault("key")
  valid_598466 = validateParameter(valid_598466, JString, required = false,
                                 default = nil)
  if valid_598466 != nil:
    section.add "key", valid_598466
  var valid_598467 = query.getOrDefault("prettyPrint")
  valid_598467 = validateParameter(valid_598467, JBool, required = false,
                                 default = newJBool(false))
  if valid_598467 != nil:
    section.add "prettyPrint", valid_598467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598468: Call_AnalyticsManagementCustomDimensionsGet_598455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom dimension to which the user has access.
  ## 
  let valid = call_598468.validator(path, query, header, formData, body)
  let scheme = call_598468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598468.url(scheme.get, call_598468.host, call_598468.base,
                         call_598468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598468, url, valid)

proc call*(call_598469: Call_AnalyticsManagementCustomDimensionsGet_598455;
          customDimensionId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsGet
  ## Get a custom dimension to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDimensionId: string (required)
  ##                    : The ID of the custom dimension to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598470 = newJObject()
  var query_598471 = newJObject()
  add(query_598471, "fields", newJString(fields))
  add(path_598470, "customDimensionId", newJString(customDimensionId))
  add(query_598471, "quotaUser", newJString(quotaUser))
  add(query_598471, "alt", newJString(alt))
  add(query_598471, "oauth_token", newJString(oauthToken))
  add(path_598470, "accountId", newJString(accountId))
  add(query_598471, "userIp", newJString(userIp))
  add(path_598470, "webPropertyId", newJString(webPropertyId))
  add(query_598471, "key", newJString(key))
  add(query_598471, "prettyPrint", newJBool(prettyPrint))
  result = call_598469.call(path_598470, query_598471, nil, nil, nil)

var analyticsManagementCustomDimensionsGet* = Call_AnalyticsManagementCustomDimensionsGet_598455(
    name: "analyticsManagementCustomDimensionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsGet_598456,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsGet_598457,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsPatch_598492 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomDimensionsPatch_598494(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDimensionId" in path,
        "`customDimensionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions/"),
               (kind: VariableSegment, value: "customDimensionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsPatch_598493(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom dimension. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDimensionId: JString (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDimensionId` field"
  var valid_598495 = path.getOrDefault("customDimensionId")
  valid_598495 = validateParameter(valid_598495, JString, required = true,
                                 default = nil)
  if valid_598495 != nil:
    section.add "customDimensionId", valid_598495
  var valid_598496 = path.getOrDefault("accountId")
  valid_598496 = validateParameter(valid_598496, JString, required = true,
                                 default = nil)
  if valid_598496 != nil:
    section.add "accountId", valid_598496
  var valid_598497 = path.getOrDefault("webPropertyId")
  valid_598497 = validateParameter(valid_598497, JString, required = true,
                                 default = nil)
  if valid_598497 != nil:
    section.add "webPropertyId", valid_598497
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598498 = query.getOrDefault("fields")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "fields", valid_598498
  var valid_598499 = query.getOrDefault("quotaUser")
  valid_598499 = validateParameter(valid_598499, JString, required = false,
                                 default = nil)
  if valid_598499 != nil:
    section.add "quotaUser", valid_598499
  var valid_598500 = query.getOrDefault("alt")
  valid_598500 = validateParameter(valid_598500, JString, required = false,
                                 default = newJString("json"))
  if valid_598500 != nil:
    section.add "alt", valid_598500
  var valid_598501 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_598501 = validateParameter(valid_598501, JBool, required = false,
                                 default = newJBool(false))
  if valid_598501 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_598501
  var valid_598502 = query.getOrDefault("oauth_token")
  valid_598502 = validateParameter(valid_598502, JString, required = false,
                                 default = nil)
  if valid_598502 != nil:
    section.add "oauth_token", valid_598502
  var valid_598503 = query.getOrDefault("userIp")
  valid_598503 = validateParameter(valid_598503, JString, required = false,
                                 default = nil)
  if valid_598503 != nil:
    section.add "userIp", valid_598503
  var valid_598504 = query.getOrDefault("key")
  valid_598504 = validateParameter(valid_598504, JString, required = false,
                                 default = nil)
  if valid_598504 != nil:
    section.add "key", valid_598504
  var valid_598505 = query.getOrDefault("prettyPrint")
  valid_598505 = validateParameter(valid_598505, JBool, required = false,
                                 default = newJBool(false))
  if valid_598505 != nil:
    section.add "prettyPrint", valid_598505
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

proc call*(call_598507: Call_AnalyticsManagementCustomDimensionsPatch_598492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension. This method supports patch semantics.
  ## 
  let valid = call_598507.validator(path, query, header, formData, body)
  let scheme = call_598507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598507.url(scheme.get, call_598507.host, call_598507.base,
                         call_598507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598507, url, valid)

proc call*(call_598508: Call_AnalyticsManagementCustomDimensionsPatch_598492;
          customDimensionId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsPatch
  ## Updates an existing custom dimension. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDimensionId: string (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598509 = newJObject()
  var query_598510 = newJObject()
  var body_598511 = newJObject()
  add(query_598510, "fields", newJString(fields))
  add(path_598509, "customDimensionId", newJString(customDimensionId))
  add(query_598510, "quotaUser", newJString(quotaUser))
  add(query_598510, "alt", newJString(alt))
  add(query_598510, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_598510, "oauth_token", newJString(oauthToken))
  add(path_598509, "accountId", newJString(accountId))
  add(query_598510, "userIp", newJString(userIp))
  add(path_598509, "webPropertyId", newJString(webPropertyId))
  add(query_598510, "key", newJString(key))
  if body != nil:
    body_598511 = body
  add(query_598510, "prettyPrint", newJBool(prettyPrint))
  result = call_598508.call(path_598509, query_598510, nil, nil, body_598511)

var analyticsManagementCustomDimensionsPatch* = Call_AnalyticsManagementCustomDimensionsPatch_598492(
    name: "analyticsManagementCustomDimensionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsPatch_598493,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsPatch_598494,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsInsert_598530 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomMetricsInsert_598532(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsInsert_598531(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new custom metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to create.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598533 = path.getOrDefault("accountId")
  valid_598533 = validateParameter(valid_598533, JString, required = true,
                                 default = nil)
  if valid_598533 != nil:
    section.add "accountId", valid_598533
  var valid_598534 = path.getOrDefault("webPropertyId")
  valid_598534 = validateParameter(valid_598534, JString, required = true,
                                 default = nil)
  if valid_598534 != nil:
    section.add "webPropertyId", valid_598534
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598535 = query.getOrDefault("fields")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "fields", valid_598535
  var valid_598536 = query.getOrDefault("quotaUser")
  valid_598536 = validateParameter(valid_598536, JString, required = false,
                                 default = nil)
  if valid_598536 != nil:
    section.add "quotaUser", valid_598536
  var valid_598537 = query.getOrDefault("alt")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = newJString("json"))
  if valid_598537 != nil:
    section.add "alt", valid_598537
  var valid_598538 = query.getOrDefault("oauth_token")
  valid_598538 = validateParameter(valid_598538, JString, required = false,
                                 default = nil)
  if valid_598538 != nil:
    section.add "oauth_token", valid_598538
  var valid_598539 = query.getOrDefault("userIp")
  valid_598539 = validateParameter(valid_598539, JString, required = false,
                                 default = nil)
  if valid_598539 != nil:
    section.add "userIp", valid_598539
  var valid_598540 = query.getOrDefault("key")
  valid_598540 = validateParameter(valid_598540, JString, required = false,
                                 default = nil)
  if valid_598540 != nil:
    section.add "key", valid_598540
  var valid_598541 = query.getOrDefault("prettyPrint")
  valid_598541 = validateParameter(valid_598541, JBool, required = false,
                                 default = newJBool(false))
  if valid_598541 != nil:
    section.add "prettyPrint", valid_598541
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

proc call*(call_598543: Call_AnalyticsManagementCustomMetricsInsert_598530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom metric.
  ## 
  let valid = call_598543.validator(path, query, header, formData, body)
  let scheme = call_598543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598543.url(scheme.get, call_598543.host, call_598543.base,
                         call_598543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598543, url, valid)

proc call*(call_598544: Call_AnalyticsManagementCustomMetricsInsert_598530;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsInsert
  ## Create a new custom metric.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to create.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to create.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598545 = newJObject()
  var query_598546 = newJObject()
  var body_598547 = newJObject()
  add(query_598546, "fields", newJString(fields))
  add(query_598546, "quotaUser", newJString(quotaUser))
  add(query_598546, "alt", newJString(alt))
  add(query_598546, "oauth_token", newJString(oauthToken))
  add(path_598545, "accountId", newJString(accountId))
  add(query_598546, "userIp", newJString(userIp))
  add(path_598545, "webPropertyId", newJString(webPropertyId))
  add(query_598546, "key", newJString(key))
  if body != nil:
    body_598547 = body
  add(query_598546, "prettyPrint", newJBool(prettyPrint))
  result = call_598544.call(path_598545, query_598546, nil, nil, body_598547)

var analyticsManagementCustomMetricsInsert* = Call_AnalyticsManagementCustomMetricsInsert_598530(
    name: "analyticsManagementCustomMetricsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsInsert_598531,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsInsert_598532,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsList_598512 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomMetricsList_598514(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsList_598513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists custom metrics to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom metrics to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metrics to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598515 = path.getOrDefault("accountId")
  valid_598515 = validateParameter(valid_598515, JString, required = true,
                                 default = nil)
  if valid_598515 != nil:
    section.add "accountId", valid_598515
  var valid_598516 = path.getOrDefault("webPropertyId")
  valid_598516 = validateParameter(valid_598516, JString, required = true,
                                 default = nil)
  if valid_598516 != nil:
    section.add "webPropertyId", valid_598516
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of custom metrics to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598517 = query.getOrDefault("fields")
  valid_598517 = validateParameter(valid_598517, JString, required = false,
                                 default = nil)
  if valid_598517 != nil:
    section.add "fields", valid_598517
  var valid_598518 = query.getOrDefault("quotaUser")
  valid_598518 = validateParameter(valid_598518, JString, required = false,
                                 default = nil)
  if valid_598518 != nil:
    section.add "quotaUser", valid_598518
  var valid_598519 = query.getOrDefault("alt")
  valid_598519 = validateParameter(valid_598519, JString, required = false,
                                 default = newJString("json"))
  if valid_598519 != nil:
    section.add "alt", valid_598519
  var valid_598520 = query.getOrDefault("oauth_token")
  valid_598520 = validateParameter(valid_598520, JString, required = false,
                                 default = nil)
  if valid_598520 != nil:
    section.add "oauth_token", valid_598520
  var valid_598521 = query.getOrDefault("userIp")
  valid_598521 = validateParameter(valid_598521, JString, required = false,
                                 default = nil)
  if valid_598521 != nil:
    section.add "userIp", valid_598521
  var valid_598522 = query.getOrDefault("key")
  valid_598522 = validateParameter(valid_598522, JString, required = false,
                                 default = nil)
  if valid_598522 != nil:
    section.add "key", valid_598522
  var valid_598523 = query.getOrDefault("max-results")
  valid_598523 = validateParameter(valid_598523, JInt, required = false, default = nil)
  if valid_598523 != nil:
    section.add "max-results", valid_598523
  var valid_598524 = query.getOrDefault("start-index")
  valid_598524 = validateParameter(valid_598524, JInt, required = false, default = nil)
  if valid_598524 != nil:
    section.add "start-index", valid_598524
  var valid_598525 = query.getOrDefault("prettyPrint")
  valid_598525 = validateParameter(valid_598525, JBool, required = false,
                                 default = newJBool(false))
  if valid_598525 != nil:
    section.add "prettyPrint", valid_598525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598526: Call_AnalyticsManagementCustomMetricsList_598512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom metrics to which the user has access.
  ## 
  let valid = call_598526.validator(path, query, header, formData, body)
  let scheme = call_598526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598526.url(scheme.get, call_598526.host, call_598526.base,
                         call_598526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598526, url, valid)

proc call*(call_598527: Call_AnalyticsManagementCustomMetricsList_598512;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsList
  ## Lists custom metrics to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metrics to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metrics to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of custom metrics to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598528 = newJObject()
  var query_598529 = newJObject()
  add(query_598529, "fields", newJString(fields))
  add(query_598529, "quotaUser", newJString(quotaUser))
  add(query_598529, "alt", newJString(alt))
  add(query_598529, "oauth_token", newJString(oauthToken))
  add(path_598528, "accountId", newJString(accountId))
  add(query_598529, "userIp", newJString(userIp))
  add(path_598528, "webPropertyId", newJString(webPropertyId))
  add(query_598529, "key", newJString(key))
  add(query_598529, "max-results", newJInt(maxResults))
  add(query_598529, "start-index", newJInt(startIndex))
  add(query_598529, "prettyPrint", newJBool(prettyPrint))
  result = call_598527.call(path_598528, query_598529, nil, nil, nil)

var analyticsManagementCustomMetricsList* = Call_AnalyticsManagementCustomMetricsList_598512(
    name: "analyticsManagementCustomMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsList_598513,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsList_598514,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsUpdate_598565 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomMetricsUpdate_598567(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customMetricId" in path, "`customMetricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics/"),
               (kind: VariableSegment, value: "customMetricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsUpdate_598566(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customMetricId: JString (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customMetricId` field"
  var valid_598568 = path.getOrDefault("customMetricId")
  valid_598568 = validateParameter(valid_598568, JString, required = true,
                                 default = nil)
  if valid_598568 != nil:
    section.add "customMetricId", valid_598568
  var valid_598569 = path.getOrDefault("accountId")
  valid_598569 = validateParameter(valid_598569, JString, required = true,
                                 default = nil)
  if valid_598569 != nil:
    section.add "accountId", valid_598569
  var valid_598570 = path.getOrDefault("webPropertyId")
  valid_598570 = validateParameter(valid_598570, JString, required = true,
                                 default = nil)
  if valid_598570 != nil:
    section.add "webPropertyId", valid_598570
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598571 = query.getOrDefault("fields")
  valid_598571 = validateParameter(valid_598571, JString, required = false,
                                 default = nil)
  if valid_598571 != nil:
    section.add "fields", valid_598571
  var valid_598572 = query.getOrDefault("quotaUser")
  valid_598572 = validateParameter(valid_598572, JString, required = false,
                                 default = nil)
  if valid_598572 != nil:
    section.add "quotaUser", valid_598572
  var valid_598573 = query.getOrDefault("alt")
  valid_598573 = validateParameter(valid_598573, JString, required = false,
                                 default = newJString("json"))
  if valid_598573 != nil:
    section.add "alt", valid_598573
  var valid_598574 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_598574 = validateParameter(valid_598574, JBool, required = false,
                                 default = newJBool(false))
  if valid_598574 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_598574
  var valid_598575 = query.getOrDefault("oauth_token")
  valid_598575 = validateParameter(valid_598575, JString, required = false,
                                 default = nil)
  if valid_598575 != nil:
    section.add "oauth_token", valid_598575
  var valid_598576 = query.getOrDefault("userIp")
  valid_598576 = validateParameter(valid_598576, JString, required = false,
                                 default = nil)
  if valid_598576 != nil:
    section.add "userIp", valid_598576
  var valid_598577 = query.getOrDefault("key")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "key", valid_598577
  var valid_598578 = query.getOrDefault("prettyPrint")
  valid_598578 = validateParameter(valid_598578, JBool, required = false,
                                 default = newJBool(false))
  if valid_598578 != nil:
    section.add "prettyPrint", valid_598578
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

proc call*(call_598580: Call_AnalyticsManagementCustomMetricsUpdate_598565;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric.
  ## 
  let valid = call_598580.validator(path, query, header, formData, body)
  let scheme = call_598580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598580.url(scheme.get, call_598580.host, call_598580.base,
                         call_598580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598580, url, valid)

proc call*(call_598581: Call_AnalyticsManagementCustomMetricsUpdate_598565;
          customMetricId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsUpdate
  ## Updates an existing custom metric.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   customMetricId: string (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598582 = newJObject()
  var query_598583 = newJObject()
  var body_598584 = newJObject()
  add(query_598583, "fields", newJString(fields))
  add(query_598583, "quotaUser", newJString(quotaUser))
  add(query_598583, "alt", newJString(alt))
  add(query_598583, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(path_598582, "customMetricId", newJString(customMetricId))
  add(query_598583, "oauth_token", newJString(oauthToken))
  add(path_598582, "accountId", newJString(accountId))
  add(query_598583, "userIp", newJString(userIp))
  add(path_598582, "webPropertyId", newJString(webPropertyId))
  add(query_598583, "key", newJString(key))
  if body != nil:
    body_598584 = body
  add(query_598583, "prettyPrint", newJBool(prettyPrint))
  result = call_598581.call(path_598582, query_598583, nil, nil, body_598584)

var analyticsManagementCustomMetricsUpdate* = Call_AnalyticsManagementCustomMetricsUpdate_598565(
    name: "analyticsManagementCustomMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsUpdate_598566,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsUpdate_598567,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsGet_598548 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomMetricsGet_598550(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customMetricId" in path, "`customMetricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics/"),
               (kind: VariableSegment, value: "customMetricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsGet_598549(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a custom metric to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customMetricId: JString (required)
  ##                 : The ID of the custom metric to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customMetricId` field"
  var valid_598551 = path.getOrDefault("customMetricId")
  valid_598551 = validateParameter(valid_598551, JString, required = true,
                                 default = nil)
  if valid_598551 != nil:
    section.add "customMetricId", valid_598551
  var valid_598552 = path.getOrDefault("accountId")
  valid_598552 = validateParameter(valid_598552, JString, required = true,
                                 default = nil)
  if valid_598552 != nil:
    section.add "accountId", valid_598552
  var valid_598553 = path.getOrDefault("webPropertyId")
  valid_598553 = validateParameter(valid_598553, JString, required = true,
                                 default = nil)
  if valid_598553 != nil:
    section.add "webPropertyId", valid_598553
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598554 = query.getOrDefault("fields")
  valid_598554 = validateParameter(valid_598554, JString, required = false,
                                 default = nil)
  if valid_598554 != nil:
    section.add "fields", valid_598554
  var valid_598555 = query.getOrDefault("quotaUser")
  valid_598555 = validateParameter(valid_598555, JString, required = false,
                                 default = nil)
  if valid_598555 != nil:
    section.add "quotaUser", valid_598555
  var valid_598556 = query.getOrDefault("alt")
  valid_598556 = validateParameter(valid_598556, JString, required = false,
                                 default = newJString("json"))
  if valid_598556 != nil:
    section.add "alt", valid_598556
  var valid_598557 = query.getOrDefault("oauth_token")
  valid_598557 = validateParameter(valid_598557, JString, required = false,
                                 default = nil)
  if valid_598557 != nil:
    section.add "oauth_token", valid_598557
  var valid_598558 = query.getOrDefault("userIp")
  valid_598558 = validateParameter(valid_598558, JString, required = false,
                                 default = nil)
  if valid_598558 != nil:
    section.add "userIp", valid_598558
  var valid_598559 = query.getOrDefault("key")
  valid_598559 = validateParameter(valid_598559, JString, required = false,
                                 default = nil)
  if valid_598559 != nil:
    section.add "key", valid_598559
  var valid_598560 = query.getOrDefault("prettyPrint")
  valid_598560 = validateParameter(valid_598560, JBool, required = false,
                                 default = newJBool(false))
  if valid_598560 != nil:
    section.add "prettyPrint", valid_598560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598561: Call_AnalyticsManagementCustomMetricsGet_598548;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom metric to which the user has access.
  ## 
  let valid = call_598561.validator(path, query, header, formData, body)
  let scheme = call_598561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598561.url(scheme.get, call_598561.host, call_598561.base,
                         call_598561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598561, url, valid)

proc call*(call_598562: Call_AnalyticsManagementCustomMetricsGet_598548;
          customMetricId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsGet
  ## Get a custom metric to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customMetricId: string (required)
  ##                 : The ID of the custom metric to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598563 = newJObject()
  var query_598564 = newJObject()
  add(query_598564, "fields", newJString(fields))
  add(query_598564, "quotaUser", newJString(quotaUser))
  add(query_598564, "alt", newJString(alt))
  add(path_598563, "customMetricId", newJString(customMetricId))
  add(query_598564, "oauth_token", newJString(oauthToken))
  add(path_598563, "accountId", newJString(accountId))
  add(query_598564, "userIp", newJString(userIp))
  add(path_598563, "webPropertyId", newJString(webPropertyId))
  add(query_598564, "key", newJString(key))
  add(query_598564, "prettyPrint", newJBool(prettyPrint))
  result = call_598562.call(path_598563, query_598564, nil, nil, nil)

var analyticsManagementCustomMetricsGet* = Call_AnalyticsManagementCustomMetricsGet_598548(
    name: "analyticsManagementCustomMetricsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsGet_598549,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsGet_598550,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsPatch_598585 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementCustomMetricsPatch_598587(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customMetricId" in path, "`customMetricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics/"),
               (kind: VariableSegment, value: "customMetricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsPatch_598586(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom metric. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customMetricId: JString (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customMetricId` field"
  var valid_598588 = path.getOrDefault("customMetricId")
  valid_598588 = validateParameter(valid_598588, JString, required = true,
                                 default = nil)
  if valid_598588 != nil:
    section.add "customMetricId", valid_598588
  var valid_598589 = path.getOrDefault("accountId")
  valid_598589 = validateParameter(valid_598589, JString, required = true,
                                 default = nil)
  if valid_598589 != nil:
    section.add "accountId", valid_598589
  var valid_598590 = path.getOrDefault("webPropertyId")
  valid_598590 = validateParameter(valid_598590, JString, required = true,
                                 default = nil)
  if valid_598590 != nil:
    section.add "webPropertyId", valid_598590
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598591 = query.getOrDefault("fields")
  valid_598591 = validateParameter(valid_598591, JString, required = false,
                                 default = nil)
  if valid_598591 != nil:
    section.add "fields", valid_598591
  var valid_598592 = query.getOrDefault("quotaUser")
  valid_598592 = validateParameter(valid_598592, JString, required = false,
                                 default = nil)
  if valid_598592 != nil:
    section.add "quotaUser", valid_598592
  var valid_598593 = query.getOrDefault("alt")
  valid_598593 = validateParameter(valid_598593, JString, required = false,
                                 default = newJString("json"))
  if valid_598593 != nil:
    section.add "alt", valid_598593
  var valid_598594 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_598594 = validateParameter(valid_598594, JBool, required = false,
                                 default = newJBool(false))
  if valid_598594 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_598594
  var valid_598595 = query.getOrDefault("oauth_token")
  valid_598595 = validateParameter(valid_598595, JString, required = false,
                                 default = nil)
  if valid_598595 != nil:
    section.add "oauth_token", valid_598595
  var valid_598596 = query.getOrDefault("userIp")
  valid_598596 = validateParameter(valid_598596, JString, required = false,
                                 default = nil)
  if valid_598596 != nil:
    section.add "userIp", valid_598596
  var valid_598597 = query.getOrDefault("key")
  valid_598597 = validateParameter(valid_598597, JString, required = false,
                                 default = nil)
  if valid_598597 != nil:
    section.add "key", valid_598597
  var valid_598598 = query.getOrDefault("prettyPrint")
  valid_598598 = validateParameter(valid_598598, JBool, required = false,
                                 default = newJBool(false))
  if valid_598598 != nil:
    section.add "prettyPrint", valid_598598
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

proc call*(call_598600: Call_AnalyticsManagementCustomMetricsPatch_598585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric. This method supports patch semantics.
  ## 
  let valid = call_598600.validator(path, query, header, formData, body)
  let scheme = call_598600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598600.url(scheme.get, call_598600.host, call_598600.base,
                         call_598600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598600, url, valid)

proc call*(call_598601: Call_AnalyticsManagementCustomMetricsPatch_598585;
          customMetricId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsPatch
  ## Updates an existing custom metric. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   customMetricId: string (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598602 = newJObject()
  var query_598603 = newJObject()
  var body_598604 = newJObject()
  add(query_598603, "fields", newJString(fields))
  add(query_598603, "quotaUser", newJString(quotaUser))
  add(query_598603, "alt", newJString(alt))
  add(query_598603, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(path_598602, "customMetricId", newJString(customMetricId))
  add(query_598603, "oauth_token", newJString(oauthToken))
  add(path_598602, "accountId", newJString(accountId))
  add(query_598603, "userIp", newJString(userIp))
  add(path_598602, "webPropertyId", newJString(webPropertyId))
  add(query_598603, "key", newJString(key))
  if body != nil:
    body_598604 = body
  add(query_598603, "prettyPrint", newJBool(prettyPrint))
  result = call_598601.call(path_598602, query_598603, nil, nil, body_598604)

var analyticsManagementCustomMetricsPatch* = Call_AnalyticsManagementCustomMetricsPatch_598585(
    name: "analyticsManagementCustomMetricsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsPatch_598586,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsPatch_598587,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_598623 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebPropertyAdWordsLinksInsert_598625(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_598624(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a webProperty-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : ID of the Google Analytics account to create the link for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598626 = path.getOrDefault("accountId")
  valid_598626 = validateParameter(valid_598626, JString, required = true,
                                 default = nil)
  if valid_598626 != nil:
    section.add "accountId", valid_598626
  var valid_598627 = path.getOrDefault("webPropertyId")
  valid_598627 = validateParameter(valid_598627, JString, required = true,
                                 default = nil)
  if valid_598627 != nil:
    section.add "webPropertyId", valid_598627
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598628 = query.getOrDefault("fields")
  valid_598628 = validateParameter(valid_598628, JString, required = false,
                                 default = nil)
  if valid_598628 != nil:
    section.add "fields", valid_598628
  var valid_598629 = query.getOrDefault("quotaUser")
  valid_598629 = validateParameter(valid_598629, JString, required = false,
                                 default = nil)
  if valid_598629 != nil:
    section.add "quotaUser", valid_598629
  var valid_598630 = query.getOrDefault("alt")
  valid_598630 = validateParameter(valid_598630, JString, required = false,
                                 default = newJString("json"))
  if valid_598630 != nil:
    section.add "alt", valid_598630
  var valid_598631 = query.getOrDefault("oauth_token")
  valid_598631 = validateParameter(valid_598631, JString, required = false,
                                 default = nil)
  if valid_598631 != nil:
    section.add "oauth_token", valid_598631
  var valid_598632 = query.getOrDefault("userIp")
  valid_598632 = validateParameter(valid_598632, JString, required = false,
                                 default = nil)
  if valid_598632 != nil:
    section.add "userIp", valid_598632
  var valid_598633 = query.getOrDefault("key")
  valid_598633 = validateParameter(valid_598633, JString, required = false,
                                 default = nil)
  if valid_598633 != nil:
    section.add "key", valid_598633
  var valid_598634 = query.getOrDefault("prettyPrint")
  valid_598634 = validateParameter(valid_598634, JBool, required = false,
                                 default = newJBool(false))
  if valid_598634 != nil:
    section.add "prettyPrint", valid_598634
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

proc call*(call_598636: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_598623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a webProperty-Google Ads link.
  ## 
  let valid = call_598636.validator(path, query, header, formData, body)
  let scheme = call_598636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598636.url(scheme.get, call_598636.host, call_598636.base,
                         call_598636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598636, url, valid)

proc call*(call_598637: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_598623;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksInsert
  ## Creates a webProperty-Google Ads link.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the Google Analytics account to create the link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598638 = newJObject()
  var query_598639 = newJObject()
  var body_598640 = newJObject()
  add(query_598639, "fields", newJString(fields))
  add(query_598639, "quotaUser", newJString(quotaUser))
  add(query_598639, "alt", newJString(alt))
  add(query_598639, "oauth_token", newJString(oauthToken))
  add(path_598638, "accountId", newJString(accountId))
  add(query_598639, "userIp", newJString(userIp))
  add(path_598638, "webPropertyId", newJString(webPropertyId))
  add(query_598639, "key", newJString(key))
  if body != nil:
    body_598640 = body
  add(query_598639, "prettyPrint", newJBool(prettyPrint))
  result = call_598637.call(path_598638, query_598639, nil, nil, body_598640)

var analyticsManagementWebPropertyAdWordsLinksInsert* = Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_598623(
    name: "analyticsManagementWebPropertyAdWordsLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_598624,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksInsert_598625,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksList_598605 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebPropertyAdWordsLinksList_598607(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksList_598606(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists webProperty-Google Ads links for a given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads links for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598608 = path.getOrDefault("accountId")
  valid_598608 = validateParameter(valid_598608, JString, required = true,
                                 default = nil)
  if valid_598608 != nil:
    section.add "accountId", valid_598608
  var valid_598609 = path.getOrDefault("webPropertyId")
  valid_598609 = validateParameter(valid_598609, JString, required = true,
                                 default = nil)
  if valid_598609 != nil:
    section.add "webPropertyId", valid_598609
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of webProperty-Google Ads links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first webProperty-Google Ads link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598610 = query.getOrDefault("fields")
  valid_598610 = validateParameter(valid_598610, JString, required = false,
                                 default = nil)
  if valid_598610 != nil:
    section.add "fields", valid_598610
  var valid_598611 = query.getOrDefault("quotaUser")
  valid_598611 = validateParameter(valid_598611, JString, required = false,
                                 default = nil)
  if valid_598611 != nil:
    section.add "quotaUser", valid_598611
  var valid_598612 = query.getOrDefault("alt")
  valid_598612 = validateParameter(valid_598612, JString, required = false,
                                 default = newJString("json"))
  if valid_598612 != nil:
    section.add "alt", valid_598612
  var valid_598613 = query.getOrDefault("oauth_token")
  valid_598613 = validateParameter(valid_598613, JString, required = false,
                                 default = nil)
  if valid_598613 != nil:
    section.add "oauth_token", valid_598613
  var valid_598614 = query.getOrDefault("userIp")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "userIp", valid_598614
  var valid_598615 = query.getOrDefault("key")
  valid_598615 = validateParameter(valid_598615, JString, required = false,
                                 default = nil)
  if valid_598615 != nil:
    section.add "key", valid_598615
  var valid_598616 = query.getOrDefault("max-results")
  valid_598616 = validateParameter(valid_598616, JInt, required = false, default = nil)
  if valid_598616 != nil:
    section.add "max-results", valid_598616
  var valid_598617 = query.getOrDefault("start-index")
  valid_598617 = validateParameter(valid_598617, JInt, required = false, default = nil)
  if valid_598617 != nil:
    section.add "start-index", valid_598617
  var valid_598618 = query.getOrDefault("prettyPrint")
  valid_598618 = validateParameter(valid_598618, JBool, required = false,
                                 default = newJBool(false))
  if valid_598618 != nil:
    section.add "prettyPrint", valid_598618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598619: Call_AnalyticsManagementWebPropertyAdWordsLinksList_598605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-Google Ads links for a given web property.
  ## 
  let valid = call_598619.validator(path, query, header, formData, body)
  let scheme = call_598619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598619.url(scheme.get, call_598619.host, call_598619.base,
                         call_598619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598619, url, valid)

proc call*(call_598620: Call_AnalyticsManagementWebPropertyAdWordsLinksList_598605;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksList
  ## Lists webProperty-Google Ads links for a given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads links for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of webProperty-Google Ads links to include in this response.
  ##   startIndex: int
  ##             : An index of the first webProperty-Google Ads link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598621 = newJObject()
  var query_598622 = newJObject()
  add(query_598622, "fields", newJString(fields))
  add(query_598622, "quotaUser", newJString(quotaUser))
  add(query_598622, "alt", newJString(alt))
  add(query_598622, "oauth_token", newJString(oauthToken))
  add(path_598621, "accountId", newJString(accountId))
  add(query_598622, "userIp", newJString(userIp))
  add(path_598621, "webPropertyId", newJString(webPropertyId))
  add(query_598622, "key", newJString(key))
  add(query_598622, "max-results", newJInt(maxResults))
  add(query_598622, "start-index", newJInt(startIndex))
  add(query_598622, "prettyPrint", newJBool(prettyPrint))
  result = call_598620.call(path_598621, query_598622, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksList* = Call_AnalyticsManagementWebPropertyAdWordsLinksList_598605(
    name: "analyticsManagementWebPropertyAdWordsLinksList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksList_598606,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksList_598607,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598658 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598660(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598659(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing webProperty-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_598661 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_598661 = validateParameter(valid_598661, JString, required = true,
                                 default = nil)
  if valid_598661 != nil:
    section.add "webPropertyAdWordsLinkId", valid_598661
  var valid_598662 = path.getOrDefault("accountId")
  valid_598662 = validateParameter(valid_598662, JString, required = true,
                                 default = nil)
  if valid_598662 != nil:
    section.add "accountId", valid_598662
  var valid_598663 = path.getOrDefault("webPropertyId")
  valid_598663 = validateParameter(valid_598663, JString, required = true,
                                 default = nil)
  if valid_598663 != nil:
    section.add "webPropertyId", valid_598663
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598664 = query.getOrDefault("fields")
  valid_598664 = validateParameter(valid_598664, JString, required = false,
                                 default = nil)
  if valid_598664 != nil:
    section.add "fields", valid_598664
  var valid_598665 = query.getOrDefault("quotaUser")
  valid_598665 = validateParameter(valid_598665, JString, required = false,
                                 default = nil)
  if valid_598665 != nil:
    section.add "quotaUser", valid_598665
  var valid_598666 = query.getOrDefault("alt")
  valid_598666 = validateParameter(valid_598666, JString, required = false,
                                 default = newJString("json"))
  if valid_598666 != nil:
    section.add "alt", valid_598666
  var valid_598667 = query.getOrDefault("oauth_token")
  valid_598667 = validateParameter(valid_598667, JString, required = false,
                                 default = nil)
  if valid_598667 != nil:
    section.add "oauth_token", valid_598667
  var valid_598668 = query.getOrDefault("userIp")
  valid_598668 = validateParameter(valid_598668, JString, required = false,
                                 default = nil)
  if valid_598668 != nil:
    section.add "userIp", valid_598668
  var valid_598669 = query.getOrDefault("key")
  valid_598669 = validateParameter(valid_598669, JString, required = false,
                                 default = nil)
  if valid_598669 != nil:
    section.add "key", valid_598669
  var valid_598670 = query.getOrDefault("prettyPrint")
  valid_598670 = validateParameter(valid_598670, JBool, required = false,
                                 default = newJBool(false))
  if valid_598670 != nil:
    section.add "prettyPrint", valid_598670
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

proc call*(call_598672: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link.
  ## 
  let valid = call_598672.validator(path, query, header, formData, body)
  let scheme = call_598672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598672.url(scheme.get, call_598672.host, call_598672.base,
                         call_598672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598672, url, valid)

proc call*(call_598673: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598658;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksUpdate
  ## Updates an existing webProperty-Google Ads link.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598674 = newJObject()
  var query_598675 = newJObject()
  var body_598676 = newJObject()
  add(query_598675, "fields", newJString(fields))
  add(query_598675, "quotaUser", newJString(quotaUser))
  add(query_598675, "alt", newJString(alt))
  add(path_598674, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_598675, "oauth_token", newJString(oauthToken))
  add(path_598674, "accountId", newJString(accountId))
  add(query_598675, "userIp", newJString(userIp))
  add(path_598674, "webPropertyId", newJString(webPropertyId))
  add(query_598675, "key", newJString(key))
  if body != nil:
    body_598676 = body
  add(query_598675, "prettyPrint", newJBool(prettyPrint))
  result = call_598673.call(path_598674, query_598675, nil, nil, body_598676)

var analyticsManagementWebPropertyAdWordsLinksUpdate* = Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598658(
    name: "analyticsManagementWebPropertyAdWordsLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598659,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_598660,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksGet_598641 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebPropertyAdWordsLinksGet_598643(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksGet_598642(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a web property-Google Ads link to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_598644 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_598644 = validateParameter(valid_598644, JString, required = true,
                                 default = nil)
  if valid_598644 != nil:
    section.add "webPropertyAdWordsLinkId", valid_598644
  var valid_598645 = path.getOrDefault("accountId")
  valid_598645 = validateParameter(valid_598645, JString, required = true,
                                 default = nil)
  if valid_598645 != nil:
    section.add "accountId", valid_598645
  var valid_598646 = path.getOrDefault("webPropertyId")
  valid_598646 = validateParameter(valid_598646, JString, required = true,
                                 default = nil)
  if valid_598646 != nil:
    section.add "webPropertyId", valid_598646
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598647 = query.getOrDefault("fields")
  valid_598647 = validateParameter(valid_598647, JString, required = false,
                                 default = nil)
  if valid_598647 != nil:
    section.add "fields", valid_598647
  var valid_598648 = query.getOrDefault("quotaUser")
  valid_598648 = validateParameter(valid_598648, JString, required = false,
                                 default = nil)
  if valid_598648 != nil:
    section.add "quotaUser", valid_598648
  var valid_598649 = query.getOrDefault("alt")
  valid_598649 = validateParameter(valid_598649, JString, required = false,
                                 default = newJString("json"))
  if valid_598649 != nil:
    section.add "alt", valid_598649
  var valid_598650 = query.getOrDefault("oauth_token")
  valid_598650 = validateParameter(valid_598650, JString, required = false,
                                 default = nil)
  if valid_598650 != nil:
    section.add "oauth_token", valid_598650
  var valid_598651 = query.getOrDefault("userIp")
  valid_598651 = validateParameter(valid_598651, JString, required = false,
                                 default = nil)
  if valid_598651 != nil:
    section.add "userIp", valid_598651
  var valid_598652 = query.getOrDefault("key")
  valid_598652 = validateParameter(valid_598652, JString, required = false,
                                 default = nil)
  if valid_598652 != nil:
    section.add "key", valid_598652
  var valid_598653 = query.getOrDefault("prettyPrint")
  valid_598653 = validateParameter(valid_598653, JBool, required = false,
                                 default = newJBool(false))
  if valid_598653 != nil:
    section.add "prettyPrint", valid_598653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598654: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_598641;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a web property-Google Ads link to which the user has access.
  ## 
  let valid = call_598654.validator(path, query, header, formData, body)
  let scheme = call_598654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598654.url(scheme.get, call_598654.host, call_598654.base,
                         call_598654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598654, url, valid)

proc call*(call_598655: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_598641;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksGet
  ## Returns a web property-Google Ads link to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598656 = newJObject()
  var query_598657 = newJObject()
  add(query_598657, "fields", newJString(fields))
  add(query_598657, "quotaUser", newJString(quotaUser))
  add(query_598657, "alt", newJString(alt))
  add(path_598656, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_598657, "oauth_token", newJString(oauthToken))
  add(path_598656, "accountId", newJString(accountId))
  add(query_598657, "userIp", newJString(userIp))
  add(path_598656, "webPropertyId", newJString(webPropertyId))
  add(query_598657, "key", newJString(key))
  add(query_598657, "prettyPrint", newJBool(prettyPrint))
  result = call_598655.call(path_598656, query_598657, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksGet* = Call_AnalyticsManagementWebPropertyAdWordsLinksGet_598641(
    name: "analyticsManagementWebPropertyAdWordsLinksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksGet_598642,
    base: "/analytics/v3", url: url_AnalyticsManagementWebPropertyAdWordsLinksGet_598643,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_598694 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebPropertyAdWordsLinksPatch_598696(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_598695(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_598697 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_598697 = validateParameter(valid_598697, JString, required = true,
                                 default = nil)
  if valid_598697 != nil:
    section.add "webPropertyAdWordsLinkId", valid_598697
  var valid_598698 = path.getOrDefault("accountId")
  valid_598698 = validateParameter(valid_598698, JString, required = true,
                                 default = nil)
  if valid_598698 != nil:
    section.add "accountId", valid_598698
  var valid_598699 = path.getOrDefault("webPropertyId")
  valid_598699 = validateParameter(valid_598699, JString, required = true,
                                 default = nil)
  if valid_598699 != nil:
    section.add "webPropertyId", valid_598699
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598700 = query.getOrDefault("fields")
  valid_598700 = validateParameter(valid_598700, JString, required = false,
                                 default = nil)
  if valid_598700 != nil:
    section.add "fields", valid_598700
  var valid_598701 = query.getOrDefault("quotaUser")
  valid_598701 = validateParameter(valid_598701, JString, required = false,
                                 default = nil)
  if valid_598701 != nil:
    section.add "quotaUser", valid_598701
  var valid_598702 = query.getOrDefault("alt")
  valid_598702 = validateParameter(valid_598702, JString, required = false,
                                 default = newJString("json"))
  if valid_598702 != nil:
    section.add "alt", valid_598702
  var valid_598703 = query.getOrDefault("oauth_token")
  valid_598703 = validateParameter(valid_598703, JString, required = false,
                                 default = nil)
  if valid_598703 != nil:
    section.add "oauth_token", valid_598703
  var valid_598704 = query.getOrDefault("userIp")
  valid_598704 = validateParameter(valid_598704, JString, required = false,
                                 default = nil)
  if valid_598704 != nil:
    section.add "userIp", valid_598704
  var valid_598705 = query.getOrDefault("key")
  valid_598705 = validateParameter(valid_598705, JString, required = false,
                                 default = nil)
  if valid_598705 != nil:
    section.add "key", valid_598705
  var valid_598706 = query.getOrDefault("prettyPrint")
  valid_598706 = validateParameter(valid_598706, JBool, required = false,
                                 default = newJBool(false))
  if valid_598706 != nil:
    section.add "prettyPrint", valid_598706
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

proc call*(call_598708: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_598694;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ## 
  let valid = call_598708.validator(path, query, header, formData, body)
  let scheme = call_598708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598708.url(scheme.get, call_598708.host, call_598708.base,
                         call_598708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598708, url, valid)

proc call*(call_598709: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_598694;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksPatch
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598710 = newJObject()
  var query_598711 = newJObject()
  var body_598712 = newJObject()
  add(query_598711, "fields", newJString(fields))
  add(query_598711, "quotaUser", newJString(quotaUser))
  add(query_598711, "alt", newJString(alt))
  add(path_598710, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_598711, "oauth_token", newJString(oauthToken))
  add(path_598710, "accountId", newJString(accountId))
  add(query_598711, "userIp", newJString(userIp))
  add(path_598710, "webPropertyId", newJString(webPropertyId))
  add(query_598711, "key", newJString(key))
  if body != nil:
    body_598712 = body
  add(query_598711, "prettyPrint", newJBool(prettyPrint))
  result = call_598709.call(path_598710, query_598711, nil, nil, body_598712)

var analyticsManagementWebPropertyAdWordsLinksPatch* = Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_598694(
    name: "analyticsManagementWebPropertyAdWordsLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_598695,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksPatch_598696,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_598677 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebPropertyAdWordsLinksDelete_598679(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_598678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a web property-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_598680 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_598680 = validateParameter(valid_598680, JString, required = true,
                                 default = nil)
  if valid_598680 != nil:
    section.add "webPropertyAdWordsLinkId", valid_598680
  var valid_598681 = path.getOrDefault("accountId")
  valid_598681 = validateParameter(valid_598681, JString, required = true,
                                 default = nil)
  if valid_598681 != nil:
    section.add "accountId", valid_598681
  var valid_598682 = path.getOrDefault("webPropertyId")
  valid_598682 = validateParameter(valid_598682, JString, required = true,
                                 default = nil)
  if valid_598682 != nil:
    section.add "webPropertyId", valid_598682
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598683 = query.getOrDefault("fields")
  valid_598683 = validateParameter(valid_598683, JString, required = false,
                                 default = nil)
  if valid_598683 != nil:
    section.add "fields", valid_598683
  var valid_598684 = query.getOrDefault("quotaUser")
  valid_598684 = validateParameter(valid_598684, JString, required = false,
                                 default = nil)
  if valid_598684 != nil:
    section.add "quotaUser", valid_598684
  var valid_598685 = query.getOrDefault("alt")
  valid_598685 = validateParameter(valid_598685, JString, required = false,
                                 default = newJString("json"))
  if valid_598685 != nil:
    section.add "alt", valid_598685
  var valid_598686 = query.getOrDefault("oauth_token")
  valid_598686 = validateParameter(valid_598686, JString, required = false,
                                 default = nil)
  if valid_598686 != nil:
    section.add "oauth_token", valid_598686
  var valid_598687 = query.getOrDefault("userIp")
  valid_598687 = validateParameter(valid_598687, JString, required = false,
                                 default = nil)
  if valid_598687 != nil:
    section.add "userIp", valid_598687
  var valid_598688 = query.getOrDefault("key")
  valid_598688 = validateParameter(valid_598688, JString, required = false,
                                 default = nil)
  if valid_598688 != nil:
    section.add "key", valid_598688
  var valid_598689 = query.getOrDefault("prettyPrint")
  valid_598689 = validateParameter(valid_598689, JBool, required = false,
                                 default = newJBool(false))
  if valid_598689 != nil:
    section.add "prettyPrint", valid_598689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598690: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_598677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a web property-Google Ads link.
  ## 
  let valid = call_598690.validator(path, query, header, formData, body)
  let scheme = call_598690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598690.url(scheme.get, call_598690.host, call_598690.base,
                         call_598690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598690, url, valid)

proc call*(call_598691: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_598677;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksDelete
  ## Deletes a web property-Google Ads link.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598692 = newJObject()
  var query_598693 = newJObject()
  add(query_598693, "fields", newJString(fields))
  add(query_598693, "quotaUser", newJString(quotaUser))
  add(query_598693, "alt", newJString(alt))
  add(path_598692, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_598693, "oauth_token", newJString(oauthToken))
  add(path_598692, "accountId", newJString(accountId))
  add(query_598693, "userIp", newJString(userIp))
  add(path_598692, "webPropertyId", newJString(webPropertyId))
  add(query_598693, "key", newJString(key))
  add(query_598693, "prettyPrint", newJBool(prettyPrint))
  result = call_598691.call(path_598692, query_598693, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksDelete* = Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_598677(
    name: "analyticsManagementWebPropertyAdWordsLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_598678,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksDelete_598679,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksInsert_598731 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertyUserLinksInsert_598733(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksInsert_598732(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds a new user to the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to create the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598734 = path.getOrDefault("accountId")
  valid_598734 = validateParameter(valid_598734, JString, required = true,
                                 default = nil)
  if valid_598734 != nil:
    section.add "accountId", valid_598734
  var valid_598735 = path.getOrDefault("webPropertyId")
  valid_598735 = validateParameter(valid_598735, JString, required = true,
                                 default = nil)
  if valid_598735 != nil:
    section.add "webPropertyId", valid_598735
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598736 = query.getOrDefault("fields")
  valid_598736 = validateParameter(valid_598736, JString, required = false,
                                 default = nil)
  if valid_598736 != nil:
    section.add "fields", valid_598736
  var valid_598737 = query.getOrDefault("quotaUser")
  valid_598737 = validateParameter(valid_598737, JString, required = false,
                                 default = nil)
  if valid_598737 != nil:
    section.add "quotaUser", valid_598737
  var valid_598738 = query.getOrDefault("alt")
  valid_598738 = validateParameter(valid_598738, JString, required = false,
                                 default = newJString("json"))
  if valid_598738 != nil:
    section.add "alt", valid_598738
  var valid_598739 = query.getOrDefault("oauth_token")
  valid_598739 = validateParameter(valid_598739, JString, required = false,
                                 default = nil)
  if valid_598739 != nil:
    section.add "oauth_token", valid_598739
  var valid_598740 = query.getOrDefault("userIp")
  valid_598740 = validateParameter(valid_598740, JString, required = false,
                                 default = nil)
  if valid_598740 != nil:
    section.add "userIp", valid_598740
  var valid_598741 = query.getOrDefault("key")
  valid_598741 = validateParameter(valid_598741, JString, required = false,
                                 default = nil)
  if valid_598741 != nil:
    section.add "key", valid_598741
  var valid_598742 = query.getOrDefault("prettyPrint")
  valid_598742 = validateParameter(valid_598742, JBool, required = false,
                                 default = newJBool(false))
  if valid_598742 != nil:
    section.add "prettyPrint", valid_598742
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

proc call*(call_598744: Call_AnalyticsManagementWebpropertyUserLinksInsert_598731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given web property.
  ## 
  let valid = call_598744.validator(path, query, header, formData, body)
  let scheme = call_598744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598744.url(scheme.get, call_598744.host, call_598744.base,
                         call_598744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598744, url, valid)

proc call*(call_598745: Call_AnalyticsManagementWebpropertyUserLinksInsert_598731;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksInsert
  ## Adds a new user to the given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to create the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598746 = newJObject()
  var query_598747 = newJObject()
  var body_598748 = newJObject()
  add(query_598747, "fields", newJString(fields))
  add(query_598747, "quotaUser", newJString(quotaUser))
  add(query_598747, "alt", newJString(alt))
  add(query_598747, "oauth_token", newJString(oauthToken))
  add(path_598746, "accountId", newJString(accountId))
  add(query_598747, "userIp", newJString(userIp))
  add(path_598746, "webPropertyId", newJString(webPropertyId))
  add(query_598747, "key", newJString(key))
  if body != nil:
    body_598748 = body
  add(query_598747, "prettyPrint", newJBool(prettyPrint))
  result = call_598745.call(path_598746, query_598747, nil, nil, body_598748)

var analyticsManagementWebpropertyUserLinksInsert* = Call_AnalyticsManagementWebpropertyUserLinksInsert_598731(
    name: "analyticsManagementWebpropertyUserLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksInsert_598732,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksInsert_598733,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksList_598713 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertyUserLinksList_598715(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksList_598714(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists webProperty-user links for a given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID for the webProperty-user links to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598716 = path.getOrDefault("accountId")
  valid_598716 = validateParameter(valid_598716, JString, required = true,
                                 default = nil)
  if valid_598716 != nil:
    section.add "accountId", valid_598716
  var valid_598717 = path.getOrDefault("webPropertyId")
  valid_598717 = validateParameter(valid_598717, JString, required = true,
                                 default = nil)
  if valid_598717 != nil:
    section.add "webPropertyId", valid_598717
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of webProperty-user Links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first webProperty-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598718 = query.getOrDefault("fields")
  valid_598718 = validateParameter(valid_598718, JString, required = false,
                                 default = nil)
  if valid_598718 != nil:
    section.add "fields", valid_598718
  var valid_598719 = query.getOrDefault("quotaUser")
  valid_598719 = validateParameter(valid_598719, JString, required = false,
                                 default = nil)
  if valid_598719 != nil:
    section.add "quotaUser", valid_598719
  var valid_598720 = query.getOrDefault("alt")
  valid_598720 = validateParameter(valid_598720, JString, required = false,
                                 default = newJString("json"))
  if valid_598720 != nil:
    section.add "alt", valid_598720
  var valid_598721 = query.getOrDefault("oauth_token")
  valid_598721 = validateParameter(valid_598721, JString, required = false,
                                 default = nil)
  if valid_598721 != nil:
    section.add "oauth_token", valid_598721
  var valid_598722 = query.getOrDefault("userIp")
  valid_598722 = validateParameter(valid_598722, JString, required = false,
                                 default = nil)
  if valid_598722 != nil:
    section.add "userIp", valid_598722
  var valid_598723 = query.getOrDefault("key")
  valid_598723 = validateParameter(valid_598723, JString, required = false,
                                 default = nil)
  if valid_598723 != nil:
    section.add "key", valid_598723
  var valid_598724 = query.getOrDefault("max-results")
  valid_598724 = validateParameter(valid_598724, JInt, required = false, default = nil)
  if valid_598724 != nil:
    section.add "max-results", valid_598724
  var valid_598725 = query.getOrDefault("start-index")
  valid_598725 = validateParameter(valid_598725, JInt, required = false, default = nil)
  if valid_598725 != nil:
    section.add "start-index", valid_598725
  var valid_598726 = query.getOrDefault("prettyPrint")
  valid_598726 = validateParameter(valid_598726, JBool, required = false,
                                 default = newJBool(false))
  if valid_598726 != nil:
    section.add "prettyPrint", valid_598726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598727: Call_AnalyticsManagementWebpropertyUserLinksList_598713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-user links for a given web property.
  ## 
  let valid = call_598727.validator(path, query, header, formData, body)
  let scheme = call_598727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598727.url(scheme.get, call_598727.host, call_598727.base,
                         call_598727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598727, url, valid)

proc call*(call_598728: Call_AnalyticsManagementWebpropertyUserLinksList_598713;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksList
  ## Lists webProperty-user links for a given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID for the webProperty-user links to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of webProperty-user Links to include in this response.
  ##   startIndex: int
  ##             : An index of the first webProperty-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598729 = newJObject()
  var query_598730 = newJObject()
  add(query_598730, "fields", newJString(fields))
  add(query_598730, "quotaUser", newJString(quotaUser))
  add(query_598730, "alt", newJString(alt))
  add(query_598730, "oauth_token", newJString(oauthToken))
  add(path_598729, "accountId", newJString(accountId))
  add(query_598730, "userIp", newJString(userIp))
  add(path_598729, "webPropertyId", newJString(webPropertyId))
  add(query_598730, "key", newJString(key))
  add(query_598730, "max-results", newJInt(maxResults))
  add(query_598730, "start-index", newJInt(startIndex))
  add(query_598730, "prettyPrint", newJBool(prettyPrint))
  result = call_598728.call(path_598729, query_598730, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksList* = Call_AnalyticsManagementWebpropertyUserLinksList_598713(
    name: "analyticsManagementWebpropertyUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksList_598714,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksList_598715,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksUpdate_598749 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertyUserLinksUpdate_598751(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksUpdate_598750(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to update the account-user link for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the account-user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the account-user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598752 = path.getOrDefault("accountId")
  valid_598752 = validateParameter(valid_598752, JString, required = true,
                                 default = nil)
  if valid_598752 != nil:
    section.add "accountId", valid_598752
  var valid_598753 = path.getOrDefault("webPropertyId")
  valid_598753 = validateParameter(valid_598753, JString, required = true,
                                 default = nil)
  if valid_598753 != nil:
    section.add "webPropertyId", valid_598753
  var valid_598754 = path.getOrDefault("linkId")
  valid_598754 = validateParameter(valid_598754, JString, required = true,
                                 default = nil)
  if valid_598754 != nil:
    section.add "linkId", valid_598754
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598755 = query.getOrDefault("fields")
  valid_598755 = validateParameter(valid_598755, JString, required = false,
                                 default = nil)
  if valid_598755 != nil:
    section.add "fields", valid_598755
  var valid_598756 = query.getOrDefault("quotaUser")
  valid_598756 = validateParameter(valid_598756, JString, required = false,
                                 default = nil)
  if valid_598756 != nil:
    section.add "quotaUser", valid_598756
  var valid_598757 = query.getOrDefault("alt")
  valid_598757 = validateParameter(valid_598757, JString, required = false,
                                 default = newJString("json"))
  if valid_598757 != nil:
    section.add "alt", valid_598757
  var valid_598758 = query.getOrDefault("oauth_token")
  valid_598758 = validateParameter(valid_598758, JString, required = false,
                                 default = nil)
  if valid_598758 != nil:
    section.add "oauth_token", valid_598758
  var valid_598759 = query.getOrDefault("userIp")
  valid_598759 = validateParameter(valid_598759, JString, required = false,
                                 default = nil)
  if valid_598759 != nil:
    section.add "userIp", valid_598759
  var valid_598760 = query.getOrDefault("key")
  valid_598760 = validateParameter(valid_598760, JString, required = false,
                                 default = nil)
  if valid_598760 != nil:
    section.add "key", valid_598760
  var valid_598761 = query.getOrDefault("prettyPrint")
  valid_598761 = validateParameter(valid_598761, JBool, required = false,
                                 default = newJBool(false))
  if valid_598761 != nil:
    section.add "prettyPrint", valid_598761
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

proc call*(call_598763: Call_AnalyticsManagementWebpropertyUserLinksUpdate_598749;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given web property.
  ## 
  let valid = call_598763.validator(path, query, header, formData, body)
  let scheme = call_598763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598763.url(scheme.get, call_598763.host, call_598763.base,
                         call_598763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598763, url, valid)

proc call*(call_598764: Call_AnalyticsManagementWebpropertyUserLinksUpdate_598749;
          accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksUpdate
  ## Updates permissions for an existing user on the given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the account-user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the account-user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to update the account-user link for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598765 = newJObject()
  var query_598766 = newJObject()
  var body_598767 = newJObject()
  add(query_598766, "fields", newJString(fields))
  add(query_598766, "quotaUser", newJString(quotaUser))
  add(query_598766, "alt", newJString(alt))
  add(query_598766, "oauth_token", newJString(oauthToken))
  add(path_598765, "accountId", newJString(accountId))
  add(query_598766, "userIp", newJString(userIp))
  add(path_598765, "webPropertyId", newJString(webPropertyId))
  add(query_598766, "key", newJString(key))
  add(path_598765, "linkId", newJString(linkId))
  if body != nil:
    body_598767 = body
  add(query_598766, "prettyPrint", newJBool(prettyPrint))
  result = call_598764.call(path_598765, query_598766, nil, nil, body_598767)

var analyticsManagementWebpropertyUserLinksUpdate* = Call_AnalyticsManagementWebpropertyUserLinksUpdate_598749(
    name: "analyticsManagementWebpropertyUserLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksUpdate_598750,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksUpdate_598751,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksDelete_598768 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementWebpropertyUserLinksDelete_598770(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksDelete_598769(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a user from the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598771 = path.getOrDefault("accountId")
  valid_598771 = validateParameter(valid_598771, JString, required = true,
                                 default = nil)
  if valid_598771 != nil:
    section.add "accountId", valid_598771
  var valid_598772 = path.getOrDefault("webPropertyId")
  valid_598772 = validateParameter(valid_598772, JString, required = true,
                                 default = nil)
  if valid_598772 != nil:
    section.add "webPropertyId", valid_598772
  var valid_598773 = path.getOrDefault("linkId")
  valid_598773 = validateParameter(valid_598773, JString, required = true,
                                 default = nil)
  if valid_598773 != nil:
    section.add "linkId", valid_598773
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598774 = query.getOrDefault("fields")
  valid_598774 = validateParameter(valid_598774, JString, required = false,
                                 default = nil)
  if valid_598774 != nil:
    section.add "fields", valid_598774
  var valid_598775 = query.getOrDefault("quotaUser")
  valid_598775 = validateParameter(valid_598775, JString, required = false,
                                 default = nil)
  if valid_598775 != nil:
    section.add "quotaUser", valid_598775
  var valid_598776 = query.getOrDefault("alt")
  valid_598776 = validateParameter(valid_598776, JString, required = false,
                                 default = newJString("json"))
  if valid_598776 != nil:
    section.add "alt", valid_598776
  var valid_598777 = query.getOrDefault("oauth_token")
  valid_598777 = validateParameter(valid_598777, JString, required = false,
                                 default = nil)
  if valid_598777 != nil:
    section.add "oauth_token", valid_598777
  var valid_598778 = query.getOrDefault("userIp")
  valid_598778 = validateParameter(valid_598778, JString, required = false,
                                 default = nil)
  if valid_598778 != nil:
    section.add "userIp", valid_598778
  var valid_598779 = query.getOrDefault("key")
  valid_598779 = validateParameter(valid_598779, JString, required = false,
                                 default = nil)
  if valid_598779 != nil:
    section.add "key", valid_598779
  var valid_598780 = query.getOrDefault("prettyPrint")
  valid_598780 = validateParameter(valid_598780, JBool, required = false,
                                 default = newJBool(false))
  if valid_598780 != nil:
    section.add "prettyPrint", valid_598780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598781: Call_AnalyticsManagementWebpropertyUserLinksDelete_598768;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given web property.
  ## 
  let valid = call_598781.validator(path, query, header, formData, body)
  let scheme = call_598781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598781.url(scheme.get, call_598781.host, call_598781.base,
                         call_598781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598781, url, valid)

proc call*(call_598782: Call_AnalyticsManagementWebpropertyUserLinksDelete_598768;
          accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksDelete
  ## Removes a user from the given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to delete the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598783 = newJObject()
  var query_598784 = newJObject()
  add(query_598784, "fields", newJString(fields))
  add(query_598784, "quotaUser", newJString(quotaUser))
  add(query_598784, "alt", newJString(alt))
  add(query_598784, "oauth_token", newJString(oauthToken))
  add(path_598783, "accountId", newJString(accountId))
  add(query_598784, "userIp", newJString(userIp))
  add(path_598783, "webPropertyId", newJString(webPropertyId))
  add(query_598784, "key", newJString(key))
  add(path_598783, "linkId", newJString(linkId))
  add(query_598784, "prettyPrint", newJBool(prettyPrint))
  result = call_598782.call(path_598783, query_598784, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksDelete* = Call_AnalyticsManagementWebpropertyUserLinksDelete_598768(
    name: "analyticsManagementWebpropertyUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksDelete_598769,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksDelete_598770,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesInsert_598803 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfilesInsert_598805(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementProfilesInsert_598804(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the view (profile) for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the view (profile) for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598806 = path.getOrDefault("accountId")
  valid_598806 = validateParameter(valid_598806, JString, required = true,
                                 default = nil)
  if valid_598806 != nil:
    section.add "accountId", valid_598806
  var valid_598807 = path.getOrDefault("webPropertyId")
  valid_598807 = validateParameter(valid_598807, JString, required = true,
                                 default = nil)
  if valid_598807 != nil:
    section.add "webPropertyId", valid_598807
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598808 = query.getOrDefault("fields")
  valid_598808 = validateParameter(valid_598808, JString, required = false,
                                 default = nil)
  if valid_598808 != nil:
    section.add "fields", valid_598808
  var valid_598809 = query.getOrDefault("quotaUser")
  valid_598809 = validateParameter(valid_598809, JString, required = false,
                                 default = nil)
  if valid_598809 != nil:
    section.add "quotaUser", valid_598809
  var valid_598810 = query.getOrDefault("alt")
  valid_598810 = validateParameter(valid_598810, JString, required = false,
                                 default = newJString("json"))
  if valid_598810 != nil:
    section.add "alt", valid_598810
  var valid_598811 = query.getOrDefault("oauth_token")
  valid_598811 = validateParameter(valid_598811, JString, required = false,
                                 default = nil)
  if valid_598811 != nil:
    section.add "oauth_token", valid_598811
  var valid_598812 = query.getOrDefault("userIp")
  valid_598812 = validateParameter(valid_598812, JString, required = false,
                                 default = nil)
  if valid_598812 != nil:
    section.add "userIp", valid_598812
  var valid_598813 = query.getOrDefault("key")
  valid_598813 = validateParameter(valid_598813, JString, required = false,
                                 default = nil)
  if valid_598813 != nil:
    section.add "key", valid_598813
  var valid_598814 = query.getOrDefault("prettyPrint")
  valid_598814 = validateParameter(valid_598814, JBool, required = false,
                                 default = newJBool(false))
  if valid_598814 != nil:
    section.add "prettyPrint", valid_598814
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

proc call*(call_598816: Call_AnalyticsManagementProfilesInsert_598803;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new view (profile).
  ## 
  let valid = call_598816.validator(path, query, header, formData, body)
  let scheme = call_598816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598816.url(scheme.get, call_598816.host, call_598816.base,
                         call_598816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598816, url, valid)

proc call*(call_598817: Call_AnalyticsManagementProfilesInsert_598803;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesInsert
  ## Create a new view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the view (profile) for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the view (profile) for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598818 = newJObject()
  var query_598819 = newJObject()
  var body_598820 = newJObject()
  add(query_598819, "fields", newJString(fields))
  add(query_598819, "quotaUser", newJString(quotaUser))
  add(query_598819, "alt", newJString(alt))
  add(query_598819, "oauth_token", newJString(oauthToken))
  add(path_598818, "accountId", newJString(accountId))
  add(query_598819, "userIp", newJString(userIp))
  add(path_598818, "webPropertyId", newJString(webPropertyId))
  add(query_598819, "key", newJString(key))
  if body != nil:
    body_598820 = body
  add(query_598819, "prettyPrint", newJBool(prettyPrint))
  result = call_598817.call(path_598818, query_598819, nil, nil, body_598820)

var analyticsManagementProfilesInsert* = Call_AnalyticsManagementProfilesInsert_598803(
    name: "analyticsManagementProfilesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesInsert_598804,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesInsert_598805,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesList_598785 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfilesList_598787(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementProfilesList_598786(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists views (profiles) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598788 = path.getOrDefault("accountId")
  valid_598788 = validateParameter(valid_598788, JString, required = true,
                                 default = nil)
  if valid_598788 != nil:
    section.add "accountId", valid_598788
  var valid_598789 = path.getOrDefault("webPropertyId")
  valid_598789 = validateParameter(valid_598789, JString, required = true,
                                 default = nil)
  if valid_598789 != nil:
    section.add "webPropertyId", valid_598789
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of views (profiles) to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598790 = query.getOrDefault("fields")
  valid_598790 = validateParameter(valid_598790, JString, required = false,
                                 default = nil)
  if valid_598790 != nil:
    section.add "fields", valid_598790
  var valid_598791 = query.getOrDefault("quotaUser")
  valid_598791 = validateParameter(valid_598791, JString, required = false,
                                 default = nil)
  if valid_598791 != nil:
    section.add "quotaUser", valid_598791
  var valid_598792 = query.getOrDefault("alt")
  valid_598792 = validateParameter(valid_598792, JString, required = false,
                                 default = newJString("json"))
  if valid_598792 != nil:
    section.add "alt", valid_598792
  var valid_598793 = query.getOrDefault("oauth_token")
  valid_598793 = validateParameter(valid_598793, JString, required = false,
                                 default = nil)
  if valid_598793 != nil:
    section.add "oauth_token", valid_598793
  var valid_598794 = query.getOrDefault("userIp")
  valid_598794 = validateParameter(valid_598794, JString, required = false,
                                 default = nil)
  if valid_598794 != nil:
    section.add "userIp", valid_598794
  var valid_598795 = query.getOrDefault("key")
  valid_598795 = validateParameter(valid_598795, JString, required = false,
                                 default = nil)
  if valid_598795 != nil:
    section.add "key", valid_598795
  var valid_598796 = query.getOrDefault("max-results")
  valid_598796 = validateParameter(valid_598796, JInt, required = false, default = nil)
  if valid_598796 != nil:
    section.add "max-results", valid_598796
  var valid_598797 = query.getOrDefault("start-index")
  valid_598797 = validateParameter(valid_598797, JInt, required = false, default = nil)
  if valid_598797 != nil:
    section.add "start-index", valid_598797
  var valid_598798 = query.getOrDefault("prettyPrint")
  valid_598798 = validateParameter(valid_598798, JBool, required = false,
                                 default = newJBool(false))
  if valid_598798 != nil:
    section.add "prettyPrint", valid_598798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598799: Call_AnalyticsManagementProfilesList_598785;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists views (profiles) to which the user has access.
  ## 
  let valid = call_598799.validator(path, query, header, formData, body)
  let scheme = call_598799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598799.url(scheme.get, call_598799.host, call_598799.base,
                         call_598799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598799, url, valid)

proc call*(call_598800: Call_AnalyticsManagementProfilesList_598785;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesList
  ## Lists views (profiles) to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of views (profiles) to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598801 = newJObject()
  var query_598802 = newJObject()
  add(query_598802, "fields", newJString(fields))
  add(query_598802, "quotaUser", newJString(quotaUser))
  add(query_598802, "alt", newJString(alt))
  add(query_598802, "oauth_token", newJString(oauthToken))
  add(path_598801, "accountId", newJString(accountId))
  add(query_598802, "userIp", newJString(userIp))
  add(path_598801, "webPropertyId", newJString(webPropertyId))
  add(query_598802, "key", newJString(key))
  add(query_598802, "max-results", newJInt(maxResults))
  add(query_598802, "start-index", newJInt(startIndex))
  add(query_598802, "prettyPrint", newJBool(prettyPrint))
  result = call_598800.call(path_598801, query_598802, nil, nil, nil)

var analyticsManagementProfilesList* = Call_AnalyticsManagementProfilesList_598785(
    name: "analyticsManagementProfilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesList_598786,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesList_598787,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesUpdate_598838 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfilesUpdate_598840(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesUpdate_598839(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which the view (profile) belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the view (profile) belongs
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598841 = path.getOrDefault("profileId")
  valid_598841 = validateParameter(valid_598841, JString, required = true,
                                 default = nil)
  if valid_598841 != nil:
    section.add "profileId", valid_598841
  var valid_598842 = path.getOrDefault("accountId")
  valid_598842 = validateParameter(valid_598842, JString, required = true,
                                 default = nil)
  if valid_598842 != nil:
    section.add "accountId", valid_598842
  var valid_598843 = path.getOrDefault("webPropertyId")
  valid_598843 = validateParameter(valid_598843, JString, required = true,
                                 default = nil)
  if valid_598843 != nil:
    section.add "webPropertyId", valid_598843
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598844 = query.getOrDefault("fields")
  valid_598844 = validateParameter(valid_598844, JString, required = false,
                                 default = nil)
  if valid_598844 != nil:
    section.add "fields", valid_598844
  var valid_598845 = query.getOrDefault("quotaUser")
  valid_598845 = validateParameter(valid_598845, JString, required = false,
                                 default = nil)
  if valid_598845 != nil:
    section.add "quotaUser", valid_598845
  var valid_598846 = query.getOrDefault("alt")
  valid_598846 = validateParameter(valid_598846, JString, required = false,
                                 default = newJString("json"))
  if valid_598846 != nil:
    section.add "alt", valid_598846
  var valid_598847 = query.getOrDefault("oauth_token")
  valid_598847 = validateParameter(valid_598847, JString, required = false,
                                 default = nil)
  if valid_598847 != nil:
    section.add "oauth_token", valid_598847
  var valid_598848 = query.getOrDefault("userIp")
  valid_598848 = validateParameter(valid_598848, JString, required = false,
                                 default = nil)
  if valid_598848 != nil:
    section.add "userIp", valid_598848
  var valid_598849 = query.getOrDefault("key")
  valid_598849 = validateParameter(valid_598849, JString, required = false,
                                 default = nil)
  if valid_598849 != nil:
    section.add "key", valid_598849
  var valid_598850 = query.getOrDefault("prettyPrint")
  valid_598850 = validateParameter(valid_598850, JBool, required = false,
                                 default = newJBool(false))
  if valid_598850 != nil:
    section.add "prettyPrint", valid_598850
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

proc call*(call_598852: Call_AnalyticsManagementProfilesUpdate_598838;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile).
  ## 
  let valid = call_598852.validator(path, query, header, formData, body)
  let scheme = call_598852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598852.url(scheme.get, call_598852.host, call_598852.base,
                         call_598852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598852, url, valid)

proc call*(call_598853: Call_AnalyticsManagementProfilesUpdate_598838;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesUpdate
  ## Updates an existing view (profile).
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the view (profile) belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598854 = newJObject()
  var query_598855 = newJObject()
  var body_598856 = newJObject()
  add(path_598854, "profileId", newJString(profileId))
  add(query_598855, "fields", newJString(fields))
  add(query_598855, "quotaUser", newJString(quotaUser))
  add(query_598855, "alt", newJString(alt))
  add(query_598855, "oauth_token", newJString(oauthToken))
  add(path_598854, "accountId", newJString(accountId))
  add(query_598855, "userIp", newJString(userIp))
  add(path_598854, "webPropertyId", newJString(webPropertyId))
  add(query_598855, "key", newJString(key))
  if body != nil:
    body_598856 = body
  add(query_598855, "prettyPrint", newJBool(prettyPrint))
  result = call_598853.call(path_598854, query_598855, nil, nil, body_598856)

var analyticsManagementProfilesUpdate* = Call_AnalyticsManagementProfilesUpdate_598838(
    name: "analyticsManagementProfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesUpdate_598839,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesUpdate_598840,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesGet_598821 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfilesGet_598823(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesGet_598822(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a view (profile) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the view (profile) for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the view (profile) for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the view (profile) for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598824 = path.getOrDefault("profileId")
  valid_598824 = validateParameter(valid_598824, JString, required = true,
                                 default = nil)
  if valid_598824 != nil:
    section.add "profileId", valid_598824
  var valid_598825 = path.getOrDefault("accountId")
  valid_598825 = validateParameter(valid_598825, JString, required = true,
                                 default = nil)
  if valid_598825 != nil:
    section.add "accountId", valid_598825
  var valid_598826 = path.getOrDefault("webPropertyId")
  valid_598826 = validateParameter(valid_598826, JString, required = true,
                                 default = nil)
  if valid_598826 != nil:
    section.add "webPropertyId", valid_598826
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598827 = query.getOrDefault("fields")
  valid_598827 = validateParameter(valid_598827, JString, required = false,
                                 default = nil)
  if valid_598827 != nil:
    section.add "fields", valid_598827
  var valid_598828 = query.getOrDefault("quotaUser")
  valid_598828 = validateParameter(valid_598828, JString, required = false,
                                 default = nil)
  if valid_598828 != nil:
    section.add "quotaUser", valid_598828
  var valid_598829 = query.getOrDefault("alt")
  valid_598829 = validateParameter(valid_598829, JString, required = false,
                                 default = newJString("json"))
  if valid_598829 != nil:
    section.add "alt", valid_598829
  var valid_598830 = query.getOrDefault("oauth_token")
  valid_598830 = validateParameter(valid_598830, JString, required = false,
                                 default = nil)
  if valid_598830 != nil:
    section.add "oauth_token", valid_598830
  var valid_598831 = query.getOrDefault("userIp")
  valid_598831 = validateParameter(valid_598831, JString, required = false,
                                 default = nil)
  if valid_598831 != nil:
    section.add "userIp", valid_598831
  var valid_598832 = query.getOrDefault("key")
  valid_598832 = validateParameter(valid_598832, JString, required = false,
                                 default = nil)
  if valid_598832 != nil:
    section.add "key", valid_598832
  var valid_598833 = query.getOrDefault("prettyPrint")
  valid_598833 = validateParameter(valid_598833, JBool, required = false,
                                 default = newJBool(false))
  if valid_598833 != nil:
    section.add "prettyPrint", valid_598833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598834: Call_AnalyticsManagementProfilesGet_598821; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a view (profile) to which the user has access.
  ## 
  let valid = call_598834.validator(path, query, header, formData, body)
  let scheme = call_598834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598834.url(scheme.get, call_598834.host, call_598834.base,
                         call_598834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598834, url, valid)

proc call*(call_598835: Call_AnalyticsManagementProfilesGet_598821;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesGet
  ## Gets a view (profile) to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the view (profile) for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the view (profile) for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the view (profile) for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598836 = newJObject()
  var query_598837 = newJObject()
  add(path_598836, "profileId", newJString(profileId))
  add(query_598837, "fields", newJString(fields))
  add(query_598837, "quotaUser", newJString(quotaUser))
  add(query_598837, "alt", newJString(alt))
  add(query_598837, "oauth_token", newJString(oauthToken))
  add(path_598836, "accountId", newJString(accountId))
  add(query_598837, "userIp", newJString(userIp))
  add(path_598836, "webPropertyId", newJString(webPropertyId))
  add(query_598837, "key", newJString(key))
  add(query_598837, "prettyPrint", newJBool(prettyPrint))
  result = call_598835.call(path_598836, query_598837, nil, nil, nil)

var analyticsManagementProfilesGet* = Call_AnalyticsManagementProfilesGet_598821(
    name: "analyticsManagementProfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesGet_598822,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesGet_598823,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesPatch_598874 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfilesPatch_598876(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesPatch_598875(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing view (profile). This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which the view (profile) belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the view (profile) belongs
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598877 = path.getOrDefault("profileId")
  valid_598877 = validateParameter(valid_598877, JString, required = true,
                                 default = nil)
  if valid_598877 != nil:
    section.add "profileId", valid_598877
  var valid_598878 = path.getOrDefault("accountId")
  valid_598878 = validateParameter(valid_598878, JString, required = true,
                                 default = nil)
  if valid_598878 != nil:
    section.add "accountId", valid_598878
  var valid_598879 = path.getOrDefault("webPropertyId")
  valid_598879 = validateParameter(valid_598879, JString, required = true,
                                 default = nil)
  if valid_598879 != nil:
    section.add "webPropertyId", valid_598879
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598880 = query.getOrDefault("fields")
  valid_598880 = validateParameter(valid_598880, JString, required = false,
                                 default = nil)
  if valid_598880 != nil:
    section.add "fields", valid_598880
  var valid_598881 = query.getOrDefault("quotaUser")
  valid_598881 = validateParameter(valid_598881, JString, required = false,
                                 default = nil)
  if valid_598881 != nil:
    section.add "quotaUser", valid_598881
  var valid_598882 = query.getOrDefault("alt")
  valid_598882 = validateParameter(valid_598882, JString, required = false,
                                 default = newJString("json"))
  if valid_598882 != nil:
    section.add "alt", valid_598882
  var valid_598883 = query.getOrDefault("oauth_token")
  valid_598883 = validateParameter(valid_598883, JString, required = false,
                                 default = nil)
  if valid_598883 != nil:
    section.add "oauth_token", valid_598883
  var valid_598884 = query.getOrDefault("userIp")
  valid_598884 = validateParameter(valid_598884, JString, required = false,
                                 default = nil)
  if valid_598884 != nil:
    section.add "userIp", valid_598884
  var valid_598885 = query.getOrDefault("key")
  valid_598885 = validateParameter(valid_598885, JString, required = false,
                                 default = nil)
  if valid_598885 != nil:
    section.add "key", valid_598885
  var valid_598886 = query.getOrDefault("prettyPrint")
  valid_598886 = validateParameter(valid_598886, JBool, required = false,
                                 default = newJBool(false))
  if valid_598886 != nil:
    section.add "prettyPrint", valid_598886
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

proc call*(call_598888: Call_AnalyticsManagementProfilesPatch_598874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile). This method supports patch semantics.
  ## 
  let valid = call_598888.validator(path, query, header, formData, body)
  let scheme = call_598888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598888.url(scheme.get, call_598888.host, call_598888.base,
                         call_598888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598888, url, valid)

proc call*(call_598889: Call_AnalyticsManagementProfilesPatch_598874;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesPatch
  ## Updates an existing view (profile). This method supports patch semantics.
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the view (profile) belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598890 = newJObject()
  var query_598891 = newJObject()
  var body_598892 = newJObject()
  add(path_598890, "profileId", newJString(profileId))
  add(query_598891, "fields", newJString(fields))
  add(query_598891, "quotaUser", newJString(quotaUser))
  add(query_598891, "alt", newJString(alt))
  add(query_598891, "oauth_token", newJString(oauthToken))
  add(path_598890, "accountId", newJString(accountId))
  add(query_598891, "userIp", newJString(userIp))
  add(path_598890, "webPropertyId", newJString(webPropertyId))
  add(query_598891, "key", newJString(key))
  if body != nil:
    body_598892 = body
  add(query_598891, "prettyPrint", newJBool(prettyPrint))
  result = call_598889.call(path_598890, query_598891, nil, nil, body_598892)

var analyticsManagementProfilesPatch* = Call_AnalyticsManagementProfilesPatch_598874(
    name: "analyticsManagementProfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesPatch_598875,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesPatch_598876,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesDelete_598857 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfilesDelete_598859(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesDelete_598858(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be deleted.
  ##   accountId: JString (required)
  ##            : Account ID to delete the view (profile) for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the view (profile) for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598860 = path.getOrDefault("profileId")
  valid_598860 = validateParameter(valid_598860, JString, required = true,
                                 default = nil)
  if valid_598860 != nil:
    section.add "profileId", valid_598860
  var valid_598861 = path.getOrDefault("accountId")
  valid_598861 = validateParameter(valid_598861, JString, required = true,
                                 default = nil)
  if valid_598861 != nil:
    section.add "accountId", valid_598861
  var valid_598862 = path.getOrDefault("webPropertyId")
  valid_598862 = validateParameter(valid_598862, JString, required = true,
                                 default = nil)
  if valid_598862 != nil:
    section.add "webPropertyId", valid_598862
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598863 = query.getOrDefault("fields")
  valid_598863 = validateParameter(valid_598863, JString, required = false,
                                 default = nil)
  if valid_598863 != nil:
    section.add "fields", valid_598863
  var valid_598864 = query.getOrDefault("quotaUser")
  valid_598864 = validateParameter(valid_598864, JString, required = false,
                                 default = nil)
  if valid_598864 != nil:
    section.add "quotaUser", valid_598864
  var valid_598865 = query.getOrDefault("alt")
  valid_598865 = validateParameter(valid_598865, JString, required = false,
                                 default = newJString("json"))
  if valid_598865 != nil:
    section.add "alt", valid_598865
  var valid_598866 = query.getOrDefault("oauth_token")
  valid_598866 = validateParameter(valid_598866, JString, required = false,
                                 default = nil)
  if valid_598866 != nil:
    section.add "oauth_token", valid_598866
  var valid_598867 = query.getOrDefault("userIp")
  valid_598867 = validateParameter(valid_598867, JString, required = false,
                                 default = nil)
  if valid_598867 != nil:
    section.add "userIp", valid_598867
  var valid_598868 = query.getOrDefault("key")
  valid_598868 = validateParameter(valid_598868, JString, required = false,
                                 default = nil)
  if valid_598868 != nil:
    section.add "key", valid_598868
  var valid_598869 = query.getOrDefault("prettyPrint")
  valid_598869 = validateParameter(valid_598869, JBool, required = false,
                                 default = newJBool(false))
  if valid_598869 != nil:
    section.add "prettyPrint", valid_598869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598870: Call_AnalyticsManagementProfilesDelete_598857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a view (profile).
  ## 
  let valid = call_598870.validator(path, query, header, formData, body)
  let scheme = call_598870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598870.url(scheme.get, call_598870.host, call_598870.base,
                         call_598870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598870, url, valid)

proc call*(call_598871: Call_AnalyticsManagementProfilesDelete_598857;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesDelete
  ## Deletes a view (profile).
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the view (profile) for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the view (profile) for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598872 = newJObject()
  var query_598873 = newJObject()
  add(path_598872, "profileId", newJString(profileId))
  add(query_598873, "fields", newJString(fields))
  add(query_598873, "quotaUser", newJString(quotaUser))
  add(query_598873, "alt", newJString(alt))
  add(query_598873, "oauth_token", newJString(oauthToken))
  add(path_598872, "accountId", newJString(accountId))
  add(query_598873, "userIp", newJString(userIp))
  add(path_598872, "webPropertyId", newJString(webPropertyId))
  add(query_598873, "key", newJString(key))
  add(query_598873, "prettyPrint", newJBool(prettyPrint))
  result = call_598871.call(path_598872, query_598873, nil, nil, nil)

var analyticsManagementProfilesDelete* = Call_AnalyticsManagementProfilesDelete_598857(
    name: "analyticsManagementProfilesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesDelete_598858,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesDelete_598859,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksInsert_598912 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileUserLinksInsert_598914(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksInsert_598913(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new user to the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to create the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598915 = path.getOrDefault("profileId")
  valid_598915 = validateParameter(valid_598915, JString, required = true,
                                 default = nil)
  if valid_598915 != nil:
    section.add "profileId", valid_598915
  var valid_598916 = path.getOrDefault("accountId")
  valid_598916 = validateParameter(valid_598916, JString, required = true,
                                 default = nil)
  if valid_598916 != nil:
    section.add "accountId", valid_598916
  var valid_598917 = path.getOrDefault("webPropertyId")
  valid_598917 = validateParameter(valid_598917, JString, required = true,
                                 default = nil)
  if valid_598917 != nil:
    section.add "webPropertyId", valid_598917
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598918 = query.getOrDefault("fields")
  valid_598918 = validateParameter(valid_598918, JString, required = false,
                                 default = nil)
  if valid_598918 != nil:
    section.add "fields", valid_598918
  var valid_598919 = query.getOrDefault("quotaUser")
  valid_598919 = validateParameter(valid_598919, JString, required = false,
                                 default = nil)
  if valid_598919 != nil:
    section.add "quotaUser", valid_598919
  var valid_598920 = query.getOrDefault("alt")
  valid_598920 = validateParameter(valid_598920, JString, required = false,
                                 default = newJString("json"))
  if valid_598920 != nil:
    section.add "alt", valid_598920
  var valid_598921 = query.getOrDefault("oauth_token")
  valid_598921 = validateParameter(valid_598921, JString, required = false,
                                 default = nil)
  if valid_598921 != nil:
    section.add "oauth_token", valid_598921
  var valid_598922 = query.getOrDefault("userIp")
  valid_598922 = validateParameter(valid_598922, JString, required = false,
                                 default = nil)
  if valid_598922 != nil:
    section.add "userIp", valid_598922
  var valid_598923 = query.getOrDefault("key")
  valid_598923 = validateParameter(valid_598923, JString, required = false,
                                 default = nil)
  if valid_598923 != nil:
    section.add "key", valid_598923
  var valid_598924 = query.getOrDefault("prettyPrint")
  valid_598924 = validateParameter(valid_598924, JBool, required = false,
                                 default = newJBool(false))
  if valid_598924 != nil:
    section.add "prettyPrint", valid_598924
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

proc call*(call_598926: Call_AnalyticsManagementProfileUserLinksInsert_598912;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given view (profile).
  ## 
  let valid = call_598926.validator(path, query, header, formData, body)
  let scheme = call_598926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598926.url(scheme.get, call_598926.host, call_598926.base,
                         call_598926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598926, url, valid)

proc call*(call_598927: Call_AnalyticsManagementProfileUserLinksInsert_598912;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksInsert
  ## Adds a new user to the given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to create the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598928 = newJObject()
  var query_598929 = newJObject()
  var body_598930 = newJObject()
  add(path_598928, "profileId", newJString(profileId))
  add(query_598929, "fields", newJString(fields))
  add(query_598929, "quotaUser", newJString(quotaUser))
  add(query_598929, "alt", newJString(alt))
  add(query_598929, "oauth_token", newJString(oauthToken))
  add(path_598928, "accountId", newJString(accountId))
  add(query_598929, "userIp", newJString(userIp))
  add(path_598928, "webPropertyId", newJString(webPropertyId))
  add(query_598929, "key", newJString(key))
  if body != nil:
    body_598930 = body
  add(query_598929, "prettyPrint", newJBool(prettyPrint))
  result = call_598927.call(path_598928, query_598929, nil, nil, body_598930)

var analyticsManagementProfileUserLinksInsert* = Call_AnalyticsManagementProfileUserLinksInsert_598912(
    name: "analyticsManagementProfileUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksInsert_598913,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksInsert_598914,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksList_598893 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileUserLinksList_598895(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksList_598894(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists profile-user links for a given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the profile-user links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID which the given view (profile) belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID which the given view (profile) belongs to. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598896 = path.getOrDefault("profileId")
  valid_598896 = validateParameter(valid_598896, JString, required = true,
                                 default = nil)
  if valid_598896 != nil:
    section.add "profileId", valid_598896
  var valid_598897 = path.getOrDefault("accountId")
  valid_598897 = validateParameter(valid_598897, JString, required = true,
                                 default = nil)
  if valid_598897 != nil:
    section.add "accountId", valid_598897
  var valid_598898 = path.getOrDefault("webPropertyId")
  valid_598898 = validateParameter(valid_598898, JString, required = true,
                                 default = nil)
  if valid_598898 != nil:
    section.add "webPropertyId", valid_598898
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of profile-user links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first profile-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598899 = query.getOrDefault("fields")
  valid_598899 = validateParameter(valid_598899, JString, required = false,
                                 default = nil)
  if valid_598899 != nil:
    section.add "fields", valid_598899
  var valid_598900 = query.getOrDefault("quotaUser")
  valid_598900 = validateParameter(valid_598900, JString, required = false,
                                 default = nil)
  if valid_598900 != nil:
    section.add "quotaUser", valid_598900
  var valid_598901 = query.getOrDefault("alt")
  valid_598901 = validateParameter(valid_598901, JString, required = false,
                                 default = newJString("json"))
  if valid_598901 != nil:
    section.add "alt", valid_598901
  var valid_598902 = query.getOrDefault("oauth_token")
  valid_598902 = validateParameter(valid_598902, JString, required = false,
                                 default = nil)
  if valid_598902 != nil:
    section.add "oauth_token", valid_598902
  var valid_598903 = query.getOrDefault("userIp")
  valid_598903 = validateParameter(valid_598903, JString, required = false,
                                 default = nil)
  if valid_598903 != nil:
    section.add "userIp", valid_598903
  var valid_598904 = query.getOrDefault("key")
  valid_598904 = validateParameter(valid_598904, JString, required = false,
                                 default = nil)
  if valid_598904 != nil:
    section.add "key", valid_598904
  var valid_598905 = query.getOrDefault("max-results")
  valid_598905 = validateParameter(valid_598905, JInt, required = false, default = nil)
  if valid_598905 != nil:
    section.add "max-results", valid_598905
  var valid_598906 = query.getOrDefault("start-index")
  valid_598906 = validateParameter(valid_598906, JInt, required = false, default = nil)
  if valid_598906 != nil:
    section.add "start-index", valid_598906
  var valid_598907 = query.getOrDefault("prettyPrint")
  valid_598907 = validateParameter(valid_598907, JBool, required = false,
                                 default = newJBool(false))
  if valid_598907 != nil:
    section.add "prettyPrint", valid_598907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598908: Call_AnalyticsManagementProfileUserLinksList_598893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists profile-user links for a given view (profile).
  ## 
  let valid = call_598908.validator(path, query, header, formData, body)
  let scheme = call_598908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598908.url(scheme.get, call_598908.host, call_598908.base,
                         call_598908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598908, url, valid)

proc call*(call_598909: Call_AnalyticsManagementProfileUserLinksList_598893;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksList
  ## Lists profile-user links for a given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the profile-user links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID which the given view (profile) belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID which the given view (profile) belongs to. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of profile-user links to include in this response.
  ##   startIndex: int
  ##             : An index of the first profile-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598910 = newJObject()
  var query_598911 = newJObject()
  add(path_598910, "profileId", newJString(profileId))
  add(query_598911, "fields", newJString(fields))
  add(query_598911, "quotaUser", newJString(quotaUser))
  add(query_598911, "alt", newJString(alt))
  add(query_598911, "oauth_token", newJString(oauthToken))
  add(path_598910, "accountId", newJString(accountId))
  add(query_598911, "userIp", newJString(userIp))
  add(path_598910, "webPropertyId", newJString(webPropertyId))
  add(query_598911, "key", newJString(key))
  add(query_598911, "max-results", newJInt(maxResults))
  add(query_598911, "start-index", newJInt(startIndex))
  add(query_598911, "prettyPrint", newJBool(prettyPrint))
  result = call_598909.call(path_598910, query_598911, nil, nil, nil)

var analyticsManagementProfileUserLinksList* = Call_AnalyticsManagementProfileUserLinksList_598893(
    name: "analyticsManagementProfileUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksList_598894,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksList_598895,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksUpdate_598931 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileUserLinksUpdate_598933(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksUpdate_598932(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile ID) to update the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to update the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to update the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598934 = path.getOrDefault("profileId")
  valid_598934 = validateParameter(valid_598934, JString, required = true,
                                 default = nil)
  if valid_598934 != nil:
    section.add "profileId", valid_598934
  var valid_598935 = path.getOrDefault("accountId")
  valid_598935 = validateParameter(valid_598935, JString, required = true,
                                 default = nil)
  if valid_598935 != nil:
    section.add "accountId", valid_598935
  var valid_598936 = path.getOrDefault("webPropertyId")
  valid_598936 = validateParameter(valid_598936, JString, required = true,
                                 default = nil)
  if valid_598936 != nil:
    section.add "webPropertyId", valid_598936
  var valid_598937 = path.getOrDefault("linkId")
  valid_598937 = validateParameter(valid_598937, JString, required = true,
                                 default = nil)
  if valid_598937 != nil:
    section.add "linkId", valid_598937
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598938 = query.getOrDefault("fields")
  valid_598938 = validateParameter(valid_598938, JString, required = false,
                                 default = nil)
  if valid_598938 != nil:
    section.add "fields", valid_598938
  var valid_598939 = query.getOrDefault("quotaUser")
  valid_598939 = validateParameter(valid_598939, JString, required = false,
                                 default = nil)
  if valid_598939 != nil:
    section.add "quotaUser", valid_598939
  var valid_598940 = query.getOrDefault("alt")
  valid_598940 = validateParameter(valid_598940, JString, required = false,
                                 default = newJString("json"))
  if valid_598940 != nil:
    section.add "alt", valid_598940
  var valid_598941 = query.getOrDefault("oauth_token")
  valid_598941 = validateParameter(valid_598941, JString, required = false,
                                 default = nil)
  if valid_598941 != nil:
    section.add "oauth_token", valid_598941
  var valid_598942 = query.getOrDefault("userIp")
  valid_598942 = validateParameter(valid_598942, JString, required = false,
                                 default = nil)
  if valid_598942 != nil:
    section.add "userIp", valid_598942
  var valid_598943 = query.getOrDefault("key")
  valid_598943 = validateParameter(valid_598943, JString, required = false,
                                 default = nil)
  if valid_598943 != nil:
    section.add "key", valid_598943
  var valid_598944 = query.getOrDefault("prettyPrint")
  valid_598944 = validateParameter(valid_598944, JBool, required = false,
                                 default = newJBool(false))
  if valid_598944 != nil:
    section.add "prettyPrint", valid_598944
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

proc call*(call_598946: Call_AnalyticsManagementProfileUserLinksUpdate_598931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given view (profile).
  ## 
  let valid = call_598946.validator(path, query, header, formData, body)
  let scheme = call_598946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598946.url(scheme.get, call_598946.host, call_598946.base,
                         call_598946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598946, url, valid)

proc call*(call_598947: Call_AnalyticsManagementProfileUserLinksUpdate_598931;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksUpdate
  ## Updates permissions for an existing user on the given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile ID) to update the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to update the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to update the user link for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598948 = newJObject()
  var query_598949 = newJObject()
  var body_598950 = newJObject()
  add(path_598948, "profileId", newJString(profileId))
  add(query_598949, "fields", newJString(fields))
  add(query_598949, "quotaUser", newJString(quotaUser))
  add(query_598949, "alt", newJString(alt))
  add(query_598949, "oauth_token", newJString(oauthToken))
  add(path_598948, "accountId", newJString(accountId))
  add(query_598949, "userIp", newJString(userIp))
  add(path_598948, "webPropertyId", newJString(webPropertyId))
  add(query_598949, "key", newJString(key))
  add(path_598948, "linkId", newJString(linkId))
  if body != nil:
    body_598950 = body
  add(query_598949, "prettyPrint", newJBool(prettyPrint))
  result = call_598947.call(path_598948, query_598949, nil, nil, body_598950)

var analyticsManagementProfileUserLinksUpdate* = Call_AnalyticsManagementProfileUserLinksUpdate_598931(
    name: "analyticsManagementProfileUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksUpdate_598932,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksUpdate_598933,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksDelete_598951 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileUserLinksDelete_598953(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksDelete_598952(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a user from the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to delete the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598954 = path.getOrDefault("profileId")
  valid_598954 = validateParameter(valid_598954, JString, required = true,
                                 default = nil)
  if valid_598954 != nil:
    section.add "profileId", valid_598954
  var valid_598955 = path.getOrDefault("accountId")
  valid_598955 = validateParameter(valid_598955, JString, required = true,
                                 default = nil)
  if valid_598955 != nil:
    section.add "accountId", valid_598955
  var valid_598956 = path.getOrDefault("webPropertyId")
  valid_598956 = validateParameter(valid_598956, JString, required = true,
                                 default = nil)
  if valid_598956 != nil:
    section.add "webPropertyId", valid_598956
  var valid_598957 = path.getOrDefault("linkId")
  valid_598957 = validateParameter(valid_598957, JString, required = true,
                                 default = nil)
  if valid_598957 != nil:
    section.add "linkId", valid_598957
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598958 = query.getOrDefault("fields")
  valid_598958 = validateParameter(valid_598958, JString, required = false,
                                 default = nil)
  if valid_598958 != nil:
    section.add "fields", valid_598958
  var valid_598959 = query.getOrDefault("quotaUser")
  valid_598959 = validateParameter(valid_598959, JString, required = false,
                                 default = nil)
  if valid_598959 != nil:
    section.add "quotaUser", valid_598959
  var valid_598960 = query.getOrDefault("alt")
  valid_598960 = validateParameter(valid_598960, JString, required = false,
                                 default = newJString("json"))
  if valid_598960 != nil:
    section.add "alt", valid_598960
  var valid_598961 = query.getOrDefault("oauth_token")
  valid_598961 = validateParameter(valid_598961, JString, required = false,
                                 default = nil)
  if valid_598961 != nil:
    section.add "oauth_token", valid_598961
  var valid_598962 = query.getOrDefault("userIp")
  valid_598962 = validateParameter(valid_598962, JString, required = false,
                                 default = nil)
  if valid_598962 != nil:
    section.add "userIp", valid_598962
  var valid_598963 = query.getOrDefault("key")
  valid_598963 = validateParameter(valid_598963, JString, required = false,
                                 default = nil)
  if valid_598963 != nil:
    section.add "key", valid_598963
  var valid_598964 = query.getOrDefault("prettyPrint")
  valid_598964 = validateParameter(valid_598964, JBool, required = false,
                                 default = newJBool(false))
  if valid_598964 != nil:
    section.add "prettyPrint", valid_598964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598965: Call_AnalyticsManagementProfileUserLinksDelete_598951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given view (profile).
  ## 
  let valid = call_598965.validator(path, query, header, formData, body)
  let scheme = call_598965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598965.url(scheme.get, call_598965.host, call_598965.base,
                         call_598965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598965, url, valid)

proc call*(call_598966: Call_AnalyticsManagementProfileUserLinksDelete_598951;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksDelete
  ## Removes a user from the given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile) ID to delete the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to delete the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598967 = newJObject()
  var query_598968 = newJObject()
  add(path_598967, "profileId", newJString(profileId))
  add(query_598968, "fields", newJString(fields))
  add(query_598968, "quotaUser", newJString(quotaUser))
  add(query_598968, "alt", newJString(alt))
  add(query_598968, "oauth_token", newJString(oauthToken))
  add(path_598967, "accountId", newJString(accountId))
  add(query_598968, "userIp", newJString(userIp))
  add(path_598967, "webPropertyId", newJString(webPropertyId))
  add(query_598968, "key", newJString(key))
  add(path_598967, "linkId", newJString(linkId))
  add(query_598968, "prettyPrint", newJBool(prettyPrint))
  result = call_598966.call(path_598967, query_598968, nil, nil, nil)

var analyticsManagementProfileUserLinksDelete* = Call_AnalyticsManagementProfileUserLinksDelete_598951(
    name: "analyticsManagementProfileUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksDelete_598952,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksDelete_598953,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsInsert_598988 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementExperimentsInsert_598990(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/experiments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsInsert_598989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the experiment for.
  ##   accountId: JString (required)
  ##            : Account ID to create the experiment for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the experiment for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598991 = path.getOrDefault("profileId")
  valid_598991 = validateParameter(valid_598991, JString, required = true,
                                 default = nil)
  if valid_598991 != nil:
    section.add "profileId", valid_598991
  var valid_598992 = path.getOrDefault("accountId")
  valid_598992 = validateParameter(valid_598992, JString, required = true,
                                 default = nil)
  if valid_598992 != nil:
    section.add "accountId", valid_598992
  var valid_598993 = path.getOrDefault("webPropertyId")
  valid_598993 = validateParameter(valid_598993, JString, required = true,
                                 default = nil)
  if valid_598993 != nil:
    section.add "webPropertyId", valid_598993
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598994 = query.getOrDefault("fields")
  valid_598994 = validateParameter(valid_598994, JString, required = false,
                                 default = nil)
  if valid_598994 != nil:
    section.add "fields", valid_598994
  var valid_598995 = query.getOrDefault("quotaUser")
  valid_598995 = validateParameter(valid_598995, JString, required = false,
                                 default = nil)
  if valid_598995 != nil:
    section.add "quotaUser", valid_598995
  var valid_598996 = query.getOrDefault("alt")
  valid_598996 = validateParameter(valid_598996, JString, required = false,
                                 default = newJString("json"))
  if valid_598996 != nil:
    section.add "alt", valid_598996
  var valid_598997 = query.getOrDefault("oauth_token")
  valid_598997 = validateParameter(valid_598997, JString, required = false,
                                 default = nil)
  if valid_598997 != nil:
    section.add "oauth_token", valid_598997
  var valid_598998 = query.getOrDefault("userIp")
  valid_598998 = validateParameter(valid_598998, JString, required = false,
                                 default = nil)
  if valid_598998 != nil:
    section.add "userIp", valid_598998
  var valid_598999 = query.getOrDefault("key")
  valid_598999 = validateParameter(valid_598999, JString, required = false,
                                 default = nil)
  if valid_598999 != nil:
    section.add "key", valid_598999
  var valid_599000 = query.getOrDefault("prettyPrint")
  valid_599000 = validateParameter(valid_599000, JBool, required = false,
                                 default = newJBool(false))
  if valid_599000 != nil:
    section.add "prettyPrint", valid_599000
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

proc call*(call_599002: Call_AnalyticsManagementExperimentsInsert_598988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new experiment.
  ## 
  let valid = call_599002.validator(path, query, header, formData, body)
  let scheme = call_599002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599002.url(scheme.get, call_599002.host, call_599002.base,
                         call_599002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599002, url, valid)

proc call*(call_599003: Call_AnalyticsManagementExperimentsInsert_598988;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsInsert
  ## Create a new experiment.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the experiment for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the experiment for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the experiment for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599004 = newJObject()
  var query_599005 = newJObject()
  var body_599006 = newJObject()
  add(path_599004, "profileId", newJString(profileId))
  add(query_599005, "fields", newJString(fields))
  add(query_599005, "quotaUser", newJString(quotaUser))
  add(query_599005, "alt", newJString(alt))
  add(query_599005, "oauth_token", newJString(oauthToken))
  add(path_599004, "accountId", newJString(accountId))
  add(query_599005, "userIp", newJString(userIp))
  add(path_599004, "webPropertyId", newJString(webPropertyId))
  add(query_599005, "key", newJString(key))
  if body != nil:
    body_599006 = body
  add(query_599005, "prettyPrint", newJBool(prettyPrint))
  result = call_599003.call(path_599004, query_599005, nil, nil, body_599006)

var analyticsManagementExperimentsInsert* = Call_AnalyticsManagementExperimentsInsert_598988(
    name: "analyticsManagementExperimentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsInsert_598989,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsInsert_598990,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsList_598969 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementExperimentsList_598971(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/experiments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsList_598970(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists experiments to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve experiments for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve experiments for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve experiments for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_598972 = path.getOrDefault("profileId")
  valid_598972 = validateParameter(valid_598972, JString, required = true,
                                 default = nil)
  if valid_598972 != nil:
    section.add "profileId", valid_598972
  var valid_598973 = path.getOrDefault("accountId")
  valid_598973 = validateParameter(valid_598973, JString, required = true,
                                 default = nil)
  if valid_598973 != nil:
    section.add "accountId", valid_598973
  var valid_598974 = path.getOrDefault("webPropertyId")
  valid_598974 = validateParameter(valid_598974, JString, required = true,
                                 default = nil)
  if valid_598974 != nil:
    section.add "webPropertyId", valid_598974
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of experiments to include in this response.
  ##   start-index: JInt
  ##              : An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598975 = query.getOrDefault("fields")
  valid_598975 = validateParameter(valid_598975, JString, required = false,
                                 default = nil)
  if valid_598975 != nil:
    section.add "fields", valid_598975
  var valid_598976 = query.getOrDefault("quotaUser")
  valid_598976 = validateParameter(valid_598976, JString, required = false,
                                 default = nil)
  if valid_598976 != nil:
    section.add "quotaUser", valid_598976
  var valid_598977 = query.getOrDefault("alt")
  valid_598977 = validateParameter(valid_598977, JString, required = false,
                                 default = newJString("json"))
  if valid_598977 != nil:
    section.add "alt", valid_598977
  var valid_598978 = query.getOrDefault("oauth_token")
  valid_598978 = validateParameter(valid_598978, JString, required = false,
                                 default = nil)
  if valid_598978 != nil:
    section.add "oauth_token", valid_598978
  var valid_598979 = query.getOrDefault("userIp")
  valid_598979 = validateParameter(valid_598979, JString, required = false,
                                 default = nil)
  if valid_598979 != nil:
    section.add "userIp", valid_598979
  var valid_598980 = query.getOrDefault("key")
  valid_598980 = validateParameter(valid_598980, JString, required = false,
                                 default = nil)
  if valid_598980 != nil:
    section.add "key", valid_598980
  var valid_598981 = query.getOrDefault("max-results")
  valid_598981 = validateParameter(valid_598981, JInt, required = false, default = nil)
  if valid_598981 != nil:
    section.add "max-results", valid_598981
  var valid_598982 = query.getOrDefault("start-index")
  valid_598982 = validateParameter(valid_598982, JInt, required = false, default = nil)
  if valid_598982 != nil:
    section.add "start-index", valid_598982
  var valid_598983 = query.getOrDefault("prettyPrint")
  valid_598983 = validateParameter(valid_598983, JBool, required = false,
                                 default = newJBool(false))
  if valid_598983 != nil:
    section.add "prettyPrint", valid_598983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598984: Call_AnalyticsManagementExperimentsList_598969;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists experiments to which the user has access.
  ## 
  let valid = call_598984.validator(path, query, header, formData, body)
  let scheme = call_598984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598984.url(scheme.get, call_598984.host, call_598984.base,
                         call_598984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598984, url, valid)

proc call*(call_598985: Call_AnalyticsManagementExperimentsList_598969;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsList
  ## Lists experiments to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve experiments for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve experiments for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve experiments for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of experiments to include in this response.
  ##   startIndex: int
  ##             : An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598986 = newJObject()
  var query_598987 = newJObject()
  add(path_598986, "profileId", newJString(profileId))
  add(query_598987, "fields", newJString(fields))
  add(query_598987, "quotaUser", newJString(quotaUser))
  add(query_598987, "alt", newJString(alt))
  add(query_598987, "oauth_token", newJString(oauthToken))
  add(path_598986, "accountId", newJString(accountId))
  add(query_598987, "userIp", newJString(userIp))
  add(path_598986, "webPropertyId", newJString(webPropertyId))
  add(query_598987, "key", newJString(key))
  add(query_598987, "max-results", newJInt(maxResults))
  add(query_598987, "start-index", newJInt(startIndex))
  add(query_598987, "prettyPrint", newJBool(prettyPrint))
  result = call_598985.call(path_598986, query_598987, nil, nil, nil)

var analyticsManagementExperimentsList* = Call_AnalyticsManagementExperimentsList_598969(
    name: "analyticsManagementExperimentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsList_598970,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsList_598971,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsUpdate_599025 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementExperimentsUpdate_599027(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsUpdate_599026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   accountId: JString (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: JString (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID of the experiment to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599028 = path.getOrDefault("profileId")
  valid_599028 = validateParameter(valid_599028, JString, required = true,
                                 default = nil)
  if valid_599028 != nil:
    section.add "profileId", valid_599028
  var valid_599029 = path.getOrDefault("accountId")
  valid_599029 = validateParameter(valid_599029, JString, required = true,
                                 default = nil)
  if valid_599029 != nil:
    section.add "accountId", valid_599029
  var valid_599030 = path.getOrDefault("experimentId")
  valid_599030 = validateParameter(valid_599030, JString, required = true,
                                 default = nil)
  if valid_599030 != nil:
    section.add "experimentId", valid_599030
  var valid_599031 = path.getOrDefault("webPropertyId")
  valid_599031 = validateParameter(valid_599031, JString, required = true,
                                 default = nil)
  if valid_599031 != nil:
    section.add "webPropertyId", valid_599031
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599032 = query.getOrDefault("fields")
  valid_599032 = validateParameter(valid_599032, JString, required = false,
                                 default = nil)
  if valid_599032 != nil:
    section.add "fields", valid_599032
  var valid_599033 = query.getOrDefault("quotaUser")
  valid_599033 = validateParameter(valid_599033, JString, required = false,
                                 default = nil)
  if valid_599033 != nil:
    section.add "quotaUser", valid_599033
  var valid_599034 = query.getOrDefault("alt")
  valid_599034 = validateParameter(valid_599034, JString, required = false,
                                 default = newJString("json"))
  if valid_599034 != nil:
    section.add "alt", valid_599034
  var valid_599035 = query.getOrDefault("oauth_token")
  valid_599035 = validateParameter(valid_599035, JString, required = false,
                                 default = nil)
  if valid_599035 != nil:
    section.add "oauth_token", valid_599035
  var valid_599036 = query.getOrDefault("userIp")
  valid_599036 = validateParameter(valid_599036, JString, required = false,
                                 default = nil)
  if valid_599036 != nil:
    section.add "userIp", valid_599036
  var valid_599037 = query.getOrDefault("key")
  valid_599037 = validateParameter(valid_599037, JString, required = false,
                                 default = nil)
  if valid_599037 != nil:
    section.add "key", valid_599037
  var valid_599038 = query.getOrDefault("prettyPrint")
  valid_599038 = validateParameter(valid_599038, JBool, required = false,
                                 default = newJBool(false))
  if valid_599038 != nil:
    section.add "prettyPrint", valid_599038
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

proc call*(call_599040: Call_AnalyticsManagementExperimentsUpdate_599025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment.
  ## 
  let valid = call_599040.validator(path, query, header, formData, body)
  let scheme = call_599040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599040.url(scheme.get, call_599040.host, call_599040.base,
                         call_599040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599040, url, valid)

proc call*(call_599041: Call_AnalyticsManagementExperimentsUpdate_599025;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsUpdate
  ## Update an existing experiment.
  ##   profileId: string (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID of the experiment to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: string (required)
  ##                : Web property ID of the experiment to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599042 = newJObject()
  var query_599043 = newJObject()
  var body_599044 = newJObject()
  add(path_599042, "profileId", newJString(profileId))
  add(query_599043, "fields", newJString(fields))
  add(query_599043, "quotaUser", newJString(quotaUser))
  add(query_599043, "alt", newJString(alt))
  add(query_599043, "oauth_token", newJString(oauthToken))
  add(path_599042, "accountId", newJString(accountId))
  add(query_599043, "userIp", newJString(userIp))
  add(path_599042, "experimentId", newJString(experimentId))
  add(path_599042, "webPropertyId", newJString(webPropertyId))
  add(query_599043, "key", newJString(key))
  if body != nil:
    body_599044 = body
  add(query_599043, "prettyPrint", newJBool(prettyPrint))
  result = call_599041.call(path_599042, query_599043, nil, nil, body_599044)

var analyticsManagementExperimentsUpdate* = Call_AnalyticsManagementExperimentsUpdate_599025(
    name: "analyticsManagementExperimentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsUpdate_599026,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsUpdate_599027,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsGet_599007 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementExperimentsGet_599009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsGet_599008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an experiment to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the experiment for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the experiment for.
  ##   experimentId: JString (required)
  ##               : Experiment ID to retrieve the experiment for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the experiment for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599010 = path.getOrDefault("profileId")
  valid_599010 = validateParameter(valid_599010, JString, required = true,
                                 default = nil)
  if valid_599010 != nil:
    section.add "profileId", valid_599010
  var valid_599011 = path.getOrDefault("accountId")
  valid_599011 = validateParameter(valid_599011, JString, required = true,
                                 default = nil)
  if valid_599011 != nil:
    section.add "accountId", valid_599011
  var valid_599012 = path.getOrDefault("experimentId")
  valid_599012 = validateParameter(valid_599012, JString, required = true,
                                 default = nil)
  if valid_599012 != nil:
    section.add "experimentId", valid_599012
  var valid_599013 = path.getOrDefault("webPropertyId")
  valid_599013 = validateParameter(valid_599013, JString, required = true,
                                 default = nil)
  if valid_599013 != nil:
    section.add "webPropertyId", valid_599013
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599014 = query.getOrDefault("fields")
  valid_599014 = validateParameter(valid_599014, JString, required = false,
                                 default = nil)
  if valid_599014 != nil:
    section.add "fields", valid_599014
  var valid_599015 = query.getOrDefault("quotaUser")
  valid_599015 = validateParameter(valid_599015, JString, required = false,
                                 default = nil)
  if valid_599015 != nil:
    section.add "quotaUser", valid_599015
  var valid_599016 = query.getOrDefault("alt")
  valid_599016 = validateParameter(valid_599016, JString, required = false,
                                 default = newJString("json"))
  if valid_599016 != nil:
    section.add "alt", valid_599016
  var valid_599017 = query.getOrDefault("oauth_token")
  valid_599017 = validateParameter(valid_599017, JString, required = false,
                                 default = nil)
  if valid_599017 != nil:
    section.add "oauth_token", valid_599017
  var valid_599018 = query.getOrDefault("userIp")
  valid_599018 = validateParameter(valid_599018, JString, required = false,
                                 default = nil)
  if valid_599018 != nil:
    section.add "userIp", valid_599018
  var valid_599019 = query.getOrDefault("key")
  valid_599019 = validateParameter(valid_599019, JString, required = false,
                                 default = nil)
  if valid_599019 != nil:
    section.add "key", valid_599019
  var valid_599020 = query.getOrDefault("prettyPrint")
  valid_599020 = validateParameter(valid_599020, JBool, required = false,
                                 default = newJBool(false))
  if valid_599020 != nil:
    section.add "prettyPrint", valid_599020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599021: Call_AnalyticsManagementExperimentsGet_599007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns an experiment to which the user has access.
  ## 
  let valid = call_599021.validator(path, query, header, formData, body)
  let scheme = call_599021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599021.url(scheme.get, call_599021.host, call_599021.base,
                         call_599021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599021, url, valid)

proc call*(call_599022: Call_AnalyticsManagementExperimentsGet_599007;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsGet
  ## Returns an experiment to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the experiment for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the experiment for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : Experiment ID to retrieve the experiment for.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the experiment for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599023 = newJObject()
  var query_599024 = newJObject()
  add(path_599023, "profileId", newJString(profileId))
  add(query_599024, "fields", newJString(fields))
  add(query_599024, "quotaUser", newJString(quotaUser))
  add(query_599024, "alt", newJString(alt))
  add(query_599024, "oauth_token", newJString(oauthToken))
  add(path_599023, "accountId", newJString(accountId))
  add(query_599024, "userIp", newJString(userIp))
  add(path_599023, "experimentId", newJString(experimentId))
  add(path_599023, "webPropertyId", newJString(webPropertyId))
  add(query_599024, "key", newJString(key))
  add(query_599024, "prettyPrint", newJBool(prettyPrint))
  result = call_599022.call(path_599023, query_599024, nil, nil, nil)

var analyticsManagementExperimentsGet* = Call_AnalyticsManagementExperimentsGet_599007(
    name: "analyticsManagementExperimentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsGet_599008,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsGet_599009,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsPatch_599063 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementExperimentsPatch_599065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsPatch_599064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing experiment. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   accountId: JString (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: JString (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID of the experiment to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599066 = path.getOrDefault("profileId")
  valid_599066 = validateParameter(valid_599066, JString, required = true,
                                 default = nil)
  if valid_599066 != nil:
    section.add "profileId", valid_599066
  var valid_599067 = path.getOrDefault("accountId")
  valid_599067 = validateParameter(valid_599067, JString, required = true,
                                 default = nil)
  if valid_599067 != nil:
    section.add "accountId", valid_599067
  var valid_599068 = path.getOrDefault("experimentId")
  valid_599068 = validateParameter(valid_599068, JString, required = true,
                                 default = nil)
  if valid_599068 != nil:
    section.add "experimentId", valid_599068
  var valid_599069 = path.getOrDefault("webPropertyId")
  valid_599069 = validateParameter(valid_599069, JString, required = true,
                                 default = nil)
  if valid_599069 != nil:
    section.add "webPropertyId", valid_599069
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599070 = query.getOrDefault("fields")
  valid_599070 = validateParameter(valid_599070, JString, required = false,
                                 default = nil)
  if valid_599070 != nil:
    section.add "fields", valid_599070
  var valid_599071 = query.getOrDefault("quotaUser")
  valid_599071 = validateParameter(valid_599071, JString, required = false,
                                 default = nil)
  if valid_599071 != nil:
    section.add "quotaUser", valid_599071
  var valid_599072 = query.getOrDefault("alt")
  valid_599072 = validateParameter(valid_599072, JString, required = false,
                                 default = newJString("json"))
  if valid_599072 != nil:
    section.add "alt", valid_599072
  var valid_599073 = query.getOrDefault("oauth_token")
  valid_599073 = validateParameter(valid_599073, JString, required = false,
                                 default = nil)
  if valid_599073 != nil:
    section.add "oauth_token", valid_599073
  var valid_599074 = query.getOrDefault("userIp")
  valid_599074 = validateParameter(valid_599074, JString, required = false,
                                 default = nil)
  if valid_599074 != nil:
    section.add "userIp", valid_599074
  var valid_599075 = query.getOrDefault("key")
  valid_599075 = validateParameter(valid_599075, JString, required = false,
                                 default = nil)
  if valid_599075 != nil:
    section.add "key", valid_599075
  var valid_599076 = query.getOrDefault("prettyPrint")
  valid_599076 = validateParameter(valid_599076, JBool, required = false,
                                 default = newJBool(false))
  if valid_599076 != nil:
    section.add "prettyPrint", valid_599076
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

proc call*(call_599078: Call_AnalyticsManagementExperimentsPatch_599063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment. This method supports patch semantics.
  ## 
  let valid = call_599078.validator(path, query, header, formData, body)
  let scheme = call_599078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599078.url(scheme.get, call_599078.host, call_599078.base,
                         call_599078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599078, url, valid)

proc call*(call_599079: Call_AnalyticsManagementExperimentsPatch_599063;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsPatch
  ## Update an existing experiment. This method supports patch semantics.
  ##   profileId: string (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID of the experiment to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: string (required)
  ##                : Web property ID of the experiment to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599080 = newJObject()
  var query_599081 = newJObject()
  var body_599082 = newJObject()
  add(path_599080, "profileId", newJString(profileId))
  add(query_599081, "fields", newJString(fields))
  add(query_599081, "quotaUser", newJString(quotaUser))
  add(query_599081, "alt", newJString(alt))
  add(query_599081, "oauth_token", newJString(oauthToken))
  add(path_599080, "accountId", newJString(accountId))
  add(query_599081, "userIp", newJString(userIp))
  add(path_599080, "experimentId", newJString(experimentId))
  add(path_599080, "webPropertyId", newJString(webPropertyId))
  add(query_599081, "key", newJString(key))
  if body != nil:
    body_599082 = body
  add(query_599081, "prettyPrint", newJBool(prettyPrint))
  result = call_599079.call(path_599080, query_599081, nil, nil, body_599082)

var analyticsManagementExperimentsPatch* = Call_AnalyticsManagementExperimentsPatch_599063(
    name: "analyticsManagementExperimentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsPatch_599064,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsPatch_599065,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsDelete_599045 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementExperimentsDelete_599047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsDelete_599046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to which the experiment belongs
  ##   accountId: JString (required)
  ##            : Account ID to which the experiment belongs
  ##   experimentId: JString (required)
  ##               : ID of the experiment to delete
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the experiment belongs
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599048 = path.getOrDefault("profileId")
  valid_599048 = validateParameter(valid_599048, JString, required = true,
                                 default = nil)
  if valid_599048 != nil:
    section.add "profileId", valid_599048
  var valid_599049 = path.getOrDefault("accountId")
  valid_599049 = validateParameter(valid_599049, JString, required = true,
                                 default = nil)
  if valid_599049 != nil:
    section.add "accountId", valid_599049
  var valid_599050 = path.getOrDefault("experimentId")
  valid_599050 = validateParameter(valid_599050, JString, required = true,
                                 default = nil)
  if valid_599050 != nil:
    section.add "experimentId", valid_599050
  var valid_599051 = path.getOrDefault("webPropertyId")
  valid_599051 = validateParameter(valid_599051, JString, required = true,
                                 default = nil)
  if valid_599051 != nil:
    section.add "webPropertyId", valid_599051
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599052 = query.getOrDefault("fields")
  valid_599052 = validateParameter(valid_599052, JString, required = false,
                                 default = nil)
  if valid_599052 != nil:
    section.add "fields", valid_599052
  var valid_599053 = query.getOrDefault("quotaUser")
  valid_599053 = validateParameter(valid_599053, JString, required = false,
                                 default = nil)
  if valid_599053 != nil:
    section.add "quotaUser", valid_599053
  var valid_599054 = query.getOrDefault("alt")
  valid_599054 = validateParameter(valid_599054, JString, required = false,
                                 default = newJString("json"))
  if valid_599054 != nil:
    section.add "alt", valid_599054
  var valid_599055 = query.getOrDefault("oauth_token")
  valid_599055 = validateParameter(valid_599055, JString, required = false,
                                 default = nil)
  if valid_599055 != nil:
    section.add "oauth_token", valid_599055
  var valid_599056 = query.getOrDefault("userIp")
  valid_599056 = validateParameter(valid_599056, JString, required = false,
                                 default = nil)
  if valid_599056 != nil:
    section.add "userIp", valid_599056
  var valid_599057 = query.getOrDefault("key")
  valid_599057 = validateParameter(valid_599057, JString, required = false,
                                 default = nil)
  if valid_599057 != nil:
    section.add "key", valid_599057
  var valid_599058 = query.getOrDefault("prettyPrint")
  valid_599058 = validateParameter(valid_599058, JBool, required = false,
                                 default = newJBool(false))
  if valid_599058 != nil:
    section.add "prettyPrint", valid_599058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599059: Call_AnalyticsManagementExperimentsDelete_599045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an experiment.
  ## 
  let valid = call_599059.validator(path, query, header, formData, body)
  let scheme = call_599059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599059.url(scheme.get, call_599059.host, call_599059.base,
                         call_599059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599059, url, valid)

proc call*(call_599060: Call_AnalyticsManagementExperimentsDelete_599045;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsDelete
  ## Delete an experiment.
  ##   profileId: string (required)
  ##            : View (Profile) ID to which the experiment belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the experiment belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : ID of the experiment to delete
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the experiment belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599061 = newJObject()
  var query_599062 = newJObject()
  add(path_599061, "profileId", newJString(profileId))
  add(query_599062, "fields", newJString(fields))
  add(query_599062, "quotaUser", newJString(quotaUser))
  add(query_599062, "alt", newJString(alt))
  add(query_599062, "oauth_token", newJString(oauthToken))
  add(path_599061, "accountId", newJString(accountId))
  add(query_599062, "userIp", newJString(userIp))
  add(path_599061, "experimentId", newJString(experimentId))
  add(path_599061, "webPropertyId", newJString(webPropertyId))
  add(query_599062, "key", newJString(key))
  add(query_599062, "prettyPrint", newJBool(prettyPrint))
  result = call_599060.call(path_599061, query_599062, nil, nil, nil)

var analyticsManagementExperimentsDelete* = Call_AnalyticsManagementExperimentsDelete_599045(
    name: "analyticsManagementExperimentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsDelete_599046,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsDelete_599047,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsInsert_599102 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementGoalsInsert_599104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementGoalsInsert_599103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new goal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the goal for.
  ##   accountId: JString (required)
  ##            : Account ID to create the goal for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the goal for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599105 = path.getOrDefault("profileId")
  valid_599105 = validateParameter(valid_599105, JString, required = true,
                                 default = nil)
  if valid_599105 != nil:
    section.add "profileId", valid_599105
  var valid_599106 = path.getOrDefault("accountId")
  valid_599106 = validateParameter(valid_599106, JString, required = true,
                                 default = nil)
  if valid_599106 != nil:
    section.add "accountId", valid_599106
  var valid_599107 = path.getOrDefault("webPropertyId")
  valid_599107 = validateParameter(valid_599107, JString, required = true,
                                 default = nil)
  if valid_599107 != nil:
    section.add "webPropertyId", valid_599107
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599108 = query.getOrDefault("fields")
  valid_599108 = validateParameter(valid_599108, JString, required = false,
                                 default = nil)
  if valid_599108 != nil:
    section.add "fields", valid_599108
  var valid_599109 = query.getOrDefault("quotaUser")
  valid_599109 = validateParameter(valid_599109, JString, required = false,
                                 default = nil)
  if valid_599109 != nil:
    section.add "quotaUser", valid_599109
  var valid_599110 = query.getOrDefault("alt")
  valid_599110 = validateParameter(valid_599110, JString, required = false,
                                 default = newJString("json"))
  if valid_599110 != nil:
    section.add "alt", valid_599110
  var valid_599111 = query.getOrDefault("oauth_token")
  valid_599111 = validateParameter(valid_599111, JString, required = false,
                                 default = nil)
  if valid_599111 != nil:
    section.add "oauth_token", valid_599111
  var valid_599112 = query.getOrDefault("userIp")
  valid_599112 = validateParameter(valid_599112, JString, required = false,
                                 default = nil)
  if valid_599112 != nil:
    section.add "userIp", valid_599112
  var valid_599113 = query.getOrDefault("key")
  valid_599113 = validateParameter(valid_599113, JString, required = false,
                                 default = nil)
  if valid_599113 != nil:
    section.add "key", valid_599113
  var valid_599114 = query.getOrDefault("prettyPrint")
  valid_599114 = validateParameter(valid_599114, JBool, required = false,
                                 default = newJBool(false))
  if valid_599114 != nil:
    section.add "prettyPrint", valid_599114
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

proc call*(call_599116: Call_AnalyticsManagementGoalsInsert_599102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new goal.
  ## 
  let valid = call_599116.validator(path, query, header, formData, body)
  let scheme = call_599116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599116.url(scheme.get, call_599116.host, call_599116.base,
                         call_599116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599116, url, valid)

proc call*(call_599117: Call_AnalyticsManagementGoalsInsert_599102;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsInsert
  ## Create a new goal.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the goal for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the goal for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the goal for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599118 = newJObject()
  var query_599119 = newJObject()
  var body_599120 = newJObject()
  add(path_599118, "profileId", newJString(profileId))
  add(query_599119, "fields", newJString(fields))
  add(query_599119, "quotaUser", newJString(quotaUser))
  add(query_599119, "alt", newJString(alt))
  add(query_599119, "oauth_token", newJString(oauthToken))
  add(path_599118, "accountId", newJString(accountId))
  add(query_599119, "userIp", newJString(userIp))
  add(path_599118, "webPropertyId", newJString(webPropertyId))
  add(query_599119, "key", newJString(key))
  if body != nil:
    body_599120 = body
  add(query_599119, "prettyPrint", newJBool(prettyPrint))
  result = call_599117.call(path_599118, query_599119, nil, nil, body_599120)

var analyticsManagementGoalsInsert* = Call_AnalyticsManagementGoalsInsert_599102(
    name: "analyticsManagementGoalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsInsert_599103,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsInsert_599104,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsList_599083 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementGoalsList_599085(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementGoalsList_599084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists goals to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599086 = path.getOrDefault("profileId")
  valid_599086 = validateParameter(valid_599086, JString, required = true,
                                 default = nil)
  if valid_599086 != nil:
    section.add "profileId", valid_599086
  var valid_599087 = path.getOrDefault("accountId")
  valid_599087 = validateParameter(valid_599087, JString, required = true,
                                 default = nil)
  if valid_599087 != nil:
    section.add "accountId", valid_599087
  var valid_599088 = path.getOrDefault("webPropertyId")
  valid_599088 = validateParameter(valid_599088, JString, required = true,
                                 default = nil)
  if valid_599088 != nil:
    section.add "webPropertyId", valid_599088
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of goals to include in this response.
  ##   start-index: JInt
  ##              : An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599089 = query.getOrDefault("fields")
  valid_599089 = validateParameter(valid_599089, JString, required = false,
                                 default = nil)
  if valid_599089 != nil:
    section.add "fields", valid_599089
  var valid_599090 = query.getOrDefault("quotaUser")
  valid_599090 = validateParameter(valid_599090, JString, required = false,
                                 default = nil)
  if valid_599090 != nil:
    section.add "quotaUser", valid_599090
  var valid_599091 = query.getOrDefault("alt")
  valid_599091 = validateParameter(valid_599091, JString, required = false,
                                 default = newJString("json"))
  if valid_599091 != nil:
    section.add "alt", valid_599091
  var valid_599092 = query.getOrDefault("oauth_token")
  valid_599092 = validateParameter(valid_599092, JString, required = false,
                                 default = nil)
  if valid_599092 != nil:
    section.add "oauth_token", valid_599092
  var valid_599093 = query.getOrDefault("userIp")
  valid_599093 = validateParameter(valid_599093, JString, required = false,
                                 default = nil)
  if valid_599093 != nil:
    section.add "userIp", valid_599093
  var valid_599094 = query.getOrDefault("key")
  valid_599094 = validateParameter(valid_599094, JString, required = false,
                                 default = nil)
  if valid_599094 != nil:
    section.add "key", valid_599094
  var valid_599095 = query.getOrDefault("max-results")
  valid_599095 = validateParameter(valid_599095, JInt, required = false, default = nil)
  if valid_599095 != nil:
    section.add "max-results", valid_599095
  var valid_599096 = query.getOrDefault("start-index")
  valid_599096 = validateParameter(valid_599096, JInt, required = false, default = nil)
  if valid_599096 != nil:
    section.add "start-index", valid_599096
  var valid_599097 = query.getOrDefault("prettyPrint")
  valid_599097 = validateParameter(valid_599097, JBool, required = false,
                                 default = newJBool(false))
  if valid_599097 != nil:
    section.add "prettyPrint", valid_599097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599098: Call_AnalyticsManagementGoalsList_599083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists goals to which the user has access.
  ## 
  let valid = call_599098.validator(path, query, header, formData, body)
  let scheme = call_599098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599098.url(scheme.get, call_599098.host, call_599098.base,
                         call_599098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599098, url, valid)

proc call*(call_599099: Call_AnalyticsManagementGoalsList_599083;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsList
  ## Lists goals to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of goals to include in this response.
  ##   startIndex: int
  ##             : An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599100 = newJObject()
  var query_599101 = newJObject()
  add(path_599100, "profileId", newJString(profileId))
  add(query_599101, "fields", newJString(fields))
  add(query_599101, "quotaUser", newJString(quotaUser))
  add(query_599101, "alt", newJString(alt))
  add(query_599101, "oauth_token", newJString(oauthToken))
  add(path_599100, "accountId", newJString(accountId))
  add(query_599101, "userIp", newJString(userIp))
  add(path_599100, "webPropertyId", newJString(webPropertyId))
  add(query_599101, "key", newJString(key))
  add(query_599101, "max-results", newJInt(maxResults))
  add(query_599101, "start-index", newJInt(startIndex))
  add(query_599101, "prettyPrint", newJBool(prettyPrint))
  result = call_599099.call(path_599100, query_599101, nil, nil, nil)

var analyticsManagementGoalsList* = Call_AnalyticsManagementGoalsList_599083(
    name: "analyticsManagementGoalsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsList_599084,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsList_599085,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsUpdate_599139 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementGoalsUpdate_599141(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "goalId" in path, "`goalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals/"),
               (kind: VariableSegment, value: "goalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsUpdate_599140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing goal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to update the goal.
  ##   accountId: JString (required)
  ##            : Account ID to update the goal.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the goal.
  ##   goalId: JString (required)
  ##         : Index of the goal to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599142 = path.getOrDefault("profileId")
  valid_599142 = validateParameter(valid_599142, JString, required = true,
                                 default = nil)
  if valid_599142 != nil:
    section.add "profileId", valid_599142
  var valid_599143 = path.getOrDefault("accountId")
  valid_599143 = validateParameter(valid_599143, JString, required = true,
                                 default = nil)
  if valid_599143 != nil:
    section.add "accountId", valid_599143
  var valid_599144 = path.getOrDefault("webPropertyId")
  valid_599144 = validateParameter(valid_599144, JString, required = true,
                                 default = nil)
  if valid_599144 != nil:
    section.add "webPropertyId", valid_599144
  var valid_599145 = path.getOrDefault("goalId")
  valid_599145 = validateParameter(valid_599145, JString, required = true,
                                 default = nil)
  if valid_599145 != nil:
    section.add "goalId", valid_599145
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599146 = query.getOrDefault("fields")
  valid_599146 = validateParameter(valid_599146, JString, required = false,
                                 default = nil)
  if valid_599146 != nil:
    section.add "fields", valid_599146
  var valid_599147 = query.getOrDefault("quotaUser")
  valid_599147 = validateParameter(valid_599147, JString, required = false,
                                 default = nil)
  if valid_599147 != nil:
    section.add "quotaUser", valid_599147
  var valid_599148 = query.getOrDefault("alt")
  valid_599148 = validateParameter(valid_599148, JString, required = false,
                                 default = newJString("json"))
  if valid_599148 != nil:
    section.add "alt", valid_599148
  var valid_599149 = query.getOrDefault("oauth_token")
  valid_599149 = validateParameter(valid_599149, JString, required = false,
                                 default = nil)
  if valid_599149 != nil:
    section.add "oauth_token", valid_599149
  var valid_599150 = query.getOrDefault("userIp")
  valid_599150 = validateParameter(valid_599150, JString, required = false,
                                 default = nil)
  if valid_599150 != nil:
    section.add "userIp", valid_599150
  var valid_599151 = query.getOrDefault("key")
  valid_599151 = validateParameter(valid_599151, JString, required = false,
                                 default = nil)
  if valid_599151 != nil:
    section.add "key", valid_599151
  var valid_599152 = query.getOrDefault("prettyPrint")
  valid_599152 = validateParameter(valid_599152, JBool, required = false,
                                 default = newJBool(false))
  if valid_599152 != nil:
    section.add "prettyPrint", valid_599152
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

proc call*(call_599154: Call_AnalyticsManagementGoalsUpdate_599139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal.
  ## 
  let valid = call_599154.validator(path, query, header, formData, body)
  let scheme = call_599154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599154.url(scheme.get, call_599154.host, call_599154.base,
                         call_599154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599154, url, valid)

proc call*(call_599155: Call_AnalyticsManagementGoalsUpdate_599139;
          profileId: string; accountId: string; webPropertyId: string; goalId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsUpdate
  ## Updates an existing goal.
  ##   profileId: string (required)
  ##            : View (Profile) ID to update the goal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the goal.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the goal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   goalId: string (required)
  ##         : Index of the goal to be updated.
  var path_599156 = newJObject()
  var query_599157 = newJObject()
  var body_599158 = newJObject()
  add(path_599156, "profileId", newJString(profileId))
  add(query_599157, "fields", newJString(fields))
  add(query_599157, "quotaUser", newJString(quotaUser))
  add(query_599157, "alt", newJString(alt))
  add(query_599157, "oauth_token", newJString(oauthToken))
  add(path_599156, "accountId", newJString(accountId))
  add(query_599157, "userIp", newJString(userIp))
  add(path_599156, "webPropertyId", newJString(webPropertyId))
  add(query_599157, "key", newJString(key))
  if body != nil:
    body_599158 = body
  add(query_599157, "prettyPrint", newJBool(prettyPrint))
  add(path_599156, "goalId", newJString(goalId))
  result = call_599155.call(path_599156, query_599157, nil, nil, body_599158)

var analyticsManagementGoalsUpdate* = Call_AnalyticsManagementGoalsUpdate_599139(
    name: "analyticsManagementGoalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsUpdate_599140,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsUpdate_599141,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsGet_599121 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementGoalsGet_599123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "goalId" in path, "`goalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals/"),
               (kind: VariableSegment, value: "goalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsGet_599122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a goal to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the goal for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the goal for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the goal for.
  ##   goalId: JString (required)
  ##         : Goal ID to retrieve the goal for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599124 = path.getOrDefault("profileId")
  valid_599124 = validateParameter(valid_599124, JString, required = true,
                                 default = nil)
  if valid_599124 != nil:
    section.add "profileId", valid_599124
  var valid_599125 = path.getOrDefault("accountId")
  valid_599125 = validateParameter(valid_599125, JString, required = true,
                                 default = nil)
  if valid_599125 != nil:
    section.add "accountId", valid_599125
  var valid_599126 = path.getOrDefault("webPropertyId")
  valid_599126 = validateParameter(valid_599126, JString, required = true,
                                 default = nil)
  if valid_599126 != nil:
    section.add "webPropertyId", valid_599126
  var valid_599127 = path.getOrDefault("goalId")
  valid_599127 = validateParameter(valid_599127, JString, required = true,
                                 default = nil)
  if valid_599127 != nil:
    section.add "goalId", valid_599127
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599128 = query.getOrDefault("fields")
  valid_599128 = validateParameter(valid_599128, JString, required = false,
                                 default = nil)
  if valid_599128 != nil:
    section.add "fields", valid_599128
  var valid_599129 = query.getOrDefault("quotaUser")
  valid_599129 = validateParameter(valid_599129, JString, required = false,
                                 default = nil)
  if valid_599129 != nil:
    section.add "quotaUser", valid_599129
  var valid_599130 = query.getOrDefault("alt")
  valid_599130 = validateParameter(valid_599130, JString, required = false,
                                 default = newJString("json"))
  if valid_599130 != nil:
    section.add "alt", valid_599130
  var valid_599131 = query.getOrDefault("oauth_token")
  valid_599131 = validateParameter(valid_599131, JString, required = false,
                                 default = nil)
  if valid_599131 != nil:
    section.add "oauth_token", valid_599131
  var valid_599132 = query.getOrDefault("userIp")
  valid_599132 = validateParameter(valid_599132, JString, required = false,
                                 default = nil)
  if valid_599132 != nil:
    section.add "userIp", valid_599132
  var valid_599133 = query.getOrDefault("key")
  valid_599133 = validateParameter(valid_599133, JString, required = false,
                                 default = nil)
  if valid_599133 != nil:
    section.add "key", valid_599133
  var valid_599134 = query.getOrDefault("prettyPrint")
  valid_599134 = validateParameter(valid_599134, JBool, required = false,
                                 default = newJBool(false))
  if valid_599134 != nil:
    section.add "prettyPrint", valid_599134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599135: Call_AnalyticsManagementGoalsGet_599121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a goal to which the user has access.
  ## 
  let valid = call_599135.validator(path, query, header, formData, body)
  let scheme = call_599135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599135.url(scheme.get, call_599135.host, call_599135.base,
                         call_599135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599135, url, valid)

proc call*(call_599136: Call_AnalyticsManagementGoalsGet_599121; profileId: string;
          accountId: string; webPropertyId: string; goalId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsGet
  ## Gets a goal to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the goal for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the goal for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the goal for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   goalId: string (required)
  ##         : Goal ID to retrieve the goal for.
  var path_599137 = newJObject()
  var query_599138 = newJObject()
  add(path_599137, "profileId", newJString(profileId))
  add(query_599138, "fields", newJString(fields))
  add(query_599138, "quotaUser", newJString(quotaUser))
  add(query_599138, "alt", newJString(alt))
  add(query_599138, "oauth_token", newJString(oauthToken))
  add(path_599137, "accountId", newJString(accountId))
  add(query_599138, "userIp", newJString(userIp))
  add(path_599137, "webPropertyId", newJString(webPropertyId))
  add(query_599138, "key", newJString(key))
  add(query_599138, "prettyPrint", newJBool(prettyPrint))
  add(path_599137, "goalId", newJString(goalId))
  result = call_599136.call(path_599137, query_599138, nil, nil, nil)

var analyticsManagementGoalsGet* = Call_AnalyticsManagementGoalsGet_599121(
    name: "analyticsManagementGoalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsGet_599122, base: "/analytics/v3",
    url: url_AnalyticsManagementGoalsGet_599123, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsPatch_599159 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementGoalsPatch_599161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "goalId" in path, "`goalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals/"),
               (kind: VariableSegment, value: "goalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsPatch_599160(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing goal. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to update the goal.
  ##   accountId: JString (required)
  ##            : Account ID to update the goal.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the goal.
  ##   goalId: JString (required)
  ##         : Index of the goal to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599162 = path.getOrDefault("profileId")
  valid_599162 = validateParameter(valid_599162, JString, required = true,
                                 default = nil)
  if valid_599162 != nil:
    section.add "profileId", valid_599162
  var valid_599163 = path.getOrDefault("accountId")
  valid_599163 = validateParameter(valid_599163, JString, required = true,
                                 default = nil)
  if valid_599163 != nil:
    section.add "accountId", valid_599163
  var valid_599164 = path.getOrDefault("webPropertyId")
  valid_599164 = validateParameter(valid_599164, JString, required = true,
                                 default = nil)
  if valid_599164 != nil:
    section.add "webPropertyId", valid_599164
  var valid_599165 = path.getOrDefault("goalId")
  valid_599165 = validateParameter(valid_599165, JString, required = true,
                                 default = nil)
  if valid_599165 != nil:
    section.add "goalId", valid_599165
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599166 = query.getOrDefault("fields")
  valid_599166 = validateParameter(valid_599166, JString, required = false,
                                 default = nil)
  if valid_599166 != nil:
    section.add "fields", valid_599166
  var valid_599167 = query.getOrDefault("quotaUser")
  valid_599167 = validateParameter(valid_599167, JString, required = false,
                                 default = nil)
  if valid_599167 != nil:
    section.add "quotaUser", valid_599167
  var valid_599168 = query.getOrDefault("alt")
  valid_599168 = validateParameter(valid_599168, JString, required = false,
                                 default = newJString("json"))
  if valid_599168 != nil:
    section.add "alt", valid_599168
  var valid_599169 = query.getOrDefault("oauth_token")
  valid_599169 = validateParameter(valid_599169, JString, required = false,
                                 default = nil)
  if valid_599169 != nil:
    section.add "oauth_token", valid_599169
  var valid_599170 = query.getOrDefault("userIp")
  valid_599170 = validateParameter(valid_599170, JString, required = false,
                                 default = nil)
  if valid_599170 != nil:
    section.add "userIp", valid_599170
  var valid_599171 = query.getOrDefault("key")
  valid_599171 = validateParameter(valid_599171, JString, required = false,
                                 default = nil)
  if valid_599171 != nil:
    section.add "key", valid_599171
  var valid_599172 = query.getOrDefault("prettyPrint")
  valid_599172 = validateParameter(valid_599172, JBool, required = false,
                                 default = newJBool(false))
  if valid_599172 != nil:
    section.add "prettyPrint", valid_599172
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

proc call*(call_599174: Call_AnalyticsManagementGoalsPatch_599159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal. This method supports patch semantics.
  ## 
  let valid = call_599174.validator(path, query, header, formData, body)
  let scheme = call_599174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599174.url(scheme.get, call_599174.host, call_599174.base,
                         call_599174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599174, url, valid)

proc call*(call_599175: Call_AnalyticsManagementGoalsPatch_599159;
          profileId: string; accountId: string; webPropertyId: string; goalId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsPatch
  ## Updates an existing goal. This method supports patch semantics.
  ##   profileId: string (required)
  ##            : View (Profile) ID to update the goal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the goal.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the goal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   goalId: string (required)
  ##         : Index of the goal to be updated.
  var path_599176 = newJObject()
  var query_599177 = newJObject()
  var body_599178 = newJObject()
  add(path_599176, "profileId", newJString(profileId))
  add(query_599177, "fields", newJString(fields))
  add(query_599177, "quotaUser", newJString(quotaUser))
  add(query_599177, "alt", newJString(alt))
  add(query_599177, "oauth_token", newJString(oauthToken))
  add(path_599176, "accountId", newJString(accountId))
  add(query_599177, "userIp", newJString(userIp))
  add(path_599176, "webPropertyId", newJString(webPropertyId))
  add(query_599177, "key", newJString(key))
  if body != nil:
    body_599178 = body
  add(query_599177, "prettyPrint", newJBool(prettyPrint))
  add(path_599176, "goalId", newJString(goalId))
  result = call_599175.call(path_599176, query_599177, nil, nil, body_599178)

var analyticsManagementGoalsPatch* = Call_AnalyticsManagementGoalsPatch_599159(
    name: "analyticsManagementGoalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsPatch_599160,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsPatch_599161,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksInsert_599198 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileFilterLinksInsert_599200(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/profileFilterLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksInsert_599199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to create filter link for.
  ##   accountId: JString (required)
  ##            : Account ID to create profile filter link for.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to create profile filter link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599201 = path.getOrDefault("profileId")
  valid_599201 = validateParameter(valid_599201, JString, required = true,
                                 default = nil)
  if valid_599201 != nil:
    section.add "profileId", valid_599201
  var valid_599202 = path.getOrDefault("accountId")
  valid_599202 = validateParameter(valid_599202, JString, required = true,
                                 default = nil)
  if valid_599202 != nil:
    section.add "accountId", valid_599202
  var valid_599203 = path.getOrDefault("webPropertyId")
  valid_599203 = validateParameter(valid_599203, JString, required = true,
                                 default = nil)
  if valid_599203 != nil:
    section.add "webPropertyId", valid_599203
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599204 = query.getOrDefault("fields")
  valid_599204 = validateParameter(valid_599204, JString, required = false,
                                 default = nil)
  if valid_599204 != nil:
    section.add "fields", valid_599204
  var valid_599205 = query.getOrDefault("quotaUser")
  valid_599205 = validateParameter(valid_599205, JString, required = false,
                                 default = nil)
  if valid_599205 != nil:
    section.add "quotaUser", valid_599205
  var valid_599206 = query.getOrDefault("alt")
  valid_599206 = validateParameter(valid_599206, JString, required = false,
                                 default = newJString("json"))
  if valid_599206 != nil:
    section.add "alt", valid_599206
  var valid_599207 = query.getOrDefault("oauth_token")
  valid_599207 = validateParameter(valid_599207, JString, required = false,
                                 default = nil)
  if valid_599207 != nil:
    section.add "oauth_token", valid_599207
  var valid_599208 = query.getOrDefault("userIp")
  valid_599208 = validateParameter(valid_599208, JString, required = false,
                                 default = nil)
  if valid_599208 != nil:
    section.add "userIp", valid_599208
  var valid_599209 = query.getOrDefault("key")
  valid_599209 = validateParameter(valid_599209, JString, required = false,
                                 default = nil)
  if valid_599209 != nil:
    section.add "key", valid_599209
  var valid_599210 = query.getOrDefault("prettyPrint")
  valid_599210 = validateParameter(valid_599210, JBool, required = false,
                                 default = newJBool(false))
  if valid_599210 != nil:
    section.add "prettyPrint", valid_599210
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

proc call*(call_599212: Call_AnalyticsManagementProfileFilterLinksInsert_599198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new profile filter link.
  ## 
  let valid = call_599212.validator(path, query, header, formData, body)
  let scheme = call_599212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599212.url(scheme.get, call_599212.host, call_599212.base,
                         call_599212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599212, url, valid)

proc call*(call_599213: Call_AnalyticsManagementProfileFilterLinksInsert_599198;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksInsert
  ## Create a new profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to create filter link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create profile filter link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to create profile filter link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599214 = newJObject()
  var query_599215 = newJObject()
  var body_599216 = newJObject()
  add(path_599214, "profileId", newJString(profileId))
  add(query_599215, "fields", newJString(fields))
  add(query_599215, "quotaUser", newJString(quotaUser))
  add(query_599215, "alt", newJString(alt))
  add(query_599215, "oauth_token", newJString(oauthToken))
  add(path_599214, "accountId", newJString(accountId))
  add(query_599215, "userIp", newJString(userIp))
  add(path_599214, "webPropertyId", newJString(webPropertyId))
  add(query_599215, "key", newJString(key))
  if body != nil:
    body_599216 = body
  add(query_599215, "prettyPrint", newJBool(prettyPrint))
  result = call_599213.call(path_599214, query_599215, nil, nil, body_599216)

var analyticsManagementProfileFilterLinksInsert* = Call_AnalyticsManagementProfileFilterLinksInsert_599198(
    name: "analyticsManagementProfileFilterLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksInsert_599199,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksInsert_599200,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksList_599179 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileFilterLinksList_599181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/profileFilterLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksList_599180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all profile filter links for a profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to retrieve filter links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve profile filter links for.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for profile filter links for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599182 = path.getOrDefault("profileId")
  valid_599182 = validateParameter(valid_599182, JString, required = true,
                                 default = nil)
  if valid_599182 != nil:
    section.add "profileId", valid_599182
  var valid_599183 = path.getOrDefault("accountId")
  valid_599183 = validateParameter(valid_599183, JString, required = true,
                                 default = nil)
  if valid_599183 != nil:
    section.add "accountId", valid_599183
  var valid_599184 = path.getOrDefault("webPropertyId")
  valid_599184 = validateParameter(valid_599184, JString, required = true,
                                 default = nil)
  if valid_599184 != nil:
    section.add "webPropertyId", valid_599184
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of profile filter links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599185 = query.getOrDefault("fields")
  valid_599185 = validateParameter(valid_599185, JString, required = false,
                                 default = nil)
  if valid_599185 != nil:
    section.add "fields", valid_599185
  var valid_599186 = query.getOrDefault("quotaUser")
  valid_599186 = validateParameter(valid_599186, JString, required = false,
                                 default = nil)
  if valid_599186 != nil:
    section.add "quotaUser", valid_599186
  var valid_599187 = query.getOrDefault("alt")
  valid_599187 = validateParameter(valid_599187, JString, required = false,
                                 default = newJString("json"))
  if valid_599187 != nil:
    section.add "alt", valid_599187
  var valid_599188 = query.getOrDefault("oauth_token")
  valid_599188 = validateParameter(valid_599188, JString, required = false,
                                 default = nil)
  if valid_599188 != nil:
    section.add "oauth_token", valid_599188
  var valid_599189 = query.getOrDefault("userIp")
  valid_599189 = validateParameter(valid_599189, JString, required = false,
                                 default = nil)
  if valid_599189 != nil:
    section.add "userIp", valid_599189
  var valid_599190 = query.getOrDefault("key")
  valid_599190 = validateParameter(valid_599190, JString, required = false,
                                 default = nil)
  if valid_599190 != nil:
    section.add "key", valid_599190
  var valid_599191 = query.getOrDefault("max-results")
  valid_599191 = validateParameter(valid_599191, JInt, required = false, default = nil)
  if valid_599191 != nil:
    section.add "max-results", valid_599191
  var valid_599192 = query.getOrDefault("start-index")
  valid_599192 = validateParameter(valid_599192, JInt, required = false, default = nil)
  if valid_599192 != nil:
    section.add "start-index", valid_599192
  var valid_599193 = query.getOrDefault("prettyPrint")
  valid_599193 = validateParameter(valid_599193, JBool, required = false,
                                 default = newJBool(false))
  if valid_599193 != nil:
    section.add "prettyPrint", valid_599193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599194: Call_AnalyticsManagementProfileFilterLinksList_599179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all profile filter links for a profile.
  ## 
  let valid = call_599194.validator(path, query, header, formData, body)
  let scheme = call_599194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599194.url(scheme.get, call_599194.host, call_599194.base,
                         call_599194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599194, url, valid)

proc call*(call_599195: Call_AnalyticsManagementProfileFilterLinksList_599179;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksList
  ## Lists all profile filter links for a profile.
  ##   profileId: string (required)
  ##            : Profile ID to retrieve filter links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve profile filter links for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for profile filter links for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of profile filter links to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599196 = newJObject()
  var query_599197 = newJObject()
  add(path_599196, "profileId", newJString(profileId))
  add(query_599197, "fields", newJString(fields))
  add(query_599197, "quotaUser", newJString(quotaUser))
  add(query_599197, "alt", newJString(alt))
  add(query_599197, "oauth_token", newJString(oauthToken))
  add(path_599196, "accountId", newJString(accountId))
  add(query_599197, "userIp", newJString(userIp))
  add(path_599196, "webPropertyId", newJString(webPropertyId))
  add(query_599197, "key", newJString(key))
  add(query_599197, "max-results", newJInt(maxResults))
  add(query_599197, "start-index", newJInt(startIndex))
  add(query_599197, "prettyPrint", newJBool(prettyPrint))
  result = call_599195.call(path_599196, query_599197, nil, nil, nil)

var analyticsManagementProfileFilterLinksList* = Call_AnalyticsManagementProfileFilterLinksList_599179(
    name: "analyticsManagementProfileFilterLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksList_599180,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksList_599181,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksUpdate_599235 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileFilterLinksUpdate_599237(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksUpdate_599236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to which filter link belongs
  ##   accountId: JString (required)
  ##            : Account ID to which profile filter link belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which profile filter link belongs
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599238 = path.getOrDefault("profileId")
  valid_599238 = validateParameter(valid_599238, JString, required = true,
                                 default = nil)
  if valid_599238 != nil:
    section.add "profileId", valid_599238
  var valid_599239 = path.getOrDefault("accountId")
  valid_599239 = validateParameter(valid_599239, JString, required = true,
                                 default = nil)
  if valid_599239 != nil:
    section.add "accountId", valid_599239
  var valid_599240 = path.getOrDefault("webPropertyId")
  valid_599240 = validateParameter(valid_599240, JString, required = true,
                                 default = nil)
  if valid_599240 != nil:
    section.add "webPropertyId", valid_599240
  var valid_599241 = path.getOrDefault("linkId")
  valid_599241 = validateParameter(valid_599241, JString, required = true,
                                 default = nil)
  if valid_599241 != nil:
    section.add "linkId", valid_599241
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599242 = query.getOrDefault("fields")
  valid_599242 = validateParameter(valid_599242, JString, required = false,
                                 default = nil)
  if valid_599242 != nil:
    section.add "fields", valid_599242
  var valid_599243 = query.getOrDefault("quotaUser")
  valid_599243 = validateParameter(valid_599243, JString, required = false,
                                 default = nil)
  if valid_599243 != nil:
    section.add "quotaUser", valid_599243
  var valid_599244 = query.getOrDefault("alt")
  valid_599244 = validateParameter(valid_599244, JString, required = false,
                                 default = newJString("json"))
  if valid_599244 != nil:
    section.add "alt", valid_599244
  var valid_599245 = query.getOrDefault("oauth_token")
  valid_599245 = validateParameter(valid_599245, JString, required = false,
                                 default = nil)
  if valid_599245 != nil:
    section.add "oauth_token", valid_599245
  var valid_599246 = query.getOrDefault("userIp")
  valid_599246 = validateParameter(valid_599246, JString, required = false,
                                 default = nil)
  if valid_599246 != nil:
    section.add "userIp", valid_599246
  var valid_599247 = query.getOrDefault("key")
  valid_599247 = validateParameter(valid_599247, JString, required = false,
                                 default = nil)
  if valid_599247 != nil:
    section.add "key", valid_599247
  var valid_599248 = query.getOrDefault("prettyPrint")
  valid_599248 = validateParameter(valid_599248, JBool, required = false,
                                 default = newJBool(false))
  if valid_599248 != nil:
    section.add "prettyPrint", valid_599248
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

proc call*(call_599250: Call_AnalyticsManagementProfileFilterLinksUpdate_599235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link.
  ## 
  let valid = call_599250.validator(path, query, header, formData, body)
  let scheme = call_599250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599250.url(scheme.get, call_599250.host, call_599250.base,
                         call_599250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599250, url, valid)

proc call*(call_599251: Call_AnalyticsManagementProfileFilterLinksUpdate_599235;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksUpdate
  ## Update an existing profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to which filter link belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which profile filter link belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which profile filter link belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599252 = newJObject()
  var query_599253 = newJObject()
  var body_599254 = newJObject()
  add(path_599252, "profileId", newJString(profileId))
  add(query_599253, "fields", newJString(fields))
  add(query_599253, "quotaUser", newJString(quotaUser))
  add(query_599253, "alt", newJString(alt))
  add(query_599253, "oauth_token", newJString(oauthToken))
  add(path_599252, "accountId", newJString(accountId))
  add(query_599253, "userIp", newJString(userIp))
  add(path_599252, "webPropertyId", newJString(webPropertyId))
  add(query_599253, "key", newJString(key))
  add(path_599252, "linkId", newJString(linkId))
  if body != nil:
    body_599254 = body
  add(query_599253, "prettyPrint", newJBool(prettyPrint))
  result = call_599251.call(path_599252, query_599253, nil, nil, body_599254)

var analyticsManagementProfileFilterLinksUpdate* = Call_AnalyticsManagementProfileFilterLinksUpdate_599235(
    name: "analyticsManagementProfileFilterLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksUpdate_599236,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksUpdate_599237,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksGet_599217 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileFilterLinksGet_599219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksGet_599218(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to retrieve filter link for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve profile filter link for.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to retrieve profile filter link for.
  ##   linkId: JString (required)
  ##         : ID of the profile filter link.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599220 = path.getOrDefault("profileId")
  valid_599220 = validateParameter(valid_599220, JString, required = true,
                                 default = nil)
  if valid_599220 != nil:
    section.add "profileId", valid_599220
  var valid_599221 = path.getOrDefault("accountId")
  valid_599221 = validateParameter(valid_599221, JString, required = true,
                                 default = nil)
  if valid_599221 != nil:
    section.add "accountId", valid_599221
  var valid_599222 = path.getOrDefault("webPropertyId")
  valid_599222 = validateParameter(valid_599222, JString, required = true,
                                 default = nil)
  if valid_599222 != nil:
    section.add "webPropertyId", valid_599222
  var valid_599223 = path.getOrDefault("linkId")
  valid_599223 = validateParameter(valid_599223, JString, required = true,
                                 default = nil)
  if valid_599223 != nil:
    section.add "linkId", valid_599223
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599224 = query.getOrDefault("fields")
  valid_599224 = validateParameter(valid_599224, JString, required = false,
                                 default = nil)
  if valid_599224 != nil:
    section.add "fields", valid_599224
  var valid_599225 = query.getOrDefault("quotaUser")
  valid_599225 = validateParameter(valid_599225, JString, required = false,
                                 default = nil)
  if valid_599225 != nil:
    section.add "quotaUser", valid_599225
  var valid_599226 = query.getOrDefault("alt")
  valid_599226 = validateParameter(valid_599226, JString, required = false,
                                 default = newJString("json"))
  if valid_599226 != nil:
    section.add "alt", valid_599226
  var valid_599227 = query.getOrDefault("oauth_token")
  valid_599227 = validateParameter(valid_599227, JString, required = false,
                                 default = nil)
  if valid_599227 != nil:
    section.add "oauth_token", valid_599227
  var valid_599228 = query.getOrDefault("userIp")
  valid_599228 = validateParameter(valid_599228, JString, required = false,
                                 default = nil)
  if valid_599228 != nil:
    section.add "userIp", valid_599228
  var valid_599229 = query.getOrDefault("key")
  valid_599229 = validateParameter(valid_599229, JString, required = false,
                                 default = nil)
  if valid_599229 != nil:
    section.add "key", valid_599229
  var valid_599230 = query.getOrDefault("prettyPrint")
  valid_599230 = validateParameter(valid_599230, JBool, required = false,
                                 default = newJBool(false))
  if valid_599230 != nil:
    section.add "prettyPrint", valid_599230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599231: Call_AnalyticsManagementProfileFilterLinksGet_599217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single profile filter link.
  ## 
  let valid = call_599231.validator(path, query, header, formData, body)
  let scheme = call_599231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599231.url(scheme.get, call_599231.host, call_599231.base,
                         call_599231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599231, url, valid)

proc call*(call_599232: Call_AnalyticsManagementProfileFilterLinksGet_599217;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksGet
  ## Returns a single profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to retrieve filter link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve profile filter link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to retrieve profile filter link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599233 = newJObject()
  var query_599234 = newJObject()
  add(path_599233, "profileId", newJString(profileId))
  add(query_599234, "fields", newJString(fields))
  add(query_599234, "quotaUser", newJString(quotaUser))
  add(query_599234, "alt", newJString(alt))
  add(query_599234, "oauth_token", newJString(oauthToken))
  add(path_599233, "accountId", newJString(accountId))
  add(query_599234, "userIp", newJString(userIp))
  add(path_599233, "webPropertyId", newJString(webPropertyId))
  add(query_599234, "key", newJString(key))
  add(path_599233, "linkId", newJString(linkId))
  add(query_599234, "prettyPrint", newJBool(prettyPrint))
  result = call_599232.call(path_599233, query_599234, nil, nil, nil)

var analyticsManagementProfileFilterLinksGet* = Call_AnalyticsManagementProfileFilterLinksGet_599217(
    name: "analyticsManagementProfileFilterLinksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksGet_599218,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksGet_599219,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksPatch_599273 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileFilterLinksPatch_599275(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksPatch_599274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing profile filter link. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to which filter link belongs
  ##   accountId: JString (required)
  ##            : Account ID to which profile filter link belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which profile filter link belongs
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599276 = path.getOrDefault("profileId")
  valid_599276 = validateParameter(valid_599276, JString, required = true,
                                 default = nil)
  if valid_599276 != nil:
    section.add "profileId", valid_599276
  var valid_599277 = path.getOrDefault("accountId")
  valid_599277 = validateParameter(valid_599277, JString, required = true,
                                 default = nil)
  if valid_599277 != nil:
    section.add "accountId", valid_599277
  var valid_599278 = path.getOrDefault("webPropertyId")
  valid_599278 = validateParameter(valid_599278, JString, required = true,
                                 default = nil)
  if valid_599278 != nil:
    section.add "webPropertyId", valid_599278
  var valid_599279 = path.getOrDefault("linkId")
  valid_599279 = validateParameter(valid_599279, JString, required = true,
                                 default = nil)
  if valid_599279 != nil:
    section.add "linkId", valid_599279
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599280 = query.getOrDefault("fields")
  valid_599280 = validateParameter(valid_599280, JString, required = false,
                                 default = nil)
  if valid_599280 != nil:
    section.add "fields", valid_599280
  var valid_599281 = query.getOrDefault("quotaUser")
  valid_599281 = validateParameter(valid_599281, JString, required = false,
                                 default = nil)
  if valid_599281 != nil:
    section.add "quotaUser", valid_599281
  var valid_599282 = query.getOrDefault("alt")
  valid_599282 = validateParameter(valid_599282, JString, required = false,
                                 default = newJString("json"))
  if valid_599282 != nil:
    section.add "alt", valid_599282
  var valid_599283 = query.getOrDefault("oauth_token")
  valid_599283 = validateParameter(valid_599283, JString, required = false,
                                 default = nil)
  if valid_599283 != nil:
    section.add "oauth_token", valid_599283
  var valid_599284 = query.getOrDefault("userIp")
  valid_599284 = validateParameter(valid_599284, JString, required = false,
                                 default = nil)
  if valid_599284 != nil:
    section.add "userIp", valid_599284
  var valid_599285 = query.getOrDefault("key")
  valid_599285 = validateParameter(valid_599285, JString, required = false,
                                 default = nil)
  if valid_599285 != nil:
    section.add "key", valid_599285
  var valid_599286 = query.getOrDefault("prettyPrint")
  valid_599286 = validateParameter(valid_599286, JBool, required = false,
                                 default = newJBool(false))
  if valid_599286 != nil:
    section.add "prettyPrint", valid_599286
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

proc call*(call_599288: Call_AnalyticsManagementProfileFilterLinksPatch_599273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link. This method supports patch semantics.
  ## 
  let valid = call_599288.validator(path, query, header, formData, body)
  let scheme = call_599288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599288.url(scheme.get, call_599288.host, call_599288.base,
                         call_599288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599288, url, valid)

proc call*(call_599289: Call_AnalyticsManagementProfileFilterLinksPatch_599273;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksPatch
  ## Update an existing profile filter link. This method supports patch semantics.
  ##   profileId: string (required)
  ##            : Profile ID to which filter link belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which profile filter link belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which profile filter link belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599290 = newJObject()
  var query_599291 = newJObject()
  var body_599292 = newJObject()
  add(path_599290, "profileId", newJString(profileId))
  add(query_599291, "fields", newJString(fields))
  add(query_599291, "quotaUser", newJString(quotaUser))
  add(query_599291, "alt", newJString(alt))
  add(query_599291, "oauth_token", newJString(oauthToken))
  add(path_599290, "accountId", newJString(accountId))
  add(query_599291, "userIp", newJString(userIp))
  add(path_599290, "webPropertyId", newJString(webPropertyId))
  add(query_599291, "key", newJString(key))
  add(path_599290, "linkId", newJString(linkId))
  if body != nil:
    body_599292 = body
  add(query_599291, "prettyPrint", newJBool(prettyPrint))
  result = call_599289.call(path_599290, query_599291, nil, nil, body_599292)

var analyticsManagementProfileFilterLinksPatch* = Call_AnalyticsManagementProfileFilterLinksPatch_599273(
    name: "analyticsManagementProfileFilterLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksPatch_599274,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksPatch_599275,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksDelete_599255 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementProfileFilterLinksDelete_599257(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksDelete_599256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to which the filter link belongs.
  ##   accountId: JString (required)
  ##            : Account ID to which the profile filter link belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which the profile filter link belongs.
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599258 = path.getOrDefault("profileId")
  valid_599258 = validateParameter(valid_599258, JString, required = true,
                                 default = nil)
  if valid_599258 != nil:
    section.add "profileId", valid_599258
  var valid_599259 = path.getOrDefault("accountId")
  valid_599259 = validateParameter(valid_599259, JString, required = true,
                                 default = nil)
  if valid_599259 != nil:
    section.add "accountId", valid_599259
  var valid_599260 = path.getOrDefault("webPropertyId")
  valid_599260 = validateParameter(valid_599260, JString, required = true,
                                 default = nil)
  if valid_599260 != nil:
    section.add "webPropertyId", valid_599260
  var valid_599261 = path.getOrDefault("linkId")
  valid_599261 = validateParameter(valid_599261, JString, required = true,
                                 default = nil)
  if valid_599261 != nil:
    section.add "linkId", valid_599261
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599262 = query.getOrDefault("fields")
  valid_599262 = validateParameter(valid_599262, JString, required = false,
                                 default = nil)
  if valid_599262 != nil:
    section.add "fields", valid_599262
  var valid_599263 = query.getOrDefault("quotaUser")
  valid_599263 = validateParameter(valid_599263, JString, required = false,
                                 default = nil)
  if valid_599263 != nil:
    section.add "quotaUser", valid_599263
  var valid_599264 = query.getOrDefault("alt")
  valid_599264 = validateParameter(valid_599264, JString, required = false,
                                 default = newJString("json"))
  if valid_599264 != nil:
    section.add "alt", valid_599264
  var valid_599265 = query.getOrDefault("oauth_token")
  valid_599265 = validateParameter(valid_599265, JString, required = false,
                                 default = nil)
  if valid_599265 != nil:
    section.add "oauth_token", valid_599265
  var valid_599266 = query.getOrDefault("userIp")
  valid_599266 = validateParameter(valid_599266, JString, required = false,
                                 default = nil)
  if valid_599266 != nil:
    section.add "userIp", valid_599266
  var valid_599267 = query.getOrDefault("key")
  valid_599267 = validateParameter(valid_599267, JString, required = false,
                                 default = nil)
  if valid_599267 != nil:
    section.add "key", valid_599267
  var valid_599268 = query.getOrDefault("prettyPrint")
  valid_599268 = validateParameter(valid_599268, JBool, required = false,
                                 default = newJBool(false))
  if valid_599268 != nil:
    section.add "prettyPrint", valid_599268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599269: Call_AnalyticsManagementProfileFilterLinksDelete_599255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a profile filter link.
  ## 
  let valid = call_599269.validator(path, query, header, formData, body)
  let scheme = call_599269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599269.url(scheme.get, call_599269.host, call_599269.base,
                         call_599269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599269, url, valid)

proc call*(call_599270: Call_AnalyticsManagementProfileFilterLinksDelete_599255;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksDelete
  ## Delete a profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to which the filter link belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the profile filter link belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which the profile filter link belongs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599271 = newJObject()
  var query_599272 = newJObject()
  add(path_599271, "profileId", newJString(profileId))
  add(query_599272, "fields", newJString(fields))
  add(query_599272, "quotaUser", newJString(quotaUser))
  add(query_599272, "alt", newJString(alt))
  add(query_599272, "oauth_token", newJString(oauthToken))
  add(path_599271, "accountId", newJString(accountId))
  add(query_599272, "userIp", newJString(userIp))
  add(path_599271, "webPropertyId", newJString(webPropertyId))
  add(query_599272, "key", newJString(key))
  add(path_599271, "linkId", newJString(linkId))
  add(query_599272, "prettyPrint", newJBool(prettyPrint))
  result = call_599270.call(path_599271, query_599272, nil, nil, nil)

var analyticsManagementProfileFilterLinksDelete* = Call_AnalyticsManagementProfileFilterLinksDelete_599255(
    name: "analyticsManagementProfileFilterLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksDelete_599256,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksDelete_599257,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsInsert_599312 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUnsampledReportsInsert_599314(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/unsampledReports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsInsert_599313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the unsampled report for.
  ##   accountId: JString (required)
  ##            : Account ID to create the unsampled report for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the unsampled report for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599315 = path.getOrDefault("profileId")
  valid_599315 = validateParameter(valid_599315, JString, required = true,
                                 default = nil)
  if valid_599315 != nil:
    section.add "profileId", valid_599315
  var valid_599316 = path.getOrDefault("accountId")
  valid_599316 = validateParameter(valid_599316, JString, required = true,
                                 default = nil)
  if valid_599316 != nil:
    section.add "accountId", valid_599316
  var valid_599317 = path.getOrDefault("webPropertyId")
  valid_599317 = validateParameter(valid_599317, JString, required = true,
                                 default = nil)
  if valid_599317 != nil:
    section.add "webPropertyId", valid_599317
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599318 = query.getOrDefault("fields")
  valid_599318 = validateParameter(valid_599318, JString, required = false,
                                 default = nil)
  if valid_599318 != nil:
    section.add "fields", valid_599318
  var valid_599319 = query.getOrDefault("quotaUser")
  valid_599319 = validateParameter(valid_599319, JString, required = false,
                                 default = nil)
  if valid_599319 != nil:
    section.add "quotaUser", valid_599319
  var valid_599320 = query.getOrDefault("alt")
  valid_599320 = validateParameter(valid_599320, JString, required = false,
                                 default = newJString("json"))
  if valid_599320 != nil:
    section.add "alt", valid_599320
  var valid_599321 = query.getOrDefault("oauth_token")
  valid_599321 = validateParameter(valid_599321, JString, required = false,
                                 default = nil)
  if valid_599321 != nil:
    section.add "oauth_token", valid_599321
  var valid_599322 = query.getOrDefault("userIp")
  valid_599322 = validateParameter(valid_599322, JString, required = false,
                                 default = nil)
  if valid_599322 != nil:
    section.add "userIp", valid_599322
  var valid_599323 = query.getOrDefault("key")
  valid_599323 = validateParameter(valid_599323, JString, required = false,
                                 default = nil)
  if valid_599323 != nil:
    section.add "key", valid_599323
  var valid_599324 = query.getOrDefault("prettyPrint")
  valid_599324 = validateParameter(valid_599324, JBool, required = false,
                                 default = newJBool(false))
  if valid_599324 != nil:
    section.add "prettyPrint", valid_599324
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

proc call*(call_599326: Call_AnalyticsManagementUnsampledReportsInsert_599312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new unsampled report.
  ## 
  let valid = call_599326.validator(path, query, header, formData, body)
  let scheme = call_599326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599326.url(scheme.get, call_599326.host, call_599326.base,
                         call_599326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599326, url, valid)

proc call*(call_599327: Call_AnalyticsManagementUnsampledReportsInsert_599312;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsInsert
  ## Create a new unsampled report.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the unsampled report for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the unsampled report for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599328 = newJObject()
  var query_599329 = newJObject()
  var body_599330 = newJObject()
  add(path_599328, "profileId", newJString(profileId))
  add(query_599329, "fields", newJString(fields))
  add(query_599329, "quotaUser", newJString(quotaUser))
  add(query_599329, "alt", newJString(alt))
  add(query_599329, "oauth_token", newJString(oauthToken))
  add(path_599328, "accountId", newJString(accountId))
  add(query_599329, "userIp", newJString(userIp))
  add(path_599328, "webPropertyId", newJString(webPropertyId))
  add(query_599329, "key", newJString(key))
  if body != nil:
    body_599330 = body
  add(query_599329, "prettyPrint", newJBool(prettyPrint))
  result = call_599327.call(path_599328, query_599329, nil, nil, body_599330)

var analyticsManagementUnsampledReportsInsert* = Call_AnalyticsManagementUnsampledReportsInsert_599312(
    name: "analyticsManagementUnsampledReportsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsInsert_599313,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsInsert_599314,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsList_599293 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUnsampledReportsList_599295(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
               (kind: ConstantSegment, value: "/unsampledReports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsList_599294(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists unsampled reports to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599296 = path.getOrDefault("profileId")
  valid_599296 = validateParameter(valid_599296, JString, required = true,
                                 default = nil)
  if valid_599296 != nil:
    section.add "profileId", valid_599296
  var valid_599297 = path.getOrDefault("accountId")
  valid_599297 = validateParameter(valid_599297, JString, required = true,
                                 default = nil)
  if valid_599297 != nil:
    section.add "accountId", valid_599297
  var valid_599298 = path.getOrDefault("webPropertyId")
  valid_599298 = validateParameter(valid_599298, JString, required = true,
                                 default = nil)
  if valid_599298 != nil:
    section.add "webPropertyId", valid_599298
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of unsampled reports to include in this response.
  ##   start-index: JInt
  ##              : An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599299 = query.getOrDefault("fields")
  valid_599299 = validateParameter(valid_599299, JString, required = false,
                                 default = nil)
  if valid_599299 != nil:
    section.add "fields", valid_599299
  var valid_599300 = query.getOrDefault("quotaUser")
  valid_599300 = validateParameter(valid_599300, JString, required = false,
                                 default = nil)
  if valid_599300 != nil:
    section.add "quotaUser", valid_599300
  var valid_599301 = query.getOrDefault("alt")
  valid_599301 = validateParameter(valid_599301, JString, required = false,
                                 default = newJString("json"))
  if valid_599301 != nil:
    section.add "alt", valid_599301
  var valid_599302 = query.getOrDefault("oauth_token")
  valid_599302 = validateParameter(valid_599302, JString, required = false,
                                 default = nil)
  if valid_599302 != nil:
    section.add "oauth_token", valid_599302
  var valid_599303 = query.getOrDefault("userIp")
  valid_599303 = validateParameter(valid_599303, JString, required = false,
                                 default = nil)
  if valid_599303 != nil:
    section.add "userIp", valid_599303
  var valid_599304 = query.getOrDefault("key")
  valid_599304 = validateParameter(valid_599304, JString, required = false,
                                 default = nil)
  if valid_599304 != nil:
    section.add "key", valid_599304
  var valid_599305 = query.getOrDefault("max-results")
  valid_599305 = validateParameter(valid_599305, JInt, required = false, default = nil)
  if valid_599305 != nil:
    section.add "max-results", valid_599305
  var valid_599306 = query.getOrDefault("start-index")
  valid_599306 = validateParameter(valid_599306, JInt, required = false, default = nil)
  if valid_599306 != nil:
    section.add "start-index", valid_599306
  var valid_599307 = query.getOrDefault("prettyPrint")
  valid_599307 = validateParameter(valid_599307, JBool, required = false,
                                 default = newJBool(false))
  if valid_599307 != nil:
    section.add "prettyPrint", valid_599307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599308: Call_AnalyticsManagementUnsampledReportsList_599293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unsampled reports to which the user has access.
  ## 
  let valid = call_599308.validator(path, query, header, formData, body)
  let scheme = call_599308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599308.url(scheme.get, call_599308.host, call_599308.base,
                         call_599308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599308, url, valid)

proc call*(call_599309: Call_AnalyticsManagementUnsampledReportsList_599293;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsList
  ## Lists unsampled reports to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of unsampled reports to include in this response.
  ##   startIndex: int
  ##             : An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599310 = newJObject()
  var query_599311 = newJObject()
  add(path_599310, "profileId", newJString(profileId))
  add(query_599311, "fields", newJString(fields))
  add(query_599311, "quotaUser", newJString(quotaUser))
  add(query_599311, "alt", newJString(alt))
  add(query_599311, "oauth_token", newJString(oauthToken))
  add(path_599310, "accountId", newJString(accountId))
  add(query_599311, "userIp", newJString(userIp))
  add(path_599310, "webPropertyId", newJString(webPropertyId))
  add(query_599311, "key", newJString(key))
  add(query_599311, "max-results", newJInt(maxResults))
  add(query_599311, "start-index", newJInt(startIndex))
  add(query_599311, "prettyPrint", newJBool(prettyPrint))
  result = call_599309.call(path_599310, query_599311, nil, nil, nil)

var analyticsManagementUnsampledReportsList* = Call_AnalyticsManagementUnsampledReportsList_599293(
    name: "analyticsManagementUnsampledReportsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsList_599294,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsList_599295,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsGet_599331 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUnsampledReportsGet_599333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "unsampledReportId" in path,
        "`unsampledReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/unsampledReports/"),
               (kind: VariableSegment, value: "unsampledReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsGet_599332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve unsampled report for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve unsampled report for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve unsampled reports for.
  ##   unsampledReportId: JString (required)
  ##                    : ID of the unsampled report to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599334 = path.getOrDefault("profileId")
  valid_599334 = validateParameter(valid_599334, JString, required = true,
                                 default = nil)
  if valid_599334 != nil:
    section.add "profileId", valid_599334
  var valid_599335 = path.getOrDefault("accountId")
  valid_599335 = validateParameter(valid_599335, JString, required = true,
                                 default = nil)
  if valid_599335 != nil:
    section.add "accountId", valid_599335
  var valid_599336 = path.getOrDefault("webPropertyId")
  valid_599336 = validateParameter(valid_599336, JString, required = true,
                                 default = nil)
  if valid_599336 != nil:
    section.add "webPropertyId", valid_599336
  var valid_599337 = path.getOrDefault("unsampledReportId")
  valid_599337 = validateParameter(valid_599337, JString, required = true,
                                 default = nil)
  if valid_599337 != nil:
    section.add "unsampledReportId", valid_599337
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599338 = query.getOrDefault("fields")
  valid_599338 = validateParameter(valid_599338, JString, required = false,
                                 default = nil)
  if valid_599338 != nil:
    section.add "fields", valid_599338
  var valid_599339 = query.getOrDefault("quotaUser")
  valid_599339 = validateParameter(valid_599339, JString, required = false,
                                 default = nil)
  if valid_599339 != nil:
    section.add "quotaUser", valid_599339
  var valid_599340 = query.getOrDefault("alt")
  valid_599340 = validateParameter(valid_599340, JString, required = false,
                                 default = newJString("json"))
  if valid_599340 != nil:
    section.add "alt", valid_599340
  var valid_599341 = query.getOrDefault("oauth_token")
  valid_599341 = validateParameter(valid_599341, JString, required = false,
                                 default = nil)
  if valid_599341 != nil:
    section.add "oauth_token", valid_599341
  var valid_599342 = query.getOrDefault("userIp")
  valid_599342 = validateParameter(valid_599342, JString, required = false,
                                 default = nil)
  if valid_599342 != nil:
    section.add "userIp", valid_599342
  var valid_599343 = query.getOrDefault("key")
  valid_599343 = validateParameter(valid_599343, JString, required = false,
                                 default = nil)
  if valid_599343 != nil:
    section.add "key", valid_599343
  var valid_599344 = query.getOrDefault("prettyPrint")
  valid_599344 = validateParameter(valid_599344, JBool, required = false,
                                 default = newJBool(false))
  if valid_599344 != nil:
    section.add "prettyPrint", valid_599344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599345: Call_AnalyticsManagementUnsampledReportsGet_599331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single unsampled report.
  ## 
  let valid = call_599345.validator(path, query, header, formData, body)
  let scheme = call_599345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599345.url(scheme.get, call_599345.host, call_599345.base,
                         call_599345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599345, url, valid)

proc call*(call_599346: Call_AnalyticsManagementUnsampledReportsGet_599331;
          profileId: string; accountId: string; webPropertyId: string;
          unsampledReportId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsGet
  ## Returns a single unsampled report.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve unsampled report for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve unsampled reports for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   unsampledReportId: string (required)
  ##                    : ID of the unsampled report to retrieve.
  var path_599347 = newJObject()
  var query_599348 = newJObject()
  add(path_599347, "profileId", newJString(profileId))
  add(query_599348, "fields", newJString(fields))
  add(query_599348, "quotaUser", newJString(quotaUser))
  add(query_599348, "alt", newJString(alt))
  add(query_599348, "oauth_token", newJString(oauthToken))
  add(path_599347, "accountId", newJString(accountId))
  add(query_599348, "userIp", newJString(userIp))
  add(path_599347, "webPropertyId", newJString(webPropertyId))
  add(query_599348, "key", newJString(key))
  add(query_599348, "prettyPrint", newJBool(prettyPrint))
  add(path_599347, "unsampledReportId", newJString(unsampledReportId))
  result = call_599346.call(path_599347, query_599348, nil, nil, nil)

var analyticsManagementUnsampledReportsGet* = Call_AnalyticsManagementUnsampledReportsGet_599331(
    name: "analyticsManagementUnsampledReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsGet_599332,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsGet_599333,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsDelete_599349 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementUnsampledReportsDelete_599351(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "unsampledReportId" in path,
        "`unsampledReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/unsampledReports/"),
               (kind: VariableSegment, value: "unsampledReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsDelete_599350(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to delete the unsampled report for.
  ##   accountId: JString (required)
  ##            : Account ID to delete the unsampled report for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the unsampled reports for.
  ##   unsampledReportId: JString (required)
  ##                    : ID of the unsampled report to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_599352 = path.getOrDefault("profileId")
  valid_599352 = validateParameter(valid_599352, JString, required = true,
                                 default = nil)
  if valid_599352 != nil:
    section.add "profileId", valid_599352
  var valid_599353 = path.getOrDefault("accountId")
  valid_599353 = validateParameter(valid_599353, JString, required = true,
                                 default = nil)
  if valid_599353 != nil:
    section.add "accountId", valid_599353
  var valid_599354 = path.getOrDefault("webPropertyId")
  valid_599354 = validateParameter(valid_599354, JString, required = true,
                                 default = nil)
  if valid_599354 != nil:
    section.add "webPropertyId", valid_599354
  var valid_599355 = path.getOrDefault("unsampledReportId")
  valid_599355 = validateParameter(valid_599355, JString, required = true,
                                 default = nil)
  if valid_599355 != nil:
    section.add "unsampledReportId", valid_599355
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599356 = query.getOrDefault("fields")
  valid_599356 = validateParameter(valid_599356, JString, required = false,
                                 default = nil)
  if valid_599356 != nil:
    section.add "fields", valid_599356
  var valid_599357 = query.getOrDefault("quotaUser")
  valid_599357 = validateParameter(valid_599357, JString, required = false,
                                 default = nil)
  if valid_599357 != nil:
    section.add "quotaUser", valid_599357
  var valid_599358 = query.getOrDefault("alt")
  valid_599358 = validateParameter(valid_599358, JString, required = false,
                                 default = newJString("json"))
  if valid_599358 != nil:
    section.add "alt", valid_599358
  var valid_599359 = query.getOrDefault("oauth_token")
  valid_599359 = validateParameter(valid_599359, JString, required = false,
                                 default = nil)
  if valid_599359 != nil:
    section.add "oauth_token", valid_599359
  var valid_599360 = query.getOrDefault("userIp")
  valid_599360 = validateParameter(valid_599360, JString, required = false,
                                 default = nil)
  if valid_599360 != nil:
    section.add "userIp", valid_599360
  var valid_599361 = query.getOrDefault("key")
  valid_599361 = validateParameter(valid_599361, JString, required = false,
                                 default = nil)
  if valid_599361 != nil:
    section.add "key", valid_599361
  var valid_599362 = query.getOrDefault("prettyPrint")
  valid_599362 = validateParameter(valid_599362, JBool, required = false,
                                 default = newJBool(false))
  if valid_599362 != nil:
    section.add "prettyPrint", valid_599362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599363: Call_AnalyticsManagementUnsampledReportsDelete_599349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unsampled report.
  ## 
  let valid = call_599363.validator(path, query, header, formData, body)
  let scheme = call_599363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599363.url(scheme.get, call_599363.host, call_599363.base,
                         call_599363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599363, url, valid)

proc call*(call_599364: Call_AnalyticsManagementUnsampledReportsDelete_599349;
          profileId: string; accountId: string; webPropertyId: string;
          unsampledReportId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsDelete
  ## Deletes an unsampled report.
  ##   profileId: string (required)
  ##            : View (Profile) ID to delete the unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the unsampled report for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the unsampled reports for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   unsampledReportId: string (required)
  ##                    : ID of the unsampled report to be deleted.
  var path_599365 = newJObject()
  var query_599366 = newJObject()
  add(path_599365, "profileId", newJString(profileId))
  add(query_599366, "fields", newJString(fields))
  add(query_599366, "quotaUser", newJString(quotaUser))
  add(query_599366, "alt", newJString(alt))
  add(query_599366, "oauth_token", newJString(oauthToken))
  add(path_599365, "accountId", newJString(accountId))
  add(query_599366, "userIp", newJString(userIp))
  add(path_599365, "webPropertyId", newJString(webPropertyId))
  add(query_599366, "key", newJString(key))
  add(query_599366, "prettyPrint", newJBool(prettyPrint))
  add(path_599365, "unsampledReportId", newJString(unsampledReportId))
  result = call_599364.call(path_599365, query_599366, nil, nil, nil)

var analyticsManagementUnsampledReportsDelete* = Call_AnalyticsManagementUnsampledReportsDelete_599349(
    name: "analyticsManagementUnsampledReportsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsDelete_599350,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsDelete_599351,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceInsert_599386 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementRemarketingAudienceInsert_599388(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceInsert_599387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID for which to create the remarketing audience.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for which to create the remarketing audience.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_599389 = path.getOrDefault("accountId")
  valid_599389 = validateParameter(valid_599389, JString, required = true,
                                 default = nil)
  if valid_599389 != nil:
    section.add "accountId", valid_599389
  var valid_599390 = path.getOrDefault("webPropertyId")
  valid_599390 = validateParameter(valid_599390, JString, required = true,
                                 default = nil)
  if valid_599390 != nil:
    section.add "webPropertyId", valid_599390
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599391 = query.getOrDefault("fields")
  valid_599391 = validateParameter(valid_599391, JString, required = false,
                                 default = nil)
  if valid_599391 != nil:
    section.add "fields", valid_599391
  var valid_599392 = query.getOrDefault("quotaUser")
  valid_599392 = validateParameter(valid_599392, JString, required = false,
                                 default = nil)
  if valid_599392 != nil:
    section.add "quotaUser", valid_599392
  var valid_599393 = query.getOrDefault("alt")
  valid_599393 = validateParameter(valid_599393, JString, required = false,
                                 default = newJString("json"))
  if valid_599393 != nil:
    section.add "alt", valid_599393
  var valid_599394 = query.getOrDefault("oauth_token")
  valid_599394 = validateParameter(valid_599394, JString, required = false,
                                 default = nil)
  if valid_599394 != nil:
    section.add "oauth_token", valid_599394
  var valid_599395 = query.getOrDefault("userIp")
  valid_599395 = validateParameter(valid_599395, JString, required = false,
                                 default = nil)
  if valid_599395 != nil:
    section.add "userIp", valid_599395
  var valid_599396 = query.getOrDefault("key")
  valid_599396 = validateParameter(valid_599396, JString, required = false,
                                 default = nil)
  if valid_599396 != nil:
    section.add "key", valid_599396
  var valid_599397 = query.getOrDefault("prettyPrint")
  valid_599397 = validateParameter(valid_599397, JBool, required = false,
                                 default = newJBool(false))
  if valid_599397 != nil:
    section.add "prettyPrint", valid_599397
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

proc call*(call_599399: Call_AnalyticsManagementRemarketingAudienceInsert_599386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new remarketing audience.
  ## 
  let valid = call_599399.validator(path, query, header, formData, body)
  let scheme = call_599399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599399.url(scheme.get, call_599399.host, call_599399.base,
                         call_599399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599399, url, valid)

proc call*(call_599400: Call_AnalyticsManagementRemarketingAudienceInsert_599386;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceInsert
  ## Creates a new remarketing audience.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID for which to create the remarketing audience.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for which to create the remarketing audience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599401 = newJObject()
  var query_599402 = newJObject()
  var body_599403 = newJObject()
  add(query_599402, "fields", newJString(fields))
  add(query_599402, "quotaUser", newJString(quotaUser))
  add(query_599402, "alt", newJString(alt))
  add(query_599402, "oauth_token", newJString(oauthToken))
  add(path_599401, "accountId", newJString(accountId))
  add(query_599402, "userIp", newJString(userIp))
  add(path_599401, "webPropertyId", newJString(webPropertyId))
  add(query_599402, "key", newJString(key))
  if body != nil:
    body_599403 = body
  add(query_599402, "prettyPrint", newJBool(prettyPrint))
  result = call_599400.call(path_599401, query_599402, nil, nil, body_599403)

var analyticsManagementRemarketingAudienceInsert* = Call_AnalyticsManagementRemarketingAudienceInsert_599386(
    name: "analyticsManagementRemarketingAudienceInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceInsert_599387,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceInsert_599388,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceList_599367 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementRemarketingAudienceList_599369(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceList_599368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists remarketing audiences to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audiences to retrieve.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audiences to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_599370 = path.getOrDefault("accountId")
  valid_599370 = validateParameter(valid_599370, JString, required = true,
                                 default = nil)
  if valid_599370 != nil:
    section.add "accountId", valid_599370
  var valid_599371 = path.getOrDefault("webPropertyId")
  valid_599371 = validateParameter(valid_599371, JString, required = true,
                                 default = nil)
  if valid_599371 != nil:
    section.add "webPropertyId", valid_599371
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   type: JString
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of remarketing audiences to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599372 = query.getOrDefault("fields")
  valid_599372 = validateParameter(valid_599372, JString, required = false,
                                 default = nil)
  if valid_599372 != nil:
    section.add "fields", valid_599372
  var valid_599373 = query.getOrDefault("quotaUser")
  valid_599373 = validateParameter(valid_599373, JString, required = false,
                                 default = nil)
  if valid_599373 != nil:
    section.add "quotaUser", valid_599373
  var valid_599374 = query.getOrDefault("alt")
  valid_599374 = validateParameter(valid_599374, JString, required = false,
                                 default = newJString("json"))
  if valid_599374 != nil:
    section.add "alt", valid_599374
  var valid_599375 = query.getOrDefault("type")
  valid_599375 = validateParameter(valid_599375, JString, required = false,
                                 default = newJString("all"))
  if valid_599375 != nil:
    section.add "type", valid_599375
  var valid_599376 = query.getOrDefault("oauth_token")
  valid_599376 = validateParameter(valid_599376, JString, required = false,
                                 default = nil)
  if valid_599376 != nil:
    section.add "oauth_token", valid_599376
  var valid_599377 = query.getOrDefault("userIp")
  valid_599377 = validateParameter(valid_599377, JString, required = false,
                                 default = nil)
  if valid_599377 != nil:
    section.add "userIp", valid_599377
  var valid_599378 = query.getOrDefault("key")
  valid_599378 = validateParameter(valid_599378, JString, required = false,
                                 default = nil)
  if valid_599378 != nil:
    section.add "key", valid_599378
  var valid_599379 = query.getOrDefault("max-results")
  valid_599379 = validateParameter(valid_599379, JInt, required = false, default = nil)
  if valid_599379 != nil:
    section.add "max-results", valid_599379
  var valid_599380 = query.getOrDefault("start-index")
  valid_599380 = validateParameter(valid_599380, JInt, required = false, default = nil)
  if valid_599380 != nil:
    section.add "start-index", valid_599380
  var valid_599381 = query.getOrDefault("prettyPrint")
  valid_599381 = validateParameter(valid_599381, JBool, required = false,
                                 default = newJBool(false))
  if valid_599381 != nil:
    section.add "prettyPrint", valid_599381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599382: Call_AnalyticsManagementRemarketingAudienceList_599367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists remarketing audiences to which the user has access.
  ## 
  let valid = call_599382.validator(path, query, header, formData, body)
  let scheme = call_599382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599382.url(scheme.get, call_599382.host, call_599382.base,
                         call_599382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599382, url, valid)

proc call*(call_599383: Call_AnalyticsManagementRemarketingAudienceList_599367;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; `type`: string = "all";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceList
  ## Lists remarketing audiences to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   type: string
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audiences to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audiences to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of remarketing audiences to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599384 = newJObject()
  var query_599385 = newJObject()
  add(query_599385, "fields", newJString(fields))
  add(query_599385, "quotaUser", newJString(quotaUser))
  add(query_599385, "alt", newJString(alt))
  add(query_599385, "type", newJString(`type`))
  add(query_599385, "oauth_token", newJString(oauthToken))
  add(path_599384, "accountId", newJString(accountId))
  add(query_599385, "userIp", newJString(userIp))
  add(path_599384, "webPropertyId", newJString(webPropertyId))
  add(query_599385, "key", newJString(key))
  add(query_599385, "max-results", newJInt(maxResults))
  add(query_599385, "start-index", newJInt(startIndex))
  add(query_599385, "prettyPrint", newJBool(prettyPrint))
  result = call_599383.call(path_599384, query_599385, nil, nil, nil)

var analyticsManagementRemarketingAudienceList* = Call_AnalyticsManagementRemarketingAudienceList_599367(
    name: "analyticsManagementRemarketingAudienceList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceList_599368,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceList_599369,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceUpdate_599421 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementRemarketingAudienceUpdate_599423(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceUpdate_599422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to update.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_599424 = path.getOrDefault("accountId")
  valid_599424 = validateParameter(valid_599424, JString, required = true,
                                 default = nil)
  if valid_599424 != nil:
    section.add "accountId", valid_599424
  var valid_599425 = path.getOrDefault("webPropertyId")
  valid_599425 = validateParameter(valid_599425, JString, required = true,
                                 default = nil)
  if valid_599425 != nil:
    section.add "webPropertyId", valid_599425
  var valid_599426 = path.getOrDefault("remarketingAudienceId")
  valid_599426 = validateParameter(valid_599426, JString, required = true,
                                 default = nil)
  if valid_599426 != nil:
    section.add "remarketingAudienceId", valid_599426
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599427 = query.getOrDefault("fields")
  valid_599427 = validateParameter(valid_599427, JString, required = false,
                                 default = nil)
  if valid_599427 != nil:
    section.add "fields", valid_599427
  var valid_599428 = query.getOrDefault("quotaUser")
  valid_599428 = validateParameter(valid_599428, JString, required = false,
                                 default = nil)
  if valid_599428 != nil:
    section.add "quotaUser", valid_599428
  var valid_599429 = query.getOrDefault("alt")
  valid_599429 = validateParameter(valid_599429, JString, required = false,
                                 default = newJString("json"))
  if valid_599429 != nil:
    section.add "alt", valid_599429
  var valid_599430 = query.getOrDefault("oauth_token")
  valid_599430 = validateParameter(valid_599430, JString, required = false,
                                 default = nil)
  if valid_599430 != nil:
    section.add "oauth_token", valid_599430
  var valid_599431 = query.getOrDefault("userIp")
  valid_599431 = validateParameter(valid_599431, JString, required = false,
                                 default = nil)
  if valid_599431 != nil:
    section.add "userIp", valid_599431
  var valid_599432 = query.getOrDefault("key")
  valid_599432 = validateParameter(valid_599432, JString, required = false,
                                 default = nil)
  if valid_599432 != nil:
    section.add "key", valid_599432
  var valid_599433 = query.getOrDefault("prettyPrint")
  valid_599433 = validateParameter(valid_599433, JBool, required = false,
                                 default = newJBool(false))
  if valid_599433 != nil:
    section.add "prettyPrint", valid_599433
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

proc call*(call_599435: Call_AnalyticsManagementRemarketingAudienceUpdate_599421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience.
  ## 
  let valid = call_599435.validator(path, query, header, formData, body)
  let scheme = call_599435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599435.url(scheme.get, call_599435.host, call_599435.base,
                         call_599435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599435, url, valid)

proc call*(call_599436: Call_AnalyticsManagementRemarketingAudienceUpdate_599421;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceUpdate
  ## Updates an existing remarketing audience.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599437 = newJObject()
  var query_599438 = newJObject()
  var body_599439 = newJObject()
  add(query_599438, "fields", newJString(fields))
  add(query_599438, "quotaUser", newJString(quotaUser))
  add(query_599438, "alt", newJString(alt))
  add(query_599438, "oauth_token", newJString(oauthToken))
  add(path_599437, "accountId", newJString(accountId))
  add(query_599438, "userIp", newJString(userIp))
  add(path_599437, "webPropertyId", newJString(webPropertyId))
  add(query_599438, "key", newJString(key))
  add(path_599437, "remarketingAudienceId", newJString(remarketingAudienceId))
  if body != nil:
    body_599439 = body
  add(query_599438, "prettyPrint", newJBool(prettyPrint))
  result = call_599436.call(path_599437, query_599438, nil, nil, body_599439)

var analyticsManagementRemarketingAudienceUpdate* = Call_AnalyticsManagementRemarketingAudienceUpdate_599421(
    name: "analyticsManagementRemarketingAudienceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceUpdate_599422,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceUpdate_599423,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceGet_599404 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementRemarketingAudienceGet_599406(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceGet_599405(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a remarketing audience to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to retrieve.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to retrieve.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_599407 = path.getOrDefault("accountId")
  valid_599407 = validateParameter(valid_599407, JString, required = true,
                                 default = nil)
  if valid_599407 != nil:
    section.add "accountId", valid_599407
  var valid_599408 = path.getOrDefault("webPropertyId")
  valid_599408 = validateParameter(valid_599408, JString, required = true,
                                 default = nil)
  if valid_599408 != nil:
    section.add "webPropertyId", valid_599408
  var valid_599409 = path.getOrDefault("remarketingAudienceId")
  valid_599409 = validateParameter(valid_599409, JString, required = true,
                                 default = nil)
  if valid_599409 != nil:
    section.add "remarketingAudienceId", valid_599409
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599410 = query.getOrDefault("fields")
  valid_599410 = validateParameter(valid_599410, JString, required = false,
                                 default = nil)
  if valid_599410 != nil:
    section.add "fields", valid_599410
  var valid_599411 = query.getOrDefault("quotaUser")
  valid_599411 = validateParameter(valid_599411, JString, required = false,
                                 default = nil)
  if valid_599411 != nil:
    section.add "quotaUser", valid_599411
  var valid_599412 = query.getOrDefault("alt")
  valid_599412 = validateParameter(valid_599412, JString, required = false,
                                 default = newJString("json"))
  if valid_599412 != nil:
    section.add "alt", valid_599412
  var valid_599413 = query.getOrDefault("oauth_token")
  valid_599413 = validateParameter(valid_599413, JString, required = false,
                                 default = nil)
  if valid_599413 != nil:
    section.add "oauth_token", valid_599413
  var valid_599414 = query.getOrDefault("userIp")
  valid_599414 = validateParameter(valid_599414, JString, required = false,
                                 default = nil)
  if valid_599414 != nil:
    section.add "userIp", valid_599414
  var valid_599415 = query.getOrDefault("key")
  valid_599415 = validateParameter(valid_599415, JString, required = false,
                                 default = nil)
  if valid_599415 != nil:
    section.add "key", valid_599415
  var valid_599416 = query.getOrDefault("prettyPrint")
  valid_599416 = validateParameter(valid_599416, JBool, required = false,
                                 default = newJBool(false))
  if valid_599416 != nil:
    section.add "prettyPrint", valid_599416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599417: Call_AnalyticsManagementRemarketingAudienceGet_599404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a remarketing audience to which the user has access.
  ## 
  let valid = call_599417.validator(path, query, header, formData, body)
  let scheme = call_599417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599417.url(scheme.get, call_599417.host, call_599417.base,
                         call_599417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599417, url, valid)

proc call*(call_599418: Call_AnalyticsManagementRemarketingAudienceGet_599404;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceGet
  ## Gets a remarketing audience to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599419 = newJObject()
  var query_599420 = newJObject()
  add(query_599420, "fields", newJString(fields))
  add(query_599420, "quotaUser", newJString(quotaUser))
  add(query_599420, "alt", newJString(alt))
  add(query_599420, "oauth_token", newJString(oauthToken))
  add(path_599419, "accountId", newJString(accountId))
  add(query_599420, "userIp", newJString(userIp))
  add(path_599419, "webPropertyId", newJString(webPropertyId))
  add(query_599420, "key", newJString(key))
  add(path_599419, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_599420, "prettyPrint", newJBool(prettyPrint))
  result = call_599418.call(path_599419, query_599420, nil, nil, nil)

var analyticsManagementRemarketingAudienceGet* = Call_AnalyticsManagementRemarketingAudienceGet_599404(
    name: "analyticsManagementRemarketingAudienceGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceGet_599405,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceGet_599406,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudiencePatch_599457 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementRemarketingAudiencePatch_599459(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudiencePatch_599458(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to update.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_599460 = path.getOrDefault("accountId")
  valid_599460 = validateParameter(valid_599460, JString, required = true,
                                 default = nil)
  if valid_599460 != nil:
    section.add "accountId", valid_599460
  var valid_599461 = path.getOrDefault("webPropertyId")
  valid_599461 = validateParameter(valid_599461, JString, required = true,
                                 default = nil)
  if valid_599461 != nil:
    section.add "webPropertyId", valid_599461
  var valid_599462 = path.getOrDefault("remarketingAudienceId")
  valid_599462 = validateParameter(valid_599462, JString, required = true,
                                 default = nil)
  if valid_599462 != nil:
    section.add "remarketingAudienceId", valid_599462
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599463 = query.getOrDefault("fields")
  valid_599463 = validateParameter(valid_599463, JString, required = false,
                                 default = nil)
  if valid_599463 != nil:
    section.add "fields", valid_599463
  var valid_599464 = query.getOrDefault("quotaUser")
  valid_599464 = validateParameter(valid_599464, JString, required = false,
                                 default = nil)
  if valid_599464 != nil:
    section.add "quotaUser", valid_599464
  var valid_599465 = query.getOrDefault("alt")
  valid_599465 = validateParameter(valid_599465, JString, required = false,
                                 default = newJString("json"))
  if valid_599465 != nil:
    section.add "alt", valid_599465
  var valid_599466 = query.getOrDefault("oauth_token")
  valid_599466 = validateParameter(valid_599466, JString, required = false,
                                 default = nil)
  if valid_599466 != nil:
    section.add "oauth_token", valid_599466
  var valid_599467 = query.getOrDefault("userIp")
  valid_599467 = validateParameter(valid_599467, JString, required = false,
                                 default = nil)
  if valid_599467 != nil:
    section.add "userIp", valid_599467
  var valid_599468 = query.getOrDefault("key")
  valid_599468 = validateParameter(valid_599468, JString, required = false,
                                 default = nil)
  if valid_599468 != nil:
    section.add "key", valid_599468
  var valid_599469 = query.getOrDefault("prettyPrint")
  valid_599469 = validateParameter(valid_599469, JBool, required = false,
                                 default = newJBool(false))
  if valid_599469 != nil:
    section.add "prettyPrint", valid_599469
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

proc call*(call_599471: Call_AnalyticsManagementRemarketingAudiencePatch_599457;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ## 
  let valid = call_599471.validator(path, query, header, formData, body)
  let scheme = call_599471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599471.url(scheme.get, call_599471.host, call_599471.base,
                         call_599471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599471, url, valid)

proc call*(call_599472: Call_AnalyticsManagementRemarketingAudiencePatch_599457;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudiencePatch
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599473 = newJObject()
  var query_599474 = newJObject()
  var body_599475 = newJObject()
  add(query_599474, "fields", newJString(fields))
  add(query_599474, "quotaUser", newJString(quotaUser))
  add(query_599474, "alt", newJString(alt))
  add(query_599474, "oauth_token", newJString(oauthToken))
  add(path_599473, "accountId", newJString(accountId))
  add(query_599474, "userIp", newJString(userIp))
  add(path_599473, "webPropertyId", newJString(webPropertyId))
  add(query_599474, "key", newJString(key))
  add(path_599473, "remarketingAudienceId", newJString(remarketingAudienceId))
  if body != nil:
    body_599475 = body
  add(query_599474, "prettyPrint", newJBool(prettyPrint))
  result = call_599472.call(path_599473, query_599474, nil, nil, body_599475)

var analyticsManagementRemarketingAudiencePatch* = Call_AnalyticsManagementRemarketingAudiencePatch_599457(
    name: "analyticsManagementRemarketingAudiencePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudiencePatch_599458,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudiencePatch_599459,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceDelete_599440 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementRemarketingAudienceDelete_599442(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceDelete_599441(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the remarketing audience belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the remarketing audience belongs.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_599443 = path.getOrDefault("accountId")
  valid_599443 = validateParameter(valid_599443, JString, required = true,
                                 default = nil)
  if valid_599443 != nil:
    section.add "accountId", valid_599443
  var valid_599444 = path.getOrDefault("webPropertyId")
  valid_599444 = validateParameter(valid_599444, JString, required = true,
                                 default = nil)
  if valid_599444 != nil:
    section.add "webPropertyId", valid_599444
  var valid_599445 = path.getOrDefault("remarketingAudienceId")
  valid_599445 = validateParameter(valid_599445, JString, required = true,
                                 default = nil)
  if valid_599445 != nil:
    section.add "remarketingAudienceId", valid_599445
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599446 = query.getOrDefault("fields")
  valid_599446 = validateParameter(valid_599446, JString, required = false,
                                 default = nil)
  if valid_599446 != nil:
    section.add "fields", valid_599446
  var valid_599447 = query.getOrDefault("quotaUser")
  valid_599447 = validateParameter(valid_599447, JString, required = false,
                                 default = nil)
  if valid_599447 != nil:
    section.add "quotaUser", valid_599447
  var valid_599448 = query.getOrDefault("alt")
  valid_599448 = validateParameter(valid_599448, JString, required = false,
                                 default = newJString("json"))
  if valid_599448 != nil:
    section.add "alt", valid_599448
  var valid_599449 = query.getOrDefault("oauth_token")
  valid_599449 = validateParameter(valid_599449, JString, required = false,
                                 default = nil)
  if valid_599449 != nil:
    section.add "oauth_token", valid_599449
  var valid_599450 = query.getOrDefault("userIp")
  valid_599450 = validateParameter(valid_599450, JString, required = false,
                                 default = nil)
  if valid_599450 != nil:
    section.add "userIp", valid_599450
  var valid_599451 = query.getOrDefault("key")
  valid_599451 = validateParameter(valid_599451, JString, required = false,
                                 default = nil)
  if valid_599451 != nil:
    section.add "key", valid_599451
  var valid_599452 = query.getOrDefault("prettyPrint")
  valid_599452 = validateParameter(valid_599452, JBool, required = false,
                                 default = newJBool(false))
  if valid_599452 != nil:
    section.add "prettyPrint", valid_599452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599453: Call_AnalyticsManagementRemarketingAudienceDelete_599440;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a remarketing audience.
  ## 
  let valid = call_599453.validator(path, query, header, formData, body)
  let scheme = call_599453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599453.url(scheme.get, call_599453.host, call_599453.base,
                         call_599453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599453, url, valid)

proc call*(call_599454: Call_AnalyticsManagementRemarketingAudienceDelete_599440;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceDelete
  ## Delete a remarketing audience.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the remarketing audience belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the remarketing audience belongs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599455 = newJObject()
  var query_599456 = newJObject()
  add(query_599456, "fields", newJString(fields))
  add(query_599456, "quotaUser", newJString(quotaUser))
  add(query_599456, "alt", newJString(alt))
  add(query_599456, "oauth_token", newJString(oauthToken))
  add(path_599455, "accountId", newJString(accountId))
  add(query_599456, "userIp", newJString(userIp))
  add(path_599455, "webPropertyId", newJString(webPropertyId))
  add(query_599456, "key", newJString(key))
  add(path_599455, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_599456, "prettyPrint", newJBool(prettyPrint))
  result = call_599454.call(path_599455, query_599456, nil, nil, nil)

var analyticsManagementRemarketingAudienceDelete* = Call_AnalyticsManagementRemarketingAudienceDelete_599440(
    name: "analyticsManagementRemarketingAudienceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceDelete_599441,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceDelete_599442,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementClientIdHashClientId_599476 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementClientIdHashClientId_599478(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsManagementClientIdHashClientId_599477(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Hashes the given Client ID.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599479 = query.getOrDefault("fields")
  valid_599479 = validateParameter(valid_599479, JString, required = false,
                                 default = nil)
  if valid_599479 != nil:
    section.add "fields", valid_599479
  var valid_599480 = query.getOrDefault("quotaUser")
  valid_599480 = validateParameter(valid_599480, JString, required = false,
                                 default = nil)
  if valid_599480 != nil:
    section.add "quotaUser", valid_599480
  var valid_599481 = query.getOrDefault("alt")
  valid_599481 = validateParameter(valid_599481, JString, required = false,
                                 default = newJString("json"))
  if valid_599481 != nil:
    section.add "alt", valid_599481
  var valid_599482 = query.getOrDefault("oauth_token")
  valid_599482 = validateParameter(valid_599482, JString, required = false,
                                 default = nil)
  if valid_599482 != nil:
    section.add "oauth_token", valid_599482
  var valid_599483 = query.getOrDefault("userIp")
  valid_599483 = validateParameter(valid_599483, JString, required = false,
                                 default = nil)
  if valid_599483 != nil:
    section.add "userIp", valid_599483
  var valid_599484 = query.getOrDefault("key")
  valid_599484 = validateParameter(valid_599484, JString, required = false,
                                 default = nil)
  if valid_599484 != nil:
    section.add "key", valid_599484
  var valid_599485 = query.getOrDefault("prettyPrint")
  valid_599485 = validateParameter(valid_599485, JBool, required = false,
                                 default = newJBool(false))
  if valid_599485 != nil:
    section.add "prettyPrint", valid_599485
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

proc call*(call_599487: Call_AnalyticsManagementClientIdHashClientId_599476;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hashes the given Client ID.
  ## 
  let valid = call_599487.validator(path, query, header, formData, body)
  let scheme = call_599487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599487.url(scheme.get, call_599487.host, call_599487.base,
                         call_599487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599487, url, valid)

proc call*(call_599488: Call_AnalyticsManagementClientIdHashClientId_599476;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementClientIdHashClientId
  ## Hashes the given Client ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_599489 = newJObject()
  var body_599490 = newJObject()
  add(query_599489, "fields", newJString(fields))
  add(query_599489, "quotaUser", newJString(quotaUser))
  add(query_599489, "alt", newJString(alt))
  add(query_599489, "oauth_token", newJString(oauthToken))
  add(query_599489, "userIp", newJString(userIp))
  add(query_599489, "key", newJString(key))
  if body != nil:
    body_599490 = body
  add(query_599489, "prettyPrint", newJBool(prettyPrint))
  result = call_599488.call(nil, query_599489, nil, nil, body_599490)

var analyticsManagementClientIdHashClientId* = Call_AnalyticsManagementClientIdHashClientId_599476(
    name: "analyticsManagementClientIdHashClientId", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/clientId:hashClientId",
    validator: validate_AnalyticsManagementClientIdHashClientId_599477,
    base: "/analytics/v3", url: url_AnalyticsManagementClientIdHashClientId_599478,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementSegmentsList_599491 = ref object of OpenApiRestCall_597437
proc url_AnalyticsManagementSegmentsList_599493(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsManagementSegmentsList_599492(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists segments to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of segments to include in this response.
  ##   start-index: JInt
  ##              : An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599494 = query.getOrDefault("fields")
  valid_599494 = validateParameter(valid_599494, JString, required = false,
                                 default = nil)
  if valid_599494 != nil:
    section.add "fields", valid_599494
  var valid_599495 = query.getOrDefault("quotaUser")
  valid_599495 = validateParameter(valid_599495, JString, required = false,
                                 default = nil)
  if valid_599495 != nil:
    section.add "quotaUser", valid_599495
  var valid_599496 = query.getOrDefault("alt")
  valid_599496 = validateParameter(valid_599496, JString, required = false,
                                 default = newJString("json"))
  if valid_599496 != nil:
    section.add "alt", valid_599496
  var valid_599497 = query.getOrDefault("oauth_token")
  valid_599497 = validateParameter(valid_599497, JString, required = false,
                                 default = nil)
  if valid_599497 != nil:
    section.add "oauth_token", valid_599497
  var valid_599498 = query.getOrDefault("userIp")
  valid_599498 = validateParameter(valid_599498, JString, required = false,
                                 default = nil)
  if valid_599498 != nil:
    section.add "userIp", valid_599498
  var valid_599499 = query.getOrDefault("key")
  valid_599499 = validateParameter(valid_599499, JString, required = false,
                                 default = nil)
  if valid_599499 != nil:
    section.add "key", valid_599499
  var valid_599500 = query.getOrDefault("max-results")
  valid_599500 = validateParameter(valid_599500, JInt, required = false, default = nil)
  if valid_599500 != nil:
    section.add "max-results", valid_599500
  var valid_599501 = query.getOrDefault("start-index")
  valid_599501 = validateParameter(valid_599501, JInt, required = false, default = nil)
  if valid_599501 != nil:
    section.add "start-index", valid_599501
  var valid_599502 = query.getOrDefault("prettyPrint")
  valid_599502 = validateParameter(valid_599502, JBool, required = false,
                                 default = newJBool(false))
  if valid_599502 != nil:
    section.add "prettyPrint", valid_599502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599503: Call_AnalyticsManagementSegmentsList_599491;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists segments to which the user has access.
  ## 
  let valid = call_599503.validator(path, query, header, formData, body)
  let scheme = call_599503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599503.url(scheme.get, call_599503.host, call_599503.base,
                         call_599503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599503, url, valid)

proc call*(call_599504: Call_AnalyticsManagementSegmentsList_599491;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementSegmentsList
  ## Lists segments to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of segments to include in this response.
  ##   startIndex: int
  ##             : An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_599505 = newJObject()
  add(query_599505, "fields", newJString(fields))
  add(query_599505, "quotaUser", newJString(quotaUser))
  add(query_599505, "alt", newJString(alt))
  add(query_599505, "oauth_token", newJString(oauthToken))
  add(query_599505, "userIp", newJString(userIp))
  add(query_599505, "key", newJString(key))
  add(query_599505, "max-results", newJInt(maxResults))
  add(query_599505, "start-index", newJInt(startIndex))
  add(query_599505, "prettyPrint", newJBool(prettyPrint))
  result = call_599504.call(nil, query_599505, nil, nil, nil)

var analyticsManagementSegmentsList* = Call_AnalyticsManagementSegmentsList_599491(
    name: "analyticsManagementSegmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/segments",
    validator: validate_AnalyticsManagementSegmentsList_599492,
    base: "/analytics/v3", url: url_AnalyticsManagementSegmentsList_599493,
    schemes: {Scheme.Https})
type
  Call_AnalyticsMetadataColumnsList_599506 = ref object of OpenApiRestCall_597437
proc url_AnalyticsMetadataColumnsList_599508(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportType" in path, "`reportType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/metadata/"),
               (kind: VariableSegment, value: "reportType"),
               (kind: ConstantSegment, value: "/columns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsMetadataColumnsList_599507(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all columns for a report type
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportType: JString (required)
  ##             : Report type. Allowed Values: 'ga'. Where 'ga' corresponds to the Core Reporting API
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportType` field"
  var valid_599509 = path.getOrDefault("reportType")
  valid_599509 = validateParameter(valid_599509, JString, required = true,
                                 default = nil)
  if valid_599509 != nil:
    section.add "reportType", valid_599509
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599510 = query.getOrDefault("fields")
  valid_599510 = validateParameter(valid_599510, JString, required = false,
                                 default = nil)
  if valid_599510 != nil:
    section.add "fields", valid_599510
  var valid_599511 = query.getOrDefault("quotaUser")
  valid_599511 = validateParameter(valid_599511, JString, required = false,
                                 default = nil)
  if valid_599511 != nil:
    section.add "quotaUser", valid_599511
  var valid_599512 = query.getOrDefault("alt")
  valid_599512 = validateParameter(valid_599512, JString, required = false,
                                 default = newJString("json"))
  if valid_599512 != nil:
    section.add "alt", valid_599512
  var valid_599513 = query.getOrDefault("oauth_token")
  valid_599513 = validateParameter(valid_599513, JString, required = false,
                                 default = nil)
  if valid_599513 != nil:
    section.add "oauth_token", valid_599513
  var valid_599514 = query.getOrDefault("userIp")
  valid_599514 = validateParameter(valid_599514, JString, required = false,
                                 default = nil)
  if valid_599514 != nil:
    section.add "userIp", valid_599514
  var valid_599515 = query.getOrDefault("key")
  valid_599515 = validateParameter(valid_599515, JString, required = false,
                                 default = nil)
  if valid_599515 != nil:
    section.add "key", valid_599515
  var valid_599516 = query.getOrDefault("prettyPrint")
  valid_599516 = validateParameter(valid_599516, JBool, required = false,
                                 default = newJBool(false))
  if valid_599516 != nil:
    section.add "prettyPrint", valid_599516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599517: Call_AnalyticsMetadataColumnsList_599506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all columns for a report type
  ## 
  let valid = call_599517.validator(path, query, header, formData, body)
  let scheme = call_599517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599517.url(scheme.get, call_599517.host, call_599517.base,
                         call_599517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599517, url, valid)

proc call*(call_599518: Call_AnalyticsMetadataColumnsList_599506;
          reportType: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsMetadataColumnsList
  ## Lists all columns for a report type
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   reportType: string (required)
  ##             : Report type. Allowed Values: 'ga'. Where 'ga' corresponds to the Core Reporting API
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599519 = newJObject()
  var query_599520 = newJObject()
  add(query_599520, "fields", newJString(fields))
  add(query_599520, "quotaUser", newJString(quotaUser))
  add(query_599520, "alt", newJString(alt))
  add(query_599520, "oauth_token", newJString(oauthToken))
  add(query_599520, "userIp", newJString(userIp))
  add(query_599520, "key", newJString(key))
  add(path_599519, "reportType", newJString(reportType))
  add(query_599520, "prettyPrint", newJBool(prettyPrint))
  result = call_599518.call(path_599519, query_599520, nil, nil, nil)

var analyticsMetadataColumnsList* = Call_AnalyticsMetadataColumnsList_599506(
    name: "analyticsMetadataColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/{reportType}/columns",
    validator: validate_AnalyticsMetadataColumnsList_599507,
    base: "/analytics/v3", url: url_AnalyticsMetadataColumnsList_599508,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTicket_599521 = ref object of OpenApiRestCall_597437
proc url_AnalyticsProvisioningCreateAccountTicket_599523(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTicket_599522(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an account ticket.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599524 = query.getOrDefault("fields")
  valid_599524 = validateParameter(valid_599524, JString, required = false,
                                 default = nil)
  if valid_599524 != nil:
    section.add "fields", valid_599524
  var valid_599525 = query.getOrDefault("quotaUser")
  valid_599525 = validateParameter(valid_599525, JString, required = false,
                                 default = nil)
  if valid_599525 != nil:
    section.add "quotaUser", valid_599525
  var valid_599526 = query.getOrDefault("alt")
  valid_599526 = validateParameter(valid_599526, JString, required = false,
                                 default = newJString("json"))
  if valid_599526 != nil:
    section.add "alt", valid_599526
  var valid_599527 = query.getOrDefault("oauth_token")
  valid_599527 = validateParameter(valid_599527, JString, required = false,
                                 default = nil)
  if valid_599527 != nil:
    section.add "oauth_token", valid_599527
  var valid_599528 = query.getOrDefault("userIp")
  valid_599528 = validateParameter(valid_599528, JString, required = false,
                                 default = nil)
  if valid_599528 != nil:
    section.add "userIp", valid_599528
  var valid_599529 = query.getOrDefault("key")
  valid_599529 = validateParameter(valid_599529, JString, required = false,
                                 default = nil)
  if valid_599529 != nil:
    section.add "key", valid_599529
  var valid_599530 = query.getOrDefault("prettyPrint")
  valid_599530 = validateParameter(valid_599530, JBool, required = false,
                                 default = newJBool(false))
  if valid_599530 != nil:
    section.add "prettyPrint", valid_599530
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

proc call*(call_599532: Call_AnalyticsProvisioningCreateAccountTicket_599521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an account ticket.
  ## 
  let valid = call_599532.validator(path, query, header, formData, body)
  let scheme = call_599532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599532.url(scheme.get, call_599532.host, call_599532.base,
                         call_599532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599532, url, valid)

proc call*(call_599533: Call_AnalyticsProvisioningCreateAccountTicket_599521;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsProvisioningCreateAccountTicket
  ## Creates an account ticket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_599534 = newJObject()
  var body_599535 = newJObject()
  add(query_599534, "fields", newJString(fields))
  add(query_599534, "quotaUser", newJString(quotaUser))
  add(query_599534, "alt", newJString(alt))
  add(query_599534, "oauth_token", newJString(oauthToken))
  add(query_599534, "userIp", newJString(userIp))
  add(query_599534, "key", newJString(key))
  if body != nil:
    body_599535 = body
  add(query_599534, "prettyPrint", newJBool(prettyPrint))
  result = call_599533.call(nil, query_599534, nil, nil, body_599535)

var analyticsProvisioningCreateAccountTicket* = Call_AnalyticsProvisioningCreateAccountTicket_599521(
    name: "analyticsProvisioningCreateAccountTicket", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTicket",
    validator: validate_AnalyticsProvisioningCreateAccountTicket_599522,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTicket_599523,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTree_599536 = ref object of OpenApiRestCall_597437
proc url_AnalyticsProvisioningCreateAccountTree_599538(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTree_599537(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provision account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599539 = query.getOrDefault("fields")
  valid_599539 = validateParameter(valid_599539, JString, required = false,
                                 default = nil)
  if valid_599539 != nil:
    section.add "fields", valid_599539
  var valid_599540 = query.getOrDefault("quotaUser")
  valid_599540 = validateParameter(valid_599540, JString, required = false,
                                 default = nil)
  if valid_599540 != nil:
    section.add "quotaUser", valid_599540
  var valid_599541 = query.getOrDefault("alt")
  valid_599541 = validateParameter(valid_599541, JString, required = false,
                                 default = newJString("json"))
  if valid_599541 != nil:
    section.add "alt", valid_599541
  var valid_599542 = query.getOrDefault("oauth_token")
  valid_599542 = validateParameter(valid_599542, JString, required = false,
                                 default = nil)
  if valid_599542 != nil:
    section.add "oauth_token", valid_599542
  var valid_599543 = query.getOrDefault("userIp")
  valid_599543 = validateParameter(valid_599543, JString, required = false,
                                 default = nil)
  if valid_599543 != nil:
    section.add "userIp", valid_599543
  var valid_599544 = query.getOrDefault("key")
  valid_599544 = validateParameter(valid_599544, JString, required = false,
                                 default = nil)
  if valid_599544 != nil:
    section.add "key", valid_599544
  var valid_599545 = query.getOrDefault("prettyPrint")
  valid_599545 = validateParameter(valid_599545, JBool, required = false,
                                 default = newJBool(false))
  if valid_599545 != nil:
    section.add "prettyPrint", valid_599545
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

proc call*(call_599547: Call_AnalyticsProvisioningCreateAccountTree_599536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provision account.
  ## 
  let valid = call_599547.validator(path, query, header, formData, body)
  let scheme = call_599547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599547.url(scheme.get, call_599547.host, call_599547.base,
                         call_599547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599547, url, valid)

proc call*(call_599548: Call_AnalyticsProvisioningCreateAccountTree_599536;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsProvisioningCreateAccountTree
  ## Provision account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_599549 = newJObject()
  var body_599550 = newJObject()
  add(query_599549, "fields", newJString(fields))
  add(query_599549, "quotaUser", newJString(quotaUser))
  add(query_599549, "alt", newJString(alt))
  add(query_599549, "oauth_token", newJString(oauthToken))
  add(query_599549, "userIp", newJString(userIp))
  add(query_599549, "key", newJString(key))
  if body != nil:
    body_599550 = body
  add(query_599549, "prettyPrint", newJBool(prettyPrint))
  result = call_599548.call(nil, query_599549, nil, nil, body_599550)

var analyticsProvisioningCreateAccountTree* = Call_AnalyticsProvisioningCreateAccountTree_599536(
    name: "analyticsProvisioningCreateAccountTree", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTree",
    validator: validate_AnalyticsProvisioningCreateAccountTree_599537,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTree_599538,
    schemes: {Scheme.Https})
type
  Call_AnalyticsUserDeletionUserDeletionRequestUpsert_599551 = ref object of OpenApiRestCall_597437
proc url_AnalyticsUserDeletionUserDeletionRequestUpsert_599553(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsUserDeletionUserDeletionRequestUpsert_599552(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Insert or update a user deletion requests.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599554 = query.getOrDefault("fields")
  valid_599554 = validateParameter(valid_599554, JString, required = false,
                                 default = nil)
  if valid_599554 != nil:
    section.add "fields", valid_599554
  var valid_599555 = query.getOrDefault("quotaUser")
  valid_599555 = validateParameter(valid_599555, JString, required = false,
                                 default = nil)
  if valid_599555 != nil:
    section.add "quotaUser", valid_599555
  var valid_599556 = query.getOrDefault("alt")
  valid_599556 = validateParameter(valid_599556, JString, required = false,
                                 default = newJString("json"))
  if valid_599556 != nil:
    section.add "alt", valid_599556
  var valid_599557 = query.getOrDefault("oauth_token")
  valid_599557 = validateParameter(valid_599557, JString, required = false,
                                 default = nil)
  if valid_599557 != nil:
    section.add "oauth_token", valid_599557
  var valid_599558 = query.getOrDefault("userIp")
  valid_599558 = validateParameter(valid_599558, JString, required = false,
                                 default = nil)
  if valid_599558 != nil:
    section.add "userIp", valid_599558
  var valid_599559 = query.getOrDefault("key")
  valid_599559 = validateParameter(valid_599559, JString, required = false,
                                 default = nil)
  if valid_599559 != nil:
    section.add "key", valid_599559
  var valid_599560 = query.getOrDefault("prettyPrint")
  valid_599560 = validateParameter(valid_599560, JBool, required = false,
                                 default = newJBool(false))
  if valid_599560 != nil:
    section.add "prettyPrint", valid_599560
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

proc call*(call_599562: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_599551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert or update a user deletion requests.
  ## 
  let valid = call_599562.validator(path, query, header, formData, body)
  let scheme = call_599562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599562.url(scheme.get, call_599562.host, call_599562.base,
                         call_599562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599562, url, valid)

proc call*(call_599563: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_599551;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsUserDeletionUserDeletionRequestUpsert
  ## Insert or update a user deletion requests.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_599564 = newJObject()
  var body_599565 = newJObject()
  add(query_599564, "fields", newJString(fields))
  add(query_599564, "quotaUser", newJString(quotaUser))
  add(query_599564, "alt", newJString(alt))
  add(query_599564, "oauth_token", newJString(oauthToken))
  add(query_599564, "userIp", newJString(userIp))
  add(query_599564, "key", newJString(key))
  if body != nil:
    body_599565 = body
  add(query_599564, "prettyPrint", newJBool(prettyPrint))
  result = call_599563.call(nil, query_599564, nil, nil, body_599565)

var analyticsUserDeletionUserDeletionRequestUpsert* = Call_AnalyticsUserDeletionUserDeletionRequestUpsert_599551(
    name: "analyticsUserDeletionUserDeletionRequestUpsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/userDeletion/userDeletionRequests:upsert",
    validator: validate_AnalyticsUserDeletionUserDeletionRequestUpsert_599552,
    base: "/analytics/v3",
    url: url_AnalyticsUserDeletionUserDeletionRequestUpsert_599553,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
