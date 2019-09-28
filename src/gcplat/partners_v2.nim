
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Partners
## version: v2
## termsOfService: (not provided)
## license: (not provided)
## 
## Searches certified companies and creates contact leads with them, and also audits the usage of clients.
## 
## https://developers.google.com/partners/
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "partners"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PartnersAnalyticsList_579690 = ref object of OpenApiRestCall_579421
proc url_PartnersAnalyticsList_579692(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersAnalyticsList_579691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListAnalyticsResponse.next_page_token`
  ## returned from the previous call to
  ## ListAnalytics.
  ## Will be a date string in `YYYY-MM-DD` format representing the end date
  ## of the date range of results to return.
  ## If unspecified or set to "", default value is the current date.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer analytics than requested.
  ## If unspecified or set to 0, default value is 30.
  ## Specifies the number of days in the date range when querying analytics.
  ## The `page_token` represents the end date of the date range
  ## and the start date is calculated using the `page_size` as the number
  ## of days BEFORE the end date.
  ## Must be a non-negative integer.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579808 = query.getOrDefault("requestMetadata.locale")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "requestMetadata.locale", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("pp")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "pp", valid_579823
  var valid_579824 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579824
  var valid_579825 = query.getOrDefault("oauth_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "oauth_token", valid_579825
  var valid_579826 = query.getOrDefault("callback")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "callback", valid_579826
  var valid_579827 = query.getOrDefault("access_token")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "access_token", valid_579827
  var valid_579828 = query.getOrDefault("uploadType")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "uploadType", valid_579828
  var valid_579829 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579829
  var valid_579830 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579830
  var valid_579831 = query.getOrDefault("key")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "key", valid_579831
  var valid_579832 = query.getOrDefault("$.xgafv")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = newJString("1"))
  if valid_579832 != nil:
    section.add "$.xgafv", valid_579832
  var valid_579833 = query.getOrDefault("pageSize")
  valid_579833 = validateParameter(valid_579833, JInt, required = false, default = nil)
  if valid_579833 != nil:
    section.add "pageSize", valid_579833
  var valid_579834 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579834
  var valid_579835 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579835 = validateParameter(valid_579835, JArray, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "requestMetadata.experimentIds", valid_579835
  var valid_579836 = query.getOrDefault("prettyPrint")
  valid_579836 = validateParameter(valid_579836, JBool, required = false,
                                 default = newJBool(true))
  if valid_579836 != nil:
    section.add "prettyPrint", valid_579836
  var valid_579837 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579837
  var valid_579838 = query.getOrDefault("bearer_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "bearer_token", valid_579838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579861: Call_PartnersAnalyticsList_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_579861.validator(path, query, header, formData, body)
  let scheme = call_579861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579861.url(scheme.get, call_579861.host, call_579861.base,
                         call_579861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579861, url, valid)

proc call*(call_579932: Call_PartnersAnalyticsList_579690;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; requestMetadataLocale: string = "";
          alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0;
          requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersAnalyticsList
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListAnalyticsResponse.next_page_token`
  ## returned from the previous call to
  ## ListAnalytics.
  ## Will be a date string in `YYYY-MM-DD` format representing the end date
  ## of the date range of results to return.
  ## If unspecified or set to "", default value is the current date.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer analytics than requested.
  ## If unspecified or set to 0, default value is 30.
  ## Specifies the number of days in the date range when querying analytics.
  ## The `page_token` represents the end date of the date range
  ## and the start date is calculated using the `page_size` as the number
  ## of days BEFORE the end date.
  ## Must be a non-negative integer.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_579933 = newJObject()
  add(query_579933, "upload_protocol", newJString(uploadProtocol))
  add(query_579933, "fields", newJString(fields))
  add(query_579933, "pageToken", newJString(pageToken))
  add(query_579933, "quotaUser", newJString(quotaUser))
  add(query_579933, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579933, "alt", newJString(alt))
  add(query_579933, "pp", newJBool(pp))
  add(query_579933, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579933, "oauth_token", newJString(oauthToken))
  add(query_579933, "callback", newJString(callback))
  add(query_579933, "access_token", newJString(accessToken))
  add(query_579933, "uploadType", newJString(uploadType))
  add(query_579933, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579933, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579933, "key", newJString(key))
  add(query_579933, "$.xgafv", newJString(Xgafv))
  add(query_579933, "pageSize", newJInt(pageSize))
  add(query_579933, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_579933.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_579933, "prettyPrint", newJBool(prettyPrint))
  add(query_579933, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579933, "bearer_token", newJString(bearerToken))
  result = call_579932.call(nil, query_579933, nil, nil, nil)

var partnersAnalyticsList* = Call_PartnersAnalyticsList_579690(
    name: "partnersAnalyticsList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/analytics",
    validator: validate_PartnersAnalyticsList_579691, base: "/",
    url: url_PartnersAnalyticsList_579692, schemes: {Scheme.Https})
type
  Call_PartnersClientMessagesLog_579973 = ref object of OpenApiRestCall_579421
proc url_PartnersClientMessagesLog_579975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersClientMessagesLog_579974(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  var valid_579982 = query.getOrDefault("callback")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "callback", valid_579982
  var valid_579983 = query.getOrDefault("access_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "access_token", valid_579983
  var valid_579984 = query.getOrDefault("uploadType")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "uploadType", valid_579984
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

proc call*(call_579990: Call_PartnersClientMessagesLog_579973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ## 
  let valid = call_579990.validator(path, query, header, formData, body)
  let scheme = call_579990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579990.url(scheme.get, call_579990.host, call_579990.base,
                         call_579990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579990, url, valid)

proc call*(call_579991: Call_PartnersClientMessagesLog_579973;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## partnersClientMessagesLog
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
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
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_579992 = newJObject()
  var body_579993 = newJObject()
  add(query_579992, "upload_protocol", newJString(uploadProtocol))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "pp", newJBool(pp))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "callback", newJString(callback))
  add(query_579992, "access_token", newJString(accessToken))
  add(query_579992, "uploadType", newJString(uploadType))
  add(query_579992, "key", newJString(key))
  add(query_579992, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579993 = body
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "bearer_token", newJString(bearerToken))
  result = call_579991.call(nil, query_579992, nil, nil, body_579993)

var partnersClientMessagesLog* = Call_PartnersClientMessagesLog_579973(
    name: "partnersClientMessagesLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/clientMessages:log",
    validator: validate_PartnersClientMessagesLog_579974, base: "/",
    url: url_PartnersClientMessagesLog_579975, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesList_579994 = ref object of OpenApiRestCall_579421
proc url_PartnersCompaniesList_579996(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersCompaniesList_579995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists companies.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMonthlyBudget.units: JString
  ##                         : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   industries: JArray
  ##             : List of industries the company can help with.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListCompaniesResponse.next_page_token`
  ## returned from the previous call to
  ## ListCompanies.
  ##   view: JString
  ##       : The view of the `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   alt: JString
  ##      : Data format for response.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   gpsMotivations: JArray
  ##                 : List of reasons for using Google Partner Search to get companies.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   specializations: JArray
  ##                  : List of specializations that the returned agencies should provide. If this
  ## is not empty, any returned agency must have at least one of these
  ## specializations, or one of the services in the "services" field.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   minMonthlyBudget.currencyCode: JString
  ##                                : The 3-letter currency code defined in ISO 4217.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: JString
  ##          : How to order addresses within the returned companies. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   services: JArray
  ##           : List of services that the returned agencies should provide. If this is
  ## not empty, any returned agency must have at least one of these services,
  ## or one of the specializations in the "specializations" field.
  ##   maxMonthlyBudget.nanos: JInt
  ##                         : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: JString
  ##             : Website URL that will help to find a better matched company.
  ## .
  ##   maxMonthlyBudget.currencyCode: JString
  ##                                : The 3-letter currency code defined in ISO 4217.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer companies than requested.
  ## If unspecified, server picks an appropriate default.
  ##   minMonthlyBudget.units: JString
  ##                         : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: JString
  ##          : The address to use when searching for companies.
  ## If not given, the geo-located address of the request is used.
  ##   languageCodes: JArray
  ##                : List of language codes that company can support. Only primary language
  ## subtags are accepted as defined by
  ## <a href="https://tools.ietf.org/html/bcp47">BCP 47</a>
  ## (IETF BCP 47, "Tags for Identifying Languages").
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   companyName: JString
  ##              : Company name to search for.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   minMonthlyBudget.nanos: JInt
  ##                         : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579997 = query.getOrDefault("upload_protocol")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "upload_protocol", valid_579997
  var valid_579998 = query.getOrDefault("maxMonthlyBudget.units")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "maxMonthlyBudget.units", valid_579998
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("industries")
  valid_580000 = validateParameter(valid_580000, JArray, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "industries", valid_580000
  var valid_580001 = query.getOrDefault("quotaUser")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "quotaUser", valid_580001
  var valid_580002 = query.getOrDefault("pageToken")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "pageToken", valid_580002
  var valid_580003 = query.getOrDefault("view")
  valid_580003 = validateParameter(valid_580003, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_580003 != nil:
    section.add "view", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("requestMetadata.locale")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "requestMetadata.locale", valid_580005
  var valid_580006 = query.getOrDefault("gpsMotivations")
  valid_580006 = validateParameter(valid_580006, JArray, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "gpsMotivations", valid_580006
  var valid_580007 = query.getOrDefault("pp")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "pp", valid_580007
  var valid_580008 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580008
  var valid_580009 = query.getOrDefault("specializations")
  valid_580009 = validateParameter(valid_580009, JArray, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "specializations", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("callback")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "callback", valid_580011
  var valid_580012 = query.getOrDefault("access_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "access_token", valid_580012
  var valid_580013 = query.getOrDefault("uploadType")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "uploadType", valid_580013
  var valid_580014 = query.getOrDefault("minMonthlyBudget.currencyCode")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "minMonthlyBudget.currencyCode", valid_580014
  var valid_580015 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580015
  var valid_580016 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580016
  var valid_580017 = query.getOrDefault("orderBy")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "orderBy", valid_580017
  var valid_580018 = query.getOrDefault("services")
  valid_580018 = validateParameter(valid_580018, JArray, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "services", valid_580018
  var valid_580019 = query.getOrDefault("maxMonthlyBudget.nanos")
  valid_580019 = validateParameter(valid_580019, JInt, required = false, default = nil)
  if valid_580019 != nil:
    section.add "maxMonthlyBudget.nanos", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("websiteUrl")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "websiteUrl", valid_580021
  var valid_580022 = query.getOrDefault("maxMonthlyBudget.currencyCode")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "maxMonthlyBudget.currencyCode", valid_580022
  var valid_580023 = query.getOrDefault("$.xgafv")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("1"))
  if valid_580023 != nil:
    section.add "$.xgafv", valid_580023
  var valid_580024 = query.getOrDefault("pageSize")
  valid_580024 = validateParameter(valid_580024, JInt, required = false, default = nil)
  if valid_580024 != nil:
    section.add "pageSize", valid_580024
  var valid_580025 = query.getOrDefault("minMonthlyBudget.units")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "minMonthlyBudget.units", valid_580025
  var valid_580026 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580026
  var valid_580027 = query.getOrDefault("address")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "address", valid_580027
  var valid_580028 = query.getOrDefault("languageCodes")
  valid_580028 = validateParameter(valid_580028, JArray, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "languageCodes", valid_580028
  var valid_580029 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580029 = validateParameter(valid_580029, JArray, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "requestMetadata.experimentIds", valid_580029
  var valid_580030 = query.getOrDefault("companyName")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "companyName", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(true))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  var valid_580032 = query.getOrDefault("minMonthlyBudget.nanos")
  valid_580032 = validateParameter(valid_580032, JInt, required = false, default = nil)
  if valid_580032 != nil:
    section.add "minMonthlyBudget.nanos", valid_580032
  var valid_580033 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580033
  var valid_580034 = query.getOrDefault("bearer_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "bearer_token", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_PartnersCompaniesList_579994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists companies.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_PartnersCompaniesList_579994;
          uploadProtocol: string = ""; maxMonthlyBudgetUnits: string = "";
          fields: string = ""; industries: JsonNode = nil; quotaUser: string = "";
          pageToken: string = ""; view: string = "COMPANY_VIEW_UNSPECIFIED";
          alt: string = "json"; requestMetadataLocale: string = "";
          gpsMotivations: JsonNode = nil; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          specializations: JsonNode = nil; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          minMonthlyBudgetCurrencyCode: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          orderBy: string = ""; services: JsonNode = nil;
          maxMonthlyBudgetNanos: int = 0; key: string = ""; websiteUrl: string = "";
          maxMonthlyBudgetCurrencyCode: string = ""; Xgafv: string = "1";
          pageSize: int = 0; minMonthlyBudgetUnits: string = "";
          requestMetadataUserOverridesUserId: string = ""; address: string = "";
          languageCodes: JsonNode = nil;
          requestMetadataExperimentIds: JsonNode = nil; companyName: string = "";
          prettyPrint: bool = true; minMonthlyBudgetNanos: int = 0;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersCompaniesList
  ## Lists companies.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMonthlyBudgetUnits: string
  ##                        : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   industries: JArray
  ##             : List of industries the company can help with.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListCompaniesResponse.next_page_token`
  ## returned from the previous call to
  ## ListCompanies.
  ##   view: string
  ##       : The view of the `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   alt: string
  ##      : Data format for response.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   gpsMotivations: JArray
  ##                 : List of reasons for using Google Partner Search to get companies.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   specializations: JArray
  ##                  : List of specializations that the returned agencies should provide. If this
  ## is not empty, any returned agency must have at least one of these
  ## specializations, or one of the services in the "services" field.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   minMonthlyBudgetCurrencyCode: string
  ##                               : The 3-letter currency code defined in ISO 4217.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: string
  ##          : How to order addresses within the returned companies. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   services: JArray
  ##           : List of services that the returned agencies should provide. If this is
  ## not empty, any returned agency must have at least one of these services,
  ## or one of the specializations in the "specializations" field.
  ##   maxMonthlyBudgetNanos: int
  ##                        : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: string
  ##             : Website URL that will help to find a better matched company.
  ## .
  ##   maxMonthlyBudgetCurrencyCode: string
  ##                               : The 3-letter currency code defined in ISO 4217.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer companies than requested.
  ## If unspecified, server picks an appropriate default.
  ##   minMonthlyBudgetUnits: string
  ##                        : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: string
  ##          : The address to use when searching for companies.
  ## If not given, the geo-located address of the request is used.
  ##   languageCodes: JArray
  ##                : List of language codes that company can support. Only primary language
  ## subtags are accepted as defined by
  ## <a href="https://tools.ietf.org/html/bcp47">BCP 47</a>
  ## (IETF BCP 47, "Tags for Identifying Languages").
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   companyName: string
  ##              : Company name to search for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   minMonthlyBudgetNanos: int
  ##                        : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580037 = newJObject()
  add(query_580037, "upload_protocol", newJString(uploadProtocol))
  add(query_580037, "maxMonthlyBudget.units", newJString(maxMonthlyBudgetUnits))
  add(query_580037, "fields", newJString(fields))
  if industries != nil:
    query_580037.add "industries", industries
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(query_580037, "pageToken", newJString(pageToken))
  add(query_580037, "view", newJString(view))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "requestMetadata.locale", newJString(requestMetadataLocale))
  if gpsMotivations != nil:
    query_580037.add "gpsMotivations", gpsMotivations
  add(query_580037, "pp", newJBool(pp))
  add(query_580037, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  if specializations != nil:
    query_580037.add "specializations", specializations
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "callback", newJString(callback))
  add(query_580037, "access_token", newJString(accessToken))
  add(query_580037, "uploadType", newJString(uploadType))
  add(query_580037, "minMonthlyBudget.currencyCode",
      newJString(minMonthlyBudgetCurrencyCode))
  add(query_580037, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580037, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580037, "orderBy", newJString(orderBy))
  if services != nil:
    query_580037.add "services", services
  add(query_580037, "maxMonthlyBudget.nanos", newJInt(maxMonthlyBudgetNanos))
  add(query_580037, "key", newJString(key))
  add(query_580037, "websiteUrl", newJString(websiteUrl))
  add(query_580037, "maxMonthlyBudget.currencyCode",
      newJString(maxMonthlyBudgetCurrencyCode))
  add(query_580037, "$.xgafv", newJString(Xgafv))
  add(query_580037, "pageSize", newJInt(pageSize))
  add(query_580037, "minMonthlyBudget.units", newJString(minMonthlyBudgetUnits))
  add(query_580037, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_580037, "address", newJString(address))
  if languageCodes != nil:
    query_580037.add "languageCodes", languageCodes
  if requestMetadataExperimentIds != nil:
    query_580037.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580037, "companyName", newJString(companyName))
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  add(query_580037, "minMonthlyBudget.nanos", newJInt(minMonthlyBudgetNanos))
  add(query_580037, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580037, "bearer_token", newJString(bearerToken))
  result = call_580036.call(nil, query_580037, nil, nil, nil)

var partnersCompaniesList* = Call_PartnersCompaniesList_579994(
    name: "partnersCompaniesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersCompaniesList_579995, base: "/",
    url: url_PartnersCompaniesList_579996, schemes: {Scheme.Https})
type
  Call_PartnersUpdateCompanies_580038 = ref object of OpenApiRestCall_579421
proc url_PartnersUpdateCompanies_580040(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUpdateCompanies_580039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580041 = query.getOrDefault("upload_protocol")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "upload_protocol", valid_580041
  var valid_580042 = query.getOrDefault("fields")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fields", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("requestMetadata.locale")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "requestMetadata.locale", valid_580044
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
  var valid_580047 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
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
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580052
  var valid_580053 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580053
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("$.xgafv")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("1"))
  if valid_580055 != nil:
    section.add "$.xgafv", valid_580055
  var valid_580056 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580056
  var valid_580057 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580057 = validateParameter(valid_580057, JArray, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "requestMetadata.experimentIds", valid_580057
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
  var valid_580060 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580060
  var valid_580061 = query.getOrDefault("bearer_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "bearer_token", valid_580061
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

proc call*(call_580063: Call_PartnersUpdateCompanies_580038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_PartnersUpdateCompanies_580038;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = "";
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUpdateCompanies
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580065 = newJObject()
  var body_580066 = newJObject()
  add(query_580065, "upload_protocol", newJString(uploadProtocol))
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(query_580065, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "pp", newJBool(pp))
  add(query_580065, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "callback", newJString(callback))
  add(query_580065, "access_token", newJString(accessToken))
  add(query_580065, "uploadType", newJString(uploadType))
  add(query_580065, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580065, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580065, "key", newJString(key))
  add(query_580065, "$.xgafv", newJString(Xgafv))
  add(query_580065, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580065.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_580066 = body
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "updateMask", newJString(updateMask))
  add(query_580065, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580065, "bearer_token", newJString(bearerToken))
  result = call_580064.call(nil, query_580065, nil, nil, body_580066)

var partnersUpdateCompanies* = Call_PartnersUpdateCompanies_580038(
    name: "partnersUpdateCompanies", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersUpdateCompanies_580039, base: "/",
    url: url_PartnersUpdateCompanies_580040, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesGet_580067 = ref object of OpenApiRestCall_579421
proc url_PartnersCompaniesGet_580069(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "companyId" in path, "`companyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/companies/"),
               (kind: VariableSegment, value: "companyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersCompaniesGet_580068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   companyId: JString (required)
  ##            : The ID of the company to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `companyId` field"
  var valid_580084 = path.getOrDefault("companyId")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "companyId", valid_580084
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The view of `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   currencyCode: JString
  ##               : If the company's budget is in a different currency code than this one, then
  ## the converted budget is converted to this currency code.
  ##   orderBy: JString
  ##          : How to order addresses within the returned company. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: JString
  ##          : The address to use for sorting the company's addresses by proximity.
  ## If not given, the geo-located address of the request is used.
  ## Used when order_by is set.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("view")
  valid_580087 = validateParameter(valid_580087, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_580087 != nil:
    section.add "view", valid_580087
  var valid_580088 = query.getOrDefault("quotaUser")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "quotaUser", valid_580088
  var valid_580089 = query.getOrDefault("requestMetadata.locale")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "requestMetadata.locale", valid_580089
  var valid_580090 = query.getOrDefault("alt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("json"))
  if valid_580090 != nil:
    section.add "alt", valid_580090
  var valid_580091 = query.getOrDefault("pp")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "pp", valid_580091
  var valid_580092 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("callback")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "callback", valid_580094
  var valid_580095 = query.getOrDefault("access_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "access_token", valid_580095
  var valid_580096 = query.getOrDefault("uploadType")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "uploadType", valid_580096
  var valid_580097 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580097
  var valid_580098 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580098
  var valid_580099 = query.getOrDefault("currencyCode")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "currencyCode", valid_580099
  var valid_580100 = query.getOrDefault("orderBy")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "orderBy", valid_580100
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
  var valid_580103 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580103
  var valid_580104 = query.getOrDefault("address")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "address", valid_580104
  var valid_580105 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580105 = validateParameter(valid_580105, JArray, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "requestMetadata.experimentIds", valid_580105
  var valid_580106 = query.getOrDefault("prettyPrint")
  valid_580106 = validateParameter(valid_580106, JBool, required = false,
                                 default = newJBool(true))
  if valid_580106 != nil:
    section.add "prettyPrint", valid_580106
  var valid_580107 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580107
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

proc call*(call_580109: Call_PartnersCompaniesGet_580067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a company.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_PartnersCompaniesGet_580067; companyId: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "COMPANY_VIEW_UNSPECIFIED"; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          currencyCode: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          address: string = ""; requestMetadataExperimentIds: JsonNode = nil;
          prettyPrint: bool = true; requestMetadataPartnersSessionId: string = "";
          bearerToken: string = ""): Recallable =
  ## partnersCompaniesGet
  ## Gets a company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The view of `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   currencyCode: string
  ##               : If the company's budget is in a different currency code than this one, then
  ## the converted budget is converted to this currency code.
  ##   orderBy: string
  ##          : How to order addresses within the returned company. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: string
  ##          : The address to use for sorting the company's addresses by proximity.
  ## If not given, the geo-located address of the request is used.
  ## Used when order_by is set.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   companyId: string (required)
  ##            : The ID of the company to retrieve.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580111 = newJObject()
  var query_580112 = newJObject()
  add(query_580112, "upload_protocol", newJString(uploadProtocol))
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "view", newJString(view))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "pp", newJBool(pp))
  add(query_580112, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "callback", newJString(callback))
  add(query_580112, "access_token", newJString(accessToken))
  add(query_580112, "uploadType", newJString(uploadType))
  add(query_580112, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580112, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580112, "currencyCode", newJString(currencyCode))
  add(query_580112, "orderBy", newJString(orderBy))
  add(query_580112, "key", newJString(key))
  add(query_580112, "$.xgafv", newJString(Xgafv))
  add(query_580112, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_580112, "address", newJString(address))
  if requestMetadataExperimentIds != nil:
    query_580112.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  add(path_580111, "companyId", newJString(companyId))
  add(query_580112, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580112, "bearer_token", newJString(bearerToken))
  result = call_580110.call(path_580111, query_580112, nil, nil, nil)

var partnersCompaniesGet* = Call_PartnersCompaniesGet_580067(
    name: "partnersCompaniesGet", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}",
    validator: validate_PartnersCompaniesGet_580068, base: "/",
    url: url_PartnersCompaniesGet_580069, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesLeadsCreate_580113 = ref object of OpenApiRestCall_579421
proc url_PartnersCompaniesLeadsCreate_580115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "companyId" in path, "`companyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/companies/"),
               (kind: VariableSegment, value: "companyId"),
               (kind: ConstantSegment, value: "/leads")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersCompaniesLeadsCreate_580114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an advertiser lead for the given company ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   companyId: JString (required)
  ##            : The ID of the company to contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `companyId` field"
  var valid_580116 = path.getOrDefault("companyId")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "companyId", valid_580116
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
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  var valid_580123 = query.getOrDefault("callback")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "callback", valid_580123
  var valid_580124 = query.getOrDefault("access_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "access_token", valid_580124
  var valid_580125 = query.getOrDefault("uploadType")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "uploadType", valid_580125
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_PartnersCompaniesLeadsCreate_580113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an advertiser lead for the given company ID.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_PartnersCompaniesLeadsCreate_580113;
          companyId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## partnersCompaniesLeadsCreate
  ## Creates an advertiser lead for the given company ID.
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
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   companyId: string (required)
  ##            : The ID of the company to contact.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  var body_580135 = newJObject()
  add(query_580134, "upload_protocol", newJString(uploadProtocol))
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "pp", newJBool(pp))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "callback", newJString(callback))
  add(query_580134, "access_token", newJString(accessToken))
  add(query_580134, "uploadType", newJString(uploadType))
  add(query_580134, "key", newJString(key))
  add(query_580134, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580135 = body
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  add(path_580133, "companyId", newJString(companyId))
  add(query_580134, "bearer_token", newJString(bearerToken))
  result = call_580132.call(path_580133, query_580134, nil, nil, body_580135)

var partnersCompaniesLeadsCreate* = Call_PartnersCompaniesLeadsCreate_580113(
    name: "partnersCompaniesLeadsCreate", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}/leads",
    validator: validate_PartnersCompaniesLeadsCreate_580114, base: "/",
    url: url_PartnersCompaniesLeadsCreate_580115, schemes: {Scheme.Https})
type
  Call_PartnersLeadsList_580136 = ref object of OpenApiRestCall_579421
proc url_PartnersLeadsList_580138(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersLeadsList_580137(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListLeadsResponse.next_page_token`
  ## returned from the previous call to
  ## ListLeads.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: JString
  ##          : How to order Leads. Currently, only `create_time`
  ## and `create_time desc` are supported
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer leads than requested.
  ## If unspecified, server picks an appropriate default.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
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
  var valid_580141 = query.getOrDefault("pageToken")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "pageToken", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("requestMetadata.locale")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "requestMetadata.locale", valid_580143
  var valid_580144 = query.getOrDefault("alt")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("json"))
  if valid_580144 != nil:
    section.add "alt", valid_580144
  var valid_580145 = query.getOrDefault("pp")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "pp", valid_580145
  var valid_580146 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("callback")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "callback", valid_580148
  var valid_580149 = query.getOrDefault("access_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "access_token", valid_580149
  var valid_580150 = query.getOrDefault("uploadType")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "uploadType", valid_580150
  var valid_580151 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580151
  var valid_580152 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580152
  var valid_580153 = query.getOrDefault("orderBy")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "orderBy", valid_580153
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
  var valid_580156 = query.getOrDefault("pageSize")
  valid_580156 = validateParameter(valid_580156, JInt, required = false, default = nil)
  if valid_580156 != nil:
    section.add "pageSize", valid_580156
  var valid_580157 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580157
  var valid_580158 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580158 = validateParameter(valid_580158, JArray, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "requestMetadata.experimentIds", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
  var valid_580160 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580160
  var valid_580161 = query.getOrDefault("bearer_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "bearer_token", valid_580161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580162: Call_PartnersLeadsList_580136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_580162.validator(path, query, header, formData, body)
  let scheme = call_580162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580162.url(scheme.get, call_580162.host, call_580162.base,
                         call_580162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580162, url, valid)

proc call*(call_580163: Call_PartnersLeadsList_580136; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersLeadsList
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListLeadsResponse.next_page_token`
  ## returned from the previous call to
  ## ListLeads.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: string
  ##          : How to order Leads. Currently, only `create_time`
  ## and `create_time desc` are supported
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer leads than requested.
  ## If unspecified, server picks an appropriate default.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580164 = newJObject()
  add(query_580164, "upload_protocol", newJString(uploadProtocol))
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "pageToken", newJString(pageToken))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580164, "alt", newJString(alt))
  add(query_580164, "pp", newJBool(pp))
  add(query_580164, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "callback", newJString(callback))
  add(query_580164, "access_token", newJString(accessToken))
  add(query_580164, "uploadType", newJString(uploadType))
  add(query_580164, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580164, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580164, "orderBy", newJString(orderBy))
  add(query_580164, "key", newJString(key))
  add(query_580164, "$.xgafv", newJString(Xgafv))
  add(query_580164, "pageSize", newJInt(pageSize))
  add(query_580164, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580164.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  add(query_580164, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580164, "bearer_token", newJString(bearerToken))
  result = call_580163.call(nil, query_580164, nil, nil, nil)

var partnersLeadsList* = Call_PartnersLeadsList_580136(name: "partnersLeadsList",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersLeadsList_580137, base: "/",
    url: url_PartnersLeadsList_580138, schemes: {Scheme.Https})
type
  Call_PartnersUpdateLeads_580165 = ref object of OpenApiRestCall_579421
proc url_PartnersUpdateLeads_580167(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUpdateLeads_580166(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specified lead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ## Only `state` and `adwords_customer_id` are currently supported.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580168 = query.getOrDefault("upload_protocol")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "upload_protocol", valid_580168
  var valid_580169 = query.getOrDefault("fields")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "fields", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("requestMetadata.locale")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "requestMetadata.locale", valid_580171
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
  var valid_580174 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580174
  var valid_580175 = query.getOrDefault("oauth_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "oauth_token", valid_580175
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
  var valid_580178 = query.getOrDefault("uploadType")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "uploadType", valid_580178
  var valid_580179 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580179
  var valid_580180 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580180
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("$.xgafv")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("1"))
  if valid_580182 != nil:
    section.add "$.xgafv", valid_580182
  var valid_580183 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580183
  var valid_580184 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580184 = validateParameter(valid_580184, JArray, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "requestMetadata.experimentIds", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
  var valid_580186 = query.getOrDefault("updateMask")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "updateMask", valid_580186
  var valid_580187 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580187
  var valid_580188 = query.getOrDefault("bearer_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "bearer_token", valid_580188
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

proc call*(call_580190: Call_PartnersUpdateLeads_580165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified lead.
  ## 
  let valid = call_580190.validator(path, query, header, formData, body)
  let scheme = call_580190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580190.url(scheme.get, call_580190.host, call_580190.base,
                         call_580190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580190, url, valid)

proc call*(call_580191: Call_PartnersUpdateLeads_580165;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = "";
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUpdateLeads
  ## Updates the specified lead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ## Only `state` and `adwords_customer_id` are currently supported.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580192 = newJObject()
  var body_580193 = newJObject()
  add(query_580192, "upload_protocol", newJString(uploadProtocol))
  add(query_580192, "fields", newJString(fields))
  add(query_580192, "quotaUser", newJString(quotaUser))
  add(query_580192, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580192, "alt", newJString(alt))
  add(query_580192, "pp", newJBool(pp))
  add(query_580192, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580192, "oauth_token", newJString(oauthToken))
  add(query_580192, "callback", newJString(callback))
  add(query_580192, "access_token", newJString(accessToken))
  add(query_580192, "uploadType", newJString(uploadType))
  add(query_580192, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580192, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580192, "key", newJString(key))
  add(query_580192, "$.xgafv", newJString(Xgafv))
  add(query_580192, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580192.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_580193 = body
  add(query_580192, "prettyPrint", newJBool(prettyPrint))
  add(query_580192, "updateMask", newJString(updateMask))
  add(query_580192, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580192, "bearer_token", newJString(bearerToken))
  result = call_580191.call(nil, query_580192, nil, nil, body_580193)

var partnersUpdateLeads* = Call_PartnersUpdateLeads_580165(
    name: "partnersUpdateLeads", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersUpdateLeads_580166, base: "/",
    url: url_PartnersUpdateLeads_580167, schemes: {Scheme.Https})
type
  Call_PartnersOffersList_580194 = ref object of OpenApiRestCall_579421
proc url_PartnersOffersList_580196(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersOffersList_580195(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the Offers available for the current user
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580197 = query.getOrDefault("upload_protocol")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "upload_protocol", valid_580197
  var valid_580198 = query.getOrDefault("fields")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "fields", valid_580198
  var valid_580199 = query.getOrDefault("quotaUser")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "quotaUser", valid_580199
  var valid_580200 = query.getOrDefault("requestMetadata.locale")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "requestMetadata.locale", valid_580200
  var valid_580201 = query.getOrDefault("alt")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = newJString("json"))
  if valid_580201 != nil:
    section.add "alt", valid_580201
  var valid_580202 = query.getOrDefault("pp")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "pp", valid_580202
  var valid_580203 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("callback")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "callback", valid_580205
  var valid_580206 = query.getOrDefault("access_token")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "access_token", valid_580206
  var valid_580207 = query.getOrDefault("uploadType")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "uploadType", valid_580207
  var valid_580208 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580208
  var valid_580209 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580209
  var valid_580210 = query.getOrDefault("key")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "key", valid_580210
  var valid_580211 = query.getOrDefault("$.xgafv")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("1"))
  if valid_580211 != nil:
    section.add "$.xgafv", valid_580211
  var valid_580212 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580212
  var valid_580213 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580213 = validateParameter(valid_580213, JArray, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "requestMetadata.experimentIds", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  var valid_580215 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580215
  var valid_580216 = query.getOrDefault("bearer_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "bearer_token", valid_580216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580217: Call_PartnersOffersList_580194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Offers available for the current user
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_PartnersOffersList_580194;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersOffersList
  ## Lists the Offers available for the current user
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580219 = newJObject()
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "pp", newJBool(pp))
  add(query_580219, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "callback", newJString(callback))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "uploadType", newJString(uploadType))
  add(query_580219, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580219, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580219, "key", newJString(key))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  add(query_580219, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580219.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  add(query_580219, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580219, "bearer_token", newJString(bearerToken))
  result = call_580218.call(nil, query_580219, nil, nil, nil)

var partnersOffersList* = Call_PartnersOffersList_580194(
    name: "partnersOffersList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers",
    validator: validate_PartnersOffersList_580195, base: "/",
    url: url_PartnersOffersList_580196, schemes: {Scheme.Https})
type
  Call_PartnersOffersHistoryList_580220 = ref object of OpenApiRestCall_579421
proc url_PartnersOffersHistoryList_580222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersOffersHistoryList_580221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Historical Offers for the current user (or user's entire company)
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to retrieve a specific page.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   entireCompany: JBool
  ##                : if true, show history for the entire company.  Requires user to be admin.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: JString
  ##          : Comma-separated list of fields to order by, e.g.: "foo,bar,baz".
  ## Use "foo desc" to sort descending.
  ## List of valid field names is: name, offer_code, expiration_time, status,
  ##     last_modified_time, sender_name, creation_time, country_code,
  ##     offer_type.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of rows to return per page.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580223 = query.getOrDefault("upload_protocol")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "upload_protocol", valid_580223
  var valid_580224 = query.getOrDefault("fields")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "fields", valid_580224
  var valid_580225 = query.getOrDefault("pageToken")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "pageToken", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("entireCompany")
  valid_580227 = validateParameter(valid_580227, JBool, required = false, default = nil)
  if valid_580227 != nil:
    section.add "entireCompany", valid_580227
  var valid_580228 = query.getOrDefault("requestMetadata.locale")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "requestMetadata.locale", valid_580228
  var valid_580229 = query.getOrDefault("alt")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("json"))
  if valid_580229 != nil:
    section.add "alt", valid_580229
  var valid_580230 = query.getOrDefault("pp")
  valid_580230 = validateParameter(valid_580230, JBool, required = false,
                                 default = newJBool(true))
  if valid_580230 != nil:
    section.add "pp", valid_580230
  var valid_580231 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580231
  var valid_580232 = query.getOrDefault("oauth_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "oauth_token", valid_580232
  var valid_580233 = query.getOrDefault("callback")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "callback", valid_580233
  var valid_580234 = query.getOrDefault("access_token")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "access_token", valid_580234
  var valid_580235 = query.getOrDefault("uploadType")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "uploadType", valid_580235
  var valid_580236 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580236
  var valid_580237 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580237
  var valid_580238 = query.getOrDefault("orderBy")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "orderBy", valid_580238
  var valid_580239 = query.getOrDefault("key")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "key", valid_580239
  var valid_580240 = query.getOrDefault("$.xgafv")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("1"))
  if valid_580240 != nil:
    section.add "$.xgafv", valid_580240
  var valid_580241 = query.getOrDefault("pageSize")
  valid_580241 = validateParameter(valid_580241, JInt, required = false, default = nil)
  if valid_580241 != nil:
    section.add "pageSize", valid_580241
  var valid_580242 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580242
  var valid_580243 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580243 = validateParameter(valid_580243, JArray, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "requestMetadata.experimentIds", valid_580243
  var valid_580244 = query.getOrDefault("prettyPrint")
  valid_580244 = validateParameter(valid_580244, JBool, required = false,
                                 default = newJBool(true))
  if valid_580244 != nil:
    section.add "prettyPrint", valid_580244
  var valid_580245 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580245
  var valid_580246 = query.getOrDefault("bearer_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "bearer_token", valid_580246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580247: Call_PartnersOffersHistoryList_580220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Historical Offers for the current user (or user's entire company)
  ## 
  let valid = call_580247.validator(path, query, header, formData, body)
  let scheme = call_580247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580247.url(scheme.get, call_580247.host, call_580247.base,
                         call_580247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580247, url, valid)

proc call*(call_580248: Call_PartnersOffersHistoryList_580220;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; entireCompany: bool = false;
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersOffersHistoryList
  ## Lists the Historical Offers for the current user (or user's entire company)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to retrieve a specific page.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   entireCompany: bool
  ##                : if true, show history for the entire company.  Requires user to be admin.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: string
  ##          : Comma-separated list of fields to order by, e.g.: "foo,bar,baz".
  ## Use "foo desc" to sort descending.
  ## List of valid field names is: name, offer_code, expiration_time, status,
  ##     last_modified_time, sender_name, creation_time, country_code,
  ##     offer_type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of rows to return per page.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580249 = newJObject()
  add(query_580249, "upload_protocol", newJString(uploadProtocol))
  add(query_580249, "fields", newJString(fields))
  add(query_580249, "pageToken", newJString(pageToken))
  add(query_580249, "quotaUser", newJString(quotaUser))
  add(query_580249, "entireCompany", newJBool(entireCompany))
  add(query_580249, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580249, "alt", newJString(alt))
  add(query_580249, "pp", newJBool(pp))
  add(query_580249, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580249, "oauth_token", newJString(oauthToken))
  add(query_580249, "callback", newJString(callback))
  add(query_580249, "access_token", newJString(accessToken))
  add(query_580249, "uploadType", newJString(uploadType))
  add(query_580249, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580249, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580249, "orderBy", newJString(orderBy))
  add(query_580249, "key", newJString(key))
  add(query_580249, "$.xgafv", newJString(Xgafv))
  add(query_580249, "pageSize", newJInt(pageSize))
  add(query_580249, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580249.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580249, "prettyPrint", newJBool(prettyPrint))
  add(query_580249, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580249, "bearer_token", newJString(bearerToken))
  result = call_580248.call(nil, query_580249, nil, nil, nil)

var partnersOffersHistoryList* = Call_PartnersOffersHistoryList_580220(
    name: "partnersOffersHistoryList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers/history",
    validator: validate_PartnersOffersHistoryList_580221, base: "/",
    url: url_PartnersOffersHistoryList_580222, schemes: {Scheme.Https})
type
  Call_PartnersGetPartnersstatus_580250 = ref object of OpenApiRestCall_579421
proc url_PartnersGetPartnersstatus_580252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersGetPartnersstatus_580251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
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
  var valid_580256 = query.getOrDefault("requestMetadata.locale")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "requestMetadata.locale", valid_580256
  var valid_580257 = query.getOrDefault("alt")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("json"))
  if valid_580257 != nil:
    section.add "alt", valid_580257
  var valid_580258 = query.getOrDefault("pp")
  valid_580258 = validateParameter(valid_580258, JBool, required = false,
                                 default = newJBool(true))
  if valid_580258 != nil:
    section.add "pp", valid_580258
  var valid_580259 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580259
  var valid_580260 = query.getOrDefault("oauth_token")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "oauth_token", valid_580260
  var valid_580261 = query.getOrDefault("callback")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "callback", valid_580261
  var valid_580262 = query.getOrDefault("access_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "access_token", valid_580262
  var valid_580263 = query.getOrDefault("uploadType")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "uploadType", valid_580263
  var valid_580264 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580264
  var valid_580265 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580265
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("$.xgafv")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = newJString("1"))
  if valid_580267 != nil:
    section.add "$.xgafv", valid_580267
  var valid_580268 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580268
  var valid_580269 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580269 = validateParameter(valid_580269, JArray, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "requestMetadata.experimentIds", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  var valid_580271 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580271
  var valid_580272 = query.getOrDefault("bearer_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "bearer_token", valid_580272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580273: Call_PartnersGetPartnersstatus_580250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ## 
  let valid = call_580273.validator(path, query, header, formData, body)
  let scheme = call_580273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580273.url(scheme.get, call_580273.host, call_580273.base,
                         call_580273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580273, url, valid)

proc call*(call_580274: Call_PartnersGetPartnersstatus_580250;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersGetPartnersstatus
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580275 = newJObject()
  add(query_580275, "upload_protocol", newJString(uploadProtocol))
  add(query_580275, "fields", newJString(fields))
  add(query_580275, "quotaUser", newJString(quotaUser))
  add(query_580275, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580275, "alt", newJString(alt))
  add(query_580275, "pp", newJBool(pp))
  add(query_580275, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580275, "oauth_token", newJString(oauthToken))
  add(query_580275, "callback", newJString(callback))
  add(query_580275, "access_token", newJString(accessToken))
  add(query_580275, "uploadType", newJString(uploadType))
  add(query_580275, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580275, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580275, "key", newJString(key))
  add(query_580275, "$.xgafv", newJString(Xgafv))
  add(query_580275, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580275.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580275, "prettyPrint", newJBool(prettyPrint))
  add(query_580275, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580275, "bearer_token", newJString(bearerToken))
  result = call_580274.call(nil, query_580275, nil, nil, nil)

var partnersGetPartnersstatus* = Call_PartnersGetPartnersstatus_580250(
    name: "partnersGetPartnersstatus", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/partnersstatus",
    validator: validate_PartnersGetPartnersstatus_580251, base: "/",
    url: url_PartnersGetPartnersstatus_580252, schemes: {Scheme.Https})
type
  Call_PartnersUserEventsLog_580276 = ref object of OpenApiRestCall_579421
proc url_PartnersUserEventsLog_580278(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUserEventsLog_580277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Logs a user event.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580279 = query.getOrDefault("upload_protocol")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "upload_protocol", valid_580279
  var valid_580280 = query.getOrDefault("fields")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "fields", valid_580280
  var valid_580281 = query.getOrDefault("quotaUser")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "quotaUser", valid_580281
  var valid_580282 = query.getOrDefault("alt")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("json"))
  if valid_580282 != nil:
    section.add "alt", valid_580282
  var valid_580283 = query.getOrDefault("pp")
  valid_580283 = validateParameter(valid_580283, JBool, required = false,
                                 default = newJBool(true))
  if valid_580283 != nil:
    section.add "pp", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("callback")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "callback", valid_580285
  var valid_580286 = query.getOrDefault("access_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "access_token", valid_580286
  var valid_580287 = query.getOrDefault("uploadType")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "uploadType", valid_580287
  var valid_580288 = query.getOrDefault("key")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "key", valid_580288
  var valid_580289 = query.getOrDefault("$.xgafv")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("1"))
  if valid_580289 != nil:
    section.add "$.xgafv", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  var valid_580291 = query.getOrDefault("bearer_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "bearer_token", valid_580291
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

proc call*(call_580293: Call_PartnersUserEventsLog_580276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a user event.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_PartnersUserEventsLog_580276;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## partnersUserEventsLog
  ## Logs a user event.
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
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580295 = newJObject()
  var body_580296 = newJObject()
  add(query_580295, "upload_protocol", newJString(uploadProtocol))
  add(query_580295, "fields", newJString(fields))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "pp", newJBool(pp))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(query_580295, "callback", newJString(callback))
  add(query_580295, "access_token", newJString(accessToken))
  add(query_580295, "uploadType", newJString(uploadType))
  add(query_580295, "key", newJString(key))
  add(query_580295, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580296 = body
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(query_580295, "bearer_token", newJString(bearerToken))
  result = call_580294.call(nil, query_580295, nil, nil, body_580296)

var partnersUserEventsLog* = Call_PartnersUserEventsLog_580276(
    name: "partnersUserEventsLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/userEvents:log",
    validator: validate_PartnersUserEventsLog_580277, base: "/",
    url: url_PartnersUserEventsLog_580278, schemes: {Scheme.Https})
type
  Call_PartnersUserStatesList_580297 = ref object of OpenApiRestCall_579421
proc url_PartnersUserStatesList_580299(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUserStatesList_580298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists states for current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580300 = query.getOrDefault("upload_protocol")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "upload_protocol", valid_580300
  var valid_580301 = query.getOrDefault("fields")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "fields", valid_580301
  var valid_580302 = query.getOrDefault("quotaUser")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "quotaUser", valid_580302
  var valid_580303 = query.getOrDefault("requestMetadata.locale")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "requestMetadata.locale", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("pp")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "pp", valid_580305
  var valid_580306 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580306
  var valid_580307 = query.getOrDefault("oauth_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "oauth_token", valid_580307
  var valid_580308 = query.getOrDefault("callback")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "callback", valid_580308
  var valid_580309 = query.getOrDefault("access_token")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "access_token", valid_580309
  var valid_580310 = query.getOrDefault("uploadType")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "uploadType", valid_580310
  var valid_580311 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580311
  var valid_580312 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580312
  var valid_580313 = query.getOrDefault("key")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "key", valid_580313
  var valid_580314 = query.getOrDefault("$.xgafv")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = newJString("1"))
  if valid_580314 != nil:
    section.add "$.xgafv", valid_580314
  var valid_580315 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580315
  var valid_580316 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580316 = validateParameter(valid_580316, JArray, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "requestMetadata.experimentIds", valid_580316
  var valid_580317 = query.getOrDefault("prettyPrint")
  valid_580317 = validateParameter(valid_580317, JBool, required = false,
                                 default = newJBool(true))
  if valid_580317 != nil:
    section.add "prettyPrint", valid_580317
  var valid_580318 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580318
  var valid_580319 = query.getOrDefault("bearer_token")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "bearer_token", valid_580319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580320: Call_PartnersUserStatesList_580297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists states for current user.
  ## 
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_PartnersUserStatesList_580297;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUserStatesList
  ## Lists states for current user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580322 = newJObject()
  add(query_580322, "upload_protocol", newJString(uploadProtocol))
  add(query_580322, "fields", newJString(fields))
  add(query_580322, "quotaUser", newJString(quotaUser))
  add(query_580322, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580322, "alt", newJString(alt))
  add(query_580322, "pp", newJBool(pp))
  add(query_580322, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580322, "oauth_token", newJString(oauthToken))
  add(query_580322, "callback", newJString(callback))
  add(query_580322, "access_token", newJString(accessToken))
  add(query_580322, "uploadType", newJString(uploadType))
  add(query_580322, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580322, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580322, "key", newJString(key))
  add(query_580322, "$.xgafv", newJString(Xgafv))
  add(query_580322, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580322.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580322, "prettyPrint", newJBool(prettyPrint))
  add(query_580322, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580322, "bearer_token", newJString(bearerToken))
  result = call_580321.call(nil, query_580322, nil, nil, nil)

var partnersUserStatesList* = Call_PartnersUserStatesList_580297(
    name: "partnersUserStatesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/userStates",
    validator: validate_PartnersUserStatesList_580298, base: "/",
    url: url_PartnersUserStatesList_580299, schemes: {Scheme.Https})
type
  Call_PartnersUsersUpdateProfile_580323 = ref object of OpenApiRestCall_579421
proc url_PartnersUsersUpdateProfile_580325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUsersUpdateProfile_580324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580326 = query.getOrDefault("upload_protocol")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "upload_protocol", valid_580326
  var valid_580327 = query.getOrDefault("fields")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "fields", valid_580327
  var valid_580328 = query.getOrDefault("quotaUser")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "quotaUser", valid_580328
  var valid_580329 = query.getOrDefault("requestMetadata.locale")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "requestMetadata.locale", valid_580329
  var valid_580330 = query.getOrDefault("alt")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("json"))
  if valid_580330 != nil:
    section.add "alt", valid_580330
  var valid_580331 = query.getOrDefault("pp")
  valid_580331 = validateParameter(valid_580331, JBool, required = false,
                                 default = newJBool(true))
  if valid_580331 != nil:
    section.add "pp", valid_580331
  var valid_580332 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580332
  var valid_580333 = query.getOrDefault("oauth_token")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "oauth_token", valid_580333
  var valid_580334 = query.getOrDefault("callback")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "callback", valid_580334
  var valid_580335 = query.getOrDefault("access_token")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "access_token", valid_580335
  var valid_580336 = query.getOrDefault("uploadType")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "uploadType", valid_580336
  var valid_580337 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580337
  var valid_580338 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580338
  var valid_580339 = query.getOrDefault("key")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "key", valid_580339
  var valid_580340 = query.getOrDefault("$.xgafv")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("1"))
  if valid_580340 != nil:
    section.add "$.xgafv", valid_580340
  var valid_580341 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580341
  var valid_580342 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580342 = validateParameter(valid_580342, JArray, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "requestMetadata.experimentIds", valid_580342
  var valid_580343 = query.getOrDefault("prettyPrint")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(true))
  if valid_580343 != nil:
    section.add "prettyPrint", valid_580343
  var valid_580344 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580344
  var valid_580345 = query.getOrDefault("bearer_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "bearer_token", valid_580345
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

proc call*(call_580347: Call_PartnersUsersUpdateProfile_580323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ## 
  let valid = call_580347.validator(path, query, header, formData, body)
  let scheme = call_580347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580347.url(scheme.get, call_580347.host, call_580347.base,
                         call_580347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580347, url, valid)

proc call*(call_580348: Call_PartnersUsersUpdateProfile_580323;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; requestMetadataPartnersSessionId: string = "";
          bearerToken: string = ""): Recallable =
  ## partnersUsersUpdateProfile
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_580349 = newJObject()
  var body_580350 = newJObject()
  add(query_580349, "upload_protocol", newJString(uploadProtocol))
  add(query_580349, "fields", newJString(fields))
  add(query_580349, "quotaUser", newJString(quotaUser))
  add(query_580349, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580349, "alt", newJString(alt))
  add(query_580349, "pp", newJBool(pp))
  add(query_580349, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580349, "oauth_token", newJString(oauthToken))
  add(query_580349, "callback", newJString(callback))
  add(query_580349, "access_token", newJString(accessToken))
  add(query_580349, "uploadType", newJString(uploadType))
  add(query_580349, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580349, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580349, "key", newJString(key))
  add(query_580349, "$.xgafv", newJString(Xgafv))
  add(query_580349, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580349.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_580350 = body
  add(query_580349, "prettyPrint", newJBool(prettyPrint))
  add(query_580349, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580349, "bearer_token", newJString(bearerToken))
  result = call_580348.call(nil, query_580349, nil, nil, body_580350)

var partnersUsersUpdateProfile* = Call_PartnersUsersUpdateProfile_580323(
    name: "partnersUsersUpdateProfile", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/users/profile",
    validator: validate_PartnersUsersUpdateProfile_580324, base: "/",
    url: url_PartnersUsersUpdateProfile_580325, schemes: {Scheme.Https})
type
  Call_PartnersUsersGet_580351 = ref object of OpenApiRestCall_579421
proc url_PartnersUsersGet_580353(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersUsersGet_580352(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : Identifier of the user. Can be set to <code>me</code> to mean the currently
  ## authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580354 = path.getOrDefault("userId")
  valid_580354 = validateParameter(valid_580354, JString, required = true,
                                 default = nil)
  if valid_580354 != nil:
    section.add "userId", valid_580354
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   userView: JString
  ##           : Specifies what parts of the user information to return.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580355 = query.getOrDefault("upload_protocol")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "upload_protocol", valid_580355
  var valid_580356 = query.getOrDefault("fields")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "fields", valid_580356
  var valid_580357 = query.getOrDefault("quotaUser")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "quotaUser", valid_580357
  var valid_580358 = query.getOrDefault("requestMetadata.locale")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "requestMetadata.locale", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("pp")
  valid_580360 = validateParameter(valid_580360, JBool, required = false,
                                 default = newJBool(true))
  if valid_580360 != nil:
    section.add "pp", valid_580360
  var valid_580361 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580361
  var valid_580362 = query.getOrDefault("userView")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580362 != nil:
    section.add "userView", valid_580362
  var valid_580363 = query.getOrDefault("oauth_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "oauth_token", valid_580363
  var valid_580364 = query.getOrDefault("callback")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "callback", valid_580364
  var valid_580365 = query.getOrDefault("access_token")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "access_token", valid_580365
  var valid_580366 = query.getOrDefault("uploadType")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "uploadType", valid_580366
  var valid_580367 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580367
  var valid_580368 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580368
  var valid_580369 = query.getOrDefault("key")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "key", valid_580369
  var valid_580370 = query.getOrDefault("$.xgafv")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = newJString("1"))
  if valid_580370 != nil:
    section.add "$.xgafv", valid_580370
  var valid_580371 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580371
  var valid_580372 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580372 = validateParameter(valid_580372, JArray, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "requestMetadata.experimentIds", valid_580372
  var valid_580373 = query.getOrDefault("prettyPrint")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(true))
  if valid_580373 != nil:
    section.add "prettyPrint", valid_580373
  var valid_580374 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580374
  var valid_580375 = query.getOrDefault("bearer_token")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "bearer_token", valid_580375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580376: Call_PartnersUsersGet_580351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a user.
  ## 
  let valid = call_580376.validator(path, query, header, formData, body)
  let scheme = call_580376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580376.url(scheme.get, call_580376.host, call_580376.base,
                         call_580376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580376, url, valid)

proc call*(call_580377: Call_PartnersUsersGet_580351; userId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          userView: string = "BASIC"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUsersGet
  ## Gets a user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   userView: string
  ##           : Specifies what parts of the user information to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Identifier of the user. Can be set to <code>me</code> to mean the currently
  ## authenticated user.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580378 = newJObject()
  var query_580379 = newJObject()
  add(query_580379, "upload_protocol", newJString(uploadProtocol))
  add(query_580379, "fields", newJString(fields))
  add(query_580379, "quotaUser", newJString(quotaUser))
  add(query_580379, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580379, "alt", newJString(alt))
  add(query_580379, "pp", newJBool(pp))
  add(query_580379, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580379, "userView", newJString(userView))
  add(query_580379, "oauth_token", newJString(oauthToken))
  add(query_580379, "callback", newJString(callback))
  add(query_580379, "access_token", newJString(accessToken))
  add(query_580379, "uploadType", newJString(uploadType))
  add(query_580379, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580379, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580379, "key", newJString(key))
  add(query_580379, "$.xgafv", newJString(Xgafv))
  add(query_580379, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580379.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580379, "prettyPrint", newJBool(prettyPrint))
  add(path_580378, "userId", newJString(userId))
  add(query_580379, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580379, "bearer_token", newJString(bearerToken))
  result = call_580377.call(path_580378, query_580379, nil, nil, nil)

var partnersUsersGet* = Call_PartnersUsersGet_580351(name: "partnersUsersGet",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com",
    route: "/v2/users/{userId}", validator: validate_PartnersUsersGet_580352,
    base: "/", url: url_PartnersUsersGet_580353, schemes: {Scheme.Https})
type
  Call_PartnersUsersCreateCompanyRelation_580380 = ref object of OpenApiRestCall_579421
proc url_PartnersUsersCreateCompanyRelation_580382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/companyRelation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersUsersCreateCompanyRelation_580381(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a user's company relation. Affiliates the user to a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580383 = path.getOrDefault("userId")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "userId", valid_580383
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580384 = query.getOrDefault("upload_protocol")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "upload_protocol", valid_580384
  var valid_580385 = query.getOrDefault("fields")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "fields", valid_580385
  var valid_580386 = query.getOrDefault("quotaUser")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "quotaUser", valid_580386
  var valid_580387 = query.getOrDefault("requestMetadata.locale")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "requestMetadata.locale", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("pp")
  valid_580389 = validateParameter(valid_580389, JBool, required = false,
                                 default = newJBool(true))
  if valid_580389 != nil:
    section.add "pp", valid_580389
  var valid_580390 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580390
  var valid_580391 = query.getOrDefault("oauth_token")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "oauth_token", valid_580391
  var valid_580392 = query.getOrDefault("callback")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "callback", valid_580392
  var valid_580393 = query.getOrDefault("access_token")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "access_token", valid_580393
  var valid_580394 = query.getOrDefault("uploadType")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "uploadType", valid_580394
  var valid_580395 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580395
  var valid_580396 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580396
  var valid_580397 = query.getOrDefault("key")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "key", valid_580397
  var valid_580398 = query.getOrDefault("$.xgafv")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = newJString("1"))
  if valid_580398 != nil:
    section.add "$.xgafv", valid_580398
  var valid_580399 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580399
  var valid_580400 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580400 = validateParameter(valid_580400, JArray, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "requestMetadata.experimentIds", valid_580400
  var valid_580401 = query.getOrDefault("prettyPrint")
  valid_580401 = validateParameter(valid_580401, JBool, required = false,
                                 default = newJBool(true))
  if valid_580401 != nil:
    section.add "prettyPrint", valid_580401
  var valid_580402 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580402
  var valid_580403 = query.getOrDefault("bearer_token")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "bearer_token", valid_580403
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

proc call*(call_580405: Call_PartnersUsersCreateCompanyRelation_580380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's company relation. Affiliates the user to a company.
  ## 
  let valid = call_580405.validator(path, query, header, formData, body)
  let scheme = call_580405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580405.url(scheme.get, call_580405.host, call_580405.base,
                         call_580405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580405, url, valid)

proc call*(call_580406: Call_PartnersUsersCreateCompanyRelation_580380;
          userId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; requestMetadataLocale: string = "";
          alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; requestMetadataPartnersSessionId: string = "";
          bearerToken: string = ""): Recallable =
  ## partnersUsersCreateCompanyRelation
  ## Creates a user's company relation. Affiliates the user to a company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580407 = newJObject()
  var query_580408 = newJObject()
  var body_580409 = newJObject()
  add(query_580408, "upload_protocol", newJString(uploadProtocol))
  add(query_580408, "fields", newJString(fields))
  add(query_580408, "quotaUser", newJString(quotaUser))
  add(query_580408, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580408, "alt", newJString(alt))
  add(query_580408, "pp", newJBool(pp))
  add(query_580408, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580408, "oauth_token", newJString(oauthToken))
  add(query_580408, "callback", newJString(callback))
  add(query_580408, "access_token", newJString(accessToken))
  add(query_580408, "uploadType", newJString(uploadType))
  add(query_580408, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580408, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580408, "key", newJString(key))
  add(query_580408, "$.xgafv", newJString(Xgafv))
  add(query_580408, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580408.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_580409 = body
  add(query_580408, "prettyPrint", newJBool(prettyPrint))
  add(path_580407, "userId", newJString(userId))
  add(query_580408, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580408, "bearer_token", newJString(bearerToken))
  result = call_580406.call(path_580407, query_580408, nil, nil, body_580409)

var partnersUsersCreateCompanyRelation* = Call_PartnersUsersCreateCompanyRelation_580380(
    name: "partnersUsersCreateCompanyRelation", meth: HttpMethod.HttpPut,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersCreateCompanyRelation_580381, base: "/",
    url: url_PartnersUsersCreateCompanyRelation_580382, schemes: {Scheme.Https})
type
  Call_PartnersUsersDeleteCompanyRelation_580410 = ref object of OpenApiRestCall_579421
proc url_PartnersUsersDeleteCompanyRelation_580412(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/companyRelation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersUsersDeleteCompanyRelation_580411(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580413 = path.getOrDefault("userId")
  valid_580413 = validateParameter(valid_580413, JString, required = true,
                                 default = nil)
  if valid_580413 != nil:
    section.add "userId", valid_580413
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580414 = query.getOrDefault("upload_protocol")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "upload_protocol", valid_580414
  var valid_580415 = query.getOrDefault("fields")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "fields", valid_580415
  var valid_580416 = query.getOrDefault("quotaUser")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "quotaUser", valid_580416
  var valid_580417 = query.getOrDefault("requestMetadata.locale")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "requestMetadata.locale", valid_580417
  var valid_580418 = query.getOrDefault("alt")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("json"))
  if valid_580418 != nil:
    section.add "alt", valid_580418
  var valid_580419 = query.getOrDefault("pp")
  valid_580419 = validateParameter(valid_580419, JBool, required = false,
                                 default = newJBool(true))
  if valid_580419 != nil:
    section.add "pp", valid_580419
  var valid_580420 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("callback")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "callback", valid_580422
  var valid_580423 = query.getOrDefault("access_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "access_token", valid_580423
  var valid_580424 = query.getOrDefault("uploadType")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "uploadType", valid_580424
  var valid_580425 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_580425
  var valid_580426 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_580426
  var valid_580427 = query.getOrDefault("key")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "key", valid_580427
  var valid_580428 = query.getOrDefault("$.xgafv")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = newJString("1"))
  if valid_580428 != nil:
    section.add "$.xgafv", valid_580428
  var valid_580429 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_580429
  var valid_580430 = query.getOrDefault("requestMetadata.experimentIds")
  valid_580430 = validateParameter(valid_580430, JArray, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "requestMetadata.experimentIds", valid_580430
  var valid_580431 = query.getOrDefault("prettyPrint")
  valid_580431 = validateParameter(valid_580431, JBool, required = false,
                                 default = newJBool(true))
  if valid_580431 != nil:
    section.add "prettyPrint", valid_580431
  var valid_580432 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "requestMetadata.partnersSessionId", valid_580432
  var valid_580433 = query.getOrDefault("bearer_token")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "bearer_token", valid_580433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580434: Call_PartnersUsersDeleteCompanyRelation_580410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ## 
  let valid = call_580434.validator(path, query, header, formData, body)
  let scheme = call_580434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580434.url(scheme.get, call_580434.host, call_580434.base,
                         call_580434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580434, url, valid)

proc call*(call_580435: Call_PartnersUsersDeleteCompanyRelation_580410;
          userId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; requestMetadataLocale: string = "";
          alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUsersDeleteCompanyRelation
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580436 = newJObject()
  var query_580437 = newJObject()
  add(query_580437, "upload_protocol", newJString(uploadProtocol))
  add(query_580437, "fields", newJString(fields))
  add(query_580437, "quotaUser", newJString(quotaUser))
  add(query_580437, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_580437, "alt", newJString(alt))
  add(query_580437, "pp", newJBool(pp))
  add(query_580437, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_580437, "oauth_token", newJString(oauthToken))
  add(query_580437, "callback", newJString(callback))
  add(query_580437, "access_token", newJString(accessToken))
  add(query_580437, "uploadType", newJString(uploadType))
  add(query_580437, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_580437, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_580437, "key", newJString(key))
  add(query_580437, "$.xgafv", newJString(Xgafv))
  add(query_580437, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_580437.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_580437, "prettyPrint", newJBool(prettyPrint))
  add(path_580436, "userId", newJString(userId))
  add(query_580437, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_580437, "bearer_token", newJString(bearerToken))
  result = call_580435.call(path_580436, query_580437, nil, nil, nil)

var partnersUsersDeleteCompanyRelation* = Call_PartnersUsersDeleteCompanyRelation_580410(
    name: "partnersUsersDeleteCompanyRelation", meth: HttpMethod.HttpDelete,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersDeleteCompanyRelation_580411, base: "/",
    url: url_PartnersUsersDeleteCompanyRelation_580412, schemes: {Scheme.Https})
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
