
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  Call_AnalyticsDataGaGet_578634 = ref object of OpenApiRestCall_578364
proc url_AnalyticsDataGaGet_578636(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataGaGet_578635(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns Analytics data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   segment: JString
  ##          : An Analytics segment to be applied to data.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   output: JString
  ##         : The selected format for the response. Default format is JSON.
  ##   samplingLevel: JString
  ##                : The desired sampling level.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified.
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
  ##   include-empty-rows: JBool
  ##                     : The response will include empty rows if this parameter is set to true, the default is true
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to Analytics data.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   start-date: JString (required)
  ##             : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   end-date: JString (required)
  ##           : End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
  section = newJObject()
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578749 = query.getOrDefault("segment")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "segment", valid_578749
  var valid_578763 = query.getOrDefault("prettyPrint")
  valid_578763 = validateParameter(valid_578763, JBool, required = false,
                                 default = newJBool(false))
  if valid_578763 != nil:
    section.add "prettyPrint", valid_578763
  var valid_578764 = query.getOrDefault("oauth_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "oauth_token", valid_578764
  var valid_578765 = query.getOrDefault("output")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("dataTable"))
  if valid_578765 != nil:
    section.add "output", valid_578765
  var valid_578766 = query.getOrDefault("samplingLevel")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_578766 != nil:
    section.add "samplingLevel", valid_578766
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_578767 = query.getOrDefault("metrics")
  valid_578767 = validateParameter(valid_578767, JString, required = true,
                                 default = nil)
  if valid_578767 != nil:
    section.add "metrics", valid_578767
  var valid_578768 = query.getOrDefault("alt")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = newJString("json"))
  if valid_578768 != nil:
    section.add "alt", valid_578768
  var valid_578769 = query.getOrDefault("userIp")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "userIp", valid_578769
  var valid_578770 = query.getOrDefault("quotaUser")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "quotaUser", valid_578770
  var valid_578771 = query.getOrDefault("dimensions")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "dimensions", valid_578771
  var valid_578772 = query.getOrDefault("start-index")
  valid_578772 = validateParameter(valid_578772, JInt, required = false, default = nil)
  if valid_578772 != nil:
    section.add "start-index", valid_578772
  var valid_578773 = query.getOrDefault("include-empty-rows")
  valid_578773 = validateParameter(valid_578773, JBool, required = false, default = nil)
  if valid_578773 != nil:
    section.add "include-empty-rows", valid_578773
  var valid_578774 = query.getOrDefault("filters")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "filters", valid_578774
  var valid_578775 = query.getOrDefault("max-results")
  valid_578775 = validateParameter(valid_578775, JInt, required = false, default = nil)
  if valid_578775 != nil:
    section.add "max-results", valid_578775
  var valid_578776 = query.getOrDefault("start-date")
  valid_578776 = validateParameter(valid_578776, JString, required = true,
                                 default = nil)
  if valid_578776 != nil:
    section.add "start-date", valid_578776
  var valid_578777 = query.getOrDefault("ids")
  valid_578777 = validateParameter(valid_578777, JString, required = true,
                                 default = nil)
  if valid_578777 != nil:
    section.add "ids", valid_578777
  var valid_578778 = query.getOrDefault("end-date")
  valid_578778 = validateParameter(valid_578778, JString, required = true,
                                 default = nil)
  if valid_578778 != nil:
    section.add "end-date", valid_578778
  var valid_578779 = query.getOrDefault("fields")
  valid_578779 = validateParameter(valid_578779, JString, required = false,
                                 default = nil)
  if valid_578779 != nil:
    section.add "fields", valid_578779
  var valid_578780 = query.getOrDefault("sort")
  valid_578780 = validateParameter(valid_578780, JString, required = false,
                                 default = nil)
  if valid_578780 != nil:
    section.add "sort", valid_578780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578803: Call_AnalyticsDataGaGet_578634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics data for a view (profile).
  ## 
  let valid = call_578803.validator(path, query, header, formData, body)
  let scheme = call_578803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578803.url(scheme.get, call_578803.host, call_578803.base,
                         call_578803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578803, url, valid)

proc call*(call_578874: Call_AnalyticsDataGaGet_578634; metrics: string;
          startDate: string; ids: string; endDate: string; key: string = "";
          segment: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          output: string = "dataTable"; samplingLevel: string = "DEFAULT";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          dimensions: string = ""; startIndex: int = 0; includeEmptyRows: bool = false;
          filters: string = ""; maxResults: int = 0; fields: string = ""; sort: string = ""): Recallable =
  ## analyticsDataGaGet
  ## Returns Analytics data for a view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   segment: string
  ##          : An Analytics segment to be applied to data.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   output: string
  ##         : The selected format for the response. Default format is JSON.
  ##   samplingLevel: string
  ##                : The desired sampling level.
  ##   metrics: string (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified.
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
  ##   includeEmptyRows: bool
  ##                   : The response will include empty rows if this parameter is set to true, the default is true
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to Analytics data.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   startDate: string (required)
  ##            : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   endDate: string (required)
  ##          : End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
  var query_578875 = newJObject()
  add(query_578875, "key", newJString(key))
  add(query_578875, "segment", newJString(segment))
  add(query_578875, "prettyPrint", newJBool(prettyPrint))
  add(query_578875, "oauth_token", newJString(oauthToken))
  add(query_578875, "output", newJString(output))
  add(query_578875, "samplingLevel", newJString(samplingLevel))
  add(query_578875, "metrics", newJString(metrics))
  add(query_578875, "alt", newJString(alt))
  add(query_578875, "userIp", newJString(userIp))
  add(query_578875, "quotaUser", newJString(quotaUser))
  add(query_578875, "dimensions", newJString(dimensions))
  add(query_578875, "start-index", newJInt(startIndex))
  add(query_578875, "include-empty-rows", newJBool(includeEmptyRows))
  add(query_578875, "filters", newJString(filters))
  add(query_578875, "max-results", newJInt(maxResults))
  add(query_578875, "start-date", newJString(startDate))
  add(query_578875, "ids", newJString(ids))
  add(query_578875, "end-date", newJString(endDate))
  add(query_578875, "fields", newJString(fields))
  add(query_578875, "sort", newJString(sort))
  result = call_578874.call(nil, query_578875, nil, nil, nil)

var analyticsDataGaGet* = Call_AnalyticsDataGaGet_578634(
    name: "analyticsDataGaGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/ga",
    validator: validate_AnalyticsDataGaGet_578635, base: "/analytics/v3",
    url: url_AnalyticsDataGaGet_578636, schemes: {Scheme.Https})
type
  Call_AnalyticsDataMcfGet_578915 = ref object of OpenApiRestCall_578364
proc url_AnalyticsDataMcfGet_578917(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataMcfGet_578916(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
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
  ##   samplingLevel: JString
  ##                : The desired sampling level.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Multi-Channel Funnels metrics. E.g., 'mcf:totalConversions,mcf:totalConversionValue'. At least one metric must be specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dimensions: JString
  ##             : A comma-separated list of Multi-Channel Funnels dimensions. E.g., 'mcf:source,mcf:medium'.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to the Analytics data.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   start-date: JString (required)
  ##             : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   end-date: JString (required)
  ##           : End date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the Analytics data.
  section = newJObject()
  var valid_578918 = query.getOrDefault("key")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "key", valid_578918
  var valid_578919 = query.getOrDefault("prettyPrint")
  valid_578919 = validateParameter(valid_578919, JBool, required = false,
                                 default = newJBool(false))
  if valid_578919 != nil:
    section.add "prettyPrint", valid_578919
  var valid_578920 = query.getOrDefault("oauth_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "oauth_token", valid_578920
  var valid_578921 = query.getOrDefault("samplingLevel")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_578921 != nil:
    section.add "samplingLevel", valid_578921
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_578922 = query.getOrDefault("metrics")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "metrics", valid_578922
  var valid_578923 = query.getOrDefault("alt")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = newJString("json"))
  if valid_578923 != nil:
    section.add "alt", valid_578923
  var valid_578924 = query.getOrDefault("userIp")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "userIp", valid_578924
  var valid_578925 = query.getOrDefault("quotaUser")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "quotaUser", valid_578925
  var valid_578926 = query.getOrDefault("dimensions")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "dimensions", valid_578926
  var valid_578927 = query.getOrDefault("start-index")
  valid_578927 = validateParameter(valid_578927, JInt, required = false, default = nil)
  if valid_578927 != nil:
    section.add "start-index", valid_578927
  var valid_578928 = query.getOrDefault("filters")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "filters", valid_578928
  var valid_578929 = query.getOrDefault("max-results")
  valid_578929 = validateParameter(valid_578929, JInt, required = false, default = nil)
  if valid_578929 != nil:
    section.add "max-results", valid_578929
  var valid_578930 = query.getOrDefault("start-date")
  valid_578930 = validateParameter(valid_578930, JString, required = true,
                                 default = nil)
  if valid_578930 != nil:
    section.add "start-date", valid_578930
  var valid_578931 = query.getOrDefault("ids")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "ids", valid_578931
  var valid_578932 = query.getOrDefault("end-date")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "end-date", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
  var valid_578934 = query.getOrDefault("sort")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "sort", valid_578934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578935: Call_AnalyticsDataMcfGet_578915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_AnalyticsDataMcfGet_578915; metrics: string;
          startDate: string; ids: string; endDate: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = "";
          samplingLevel: string = "DEFAULT"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dimensions: string = ""; startIndex: int = 0;
          filters: string = ""; maxResults: int = 0; fields: string = ""; sort: string = ""): Recallable =
  ## analyticsDataMcfGet
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   samplingLevel: string
  ##                : The desired sampling level.
  ##   metrics: string (required)
  ##          : A comma-separated list of Multi-Channel Funnels metrics. E.g., 'mcf:totalConversions,mcf:totalConversionValue'. At least one metric must be specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dimensions: string
  ##             : A comma-separated list of Multi-Channel Funnels dimensions. E.g., 'mcf:source,mcf:medium'.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to the Analytics data.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   startDate: string (required)
  ##            : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   endDate: string (required)
  ##          : End date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the Analytics data.
  var query_578937 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "samplingLevel", newJString(samplingLevel))
  add(query_578937, "metrics", newJString(metrics))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "userIp", newJString(userIp))
  add(query_578937, "quotaUser", newJString(quotaUser))
  add(query_578937, "dimensions", newJString(dimensions))
  add(query_578937, "start-index", newJInt(startIndex))
  add(query_578937, "filters", newJString(filters))
  add(query_578937, "max-results", newJInt(maxResults))
  add(query_578937, "start-date", newJString(startDate))
  add(query_578937, "ids", newJString(ids))
  add(query_578937, "end-date", newJString(endDate))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "sort", newJString(sort))
  result = call_578936.call(nil, query_578937, nil, nil, nil)

var analyticsDataMcfGet* = Call_AnalyticsDataMcfGet_578915(
    name: "analyticsDataMcfGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/mcf",
    validator: validate_AnalyticsDataMcfGet_578916, base: "/analytics/v3",
    url: url_AnalyticsDataMcfGet_578917, schemes: {Scheme.Https})
type
  Call_AnalyticsDataRealtimeGet_578938 = ref object of OpenApiRestCall_578364
proc url_AnalyticsDataRealtimeGet_578940(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataRealtimeGet_578939(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns real time data for a view (profile).
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
  ##   metrics: JString (required)
  ##          : A comma-separated list of real time metrics. E.g., 'rt:activeUsers'. At least one metric must be specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dimensions: JString
  ##             : A comma-separated list of real time dimensions. E.g., 'rt:medium,rt:city'.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to real time data.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving real time data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for real time data.
  section = newJObject()
  var valid_578941 = query.getOrDefault("key")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "key", valid_578941
  var valid_578942 = query.getOrDefault("prettyPrint")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(false))
  if valid_578942 != nil:
    section.add "prettyPrint", valid_578942
  var valid_578943 = query.getOrDefault("oauth_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "oauth_token", valid_578943
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_578944 = query.getOrDefault("metrics")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "metrics", valid_578944
  var valid_578945 = query.getOrDefault("alt")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("json"))
  if valid_578945 != nil:
    section.add "alt", valid_578945
  var valid_578946 = query.getOrDefault("userIp")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "userIp", valid_578946
  var valid_578947 = query.getOrDefault("quotaUser")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "quotaUser", valid_578947
  var valid_578948 = query.getOrDefault("dimensions")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "dimensions", valid_578948
  var valid_578949 = query.getOrDefault("filters")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "filters", valid_578949
  var valid_578950 = query.getOrDefault("max-results")
  valid_578950 = validateParameter(valid_578950, JInt, required = false, default = nil)
  if valid_578950 != nil:
    section.add "max-results", valid_578950
  var valid_578951 = query.getOrDefault("ids")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "ids", valid_578951
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
  var valid_578953 = query.getOrDefault("sort")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "sort", valid_578953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578954: Call_AnalyticsDataRealtimeGet_578938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns real time data for a view (profile).
  ## 
  let valid = call_578954.validator(path, query, header, formData, body)
  let scheme = call_578954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578954.url(scheme.get, call_578954.host, call_578954.base,
                         call_578954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578954, url, valid)

proc call*(call_578955: Call_AnalyticsDataRealtimeGet_578938; metrics: string;
          ids: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; dimensions: string = ""; filters: string = "";
          maxResults: int = 0; fields: string = ""; sort: string = ""): Recallable =
  ## analyticsDataRealtimeGet
  ## Returns real time data for a view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   metrics: string (required)
  ##          : A comma-separated list of real time metrics. E.g., 'rt:activeUsers'. At least one metric must be specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dimensions: string
  ##             : A comma-separated list of real time dimensions. E.g., 'rt:medium,rt:city'.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to real time data.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving real time data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for real time data.
  var query_578956 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "metrics", newJString(metrics))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "userIp", newJString(userIp))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(query_578956, "dimensions", newJString(dimensions))
  add(query_578956, "filters", newJString(filters))
  add(query_578956, "max-results", newJInt(maxResults))
  add(query_578956, "ids", newJString(ids))
  add(query_578956, "fields", newJString(fields))
  add(query_578956, "sort", newJString(sort))
  result = call_578955.call(nil, query_578956, nil, nil, nil)

var analyticsDataRealtimeGet* = Call_AnalyticsDataRealtimeGet_578938(
    name: "analyticsDataRealtimeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/realtime",
    validator: validate_AnalyticsDataRealtimeGet_578939, base: "/analytics/v3",
    url: url_AnalyticsDataRealtimeGet_578940, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountSummariesList_578957 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementAccountSummariesList_578959(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountSummariesList_578958(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
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
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of account summaries to include in this response, where the largest acceptable value is 1000.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578960 = query.getOrDefault("key")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "key", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(false))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("userIp")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "userIp", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("start-index")
  valid_578966 = validateParameter(valid_578966, JInt, required = false, default = nil)
  if valid_578966 != nil:
    section.add "start-index", valid_578966
  var valid_578967 = query.getOrDefault("max-results")
  valid_578967 = validateParameter(valid_578967, JInt, required = false, default = nil)
  if valid_578967 != nil:
    section.add "max-results", valid_578967
  var valid_578968 = query.getOrDefault("fields")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "fields", valid_578968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578969: Call_AnalyticsManagementAccountSummariesList_578957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ## 
  let valid = call_578969.validator(path, query, header, formData, body)
  let scheme = call_578969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578969.url(scheme.get, call_578969.host, call_578969.base,
                         call_578969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578969, url, valid)

proc call*(call_578970: Call_AnalyticsManagementAccountSummariesList_578957;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementAccountSummariesList
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
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
  ##             : The maximum number of account summaries to include in this response, where the largest acceptable value is 1000.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578971 = newJObject()
  add(query_578971, "key", newJString(key))
  add(query_578971, "prettyPrint", newJBool(prettyPrint))
  add(query_578971, "oauth_token", newJString(oauthToken))
  add(query_578971, "alt", newJString(alt))
  add(query_578971, "userIp", newJString(userIp))
  add(query_578971, "quotaUser", newJString(quotaUser))
  add(query_578971, "start-index", newJInt(startIndex))
  add(query_578971, "max-results", newJInt(maxResults))
  add(query_578971, "fields", newJString(fields))
  result = call_578970.call(nil, query_578971, nil, nil, nil)

var analyticsManagementAccountSummariesList* = Call_AnalyticsManagementAccountSummariesList_578957(
    name: "analyticsManagementAccountSummariesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accountSummaries",
    validator: validate_AnalyticsManagementAccountSummariesList_578958,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountSummariesList_578959,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountsList_578972 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementAccountsList_578974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountsList_578973(path: JsonNode;
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
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("prettyPrint")
  valid_578976 = validateParameter(valid_578976, JBool, required = false,
                                 default = newJBool(false))
  if valid_578976 != nil:
    section.add "prettyPrint", valid_578976
  var valid_578977 = query.getOrDefault("oauth_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "oauth_token", valid_578977
  var valid_578978 = query.getOrDefault("alt")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("json"))
  if valid_578978 != nil:
    section.add "alt", valid_578978
  var valid_578979 = query.getOrDefault("userIp")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "userIp", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("start-index")
  valid_578981 = validateParameter(valid_578981, JInt, required = false, default = nil)
  if valid_578981 != nil:
    section.add "start-index", valid_578981
  var valid_578982 = query.getOrDefault("max-results")
  valid_578982 = validateParameter(valid_578982, JInt, required = false, default = nil)
  if valid_578982 != nil:
    section.add "max-results", valid_578982
  var valid_578983 = query.getOrDefault("fields")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "fields", valid_578983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578984: Call_AnalyticsManagementAccountsList_578972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all accounts to which the user has access.
  ## 
  let valid = call_578984.validator(path, query, header, formData, body)
  let scheme = call_578984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578984.url(scheme.get, call_578984.host, call_578984.base,
                         call_578984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578984, url, valid)

proc call*(call_578985: Call_AnalyticsManagementAccountsList_578972;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
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
  var query_578986 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "userIp", newJString(userIp))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(query_578986, "start-index", newJInt(startIndex))
  add(query_578986, "max-results", newJInt(maxResults))
  add(query_578986, "fields", newJString(fields))
  result = call_578985.call(nil, query_578986, nil, nil, nil)

var analyticsManagementAccountsList* = Call_AnalyticsManagementAccountsList_578972(
    name: "analyticsManagementAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts",
    validator: validate_AnalyticsManagementAccountsList_578973,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountsList_578974,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksInsert_579018 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementAccountUserLinksInsert_579020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementAccountUserLinksInsert_579019(path: JsonNode;
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
  var valid_579021 = path.getOrDefault("accountId")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "accountId", valid_579021
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579022 = query.getOrDefault("key")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "key", valid_579022
  var valid_579023 = query.getOrDefault("prettyPrint")
  valid_579023 = validateParameter(valid_579023, JBool, required = false,
                                 default = newJBool(false))
  if valid_579023 != nil:
    section.add "prettyPrint", valid_579023
  var valid_579024 = query.getOrDefault("oauth_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "oauth_token", valid_579024
  var valid_579025 = query.getOrDefault("alt")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = newJString("json"))
  if valid_579025 != nil:
    section.add "alt", valid_579025
  var valid_579026 = query.getOrDefault("userIp")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "userIp", valid_579026
  var valid_579027 = query.getOrDefault("quotaUser")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "quotaUser", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
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

proc call*(call_579030: Call_AnalyticsManagementAccountUserLinksInsert_579018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given account.
  ## 
  let valid = call_579030.validator(path, query, header, formData, body)
  let scheme = call_579030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579030.url(scheme.get, call_579030.host, call_579030.base,
                         call_579030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579030, url, valid)

proc call*(call_579031: Call_AnalyticsManagementAccountUserLinksInsert_579018;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementAccountUserLinksInsert
  ## Adds a new user to the given account.
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579032 = newJObject()
  var query_579033 = newJObject()
  var body_579034 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "userIp", newJString(userIp))
  add(query_579033, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579034 = body
  add(path_579032, "accountId", newJString(accountId))
  add(query_579033, "fields", newJString(fields))
  result = call_579031.call(path_579032, query_579033, nil, nil, body_579034)

var analyticsManagementAccountUserLinksInsert* = Call_AnalyticsManagementAccountUserLinksInsert_579018(
    name: "analyticsManagementAccountUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksInsert_579019,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksInsert_579020,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksList_578987 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementAccountUserLinksList_578989(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementAccountUserLinksList_578988(path: JsonNode;
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
  var valid_579004 = path.getOrDefault("accountId")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "accountId", valid_579004
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
  ##              : An index of the first account-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of account-user links to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579005 = query.getOrDefault("key")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "key", valid_579005
  var valid_579006 = query.getOrDefault("prettyPrint")
  valid_579006 = validateParameter(valid_579006, JBool, required = false,
                                 default = newJBool(false))
  if valid_579006 != nil:
    section.add "prettyPrint", valid_579006
  var valid_579007 = query.getOrDefault("oauth_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "oauth_token", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("userIp")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "userIp", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("start-index")
  valid_579011 = validateParameter(valid_579011, JInt, required = false, default = nil)
  if valid_579011 != nil:
    section.add "start-index", valid_579011
  var valid_579012 = query.getOrDefault("max-results")
  valid_579012 = validateParameter(valid_579012, JInt, required = false, default = nil)
  if valid_579012 != nil:
    section.add "max-results", valid_579012
  var valid_579013 = query.getOrDefault("fields")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "fields", valid_579013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579014: Call_AnalyticsManagementAccountUserLinksList_578987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account-user links for a given account.
  ## 
  let valid = call_579014.validator(path, query, header, formData, body)
  let scheme = call_579014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579014.url(scheme.get, call_579014.host, call_579014.base,
                         call_579014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579014, url, valid)

proc call*(call_579015: Call_AnalyticsManagementAccountUserLinksList_578987;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; startIndex: int = 0; maxResults: int = 0;
          fields: string = ""): Recallable =
  ## analyticsManagementAccountUserLinksList
  ## Lists account-user links for a given account.
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
  ##             : An index of the first account-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of account-user links to include in this response.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the user links for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579016 = newJObject()
  var query_579017 = newJObject()
  add(query_579017, "key", newJString(key))
  add(query_579017, "prettyPrint", newJBool(prettyPrint))
  add(query_579017, "oauth_token", newJString(oauthToken))
  add(query_579017, "alt", newJString(alt))
  add(query_579017, "userIp", newJString(userIp))
  add(query_579017, "quotaUser", newJString(quotaUser))
  add(query_579017, "start-index", newJInt(startIndex))
  add(query_579017, "max-results", newJInt(maxResults))
  add(path_579016, "accountId", newJString(accountId))
  add(query_579017, "fields", newJString(fields))
  result = call_579015.call(path_579016, query_579017, nil, nil, nil)

var analyticsManagementAccountUserLinksList* = Call_AnalyticsManagementAccountUserLinksList_578987(
    name: "analyticsManagementAccountUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksList_578988,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksList_578989,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksUpdate_579035 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementAccountUserLinksUpdate_579037(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementAccountUserLinksUpdate_579036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : Link ID to update the account-user link for.
  ##   accountId: JString (required)
  ##            : Account ID to update the account-user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_579038 = path.getOrDefault("linkId")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "linkId", valid_579038
  var valid_579039 = path.getOrDefault("accountId")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "accountId", valid_579039
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579040 = query.getOrDefault("key")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "key", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(false))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("alt")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("json"))
  if valid_579043 != nil:
    section.add "alt", valid_579043
  var valid_579044 = query.getOrDefault("userIp")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "userIp", valid_579044
  var valid_579045 = query.getOrDefault("quotaUser")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "quotaUser", valid_579045
  var valid_579046 = query.getOrDefault("fields")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "fields", valid_579046
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

proc call*(call_579048: Call_AnalyticsManagementAccountUserLinksUpdate_579035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given account.
  ## 
  let valid = call_579048.validator(path, query, header, formData, body)
  let scheme = call_579048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579048.url(scheme.get, call_579048.host, call_579048.base,
                         call_579048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579048, url, valid)

proc call*(call_579049: Call_AnalyticsManagementAccountUserLinksUpdate_579035;
          linkId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementAccountUserLinksUpdate
  ## Updates permissions for an existing user on the given account.
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
  ##   linkId: string (required)
  ##         : Link ID to update the account-user link for.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to update the account-user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579050 = newJObject()
  var query_579051 = newJObject()
  var body_579052 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "userIp", newJString(userIp))
  add(query_579051, "quotaUser", newJString(quotaUser))
  add(path_579050, "linkId", newJString(linkId))
  if body != nil:
    body_579052 = body
  add(path_579050, "accountId", newJString(accountId))
  add(query_579051, "fields", newJString(fields))
  result = call_579049.call(path_579050, query_579051, nil, nil, body_579052)

var analyticsManagementAccountUserLinksUpdate* = Call_AnalyticsManagementAccountUserLinksUpdate_579035(
    name: "analyticsManagementAccountUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksUpdate_579036,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksUpdate_579037,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksDelete_579053 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementAccountUserLinksDelete_579055(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementAccountUserLinksDelete_579054(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a user from the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_579056 = path.getOrDefault("linkId")
  valid_579056 = validateParameter(valid_579056, JString, required = true,
                                 default = nil)
  if valid_579056 != nil:
    section.add "linkId", valid_579056
  var valid_579057 = path.getOrDefault("accountId")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "accountId", valid_579057
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579058 = query.getOrDefault("key")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "key", valid_579058
  var valid_579059 = query.getOrDefault("prettyPrint")
  valid_579059 = validateParameter(valid_579059, JBool, required = false,
                                 default = newJBool(false))
  if valid_579059 != nil:
    section.add "prettyPrint", valid_579059
  var valid_579060 = query.getOrDefault("oauth_token")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "oauth_token", valid_579060
  var valid_579061 = query.getOrDefault("alt")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("json"))
  if valid_579061 != nil:
    section.add "alt", valid_579061
  var valid_579062 = query.getOrDefault("userIp")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "userIp", valid_579062
  var valid_579063 = query.getOrDefault("quotaUser")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "quotaUser", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579065: Call_AnalyticsManagementAccountUserLinksDelete_579053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given account.
  ## 
  let valid = call_579065.validator(path, query, header, formData, body)
  let scheme = call_579065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579065.url(scheme.get, call_579065.host, call_579065.base,
                         call_579065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579065, url, valid)

proc call*(call_579066: Call_AnalyticsManagementAccountUserLinksDelete_579053;
          linkId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementAccountUserLinksDelete
  ## Removes a user from the given account.
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
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579067 = newJObject()
  var query_579068 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "userIp", newJString(userIp))
  add(query_579068, "quotaUser", newJString(quotaUser))
  add(path_579067, "linkId", newJString(linkId))
  add(path_579067, "accountId", newJString(accountId))
  add(query_579068, "fields", newJString(fields))
  result = call_579066.call(path_579067, query_579068, nil, nil, nil)

var analyticsManagementAccountUserLinksDelete* = Call_AnalyticsManagementAccountUserLinksDelete_579053(
    name: "analyticsManagementAccountUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksDelete_579054,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksDelete_579055,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersInsert_579086 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementFiltersInsert_579088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementFiltersInsert_579087(path: JsonNode;
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
  var valid_579089 = path.getOrDefault("accountId")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "accountId", valid_579089
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579090 = query.getOrDefault("key")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "key", valid_579090
  var valid_579091 = query.getOrDefault("prettyPrint")
  valid_579091 = validateParameter(valid_579091, JBool, required = false,
                                 default = newJBool(false))
  if valid_579091 != nil:
    section.add "prettyPrint", valid_579091
  var valid_579092 = query.getOrDefault("oauth_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "oauth_token", valid_579092
  var valid_579093 = query.getOrDefault("alt")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = newJString("json"))
  if valid_579093 != nil:
    section.add "alt", valid_579093
  var valid_579094 = query.getOrDefault("userIp")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "userIp", valid_579094
  var valid_579095 = query.getOrDefault("quotaUser")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "quotaUser", valid_579095
  var valid_579096 = query.getOrDefault("fields")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "fields", valid_579096
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

proc call*(call_579098: Call_AnalyticsManagementFiltersInsert_579086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new filter.
  ## 
  let valid = call_579098.validator(path, query, header, formData, body)
  let scheme = call_579098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579098.url(scheme.get, call_579098.host, call_579098.base,
                         call_579098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579098, url, valid)

proc call*(call_579099: Call_AnalyticsManagementFiltersInsert_579086;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementFiltersInsert
  ## Create a new filter.
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create filter for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579100 = newJObject()
  var query_579101 = newJObject()
  var body_579102 = newJObject()
  add(query_579101, "key", newJString(key))
  add(query_579101, "prettyPrint", newJBool(prettyPrint))
  add(query_579101, "oauth_token", newJString(oauthToken))
  add(query_579101, "alt", newJString(alt))
  add(query_579101, "userIp", newJString(userIp))
  add(query_579101, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579102 = body
  add(path_579100, "accountId", newJString(accountId))
  add(query_579101, "fields", newJString(fields))
  result = call_579099.call(path_579100, query_579101, nil, nil, body_579102)

var analyticsManagementFiltersInsert* = Call_AnalyticsManagementFiltersInsert_579086(
    name: "analyticsManagementFiltersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersInsert_579087,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersInsert_579088,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersList_579069 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementFiltersList_579071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementFiltersList_579070(path: JsonNode;
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
  var valid_579072 = path.getOrDefault("accountId")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "accountId", valid_579072
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
  ##              : The maximum number of filters to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(false))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("alt")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("json"))
  if valid_579076 != nil:
    section.add "alt", valid_579076
  var valid_579077 = query.getOrDefault("userIp")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "userIp", valid_579077
  var valid_579078 = query.getOrDefault("quotaUser")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "quotaUser", valid_579078
  var valid_579079 = query.getOrDefault("start-index")
  valid_579079 = validateParameter(valid_579079, JInt, required = false, default = nil)
  if valid_579079 != nil:
    section.add "start-index", valid_579079
  var valid_579080 = query.getOrDefault("max-results")
  valid_579080 = validateParameter(valid_579080, JInt, required = false, default = nil)
  if valid_579080 != nil:
    section.add "max-results", valid_579080
  var valid_579081 = query.getOrDefault("fields")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "fields", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_AnalyticsManagementFiltersList_579069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all filters for an account
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_AnalyticsManagementFiltersList_579069;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; startIndex: int = 0; maxResults: int = 0;
          fields: string = ""): Recallable =
  ## analyticsManagementFiltersList
  ## Lists all filters for an account
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
  ##             : The maximum number of filters to include in this response.
  ##   accountId: string (required)
  ##            : Account ID to retrieve filters for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "userIp", newJString(userIp))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(query_579085, "start-index", newJInt(startIndex))
  add(query_579085, "max-results", newJInt(maxResults))
  add(path_579084, "accountId", newJString(accountId))
  add(query_579085, "fields", newJString(fields))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var analyticsManagementFiltersList* = Call_AnalyticsManagementFiltersList_579069(
    name: "analyticsManagementFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersList_579070,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersList_579071,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersUpdate_579119 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementFiltersUpdate_579121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementFiltersUpdate_579120(path: JsonNode;
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
  var valid_579122 = path.getOrDefault("accountId")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "accountId", valid_579122
  var valid_579123 = path.getOrDefault("filterId")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "filterId", valid_579123
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579124 = query.getOrDefault("key")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "key", valid_579124
  var valid_579125 = query.getOrDefault("prettyPrint")
  valid_579125 = validateParameter(valid_579125, JBool, required = false,
                                 default = newJBool(false))
  if valid_579125 != nil:
    section.add "prettyPrint", valid_579125
  var valid_579126 = query.getOrDefault("oauth_token")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "oauth_token", valid_579126
  var valid_579127 = query.getOrDefault("alt")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = newJString("json"))
  if valid_579127 != nil:
    section.add "alt", valid_579127
  var valid_579128 = query.getOrDefault("userIp")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "userIp", valid_579128
  var valid_579129 = query.getOrDefault("quotaUser")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "quotaUser", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
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

proc call*(call_579132: Call_AnalyticsManagementFiltersUpdate_579119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter.
  ## 
  let valid = call_579132.validator(path, query, header, formData, body)
  let scheme = call_579132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579132.url(scheme.get, call_579132.host, call_579132.base,
                         call_579132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579132, url, valid)

proc call*(call_579133: Call_AnalyticsManagementFiltersUpdate_579119;
          accountId: string; filterId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementFiltersUpdate
  ## Updates an existing filter.
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which the filter belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterId: string (required)
  ##           : ID of the filter to be updated.
  var path_579134 = newJObject()
  var query_579135 = newJObject()
  var body_579136 = newJObject()
  add(query_579135, "key", newJString(key))
  add(query_579135, "prettyPrint", newJBool(prettyPrint))
  add(query_579135, "oauth_token", newJString(oauthToken))
  add(query_579135, "alt", newJString(alt))
  add(query_579135, "userIp", newJString(userIp))
  add(query_579135, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579136 = body
  add(path_579134, "accountId", newJString(accountId))
  add(query_579135, "fields", newJString(fields))
  add(path_579134, "filterId", newJString(filterId))
  result = call_579133.call(path_579134, query_579135, nil, nil, body_579136)

var analyticsManagementFiltersUpdate* = Call_AnalyticsManagementFiltersUpdate_579119(
    name: "analyticsManagementFiltersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersUpdate_579120,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersUpdate_579121,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersGet_579103 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementFiltersGet_579105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementFiltersGet_579104(path: JsonNode; query: JsonNode;
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
  var valid_579106 = path.getOrDefault("accountId")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "accountId", valid_579106
  var valid_579107 = path.getOrDefault("filterId")
  valid_579107 = validateParameter(valid_579107, JString, required = true,
                                 default = nil)
  if valid_579107 != nil:
    section.add "filterId", valid_579107
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579108 = query.getOrDefault("key")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "key", valid_579108
  var valid_579109 = query.getOrDefault("prettyPrint")
  valid_579109 = validateParameter(valid_579109, JBool, required = false,
                                 default = newJBool(false))
  if valid_579109 != nil:
    section.add "prettyPrint", valid_579109
  var valid_579110 = query.getOrDefault("oauth_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "oauth_token", valid_579110
  var valid_579111 = query.getOrDefault("alt")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("json"))
  if valid_579111 != nil:
    section.add "alt", valid_579111
  var valid_579112 = query.getOrDefault("userIp")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "userIp", valid_579112
  var valid_579113 = query.getOrDefault("quotaUser")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "quotaUser", valid_579113
  var valid_579114 = query.getOrDefault("fields")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "fields", valid_579114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579115: Call_AnalyticsManagementFiltersGet_579103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns filters to which the user has access.
  ## 
  let valid = call_579115.validator(path, query, header, formData, body)
  let scheme = call_579115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579115.url(scheme.get, call_579115.host, call_579115.base,
                         call_579115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579115, url, valid)

proc call*(call_579116: Call_AnalyticsManagementFiltersGet_579103;
          accountId: string; filterId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementFiltersGet
  ## Returns filters to which the user has access.
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
  ##   accountId: string (required)
  ##            : Account ID to retrieve filters for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterId: string (required)
  ##           : Filter ID to retrieve filters for.
  var path_579117 = newJObject()
  var query_579118 = newJObject()
  add(query_579118, "key", newJString(key))
  add(query_579118, "prettyPrint", newJBool(prettyPrint))
  add(query_579118, "oauth_token", newJString(oauthToken))
  add(query_579118, "alt", newJString(alt))
  add(query_579118, "userIp", newJString(userIp))
  add(query_579118, "quotaUser", newJString(quotaUser))
  add(path_579117, "accountId", newJString(accountId))
  add(query_579118, "fields", newJString(fields))
  add(path_579117, "filterId", newJString(filterId))
  result = call_579116.call(path_579117, query_579118, nil, nil, nil)

var analyticsManagementFiltersGet* = Call_AnalyticsManagementFiltersGet_579103(
    name: "analyticsManagementFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersGet_579104,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersGet_579105,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersPatch_579153 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementFiltersPatch_579155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementFiltersPatch_579154(path: JsonNode;
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
  var valid_579156 = path.getOrDefault("accountId")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "accountId", valid_579156
  var valid_579157 = path.getOrDefault("filterId")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "filterId", valid_579157
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579158 = query.getOrDefault("key")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "key", valid_579158
  var valid_579159 = query.getOrDefault("prettyPrint")
  valid_579159 = validateParameter(valid_579159, JBool, required = false,
                                 default = newJBool(false))
  if valid_579159 != nil:
    section.add "prettyPrint", valid_579159
  var valid_579160 = query.getOrDefault("oauth_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "oauth_token", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("userIp")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "userIp", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("fields")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "fields", valid_579164
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

proc call*(call_579166: Call_AnalyticsManagementFiltersPatch_579153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter. This method supports patch semantics.
  ## 
  let valid = call_579166.validator(path, query, header, formData, body)
  let scheme = call_579166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579166.url(scheme.get, call_579166.host, call_579166.base,
                         call_579166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579166, url, valid)

proc call*(call_579167: Call_AnalyticsManagementFiltersPatch_579153;
          accountId: string; filterId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementFiltersPatch
  ## Updates an existing filter. This method supports patch semantics.
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which the filter belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterId: string (required)
  ##           : ID of the filter to be updated.
  var path_579168 = newJObject()
  var query_579169 = newJObject()
  var body_579170 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "userIp", newJString(userIp))
  add(query_579169, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579170 = body
  add(path_579168, "accountId", newJString(accountId))
  add(query_579169, "fields", newJString(fields))
  add(path_579168, "filterId", newJString(filterId))
  result = call_579167.call(path_579168, query_579169, nil, nil, body_579170)

var analyticsManagementFiltersPatch* = Call_AnalyticsManagementFiltersPatch_579153(
    name: "analyticsManagementFiltersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersPatch_579154,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersPatch_579155,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersDelete_579137 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementFiltersDelete_579139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementFiltersDelete_579138(path: JsonNode;
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
  var valid_579140 = path.getOrDefault("accountId")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "accountId", valid_579140
  var valid_579141 = path.getOrDefault("filterId")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "filterId", valid_579141
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(false))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("userIp")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "userIp", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("fields")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "fields", valid_579148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_AnalyticsManagementFiltersDelete_579137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a filter.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_AnalyticsManagementFiltersDelete_579137;
          accountId: string; filterId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementFiltersDelete
  ## Delete a filter.
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
  ##   accountId: string (required)
  ##            : Account ID to delete the filter for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterId: string (required)
  ##           : ID of the filter to be deleted.
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "userIp", newJString(userIp))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(path_579151, "accountId", newJString(accountId))
  add(query_579152, "fields", newJString(fields))
  add(path_579151, "filterId", newJString(filterId))
  result = call_579150.call(path_579151, query_579152, nil, nil, nil)

var analyticsManagementFiltersDelete* = Call_AnalyticsManagementFiltersDelete_579137(
    name: "analyticsManagementFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersDelete_579138,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersDelete_579139,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesInsert_579188 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertiesInsert_579190(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertiesInsert_579189(path: JsonNode;
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
  var valid_579191 = path.getOrDefault("accountId")
  valid_579191 = validateParameter(valid_579191, JString, required = true,
                                 default = nil)
  if valid_579191 != nil:
    section.add "accountId", valid_579191
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579192 = query.getOrDefault("key")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "key", valid_579192
  var valid_579193 = query.getOrDefault("prettyPrint")
  valid_579193 = validateParameter(valid_579193, JBool, required = false,
                                 default = newJBool(false))
  if valid_579193 != nil:
    section.add "prettyPrint", valid_579193
  var valid_579194 = query.getOrDefault("oauth_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "oauth_token", valid_579194
  var valid_579195 = query.getOrDefault("alt")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = newJString("json"))
  if valid_579195 != nil:
    section.add "alt", valid_579195
  var valid_579196 = query.getOrDefault("userIp")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "userIp", valid_579196
  var valid_579197 = query.getOrDefault("quotaUser")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "quotaUser", valid_579197
  var valid_579198 = query.getOrDefault("fields")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "fields", valid_579198
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

proc call*(call_579200: Call_AnalyticsManagementWebpropertiesInsert_579188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ## 
  let valid = call_579200.validator(path, query, header, formData, body)
  let scheme = call_579200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579200.url(scheme.get, call_579200.host, call_579200.base,
                         call_579200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579200, url, valid)

proc call*(call_579201: Call_AnalyticsManagementWebpropertiesInsert_579188;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementWebpropertiesInsert
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
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
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the web property for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579202 = newJObject()
  var query_579203 = newJObject()
  var body_579204 = newJObject()
  add(query_579203, "key", newJString(key))
  add(query_579203, "prettyPrint", newJBool(prettyPrint))
  add(query_579203, "oauth_token", newJString(oauthToken))
  add(query_579203, "alt", newJString(alt))
  add(query_579203, "userIp", newJString(userIp))
  add(query_579203, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579204 = body
  add(path_579202, "accountId", newJString(accountId))
  add(query_579203, "fields", newJString(fields))
  result = call_579201.call(path_579202, query_579203, nil, nil, body_579204)

var analyticsManagementWebpropertiesInsert* = Call_AnalyticsManagementWebpropertiesInsert_579188(
    name: "analyticsManagementWebpropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesInsert_579189,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesInsert_579190,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesList_579171 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertiesList_579173(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertiesList_579172(path: JsonNode;
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
  var valid_579174 = path.getOrDefault("accountId")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "accountId", valid_579174
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
  var valid_579175 = query.getOrDefault("key")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "key", valid_579175
  var valid_579176 = query.getOrDefault("prettyPrint")
  valid_579176 = validateParameter(valid_579176, JBool, required = false,
                                 default = newJBool(false))
  if valid_579176 != nil:
    section.add "prettyPrint", valid_579176
  var valid_579177 = query.getOrDefault("oauth_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "oauth_token", valid_579177
  var valid_579178 = query.getOrDefault("alt")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("json"))
  if valid_579178 != nil:
    section.add "alt", valid_579178
  var valid_579179 = query.getOrDefault("userIp")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "userIp", valid_579179
  var valid_579180 = query.getOrDefault("quotaUser")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "quotaUser", valid_579180
  var valid_579181 = query.getOrDefault("start-index")
  valid_579181 = validateParameter(valid_579181, JInt, required = false, default = nil)
  if valid_579181 != nil:
    section.add "start-index", valid_579181
  var valid_579182 = query.getOrDefault("max-results")
  valid_579182 = validateParameter(valid_579182, JInt, required = false, default = nil)
  if valid_579182 != nil:
    section.add "max-results", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579184: Call_AnalyticsManagementWebpropertiesList_579171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web properties to which the user has access.
  ## 
  let valid = call_579184.validator(path, query, header, formData, body)
  let scheme = call_579184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579184.url(scheme.get, call_579184.host, call_579184.base,
                         call_579184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579184, url, valid)

proc call*(call_579185: Call_AnalyticsManagementWebpropertiesList_579171;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
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
  var path_579186 = newJObject()
  var query_579187 = newJObject()
  add(query_579187, "key", newJString(key))
  add(query_579187, "prettyPrint", newJBool(prettyPrint))
  add(query_579187, "oauth_token", newJString(oauthToken))
  add(query_579187, "alt", newJString(alt))
  add(query_579187, "userIp", newJString(userIp))
  add(query_579187, "quotaUser", newJString(quotaUser))
  add(query_579187, "start-index", newJInt(startIndex))
  add(query_579187, "max-results", newJInt(maxResults))
  add(path_579186, "accountId", newJString(accountId))
  add(query_579187, "fields", newJString(fields))
  result = call_579185.call(path_579186, query_579187, nil, nil, nil)

var analyticsManagementWebpropertiesList* = Call_AnalyticsManagementWebpropertiesList_579171(
    name: "analyticsManagementWebpropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesList_579172,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesList_579173,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesUpdate_579221 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertiesUpdate_579223(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesUpdate_579222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID
  ##   accountId: JString (required)
  ##            : Account ID to which the web property belongs
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579224 = path.getOrDefault("webPropertyId")
  valid_579224 = validateParameter(valid_579224, JString, required = true,
                                 default = nil)
  if valid_579224 != nil:
    section.add "webPropertyId", valid_579224
  var valid_579225 = path.getOrDefault("accountId")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "accountId", valid_579225
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579226 = query.getOrDefault("key")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "key", valid_579226
  var valid_579227 = query.getOrDefault("prettyPrint")
  valid_579227 = validateParameter(valid_579227, JBool, required = false,
                                 default = newJBool(false))
  if valid_579227 != nil:
    section.add "prettyPrint", valid_579227
  var valid_579228 = query.getOrDefault("oauth_token")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "oauth_token", valid_579228
  var valid_579229 = query.getOrDefault("alt")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = newJString("json"))
  if valid_579229 != nil:
    section.add "alt", valid_579229
  var valid_579230 = query.getOrDefault("userIp")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "userIp", valid_579230
  var valid_579231 = query.getOrDefault("quotaUser")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "quotaUser", valid_579231
  var valid_579232 = query.getOrDefault("fields")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "fields", valid_579232
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

proc call*(call_579234: Call_AnalyticsManagementWebpropertiesUpdate_579221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property.
  ## 
  let valid = call_579234.validator(path, query, header, formData, body)
  let scheme = call_579234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579234.url(scheme.get, call_579234.host, call_579234.base,
                         call_579234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579234, url, valid)

proc call*(call_579235: Call_AnalyticsManagementWebpropertiesUpdate_579221;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementWebpropertiesUpdate
  ## Updates an existing web property.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which the web property belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579236 = newJObject()
  var query_579237 = newJObject()
  var body_579238 = newJObject()
  add(query_579237, "key", newJString(key))
  add(query_579237, "prettyPrint", newJBool(prettyPrint))
  add(query_579237, "oauth_token", newJString(oauthToken))
  add(path_579236, "webPropertyId", newJString(webPropertyId))
  add(query_579237, "alt", newJString(alt))
  add(query_579237, "userIp", newJString(userIp))
  add(query_579237, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579238 = body
  add(path_579236, "accountId", newJString(accountId))
  add(query_579237, "fields", newJString(fields))
  result = call_579235.call(path_579236, query_579237, nil, nil, body_579238)

var analyticsManagementWebpropertiesUpdate* = Call_AnalyticsManagementWebpropertiesUpdate_579221(
    name: "analyticsManagementWebpropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesUpdate_579222,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesUpdate_579223,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesGet_579205 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertiesGet_579207(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesGet_579206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a web property to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : ID to retrieve the web property for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the web property for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579208 = path.getOrDefault("webPropertyId")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "webPropertyId", valid_579208
  var valid_579209 = path.getOrDefault("accountId")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "accountId", valid_579209
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579210 = query.getOrDefault("key")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "key", valid_579210
  var valid_579211 = query.getOrDefault("prettyPrint")
  valid_579211 = validateParameter(valid_579211, JBool, required = false,
                                 default = newJBool(false))
  if valid_579211 != nil:
    section.add "prettyPrint", valid_579211
  var valid_579212 = query.getOrDefault("oauth_token")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "oauth_token", valid_579212
  var valid_579213 = query.getOrDefault("alt")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("json"))
  if valid_579213 != nil:
    section.add "alt", valid_579213
  var valid_579214 = query.getOrDefault("userIp")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "userIp", valid_579214
  var valid_579215 = query.getOrDefault("quotaUser")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "quotaUser", valid_579215
  var valid_579216 = query.getOrDefault("fields")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "fields", valid_579216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579217: Call_AnalyticsManagementWebpropertiesGet_579205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web property to which the user has access.
  ## 
  let valid = call_579217.validator(path, query, header, formData, body)
  let scheme = call_579217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579217.url(scheme.get, call_579217.host, call_579217.base,
                         call_579217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579217, url, valid)

proc call*(call_579218: Call_AnalyticsManagementWebpropertiesGet_579205;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementWebpropertiesGet
  ## Gets a web property to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : ID to retrieve the web property for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the web property for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579219 = newJObject()
  var query_579220 = newJObject()
  add(query_579220, "key", newJString(key))
  add(query_579220, "prettyPrint", newJBool(prettyPrint))
  add(query_579220, "oauth_token", newJString(oauthToken))
  add(path_579219, "webPropertyId", newJString(webPropertyId))
  add(query_579220, "alt", newJString(alt))
  add(query_579220, "userIp", newJString(userIp))
  add(query_579220, "quotaUser", newJString(quotaUser))
  add(path_579219, "accountId", newJString(accountId))
  add(query_579220, "fields", newJString(fields))
  result = call_579218.call(path_579219, query_579220, nil, nil, nil)

var analyticsManagementWebpropertiesGet* = Call_AnalyticsManagementWebpropertiesGet_579205(
    name: "analyticsManagementWebpropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesGet_579206,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesGet_579207,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesPatch_579239 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertiesPatch_579241(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesPatch_579240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web property. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID
  ##   accountId: JString (required)
  ##            : Account ID to which the web property belongs
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579242 = path.getOrDefault("webPropertyId")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "webPropertyId", valid_579242
  var valid_579243 = path.getOrDefault("accountId")
  valid_579243 = validateParameter(valid_579243, JString, required = true,
                                 default = nil)
  if valid_579243 != nil:
    section.add "accountId", valid_579243
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579244 = query.getOrDefault("key")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "key", valid_579244
  var valid_579245 = query.getOrDefault("prettyPrint")
  valid_579245 = validateParameter(valid_579245, JBool, required = false,
                                 default = newJBool(false))
  if valid_579245 != nil:
    section.add "prettyPrint", valid_579245
  var valid_579246 = query.getOrDefault("oauth_token")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "oauth_token", valid_579246
  var valid_579247 = query.getOrDefault("alt")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = newJString("json"))
  if valid_579247 != nil:
    section.add "alt", valid_579247
  var valid_579248 = query.getOrDefault("userIp")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "userIp", valid_579248
  var valid_579249 = query.getOrDefault("quotaUser")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "quotaUser", valid_579249
  var valid_579250 = query.getOrDefault("fields")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "fields", valid_579250
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

proc call*(call_579252: Call_AnalyticsManagementWebpropertiesPatch_579239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property. This method supports patch semantics.
  ## 
  let valid = call_579252.validator(path, query, header, formData, body)
  let scheme = call_579252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579252.url(scheme.get, call_579252.host, call_579252.base,
                         call_579252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579252, url, valid)

proc call*(call_579253: Call_AnalyticsManagementWebpropertiesPatch_579239;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementWebpropertiesPatch
  ## Updates an existing web property. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which the web property belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579254 = newJObject()
  var query_579255 = newJObject()
  var body_579256 = newJObject()
  add(query_579255, "key", newJString(key))
  add(query_579255, "prettyPrint", newJBool(prettyPrint))
  add(query_579255, "oauth_token", newJString(oauthToken))
  add(path_579254, "webPropertyId", newJString(webPropertyId))
  add(query_579255, "alt", newJString(alt))
  add(query_579255, "userIp", newJString(userIp))
  add(query_579255, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579256 = body
  add(path_579254, "accountId", newJString(accountId))
  add(query_579255, "fields", newJString(fields))
  result = call_579253.call(path_579254, query_579255, nil, nil, body_579256)

var analyticsManagementWebpropertiesPatch* = Call_AnalyticsManagementWebpropertiesPatch_579239(
    name: "analyticsManagementWebpropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesPatch_579240,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesPatch_579241,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDataSourcesList_579257 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomDataSourcesList_579259(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/customDataSources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDataSourcesList_579258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List custom data sources to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the custom data sources to retrieve.
  ##   accountId: JString (required)
  ##            : Account Id for the custom data sources to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579260 = path.getOrDefault("webPropertyId")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "webPropertyId", valid_579260
  var valid_579261 = path.getOrDefault("accountId")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "accountId", valid_579261
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
  ##              : A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of custom data sources to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579262 = query.getOrDefault("key")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "key", valid_579262
  var valid_579263 = query.getOrDefault("prettyPrint")
  valid_579263 = validateParameter(valid_579263, JBool, required = false,
                                 default = newJBool(false))
  if valid_579263 != nil:
    section.add "prettyPrint", valid_579263
  var valid_579264 = query.getOrDefault("oauth_token")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "oauth_token", valid_579264
  var valid_579265 = query.getOrDefault("alt")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = newJString("json"))
  if valid_579265 != nil:
    section.add "alt", valid_579265
  var valid_579266 = query.getOrDefault("userIp")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "userIp", valid_579266
  var valid_579267 = query.getOrDefault("quotaUser")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "quotaUser", valid_579267
  var valid_579268 = query.getOrDefault("start-index")
  valid_579268 = validateParameter(valid_579268, JInt, required = false, default = nil)
  if valid_579268 != nil:
    section.add "start-index", valid_579268
  var valid_579269 = query.getOrDefault("max-results")
  valid_579269 = validateParameter(valid_579269, JInt, required = false, default = nil)
  if valid_579269 != nil:
    section.add "max-results", valid_579269
  var valid_579270 = query.getOrDefault("fields")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "fields", valid_579270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579271: Call_AnalyticsManagementCustomDataSourcesList_579257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List custom data sources to which the user has access.
  ## 
  let valid = call_579271.validator(path, query, header, formData, body)
  let scheme = call_579271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579271.url(scheme.get, call_579271.host, call_579271.base,
                         call_579271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579271, url, valid)

proc call*(call_579272: Call_AnalyticsManagementCustomDataSourcesList_579257;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementCustomDataSourcesList
  ## List custom data sources to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the custom data sources to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of custom data sources to include in this response.
  ##   accountId: string (required)
  ##            : Account Id for the custom data sources to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579273 = newJObject()
  var query_579274 = newJObject()
  add(query_579274, "key", newJString(key))
  add(query_579274, "prettyPrint", newJBool(prettyPrint))
  add(query_579274, "oauth_token", newJString(oauthToken))
  add(path_579273, "webPropertyId", newJString(webPropertyId))
  add(query_579274, "alt", newJString(alt))
  add(query_579274, "userIp", newJString(userIp))
  add(query_579274, "quotaUser", newJString(quotaUser))
  add(query_579274, "start-index", newJInt(startIndex))
  add(query_579274, "max-results", newJInt(maxResults))
  add(path_579273, "accountId", newJString(accountId))
  add(query_579274, "fields", newJString(fields))
  result = call_579272.call(path_579273, query_579274, nil, nil, nil)

var analyticsManagementCustomDataSourcesList* = Call_AnalyticsManagementCustomDataSourcesList_579257(
    name: "analyticsManagementCustomDataSourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources",
    validator: validate_AnalyticsManagementCustomDataSourcesList_579258,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDataSourcesList_579259,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsDeleteUploadData_579275 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUploadsDeleteUploadData_579277(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementUploadsDeleteUploadData_579276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete data associated with a previous upload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the uploads to be deleted.
  ##   accountId: JString (required)
  ##            : Account Id for the uploads to be deleted.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for the uploads to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579278 = path.getOrDefault("webPropertyId")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "webPropertyId", valid_579278
  var valid_579279 = path.getOrDefault("accountId")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "accountId", valid_579279
  var valid_579280 = path.getOrDefault("customDataSourceId")
  valid_579280 = validateParameter(valid_579280, JString, required = true,
                                 default = nil)
  if valid_579280 != nil:
    section.add "customDataSourceId", valid_579280
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579281 = query.getOrDefault("key")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "key", valid_579281
  var valid_579282 = query.getOrDefault("prettyPrint")
  valid_579282 = validateParameter(valid_579282, JBool, required = false,
                                 default = newJBool(false))
  if valid_579282 != nil:
    section.add "prettyPrint", valid_579282
  var valid_579283 = query.getOrDefault("oauth_token")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "oauth_token", valid_579283
  var valid_579284 = query.getOrDefault("alt")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = newJString("json"))
  if valid_579284 != nil:
    section.add "alt", valid_579284
  var valid_579285 = query.getOrDefault("userIp")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "userIp", valid_579285
  var valid_579286 = query.getOrDefault("quotaUser")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "quotaUser", valid_579286
  var valid_579287 = query.getOrDefault("fields")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "fields", valid_579287
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

proc call*(call_579289: Call_AnalyticsManagementUploadsDeleteUploadData_579275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete data associated with a previous upload.
  ## 
  let valid = call_579289.validator(path, query, header, formData, body)
  let scheme = call_579289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579289.url(scheme.get, call_579289.host, call_579289.base,
                         call_579289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579289, url, valid)

proc call*(call_579290: Call_AnalyticsManagementUploadsDeleteUploadData_579275;
          webPropertyId: string; accountId: string; customDataSourceId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementUploadsDeleteUploadData
  ## Delete data associated with a previous upload.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the uploads to be deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account Id for the uploads to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for the uploads to be deleted.
  var path_579291 = newJObject()
  var query_579292 = newJObject()
  var body_579293 = newJObject()
  add(query_579292, "key", newJString(key))
  add(query_579292, "prettyPrint", newJBool(prettyPrint))
  add(query_579292, "oauth_token", newJString(oauthToken))
  add(path_579291, "webPropertyId", newJString(webPropertyId))
  add(query_579292, "alt", newJString(alt))
  add(query_579292, "userIp", newJString(userIp))
  add(query_579292, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579293 = body
  add(path_579291, "accountId", newJString(accountId))
  add(query_579292, "fields", newJString(fields))
  add(path_579291, "customDataSourceId", newJString(customDataSourceId))
  result = call_579290.call(path_579291, query_579292, nil, nil, body_579293)

var analyticsManagementUploadsDeleteUploadData* = Call_AnalyticsManagementUploadsDeleteUploadData_579275(
    name: "analyticsManagementUploadsDeleteUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/deleteUploadData",
    validator: validate_AnalyticsManagementUploadsDeleteUploadData_579276,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsDeleteUploadData_579277,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsUploadData_579313 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUploadsUploadData_579315(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementUploadsUploadData_579314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload data for a custom data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property UA-string associated with the upload.
  ##   accountId: JString (required)
  ##            : Account Id associated with the upload.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id to which the data being uploaded belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579316 = path.getOrDefault("webPropertyId")
  valid_579316 = validateParameter(valid_579316, JString, required = true,
                                 default = nil)
  if valid_579316 != nil:
    section.add "webPropertyId", valid_579316
  var valid_579317 = path.getOrDefault("accountId")
  valid_579317 = validateParameter(valid_579317, JString, required = true,
                                 default = nil)
  if valid_579317 != nil:
    section.add "accountId", valid_579317
  var valid_579318 = path.getOrDefault("customDataSourceId")
  valid_579318 = validateParameter(valid_579318, JString, required = true,
                                 default = nil)
  if valid_579318 != nil:
    section.add "customDataSourceId", valid_579318
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579319 = query.getOrDefault("key")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "key", valid_579319
  var valid_579320 = query.getOrDefault("prettyPrint")
  valid_579320 = validateParameter(valid_579320, JBool, required = false,
                                 default = newJBool(false))
  if valid_579320 != nil:
    section.add "prettyPrint", valid_579320
  var valid_579321 = query.getOrDefault("oauth_token")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "oauth_token", valid_579321
  var valid_579322 = query.getOrDefault("alt")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = newJString("json"))
  if valid_579322 != nil:
    section.add "alt", valid_579322
  var valid_579323 = query.getOrDefault("userIp")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "userIp", valid_579323
  var valid_579324 = query.getOrDefault("quotaUser")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "quotaUser", valid_579324
  var valid_579325 = query.getOrDefault("fields")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "fields", valid_579325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579326: Call_AnalyticsManagementUploadsUploadData_579313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload data for a custom data source.
  ## 
  let valid = call_579326.validator(path, query, header, formData, body)
  let scheme = call_579326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579326.url(scheme.get, call_579326.host, call_579326.base,
                         call_579326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579326, url, valid)

proc call*(call_579327: Call_AnalyticsManagementUploadsUploadData_579313;
          webPropertyId: string; accountId: string; customDataSourceId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementUploadsUploadData
  ## Upload data for a custom data source.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property UA-string associated with the upload.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account Id associated with the upload.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id to which the data being uploaded belongs.
  var path_579328 = newJObject()
  var query_579329 = newJObject()
  add(query_579329, "key", newJString(key))
  add(query_579329, "prettyPrint", newJBool(prettyPrint))
  add(query_579329, "oauth_token", newJString(oauthToken))
  add(path_579328, "webPropertyId", newJString(webPropertyId))
  add(query_579329, "alt", newJString(alt))
  add(query_579329, "userIp", newJString(userIp))
  add(query_579329, "quotaUser", newJString(quotaUser))
  add(path_579328, "accountId", newJString(accountId))
  add(query_579329, "fields", newJString(fields))
  add(path_579328, "customDataSourceId", newJString(customDataSourceId))
  result = call_579327.call(path_579328, query_579329, nil, nil, nil)

var analyticsManagementUploadsUploadData* = Call_AnalyticsManagementUploadsUploadData_579313(
    name: "analyticsManagementUploadsUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsUploadData_579314,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsUploadData_579315,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsList_579294 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUploadsList_579296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementUploadsList_579295(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List uploads to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the uploads to retrieve.
  ##   accountId: JString (required)
  ##            : Account Id for the uploads to retrieve.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for uploads to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579297 = path.getOrDefault("webPropertyId")
  valid_579297 = validateParameter(valid_579297, JString, required = true,
                                 default = nil)
  if valid_579297 != nil:
    section.add "webPropertyId", valid_579297
  var valid_579298 = path.getOrDefault("accountId")
  valid_579298 = validateParameter(valid_579298, JString, required = true,
                                 default = nil)
  if valid_579298 != nil:
    section.add "accountId", valid_579298
  var valid_579299 = path.getOrDefault("customDataSourceId")
  valid_579299 = validateParameter(valid_579299, JString, required = true,
                                 default = nil)
  if valid_579299 != nil:
    section.add "customDataSourceId", valid_579299
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
  ##              : A 1-based index of the first upload to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of uploads to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579300 = query.getOrDefault("key")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "key", valid_579300
  var valid_579301 = query.getOrDefault("prettyPrint")
  valid_579301 = validateParameter(valid_579301, JBool, required = false,
                                 default = newJBool(false))
  if valid_579301 != nil:
    section.add "prettyPrint", valid_579301
  var valid_579302 = query.getOrDefault("oauth_token")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "oauth_token", valid_579302
  var valid_579303 = query.getOrDefault("alt")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = newJString("json"))
  if valid_579303 != nil:
    section.add "alt", valid_579303
  var valid_579304 = query.getOrDefault("userIp")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "userIp", valid_579304
  var valid_579305 = query.getOrDefault("quotaUser")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "quotaUser", valid_579305
  var valid_579306 = query.getOrDefault("start-index")
  valid_579306 = validateParameter(valid_579306, JInt, required = false, default = nil)
  if valid_579306 != nil:
    section.add "start-index", valid_579306
  var valid_579307 = query.getOrDefault("max-results")
  valid_579307 = validateParameter(valid_579307, JInt, required = false, default = nil)
  if valid_579307 != nil:
    section.add "max-results", valid_579307
  var valid_579308 = query.getOrDefault("fields")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "fields", valid_579308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579309: Call_AnalyticsManagementUploadsList_579294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_579309.validator(path, query, header, formData, body)
  let scheme = call_579309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579309.url(scheme.get, call_579309.host, call_579309.base,
                         call_579309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579309, url, valid)

proc call*(call_579310: Call_AnalyticsManagementUploadsList_579294;
          webPropertyId: string; accountId: string; customDataSourceId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementUploadsList
  ## List uploads to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the uploads to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : A 1-based index of the first upload to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of uploads to include in this response.
  ##   accountId: string (required)
  ##            : Account Id for the uploads to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for uploads to retrieve.
  var path_579311 = newJObject()
  var query_579312 = newJObject()
  add(query_579312, "key", newJString(key))
  add(query_579312, "prettyPrint", newJBool(prettyPrint))
  add(query_579312, "oauth_token", newJString(oauthToken))
  add(path_579311, "webPropertyId", newJString(webPropertyId))
  add(query_579312, "alt", newJString(alt))
  add(query_579312, "userIp", newJString(userIp))
  add(query_579312, "quotaUser", newJString(quotaUser))
  add(query_579312, "start-index", newJInt(startIndex))
  add(query_579312, "max-results", newJInt(maxResults))
  add(path_579311, "accountId", newJString(accountId))
  add(query_579312, "fields", newJString(fields))
  add(path_579311, "customDataSourceId", newJString(customDataSourceId))
  result = call_579310.call(path_579311, query_579312, nil, nil, nil)

var analyticsManagementUploadsList* = Call_AnalyticsManagementUploadsList_579294(
    name: "analyticsManagementUploadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsList_579295,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsList_579296,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsGet_579330 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUploadsGet_579332(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementUploadsGet_579331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List uploads to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the upload to retrieve.
  ##   accountId: JString (required)
  ##            : Account Id for the upload to retrieve.
  ##   uploadId: JString (required)
  ##           : Upload Id to retrieve.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for upload to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579333 = path.getOrDefault("webPropertyId")
  valid_579333 = validateParameter(valid_579333, JString, required = true,
                                 default = nil)
  if valid_579333 != nil:
    section.add "webPropertyId", valid_579333
  var valid_579334 = path.getOrDefault("accountId")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = nil)
  if valid_579334 != nil:
    section.add "accountId", valid_579334
  var valid_579335 = path.getOrDefault("uploadId")
  valid_579335 = validateParameter(valid_579335, JString, required = true,
                                 default = nil)
  if valid_579335 != nil:
    section.add "uploadId", valid_579335
  var valid_579336 = path.getOrDefault("customDataSourceId")
  valid_579336 = validateParameter(valid_579336, JString, required = true,
                                 default = nil)
  if valid_579336 != nil:
    section.add "customDataSourceId", valid_579336
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579337 = query.getOrDefault("key")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "key", valid_579337
  var valid_579338 = query.getOrDefault("prettyPrint")
  valid_579338 = validateParameter(valid_579338, JBool, required = false,
                                 default = newJBool(false))
  if valid_579338 != nil:
    section.add "prettyPrint", valid_579338
  var valid_579339 = query.getOrDefault("oauth_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "oauth_token", valid_579339
  var valid_579340 = query.getOrDefault("alt")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = newJString("json"))
  if valid_579340 != nil:
    section.add "alt", valid_579340
  var valid_579341 = query.getOrDefault("userIp")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "userIp", valid_579341
  var valid_579342 = query.getOrDefault("quotaUser")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "quotaUser", valid_579342
  var valid_579343 = query.getOrDefault("fields")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "fields", valid_579343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579344: Call_AnalyticsManagementUploadsGet_579330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_579344.validator(path, query, header, formData, body)
  let scheme = call_579344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579344.url(scheme.get, call_579344.host, call_579344.base,
                         call_579344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579344, url, valid)

proc call*(call_579345: Call_AnalyticsManagementUploadsGet_579330;
          webPropertyId: string; accountId: string; uploadId: string;
          customDataSourceId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementUploadsGet
  ## List uploads to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the upload to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account Id for the upload to retrieve.
  ##   uploadId: string (required)
  ##           : Upload Id to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for upload to retrieve.
  var path_579346 = newJObject()
  var query_579347 = newJObject()
  add(query_579347, "key", newJString(key))
  add(query_579347, "prettyPrint", newJBool(prettyPrint))
  add(query_579347, "oauth_token", newJString(oauthToken))
  add(path_579346, "webPropertyId", newJString(webPropertyId))
  add(query_579347, "alt", newJString(alt))
  add(query_579347, "userIp", newJString(userIp))
  add(query_579347, "quotaUser", newJString(quotaUser))
  add(path_579346, "accountId", newJString(accountId))
  add(path_579346, "uploadId", newJString(uploadId))
  add(query_579347, "fields", newJString(fields))
  add(path_579346, "customDataSourceId", newJString(customDataSourceId))
  result = call_579345.call(path_579346, query_579347, nil, nil, nil)

var analyticsManagementUploadsGet* = Call_AnalyticsManagementUploadsGet_579330(
    name: "analyticsManagementUploadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads/{uploadId}",
    validator: validate_AnalyticsManagementUploadsGet_579331,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsGet_579332,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsInsert_579366 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomDimensionsInsert_579368(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/customDimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsInsert_579367(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new custom dimension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to create.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579369 = path.getOrDefault("webPropertyId")
  valid_579369 = validateParameter(valid_579369, JString, required = true,
                                 default = nil)
  if valid_579369 != nil:
    section.add "webPropertyId", valid_579369
  var valid_579370 = path.getOrDefault("accountId")
  valid_579370 = validateParameter(valid_579370, JString, required = true,
                                 default = nil)
  if valid_579370 != nil:
    section.add "accountId", valid_579370
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579371 = query.getOrDefault("key")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "key", valid_579371
  var valid_579372 = query.getOrDefault("prettyPrint")
  valid_579372 = validateParameter(valid_579372, JBool, required = false,
                                 default = newJBool(false))
  if valid_579372 != nil:
    section.add "prettyPrint", valid_579372
  var valid_579373 = query.getOrDefault("oauth_token")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "oauth_token", valid_579373
  var valid_579374 = query.getOrDefault("alt")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = newJString("json"))
  if valid_579374 != nil:
    section.add "alt", valid_579374
  var valid_579375 = query.getOrDefault("userIp")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "userIp", valid_579375
  var valid_579376 = query.getOrDefault("quotaUser")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "quotaUser", valid_579376
  var valid_579377 = query.getOrDefault("fields")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "fields", valid_579377
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

proc call*(call_579379: Call_AnalyticsManagementCustomDimensionsInsert_579366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom dimension.
  ## 
  let valid = call_579379.validator(path, query, header, formData, body)
  let scheme = call_579379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579379.url(scheme.get, call_579379.host, call_579379.base,
                         call_579379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579379, url, valid)

proc call*(call_579380: Call_AnalyticsManagementCustomDimensionsInsert_579366;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementCustomDimensionsInsert
  ## Create a new custom dimension.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to create.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to create.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579381 = newJObject()
  var query_579382 = newJObject()
  var body_579383 = newJObject()
  add(query_579382, "key", newJString(key))
  add(query_579382, "prettyPrint", newJBool(prettyPrint))
  add(query_579382, "oauth_token", newJString(oauthToken))
  add(path_579381, "webPropertyId", newJString(webPropertyId))
  add(query_579382, "alt", newJString(alt))
  add(query_579382, "userIp", newJString(userIp))
  add(query_579382, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579383 = body
  add(path_579381, "accountId", newJString(accountId))
  add(query_579382, "fields", newJString(fields))
  result = call_579380.call(path_579381, query_579382, nil, nil, body_579383)

var analyticsManagementCustomDimensionsInsert* = Call_AnalyticsManagementCustomDimensionsInsert_579366(
    name: "analyticsManagementCustomDimensionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsInsert_579367,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsInsert_579368,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsList_579348 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomDimensionsList_579350(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/customDimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsList_579349(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists custom dimensions to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimensions to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimensions to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579351 = path.getOrDefault("webPropertyId")
  valid_579351 = validateParameter(valid_579351, JString, required = true,
                                 default = nil)
  if valid_579351 != nil:
    section.add "webPropertyId", valid_579351
  var valid_579352 = path.getOrDefault("accountId")
  valid_579352 = validateParameter(valid_579352, JString, required = true,
                                 default = nil)
  if valid_579352 != nil:
    section.add "accountId", valid_579352
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
  ##              : The maximum number of custom dimensions to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579353 = query.getOrDefault("key")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "key", valid_579353
  var valid_579354 = query.getOrDefault("prettyPrint")
  valid_579354 = validateParameter(valid_579354, JBool, required = false,
                                 default = newJBool(false))
  if valid_579354 != nil:
    section.add "prettyPrint", valid_579354
  var valid_579355 = query.getOrDefault("oauth_token")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "oauth_token", valid_579355
  var valid_579356 = query.getOrDefault("alt")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = newJString("json"))
  if valid_579356 != nil:
    section.add "alt", valid_579356
  var valid_579357 = query.getOrDefault("userIp")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "userIp", valid_579357
  var valid_579358 = query.getOrDefault("quotaUser")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "quotaUser", valid_579358
  var valid_579359 = query.getOrDefault("start-index")
  valid_579359 = validateParameter(valid_579359, JInt, required = false, default = nil)
  if valid_579359 != nil:
    section.add "start-index", valid_579359
  var valid_579360 = query.getOrDefault("max-results")
  valid_579360 = validateParameter(valid_579360, JInt, required = false, default = nil)
  if valid_579360 != nil:
    section.add "max-results", valid_579360
  var valid_579361 = query.getOrDefault("fields")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "fields", valid_579361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579362: Call_AnalyticsManagementCustomDimensionsList_579348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom dimensions to which the user has access.
  ## 
  let valid = call_579362.validator(path, query, header, formData, body)
  let scheme = call_579362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579362.url(scheme.get, call_579362.host, call_579362.base,
                         call_579362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579362, url, valid)

proc call*(call_579363: Call_AnalyticsManagementCustomDimensionsList_579348;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementCustomDimensionsList
  ## Lists custom dimensions to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimensions to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of custom dimensions to include in this response.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimensions to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579364 = newJObject()
  var query_579365 = newJObject()
  add(query_579365, "key", newJString(key))
  add(query_579365, "prettyPrint", newJBool(prettyPrint))
  add(query_579365, "oauth_token", newJString(oauthToken))
  add(path_579364, "webPropertyId", newJString(webPropertyId))
  add(query_579365, "alt", newJString(alt))
  add(query_579365, "userIp", newJString(userIp))
  add(query_579365, "quotaUser", newJString(quotaUser))
  add(query_579365, "start-index", newJInt(startIndex))
  add(query_579365, "max-results", newJInt(maxResults))
  add(path_579364, "accountId", newJString(accountId))
  add(query_579365, "fields", newJString(fields))
  result = call_579363.call(path_579364, query_579365, nil, nil, nil)

var analyticsManagementCustomDimensionsList* = Call_AnalyticsManagementCustomDimensionsList_579348(
    name: "analyticsManagementCustomDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsList_579349,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsList_579350,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsUpdate_579401 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomDimensionsUpdate_579403(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementCustomDimensionsUpdate_579402(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom dimension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to update.
  ##   customDimensionId: JString (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579404 = path.getOrDefault("webPropertyId")
  valid_579404 = validateParameter(valid_579404, JString, required = true,
                                 default = nil)
  if valid_579404 != nil:
    section.add "webPropertyId", valid_579404
  var valid_579405 = path.getOrDefault("accountId")
  valid_579405 = validateParameter(valid_579405, JString, required = true,
                                 default = nil)
  if valid_579405 != nil:
    section.add "accountId", valid_579405
  var valid_579406 = path.getOrDefault("customDimensionId")
  valid_579406 = validateParameter(valid_579406, JString, required = true,
                                 default = nil)
  if valid_579406 != nil:
    section.add "customDimensionId", valid_579406
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
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579407 = query.getOrDefault("key")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "key", valid_579407
  var valid_579408 = query.getOrDefault("prettyPrint")
  valid_579408 = validateParameter(valid_579408, JBool, required = false,
                                 default = newJBool(false))
  if valid_579408 != nil:
    section.add "prettyPrint", valid_579408
  var valid_579409 = query.getOrDefault("oauth_token")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "oauth_token", valid_579409
  var valid_579410 = query.getOrDefault("alt")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = newJString("json"))
  if valid_579410 != nil:
    section.add "alt", valid_579410
  var valid_579411 = query.getOrDefault("userIp")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "userIp", valid_579411
  var valid_579412 = query.getOrDefault("quotaUser")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "quotaUser", valid_579412
  var valid_579413 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_579413 = validateParameter(valid_579413, JBool, required = false,
                                 default = newJBool(false))
  if valid_579413 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_579413
  var valid_579414 = query.getOrDefault("fields")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "fields", valid_579414
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

proc call*(call_579416: Call_AnalyticsManagementCustomDimensionsUpdate_579401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension.
  ## 
  let valid = call_579416.validator(path, query, header, formData, body)
  let scheme = call_579416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579416.url(scheme.get, call_579416.host, call_579416.base,
                         call_579416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579416, url, valid)

proc call*(call_579417: Call_AnalyticsManagementCustomDimensionsUpdate_579401;
          webPropertyId: string; accountId: string; customDimensionId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; ignoreCustomDataSourceLinks: bool = false;
          fields: string = ""): Recallable =
  ## analyticsManagementCustomDimensionsUpdate
  ## Updates an existing custom dimension.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to update.
  ##   customDimensionId: string (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579418 = newJObject()
  var query_579419 = newJObject()
  var body_579420 = newJObject()
  add(query_579419, "key", newJString(key))
  add(query_579419, "prettyPrint", newJBool(prettyPrint))
  add(query_579419, "oauth_token", newJString(oauthToken))
  add(path_579418, "webPropertyId", newJString(webPropertyId))
  add(query_579419, "alt", newJString(alt))
  add(query_579419, "userIp", newJString(userIp))
  add(query_579419, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579420 = body
  add(path_579418, "accountId", newJString(accountId))
  add(path_579418, "customDimensionId", newJString(customDimensionId))
  add(query_579419, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_579419, "fields", newJString(fields))
  result = call_579417.call(path_579418, query_579419, nil, nil, body_579420)

var analyticsManagementCustomDimensionsUpdate* = Call_AnalyticsManagementCustomDimensionsUpdate_579401(
    name: "analyticsManagementCustomDimensionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsUpdate_579402,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsUpdate_579403,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsGet_579384 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomDimensionsGet_579386(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementCustomDimensionsGet_579385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a custom dimension to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to retrieve.
  ##   customDimensionId: JString (required)
  ##                    : The ID of the custom dimension to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579387 = path.getOrDefault("webPropertyId")
  valid_579387 = validateParameter(valid_579387, JString, required = true,
                                 default = nil)
  if valid_579387 != nil:
    section.add "webPropertyId", valid_579387
  var valid_579388 = path.getOrDefault("accountId")
  valid_579388 = validateParameter(valid_579388, JString, required = true,
                                 default = nil)
  if valid_579388 != nil:
    section.add "accountId", valid_579388
  var valid_579389 = path.getOrDefault("customDimensionId")
  valid_579389 = validateParameter(valid_579389, JString, required = true,
                                 default = nil)
  if valid_579389 != nil:
    section.add "customDimensionId", valid_579389
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579390 = query.getOrDefault("key")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "key", valid_579390
  var valid_579391 = query.getOrDefault("prettyPrint")
  valid_579391 = validateParameter(valid_579391, JBool, required = false,
                                 default = newJBool(false))
  if valid_579391 != nil:
    section.add "prettyPrint", valid_579391
  var valid_579392 = query.getOrDefault("oauth_token")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "oauth_token", valid_579392
  var valid_579393 = query.getOrDefault("alt")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = newJString("json"))
  if valid_579393 != nil:
    section.add "alt", valid_579393
  var valid_579394 = query.getOrDefault("userIp")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "userIp", valid_579394
  var valid_579395 = query.getOrDefault("quotaUser")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "quotaUser", valid_579395
  var valid_579396 = query.getOrDefault("fields")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "fields", valid_579396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579397: Call_AnalyticsManagementCustomDimensionsGet_579384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom dimension to which the user has access.
  ## 
  let valid = call_579397.validator(path, query, header, formData, body)
  let scheme = call_579397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579397.url(scheme.get, call_579397.host, call_579397.base,
                         call_579397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579397, url, valid)

proc call*(call_579398: Call_AnalyticsManagementCustomDimensionsGet_579384;
          webPropertyId: string; accountId: string; customDimensionId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementCustomDimensionsGet
  ## Get a custom dimension to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to retrieve.
  ##   customDimensionId: string (required)
  ##                    : The ID of the custom dimension to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579399 = newJObject()
  var query_579400 = newJObject()
  add(query_579400, "key", newJString(key))
  add(query_579400, "prettyPrint", newJBool(prettyPrint))
  add(query_579400, "oauth_token", newJString(oauthToken))
  add(path_579399, "webPropertyId", newJString(webPropertyId))
  add(query_579400, "alt", newJString(alt))
  add(query_579400, "userIp", newJString(userIp))
  add(query_579400, "quotaUser", newJString(quotaUser))
  add(path_579399, "accountId", newJString(accountId))
  add(path_579399, "customDimensionId", newJString(customDimensionId))
  add(query_579400, "fields", newJString(fields))
  result = call_579398.call(path_579399, query_579400, nil, nil, nil)

var analyticsManagementCustomDimensionsGet* = Call_AnalyticsManagementCustomDimensionsGet_579384(
    name: "analyticsManagementCustomDimensionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsGet_579385,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsGet_579386,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsPatch_579421 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomDimensionsPatch_579423(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementCustomDimensionsPatch_579422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom dimension. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to update.
  ##   customDimensionId: JString (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579424 = path.getOrDefault("webPropertyId")
  valid_579424 = validateParameter(valid_579424, JString, required = true,
                                 default = nil)
  if valid_579424 != nil:
    section.add "webPropertyId", valid_579424
  var valid_579425 = path.getOrDefault("accountId")
  valid_579425 = validateParameter(valid_579425, JString, required = true,
                                 default = nil)
  if valid_579425 != nil:
    section.add "accountId", valid_579425
  var valid_579426 = path.getOrDefault("customDimensionId")
  valid_579426 = validateParameter(valid_579426, JString, required = true,
                                 default = nil)
  if valid_579426 != nil:
    section.add "customDimensionId", valid_579426
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
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579427 = query.getOrDefault("key")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "key", valid_579427
  var valid_579428 = query.getOrDefault("prettyPrint")
  valid_579428 = validateParameter(valid_579428, JBool, required = false,
                                 default = newJBool(false))
  if valid_579428 != nil:
    section.add "prettyPrint", valid_579428
  var valid_579429 = query.getOrDefault("oauth_token")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "oauth_token", valid_579429
  var valid_579430 = query.getOrDefault("alt")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = newJString("json"))
  if valid_579430 != nil:
    section.add "alt", valid_579430
  var valid_579431 = query.getOrDefault("userIp")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "userIp", valid_579431
  var valid_579432 = query.getOrDefault("quotaUser")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "quotaUser", valid_579432
  var valid_579433 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_579433 = validateParameter(valid_579433, JBool, required = false,
                                 default = newJBool(false))
  if valid_579433 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_579433
  var valid_579434 = query.getOrDefault("fields")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "fields", valid_579434
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

proc call*(call_579436: Call_AnalyticsManagementCustomDimensionsPatch_579421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension. This method supports patch semantics.
  ## 
  let valid = call_579436.validator(path, query, header, formData, body)
  let scheme = call_579436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579436.url(scheme.get, call_579436.host, call_579436.base,
                         call_579436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579436, url, valid)

proc call*(call_579437: Call_AnalyticsManagementCustomDimensionsPatch_579421;
          webPropertyId: string; accountId: string; customDimensionId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; ignoreCustomDataSourceLinks: bool = false;
          fields: string = ""): Recallable =
  ## analyticsManagementCustomDimensionsPatch
  ## Updates an existing custom dimension. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to update.
  ##   customDimensionId: string (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579438 = newJObject()
  var query_579439 = newJObject()
  var body_579440 = newJObject()
  add(query_579439, "key", newJString(key))
  add(query_579439, "prettyPrint", newJBool(prettyPrint))
  add(query_579439, "oauth_token", newJString(oauthToken))
  add(path_579438, "webPropertyId", newJString(webPropertyId))
  add(query_579439, "alt", newJString(alt))
  add(query_579439, "userIp", newJString(userIp))
  add(query_579439, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579440 = body
  add(path_579438, "accountId", newJString(accountId))
  add(path_579438, "customDimensionId", newJString(customDimensionId))
  add(query_579439, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_579439, "fields", newJString(fields))
  result = call_579437.call(path_579438, query_579439, nil, nil, body_579440)

var analyticsManagementCustomDimensionsPatch* = Call_AnalyticsManagementCustomDimensionsPatch_579421(
    name: "analyticsManagementCustomDimensionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsPatch_579422,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsPatch_579423,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsInsert_579459 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomMetricsInsert_579461(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/customMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsInsert_579460(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new custom metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to create.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to create.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579462 = path.getOrDefault("webPropertyId")
  valid_579462 = validateParameter(valid_579462, JString, required = true,
                                 default = nil)
  if valid_579462 != nil:
    section.add "webPropertyId", valid_579462
  var valid_579463 = path.getOrDefault("accountId")
  valid_579463 = validateParameter(valid_579463, JString, required = true,
                                 default = nil)
  if valid_579463 != nil:
    section.add "accountId", valid_579463
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579464 = query.getOrDefault("key")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "key", valid_579464
  var valid_579465 = query.getOrDefault("prettyPrint")
  valid_579465 = validateParameter(valid_579465, JBool, required = false,
                                 default = newJBool(false))
  if valid_579465 != nil:
    section.add "prettyPrint", valid_579465
  var valid_579466 = query.getOrDefault("oauth_token")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "oauth_token", valid_579466
  var valid_579467 = query.getOrDefault("alt")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = newJString("json"))
  if valid_579467 != nil:
    section.add "alt", valid_579467
  var valid_579468 = query.getOrDefault("userIp")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "userIp", valid_579468
  var valid_579469 = query.getOrDefault("quotaUser")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "quotaUser", valid_579469
  var valid_579470 = query.getOrDefault("fields")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "fields", valid_579470
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

proc call*(call_579472: Call_AnalyticsManagementCustomMetricsInsert_579459;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom metric.
  ## 
  let valid = call_579472.validator(path, query, header, formData, body)
  let scheme = call_579472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579472.url(scheme.get, call_579472.host, call_579472.base,
                         call_579472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579472, url, valid)

proc call*(call_579473: Call_AnalyticsManagementCustomMetricsInsert_579459;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementCustomMetricsInsert
  ## Create a new custom metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to create.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to create.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579474 = newJObject()
  var query_579475 = newJObject()
  var body_579476 = newJObject()
  add(query_579475, "key", newJString(key))
  add(query_579475, "prettyPrint", newJBool(prettyPrint))
  add(query_579475, "oauth_token", newJString(oauthToken))
  add(path_579474, "webPropertyId", newJString(webPropertyId))
  add(query_579475, "alt", newJString(alt))
  add(query_579475, "userIp", newJString(userIp))
  add(query_579475, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579476 = body
  add(path_579474, "accountId", newJString(accountId))
  add(query_579475, "fields", newJString(fields))
  result = call_579473.call(path_579474, query_579475, nil, nil, body_579476)

var analyticsManagementCustomMetricsInsert* = Call_AnalyticsManagementCustomMetricsInsert_579459(
    name: "analyticsManagementCustomMetricsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsInsert_579460,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsInsert_579461,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsList_579441 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomMetricsList_579443(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/customMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsList_579442(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists custom metrics to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metrics to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metrics to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579444 = path.getOrDefault("webPropertyId")
  valid_579444 = validateParameter(valid_579444, JString, required = true,
                                 default = nil)
  if valid_579444 != nil:
    section.add "webPropertyId", valid_579444
  var valid_579445 = path.getOrDefault("accountId")
  valid_579445 = validateParameter(valid_579445, JString, required = true,
                                 default = nil)
  if valid_579445 != nil:
    section.add "accountId", valid_579445
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
  ##              : The maximum number of custom metrics to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579446 = query.getOrDefault("key")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "key", valid_579446
  var valid_579447 = query.getOrDefault("prettyPrint")
  valid_579447 = validateParameter(valid_579447, JBool, required = false,
                                 default = newJBool(false))
  if valid_579447 != nil:
    section.add "prettyPrint", valid_579447
  var valid_579448 = query.getOrDefault("oauth_token")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "oauth_token", valid_579448
  var valid_579449 = query.getOrDefault("alt")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = newJString("json"))
  if valid_579449 != nil:
    section.add "alt", valid_579449
  var valid_579450 = query.getOrDefault("userIp")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "userIp", valid_579450
  var valid_579451 = query.getOrDefault("quotaUser")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "quotaUser", valid_579451
  var valid_579452 = query.getOrDefault("start-index")
  valid_579452 = validateParameter(valid_579452, JInt, required = false, default = nil)
  if valid_579452 != nil:
    section.add "start-index", valid_579452
  var valid_579453 = query.getOrDefault("max-results")
  valid_579453 = validateParameter(valid_579453, JInt, required = false, default = nil)
  if valid_579453 != nil:
    section.add "max-results", valid_579453
  var valid_579454 = query.getOrDefault("fields")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "fields", valid_579454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579455: Call_AnalyticsManagementCustomMetricsList_579441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom metrics to which the user has access.
  ## 
  let valid = call_579455.validator(path, query, header, formData, body)
  let scheme = call_579455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579455.url(scheme.get, call_579455.host, call_579455.base,
                         call_579455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579455, url, valid)

proc call*(call_579456: Call_AnalyticsManagementCustomMetricsList_579441;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementCustomMetricsList
  ## Lists custom metrics to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metrics to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of custom metrics to include in this response.
  ##   accountId: string (required)
  ##            : Account ID for the custom metrics to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579457 = newJObject()
  var query_579458 = newJObject()
  add(query_579458, "key", newJString(key))
  add(query_579458, "prettyPrint", newJBool(prettyPrint))
  add(query_579458, "oauth_token", newJString(oauthToken))
  add(path_579457, "webPropertyId", newJString(webPropertyId))
  add(query_579458, "alt", newJString(alt))
  add(query_579458, "userIp", newJString(userIp))
  add(query_579458, "quotaUser", newJString(quotaUser))
  add(query_579458, "start-index", newJInt(startIndex))
  add(query_579458, "max-results", newJInt(maxResults))
  add(path_579457, "accountId", newJString(accountId))
  add(query_579458, "fields", newJString(fields))
  result = call_579456.call(path_579457, query_579458, nil, nil, nil)

var analyticsManagementCustomMetricsList* = Call_AnalyticsManagementCustomMetricsList_579441(
    name: "analyticsManagementCustomMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsList_579442,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsList_579443,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsUpdate_579494 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomMetricsUpdate_579496(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementCustomMetricsUpdate_579495(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to update.
  ##   customMetricId: JString (required)
  ##                 : Custom metric ID for the custom metric to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579497 = path.getOrDefault("webPropertyId")
  valid_579497 = validateParameter(valid_579497, JString, required = true,
                                 default = nil)
  if valid_579497 != nil:
    section.add "webPropertyId", valid_579497
  var valid_579498 = path.getOrDefault("accountId")
  valid_579498 = validateParameter(valid_579498, JString, required = true,
                                 default = nil)
  if valid_579498 != nil:
    section.add "accountId", valid_579498
  var valid_579499 = path.getOrDefault("customMetricId")
  valid_579499 = validateParameter(valid_579499, JString, required = true,
                                 default = nil)
  if valid_579499 != nil:
    section.add "customMetricId", valid_579499
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
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579500 = query.getOrDefault("key")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "key", valid_579500
  var valid_579501 = query.getOrDefault("prettyPrint")
  valid_579501 = validateParameter(valid_579501, JBool, required = false,
                                 default = newJBool(false))
  if valid_579501 != nil:
    section.add "prettyPrint", valid_579501
  var valid_579502 = query.getOrDefault("oauth_token")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "oauth_token", valid_579502
  var valid_579503 = query.getOrDefault("alt")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = newJString("json"))
  if valid_579503 != nil:
    section.add "alt", valid_579503
  var valid_579504 = query.getOrDefault("userIp")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = nil)
  if valid_579504 != nil:
    section.add "userIp", valid_579504
  var valid_579505 = query.getOrDefault("quotaUser")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "quotaUser", valid_579505
  var valid_579506 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_579506 = validateParameter(valid_579506, JBool, required = false,
                                 default = newJBool(false))
  if valid_579506 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_579506
  var valid_579507 = query.getOrDefault("fields")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "fields", valid_579507
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

proc call*(call_579509: Call_AnalyticsManagementCustomMetricsUpdate_579494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric.
  ## 
  let valid = call_579509.validator(path, query, header, formData, body)
  let scheme = call_579509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579509.url(scheme.get, call_579509.host, call_579509.base,
                         call_579509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579509, url, valid)

proc call*(call_579510: Call_AnalyticsManagementCustomMetricsUpdate_579494;
          webPropertyId: string; accountId: string; customMetricId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; ignoreCustomDataSourceLinks: bool = false;
          fields: string = ""): Recallable =
  ## analyticsManagementCustomMetricsUpdate
  ## Updates an existing custom metric.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to update.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customMetricId: string (required)
  ##                 : Custom metric ID for the custom metric to update.
  var path_579511 = newJObject()
  var query_579512 = newJObject()
  var body_579513 = newJObject()
  add(query_579512, "key", newJString(key))
  add(query_579512, "prettyPrint", newJBool(prettyPrint))
  add(query_579512, "oauth_token", newJString(oauthToken))
  add(path_579511, "webPropertyId", newJString(webPropertyId))
  add(query_579512, "alt", newJString(alt))
  add(query_579512, "userIp", newJString(userIp))
  add(query_579512, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579513 = body
  add(path_579511, "accountId", newJString(accountId))
  add(query_579512, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_579512, "fields", newJString(fields))
  add(path_579511, "customMetricId", newJString(customMetricId))
  result = call_579510.call(path_579511, query_579512, nil, nil, body_579513)

var analyticsManagementCustomMetricsUpdate* = Call_AnalyticsManagementCustomMetricsUpdate_579494(
    name: "analyticsManagementCustomMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsUpdate_579495,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsUpdate_579496,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsGet_579477 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomMetricsGet_579479(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementCustomMetricsGet_579478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a custom metric to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to retrieve.
  ##   customMetricId: JString (required)
  ##                 : The ID of the custom metric to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579480 = path.getOrDefault("webPropertyId")
  valid_579480 = validateParameter(valid_579480, JString, required = true,
                                 default = nil)
  if valid_579480 != nil:
    section.add "webPropertyId", valid_579480
  var valid_579481 = path.getOrDefault("accountId")
  valid_579481 = validateParameter(valid_579481, JString, required = true,
                                 default = nil)
  if valid_579481 != nil:
    section.add "accountId", valid_579481
  var valid_579482 = path.getOrDefault("customMetricId")
  valid_579482 = validateParameter(valid_579482, JString, required = true,
                                 default = nil)
  if valid_579482 != nil:
    section.add "customMetricId", valid_579482
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579483 = query.getOrDefault("key")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "key", valid_579483
  var valid_579484 = query.getOrDefault("prettyPrint")
  valid_579484 = validateParameter(valid_579484, JBool, required = false,
                                 default = newJBool(false))
  if valid_579484 != nil:
    section.add "prettyPrint", valid_579484
  var valid_579485 = query.getOrDefault("oauth_token")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "oauth_token", valid_579485
  var valid_579486 = query.getOrDefault("alt")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = newJString("json"))
  if valid_579486 != nil:
    section.add "alt", valid_579486
  var valid_579487 = query.getOrDefault("userIp")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "userIp", valid_579487
  var valid_579488 = query.getOrDefault("quotaUser")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "quotaUser", valid_579488
  var valid_579489 = query.getOrDefault("fields")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "fields", valid_579489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579490: Call_AnalyticsManagementCustomMetricsGet_579477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom metric to which the user has access.
  ## 
  let valid = call_579490.validator(path, query, header, formData, body)
  let scheme = call_579490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579490.url(scheme.get, call_579490.host, call_579490.base,
                         call_579490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579490, url, valid)

proc call*(call_579491: Call_AnalyticsManagementCustomMetricsGet_579477;
          webPropertyId: string; accountId: string; customMetricId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementCustomMetricsGet
  ## Get a custom metric to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customMetricId: string (required)
  ##                 : The ID of the custom metric to retrieve.
  var path_579492 = newJObject()
  var query_579493 = newJObject()
  add(query_579493, "key", newJString(key))
  add(query_579493, "prettyPrint", newJBool(prettyPrint))
  add(query_579493, "oauth_token", newJString(oauthToken))
  add(path_579492, "webPropertyId", newJString(webPropertyId))
  add(query_579493, "alt", newJString(alt))
  add(query_579493, "userIp", newJString(userIp))
  add(query_579493, "quotaUser", newJString(quotaUser))
  add(path_579492, "accountId", newJString(accountId))
  add(query_579493, "fields", newJString(fields))
  add(path_579492, "customMetricId", newJString(customMetricId))
  result = call_579491.call(path_579492, query_579493, nil, nil, nil)

var analyticsManagementCustomMetricsGet* = Call_AnalyticsManagementCustomMetricsGet_579477(
    name: "analyticsManagementCustomMetricsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsGet_579478,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsGet_579479,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsPatch_579514 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementCustomMetricsPatch_579516(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementCustomMetricsPatch_579515(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom metric. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to update.
  ##   customMetricId: JString (required)
  ##                 : Custom metric ID for the custom metric to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579517 = path.getOrDefault("webPropertyId")
  valid_579517 = validateParameter(valid_579517, JString, required = true,
                                 default = nil)
  if valid_579517 != nil:
    section.add "webPropertyId", valid_579517
  var valid_579518 = path.getOrDefault("accountId")
  valid_579518 = validateParameter(valid_579518, JString, required = true,
                                 default = nil)
  if valid_579518 != nil:
    section.add "accountId", valid_579518
  var valid_579519 = path.getOrDefault("customMetricId")
  valid_579519 = validateParameter(valid_579519, JString, required = true,
                                 default = nil)
  if valid_579519 != nil:
    section.add "customMetricId", valid_579519
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
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579520 = query.getOrDefault("key")
  valid_579520 = validateParameter(valid_579520, JString, required = false,
                                 default = nil)
  if valid_579520 != nil:
    section.add "key", valid_579520
  var valid_579521 = query.getOrDefault("prettyPrint")
  valid_579521 = validateParameter(valid_579521, JBool, required = false,
                                 default = newJBool(false))
  if valid_579521 != nil:
    section.add "prettyPrint", valid_579521
  var valid_579522 = query.getOrDefault("oauth_token")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = nil)
  if valid_579522 != nil:
    section.add "oauth_token", valid_579522
  var valid_579523 = query.getOrDefault("alt")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = newJString("json"))
  if valid_579523 != nil:
    section.add "alt", valid_579523
  var valid_579524 = query.getOrDefault("userIp")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = nil)
  if valid_579524 != nil:
    section.add "userIp", valid_579524
  var valid_579525 = query.getOrDefault("quotaUser")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "quotaUser", valid_579525
  var valid_579526 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_579526 = validateParameter(valid_579526, JBool, required = false,
                                 default = newJBool(false))
  if valid_579526 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_579526
  var valid_579527 = query.getOrDefault("fields")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "fields", valid_579527
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

proc call*(call_579529: Call_AnalyticsManagementCustomMetricsPatch_579514;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric. This method supports patch semantics.
  ## 
  let valid = call_579529.validator(path, query, header, formData, body)
  let scheme = call_579529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579529.url(scheme.get, call_579529.host, call_579529.base,
                         call_579529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579529, url, valid)

proc call*(call_579530: Call_AnalyticsManagementCustomMetricsPatch_579514;
          webPropertyId: string; accountId: string; customMetricId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; ignoreCustomDataSourceLinks: bool = false;
          fields: string = ""): Recallable =
  ## analyticsManagementCustomMetricsPatch
  ## Updates an existing custom metric. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to update.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customMetricId: string (required)
  ##                 : Custom metric ID for the custom metric to update.
  var path_579531 = newJObject()
  var query_579532 = newJObject()
  var body_579533 = newJObject()
  add(query_579532, "key", newJString(key))
  add(query_579532, "prettyPrint", newJBool(prettyPrint))
  add(query_579532, "oauth_token", newJString(oauthToken))
  add(path_579531, "webPropertyId", newJString(webPropertyId))
  add(query_579532, "alt", newJString(alt))
  add(query_579532, "userIp", newJString(userIp))
  add(query_579532, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579533 = body
  add(path_579531, "accountId", newJString(accountId))
  add(query_579532, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_579532, "fields", newJString(fields))
  add(path_579531, "customMetricId", newJString(customMetricId))
  result = call_579530.call(path_579531, query_579532, nil, nil, body_579533)

var analyticsManagementCustomMetricsPatch* = Call_AnalyticsManagementCustomMetricsPatch_579514(
    name: "analyticsManagementCustomMetricsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsPatch_579515,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsPatch_579516,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_579552 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebPropertyAdWordsLinksInsert_579554(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/entityAdWordsLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_579553(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a webProperty-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the link for.
  ##   accountId: JString (required)
  ##            : ID of the Google Analytics account to create the link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579555 = path.getOrDefault("webPropertyId")
  valid_579555 = validateParameter(valid_579555, JString, required = true,
                                 default = nil)
  if valid_579555 != nil:
    section.add "webPropertyId", valid_579555
  var valid_579556 = path.getOrDefault("accountId")
  valid_579556 = validateParameter(valid_579556, JString, required = true,
                                 default = nil)
  if valid_579556 != nil:
    section.add "accountId", valid_579556
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579557 = query.getOrDefault("key")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "key", valid_579557
  var valid_579558 = query.getOrDefault("prettyPrint")
  valid_579558 = validateParameter(valid_579558, JBool, required = false,
                                 default = newJBool(false))
  if valid_579558 != nil:
    section.add "prettyPrint", valid_579558
  var valid_579559 = query.getOrDefault("oauth_token")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "oauth_token", valid_579559
  var valid_579560 = query.getOrDefault("alt")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = newJString("json"))
  if valid_579560 != nil:
    section.add "alt", valid_579560
  var valid_579561 = query.getOrDefault("userIp")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "userIp", valid_579561
  var valid_579562 = query.getOrDefault("quotaUser")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "quotaUser", valid_579562
  var valid_579563 = query.getOrDefault("fields")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "fields", valid_579563
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

proc call*(call_579565: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_579552;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a webProperty-Google Ads link.
  ## 
  let valid = call_579565.validator(path, query, header, formData, body)
  let scheme = call_579565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579565.url(scheme.get, call_579565.host, call_579565.base,
                         call_579565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579565, url, valid)

proc call*(call_579566: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_579552;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksInsert
  ## Creates a webProperty-Google Ads link.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : ID of the Google Analytics account to create the link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579567 = newJObject()
  var query_579568 = newJObject()
  var body_579569 = newJObject()
  add(query_579568, "key", newJString(key))
  add(query_579568, "prettyPrint", newJBool(prettyPrint))
  add(query_579568, "oauth_token", newJString(oauthToken))
  add(path_579567, "webPropertyId", newJString(webPropertyId))
  add(query_579568, "alt", newJString(alt))
  add(query_579568, "userIp", newJString(userIp))
  add(query_579568, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579569 = body
  add(path_579567, "accountId", newJString(accountId))
  add(query_579568, "fields", newJString(fields))
  result = call_579566.call(path_579567, query_579568, nil, nil, body_579569)

var analyticsManagementWebPropertyAdWordsLinksInsert* = Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_579552(
    name: "analyticsManagementWebPropertyAdWordsLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_579553,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksInsert_579554,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksList_579534 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebPropertyAdWordsLinksList_579536(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/entityAdWordsLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksList_579535(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists webProperty-Google Ads links for a given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads links for.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579537 = path.getOrDefault("webPropertyId")
  valid_579537 = validateParameter(valid_579537, JString, required = true,
                                 default = nil)
  if valid_579537 != nil:
    section.add "webPropertyId", valid_579537
  var valid_579538 = path.getOrDefault("accountId")
  valid_579538 = validateParameter(valid_579538, JString, required = true,
                                 default = nil)
  if valid_579538 != nil:
    section.add "accountId", valid_579538
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
  ##              : An index of the first webProperty-Google Ads link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of webProperty-Google Ads links to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579539 = query.getOrDefault("key")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "key", valid_579539
  var valid_579540 = query.getOrDefault("prettyPrint")
  valid_579540 = validateParameter(valid_579540, JBool, required = false,
                                 default = newJBool(false))
  if valid_579540 != nil:
    section.add "prettyPrint", valid_579540
  var valid_579541 = query.getOrDefault("oauth_token")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "oauth_token", valid_579541
  var valid_579542 = query.getOrDefault("alt")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = newJString("json"))
  if valid_579542 != nil:
    section.add "alt", valid_579542
  var valid_579543 = query.getOrDefault("userIp")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "userIp", valid_579543
  var valid_579544 = query.getOrDefault("quotaUser")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "quotaUser", valid_579544
  var valid_579545 = query.getOrDefault("start-index")
  valid_579545 = validateParameter(valid_579545, JInt, required = false, default = nil)
  if valid_579545 != nil:
    section.add "start-index", valid_579545
  var valid_579546 = query.getOrDefault("max-results")
  valid_579546 = validateParameter(valid_579546, JInt, required = false, default = nil)
  if valid_579546 != nil:
    section.add "max-results", valid_579546
  var valid_579547 = query.getOrDefault("fields")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "fields", valid_579547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579548: Call_AnalyticsManagementWebPropertyAdWordsLinksList_579534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-Google Ads links for a given web property.
  ## 
  let valid = call_579548.validator(path, query, header, formData, body)
  let scheme = call_579548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579548.url(scheme.get, call_579548.host, call_579548.base,
                         call_579548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579548, url, valid)

proc call*(call_579549: Call_AnalyticsManagementWebPropertyAdWordsLinksList_579534;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksList
  ## Lists webProperty-Google Ads links for a given web property.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads links for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first webProperty-Google Ads link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of webProperty-Google Ads links to include in this response.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579550 = newJObject()
  var query_579551 = newJObject()
  add(query_579551, "key", newJString(key))
  add(query_579551, "prettyPrint", newJBool(prettyPrint))
  add(query_579551, "oauth_token", newJString(oauthToken))
  add(path_579550, "webPropertyId", newJString(webPropertyId))
  add(query_579551, "alt", newJString(alt))
  add(query_579551, "userIp", newJString(userIp))
  add(query_579551, "quotaUser", newJString(quotaUser))
  add(query_579551, "start-index", newJInt(startIndex))
  add(query_579551, "max-results", newJInt(maxResults))
  add(path_579550, "accountId", newJString(accountId))
  add(query_579551, "fields", newJString(fields))
  result = call_579549.call(path_579550, query_579551, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksList* = Call_AnalyticsManagementWebPropertyAdWordsLinksList_579534(
    name: "analyticsManagementWebPropertyAdWordsLinksList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksList_579535,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksList_579536,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579587 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579589(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579588(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing webProperty-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579590 = path.getOrDefault("webPropertyId")
  valid_579590 = validateParameter(valid_579590, JString, required = true,
                                 default = nil)
  if valid_579590 != nil:
    section.add "webPropertyId", valid_579590
  var valid_579591 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_579591 = validateParameter(valid_579591, JString, required = true,
                                 default = nil)
  if valid_579591 != nil:
    section.add "webPropertyAdWordsLinkId", valid_579591
  var valid_579592 = path.getOrDefault("accountId")
  valid_579592 = validateParameter(valid_579592, JString, required = true,
                                 default = nil)
  if valid_579592 != nil:
    section.add "accountId", valid_579592
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579593 = query.getOrDefault("key")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "key", valid_579593
  var valid_579594 = query.getOrDefault("prettyPrint")
  valid_579594 = validateParameter(valid_579594, JBool, required = false,
                                 default = newJBool(false))
  if valid_579594 != nil:
    section.add "prettyPrint", valid_579594
  var valid_579595 = query.getOrDefault("oauth_token")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "oauth_token", valid_579595
  var valid_579596 = query.getOrDefault("alt")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = newJString("json"))
  if valid_579596 != nil:
    section.add "alt", valid_579596
  var valid_579597 = query.getOrDefault("userIp")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "userIp", valid_579597
  var valid_579598 = query.getOrDefault("quotaUser")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "quotaUser", valid_579598
  var valid_579599 = query.getOrDefault("fields")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "fields", valid_579599
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

proc call*(call_579601: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579587;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link.
  ## 
  let valid = call_579601.validator(path, query, header, formData, body)
  let scheme = call_579601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579601.url(scheme.get, call_579601.host, call_579601.base,
                         call_579601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579601, url, valid)

proc call*(call_579602: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579587;
          webPropertyId: string; webPropertyAdWordsLinkId: string;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksUpdate
  ## Updates an existing webProperty-Google Ads link.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579603 = newJObject()
  var query_579604 = newJObject()
  var body_579605 = newJObject()
  add(query_579604, "key", newJString(key))
  add(query_579604, "prettyPrint", newJBool(prettyPrint))
  add(query_579604, "oauth_token", newJString(oauthToken))
  add(path_579603, "webPropertyId", newJString(webPropertyId))
  add(query_579604, "alt", newJString(alt))
  add(query_579604, "userIp", newJString(userIp))
  add(query_579604, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579605 = body
  add(path_579603, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(path_579603, "accountId", newJString(accountId))
  add(query_579604, "fields", newJString(fields))
  result = call_579602.call(path_579603, query_579604, nil, nil, body_579605)

var analyticsManagementWebPropertyAdWordsLinksUpdate* = Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579587(
    name: "analyticsManagementWebPropertyAdWordsLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579588,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_579589,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksGet_579570 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebPropertyAdWordsLinksGet_579572(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksGet_579571(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a web property-Google Ads link to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579573 = path.getOrDefault("webPropertyId")
  valid_579573 = validateParameter(valid_579573, JString, required = true,
                                 default = nil)
  if valid_579573 != nil:
    section.add "webPropertyId", valid_579573
  var valid_579574 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_579574 = validateParameter(valid_579574, JString, required = true,
                                 default = nil)
  if valid_579574 != nil:
    section.add "webPropertyAdWordsLinkId", valid_579574
  var valid_579575 = path.getOrDefault("accountId")
  valid_579575 = validateParameter(valid_579575, JString, required = true,
                                 default = nil)
  if valid_579575 != nil:
    section.add "accountId", valid_579575
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579576 = query.getOrDefault("key")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "key", valid_579576
  var valid_579577 = query.getOrDefault("prettyPrint")
  valid_579577 = validateParameter(valid_579577, JBool, required = false,
                                 default = newJBool(false))
  if valid_579577 != nil:
    section.add "prettyPrint", valid_579577
  var valid_579578 = query.getOrDefault("oauth_token")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "oauth_token", valid_579578
  var valid_579579 = query.getOrDefault("alt")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = newJString("json"))
  if valid_579579 != nil:
    section.add "alt", valid_579579
  var valid_579580 = query.getOrDefault("userIp")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "userIp", valid_579580
  var valid_579581 = query.getOrDefault("quotaUser")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "quotaUser", valid_579581
  var valid_579582 = query.getOrDefault("fields")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "fields", valid_579582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579583: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_579570;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a web property-Google Ads link to which the user has access.
  ## 
  let valid = call_579583.validator(path, query, header, formData, body)
  let scheme = call_579583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579583.url(scheme.get, call_579583.host, call_579583.base,
                         call_579583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579583, url, valid)

proc call*(call_579584: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_579570;
          webPropertyId: string; webPropertyAdWordsLinkId: string;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksGet
  ## Returns a web property-Google Ads link to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579585 = newJObject()
  var query_579586 = newJObject()
  add(query_579586, "key", newJString(key))
  add(query_579586, "prettyPrint", newJBool(prettyPrint))
  add(query_579586, "oauth_token", newJString(oauthToken))
  add(path_579585, "webPropertyId", newJString(webPropertyId))
  add(query_579586, "alt", newJString(alt))
  add(query_579586, "userIp", newJString(userIp))
  add(query_579586, "quotaUser", newJString(quotaUser))
  add(path_579585, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(path_579585, "accountId", newJString(accountId))
  add(query_579586, "fields", newJString(fields))
  result = call_579584.call(path_579585, query_579586, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksGet* = Call_AnalyticsManagementWebPropertyAdWordsLinksGet_579570(
    name: "analyticsManagementWebPropertyAdWordsLinksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksGet_579571,
    base: "/analytics/v3", url: url_AnalyticsManagementWebPropertyAdWordsLinksGet_579572,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_579623 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebPropertyAdWordsLinksPatch_579625(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_579624(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579626 = path.getOrDefault("webPropertyId")
  valid_579626 = validateParameter(valid_579626, JString, required = true,
                                 default = nil)
  if valid_579626 != nil:
    section.add "webPropertyId", valid_579626
  var valid_579627 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_579627 = validateParameter(valid_579627, JString, required = true,
                                 default = nil)
  if valid_579627 != nil:
    section.add "webPropertyAdWordsLinkId", valid_579627
  var valid_579628 = path.getOrDefault("accountId")
  valid_579628 = validateParameter(valid_579628, JString, required = true,
                                 default = nil)
  if valid_579628 != nil:
    section.add "accountId", valid_579628
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579629 = query.getOrDefault("key")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "key", valid_579629
  var valid_579630 = query.getOrDefault("prettyPrint")
  valid_579630 = validateParameter(valid_579630, JBool, required = false,
                                 default = newJBool(false))
  if valid_579630 != nil:
    section.add "prettyPrint", valid_579630
  var valid_579631 = query.getOrDefault("oauth_token")
  valid_579631 = validateParameter(valid_579631, JString, required = false,
                                 default = nil)
  if valid_579631 != nil:
    section.add "oauth_token", valid_579631
  var valid_579632 = query.getOrDefault("alt")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = newJString("json"))
  if valid_579632 != nil:
    section.add "alt", valid_579632
  var valid_579633 = query.getOrDefault("userIp")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "userIp", valid_579633
  var valid_579634 = query.getOrDefault("quotaUser")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "quotaUser", valid_579634
  var valid_579635 = query.getOrDefault("fields")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = nil)
  if valid_579635 != nil:
    section.add "fields", valid_579635
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

proc call*(call_579637: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_579623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ## 
  let valid = call_579637.validator(path, query, header, formData, body)
  let scheme = call_579637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579637.url(scheme.get, call_579637.host, call_579637.base,
                         call_579637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579637, url, valid)

proc call*(call_579638: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_579623;
          webPropertyId: string; webPropertyAdWordsLinkId: string;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksPatch
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579639 = newJObject()
  var query_579640 = newJObject()
  var body_579641 = newJObject()
  add(query_579640, "key", newJString(key))
  add(query_579640, "prettyPrint", newJBool(prettyPrint))
  add(query_579640, "oauth_token", newJString(oauthToken))
  add(path_579639, "webPropertyId", newJString(webPropertyId))
  add(query_579640, "alt", newJString(alt))
  add(query_579640, "userIp", newJString(userIp))
  add(query_579640, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579641 = body
  add(path_579639, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(path_579639, "accountId", newJString(accountId))
  add(query_579640, "fields", newJString(fields))
  result = call_579638.call(path_579639, query_579640, nil, nil, body_579641)

var analyticsManagementWebPropertyAdWordsLinksPatch* = Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_579623(
    name: "analyticsManagementWebPropertyAdWordsLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_579624,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksPatch_579625,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_579606 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebPropertyAdWordsLinksDelete_579608(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_579607(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a web property-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the Google Ads link for.
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579609 = path.getOrDefault("webPropertyId")
  valid_579609 = validateParameter(valid_579609, JString, required = true,
                                 default = nil)
  if valid_579609 != nil:
    section.add "webPropertyId", valid_579609
  var valid_579610 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_579610 = validateParameter(valid_579610, JString, required = true,
                                 default = nil)
  if valid_579610 != nil:
    section.add "webPropertyAdWordsLinkId", valid_579610
  var valid_579611 = path.getOrDefault("accountId")
  valid_579611 = validateParameter(valid_579611, JString, required = true,
                                 default = nil)
  if valid_579611 != nil:
    section.add "accountId", valid_579611
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579612 = query.getOrDefault("key")
  valid_579612 = validateParameter(valid_579612, JString, required = false,
                                 default = nil)
  if valid_579612 != nil:
    section.add "key", valid_579612
  var valid_579613 = query.getOrDefault("prettyPrint")
  valid_579613 = validateParameter(valid_579613, JBool, required = false,
                                 default = newJBool(false))
  if valid_579613 != nil:
    section.add "prettyPrint", valid_579613
  var valid_579614 = query.getOrDefault("oauth_token")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = nil)
  if valid_579614 != nil:
    section.add "oauth_token", valid_579614
  var valid_579615 = query.getOrDefault("alt")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = newJString("json"))
  if valid_579615 != nil:
    section.add "alt", valid_579615
  var valid_579616 = query.getOrDefault("userIp")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = nil)
  if valid_579616 != nil:
    section.add "userIp", valid_579616
  var valid_579617 = query.getOrDefault("quotaUser")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "quotaUser", valid_579617
  var valid_579618 = query.getOrDefault("fields")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "fields", valid_579618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579619: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_579606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a web property-Google Ads link.
  ## 
  let valid = call_579619.validator(path, query, header, formData, body)
  let scheme = call_579619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579619.url(scheme.get, call_579619.host, call_579619.base,
                         call_579619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579619, url, valid)

proc call*(call_579620: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_579606;
          webPropertyId: string; webPropertyAdWordsLinkId: string;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksDelete
  ## Deletes a web property-Google Ads link.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the Google Ads link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property Google Ads link ID.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579621 = newJObject()
  var query_579622 = newJObject()
  add(query_579622, "key", newJString(key))
  add(query_579622, "prettyPrint", newJBool(prettyPrint))
  add(query_579622, "oauth_token", newJString(oauthToken))
  add(path_579621, "webPropertyId", newJString(webPropertyId))
  add(query_579622, "alt", newJString(alt))
  add(query_579622, "userIp", newJString(userIp))
  add(query_579622, "quotaUser", newJString(quotaUser))
  add(path_579621, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(path_579621, "accountId", newJString(accountId))
  add(query_579622, "fields", newJString(fields))
  result = call_579620.call(path_579621, query_579622, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksDelete* = Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_579606(
    name: "analyticsManagementWebPropertyAdWordsLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_579607,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksDelete_579608,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksInsert_579660 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertyUserLinksInsert_579662(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksInsert_579661(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds a new user to the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to create the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579663 = path.getOrDefault("webPropertyId")
  valid_579663 = validateParameter(valid_579663, JString, required = true,
                                 default = nil)
  if valid_579663 != nil:
    section.add "webPropertyId", valid_579663
  var valid_579664 = path.getOrDefault("accountId")
  valid_579664 = validateParameter(valid_579664, JString, required = true,
                                 default = nil)
  if valid_579664 != nil:
    section.add "accountId", valid_579664
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579665 = query.getOrDefault("key")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "key", valid_579665
  var valid_579666 = query.getOrDefault("prettyPrint")
  valid_579666 = validateParameter(valid_579666, JBool, required = false,
                                 default = newJBool(false))
  if valid_579666 != nil:
    section.add "prettyPrint", valid_579666
  var valid_579667 = query.getOrDefault("oauth_token")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "oauth_token", valid_579667
  var valid_579668 = query.getOrDefault("alt")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = newJString("json"))
  if valid_579668 != nil:
    section.add "alt", valid_579668
  var valid_579669 = query.getOrDefault("userIp")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "userIp", valid_579669
  var valid_579670 = query.getOrDefault("quotaUser")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "quotaUser", valid_579670
  var valid_579671 = query.getOrDefault("fields")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "fields", valid_579671
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

proc call*(call_579673: Call_AnalyticsManagementWebpropertyUserLinksInsert_579660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given web property.
  ## 
  let valid = call_579673.validator(path, query, header, formData, body)
  let scheme = call_579673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579673.url(scheme.get, call_579673.host, call_579673.base,
                         call_579673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579673, url, valid)

proc call*(call_579674: Call_AnalyticsManagementWebpropertyUserLinksInsert_579660;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementWebpropertyUserLinksInsert
  ## Adds a new user to the given web property.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to create the user link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579675 = newJObject()
  var query_579676 = newJObject()
  var body_579677 = newJObject()
  add(query_579676, "key", newJString(key))
  add(query_579676, "prettyPrint", newJBool(prettyPrint))
  add(query_579676, "oauth_token", newJString(oauthToken))
  add(path_579675, "webPropertyId", newJString(webPropertyId))
  add(query_579676, "alt", newJString(alt))
  add(query_579676, "userIp", newJString(userIp))
  add(query_579676, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579677 = body
  add(path_579675, "accountId", newJString(accountId))
  add(query_579676, "fields", newJString(fields))
  result = call_579674.call(path_579675, query_579676, nil, nil, body_579677)

var analyticsManagementWebpropertyUserLinksInsert* = Call_AnalyticsManagementWebpropertyUserLinksInsert_579660(
    name: "analyticsManagementWebpropertyUserLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksInsert_579661,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksInsert_579662,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksList_579642 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertyUserLinksList_579644(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksList_579643(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists webProperty-user links for a given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web Property ID for the webProperty-user links to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID which the given web property belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579645 = path.getOrDefault("webPropertyId")
  valid_579645 = validateParameter(valid_579645, JString, required = true,
                                 default = nil)
  if valid_579645 != nil:
    section.add "webPropertyId", valid_579645
  var valid_579646 = path.getOrDefault("accountId")
  valid_579646 = validateParameter(valid_579646, JString, required = true,
                                 default = nil)
  if valid_579646 != nil:
    section.add "accountId", valid_579646
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
  ##              : An index of the first webProperty-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of webProperty-user Links to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579647 = query.getOrDefault("key")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = nil)
  if valid_579647 != nil:
    section.add "key", valid_579647
  var valid_579648 = query.getOrDefault("prettyPrint")
  valid_579648 = validateParameter(valid_579648, JBool, required = false,
                                 default = newJBool(false))
  if valid_579648 != nil:
    section.add "prettyPrint", valid_579648
  var valid_579649 = query.getOrDefault("oauth_token")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "oauth_token", valid_579649
  var valid_579650 = query.getOrDefault("alt")
  valid_579650 = validateParameter(valid_579650, JString, required = false,
                                 default = newJString("json"))
  if valid_579650 != nil:
    section.add "alt", valid_579650
  var valid_579651 = query.getOrDefault("userIp")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "userIp", valid_579651
  var valid_579652 = query.getOrDefault("quotaUser")
  valid_579652 = validateParameter(valid_579652, JString, required = false,
                                 default = nil)
  if valid_579652 != nil:
    section.add "quotaUser", valid_579652
  var valid_579653 = query.getOrDefault("start-index")
  valid_579653 = validateParameter(valid_579653, JInt, required = false, default = nil)
  if valid_579653 != nil:
    section.add "start-index", valid_579653
  var valid_579654 = query.getOrDefault("max-results")
  valid_579654 = validateParameter(valid_579654, JInt, required = false, default = nil)
  if valid_579654 != nil:
    section.add "max-results", valid_579654
  var valid_579655 = query.getOrDefault("fields")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "fields", valid_579655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579656: Call_AnalyticsManagementWebpropertyUserLinksList_579642;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-user links for a given web property.
  ## 
  let valid = call_579656.validator(path, query, header, formData, body)
  let scheme = call_579656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579656.url(scheme.get, call_579656.host, call_579656.base,
                         call_579656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579656, url, valid)

proc call*(call_579657: Call_AnalyticsManagementWebpropertyUserLinksList_579642;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementWebpropertyUserLinksList
  ## Lists webProperty-user links for a given web property.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web Property ID for the webProperty-user links to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first webProperty-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of webProperty-user Links to include in this response.
  ##   accountId: string (required)
  ##            : Account ID which the given web property belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579658 = newJObject()
  var query_579659 = newJObject()
  add(query_579659, "key", newJString(key))
  add(query_579659, "prettyPrint", newJBool(prettyPrint))
  add(query_579659, "oauth_token", newJString(oauthToken))
  add(path_579658, "webPropertyId", newJString(webPropertyId))
  add(query_579659, "alt", newJString(alt))
  add(query_579659, "userIp", newJString(userIp))
  add(query_579659, "quotaUser", newJString(quotaUser))
  add(query_579659, "start-index", newJInt(startIndex))
  add(query_579659, "max-results", newJInt(maxResults))
  add(path_579658, "accountId", newJString(accountId))
  add(query_579659, "fields", newJString(fields))
  result = call_579657.call(path_579658, query_579659, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksList* = Call_AnalyticsManagementWebpropertyUserLinksList_579642(
    name: "analyticsManagementWebpropertyUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksList_579643,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksList_579644,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksUpdate_579678 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertyUserLinksUpdate_579680(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementWebpropertyUserLinksUpdate_579679(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the account-user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the account-user link for.
  ##   accountId: JString (required)
  ##            : Account ID to update the account-user link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579681 = path.getOrDefault("webPropertyId")
  valid_579681 = validateParameter(valid_579681, JString, required = true,
                                 default = nil)
  if valid_579681 != nil:
    section.add "webPropertyId", valid_579681
  var valid_579682 = path.getOrDefault("linkId")
  valid_579682 = validateParameter(valid_579682, JString, required = true,
                                 default = nil)
  if valid_579682 != nil:
    section.add "linkId", valid_579682
  var valid_579683 = path.getOrDefault("accountId")
  valid_579683 = validateParameter(valid_579683, JString, required = true,
                                 default = nil)
  if valid_579683 != nil:
    section.add "accountId", valid_579683
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579684 = query.getOrDefault("key")
  valid_579684 = validateParameter(valid_579684, JString, required = false,
                                 default = nil)
  if valid_579684 != nil:
    section.add "key", valid_579684
  var valid_579685 = query.getOrDefault("prettyPrint")
  valid_579685 = validateParameter(valid_579685, JBool, required = false,
                                 default = newJBool(false))
  if valid_579685 != nil:
    section.add "prettyPrint", valid_579685
  var valid_579686 = query.getOrDefault("oauth_token")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "oauth_token", valid_579686
  var valid_579687 = query.getOrDefault("alt")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = newJString("json"))
  if valid_579687 != nil:
    section.add "alt", valid_579687
  var valid_579688 = query.getOrDefault("userIp")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "userIp", valid_579688
  var valid_579689 = query.getOrDefault("quotaUser")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "quotaUser", valid_579689
  var valid_579690 = query.getOrDefault("fields")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "fields", valid_579690
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

proc call*(call_579692: Call_AnalyticsManagementWebpropertyUserLinksUpdate_579678;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given web property.
  ## 
  let valid = call_579692.validator(path, query, header, formData, body)
  let scheme = call_579692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579692.url(scheme.get, call_579692.host, call_579692.base,
                         call_579692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579692, url, valid)

proc call*(call_579693: Call_AnalyticsManagementWebpropertyUserLinksUpdate_579678;
          webPropertyId: string; linkId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementWebpropertyUserLinksUpdate
  ## Updates permissions for an existing user on the given web property.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the account-user link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : Link ID to update the account-user link for.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to update the account-user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579694 = newJObject()
  var query_579695 = newJObject()
  var body_579696 = newJObject()
  add(query_579695, "key", newJString(key))
  add(query_579695, "prettyPrint", newJBool(prettyPrint))
  add(query_579695, "oauth_token", newJString(oauthToken))
  add(path_579694, "webPropertyId", newJString(webPropertyId))
  add(query_579695, "alt", newJString(alt))
  add(query_579695, "userIp", newJString(userIp))
  add(query_579695, "quotaUser", newJString(quotaUser))
  add(path_579694, "linkId", newJString(linkId))
  if body != nil:
    body_579696 = body
  add(path_579694, "accountId", newJString(accountId))
  add(query_579695, "fields", newJString(fields))
  result = call_579693.call(path_579694, query_579695, nil, nil, body_579696)

var analyticsManagementWebpropertyUserLinksUpdate* = Call_AnalyticsManagementWebpropertyUserLinksUpdate_579678(
    name: "analyticsManagementWebpropertyUserLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksUpdate_579679,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksUpdate_579680,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksDelete_579697 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementWebpropertyUserLinksDelete_579699(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementWebpropertyUserLinksDelete_579698(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a user from the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579700 = path.getOrDefault("webPropertyId")
  valid_579700 = validateParameter(valid_579700, JString, required = true,
                                 default = nil)
  if valid_579700 != nil:
    section.add "webPropertyId", valid_579700
  var valid_579701 = path.getOrDefault("linkId")
  valid_579701 = validateParameter(valid_579701, JString, required = true,
                                 default = nil)
  if valid_579701 != nil:
    section.add "linkId", valid_579701
  var valid_579702 = path.getOrDefault("accountId")
  valid_579702 = validateParameter(valid_579702, JString, required = true,
                                 default = nil)
  if valid_579702 != nil:
    section.add "accountId", valid_579702
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579703 = query.getOrDefault("key")
  valid_579703 = validateParameter(valid_579703, JString, required = false,
                                 default = nil)
  if valid_579703 != nil:
    section.add "key", valid_579703
  var valid_579704 = query.getOrDefault("prettyPrint")
  valid_579704 = validateParameter(valid_579704, JBool, required = false,
                                 default = newJBool(false))
  if valid_579704 != nil:
    section.add "prettyPrint", valid_579704
  var valid_579705 = query.getOrDefault("oauth_token")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "oauth_token", valid_579705
  var valid_579706 = query.getOrDefault("alt")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = newJString("json"))
  if valid_579706 != nil:
    section.add "alt", valid_579706
  var valid_579707 = query.getOrDefault("userIp")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "userIp", valid_579707
  var valid_579708 = query.getOrDefault("quotaUser")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = nil)
  if valid_579708 != nil:
    section.add "quotaUser", valid_579708
  var valid_579709 = query.getOrDefault("fields")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "fields", valid_579709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579710: Call_AnalyticsManagementWebpropertyUserLinksDelete_579697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given web property.
  ## 
  let valid = call_579710.validator(path, query, header, formData, body)
  let scheme = call_579710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579710.url(scheme.get, call_579710.host, call_579710.base,
                         call_579710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579710, url, valid)

proc call*(call_579711: Call_AnalyticsManagementWebpropertyUserLinksDelete_579697;
          webPropertyId: string; linkId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementWebpropertyUserLinksDelete
  ## Removes a user from the given web property.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to delete the user link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579712 = newJObject()
  var query_579713 = newJObject()
  add(query_579713, "key", newJString(key))
  add(query_579713, "prettyPrint", newJBool(prettyPrint))
  add(query_579713, "oauth_token", newJString(oauthToken))
  add(path_579712, "webPropertyId", newJString(webPropertyId))
  add(query_579713, "alt", newJString(alt))
  add(query_579713, "userIp", newJString(userIp))
  add(query_579713, "quotaUser", newJString(quotaUser))
  add(path_579712, "linkId", newJString(linkId))
  add(path_579712, "accountId", newJString(accountId))
  add(query_579713, "fields", newJString(fields))
  result = call_579711.call(path_579712, query_579713, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksDelete* = Call_AnalyticsManagementWebpropertyUserLinksDelete_579697(
    name: "analyticsManagementWebpropertyUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksDelete_579698,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksDelete_579699,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesInsert_579732 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfilesInsert_579734(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesInsert_579733(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the view (profile) for.
  ##   accountId: JString (required)
  ##            : Account ID to create the view (profile) for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579735 = path.getOrDefault("webPropertyId")
  valid_579735 = validateParameter(valid_579735, JString, required = true,
                                 default = nil)
  if valid_579735 != nil:
    section.add "webPropertyId", valid_579735
  var valid_579736 = path.getOrDefault("accountId")
  valid_579736 = validateParameter(valid_579736, JString, required = true,
                                 default = nil)
  if valid_579736 != nil:
    section.add "accountId", valid_579736
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579737 = query.getOrDefault("key")
  valid_579737 = validateParameter(valid_579737, JString, required = false,
                                 default = nil)
  if valid_579737 != nil:
    section.add "key", valid_579737
  var valid_579738 = query.getOrDefault("prettyPrint")
  valid_579738 = validateParameter(valid_579738, JBool, required = false,
                                 default = newJBool(false))
  if valid_579738 != nil:
    section.add "prettyPrint", valid_579738
  var valid_579739 = query.getOrDefault("oauth_token")
  valid_579739 = validateParameter(valid_579739, JString, required = false,
                                 default = nil)
  if valid_579739 != nil:
    section.add "oauth_token", valid_579739
  var valid_579740 = query.getOrDefault("alt")
  valid_579740 = validateParameter(valid_579740, JString, required = false,
                                 default = newJString("json"))
  if valid_579740 != nil:
    section.add "alt", valid_579740
  var valid_579741 = query.getOrDefault("userIp")
  valid_579741 = validateParameter(valid_579741, JString, required = false,
                                 default = nil)
  if valid_579741 != nil:
    section.add "userIp", valid_579741
  var valid_579742 = query.getOrDefault("quotaUser")
  valid_579742 = validateParameter(valid_579742, JString, required = false,
                                 default = nil)
  if valid_579742 != nil:
    section.add "quotaUser", valid_579742
  var valid_579743 = query.getOrDefault("fields")
  valid_579743 = validateParameter(valid_579743, JString, required = false,
                                 default = nil)
  if valid_579743 != nil:
    section.add "fields", valid_579743
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

proc call*(call_579745: Call_AnalyticsManagementProfilesInsert_579732;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new view (profile).
  ## 
  let valid = call_579745.validator(path, query, header, formData, body)
  let scheme = call_579745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579745.url(scheme.get, call_579745.host, call_579745.base,
                         call_579745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579745, url, valid)

proc call*(call_579746: Call_AnalyticsManagementProfilesInsert_579732;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementProfilesInsert
  ## Create a new view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the view (profile) for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the view (profile) for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579747 = newJObject()
  var query_579748 = newJObject()
  var body_579749 = newJObject()
  add(query_579748, "key", newJString(key))
  add(query_579748, "prettyPrint", newJBool(prettyPrint))
  add(query_579748, "oauth_token", newJString(oauthToken))
  add(path_579747, "webPropertyId", newJString(webPropertyId))
  add(query_579748, "alt", newJString(alt))
  add(query_579748, "userIp", newJString(userIp))
  add(query_579748, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579749 = body
  add(path_579747, "accountId", newJString(accountId))
  add(query_579748, "fields", newJString(fields))
  result = call_579746.call(path_579747, query_579748, nil, nil, body_579749)

var analyticsManagementProfilesInsert* = Call_AnalyticsManagementProfilesInsert_579732(
    name: "analyticsManagementProfilesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesInsert_579733,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesInsert_579734,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesList_579714 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfilesList_579716(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesList_579715(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists views (profiles) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  ##   accountId: JString (required)
  ##            : Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579717 = path.getOrDefault("webPropertyId")
  valid_579717 = validateParameter(valid_579717, JString, required = true,
                                 default = nil)
  if valid_579717 != nil:
    section.add "webPropertyId", valid_579717
  var valid_579718 = path.getOrDefault("accountId")
  valid_579718 = validateParameter(valid_579718, JString, required = true,
                                 default = nil)
  if valid_579718 != nil:
    section.add "accountId", valid_579718
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
  var valid_579719 = query.getOrDefault("key")
  valid_579719 = validateParameter(valid_579719, JString, required = false,
                                 default = nil)
  if valid_579719 != nil:
    section.add "key", valid_579719
  var valid_579720 = query.getOrDefault("prettyPrint")
  valid_579720 = validateParameter(valid_579720, JBool, required = false,
                                 default = newJBool(false))
  if valid_579720 != nil:
    section.add "prettyPrint", valid_579720
  var valid_579721 = query.getOrDefault("oauth_token")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = nil)
  if valid_579721 != nil:
    section.add "oauth_token", valid_579721
  var valid_579722 = query.getOrDefault("alt")
  valid_579722 = validateParameter(valid_579722, JString, required = false,
                                 default = newJString("json"))
  if valid_579722 != nil:
    section.add "alt", valid_579722
  var valid_579723 = query.getOrDefault("userIp")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = nil)
  if valid_579723 != nil:
    section.add "userIp", valid_579723
  var valid_579724 = query.getOrDefault("quotaUser")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = nil)
  if valid_579724 != nil:
    section.add "quotaUser", valid_579724
  var valid_579725 = query.getOrDefault("start-index")
  valid_579725 = validateParameter(valid_579725, JInt, required = false, default = nil)
  if valid_579725 != nil:
    section.add "start-index", valid_579725
  var valid_579726 = query.getOrDefault("max-results")
  valid_579726 = validateParameter(valid_579726, JInt, required = false, default = nil)
  if valid_579726 != nil:
    section.add "max-results", valid_579726
  var valid_579727 = query.getOrDefault("fields")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "fields", valid_579727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579728: Call_AnalyticsManagementProfilesList_579714;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists views (profiles) to which the user has access.
  ## 
  let valid = call_579728.validator(path, query, header, formData, body)
  let scheme = call_579728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579728.url(scheme.get, call_579728.host, call_579728.base,
                         call_579728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579728, url, valid)

proc call*(call_579729: Call_AnalyticsManagementProfilesList_579714;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
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
  ##            : Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579730 = newJObject()
  var query_579731 = newJObject()
  add(query_579731, "key", newJString(key))
  add(query_579731, "prettyPrint", newJBool(prettyPrint))
  add(query_579731, "oauth_token", newJString(oauthToken))
  add(path_579730, "webPropertyId", newJString(webPropertyId))
  add(query_579731, "alt", newJString(alt))
  add(query_579731, "userIp", newJString(userIp))
  add(query_579731, "quotaUser", newJString(quotaUser))
  add(query_579731, "start-index", newJInt(startIndex))
  add(query_579731, "max-results", newJInt(maxResults))
  add(path_579730, "accountId", newJString(accountId))
  add(query_579731, "fields", newJString(fields))
  result = call_579729.call(path_579730, query_579731, nil, nil, nil)

var analyticsManagementProfilesList* = Call_AnalyticsManagementProfilesList_579714(
    name: "analyticsManagementProfilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesList_579715,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesList_579716,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesUpdate_579767 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfilesUpdate_579769(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesUpdate_579768(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which the view (profile) belongs
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579770 = path.getOrDefault("webPropertyId")
  valid_579770 = validateParameter(valid_579770, JString, required = true,
                                 default = nil)
  if valid_579770 != nil:
    section.add "webPropertyId", valid_579770
  var valid_579771 = path.getOrDefault("profileId")
  valid_579771 = validateParameter(valid_579771, JString, required = true,
                                 default = nil)
  if valid_579771 != nil:
    section.add "profileId", valid_579771
  var valid_579772 = path.getOrDefault("accountId")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "accountId", valid_579772
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579774 = query.getOrDefault("prettyPrint")
  valid_579774 = validateParameter(valid_579774, JBool, required = false,
                                 default = newJBool(false))
  if valid_579774 != nil:
    section.add "prettyPrint", valid_579774
  var valid_579775 = query.getOrDefault("oauth_token")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "oauth_token", valid_579775
  var valid_579776 = query.getOrDefault("alt")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = newJString("json"))
  if valid_579776 != nil:
    section.add "alt", valid_579776
  var valid_579777 = query.getOrDefault("userIp")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "userIp", valid_579777
  var valid_579778 = query.getOrDefault("quotaUser")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "quotaUser", valid_579778
  var valid_579779 = query.getOrDefault("fields")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "fields", valid_579779
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

proc call*(call_579781: Call_AnalyticsManagementProfilesUpdate_579767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile).
  ## 
  let valid = call_579781.validator(path, query, header, formData, body)
  let scheme = call_579781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579781.url(scheme.get, call_579781.host, call_579781.base,
                         call_579781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579781, url, valid)

proc call*(call_579782: Call_AnalyticsManagementProfilesUpdate_579767;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementProfilesUpdate
  ## Updates an existing view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which the view (profile) belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579783 = newJObject()
  var query_579784 = newJObject()
  var body_579785 = newJObject()
  add(query_579784, "key", newJString(key))
  add(query_579784, "prettyPrint", newJBool(prettyPrint))
  add(query_579784, "oauth_token", newJString(oauthToken))
  add(path_579783, "webPropertyId", newJString(webPropertyId))
  add(path_579783, "profileId", newJString(profileId))
  add(query_579784, "alt", newJString(alt))
  add(query_579784, "userIp", newJString(userIp))
  add(query_579784, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579785 = body
  add(path_579783, "accountId", newJString(accountId))
  add(query_579784, "fields", newJString(fields))
  result = call_579782.call(path_579783, query_579784, nil, nil, body_579785)

var analyticsManagementProfilesUpdate* = Call_AnalyticsManagementProfilesUpdate_579767(
    name: "analyticsManagementProfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesUpdate_579768,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesUpdate_579769,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesGet_579750 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfilesGet_579752(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesGet_579751(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a view (profile) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the view (profile) for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the view (profile) for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the view (profile) for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579753 = path.getOrDefault("webPropertyId")
  valid_579753 = validateParameter(valid_579753, JString, required = true,
                                 default = nil)
  if valid_579753 != nil:
    section.add "webPropertyId", valid_579753
  var valid_579754 = path.getOrDefault("profileId")
  valid_579754 = validateParameter(valid_579754, JString, required = true,
                                 default = nil)
  if valid_579754 != nil:
    section.add "profileId", valid_579754
  var valid_579755 = path.getOrDefault("accountId")
  valid_579755 = validateParameter(valid_579755, JString, required = true,
                                 default = nil)
  if valid_579755 != nil:
    section.add "accountId", valid_579755
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579756 = query.getOrDefault("key")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = nil)
  if valid_579756 != nil:
    section.add "key", valid_579756
  var valid_579757 = query.getOrDefault("prettyPrint")
  valid_579757 = validateParameter(valid_579757, JBool, required = false,
                                 default = newJBool(false))
  if valid_579757 != nil:
    section.add "prettyPrint", valid_579757
  var valid_579758 = query.getOrDefault("oauth_token")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "oauth_token", valid_579758
  var valid_579759 = query.getOrDefault("alt")
  valid_579759 = validateParameter(valid_579759, JString, required = false,
                                 default = newJString("json"))
  if valid_579759 != nil:
    section.add "alt", valid_579759
  var valid_579760 = query.getOrDefault("userIp")
  valid_579760 = validateParameter(valid_579760, JString, required = false,
                                 default = nil)
  if valid_579760 != nil:
    section.add "userIp", valid_579760
  var valid_579761 = query.getOrDefault("quotaUser")
  valid_579761 = validateParameter(valid_579761, JString, required = false,
                                 default = nil)
  if valid_579761 != nil:
    section.add "quotaUser", valid_579761
  var valid_579762 = query.getOrDefault("fields")
  valid_579762 = validateParameter(valid_579762, JString, required = false,
                                 default = nil)
  if valid_579762 != nil:
    section.add "fields", valid_579762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579763: Call_AnalyticsManagementProfilesGet_579750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a view (profile) to which the user has access.
  ## 
  let valid = call_579763.validator(path, query, header, formData, body)
  let scheme = call_579763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579763.url(scheme.get, call_579763.host, call_579763.base,
                         call_579763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579763, url, valid)

proc call*(call_579764: Call_AnalyticsManagementProfilesGet_579750;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementProfilesGet
  ## Gets a view (profile) to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the view (profile) for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the view (profile) for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the view (profile) for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579765 = newJObject()
  var query_579766 = newJObject()
  add(query_579766, "key", newJString(key))
  add(query_579766, "prettyPrint", newJBool(prettyPrint))
  add(query_579766, "oauth_token", newJString(oauthToken))
  add(path_579765, "webPropertyId", newJString(webPropertyId))
  add(path_579765, "profileId", newJString(profileId))
  add(query_579766, "alt", newJString(alt))
  add(query_579766, "userIp", newJString(userIp))
  add(query_579766, "quotaUser", newJString(quotaUser))
  add(path_579765, "accountId", newJString(accountId))
  add(query_579766, "fields", newJString(fields))
  result = call_579764.call(path_579765, query_579766, nil, nil, nil)

var analyticsManagementProfilesGet* = Call_AnalyticsManagementProfilesGet_579750(
    name: "analyticsManagementProfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesGet_579751,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesGet_579752,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesPatch_579803 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfilesPatch_579805(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesPatch_579804(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing view (profile). This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which the view (profile) belongs
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579806 = path.getOrDefault("webPropertyId")
  valid_579806 = validateParameter(valid_579806, JString, required = true,
                                 default = nil)
  if valid_579806 != nil:
    section.add "webPropertyId", valid_579806
  var valid_579807 = path.getOrDefault("profileId")
  valid_579807 = validateParameter(valid_579807, JString, required = true,
                                 default = nil)
  if valid_579807 != nil:
    section.add "profileId", valid_579807
  var valid_579808 = path.getOrDefault("accountId")
  valid_579808 = validateParameter(valid_579808, JString, required = true,
                                 default = nil)
  if valid_579808 != nil:
    section.add "accountId", valid_579808
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579809 = query.getOrDefault("key")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "key", valid_579809
  var valid_579810 = query.getOrDefault("prettyPrint")
  valid_579810 = validateParameter(valid_579810, JBool, required = false,
                                 default = newJBool(false))
  if valid_579810 != nil:
    section.add "prettyPrint", valid_579810
  var valid_579811 = query.getOrDefault("oauth_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "oauth_token", valid_579811
  var valid_579812 = query.getOrDefault("alt")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = newJString("json"))
  if valid_579812 != nil:
    section.add "alt", valid_579812
  var valid_579813 = query.getOrDefault("userIp")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "userIp", valid_579813
  var valid_579814 = query.getOrDefault("quotaUser")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "quotaUser", valid_579814
  var valid_579815 = query.getOrDefault("fields")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "fields", valid_579815
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

proc call*(call_579817: Call_AnalyticsManagementProfilesPatch_579803;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile). This method supports patch semantics.
  ## 
  let valid = call_579817.validator(path, query, header, formData, body)
  let scheme = call_579817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579817.url(scheme.get, call_579817.host, call_579817.base,
                         call_579817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579817, url, valid)

proc call*(call_579818: Call_AnalyticsManagementProfilesPatch_579803;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementProfilesPatch
  ## Updates an existing view (profile). This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which the view (profile) belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579819 = newJObject()
  var query_579820 = newJObject()
  var body_579821 = newJObject()
  add(query_579820, "key", newJString(key))
  add(query_579820, "prettyPrint", newJBool(prettyPrint))
  add(query_579820, "oauth_token", newJString(oauthToken))
  add(path_579819, "webPropertyId", newJString(webPropertyId))
  add(path_579819, "profileId", newJString(profileId))
  add(query_579820, "alt", newJString(alt))
  add(query_579820, "userIp", newJString(userIp))
  add(query_579820, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579821 = body
  add(path_579819, "accountId", newJString(accountId))
  add(query_579820, "fields", newJString(fields))
  result = call_579818.call(path_579819, query_579820, nil, nil, body_579821)

var analyticsManagementProfilesPatch* = Call_AnalyticsManagementProfilesPatch_579803(
    name: "analyticsManagementProfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesPatch_579804,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesPatch_579805,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesDelete_579786 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfilesDelete_579788(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesDelete_579787(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the view (profile) for.
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be deleted.
  ##   accountId: JString (required)
  ##            : Account ID to delete the view (profile) for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579789 = path.getOrDefault("webPropertyId")
  valid_579789 = validateParameter(valid_579789, JString, required = true,
                                 default = nil)
  if valid_579789 != nil:
    section.add "webPropertyId", valid_579789
  var valid_579790 = path.getOrDefault("profileId")
  valid_579790 = validateParameter(valid_579790, JString, required = true,
                                 default = nil)
  if valid_579790 != nil:
    section.add "profileId", valid_579790
  var valid_579791 = path.getOrDefault("accountId")
  valid_579791 = validateParameter(valid_579791, JString, required = true,
                                 default = nil)
  if valid_579791 != nil:
    section.add "accountId", valid_579791
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579792 = query.getOrDefault("key")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "key", valid_579792
  var valid_579793 = query.getOrDefault("prettyPrint")
  valid_579793 = validateParameter(valid_579793, JBool, required = false,
                                 default = newJBool(false))
  if valid_579793 != nil:
    section.add "prettyPrint", valid_579793
  var valid_579794 = query.getOrDefault("oauth_token")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "oauth_token", valid_579794
  var valid_579795 = query.getOrDefault("alt")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = newJString("json"))
  if valid_579795 != nil:
    section.add "alt", valid_579795
  var valid_579796 = query.getOrDefault("userIp")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "userIp", valid_579796
  var valid_579797 = query.getOrDefault("quotaUser")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "quotaUser", valid_579797
  var valid_579798 = query.getOrDefault("fields")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "fields", valid_579798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579799: Call_AnalyticsManagementProfilesDelete_579786;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a view (profile).
  ## 
  let valid = call_579799.validator(path, query, header, formData, body)
  let scheme = call_579799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579799.url(scheme.get, call_579799.host, call_579799.base,
                         call_579799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579799, url, valid)

proc call*(call_579800: Call_AnalyticsManagementProfilesDelete_579786;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementProfilesDelete
  ## Deletes a view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the view (profile) for.
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID to delete the view (profile) for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579801 = newJObject()
  var query_579802 = newJObject()
  add(query_579802, "key", newJString(key))
  add(query_579802, "prettyPrint", newJBool(prettyPrint))
  add(query_579802, "oauth_token", newJString(oauthToken))
  add(path_579801, "webPropertyId", newJString(webPropertyId))
  add(path_579801, "profileId", newJString(profileId))
  add(query_579802, "alt", newJString(alt))
  add(query_579802, "userIp", newJString(userIp))
  add(query_579802, "quotaUser", newJString(quotaUser))
  add(path_579801, "accountId", newJString(accountId))
  add(query_579802, "fields", newJString(fields))
  result = call_579800.call(path_579801, query_579802, nil, nil, nil)

var analyticsManagementProfilesDelete* = Call_AnalyticsManagementProfilesDelete_579786(
    name: "analyticsManagementProfilesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesDelete_579787,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesDelete_579788,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksInsert_579841 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileUserLinksInsert_579843(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksInsert_579842(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new user to the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to create the user link for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579844 = path.getOrDefault("webPropertyId")
  valid_579844 = validateParameter(valid_579844, JString, required = true,
                                 default = nil)
  if valid_579844 != nil:
    section.add "webPropertyId", valid_579844
  var valid_579845 = path.getOrDefault("profileId")
  valid_579845 = validateParameter(valid_579845, JString, required = true,
                                 default = nil)
  if valid_579845 != nil:
    section.add "profileId", valid_579845
  var valid_579846 = path.getOrDefault("accountId")
  valid_579846 = validateParameter(valid_579846, JString, required = true,
                                 default = nil)
  if valid_579846 != nil:
    section.add "accountId", valid_579846
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579847 = query.getOrDefault("key")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "key", valid_579847
  var valid_579848 = query.getOrDefault("prettyPrint")
  valid_579848 = validateParameter(valid_579848, JBool, required = false,
                                 default = newJBool(false))
  if valid_579848 != nil:
    section.add "prettyPrint", valid_579848
  var valid_579849 = query.getOrDefault("oauth_token")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "oauth_token", valid_579849
  var valid_579850 = query.getOrDefault("alt")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = newJString("json"))
  if valid_579850 != nil:
    section.add "alt", valid_579850
  var valid_579851 = query.getOrDefault("userIp")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = nil)
  if valid_579851 != nil:
    section.add "userIp", valid_579851
  var valid_579852 = query.getOrDefault("quotaUser")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "quotaUser", valid_579852
  var valid_579853 = query.getOrDefault("fields")
  valid_579853 = validateParameter(valid_579853, JString, required = false,
                                 default = nil)
  if valid_579853 != nil:
    section.add "fields", valid_579853
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

proc call*(call_579855: Call_AnalyticsManagementProfileUserLinksInsert_579841;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given view (profile).
  ## 
  let valid = call_579855.validator(path, query, header, formData, body)
  let scheme = call_579855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579855.url(scheme.get, call_579855.host, call_579855.base,
                         call_579855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579855, url, valid)

proc call*(call_579856: Call_AnalyticsManagementProfileUserLinksInsert_579841;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementProfileUserLinksInsert
  ## Adds a new user to the given view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to create the user link for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the user link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579857 = newJObject()
  var query_579858 = newJObject()
  var body_579859 = newJObject()
  add(query_579858, "key", newJString(key))
  add(query_579858, "prettyPrint", newJBool(prettyPrint))
  add(query_579858, "oauth_token", newJString(oauthToken))
  add(path_579857, "webPropertyId", newJString(webPropertyId))
  add(path_579857, "profileId", newJString(profileId))
  add(query_579858, "alt", newJString(alt))
  add(query_579858, "userIp", newJString(userIp))
  add(query_579858, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579859 = body
  add(path_579857, "accountId", newJString(accountId))
  add(query_579858, "fields", newJString(fields))
  result = call_579856.call(path_579857, query_579858, nil, nil, body_579859)

var analyticsManagementProfileUserLinksInsert* = Call_AnalyticsManagementProfileUserLinksInsert_579841(
    name: "analyticsManagementProfileUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksInsert_579842,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksInsert_579843,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksList_579822 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileUserLinksList_579824(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksList_579823(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists profile-user links for a given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web Property ID which the given view (profile) belongs to. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the profile-user links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID which the given view (profile) belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579825 = path.getOrDefault("webPropertyId")
  valid_579825 = validateParameter(valid_579825, JString, required = true,
                                 default = nil)
  if valid_579825 != nil:
    section.add "webPropertyId", valid_579825
  var valid_579826 = path.getOrDefault("profileId")
  valid_579826 = validateParameter(valid_579826, JString, required = true,
                                 default = nil)
  if valid_579826 != nil:
    section.add "profileId", valid_579826
  var valid_579827 = path.getOrDefault("accountId")
  valid_579827 = validateParameter(valid_579827, JString, required = true,
                                 default = nil)
  if valid_579827 != nil:
    section.add "accountId", valid_579827
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
  ##              : An index of the first profile-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of profile-user links to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(false))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  var valid_579830 = query.getOrDefault("oauth_token")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "oauth_token", valid_579830
  var valid_579831 = query.getOrDefault("alt")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = newJString("json"))
  if valid_579831 != nil:
    section.add "alt", valid_579831
  var valid_579832 = query.getOrDefault("userIp")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "userIp", valid_579832
  var valid_579833 = query.getOrDefault("quotaUser")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "quotaUser", valid_579833
  var valid_579834 = query.getOrDefault("start-index")
  valid_579834 = validateParameter(valid_579834, JInt, required = false, default = nil)
  if valid_579834 != nil:
    section.add "start-index", valid_579834
  var valid_579835 = query.getOrDefault("max-results")
  valid_579835 = validateParameter(valid_579835, JInt, required = false, default = nil)
  if valid_579835 != nil:
    section.add "max-results", valid_579835
  var valid_579836 = query.getOrDefault("fields")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "fields", valid_579836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579837: Call_AnalyticsManagementProfileUserLinksList_579822;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists profile-user links for a given view (profile).
  ## 
  let valid = call_579837.validator(path, query, header, formData, body)
  let scheme = call_579837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579837.url(scheme.get, call_579837.host, call_579837.base,
                         call_579837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579837, url, valid)

proc call*(call_579838: Call_AnalyticsManagementProfileUserLinksList_579822;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementProfileUserLinksList
  ## Lists profile-user links for a given view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web Property ID which the given view (profile) belongs to. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the profile-user links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first profile-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of profile-user links to include in this response.
  ##   accountId: string (required)
  ##            : Account ID which the given view (profile) belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579839 = newJObject()
  var query_579840 = newJObject()
  add(query_579840, "key", newJString(key))
  add(query_579840, "prettyPrint", newJBool(prettyPrint))
  add(query_579840, "oauth_token", newJString(oauthToken))
  add(path_579839, "webPropertyId", newJString(webPropertyId))
  add(path_579839, "profileId", newJString(profileId))
  add(query_579840, "alt", newJString(alt))
  add(query_579840, "userIp", newJString(userIp))
  add(query_579840, "quotaUser", newJString(quotaUser))
  add(query_579840, "start-index", newJInt(startIndex))
  add(query_579840, "max-results", newJInt(maxResults))
  add(path_579839, "accountId", newJString(accountId))
  add(query_579840, "fields", newJString(fields))
  result = call_579838.call(path_579839, query_579840, nil, nil, nil)

var analyticsManagementProfileUserLinksList* = Call_AnalyticsManagementProfileUserLinksList_579822(
    name: "analyticsManagementProfileUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksList_579823,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksList_579824,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksUpdate_579860 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileUserLinksUpdate_579862(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementProfileUserLinksUpdate_579861(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to update the user link for.
  ##   profileId: JString (required)
  ##            : View (Profile ID) to update the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to update the user link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579863 = path.getOrDefault("webPropertyId")
  valid_579863 = validateParameter(valid_579863, JString, required = true,
                                 default = nil)
  if valid_579863 != nil:
    section.add "webPropertyId", valid_579863
  var valid_579864 = path.getOrDefault("profileId")
  valid_579864 = validateParameter(valid_579864, JString, required = true,
                                 default = nil)
  if valid_579864 != nil:
    section.add "profileId", valid_579864
  var valid_579865 = path.getOrDefault("linkId")
  valid_579865 = validateParameter(valid_579865, JString, required = true,
                                 default = nil)
  if valid_579865 != nil:
    section.add "linkId", valid_579865
  var valid_579866 = path.getOrDefault("accountId")
  valid_579866 = validateParameter(valid_579866, JString, required = true,
                                 default = nil)
  if valid_579866 != nil:
    section.add "accountId", valid_579866
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579867 = query.getOrDefault("key")
  valid_579867 = validateParameter(valid_579867, JString, required = false,
                                 default = nil)
  if valid_579867 != nil:
    section.add "key", valid_579867
  var valid_579868 = query.getOrDefault("prettyPrint")
  valid_579868 = validateParameter(valid_579868, JBool, required = false,
                                 default = newJBool(false))
  if valid_579868 != nil:
    section.add "prettyPrint", valid_579868
  var valid_579869 = query.getOrDefault("oauth_token")
  valid_579869 = validateParameter(valid_579869, JString, required = false,
                                 default = nil)
  if valid_579869 != nil:
    section.add "oauth_token", valid_579869
  var valid_579870 = query.getOrDefault("alt")
  valid_579870 = validateParameter(valid_579870, JString, required = false,
                                 default = newJString("json"))
  if valid_579870 != nil:
    section.add "alt", valid_579870
  var valid_579871 = query.getOrDefault("userIp")
  valid_579871 = validateParameter(valid_579871, JString, required = false,
                                 default = nil)
  if valid_579871 != nil:
    section.add "userIp", valid_579871
  var valid_579872 = query.getOrDefault("quotaUser")
  valid_579872 = validateParameter(valid_579872, JString, required = false,
                                 default = nil)
  if valid_579872 != nil:
    section.add "quotaUser", valid_579872
  var valid_579873 = query.getOrDefault("fields")
  valid_579873 = validateParameter(valid_579873, JString, required = false,
                                 default = nil)
  if valid_579873 != nil:
    section.add "fields", valid_579873
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

proc call*(call_579875: Call_AnalyticsManagementProfileUserLinksUpdate_579860;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given view (profile).
  ## 
  let valid = call_579875.validator(path, query, header, formData, body)
  let scheme = call_579875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579875.url(scheme.get, call_579875.host, call_579875.base,
                         call_579875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579875, url, valid)

proc call*(call_579876: Call_AnalyticsManagementProfileUserLinksUpdate_579860;
          webPropertyId: string; profileId: string; linkId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementProfileUserLinksUpdate
  ## Updates permissions for an existing user on the given view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to update the user link for.
  ##   profileId: string (required)
  ##            : View (Profile ID) to update the user link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : Link ID to update the user link for.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to update the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579877 = newJObject()
  var query_579878 = newJObject()
  var body_579879 = newJObject()
  add(query_579878, "key", newJString(key))
  add(query_579878, "prettyPrint", newJBool(prettyPrint))
  add(query_579878, "oauth_token", newJString(oauthToken))
  add(path_579877, "webPropertyId", newJString(webPropertyId))
  add(path_579877, "profileId", newJString(profileId))
  add(query_579878, "alt", newJString(alt))
  add(query_579878, "userIp", newJString(userIp))
  add(query_579878, "quotaUser", newJString(quotaUser))
  add(path_579877, "linkId", newJString(linkId))
  if body != nil:
    body_579879 = body
  add(path_579877, "accountId", newJString(accountId))
  add(query_579878, "fields", newJString(fields))
  result = call_579876.call(path_579877, query_579878, nil, nil, body_579879)

var analyticsManagementProfileUserLinksUpdate* = Call_AnalyticsManagementProfileUserLinksUpdate_579860(
    name: "analyticsManagementProfileUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksUpdate_579861,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksUpdate_579862,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksDelete_579880 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileUserLinksDelete_579882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementProfileUserLinksDelete_579881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a user from the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to delete the user link for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579883 = path.getOrDefault("webPropertyId")
  valid_579883 = validateParameter(valid_579883, JString, required = true,
                                 default = nil)
  if valid_579883 != nil:
    section.add "webPropertyId", valid_579883
  var valid_579884 = path.getOrDefault("profileId")
  valid_579884 = validateParameter(valid_579884, JString, required = true,
                                 default = nil)
  if valid_579884 != nil:
    section.add "profileId", valid_579884
  var valid_579885 = path.getOrDefault("linkId")
  valid_579885 = validateParameter(valid_579885, JString, required = true,
                                 default = nil)
  if valid_579885 != nil:
    section.add "linkId", valid_579885
  var valid_579886 = path.getOrDefault("accountId")
  valid_579886 = validateParameter(valid_579886, JString, required = true,
                                 default = nil)
  if valid_579886 != nil:
    section.add "accountId", valid_579886
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579887 = query.getOrDefault("key")
  valid_579887 = validateParameter(valid_579887, JString, required = false,
                                 default = nil)
  if valid_579887 != nil:
    section.add "key", valid_579887
  var valid_579888 = query.getOrDefault("prettyPrint")
  valid_579888 = validateParameter(valid_579888, JBool, required = false,
                                 default = newJBool(false))
  if valid_579888 != nil:
    section.add "prettyPrint", valid_579888
  var valid_579889 = query.getOrDefault("oauth_token")
  valid_579889 = validateParameter(valid_579889, JString, required = false,
                                 default = nil)
  if valid_579889 != nil:
    section.add "oauth_token", valid_579889
  var valid_579890 = query.getOrDefault("alt")
  valid_579890 = validateParameter(valid_579890, JString, required = false,
                                 default = newJString("json"))
  if valid_579890 != nil:
    section.add "alt", valid_579890
  var valid_579891 = query.getOrDefault("userIp")
  valid_579891 = validateParameter(valid_579891, JString, required = false,
                                 default = nil)
  if valid_579891 != nil:
    section.add "userIp", valid_579891
  var valid_579892 = query.getOrDefault("quotaUser")
  valid_579892 = validateParameter(valid_579892, JString, required = false,
                                 default = nil)
  if valid_579892 != nil:
    section.add "quotaUser", valid_579892
  var valid_579893 = query.getOrDefault("fields")
  valid_579893 = validateParameter(valid_579893, JString, required = false,
                                 default = nil)
  if valid_579893 != nil:
    section.add "fields", valid_579893
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579894: Call_AnalyticsManagementProfileUserLinksDelete_579880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given view (profile).
  ## 
  let valid = call_579894.validator(path, query, header, formData, body)
  let scheme = call_579894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579894.url(scheme.get, call_579894.host, call_579894.base,
                         call_579894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579894, url, valid)

proc call*(call_579895: Call_AnalyticsManagementProfileUserLinksDelete_579880;
          webPropertyId: string; profileId: string; linkId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementProfileUserLinksDelete
  ## Removes a user from the given view (profile).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to delete the user link for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to delete the user link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579896 = newJObject()
  var query_579897 = newJObject()
  add(query_579897, "key", newJString(key))
  add(query_579897, "prettyPrint", newJBool(prettyPrint))
  add(query_579897, "oauth_token", newJString(oauthToken))
  add(path_579896, "webPropertyId", newJString(webPropertyId))
  add(path_579896, "profileId", newJString(profileId))
  add(query_579897, "alt", newJString(alt))
  add(query_579897, "userIp", newJString(userIp))
  add(query_579897, "quotaUser", newJString(quotaUser))
  add(path_579896, "linkId", newJString(linkId))
  add(path_579896, "accountId", newJString(accountId))
  add(query_579897, "fields", newJString(fields))
  result = call_579895.call(path_579896, query_579897, nil, nil, nil)

var analyticsManagementProfileUserLinksDelete* = Call_AnalyticsManagementProfileUserLinksDelete_579880(
    name: "analyticsManagementProfileUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksDelete_579881,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksDelete_579882,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsInsert_579917 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementExperimentsInsert_579919(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/experiments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsInsert_579918(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the experiment for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the experiment for.
  ##   accountId: JString (required)
  ##            : Account ID to create the experiment for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579920 = path.getOrDefault("webPropertyId")
  valid_579920 = validateParameter(valid_579920, JString, required = true,
                                 default = nil)
  if valid_579920 != nil:
    section.add "webPropertyId", valid_579920
  var valid_579921 = path.getOrDefault("profileId")
  valid_579921 = validateParameter(valid_579921, JString, required = true,
                                 default = nil)
  if valid_579921 != nil:
    section.add "profileId", valid_579921
  var valid_579922 = path.getOrDefault("accountId")
  valid_579922 = validateParameter(valid_579922, JString, required = true,
                                 default = nil)
  if valid_579922 != nil:
    section.add "accountId", valid_579922
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579923 = query.getOrDefault("key")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "key", valid_579923
  var valid_579924 = query.getOrDefault("prettyPrint")
  valid_579924 = validateParameter(valid_579924, JBool, required = false,
                                 default = newJBool(false))
  if valid_579924 != nil:
    section.add "prettyPrint", valid_579924
  var valid_579925 = query.getOrDefault("oauth_token")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "oauth_token", valid_579925
  var valid_579926 = query.getOrDefault("alt")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = newJString("json"))
  if valid_579926 != nil:
    section.add "alt", valid_579926
  var valid_579927 = query.getOrDefault("userIp")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "userIp", valid_579927
  var valid_579928 = query.getOrDefault("quotaUser")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "quotaUser", valid_579928
  var valid_579929 = query.getOrDefault("fields")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "fields", valid_579929
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

proc call*(call_579931: Call_AnalyticsManagementExperimentsInsert_579917;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new experiment.
  ## 
  let valid = call_579931.validator(path, query, header, formData, body)
  let scheme = call_579931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579931.url(scheme.get, call_579931.host, call_579931.base,
                         call_579931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579931, url, valid)

proc call*(call_579932: Call_AnalyticsManagementExperimentsInsert_579917;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementExperimentsInsert
  ## Create a new experiment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the experiment for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the experiment for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the experiment for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579933 = newJObject()
  var query_579934 = newJObject()
  var body_579935 = newJObject()
  add(query_579934, "key", newJString(key))
  add(query_579934, "prettyPrint", newJBool(prettyPrint))
  add(query_579934, "oauth_token", newJString(oauthToken))
  add(path_579933, "webPropertyId", newJString(webPropertyId))
  add(path_579933, "profileId", newJString(profileId))
  add(query_579934, "alt", newJString(alt))
  add(query_579934, "userIp", newJString(userIp))
  add(query_579934, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579935 = body
  add(path_579933, "accountId", newJString(accountId))
  add(query_579934, "fields", newJString(fields))
  result = call_579932.call(path_579933, query_579934, nil, nil, body_579935)

var analyticsManagementExperimentsInsert* = Call_AnalyticsManagementExperimentsInsert_579917(
    name: "analyticsManagementExperimentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsInsert_579918,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsInsert_579919,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsList_579898 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementExperimentsList_579900(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/experiments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsList_579899(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists experiments to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve experiments for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve experiments for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve experiments for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579901 = path.getOrDefault("webPropertyId")
  valid_579901 = validateParameter(valid_579901, JString, required = true,
                                 default = nil)
  if valid_579901 != nil:
    section.add "webPropertyId", valid_579901
  var valid_579902 = path.getOrDefault("profileId")
  valid_579902 = validateParameter(valid_579902, JString, required = true,
                                 default = nil)
  if valid_579902 != nil:
    section.add "profileId", valid_579902
  var valid_579903 = path.getOrDefault("accountId")
  valid_579903 = validateParameter(valid_579903, JString, required = true,
                                 default = nil)
  if valid_579903 != nil:
    section.add "accountId", valid_579903
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
  ##              : An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of experiments to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579904 = query.getOrDefault("key")
  valid_579904 = validateParameter(valid_579904, JString, required = false,
                                 default = nil)
  if valid_579904 != nil:
    section.add "key", valid_579904
  var valid_579905 = query.getOrDefault("prettyPrint")
  valid_579905 = validateParameter(valid_579905, JBool, required = false,
                                 default = newJBool(false))
  if valid_579905 != nil:
    section.add "prettyPrint", valid_579905
  var valid_579906 = query.getOrDefault("oauth_token")
  valid_579906 = validateParameter(valid_579906, JString, required = false,
                                 default = nil)
  if valid_579906 != nil:
    section.add "oauth_token", valid_579906
  var valid_579907 = query.getOrDefault("alt")
  valid_579907 = validateParameter(valid_579907, JString, required = false,
                                 default = newJString("json"))
  if valid_579907 != nil:
    section.add "alt", valid_579907
  var valid_579908 = query.getOrDefault("userIp")
  valid_579908 = validateParameter(valid_579908, JString, required = false,
                                 default = nil)
  if valid_579908 != nil:
    section.add "userIp", valid_579908
  var valid_579909 = query.getOrDefault("quotaUser")
  valid_579909 = validateParameter(valid_579909, JString, required = false,
                                 default = nil)
  if valid_579909 != nil:
    section.add "quotaUser", valid_579909
  var valid_579910 = query.getOrDefault("start-index")
  valid_579910 = validateParameter(valid_579910, JInt, required = false, default = nil)
  if valid_579910 != nil:
    section.add "start-index", valid_579910
  var valid_579911 = query.getOrDefault("max-results")
  valid_579911 = validateParameter(valid_579911, JInt, required = false, default = nil)
  if valid_579911 != nil:
    section.add "max-results", valid_579911
  var valid_579912 = query.getOrDefault("fields")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "fields", valid_579912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579913: Call_AnalyticsManagementExperimentsList_579898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists experiments to which the user has access.
  ## 
  let valid = call_579913.validator(path, query, header, formData, body)
  let scheme = call_579913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579913.url(scheme.get, call_579913.host, call_579913.base,
                         call_579913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579913, url, valid)

proc call*(call_579914: Call_AnalyticsManagementExperimentsList_579898;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementExperimentsList
  ## Lists experiments to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve experiments for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve experiments for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of experiments to include in this response.
  ##   accountId: string (required)
  ##            : Account ID to retrieve experiments for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579915 = newJObject()
  var query_579916 = newJObject()
  add(query_579916, "key", newJString(key))
  add(query_579916, "prettyPrint", newJBool(prettyPrint))
  add(query_579916, "oauth_token", newJString(oauthToken))
  add(path_579915, "webPropertyId", newJString(webPropertyId))
  add(path_579915, "profileId", newJString(profileId))
  add(query_579916, "alt", newJString(alt))
  add(query_579916, "userIp", newJString(userIp))
  add(query_579916, "quotaUser", newJString(quotaUser))
  add(query_579916, "start-index", newJInt(startIndex))
  add(query_579916, "max-results", newJInt(maxResults))
  add(path_579915, "accountId", newJString(accountId))
  add(query_579916, "fields", newJString(fields))
  result = call_579914.call(path_579915, query_579916, nil, nil, nil)

var analyticsManagementExperimentsList* = Call_AnalyticsManagementExperimentsList_579898(
    name: "analyticsManagementExperimentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsList_579899,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsList_579900,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsUpdate_579954 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementExperimentsUpdate_579956(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementExperimentsUpdate_579955(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID of the experiment to update.
  ##   profileId: JString (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   accountId: JString (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: JString (required)
  ##               : Experiment ID of the experiment to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579957 = path.getOrDefault("webPropertyId")
  valid_579957 = validateParameter(valid_579957, JString, required = true,
                                 default = nil)
  if valid_579957 != nil:
    section.add "webPropertyId", valid_579957
  var valid_579958 = path.getOrDefault("profileId")
  valid_579958 = validateParameter(valid_579958, JString, required = true,
                                 default = nil)
  if valid_579958 != nil:
    section.add "profileId", valid_579958
  var valid_579959 = path.getOrDefault("accountId")
  valid_579959 = validateParameter(valid_579959, JString, required = true,
                                 default = nil)
  if valid_579959 != nil:
    section.add "accountId", valid_579959
  var valid_579960 = path.getOrDefault("experimentId")
  valid_579960 = validateParameter(valid_579960, JString, required = true,
                                 default = nil)
  if valid_579960 != nil:
    section.add "experimentId", valid_579960
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579961 = query.getOrDefault("key")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "key", valid_579961
  var valid_579962 = query.getOrDefault("prettyPrint")
  valid_579962 = validateParameter(valid_579962, JBool, required = false,
                                 default = newJBool(false))
  if valid_579962 != nil:
    section.add "prettyPrint", valid_579962
  var valid_579963 = query.getOrDefault("oauth_token")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "oauth_token", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("userIp")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "userIp", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("fields")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "fields", valid_579967
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

proc call*(call_579969: Call_AnalyticsManagementExperimentsUpdate_579954;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_AnalyticsManagementExperimentsUpdate_579954;
          webPropertyId: string; profileId: string; accountId: string;
          experimentId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementExperimentsUpdate
  ## Update an existing experiment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID of the experiment to update.
  ##   profileId: string (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: string (required)
  ##               : Experiment ID of the experiment to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579971 = newJObject()
  var query_579972 = newJObject()
  var body_579973 = newJObject()
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(path_579971, "webPropertyId", newJString(webPropertyId))
  add(path_579971, "profileId", newJString(profileId))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "userIp", newJString(userIp))
  add(query_579972, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579973 = body
  add(path_579971, "accountId", newJString(accountId))
  add(path_579971, "experimentId", newJString(experimentId))
  add(query_579972, "fields", newJString(fields))
  result = call_579970.call(path_579971, query_579972, nil, nil, body_579973)

var analyticsManagementExperimentsUpdate* = Call_AnalyticsManagementExperimentsUpdate_579954(
    name: "analyticsManagementExperimentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsUpdate_579955,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsUpdate_579956,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsGet_579936 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementExperimentsGet_579938(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementExperimentsGet_579937(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an experiment to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the experiment for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the experiment for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the experiment for.
  ##   experimentId: JString (required)
  ##               : Experiment ID to retrieve the experiment for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579939 = path.getOrDefault("webPropertyId")
  valid_579939 = validateParameter(valid_579939, JString, required = true,
                                 default = nil)
  if valid_579939 != nil:
    section.add "webPropertyId", valid_579939
  var valid_579940 = path.getOrDefault("profileId")
  valid_579940 = validateParameter(valid_579940, JString, required = true,
                                 default = nil)
  if valid_579940 != nil:
    section.add "profileId", valid_579940
  var valid_579941 = path.getOrDefault("accountId")
  valid_579941 = validateParameter(valid_579941, JString, required = true,
                                 default = nil)
  if valid_579941 != nil:
    section.add "accountId", valid_579941
  var valid_579942 = path.getOrDefault("experimentId")
  valid_579942 = validateParameter(valid_579942, JString, required = true,
                                 default = nil)
  if valid_579942 != nil:
    section.add "experimentId", valid_579942
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579943 = query.getOrDefault("key")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "key", valid_579943
  var valid_579944 = query.getOrDefault("prettyPrint")
  valid_579944 = validateParameter(valid_579944, JBool, required = false,
                                 default = newJBool(false))
  if valid_579944 != nil:
    section.add "prettyPrint", valid_579944
  var valid_579945 = query.getOrDefault("oauth_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "oauth_token", valid_579945
  var valid_579946 = query.getOrDefault("alt")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = newJString("json"))
  if valid_579946 != nil:
    section.add "alt", valid_579946
  var valid_579947 = query.getOrDefault("userIp")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "userIp", valid_579947
  var valid_579948 = query.getOrDefault("quotaUser")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "quotaUser", valid_579948
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579950: Call_AnalyticsManagementExperimentsGet_579936;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns an experiment to which the user has access.
  ## 
  let valid = call_579950.validator(path, query, header, formData, body)
  let scheme = call_579950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579950.url(scheme.get, call_579950.host, call_579950.base,
                         call_579950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579950, url, valid)

proc call*(call_579951: Call_AnalyticsManagementExperimentsGet_579936;
          webPropertyId: string; profileId: string; accountId: string;
          experimentId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementExperimentsGet
  ## Returns an experiment to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the experiment for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the experiment for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the experiment for.
  ##   experimentId: string (required)
  ##               : Experiment ID to retrieve the experiment for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579952 = newJObject()
  var query_579953 = newJObject()
  add(query_579953, "key", newJString(key))
  add(query_579953, "prettyPrint", newJBool(prettyPrint))
  add(query_579953, "oauth_token", newJString(oauthToken))
  add(path_579952, "webPropertyId", newJString(webPropertyId))
  add(path_579952, "profileId", newJString(profileId))
  add(query_579953, "alt", newJString(alt))
  add(query_579953, "userIp", newJString(userIp))
  add(query_579953, "quotaUser", newJString(quotaUser))
  add(path_579952, "accountId", newJString(accountId))
  add(path_579952, "experimentId", newJString(experimentId))
  add(query_579953, "fields", newJString(fields))
  result = call_579951.call(path_579952, query_579953, nil, nil, nil)

var analyticsManagementExperimentsGet* = Call_AnalyticsManagementExperimentsGet_579936(
    name: "analyticsManagementExperimentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsGet_579937,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsGet_579938,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsPatch_579992 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementExperimentsPatch_579994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementExperimentsPatch_579993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing experiment. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID of the experiment to update.
  ##   profileId: JString (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   accountId: JString (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: JString (required)
  ##               : Experiment ID of the experiment to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579995 = path.getOrDefault("webPropertyId")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "webPropertyId", valid_579995
  var valid_579996 = path.getOrDefault("profileId")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "profileId", valid_579996
  var valid_579997 = path.getOrDefault("accountId")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "accountId", valid_579997
  var valid_579998 = path.getOrDefault("experimentId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "experimentId", valid_579998
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(false))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("alt")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("json"))
  if valid_580002 != nil:
    section.add "alt", valid_580002
  var valid_580003 = query.getOrDefault("userIp")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "userIp", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
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

proc call*(call_580007: Call_AnalyticsManagementExperimentsPatch_579992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment. This method supports patch semantics.
  ## 
  let valid = call_580007.validator(path, query, header, formData, body)
  let scheme = call_580007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580007.url(scheme.get, call_580007.host, call_580007.base,
                         call_580007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580007, url, valid)

proc call*(call_580008: Call_AnalyticsManagementExperimentsPatch_579992;
          webPropertyId: string; profileId: string; accountId: string;
          experimentId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementExperimentsPatch
  ## Update an existing experiment. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID of the experiment to update.
  ##   profileId: string (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: string (required)
  ##               : Experiment ID of the experiment to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580009 = newJObject()
  var query_580010 = newJObject()
  var body_580011 = newJObject()
  add(query_580010, "key", newJString(key))
  add(query_580010, "prettyPrint", newJBool(prettyPrint))
  add(query_580010, "oauth_token", newJString(oauthToken))
  add(path_580009, "webPropertyId", newJString(webPropertyId))
  add(path_580009, "profileId", newJString(profileId))
  add(query_580010, "alt", newJString(alt))
  add(query_580010, "userIp", newJString(userIp))
  add(query_580010, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580011 = body
  add(path_580009, "accountId", newJString(accountId))
  add(path_580009, "experimentId", newJString(experimentId))
  add(query_580010, "fields", newJString(fields))
  result = call_580008.call(path_580009, query_580010, nil, nil, body_580011)

var analyticsManagementExperimentsPatch* = Call_AnalyticsManagementExperimentsPatch_579992(
    name: "analyticsManagementExperimentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsPatch_579993,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsPatch_579994,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsDelete_579974 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementExperimentsDelete_579976(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementExperimentsDelete_579975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the experiment belongs
  ##   profileId: JString (required)
  ##            : View (Profile) ID to which the experiment belongs
  ##   accountId: JString (required)
  ##            : Account ID to which the experiment belongs
  ##   experimentId: JString (required)
  ##               : ID of the experiment to delete
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_579977 = path.getOrDefault("webPropertyId")
  valid_579977 = validateParameter(valid_579977, JString, required = true,
                                 default = nil)
  if valid_579977 != nil:
    section.add "webPropertyId", valid_579977
  var valid_579978 = path.getOrDefault("profileId")
  valid_579978 = validateParameter(valid_579978, JString, required = true,
                                 default = nil)
  if valid_579978 != nil:
    section.add "profileId", valid_579978
  var valid_579979 = path.getOrDefault("accountId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "accountId", valid_579979
  var valid_579980 = path.getOrDefault("experimentId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "experimentId", valid_579980
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(false))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_AnalyticsManagementExperimentsDelete_579974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an experiment.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_AnalyticsManagementExperimentsDelete_579974;
          webPropertyId: string; profileId: string; accountId: string;
          experimentId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementExperimentsDelete
  ## Delete an experiment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the experiment belongs
  ##   profileId: string (required)
  ##            : View (Profile) ID to which the experiment belongs
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID to which the experiment belongs
  ##   experimentId: string (required)
  ##               : ID of the experiment to delete
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  add(query_579991, "key", newJString(key))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(path_579990, "webPropertyId", newJString(webPropertyId))
  add(path_579990, "profileId", newJString(profileId))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "userIp", newJString(userIp))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(path_579990, "accountId", newJString(accountId))
  add(path_579990, "experimentId", newJString(experimentId))
  add(query_579991, "fields", newJString(fields))
  result = call_579989.call(path_579990, query_579991, nil, nil, nil)

var analyticsManagementExperimentsDelete* = Call_AnalyticsManagementExperimentsDelete_579974(
    name: "analyticsManagementExperimentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsDelete_579975,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsDelete_579976,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsInsert_580031 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementGoalsInsert_580033(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsInsert_580032(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new goal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the goal for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the goal for.
  ##   accountId: JString (required)
  ##            : Account ID to create the goal for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580034 = path.getOrDefault("webPropertyId")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "webPropertyId", valid_580034
  var valid_580035 = path.getOrDefault("profileId")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "profileId", valid_580035
  var valid_580036 = path.getOrDefault("accountId")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "accountId", valid_580036
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(false))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("alt")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("json"))
  if valid_580040 != nil:
    section.add "alt", valid_580040
  var valid_580041 = query.getOrDefault("userIp")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "userIp", valid_580041
  var valid_580042 = query.getOrDefault("quotaUser")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "quotaUser", valid_580042
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
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

proc call*(call_580045: Call_AnalyticsManagementGoalsInsert_580031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new goal.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_AnalyticsManagementGoalsInsert_580031;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementGoalsInsert
  ## Create a new goal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the goal for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the goal for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the goal for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  var body_580049 = newJObject()
  add(query_580048, "key", newJString(key))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(path_580047, "webPropertyId", newJString(webPropertyId))
  add(path_580047, "profileId", newJString(profileId))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "userIp", newJString(userIp))
  add(query_580048, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580049 = body
  add(path_580047, "accountId", newJString(accountId))
  add(query_580048, "fields", newJString(fields))
  result = call_580046.call(path_580047, query_580048, nil, nil, body_580049)

var analyticsManagementGoalsInsert* = Call_AnalyticsManagementGoalsInsert_580031(
    name: "analyticsManagementGoalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsInsert_580032,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsInsert_580033,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsList_580012 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementGoalsList_580014(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsList_580013(path: JsonNode; query: JsonNode;
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
  var valid_580015 = path.getOrDefault("webPropertyId")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "webPropertyId", valid_580015
  var valid_580016 = path.getOrDefault("profileId")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "profileId", valid_580016
  var valid_580017 = path.getOrDefault("accountId")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = nil)
  if valid_580017 != nil:
    section.add "accountId", valid_580017
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
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(false))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("userIp")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "userIp", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("start-index")
  valid_580024 = validateParameter(valid_580024, JInt, required = false, default = nil)
  if valid_580024 != nil:
    section.add "start-index", valid_580024
  var valid_580025 = query.getOrDefault("max-results")
  valid_580025 = validateParameter(valid_580025, JInt, required = false, default = nil)
  if valid_580025 != nil:
    section.add "max-results", valid_580025
  var valid_580026 = query.getOrDefault("fields")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "fields", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580027: Call_AnalyticsManagementGoalsList_580012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists goals to which the user has access.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_AnalyticsManagementGoalsList_580012;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
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
  var path_580029 = newJObject()
  var query_580030 = newJObject()
  add(query_580030, "key", newJString(key))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(path_580029, "webPropertyId", newJString(webPropertyId))
  add(path_580029, "profileId", newJString(profileId))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "userIp", newJString(userIp))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(query_580030, "start-index", newJInt(startIndex))
  add(query_580030, "max-results", newJInt(maxResults))
  add(path_580029, "accountId", newJString(accountId))
  add(query_580030, "fields", newJString(fields))
  result = call_580028.call(path_580029, query_580030, nil, nil, nil)

var analyticsManagementGoalsList* = Call_AnalyticsManagementGoalsList_580012(
    name: "analyticsManagementGoalsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsList_580013,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsList_580014,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsUpdate_580068 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementGoalsUpdate_580070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementGoalsUpdate_580069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing goal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the goal.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to update the goal.
  ##   goalId: JString (required)
  ##         : Index of the goal to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to update the goal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580071 = path.getOrDefault("webPropertyId")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "webPropertyId", valid_580071
  var valid_580072 = path.getOrDefault("profileId")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "profileId", valid_580072
  var valid_580073 = path.getOrDefault("goalId")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "goalId", valid_580073
  var valid_580074 = path.getOrDefault("accountId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "accountId", valid_580074
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(false))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("userIp")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "userIp", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("fields")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "fields", valid_580081
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

proc call*(call_580083: Call_AnalyticsManagementGoalsUpdate_580068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_AnalyticsManagementGoalsUpdate_580068;
          webPropertyId: string; profileId: string; goalId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementGoalsUpdate
  ## Updates an existing goal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the goal.
  ##   profileId: string (required)
  ##            : View (Profile) ID to update the goal.
  ##   goalId: string (required)
  ##         : Index of the goal to be updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to update the goal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  var body_580087 = newJObject()
  add(query_580086, "key", newJString(key))
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(path_580085, "webPropertyId", newJString(webPropertyId))
  add(path_580085, "profileId", newJString(profileId))
  add(path_580085, "goalId", newJString(goalId))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "userIp", newJString(userIp))
  add(query_580086, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580087 = body
  add(path_580085, "accountId", newJString(accountId))
  add(query_580086, "fields", newJString(fields))
  result = call_580084.call(path_580085, query_580086, nil, nil, body_580087)

var analyticsManagementGoalsUpdate* = Call_AnalyticsManagementGoalsUpdate_580068(
    name: "analyticsManagementGoalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsUpdate_580069,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsUpdate_580070,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsGet_580050 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementGoalsGet_580052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementGoalsGet_580051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a goal to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the goal for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the goal for.
  ##   goalId: JString (required)
  ##         : Goal ID to retrieve the goal for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the goal for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580053 = path.getOrDefault("webPropertyId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "webPropertyId", valid_580053
  var valid_580054 = path.getOrDefault("profileId")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "profileId", valid_580054
  var valid_580055 = path.getOrDefault("goalId")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "goalId", valid_580055
  var valid_580056 = path.getOrDefault("accountId")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "accountId", valid_580056
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(false))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("alt")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("json"))
  if valid_580060 != nil:
    section.add "alt", valid_580060
  var valid_580061 = query.getOrDefault("userIp")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "userIp", valid_580061
  var valid_580062 = query.getOrDefault("quotaUser")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "quotaUser", valid_580062
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580064: Call_AnalyticsManagementGoalsGet_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a goal to which the user has access.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_AnalyticsManagementGoalsGet_580050;
          webPropertyId: string; profileId: string; goalId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementGoalsGet
  ## Gets a goal to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the goal for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the goal for.
  ##   goalId: string (required)
  ##         : Goal ID to retrieve the goal for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the goal for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  add(query_580067, "key", newJString(key))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(path_580066, "webPropertyId", newJString(webPropertyId))
  add(path_580066, "profileId", newJString(profileId))
  add(path_580066, "goalId", newJString(goalId))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "userIp", newJString(userIp))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(path_580066, "accountId", newJString(accountId))
  add(query_580067, "fields", newJString(fields))
  result = call_580065.call(path_580066, query_580067, nil, nil, nil)

var analyticsManagementGoalsGet* = Call_AnalyticsManagementGoalsGet_580050(
    name: "analyticsManagementGoalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsGet_580051, base: "/analytics/v3",
    url: url_AnalyticsManagementGoalsGet_580052, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsPatch_580088 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementGoalsPatch_580090(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementGoalsPatch_580089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing goal. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the goal.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to update the goal.
  ##   goalId: JString (required)
  ##         : Index of the goal to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to update the goal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580091 = path.getOrDefault("webPropertyId")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "webPropertyId", valid_580091
  var valid_580092 = path.getOrDefault("profileId")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "profileId", valid_580092
  var valid_580093 = path.getOrDefault("goalId")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "goalId", valid_580093
  var valid_580094 = path.getOrDefault("accountId")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "accountId", valid_580094
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(false))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("userIp")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userIp", valid_580099
  var valid_580100 = query.getOrDefault("quotaUser")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "quotaUser", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
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

proc call*(call_580103: Call_AnalyticsManagementGoalsPatch_580088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal. This method supports patch semantics.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_AnalyticsManagementGoalsPatch_580088;
          webPropertyId: string; profileId: string; goalId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementGoalsPatch
  ## Updates an existing goal. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the goal.
  ##   profileId: string (required)
  ##            : View (Profile) ID to update the goal.
  ##   goalId: string (required)
  ##         : Index of the goal to be updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to update the goal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  var body_580107 = newJObject()
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(path_580105, "webPropertyId", newJString(webPropertyId))
  add(path_580105, "profileId", newJString(profileId))
  add(path_580105, "goalId", newJString(goalId))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580107 = body
  add(path_580105, "accountId", newJString(accountId))
  add(query_580106, "fields", newJString(fields))
  result = call_580104.call(path_580105, query_580106, nil, nil, body_580107)

var analyticsManagementGoalsPatch* = Call_AnalyticsManagementGoalsPatch_580088(
    name: "analyticsManagementGoalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsPatch_580089,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsPatch_580090,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksInsert_580127 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileFilterLinksInsert_580129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/profileFilterLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksInsert_580128(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id to create profile filter link for.
  ##   profileId: JString (required)
  ##            : Profile ID to create filter link for.
  ##   accountId: JString (required)
  ##            : Account ID to create profile filter link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580130 = path.getOrDefault("webPropertyId")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "webPropertyId", valid_580130
  var valid_580131 = path.getOrDefault("profileId")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "profileId", valid_580131
  var valid_580132 = path.getOrDefault("accountId")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "accountId", valid_580132
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580133 = query.getOrDefault("key")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "key", valid_580133
  var valid_580134 = query.getOrDefault("prettyPrint")
  valid_580134 = validateParameter(valid_580134, JBool, required = false,
                                 default = newJBool(false))
  if valid_580134 != nil:
    section.add "prettyPrint", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("alt")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("json"))
  if valid_580136 != nil:
    section.add "alt", valid_580136
  var valid_580137 = query.getOrDefault("userIp")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "userIp", valid_580137
  var valid_580138 = query.getOrDefault("quotaUser")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "quotaUser", valid_580138
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
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

proc call*(call_580141: Call_AnalyticsManagementProfileFilterLinksInsert_580127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new profile filter link.
  ## 
  let valid = call_580141.validator(path, query, header, formData, body)
  let scheme = call_580141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580141.url(scheme.get, call_580141.host, call_580141.base,
                         call_580141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580141, url, valid)

proc call*(call_580142: Call_AnalyticsManagementProfileFilterLinksInsert_580127;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementProfileFilterLinksInsert
  ## Create a new profile filter link.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id to create profile filter link for.
  ##   profileId: string (required)
  ##            : Profile ID to create filter link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create profile filter link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580143 = newJObject()
  var query_580144 = newJObject()
  var body_580145 = newJObject()
  add(query_580144, "key", newJString(key))
  add(query_580144, "prettyPrint", newJBool(prettyPrint))
  add(query_580144, "oauth_token", newJString(oauthToken))
  add(path_580143, "webPropertyId", newJString(webPropertyId))
  add(path_580143, "profileId", newJString(profileId))
  add(query_580144, "alt", newJString(alt))
  add(query_580144, "userIp", newJString(userIp))
  add(query_580144, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580145 = body
  add(path_580143, "accountId", newJString(accountId))
  add(query_580144, "fields", newJString(fields))
  result = call_580142.call(path_580143, query_580144, nil, nil, body_580145)

var analyticsManagementProfileFilterLinksInsert* = Call_AnalyticsManagementProfileFilterLinksInsert_580127(
    name: "analyticsManagementProfileFilterLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksInsert_580128,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksInsert_580129,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksList_580108 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileFilterLinksList_580110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/profileFilterLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksList_580109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all profile filter links for a profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id for profile filter links for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   profileId: JString (required)
  ##            : Profile ID to retrieve filter links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve profile filter links for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580111 = path.getOrDefault("webPropertyId")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "webPropertyId", valid_580111
  var valid_580112 = path.getOrDefault("profileId")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "profileId", valid_580112
  var valid_580113 = path.getOrDefault("accountId")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "accountId", valid_580113
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
  ##              : The maximum number of profile filter links to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580114 = query.getOrDefault("key")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "key", valid_580114
  var valid_580115 = query.getOrDefault("prettyPrint")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(false))
  if valid_580115 != nil:
    section.add "prettyPrint", valid_580115
  var valid_580116 = query.getOrDefault("oauth_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "oauth_token", valid_580116
  var valid_580117 = query.getOrDefault("alt")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("json"))
  if valid_580117 != nil:
    section.add "alt", valid_580117
  var valid_580118 = query.getOrDefault("userIp")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "userIp", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("start-index")
  valid_580120 = validateParameter(valid_580120, JInt, required = false, default = nil)
  if valid_580120 != nil:
    section.add "start-index", valid_580120
  var valid_580121 = query.getOrDefault("max-results")
  valid_580121 = validateParameter(valid_580121, JInt, required = false, default = nil)
  if valid_580121 != nil:
    section.add "max-results", valid_580121
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580123: Call_AnalyticsManagementProfileFilterLinksList_580108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all profile filter links for a profile.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_AnalyticsManagementProfileFilterLinksList_580108;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementProfileFilterLinksList
  ## Lists all profile filter links for a profile.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id for profile filter links for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   profileId: string (required)
  ##            : Profile ID to retrieve filter links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of profile filter links to include in this response.
  ##   accountId: string (required)
  ##            : Account ID to retrieve profile filter links for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580125 = newJObject()
  var query_580126 = newJObject()
  add(query_580126, "key", newJString(key))
  add(query_580126, "prettyPrint", newJBool(prettyPrint))
  add(query_580126, "oauth_token", newJString(oauthToken))
  add(path_580125, "webPropertyId", newJString(webPropertyId))
  add(path_580125, "profileId", newJString(profileId))
  add(query_580126, "alt", newJString(alt))
  add(query_580126, "userIp", newJString(userIp))
  add(query_580126, "quotaUser", newJString(quotaUser))
  add(query_580126, "start-index", newJInt(startIndex))
  add(query_580126, "max-results", newJInt(maxResults))
  add(path_580125, "accountId", newJString(accountId))
  add(query_580126, "fields", newJString(fields))
  result = call_580124.call(path_580125, query_580126, nil, nil, nil)

var analyticsManagementProfileFilterLinksList* = Call_AnalyticsManagementProfileFilterLinksList_580108(
    name: "analyticsManagementProfileFilterLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksList_580109,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksList_580110,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksUpdate_580164 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileFilterLinksUpdate_580166(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementProfileFilterLinksUpdate_580165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which profile filter link belongs
  ##   profileId: JString (required)
  ##            : Profile ID to which filter link belongs
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which profile filter link belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580167 = path.getOrDefault("webPropertyId")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "webPropertyId", valid_580167
  var valid_580168 = path.getOrDefault("profileId")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "profileId", valid_580168
  var valid_580169 = path.getOrDefault("linkId")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "linkId", valid_580169
  var valid_580170 = path.getOrDefault("accountId")
  valid_580170 = validateParameter(valid_580170, JString, required = true,
                                 default = nil)
  if valid_580170 != nil:
    section.add "accountId", valid_580170
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580171 = query.getOrDefault("key")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "key", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(false))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("userIp")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "userIp", valid_580175
  var valid_580176 = query.getOrDefault("quotaUser")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "quotaUser", valid_580176
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
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

proc call*(call_580179: Call_AnalyticsManagementProfileFilterLinksUpdate_580164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_AnalyticsManagementProfileFilterLinksUpdate_580164;
          webPropertyId: string; profileId: string; linkId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementProfileFilterLinksUpdate
  ## Update an existing profile filter link.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which profile filter link belongs
  ##   profileId: string (required)
  ##            : Profile ID to which filter link belongs
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to be updated.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which profile filter link belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  var body_580183 = newJObject()
  add(query_580182, "key", newJString(key))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(path_580181, "webPropertyId", newJString(webPropertyId))
  add(path_580181, "profileId", newJString(profileId))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "userIp", newJString(userIp))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(path_580181, "linkId", newJString(linkId))
  if body != nil:
    body_580183 = body
  add(path_580181, "accountId", newJString(accountId))
  add(query_580182, "fields", newJString(fields))
  result = call_580180.call(path_580181, query_580182, nil, nil, body_580183)

var analyticsManagementProfileFilterLinksUpdate* = Call_AnalyticsManagementProfileFilterLinksUpdate_580164(
    name: "analyticsManagementProfileFilterLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksUpdate_580165,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksUpdate_580166,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksGet_580146 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileFilterLinksGet_580148(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementProfileFilterLinksGet_580147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id to retrieve profile filter link for.
  ##   profileId: JString (required)
  ##            : Profile ID to retrieve filter link for.
  ##   linkId: JString (required)
  ##         : ID of the profile filter link.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve profile filter link for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580149 = path.getOrDefault("webPropertyId")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "webPropertyId", valid_580149
  var valid_580150 = path.getOrDefault("profileId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "profileId", valid_580150
  var valid_580151 = path.getOrDefault("linkId")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "linkId", valid_580151
  var valid_580152 = path.getOrDefault("accountId")
  valid_580152 = validateParameter(valid_580152, JString, required = true,
                                 default = nil)
  if valid_580152 != nil:
    section.add "accountId", valid_580152
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("prettyPrint")
  valid_580154 = validateParameter(valid_580154, JBool, required = false,
                                 default = newJBool(false))
  if valid_580154 != nil:
    section.add "prettyPrint", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("alt")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("json"))
  if valid_580156 != nil:
    section.add "alt", valid_580156
  var valid_580157 = query.getOrDefault("userIp")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "userIp", valid_580157
  var valid_580158 = query.getOrDefault("quotaUser")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "quotaUser", valid_580158
  var valid_580159 = query.getOrDefault("fields")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "fields", valid_580159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580160: Call_AnalyticsManagementProfileFilterLinksGet_580146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single profile filter link.
  ## 
  let valid = call_580160.validator(path, query, header, formData, body)
  let scheme = call_580160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580160.url(scheme.get, call_580160.host, call_580160.base,
                         call_580160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580160, url, valid)

proc call*(call_580161: Call_AnalyticsManagementProfileFilterLinksGet_580146;
          webPropertyId: string; profileId: string; linkId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementProfileFilterLinksGet
  ## Returns a single profile filter link.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id to retrieve profile filter link for.
  ##   profileId: string (required)
  ##            : Profile ID to retrieve filter link for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : ID of the profile filter link.
  ##   accountId: string (required)
  ##            : Account ID to retrieve profile filter link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580162 = newJObject()
  var query_580163 = newJObject()
  add(query_580163, "key", newJString(key))
  add(query_580163, "prettyPrint", newJBool(prettyPrint))
  add(query_580163, "oauth_token", newJString(oauthToken))
  add(path_580162, "webPropertyId", newJString(webPropertyId))
  add(path_580162, "profileId", newJString(profileId))
  add(query_580163, "alt", newJString(alt))
  add(query_580163, "userIp", newJString(userIp))
  add(query_580163, "quotaUser", newJString(quotaUser))
  add(path_580162, "linkId", newJString(linkId))
  add(path_580162, "accountId", newJString(accountId))
  add(query_580163, "fields", newJString(fields))
  result = call_580161.call(path_580162, query_580163, nil, nil, nil)

var analyticsManagementProfileFilterLinksGet* = Call_AnalyticsManagementProfileFilterLinksGet_580146(
    name: "analyticsManagementProfileFilterLinksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksGet_580147,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksGet_580148,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksPatch_580202 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileFilterLinksPatch_580204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementProfileFilterLinksPatch_580203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing profile filter link. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which profile filter link belongs
  ##   profileId: JString (required)
  ##            : Profile ID to which filter link belongs
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which profile filter link belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580205 = path.getOrDefault("webPropertyId")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "webPropertyId", valid_580205
  var valid_580206 = path.getOrDefault("profileId")
  valid_580206 = validateParameter(valid_580206, JString, required = true,
                                 default = nil)
  if valid_580206 != nil:
    section.add "profileId", valid_580206
  var valid_580207 = path.getOrDefault("linkId")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "linkId", valid_580207
  var valid_580208 = path.getOrDefault("accountId")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "accountId", valid_580208
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580209 = query.getOrDefault("key")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "key", valid_580209
  var valid_580210 = query.getOrDefault("prettyPrint")
  valid_580210 = validateParameter(valid_580210, JBool, required = false,
                                 default = newJBool(false))
  if valid_580210 != nil:
    section.add "prettyPrint", valid_580210
  var valid_580211 = query.getOrDefault("oauth_token")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "oauth_token", valid_580211
  var valid_580212 = query.getOrDefault("alt")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("json"))
  if valid_580212 != nil:
    section.add "alt", valid_580212
  var valid_580213 = query.getOrDefault("userIp")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "userIp", valid_580213
  var valid_580214 = query.getOrDefault("quotaUser")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "quotaUser", valid_580214
  var valid_580215 = query.getOrDefault("fields")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "fields", valid_580215
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

proc call*(call_580217: Call_AnalyticsManagementProfileFilterLinksPatch_580202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link. This method supports patch semantics.
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_AnalyticsManagementProfileFilterLinksPatch_580202;
          webPropertyId: string; profileId: string; linkId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementProfileFilterLinksPatch
  ## Update an existing profile filter link. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which profile filter link belongs
  ##   profileId: string (required)
  ##            : Profile ID to which filter link belongs
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to be updated.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to which profile filter link belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580219 = newJObject()
  var query_580220 = newJObject()
  var body_580221 = newJObject()
  add(query_580220, "key", newJString(key))
  add(query_580220, "prettyPrint", newJBool(prettyPrint))
  add(query_580220, "oauth_token", newJString(oauthToken))
  add(path_580219, "webPropertyId", newJString(webPropertyId))
  add(path_580219, "profileId", newJString(profileId))
  add(query_580220, "alt", newJString(alt))
  add(query_580220, "userIp", newJString(userIp))
  add(query_580220, "quotaUser", newJString(quotaUser))
  add(path_580219, "linkId", newJString(linkId))
  if body != nil:
    body_580221 = body
  add(path_580219, "accountId", newJString(accountId))
  add(query_580220, "fields", newJString(fields))
  result = call_580218.call(path_580219, query_580220, nil, nil, body_580221)

var analyticsManagementProfileFilterLinksPatch* = Call_AnalyticsManagementProfileFilterLinksPatch_580202(
    name: "analyticsManagementProfileFilterLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksPatch_580203,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksPatch_580204,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksDelete_580184 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementProfileFilterLinksDelete_580186(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementProfileFilterLinksDelete_580185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which the profile filter link belongs.
  ##   profileId: JString (required)
  ##            : Profile ID to which the filter link belongs.
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to delete.
  ##   accountId: JString (required)
  ##            : Account ID to which the profile filter link belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580187 = path.getOrDefault("webPropertyId")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "webPropertyId", valid_580187
  var valid_580188 = path.getOrDefault("profileId")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "profileId", valid_580188
  var valid_580189 = path.getOrDefault("linkId")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = nil)
  if valid_580189 != nil:
    section.add "linkId", valid_580189
  var valid_580190 = path.getOrDefault("accountId")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "accountId", valid_580190
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580191 = query.getOrDefault("key")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "key", valid_580191
  var valid_580192 = query.getOrDefault("prettyPrint")
  valid_580192 = validateParameter(valid_580192, JBool, required = false,
                                 default = newJBool(false))
  if valid_580192 != nil:
    section.add "prettyPrint", valid_580192
  var valid_580193 = query.getOrDefault("oauth_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "oauth_token", valid_580193
  var valid_580194 = query.getOrDefault("alt")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("json"))
  if valid_580194 != nil:
    section.add "alt", valid_580194
  var valid_580195 = query.getOrDefault("userIp")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "userIp", valid_580195
  var valid_580196 = query.getOrDefault("quotaUser")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "quotaUser", valid_580196
  var valid_580197 = query.getOrDefault("fields")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "fields", valid_580197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580198: Call_AnalyticsManagementProfileFilterLinksDelete_580184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a profile filter link.
  ## 
  let valid = call_580198.validator(path, query, header, formData, body)
  let scheme = call_580198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580198.url(scheme.get, call_580198.host, call_580198.base,
                         call_580198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580198, url, valid)

proc call*(call_580199: Call_AnalyticsManagementProfileFilterLinksDelete_580184;
          webPropertyId: string; profileId: string; linkId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementProfileFilterLinksDelete
  ## Delete a profile filter link.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which the profile filter link belongs.
  ##   profileId: string (required)
  ##            : Profile ID to which the filter link belongs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to delete.
  ##   accountId: string (required)
  ##            : Account ID to which the profile filter link belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580200 = newJObject()
  var query_580201 = newJObject()
  add(query_580201, "key", newJString(key))
  add(query_580201, "prettyPrint", newJBool(prettyPrint))
  add(query_580201, "oauth_token", newJString(oauthToken))
  add(path_580200, "webPropertyId", newJString(webPropertyId))
  add(path_580200, "profileId", newJString(profileId))
  add(query_580201, "alt", newJString(alt))
  add(query_580201, "userIp", newJString(userIp))
  add(query_580201, "quotaUser", newJString(quotaUser))
  add(path_580200, "linkId", newJString(linkId))
  add(path_580200, "accountId", newJString(accountId))
  add(query_580201, "fields", newJString(fields))
  result = call_580199.call(path_580200, query_580201, nil, nil, nil)

var analyticsManagementProfileFilterLinksDelete* = Call_AnalyticsManagementProfileFilterLinksDelete_580184(
    name: "analyticsManagementProfileFilterLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksDelete_580185,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksDelete_580186,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsInsert_580241 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUnsampledReportsInsert_580243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/unsampledReports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsInsert_580242(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the unsampled report for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the unsampled report for.
  ##   accountId: JString (required)
  ##            : Account ID to create the unsampled report for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580244 = path.getOrDefault("webPropertyId")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "webPropertyId", valid_580244
  var valid_580245 = path.getOrDefault("profileId")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "profileId", valid_580245
  var valid_580246 = path.getOrDefault("accountId")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "accountId", valid_580246
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("prettyPrint")
  valid_580248 = validateParameter(valid_580248, JBool, required = false,
                                 default = newJBool(false))
  if valid_580248 != nil:
    section.add "prettyPrint", valid_580248
  var valid_580249 = query.getOrDefault("oauth_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "oauth_token", valid_580249
  var valid_580250 = query.getOrDefault("alt")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("json"))
  if valid_580250 != nil:
    section.add "alt", valid_580250
  var valid_580251 = query.getOrDefault("userIp")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "userIp", valid_580251
  var valid_580252 = query.getOrDefault("quotaUser")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "quotaUser", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
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

proc call*(call_580255: Call_AnalyticsManagementUnsampledReportsInsert_580241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new unsampled report.
  ## 
  let valid = call_580255.validator(path, query, header, formData, body)
  let scheme = call_580255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580255.url(scheme.get, call_580255.host, call_580255.base,
                         call_580255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580255, url, valid)

proc call*(call_580256: Call_AnalyticsManagementUnsampledReportsInsert_580241;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementUnsampledReportsInsert
  ## Create a new unsampled report.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the unsampled report for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the unsampled report for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account ID to create the unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580257 = newJObject()
  var query_580258 = newJObject()
  var body_580259 = newJObject()
  add(query_580258, "key", newJString(key))
  add(query_580258, "prettyPrint", newJBool(prettyPrint))
  add(query_580258, "oauth_token", newJString(oauthToken))
  add(path_580257, "webPropertyId", newJString(webPropertyId))
  add(path_580257, "profileId", newJString(profileId))
  add(query_580258, "alt", newJString(alt))
  add(query_580258, "userIp", newJString(userIp))
  add(query_580258, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580259 = body
  add(path_580257, "accountId", newJString(accountId))
  add(query_580258, "fields", newJString(fields))
  result = call_580256.call(path_580257, query_580258, nil, nil, body_580259)

var analyticsManagementUnsampledReportsInsert* = Call_AnalyticsManagementUnsampledReportsInsert_580241(
    name: "analyticsManagementUnsampledReportsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsInsert_580242,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsInsert_580243,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsList_580222 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUnsampledReportsList_580224(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/unsampledReports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsList_580223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists unsampled reports to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580225 = path.getOrDefault("webPropertyId")
  valid_580225 = validateParameter(valid_580225, JString, required = true,
                                 default = nil)
  if valid_580225 != nil:
    section.add "webPropertyId", valid_580225
  var valid_580226 = path.getOrDefault("profileId")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "profileId", valid_580226
  var valid_580227 = path.getOrDefault("accountId")
  valid_580227 = validateParameter(valid_580227, JString, required = true,
                                 default = nil)
  if valid_580227 != nil:
    section.add "accountId", valid_580227
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
  ##              : An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of unsampled reports to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580228 = query.getOrDefault("key")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "key", valid_580228
  var valid_580229 = query.getOrDefault("prettyPrint")
  valid_580229 = validateParameter(valid_580229, JBool, required = false,
                                 default = newJBool(false))
  if valid_580229 != nil:
    section.add "prettyPrint", valid_580229
  var valid_580230 = query.getOrDefault("oauth_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "oauth_token", valid_580230
  var valid_580231 = query.getOrDefault("alt")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("json"))
  if valid_580231 != nil:
    section.add "alt", valid_580231
  var valid_580232 = query.getOrDefault("userIp")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "userIp", valid_580232
  var valid_580233 = query.getOrDefault("quotaUser")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "quotaUser", valid_580233
  var valid_580234 = query.getOrDefault("start-index")
  valid_580234 = validateParameter(valid_580234, JInt, required = false, default = nil)
  if valid_580234 != nil:
    section.add "start-index", valid_580234
  var valid_580235 = query.getOrDefault("max-results")
  valid_580235 = validateParameter(valid_580235, JInt, required = false, default = nil)
  if valid_580235 != nil:
    section.add "max-results", valid_580235
  var valid_580236 = query.getOrDefault("fields")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "fields", valid_580236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580237: Call_AnalyticsManagementUnsampledReportsList_580222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unsampled reports to which the user has access.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_AnalyticsManagementUnsampledReportsList_580222;
          webPropertyId: string; profileId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementUnsampledReportsList
  ## Lists unsampled reports to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of unsampled reports to include in this response.
  ##   accountId: string (required)
  ##            : Account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  add(query_580240, "key", newJString(key))
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(path_580239, "webPropertyId", newJString(webPropertyId))
  add(path_580239, "profileId", newJString(profileId))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "userIp", newJString(userIp))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "start-index", newJInt(startIndex))
  add(query_580240, "max-results", newJInt(maxResults))
  add(path_580239, "accountId", newJString(accountId))
  add(query_580240, "fields", newJString(fields))
  result = call_580238.call(path_580239, query_580240, nil, nil, nil)

var analyticsManagementUnsampledReportsList* = Call_AnalyticsManagementUnsampledReportsList_580222(
    name: "analyticsManagementUnsampledReportsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsList_580223,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsList_580224,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsGet_580260 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUnsampledReportsGet_580262(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementUnsampledReportsGet_580261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve unsampled reports for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve unsampled report for.
  ##   unsampledReportId: JString (required)
  ##                    : ID of the unsampled report to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve unsampled report for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580263 = path.getOrDefault("webPropertyId")
  valid_580263 = validateParameter(valid_580263, JString, required = true,
                                 default = nil)
  if valid_580263 != nil:
    section.add "webPropertyId", valid_580263
  var valid_580264 = path.getOrDefault("profileId")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "profileId", valid_580264
  var valid_580265 = path.getOrDefault("unsampledReportId")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "unsampledReportId", valid_580265
  var valid_580266 = path.getOrDefault("accountId")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "accountId", valid_580266
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(false))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  var valid_580269 = query.getOrDefault("oauth_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "oauth_token", valid_580269
  var valid_580270 = query.getOrDefault("alt")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = newJString("json"))
  if valid_580270 != nil:
    section.add "alt", valid_580270
  var valid_580271 = query.getOrDefault("userIp")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "userIp", valid_580271
  var valid_580272 = query.getOrDefault("quotaUser")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "quotaUser", valid_580272
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580274: Call_AnalyticsManagementUnsampledReportsGet_580260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single unsampled report.
  ## 
  let valid = call_580274.validator(path, query, header, formData, body)
  let scheme = call_580274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580274.url(scheme.get, call_580274.host, call_580274.base,
                         call_580274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580274, url, valid)

proc call*(call_580275: Call_AnalyticsManagementUnsampledReportsGet_580260;
          webPropertyId: string; profileId: string; unsampledReportId: string;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementUnsampledReportsGet
  ## Returns a single unsampled report.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve unsampled reports for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve unsampled report for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   unsampledReportId: string (required)
  ##                    : ID of the unsampled report to retrieve.
  ##   accountId: string (required)
  ##            : Account ID to retrieve unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580276 = newJObject()
  var query_580277 = newJObject()
  add(query_580277, "key", newJString(key))
  add(query_580277, "prettyPrint", newJBool(prettyPrint))
  add(query_580277, "oauth_token", newJString(oauthToken))
  add(path_580276, "webPropertyId", newJString(webPropertyId))
  add(path_580276, "profileId", newJString(profileId))
  add(query_580277, "alt", newJString(alt))
  add(query_580277, "userIp", newJString(userIp))
  add(query_580277, "quotaUser", newJString(quotaUser))
  add(path_580276, "unsampledReportId", newJString(unsampledReportId))
  add(path_580276, "accountId", newJString(accountId))
  add(query_580277, "fields", newJString(fields))
  result = call_580275.call(path_580276, query_580277, nil, nil, nil)

var analyticsManagementUnsampledReportsGet* = Call_AnalyticsManagementUnsampledReportsGet_580260(
    name: "analyticsManagementUnsampledReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsGet_580261,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsGet_580262,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsDelete_580278 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementUnsampledReportsDelete_580280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementUnsampledReportsDelete_580279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the unsampled reports for.
  ##   profileId: JString (required)
  ##            : View (Profile) ID to delete the unsampled report for.
  ##   unsampledReportId: JString (required)
  ##                    : ID of the unsampled report to be deleted.
  ##   accountId: JString (required)
  ##            : Account ID to delete the unsampled report for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580281 = path.getOrDefault("webPropertyId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "webPropertyId", valid_580281
  var valid_580282 = path.getOrDefault("profileId")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "profileId", valid_580282
  var valid_580283 = path.getOrDefault("unsampledReportId")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "unsampledReportId", valid_580283
  var valid_580284 = path.getOrDefault("accountId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "accountId", valid_580284
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580285 = query.getOrDefault("key")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "key", valid_580285
  var valid_580286 = query.getOrDefault("prettyPrint")
  valid_580286 = validateParameter(valid_580286, JBool, required = false,
                                 default = newJBool(false))
  if valid_580286 != nil:
    section.add "prettyPrint", valid_580286
  var valid_580287 = query.getOrDefault("oauth_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "oauth_token", valid_580287
  var valid_580288 = query.getOrDefault("alt")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("json"))
  if valid_580288 != nil:
    section.add "alt", valid_580288
  var valid_580289 = query.getOrDefault("userIp")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "userIp", valid_580289
  var valid_580290 = query.getOrDefault("quotaUser")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "quotaUser", valid_580290
  var valid_580291 = query.getOrDefault("fields")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "fields", valid_580291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580292: Call_AnalyticsManagementUnsampledReportsDelete_580278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unsampled report.
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_AnalyticsManagementUnsampledReportsDelete_580278;
          webPropertyId: string; profileId: string; unsampledReportId: string;
          accountId: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsManagementUnsampledReportsDelete
  ## Deletes an unsampled report.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the unsampled reports for.
  ##   profileId: string (required)
  ##            : View (Profile) ID to delete the unsampled report for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   unsampledReportId: string (required)
  ##                    : ID of the unsampled report to be deleted.
  ##   accountId: string (required)
  ##            : Account ID to delete the unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  add(query_580295, "key", newJString(key))
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(path_580294, "webPropertyId", newJString(webPropertyId))
  add(path_580294, "profileId", newJString(profileId))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "userIp", newJString(userIp))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(path_580294, "unsampledReportId", newJString(unsampledReportId))
  add(path_580294, "accountId", newJString(accountId))
  add(query_580295, "fields", newJString(fields))
  result = call_580293.call(path_580294, query_580295, nil, nil, nil)

var analyticsManagementUnsampledReportsDelete* = Call_AnalyticsManagementUnsampledReportsDelete_580278(
    name: "analyticsManagementUnsampledReportsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsDelete_580279,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsDelete_580280,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceInsert_580315 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementRemarketingAudienceInsert_580317(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/remarketingAudiences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceInsert_580316(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID for which to create the remarketing audience.
  ##   accountId: JString (required)
  ##            : The account ID for which to create the remarketing audience.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580318 = path.getOrDefault("webPropertyId")
  valid_580318 = validateParameter(valid_580318, JString, required = true,
                                 default = nil)
  if valid_580318 != nil:
    section.add "webPropertyId", valid_580318
  var valid_580319 = path.getOrDefault("accountId")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "accountId", valid_580319
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580320 = query.getOrDefault("key")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "key", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(false))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
  var valid_580322 = query.getOrDefault("oauth_token")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "oauth_token", valid_580322
  var valid_580323 = query.getOrDefault("alt")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("json"))
  if valid_580323 != nil:
    section.add "alt", valid_580323
  var valid_580324 = query.getOrDefault("userIp")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "userIp", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("fields")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "fields", valid_580326
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

proc call*(call_580328: Call_AnalyticsManagementRemarketingAudienceInsert_580315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new remarketing audience.
  ## 
  let valid = call_580328.validator(path, query, header, formData, body)
  let scheme = call_580328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580328.url(scheme.get, call_580328.host, call_580328.base,
                         call_580328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580328, url, valid)

proc call*(call_580329: Call_AnalyticsManagementRemarketingAudienceInsert_580315;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## analyticsManagementRemarketingAudienceInsert
  ## Creates a new remarketing audience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID for which to create the remarketing audience.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The account ID for which to create the remarketing audience.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580330 = newJObject()
  var query_580331 = newJObject()
  var body_580332 = newJObject()
  add(query_580331, "key", newJString(key))
  add(query_580331, "prettyPrint", newJBool(prettyPrint))
  add(query_580331, "oauth_token", newJString(oauthToken))
  add(path_580330, "webPropertyId", newJString(webPropertyId))
  add(query_580331, "alt", newJString(alt))
  add(query_580331, "userIp", newJString(userIp))
  add(query_580331, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580332 = body
  add(path_580330, "accountId", newJString(accountId))
  add(query_580331, "fields", newJString(fields))
  result = call_580329.call(path_580330, query_580331, nil, nil, body_580332)

var analyticsManagementRemarketingAudienceInsert* = Call_AnalyticsManagementRemarketingAudienceInsert_580315(
    name: "analyticsManagementRemarketingAudienceInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceInsert_580316,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceInsert_580317,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceList_580296 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementRemarketingAudienceList_580298(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/remarketingAudiences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceList_580297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists remarketing audiences to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audiences to retrieve.
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audiences to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580299 = path.getOrDefault("webPropertyId")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "webPropertyId", valid_580299
  var valid_580300 = path.getOrDefault("accountId")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "accountId", valid_580300
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
  ##   type: JString
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of remarketing audiences to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(false))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
  var valid_580303 = query.getOrDefault("oauth_token")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "oauth_token", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("userIp")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "userIp", valid_580305
  var valid_580306 = query.getOrDefault("quotaUser")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "quotaUser", valid_580306
  var valid_580307 = query.getOrDefault("type")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = newJString("all"))
  if valid_580307 != nil:
    section.add "type", valid_580307
  var valid_580308 = query.getOrDefault("start-index")
  valid_580308 = validateParameter(valid_580308, JInt, required = false, default = nil)
  if valid_580308 != nil:
    section.add "start-index", valid_580308
  var valid_580309 = query.getOrDefault("max-results")
  valid_580309 = validateParameter(valid_580309, JInt, required = false, default = nil)
  if valid_580309 != nil:
    section.add "max-results", valid_580309
  var valid_580310 = query.getOrDefault("fields")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "fields", valid_580310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580311: Call_AnalyticsManagementRemarketingAudienceList_580296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists remarketing audiences to which the user has access.
  ## 
  let valid = call_580311.validator(path, query, header, formData, body)
  let scheme = call_580311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580311.url(scheme.get, call_580311.host, call_580311.base,
                         call_580311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580311, url, valid)

proc call*(call_580312: Call_AnalyticsManagementRemarketingAudienceList_580296;
          webPropertyId: string; accountId: string; key: string = "";
          prettyPrint: bool = false; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; `type`: string = "all";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementRemarketingAudienceList
  ## Lists remarketing audiences to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audiences to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   type: string
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of remarketing audiences to include in this response.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audiences to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580313 = newJObject()
  var query_580314 = newJObject()
  add(query_580314, "key", newJString(key))
  add(query_580314, "prettyPrint", newJBool(prettyPrint))
  add(query_580314, "oauth_token", newJString(oauthToken))
  add(path_580313, "webPropertyId", newJString(webPropertyId))
  add(query_580314, "alt", newJString(alt))
  add(query_580314, "userIp", newJString(userIp))
  add(query_580314, "quotaUser", newJString(quotaUser))
  add(query_580314, "type", newJString(`type`))
  add(query_580314, "start-index", newJInt(startIndex))
  add(query_580314, "max-results", newJInt(maxResults))
  add(path_580313, "accountId", newJString(accountId))
  add(query_580314, "fields", newJString(fields))
  result = call_580312.call(path_580313, query_580314, nil, nil, nil)

var analyticsManagementRemarketingAudienceList* = Call_AnalyticsManagementRemarketingAudienceList_580296(
    name: "analyticsManagementRemarketingAudienceList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceList_580297,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceList_580298,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceUpdate_580350 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementRemarketingAudienceUpdate_580352(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementRemarketingAudienceUpdate_580351(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to update.
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580353 = path.getOrDefault("webPropertyId")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "webPropertyId", valid_580353
  var valid_580354 = path.getOrDefault("remarketingAudienceId")
  valid_580354 = validateParameter(valid_580354, JString, required = true,
                                 default = nil)
  if valid_580354 != nil:
    section.add "remarketingAudienceId", valid_580354
  var valid_580355 = path.getOrDefault("accountId")
  valid_580355 = validateParameter(valid_580355, JString, required = true,
                                 default = nil)
  if valid_580355 != nil:
    section.add "accountId", valid_580355
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  var valid_580357 = query.getOrDefault("prettyPrint")
  valid_580357 = validateParameter(valid_580357, JBool, required = false,
                                 default = newJBool(false))
  if valid_580357 != nil:
    section.add "prettyPrint", valid_580357
  var valid_580358 = query.getOrDefault("oauth_token")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "oauth_token", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("userIp")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "userIp", valid_580360
  var valid_580361 = query.getOrDefault("quotaUser")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "quotaUser", valid_580361
  var valid_580362 = query.getOrDefault("fields")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "fields", valid_580362
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

proc call*(call_580364: Call_AnalyticsManagementRemarketingAudienceUpdate_580350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience.
  ## 
  let valid = call_580364.validator(path, query, header, formData, body)
  let scheme = call_580364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580364.url(scheme.get, call_580364.host, call_580364.base,
                         call_580364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580364, url, valid)

proc call*(call_580365: Call_AnalyticsManagementRemarketingAudienceUpdate_580350;
          webPropertyId: string; remarketingAudienceId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementRemarketingAudienceUpdate
  ## Updates an existing remarketing audience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580366 = newJObject()
  var query_580367 = newJObject()
  var body_580368 = newJObject()
  add(query_580367, "key", newJString(key))
  add(query_580367, "prettyPrint", newJBool(prettyPrint))
  add(query_580367, "oauth_token", newJString(oauthToken))
  add(path_580366, "webPropertyId", newJString(webPropertyId))
  add(path_580366, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_580367, "alt", newJString(alt))
  add(query_580367, "userIp", newJString(userIp))
  add(query_580367, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580368 = body
  add(path_580366, "accountId", newJString(accountId))
  add(query_580367, "fields", newJString(fields))
  result = call_580365.call(path_580366, query_580367, nil, nil, body_580368)

var analyticsManagementRemarketingAudienceUpdate* = Call_AnalyticsManagementRemarketingAudienceUpdate_580350(
    name: "analyticsManagementRemarketingAudienceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceUpdate_580351,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceUpdate_580352,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceGet_580333 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementRemarketingAudienceGet_580335(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementRemarketingAudienceGet_580334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a remarketing audience to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to retrieve.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to retrieve.
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580336 = path.getOrDefault("webPropertyId")
  valid_580336 = validateParameter(valid_580336, JString, required = true,
                                 default = nil)
  if valid_580336 != nil:
    section.add "webPropertyId", valid_580336
  var valid_580337 = path.getOrDefault("remarketingAudienceId")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "remarketingAudienceId", valid_580337
  var valid_580338 = path.getOrDefault("accountId")
  valid_580338 = validateParameter(valid_580338, JString, required = true,
                                 default = nil)
  if valid_580338 != nil:
    section.add "accountId", valid_580338
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580339 = query.getOrDefault("key")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "key", valid_580339
  var valid_580340 = query.getOrDefault("prettyPrint")
  valid_580340 = validateParameter(valid_580340, JBool, required = false,
                                 default = newJBool(false))
  if valid_580340 != nil:
    section.add "prettyPrint", valid_580340
  var valid_580341 = query.getOrDefault("oauth_token")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "oauth_token", valid_580341
  var valid_580342 = query.getOrDefault("alt")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("json"))
  if valid_580342 != nil:
    section.add "alt", valid_580342
  var valid_580343 = query.getOrDefault("userIp")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "userIp", valid_580343
  var valid_580344 = query.getOrDefault("quotaUser")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "quotaUser", valid_580344
  var valid_580345 = query.getOrDefault("fields")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "fields", valid_580345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580346: Call_AnalyticsManagementRemarketingAudienceGet_580333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a remarketing audience to which the user has access.
  ## 
  let valid = call_580346.validator(path, query, header, formData, body)
  let scheme = call_580346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580346.url(scheme.get, call_580346.host, call_580346.base,
                         call_580346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580346, url, valid)

proc call*(call_580347: Call_AnalyticsManagementRemarketingAudienceGet_580333;
          webPropertyId: string; remarketingAudienceId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementRemarketingAudienceGet
  ## Gets a remarketing audience to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to retrieve.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580348 = newJObject()
  var query_580349 = newJObject()
  add(query_580349, "key", newJString(key))
  add(query_580349, "prettyPrint", newJBool(prettyPrint))
  add(query_580349, "oauth_token", newJString(oauthToken))
  add(path_580348, "webPropertyId", newJString(webPropertyId))
  add(path_580348, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_580349, "alt", newJString(alt))
  add(query_580349, "userIp", newJString(userIp))
  add(query_580349, "quotaUser", newJString(quotaUser))
  add(path_580348, "accountId", newJString(accountId))
  add(query_580349, "fields", newJString(fields))
  result = call_580347.call(path_580348, query_580349, nil, nil, nil)

var analyticsManagementRemarketingAudienceGet* = Call_AnalyticsManagementRemarketingAudienceGet_580333(
    name: "analyticsManagementRemarketingAudienceGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceGet_580334,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceGet_580335,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudiencePatch_580386 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementRemarketingAudiencePatch_580388(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementRemarketingAudiencePatch_580387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to update.
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580389 = path.getOrDefault("webPropertyId")
  valid_580389 = validateParameter(valid_580389, JString, required = true,
                                 default = nil)
  if valid_580389 != nil:
    section.add "webPropertyId", valid_580389
  var valid_580390 = path.getOrDefault("remarketingAudienceId")
  valid_580390 = validateParameter(valid_580390, JString, required = true,
                                 default = nil)
  if valid_580390 != nil:
    section.add "remarketingAudienceId", valid_580390
  var valid_580391 = path.getOrDefault("accountId")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "accountId", valid_580391
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580392 = query.getOrDefault("key")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "key", valid_580392
  var valid_580393 = query.getOrDefault("prettyPrint")
  valid_580393 = validateParameter(valid_580393, JBool, required = false,
                                 default = newJBool(false))
  if valid_580393 != nil:
    section.add "prettyPrint", valid_580393
  var valid_580394 = query.getOrDefault("oauth_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "oauth_token", valid_580394
  var valid_580395 = query.getOrDefault("alt")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = newJString("json"))
  if valid_580395 != nil:
    section.add "alt", valid_580395
  var valid_580396 = query.getOrDefault("userIp")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "userIp", valid_580396
  var valid_580397 = query.getOrDefault("quotaUser")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "quotaUser", valid_580397
  var valid_580398 = query.getOrDefault("fields")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "fields", valid_580398
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

proc call*(call_580400: Call_AnalyticsManagementRemarketingAudiencePatch_580386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ## 
  let valid = call_580400.validator(path, query, header, formData, body)
  let scheme = call_580400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580400.url(scheme.get, call_580400.host, call_580400.base,
                         call_580400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580400, url, valid)

proc call*(call_580401: Call_AnalyticsManagementRemarketingAudiencePatch_580386;
          webPropertyId: string; remarketingAudienceId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementRemarketingAudiencePatch
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580402 = newJObject()
  var query_580403 = newJObject()
  var body_580404 = newJObject()
  add(query_580403, "key", newJString(key))
  add(query_580403, "prettyPrint", newJBool(prettyPrint))
  add(query_580403, "oauth_token", newJString(oauthToken))
  add(path_580402, "webPropertyId", newJString(webPropertyId))
  add(path_580402, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_580403, "alt", newJString(alt))
  add(query_580403, "userIp", newJString(userIp))
  add(query_580403, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580404 = body
  add(path_580402, "accountId", newJString(accountId))
  add(query_580403, "fields", newJString(fields))
  result = call_580401.call(path_580402, query_580403, nil, nil, body_580404)

var analyticsManagementRemarketingAudiencePatch* = Call_AnalyticsManagementRemarketingAudiencePatch_580386(
    name: "analyticsManagementRemarketingAudiencePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudiencePatch_580387,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudiencePatch_580388,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceDelete_580369 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementRemarketingAudienceDelete_580371(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsManagementRemarketingAudienceDelete_580370(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the remarketing audience belongs.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to delete.
  ##   accountId: JString (required)
  ##            : Account ID to which the remarketing audience belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `webPropertyId` field"
  var valid_580372 = path.getOrDefault("webPropertyId")
  valid_580372 = validateParameter(valid_580372, JString, required = true,
                                 default = nil)
  if valid_580372 != nil:
    section.add "webPropertyId", valid_580372
  var valid_580373 = path.getOrDefault("remarketingAudienceId")
  valid_580373 = validateParameter(valid_580373, JString, required = true,
                                 default = nil)
  if valid_580373 != nil:
    section.add "remarketingAudienceId", valid_580373
  var valid_580374 = path.getOrDefault("accountId")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "accountId", valid_580374
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580375 = query.getOrDefault("key")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "key", valid_580375
  var valid_580376 = query.getOrDefault("prettyPrint")
  valid_580376 = validateParameter(valid_580376, JBool, required = false,
                                 default = newJBool(false))
  if valid_580376 != nil:
    section.add "prettyPrint", valid_580376
  var valid_580377 = query.getOrDefault("oauth_token")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "oauth_token", valid_580377
  var valid_580378 = query.getOrDefault("alt")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("json"))
  if valid_580378 != nil:
    section.add "alt", valid_580378
  var valid_580379 = query.getOrDefault("userIp")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "userIp", valid_580379
  var valid_580380 = query.getOrDefault("quotaUser")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "quotaUser", valid_580380
  var valid_580381 = query.getOrDefault("fields")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "fields", valid_580381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580382: Call_AnalyticsManagementRemarketingAudienceDelete_580369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a remarketing audience.
  ## 
  let valid = call_580382.validator(path, query, header, formData, body)
  let scheme = call_580382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580382.url(scheme.get, call_580382.host, call_580382.base,
                         call_580382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580382, url, valid)

proc call*(call_580383: Call_AnalyticsManagementRemarketingAudienceDelete_580369;
          webPropertyId: string; remarketingAudienceId: string; accountId: string;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## analyticsManagementRemarketingAudienceDelete
  ## Delete a remarketing audience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the remarketing audience belongs.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account ID to which the remarketing audience belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580384 = newJObject()
  var query_580385 = newJObject()
  add(query_580385, "key", newJString(key))
  add(query_580385, "prettyPrint", newJBool(prettyPrint))
  add(query_580385, "oauth_token", newJString(oauthToken))
  add(path_580384, "webPropertyId", newJString(webPropertyId))
  add(path_580384, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_580385, "alt", newJString(alt))
  add(query_580385, "userIp", newJString(userIp))
  add(query_580385, "quotaUser", newJString(quotaUser))
  add(path_580384, "accountId", newJString(accountId))
  add(query_580385, "fields", newJString(fields))
  result = call_580383.call(path_580384, query_580385, nil, nil, nil)

var analyticsManagementRemarketingAudienceDelete* = Call_AnalyticsManagementRemarketingAudienceDelete_580369(
    name: "analyticsManagementRemarketingAudienceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceDelete_580370,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceDelete_580371,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementClientIdHashClientId_580405 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementClientIdHashClientId_580407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementClientIdHashClientId_580406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Hashes the given Client ID.
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580408 = query.getOrDefault("key")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "key", valid_580408
  var valid_580409 = query.getOrDefault("prettyPrint")
  valid_580409 = validateParameter(valid_580409, JBool, required = false,
                                 default = newJBool(false))
  if valid_580409 != nil:
    section.add "prettyPrint", valid_580409
  var valid_580410 = query.getOrDefault("oauth_token")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "oauth_token", valid_580410
  var valid_580411 = query.getOrDefault("alt")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("json"))
  if valid_580411 != nil:
    section.add "alt", valid_580411
  var valid_580412 = query.getOrDefault("userIp")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "userIp", valid_580412
  var valid_580413 = query.getOrDefault("quotaUser")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "quotaUser", valid_580413
  var valid_580414 = query.getOrDefault("fields")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "fields", valid_580414
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

proc call*(call_580416: Call_AnalyticsManagementClientIdHashClientId_580405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hashes the given Client ID.
  ## 
  let valid = call_580416.validator(path, query, header, formData, body)
  let scheme = call_580416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580416.url(scheme.get, call_580416.host, call_580416.base,
                         call_580416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580416, url, valid)

proc call*(call_580417: Call_AnalyticsManagementClientIdHashClientId_580405;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsManagementClientIdHashClientId
  ## Hashes the given Client ID.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580418 = newJObject()
  var body_580419 = newJObject()
  add(query_580418, "key", newJString(key))
  add(query_580418, "prettyPrint", newJBool(prettyPrint))
  add(query_580418, "oauth_token", newJString(oauthToken))
  add(query_580418, "alt", newJString(alt))
  add(query_580418, "userIp", newJString(userIp))
  add(query_580418, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580419 = body
  add(query_580418, "fields", newJString(fields))
  result = call_580417.call(nil, query_580418, nil, nil, body_580419)

var analyticsManagementClientIdHashClientId* = Call_AnalyticsManagementClientIdHashClientId_580405(
    name: "analyticsManagementClientIdHashClientId", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/clientId:hashClientId",
    validator: validate_AnalyticsManagementClientIdHashClientId_580406,
    base: "/analytics/v3", url: url_AnalyticsManagementClientIdHashClientId_580407,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementSegmentsList_580420 = ref object of OpenApiRestCall_578364
proc url_AnalyticsManagementSegmentsList_580422(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementSegmentsList_580421(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists segments to which the user has access.
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
  ##              : An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   max-results: JInt
  ##              : The maximum number of segments to include in this response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580423 = query.getOrDefault("key")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "key", valid_580423
  var valid_580424 = query.getOrDefault("prettyPrint")
  valid_580424 = validateParameter(valid_580424, JBool, required = false,
                                 default = newJBool(false))
  if valid_580424 != nil:
    section.add "prettyPrint", valid_580424
  var valid_580425 = query.getOrDefault("oauth_token")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "oauth_token", valid_580425
  var valid_580426 = query.getOrDefault("alt")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("json"))
  if valid_580426 != nil:
    section.add "alt", valid_580426
  var valid_580427 = query.getOrDefault("userIp")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "userIp", valid_580427
  var valid_580428 = query.getOrDefault("quotaUser")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "quotaUser", valid_580428
  var valid_580429 = query.getOrDefault("start-index")
  valid_580429 = validateParameter(valid_580429, JInt, required = false, default = nil)
  if valid_580429 != nil:
    section.add "start-index", valid_580429
  var valid_580430 = query.getOrDefault("max-results")
  valid_580430 = validateParameter(valid_580430, JInt, required = false, default = nil)
  if valid_580430 != nil:
    section.add "max-results", valid_580430
  var valid_580431 = query.getOrDefault("fields")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "fields", valid_580431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580432: Call_AnalyticsManagementSegmentsList_580420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists segments to which the user has access.
  ## 
  let valid = call_580432.validator(path, query, header, formData, body)
  let scheme = call_580432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580432.url(scheme.get, call_580432.host, call_580432.base,
                         call_580432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580432, url, valid)

proc call*(call_580433: Call_AnalyticsManagementSegmentsList_580420;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; maxResults: int = 0; fields: string = ""): Recallable =
  ## analyticsManagementSegmentsList
  ## Lists segments to which the user has access.
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
  ##             : An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   maxResults: int
  ##             : The maximum number of segments to include in this response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580434 = newJObject()
  add(query_580434, "key", newJString(key))
  add(query_580434, "prettyPrint", newJBool(prettyPrint))
  add(query_580434, "oauth_token", newJString(oauthToken))
  add(query_580434, "alt", newJString(alt))
  add(query_580434, "userIp", newJString(userIp))
  add(query_580434, "quotaUser", newJString(quotaUser))
  add(query_580434, "start-index", newJInt(startIndex))
  add(query_580434, "max-results", newJInt(maxResults))
  add(query_580434, "fields", newJString(fields))
  result = call_580433.call(nil, query_580434, nil, nil, nil)

var analyticsManagementSegmentsList* = Call_AnalyticsManagementSegmentsList_580420(
    name: "analyticsManagementSegmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/segments",
    validator: validate_AnalyticsManagementSegmentsList_580421,
    base: "/analytics/v3", url: url_AnalyticsManagementSegmentsList_580422,
    schemes: {Scheme.Https})
type
  Call_AnalyticsMetadataColumnsList_580435 = ref object of OpenApiRestCall_578364
proc url_AnalyticsMetadataColumnsList_580437(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AnalyticsMetadataColumnsList_580436(path: JsonNode; query: JsonNode;
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
  var valid_580438 = path.getOrDefault("reportType")
  valid_580438 = validateParameter(valid_580438, JString, required = true,
                                 default = nil)
  if valid_580438 != nil:
    section.add "reportType", valid_580438
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580439 = query.getOrDefault("key")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "key", valid_580439
  var valid_580440 = query.getOrDefault("prettyPrint")
  valid_580440 = validateParameter(valid_580440, JBool, required = false,
                                 default = newJBool(false))
  if valid_580440 != nil:
    section.add "prettyPrint", valid_580440
  var valid_580441 = query.getOrDefault("oauth_token")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "oauth_token", valid_580441
  var valid_580442 = query.getOrDefault("alt")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = newJString("json"))
  if valid_580442 != nil:
    section.add "alt", valid_580442
  var valid_580443 = query.getOrDefault("userIp")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "userIp", valid_580443
  var valid_580444 = query.getOrDefault("quotaUser")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "quotaUser", valid_580444
  var valid_580445 = query.getOrDefault("fields")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "fields", valid_580445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580446: Call_AnalyticsMetadataColumnsList_580435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all columns for a report type
  ## 
  let valid = call_580446.validator(path, query, header, formData, body)
  let scheme = call_580446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580446.url(scheme.get, call_580446.host, call_580446.base,
                         call_580446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580446, url, valid)

proc call*(call_580447: Call_AnalyticsMetadataColumnsList_580435;
          reportType: string; key: string = ""; prettyPrint: bool = false;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## analyticsMetadataColumnsList
  ## Lists all columns for a report type
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   reportType: string (required)
  ##             : Report type. Allowed Values: 'ga'. Where 'ga' corresponds to the Core Reporting API
  var path_580448 = newJObject()
  var query_580449 = newJObject()
  add(query_580449, "key", newJString(key))
  add(query_580449, "prettyPrint", newJBool(prettyPrint))
  add(query_580449, "oauth_token", newJString(oauthToken))
  add(query_580449, "alt", newJString(alt))
  add(query_580449, "userIp", newJString(userIp))
  add(query_580449, "quotaUser", newJString(quotaUser))
  add(query_580449, "fields", newJString(fields))
  add(path_580448, "reportType", newJString(reportType))
  result = call_580447.call(path_580448, query_580449, nil, nil, nil)

var analyticsMetadataColumnsList* = Call_AnalyticsMetadataColumnsList_580435(
    name: "analyticsMetadataColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/{reportType}/columns",
    validator: validate_AnalyticsMetadataColumnsList_580436,
    base: "/analytics/v3", url: url_AnalyticsMetadataColumnsList_580437,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTicket_580450 = ref object of OpenApiRestCall_578364
proc url_AnalyticsProvisioningCreateAccountTicket_580452(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTicket_580451(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an account ticket.
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580453 = query.getOrDefault("key")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "key", valid_580453
  var valid_580454 = query.getOrDefault("prettyPrint")
  valid_580454 = validateParameter(valid_580454, JBool, required = false,
                                 default = newJBool(false))
  if valid_580454 != nil:
    section.add "prettyPrint", valid_580454
  var valid_580455 = query.getOrDefault("oauth_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "oauth_token", valid_580455
  var valid_580456 = query.getOrDefault("alt")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = newJString("json"))
  if valid_580456 != nil:
    section.add "alt", valid_580456
  var valid_580457 = query.getOrDefault("userIp")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "userIp", valid_580457
  var valid_580458 = query.getOrDefault("quotaUser")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "quotaUser", valid_580458
  var valid_580459 = query.getOrDefault("fields")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "fields", valid_580459
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

proc call*(call_580461: Call_AnalyticsProvisioningCreateAccountTicket_580450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an account ticket.
  ## 
  let valid = call_580461.validator(path, query, header, formData, body)
  let scheme = call_580461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580461.url(scheme.get, call_580461.host, call_580461.base,
                         call_580461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580461, url, valid)

proc call*(call_580462: Call_AnalyticsProvisioningCreateAccountTicket_580450;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsProvisioningCreateAccountTicket
  ## Creates an account ticket.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580463 = newJObject()
  var body_580464 = newJObject()
  add(query_580463, "key", newJString(key))
  add(query_580463, "prettyPrint", newJBool(prettyPrint))
  add(query_580463, "oauth_token", newJString(oauthToken))
  add(query_580463, "alt", newJString(alt))
  add(query_580463, "userIp", newJString(userIp))
  add(query_580463, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580464 = body
  add(query_580463, "fields", newJString(fields))
  result = call_580462.call(nil, query_580463, nil, nil, body_580464)

var analyticsProvisioningCreateAccountTicket* = Call_AnalyticsProvisioningCreateAccountTicket_580450(
    name: "analyticsProvisioningCreateAccountTicket", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTicket",
    validator: validate_AnalyticsProvisioningCreateAccountTicket_580451,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTicket_580452,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTree_580465 = ref object of OpenApiRestCall_578364
proc url_AnalyticsProvisioningCreateAccountTree_580467(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTree_580466(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provision account.
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580468 = query.getOrDefault("key")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "key", valid_580468
  var valid_580469 = query.getOrDefault("prettyPrint")
  valid_580469 = validateParameter(valid_580469, JBool, required = false,
                                 default = newJBool(false))
  if valid_580469 != nil:
    section.add "prettyPrint", valid_580469
  var valid_580470 = query.getOrDefault("oauth_token")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "oauth_token", valid_580470
  var valid_580471 = query.getOrDefault("alt")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = newJString("json"))
  if valid_580471 != nil:
    section.add "alt", valid_580471
  var valid_580472 = query.getOrDefault("userIp")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "userIp", valid_580472
  var valid_580473 = query.getOrDefault("quotaUser")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "quotaUser", valid_580473
  var valid_580474 = query.getOrDefault("fields")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "fields", valid_580474
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

proc call*(call_580476: Call_AnalyticsProvisioningCreateAccountTree_580465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provision account.
  ## 
  let valid = call_580476.validator(path, query, header, formData, body)
  let scheme = call_580476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580476.url(scheme.get, call_580476.host, call_580476.base,
                         call_580476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580476, url, valid)

proc call*(call_580477: Call_AnalyticsProvisioningCreateAccountTree_580465;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsProvisioningCreateAccountTree
  ## Provision account.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580478 = newJObject()
  var body_580479 = newJObject()
  add(query_580478, "key", newJString(key))
  add(query_580478, "prettyPrint", newJBool(prettyPrint))
  add(query_580478, "oauth_token", newJString(oauthToken))
  add(query_580478, "alt", newJString(alt))
  add(query_580478, "userIp", newJString(userIp))
  add(query_580478, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580479 = body
  add(query_580478, "fields", newJString(fields))
  result = call_580477.call(nil, query_580478, nil, nil, body_580479)

var analyticsProvisioningCreateAccountTree* = Call_AnalyticsProvisioningCreateAccountTree_580465(
    name: "analyticsProvisioningCreateAccountTree", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTree",
    validator: validate_AnalyticsProvisioningCreateAccountTree_580466,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTree_580467,
    schemes: {Scheme.Https})
type
  Call_AnalyticsUserDeletionUserDeletionRequestUpsert_580480 = ref object of OpenApiRestCall_578364
proc url_AnalyticsUserDeletionUserDeletionRequestUpsert_580482(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsUserDeletionUserDeletionRequestUpsert_580481(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Insert or update a user deletion requests.
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580483 = query.getOrDefault("key")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "key", valid_580483
  var valid_580484 = query.getOrDefault("prettyPrint")
  valid_580484 = validateParameter(valid_580484, JBool, required = false,
                                 default = newJBool(false))
  if valid_580484 != nil:
    section.add "prettyPrint", valid_580484
  var valid_580485 = query.getOrDefault("oauth_token")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "oauth_token", valid_580485
  var valid_580486 = query.getOrDefault("alt")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = newJString("json"))
  if valid_580486 != nil:
    section.add "alt", valid_580486
  var valid_580487 = query.getOrDefault("userIp")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "userIp", valid_580487
  var valid_580488 = query.getOrDefault("quotaUser")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "quotaUser", valid_580488
  var valid_580489 = query.getOrDefault("fields")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "fields", valid_580489
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

proc call*(call_580491: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_580480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert or update a user deletion requests.
  ## 
  let valid = call_580491.validator(path, query, header, formData, body)
  let scheme = call_580491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580491.url(scheme.get, call_580491.host, call_580491.base,
                         call_580491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580491, url, valid)

proc call*(call_580492: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_580480;
          key: string = ""; prettyPrint: bool = false; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## analyticsUserDeletionUserDeletionRequestUpsert
  ## Insert or update a user deletion requests.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580493 = newJObject()
  var body_580494 = newJObject()
  add(query_580493, "key", newJString(key))
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "userIp", newJString(userIp))
  add(query_580493, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580494 = body
  add(query_580493, "fields", newJString(fields))
  result = call_580492.call(nil, query_580493, nil, nil, body_580494)

var analyticsUserDeletionUserDeletionRequestUpsert* = Call_AnalyticsUserDeletionUserDeletionRequestUpsert_580480(
    name: "analyticsUserDeletionUserDeletionRequestUpsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/userDeletion/userDeletionRequests:upsert",
    validator: validate_AnalyticsUserDeletionUserDeletionRequestUpsert_580481,
    base: "/analytics/v3",
    url: url_AnalyticsUserDeletionUserDeletionRequestUpsert_580482,
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
