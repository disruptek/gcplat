
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "partners"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PartnersAnalyticsList_578619 = ref object of OpenApiRestCall_578348
proc url_PartnersAnalyticsList_578621(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersAnalyticsList_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer analytics than requested.
  ## If unspecified or set to 0, default value is 30.
  ## Specifies the number of days in the date range when querying analytics.
  ## The `page_token` represents the end date of the date range
  ## and the start date is calculated using the `page_size` as the number
  ## of days BEFORE the end date.
  ## Must be a non-negative integer.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListAnalyticsResponse.next_page_token`
  ## returned from the previous call to
  ## ListAnalytics.
  ## Will be a date string in `YYYY-MM-DD` format representing the end date
  ## of the date range of results to return.
  ## If unspecified or set to "", default value is the current date.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("pp")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "pp", valid_578747
  var valid_578748 = query.getOrDefault("prettyPrint")
  valid_578748 = validateParameter(valid_578748, JBool, required = false,
                                 default = newJBool(true))
  if valid_578748 != nil:
    section.add "prettyPrint", valid_578748
  var valid_578749 = query.getOrDefault("oauth_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "oauth_token", valid_578749
  var valid_578750 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_578750
  var valid_578751 = query.getOrDefault("$.xgafv")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = newJString("1"))
  if valid_578751 != nil:
    section.add "$.xgafv", valid_578751
  var valid_578752 = query.getOrDefault("bearer_token")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "bearer_token", valid_578752
  var valid_578753 = query.getOrDefault("pageSize")
  valid_578753 = validateParameter(valid_578753, JInt, required = false, default = nil)
  if valid_578753 != nil:
    section.add "pageSize", valid_578753
  var valid_578754 = query.getOrDefault("alt")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = newJString("json"))
  if valid_578754 != nil:
    section.add "alt", valid_578754
  var valid_578755 = query.getOrDefault("uploadType")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "uploadType", valid_578755
  var valid_578756 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("pageToken")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "pageToken", valid_578758
  var valid_578759 = query.getOrDefault("requestMetadata.experimentIds")
  valid_578759 = validateParameter(valid_578759, JArray, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "requestMetadata.experimentIds", valid_578759
  var valid_578760 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_578760
  var valid_578761 = query.getOrDefault("callback")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "callback", valid_578761
  var valid_578762 = query.getOrDefault("requestMetadata.locale")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "requestMetadata.locale", valid_578762
  var valid_578763 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_578763
  var valid_578764 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "requestMetadata.partnersSessionId", valid_578764
  var valid_578765 = query.getOrDefault("fields")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "fields", valid_578765
  var valid_578766 = query.getOrDefault("access_token")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "access_token", valid_578766
  var valid_578767 = query.getOrDefault("upload_protocol")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "upload_protocol", valid_578767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578790: Call_PartnersAnalyticsList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_578790.validator(path, query, header, formData, body)
  let scheme = call_578790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578790.url(scheme.get, call_578790.host, call_578790.base,
                         call_578790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578790, url, valid)

proc call*(call_578861: Call_PartnersAnalyticsList_578619; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; requestMetadataUserOverridesUserId: string = "";
          quotaUser: string = ""; pageToken: string = "";
          requestMetadataExperimentIds: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersAnalyticsList
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer analytics than requested.
  ## If unspecified or set to 0, default value is 30.
  ## Specifies the number of days in the date range when querying analytics.
  ## The `page_token` represents the end date of the date range
  ## and the start date is calculated using the `page_size` as the number
  ## of days BEFORE the end date.
  ## Must be a non-negative integer.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListAnalyticsResponse.next_page_token`
  ## returned from the previous call to
  ## ListAnalytics.
  ## Will be a date string in `YYYY-MM-DD` format representing the end date
  ## of the date range of results to return.
  ## If unspecified or set to "", default value is the current date.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578862 = newJObject()
  add(query_578862, "key", newJString(key))
  add(query_578862, "pp", newJBool(pp))
  add(query_578862, "prettyPrint", newJBool(prettyPrint))
  add(query_578862, "oauth_token", newJString(oauthToken))
  add(query_578862, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_578862, "$.xgafv", newJString(Xgafv))
  add(query_578862, "bearer_token", newJString(bearerToken))
  add(query_578862, "pageSize", newJInt(pageSize))
  add(query_578862, "alt", newJString(alt))
  add(query_578862, "uploadType", newJString(uploadType))
  add(query_578862, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_578862, "quotaUser", newJString(quotaUser))
  add(query_578862, "pageToken", newJString(pageToken))
  if requestMetadataExperimentIds != nil:
    query_578862.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_578862, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_578862, "callback", newJString(callback))
  add(query_578862, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_578862, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_578862, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_578862, "fields", newJString(fields))
  add(query_578862, "access_token", newJString(accessToken))
  add(query_578862, "upload_protocol", newJString(uploadProtocol))
  result = call_578861.call(nil, query_578862, nil, nil, nil)

var partnersAnalyticsList* = Call_PartnersAnalyticsList_578619(
    name: "partnersAnalyticsList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/analytics",
    validator: validate_PartnersAnalyticsList_578620, base: "/",
    url: url_PartnersAnalyticsList_578621, schemes: {Scheme.Https})
type
  Call_PartnersClientMessagesLog_578902 = ref object of OpenApiRestCall_578348
proc url_PartnersClientMessagesLog_578904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersClientMessagesLog_578903(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578905 = query.getOrDefault("key")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "key", valid_578905
  var valid_578906 = query.getOrDefault("pp")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "pp", valid_578906
  var valid_578907 = query.getOrDefault("prettyPrint")
  valid_578907 = validateParameter(valid_578907, JBool, required = false,
                                 default = newJBool(true))
  if valid_578907 != nil:
    section.add "prettyPrint", valid_578907
  var valid_578908 = query.getOrDefault("oauth_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "oauth_token", valid_578908
  var valid_578909 = query.getOrDefault("$.xgafv")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("1"))
  if valid_578909 != nil:
    section.add "$.xgafv", valid_578909
  var valid_578910 = query.getOrDefault("bearer_token")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "bearer_token", valid_578910
  var valid_578911 = query.getOrDefault("alt")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("json"))
  if valid_578911 != nil:
    section.add "alt", valid_578911
  var valid_578912 = query.getOrDefault("uploadType")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "uploadType", valid_578912
  var valid_578913 = query.getOrDefault("quotaUser")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "quotaUser", valid_578913
  var valid_578914 = query.getOrDefault("callback")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "callback", valid_578914
  var valid_578915 = query.getOrDefault("fields")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "fields", valid_578915
  var valid_578916 = query.getOrDefault("access_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "access_token", valid_578916
  var valid_578917 = query.getOrDefault("upload_protocol")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "upload_protocol", valid_578917
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

proc call*(call_578919: Call_PartnersClientMessagesLog_578902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_PartnersClientMessagesLog_578902; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## partnersClientMessagesLog
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578921 = newJObject()
  var body_578922 = newJObject()
  add(query_578921, "key", newJString(key))
  add(query_578921, "pp", newJBool(pp))
  add(query_578921, "prettyPrint", newJBool(prettyPrint))
  add(query_578921, "oauth_token", newJString(oauthToken))
  add(query_578921, "$.xgafv", newJString(Xgafv))
  add(query_578921, "bearer_token", newJString(bearerToken))
  add(query_578921, "alt", newJString(alt))
  add(query_578921, "uploadType", newJString(uploadType))
  add(query_578921, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578922 = body
  add(query_578921, "callback", newJString(callback))
  add(query_578921, "fields", newJString(fields))
  add(query_578921, "access_token", newJString(accessToken))
  add(query_578921, "upload_protocol", newJString(uploadProtocol))
  result = call_578920.call(nil, query_578921, nil, nil, body_578922)

var partnersClientMessagesLog* = Call_PartnersClientMessagesLog_578902(
    name: "partnersClientMessagesLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/clientMessages:log",
    validator: validate_PartnersClientMessagesLog_578903, base: "/",
    url: url_PartnersClientMessagesLog_578904, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesList_578923 = ref object of OpenApiRestCall_578348
proc url_PartnersCompaniesList_578925(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersCompaniesList_578924(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists companies.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   maxMonthlyBudget.nanos: JInt
  ##                         : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   specializations: JArray
  ##                  : List of specializations that the returned agencies should provide. If this
  ## is not empty, any returned agency must have at least one of these
  ## specializations, or one of the services in the "services" field.
  ##   minMonthlyBudget.units: JString
  ##                         : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCodes: JArray
  ##                : List of language codes that company can support. Only primary language
  ## subtags are accepted as defined by
  ## <a href="https://tools.ietf.org/html/bcp47">BCP 47</a>
  ## (IETF BCP 47, "Tags for Identifying Languages").
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer companies than requested.
  ## If unspecified, server picks an appropriate default.
  ##   maxMonthlyBudget.units: JString
  ##                         : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   minMonthlyBudget.nanos: JInt
  ##                         : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   industries: JArray
  ##             : List of industries the company can help with.
  ##   orderBy: JString
  ##          : How to order addresses within the returned companies. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListCompaniesResponse.next_page_token`
  ## returned from the previous call to
  ## ListCompanies.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   maxMonthlyBudget.currencyCode: JString
  ##                                : The 3-letter currency code defined in ISO 4217.
  ##   gpsMotivations: JArray
  ##                 : List of reasons for using Google Partner Search to get companies.
  ##   websiteUrl: JString
  ##             : Website URL that will help to find a better matched company.
  ## .
  ##   minMonthlyBudget.currencyCode: JString
  ##                                : The 3-letter currency code defined in ISO 4217.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   services: JArray
  ##           : List of services that the returned agencies should provide. If this is
  ## not empty, any returned agency must have at least one of these services,
  ## or one of the specializations in the "specializations" field.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   address: JString
  ##          : The address to use when searching for companies.
  ## If not given, the geo-located address of the request is used.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The view of the `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   companyName: JString
  ##              : Company name to search for.
  section = newJObject()
  var valid_578926 = query.getOrDefault("key")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "key", valid_578926
  var valid_578927 = query.getOrDefault("pp")
  valid_578927 = validateParameter(valid_578927, JBool, required = false,
                                 default = newJBool(true))
  if valid_578927 != nil:
    section.add "pp", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_578930
  var valid_578931 = query.getOrDefault("maxMonthlyBudget.nanos")
  valid_578931 = validateParameter(valid_578931, JInt, required = false, default = nil)
  if valid_578931 != nil:
    section.add "maxMonthlyBudget.nanos", valid_578931
  var valid_578932 = query.getOrDefault("specializations")
  valid_578932 = validateParameter(valid_578932, JArray, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "specializations", valid_578932
  var valid_578933 = query.getOrDefault("minMonthlyBudget.units")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "minMonthlyBudget.units", valid_578933
  var valid_578934 = query.getOrDefault("$.xgafv")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("1"))
  if valid_578934 != nil:
    section.add "$.xgafv", valid_578934
  var valid_578935 = query.getOrDefault("languageCodes")
  valid_578935 = validateParameter(valid_578935, JArray, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "languageCodes", valid_578935
  var valid_578936 = query.getOrDefault("bearer_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "bearer_token", valid_578936
  var valid_578937 = query.getOrDefault("pageSize")
  valid_578937 = validateParameter(valid_578937, JInt, required = false, default = nil)
  if valid_578937 != nil:
    section.add "pageSize", valid_578937
  var valid_578938 = query.getOrDefault("maxMonthlyBudget.units")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "maxMonthlyBudget.units", valid_578938
  var valid_578939 = query.getOrDefault("minMonthlyBudget.nanos")
  valid_578939 = validateParameter(valid_578939, JInt, required = false, default = nil)
  if valid_578939 != nil:
    section.add "minMonthlyBudget.nanos", valid_578939
  var valid_578940 = query.getOrDefault("alt")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("json"))
  if valid_578940 != nil:
    section.add "alt", valid_578940
  var valid_578941 = query.getOrDefault("uploadType")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "uploadType", valid_578941
  var valid_578942 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("industries")
  valid_578944 = validateParameter(valid_578944, JArray, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "industries", valid_578944
  var valid_578945 = query.getOrDefault("orderBy")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "orderBy", valid_578945
  var valid_578946 = query.getOrDefault("pageToken")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "pageToken", valid_578946
  var valid_578947 = query.getOrDefault("requestMetadata.experimentIds")
  valid_578947 = validateParameter(valid_578947, JArray, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "requestMetadata.experimentIds", valid_578947
  var valid_578948 = query.getOrDefault("maxMonthlyBudget.currencyCode")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "maxMonthlyBudget.currencyCode", valid_578948
  var valid_578949 = query.getOrDefault("gpsMotivations")
  valid_578949 = validateParameter(valid_578949, JArray, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "gpsMotivations", valid_578949
  var valid_578950 = query.getOrDefault("websiteUrl")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "websiteUrl", valid_578950
  var valid_578951 = query.getOrDefault("minMonthlyBudget.currencyCode")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "minMonthlyBudget.currencyCode", valid_578951
  var valid_578952 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_578952
  var valid_578953 = query.getOrDefault("callback")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "callback", valid_578953
  var valid_578954 = query.getOrDefault("services")
  valid_578954 = validateParameter(valid_578954, JArray, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "services", valid_578954
  var valid_578955 = query.getOrDefault("requestMetadata.locale")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "requestMetadata.locale", valid_578955
  var valid_578956 = query.getOrDefault("address")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "address", valid_578956
  var valid_578957 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_578957
  var valid_578958 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "requestMetadata.partnersSessionId", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
  var valid_578960 = query.getOrDefault("access_token")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "access_token", valid_578960
  var valid_578961 = query.getOrDefault("upload_protocol")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "upload_protocol", valid_578961
  var valid_578962 = query.getOrDefault("view")
  valid_578962 = validateParameter(valid_578962, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_578962 != nil:
    section.add "view", valid_578962
  var valid_578963 = query.getOrDefault("companyName")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "companyName", valid_578963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578964: Call_PartnersCompaniesList_578923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists companies.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_PartnersCompaniesList_578923; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = "";
          maxMonthlyBudgetNanos: int = 0; specializations: JsonNode = nil;
          minMonthlyBudgetUnits: string = ""; Xgafv: string = "1";
          languageCodes: JsonNode = nil; bearerToken: string = ""; pageSize: int = 0;
          maxMonthlyBudgetUnits: string = ""; minMonthlyBudgetNanos: int = 0;
          alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          industries: JsonNode = nil; orderBy: string = ""; pageToken: string = "";
          requestMetadataExperimentIds: JsonNode = nil;
          maxMonthlyBudgetCurrencyCode: string = ""; gpsMotivations: JsonNode = nil;
          websiteUrl: string = ""; minMonthlyBudgetCurrencyCode: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; services: JsonNode = nil;
          requestMetadataLocale: string = ""; address: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "COMPANY_VIEW_UNSPECIFIED"; companyName: string = ""): Recallable =
  ## partnersCompaniesList
  ## Lists companies.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   maxMonthlyBudgetNanos: int
  ##                        : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   specializations: JArray
  ##                  : List of specializations that the returned agencies should provide. If this
  ## is not empty, any returned agency must have at least one of these
  ## specializations, or one of the services in the "services" field.
  ##   minMonthlyBudgetUnits: string
  ##                        : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCodes: JArray
  ##                : List of language codes that company can support. Only primary language
  ## subtags are accepted as defined by
  ## <a href="https://tools.ietf.org/html/bcp47">BCP 47</a>
  ## (IETF BCP 47, "Tags for Identifying Languages").
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer companies than requested.
  ## If unspecified, server picks an appropriate default.
  ##   maxMonthlyBudgetUnits: string
  ##                        : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   minMonthlyBudgetNanos: int
  ##                        : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   industries: JArray
  ##             : List of industries the company can help with.
  ##   orderBy: string
  ##          : How to order addresses within the returned companies. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListCompaniesResponse.next_page_token`
  ## returned from the previous call to
  ## ListCompanies.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   maxMonthlyBudgetCurrencyCode: string
  ##                               : The 3-letter currency code defined in ISO 4217.
  ##   gpsMotivations: JArray
  ##                 : List of reasons for using Google Partner Search to get companies.
  ##   websiteUrl: string
  ##             : Website URL that will help to find a better matched company.
  ## .
  ##   minMonthlyBudgetCurrencyCode: string
  ##                               : The 3-letter currency code defined in ISO 4217.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   services: JArray
  ##           : List of services that the returned agencies should provide. If this is
  ## not empty, any returned agency must have at least one of these services,
  ## or one of the specializations in the "specializations" field.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   address: string
  ##          : The address to use when searching for companies.
  ## If not given, the geo-located address of the request is used.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The view of the `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   companyName: string
  ##              : Company name to search for.
  var query_578966 = newJObject()
  add(query_578966, "key", newJString(key))
  add(query_578966, "pp", newJBool(pp))
  add(query_578966, "prettyPrint", newJBool(prettyPrint))
  add(query_578966, "oauth_token", newJString(oauthToken))
  add(query_578966, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_578966, "maxMonthlyBudget.nanos", newJInt(maxMonthlyBudgetNanos))
  if specializations != nil:
    query_578966.add "specializations", specializations
  add(query_578966, "minMonthlyBudget.units", newJString(minMonthlyBudgetUnits))
  add(query_578966, "$.xgafv", newJString(Xgafv))
  if languageCodes != nil:
    query_578966.add "languageCodes", languageCodes
  add(query_578966, "bearer_token", newJString(bearerToken))
  add(query_578966, "pageSize", newJInt(pageSize))
  add(query_578966, "maxMonthlyBudget.units", newJString(maxMonthlyBudgetUnits))
  add(query_578966, "minMonthlyBudget.nanos", newJInt(minMonthlyBudgetNanos))
  add(query_578966, "alt", newJString(alt))
  add(query_578966, "uploadType", newJString(uploadType))
  add(query_578966, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_578966, "quotaUser", newJString(quotaUser))
  if industries != nil:
    query_578966.add "industries", industries
  add(query_578966, "orderBy", newJString(orderBy))
  add(query_578966, "pageToken", newJString(pageToken))
  if requestMetadataExperimentIds != nil:
    query_578966.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_578966, "maxMonthlyBudget.currencyCode",
      newJString(maxMonthlyBudgetCurrencyCode))
  if gpsMotivations != nil:
    query_578966.add "gpsMotivations", gpsMotivations
  add(query_578966, "websiteUrl", newJString(websiteUrl))
  add(query_578966, "minMonthlyBudget.currencyCode",
      newJString(minMonthlyBudgetCurrencyCode))
  add(query_578966, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_578966, "callback", newJString(callback))
  if services != nil:
    query_578966.add "services", services
  add(query_578966, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_578966, "address", newJString(address))
  add(query_578966, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_578966, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_578966, "fields", newJString(fields))
  add(query_578966, "access_token", newJString(accessToken))
  add(query_578966, "upload_protocol", newJString(uploadProtocol))
  add(query_578966, "view", newJString(view))
  add(query_578966, "companyName", newJString(companyName))
  result = call_578965.call(nil, query_578966, nil, nil, nil)

var partnersCompaniesList* = Call_PartnersCompaniesList_578923(
    name: "partnersCompaniesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersCompaniesList_578924, base: "/",
    url: url_PartnersCompaniesList_578925, schemes: {Scheme.Https})
type
  Call_PartnersUpdateCompanies_578967 = ref object of OpenApiRestCall_578348
proc url_PartnersUpdateCompanies_578969(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUpdateCompanies_578968(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578970 = query.getOrDefault("key")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "key", valid_578970
  var valid_578971 = query.getOrDefault("pp")
  valid_578971 = validateParameter(valid_578971, JBool, required = false,
                                 default = newJBool(true))
  if valid_578971 != nil:
    section.add "pp", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  var valid_578974 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_578974
  var valid_578975 = query.getOrDefault("$.xgafv")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("1"))
  if valid_578975 != nil:
    section.add "$.xgafv", valid_578975
  var valid_578976 = query.getOrDefault("bearer_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "bearer_token", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("uploadType")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "uploadType", valid_578978
  var valid_578979 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("updateMask")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "updateMask", valid_578981
  var valid_578982 = query.getOrDefault("requestMetadata.experimentIds")
  valid_578982 = validateParameter(valid_578982, JArray, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "requestMetadata.experimentIds", valid_578982
  var valid_578983 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_578983
  var valid_578984 = query.getOrDefault("callback")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "callback", valid_578984
  var valid_578985 = query.getOrDefault("requestMetadata.locale")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "requestMetadata.locale", valid_578985
  var valid_578986 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_578986
  var valid_578987 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "requestMetadata.partnersSessionId", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
  var valid_578989 = query.getOrDefault("access_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "access_token", valid_578989
  var valid_578990 = query.getOrDefault("upload_protocol")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "upload_protocol", valid_578990
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

proc call*(call_578992: Call_PartnersUpdateCompanies_578967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_PartnersUpdateCompanies_578967; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          updateMask: string = ""; requestMetadataExperimentIds: JsonNode = nil;
          body: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersUpdateCompanies
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578994 = newJObject()
  var body_578995 = newJObject()
  add(query_578994, "key", newJString(key))
  add(query_578994, "pp", newJBool(pp))
  add(query_578994, "prettyPrint", newJBool(prettyPrint))
  add(query_578994, "oauth_token", newJString(oauthToken))
  add(query_578994, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_578994, "$.xgafv", newJString(Xgafv))
  add(query_578994, "bearer_token", newJString(bearerToken))
  add(query_578994, "alt", newJString(alt))
  add(query_578994, "uploadType", newJString(uploadType))
  add(query_578994, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_578994, "quotaUser", newJString(quotaUser))
  add(query_578994, "updateMask", newJString(updateMask))
  if requestMetadataExperimentIds != nil:
    query_578994.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_578995 = body
  add(query_578994, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_578994, "callback", newJString(callback))
  add(query_578994, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_578994, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_578994, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_578994, "fields", newJString(fields))
  add(query_578994, "access_token", newJString(accessToken))
  add(query_578994, "upload_protocol", newJString(uploadProtocol))
  result = call_578993.call(nil, query_578994, nil, nil, body_578995)

var partnersUpdateCompanies* = Call_PartnersUpdateCompanies_578967(
    name: "partnersUpdateCompanies", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersUpdateCompanies_578968, base: "/",
    url: url_PartnersUpdateCompanies_578969, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesGet_578996 = ref object of OpenApiRestCall_578348
proc url_PartnersCompaniesGet_578998(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersCompaniesGet_578997(path: JsonNode; query: JsonNode;
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
  var valid_579013 = path.getOrDefault("companyId")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "companyId", valid_579013
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : How to order addresses within the returned company. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   currencyCode: JString
  ##               : If the company's budget is in a different currency code than this one, then
  ## the converted budget is converted to this currency code.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   address: JString
  ##          : The address to use for sorting the company's addresses by proximity.
  ## If not given, the geo-located address of the request is used.
  ## Used when order_by is set.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The view of `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  section = newJObject()
  var valid_579014 = query.getOrDefault("key")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "key", valid_579014
  var valid_579015 = query.getOrDefault("pp")
  valid_579015 = validateParameter(valid_579015, JBool, required = false,
                                 default = newJBool(true))
  if valid_579015 != nil:
    section.add "pp", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579018
  var valid_579019 = query.getOrDefault("$.xgafv")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("1"))
  if valid_579019 != nil:
    section.add "$.xgafv", valid_579019
  var valid_579020 = query.getOrDefault("bearer_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "bearer_token", valid_579020
  var valid_579021 = query.getOrDefault("alt")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("json"))
  if valid_579021 != nil:
    section.add "alt", valid_579021
  var valid_579022 = query.getOrDefault("uploadType")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "uploadType", valid_579022
  var valid_579023 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("orderBy")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "orderBy", valid_579025
  var valid_579026 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579026 = validateParameter(valid_579026, JArray, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "requestMetadata.experimentIds", valid_579026
  var valid_579027 = query.getOrDefault("currencyCode")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "currencyCode", valid_579027
  var valid_579028 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579028
  var valid_579029 = query.getOrDefault("callback")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "callback", valid_579029
  var valid_579030 = query.getOrDefault("requestMetadata.locale")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "requestMetadata.locale", valid_579030
  var valid_579031 = query.getOrDefault("address")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "address", valid_579031
  var valid_579032 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579032
  var valid_579033 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  var valid_579035 = query.getOrDefault("access_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "access_token", valid_579035
  var valid_579036 = query.getOrDefault("upload_protocol")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "upload_protocol", valid_579036
  var valid_579037 = query.getOrDefault("view")
  valid_579037 = validateParameter(valid_579037, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_579037 != nil:
    section.add "view", valid_579037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579038: Call_PartnersCompaniesGet_578996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a company.
  ## 
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_PartnersCompaniesGet_578996; companyId: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          orderBy: string = ""; requestMetadataExperimentIds: JsonNode = nil;
          currencyCode: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          address: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "COMPANY_VIEW_UNSPECIFIED"): Recallable =
  ## partnersCompaniesGet
  ## Gets a company.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   companyId: string (required)
  ##            : The ID of the company to retrieve.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : How to order addresses within the returned company. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   currencyCode: string
  ##               : If the company's budget is in a different currency code than this one, then
  ## the converted budget is converted to this currency code.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   address: string
  ##          : The address to use for sorting the company's addresses by proximity.
  ## If not given, the geo-located address of the request is used.
  ## Used when order_by is set.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The view of `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "pp", newJBool(pp))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579041, "$.xgafv", newJString(Xgafv))
  add(path_579040, "companyId", newJString(companyId))
  add(query_579041, "bearer_token", newJString(bearerToken))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "uploadType", newJString(uploadType))
  add(query_579041, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579041, "quotaUser", newJString(quotaUser))
  add(query_579041, "orderBy", newJString(orderBy))
  if requestMetadataExperimentIds != nil:
    query_579041.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_579041, "currencyCode", newJString(currencyCode))
  add(query_579041, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579041, "callback", newJString(callback))
  add(query_579041, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579041, "address", newJString(address))
  add(query_579041, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579041, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579041, "fields", newJString(fields))
  add(query_579041, "access_token", newJString(accessToken))
  add(query_579041, "upload_protocol", newJString(uploadProtocol))
  add(query_579041, "view", newJString(view))
  result = call_579039.call(path_579040, query_579041, nil, nil, nil)

var partnersCompaniesGet* = Call_PartnersCompaniesGet_578996(
    name: "partnersCompaniesGet", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}",
    validator: validate_PartnersCompaniesGet_578997, base: "/",
    url: url_PartnersCompaniesGet_578998, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesLeadsCreate_579042 = ref object of OpenApiRestCall_578348
proc url_PartnersCompaniesLeadsCreate_579044(protocol: Scheme; host: string;
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

proc validate_PartnersCompaniesLeadsCreate_579043(path: JsonNode; query: JsonNode;
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
  var valid_579045 = path.getOrDefault("companyId")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "companyId", valid_579045
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579046 = query.getOrDefault("key")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "key", valid_579046
  var valid_579047 = query.getOrDefault("pp")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "pp", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("$.xgafv")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("1"))
  if valid_579050 != nil:
    section.add "$.xgafv", valid_579050
  var valid_579051 = query.getOrDefault("bearer_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "bearer_token", valid_579051
  var valid_579052 = query.getOrDefault("alt")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("json"))
  if valid_579052 != nil:
    section.add "alt", valid_579052
  var valid_579053 = query.getOrDefault("uploadType")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "uploadType", valid_579053
  var valid_579054 = query.getOrDefault("quotaUser")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "quotaUser", valid_579054
  var valid_579055 = query.getOrDefault("callback")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "callback", valid_579055
  var valid_579056 = query.getOrDefault("fields")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "fields", valid_579056
  var valid_579057 = query.getOrDefault("access_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "access_token", valid_579057
  var valid_579058 = query.getOrDefault("upload_protocol")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "upload_protocol", valid_579058
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

proc call*(call_579060: Call_PartnersCompaniesLeadsCreate_579042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an advertiser lead for the given company ID.
  ## 
  let valid = call_579060.validator(path, query, header, formData, body)
  let scheme = call_579060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579060.url(scheme.get, call_579060.host, call_579060.base,
                         call_579060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579060, url, valid)

proc call*(call_579061: Call_PartnersCompaniesLeadsCreate_579042;
          companyId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersCompaniesLeadsCreate
  ## Creates an advertiser lead for the given company ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   companyId: string (required)
  ##            : The ID of the company to contact.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579062 = newJObject()
  var query_579063 = newJObject()
  var body_579064 = newJObject()
  add(query_579063, "key", newJString(key))
  add(query_579063, "pp", newJBool(pp))
  add(query_579063, "prettyPrint", newJBool(prettyPrint))
  add(query_579063, "oauth_token", newJString(oauthToken))
  add(query_579063, "$.xgafv", newJString(Xgafv))
  add(path_579062, "companyId", newJString(companyId))
  add(query_579063, "bearer_token", newJString(bearerToken))
  add(query_579063, "alt", newJString(alt))
  add(query_579063, "uploadType", newJString(uploadType))
  add(query_579063, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579064 = body
  add(query_579063, "callback", newJString(callback))
  add(query_579063, "fields", newJString(fields))
  add(query_579063, "access_token", newJString(accessToken))
  add(query_579063, "upload_protocol", newJString(uploadProtocol))
  result = call_579061.call(path_579062, query_579063, nil, nil, body_579064)

var partnersCompaniesLeadsCreate* = Call_PartnersCompaniesLeadsCreate_579042(
    name: "partnersCompaniesLeadsCreate", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}/leads",
    validator: validate_PartnersCompaniesLeadsCreate_579043, base: "/",
    url: url_PartnersCompaniesLeadsCreate_579044, schemes: {Scheme.Https})
type
  Call_PartnersLeadsList_579065 = ref object of OpenApiRestCall_578348
proc url_PartnersLeadsList_579067(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersLeadsList_579066(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer leads than requested.
  ## If unspecified, server picks an appropriate default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : How to order Leads. Currently, only `create_time`
  ## and `create_time desc` are supported
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListLeadsResponse.next_page_token`
  ## returned from the previous call to
  ## ListLeads.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579068 = query.getOrDefault("key")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "key", valid_579068
  var valid_579069 = query.getOrDefault("pp")
  valid_579069 = validateParameter(valid_579069, JBool, required = false,
                                 default = newJBool(true))
  if valid_579069 != nil:
    section.add "pp", valid_579069
  var valid_579070 = query.getOrDefault("prettyPrint")
  valid_579070 = validateParameter(valid_579070, JBool, required = false,
                                 default = newJBool(true))
  if valid_579070 != nil:
    section.add "prettyPrint", valid_579070
  var valid_579071 = query.getOrDefault("oauth_token")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "oauth_token", valid_579071
  var valid_579072 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579072
  var valid_579073 = query.getOrDefault("$.xgafv")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("1"))
  if valid_579073 != nil:
    section.add "$.xgafv", valid_579073
  var valid_579074 = query.getOrDefault("bearer_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "bearer_token", valid_579074
  var valid_579075 = query.getOrDefault("pageSize")
  valid_579075 = validateParameter(valid_579075, JInt, required = false, default = nil)
  if valid_579075 != nil:
    section.add "pageSize", valid_579075
  var valid_579076 = query.getOrDefault("alt")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("json"))
  if valid_579076 != nil:
    section.add "alt", valid_579076
  var valid_579077 = query.getOrDefault("uploadType")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "uploadType", valid_579077
  var valid_579078 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579078
  var valid_579079 = query.getOrDefault("quotaUser")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "quotaUser", valid_579079
  var valid_579080 = query.getOrDefault("orderBy")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "orderBy", valid_579080
  var valid_579081 = query.getOrDefault("pageToken")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "pageToken", valid_579081
  var valid_579082 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579082 = validateParameter(valid_579082, JArray, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "requestMetadata.experimentIds", valid_579082
  var valid_579083 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579083
  var valid_579084 = query.getOrDefault("callback")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "callback", valid_579084
  var valid_579085 = query.getOrDefault("requestMetadata.locale")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "requestMetadata.locale", valid_579085
  var valid_579086 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579086
  var valid_579087 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579087
  var valid_579088 = query.getOrDefault("fields")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "fields", valid_579088
  var valid_579089 = query.getOrDefault("access_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "access_token", valid_579089
  var valid_579090 = query.getOrDefault("upload_protocol")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "upload_protocol", valid_579090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579091: Call_PartnersLeadsList_579065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_579091.validator(path, query, header, formData, body)
  let scheme = call_579091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579091.url(scheme.get, call_579091.host, call_579091.base,
                         call_579091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579091, url, valid)

proc call*(call_579092: Call_PartnersLeadsList_579065; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; requestMetadataUserOverridesUserId: string = "";
          quotaUser: string = ""; orderBy: string = ""; pageToken: string = "";
          requestMetadataExperimentIds: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersLeadsList
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer leads than requested.
  ## If unspecified, server picks an appropriate default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : How to order Leads. Currently, only `create_time`
  ## and `create_time desc` are supported
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListLeadsResponse.next_page_token`
  ## returned from the previous call to
  ## ListLeads.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579093 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "pp", newJBool(pp))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(query_579093, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "bearer_token", newJString(bearerToken))
  add(query_579093, "pageSize", newJInt(pageSize))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579093, "quotaUser", newJString(quotaUser))
  add(query_579093, "orderBy", newJString(orderBy))
  add(query_579093, "pageToken", newJString(pageToken))
  if requestMetadataExperimentIds != nil:
    query_579093.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_579093, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579093, "callback", newJString(callback))
  add(query_579093, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579093, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579093, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579092.call(nil, query_579093, nil, nil, nil)

var partnersLeadsList* = Call_PartnersLeadsList_579065(name: "partnersLeadsList",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersLeadsList_579066, base: "/",
    url: url_PartnersLeadsList_579067, schemes: {Scheme.Https})
type
  Call_PartnersUpdateLeads_579094 = ref object of OpenApiRestCall_578348
proc url_PartnersUpdateLeads_579096(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUpdateLeads_579095(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specified lead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ## Only `state` and `adwords_customer_id` are currently supported.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579097 = query.getOrDefault("key")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "key", valid_579097
  var valid_579098 = query.getOrDefault("pp")
  valid_579098 = validateParameter(valid_579098, JBool, required = false,
                                 default = newJBool(true))
  if valid_579098 != nil:
    section.add "pp", valid_579098
  var valid_579099 = query.getOrDefault("prettyPrint")
  valid_579099 = validateParameter(valid_579099, JBool, required = false,
                                 default = newJBool(true))
  if valid_579099 != nil:
    section.add "prettyPrint", valid_579099
  var valid_579100 = query.getOrDefault("oauth_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "oauth_token", valid_579100
  var valid_579101 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579101
  var valid_579102 = query.getOrDefault("$.xgafv")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("1"))
  if valid_579102 != nil:
    section.add "$.xgafv", valid_579102
  var valid_579103 = query.getOrDefault("bearer_token")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "bearer_token", valid_579103
  var valid_579104 = query.getOrDefault("alt")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("json"))
  if valid_579104 != nil:
    section.add "alt", valid_579104
  var valid_579105 = query.getOrDefault("uploadType")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "uploadType", valid_579105
  var valid_579106 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579106
  var valid_579107 = query.getOrDefault("quotaUser")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "quotaUser", valid_579107
  var valid_579108 = query.getOrDefault("updateMask")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "updateMask", valid_579108
  var valid_579109 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579109 = validateParameter(valid_579109, JArray, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "requestMetadata.experimentIds", valid_579109
  var valid_579110 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579110
  var valid_579111 = query.getOrDefault("callback")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "callback", valid_579111
  var valid_579112 = query.getOrDefault("requestMetadata.locale")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "requestMetadata.locale", valid_579112
  var valid_579113 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579113
  var valid_579114 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  var valid_579116 = query.getOrDefault("access_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "access_token", valid_579116
  var valid_579117 = query.getOrDefault("upload_protocol")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "upload_protocol", valid_579117
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

proc call*(call_579119: Call_PartnersUpdateLeads_579094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified lead.
  ## 
  let valid = call_579119.validator(path, query, header, formData, body)
  let scheme = call_579119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579119.url(scheme.get, call_579119.host, call_579119.base,
                         call_579119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579119, url, valid)

proc call*(call_579120: Call_PartnersUpdateLeads_579094; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          updateMask: string = ""; requestMetadataExperimentIds: JsonNode = nil;
          body: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersUpdateLeads
  ## Updates the specified lead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ## Only `state` and `adwords_customer_id` are currently supported.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579121 = newJObject()
  var body_579122 = newJObject()
  add(query_579121, "key", newJString(key))
  add(query_579121, "pp", newJBool(pp))
  add(query_579121, "prettyPrint", newJBool(prettyPrint))
  add(query_579121, "oauth_token", newJString(oauthToken))
  add(query_579121, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579121, "$.xgafv", newJString(Xgafv))
  add(query_579121, "bearer_token", newJString(bearerToken))
  add(query_579121, "alt", newJString(alt))
  add(query_579121, "uploadType", newJString(uploadType))
  add(query_579121, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579121, "quotaUser", newJString(quotaUser))
  add(query_579121, "updateMask", newJString(updateMask))
  if requestMetadataExperimentIds != nil:
    query_579121.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_579122 = body
  add(query_579121, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579121, "callback", newJString(callback))
  add(query_579121, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579121, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579121, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579121, "fields", newJString(fields))
  add(query_579121, "access_token", newJString(accessToken))
  add(query_579121, "upload_protocol", newJString(uploadProtocol))
  result = call_579120.call(nil, query_579121, nil, nil, body_579122)

var partnersUpdateLeads* = Call_PartnersUpdateLeads_579094(
    name: "partnersUpdateLeads", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersUpdateLeads_579095, base: "/",
    url: url_PartnersUpdateLeads_579096, schemes: {Scheme.Https})
type
  Call_PartnersOffersList_579123 = ref object of OpenApiRestCall_578348
proc url_PartnersOffersList_579125(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersOffersList_579124(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the Offers available for the current user
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579126 = query.getOrDefault("key")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "key", valid_579126
  var valid_579127 = query.getOrDefault("pp")
  valid_579127 = validateParameter(valid_579127, JBool, required = false,
                                 default = newJBool(true))
  if valid_579127 != nil:
    section.add "pp", valid_579127
  var valid_579128 = query.getOrDefault("prettyPrint")
  valid_579128 = validateParameter(valid_579128, JBool, required = false,
                                 default = newJBool(true))
  if valid_579128 != nil:
    section.add "prettyPrint", valid_579128
  var valid_579129 = query.getOrDefault("oauth_token")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "oauth_token", valid_579129
  var valid_579130 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579130
  var valid_579131 = query.getOrDefault("$.xgafv")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = newJString("1"))
  if valid_579131 != nil:
    section.add "$.xgafv", valid_579131
  var valid_579132 = query.getOrDefault("bearer_token")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "bearer_token", valid_579132
  var valid_579133 = query.getOrDefault("alt")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("json"))
  if valid_579133 != nil:
    section.add "alt", valid_579133
  var valid_579134 = query.getOrDefault("uploadType")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "uploadType", valid_579134
  var valid_579135 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579135
  var valid_579136 = query.getOrDefault("quotaUser")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "quotaUser", valid_579136
  var valid_579137 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579137 = validateParameter(valid_579137, JArray, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "requestMetadata.experimentIds", valid_579137
  var valid_579138 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579138
  var valid_579139 = query.getOrDefault("callback")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "callback", valid_579139
  var valid_579140 = query.getOrDefault("requestMetadata.locale")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "requestMetadata.locale", valid_579140
  var valid_579141 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579141
  var valid_579142 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579142
  var valid_579143 = query.getOrDefault("fields")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "fields", valid_579143
  var valid_579144 = query.getOrDefault("access_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "access_token", valid_579144
  var valid_579145 = query.getOrDefault("upload_protocol")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "upload_protocol", valid_579145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579146: Call_PartnersOffersList_579123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Offers available for the current user
  ## 
  let valid = call_579146.validator(path, query, header, formData, body)
  let scheme = call_579146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579146.url(scheme.get, call_579146.host, call_579146.base,
                         call_579146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579146, url, valid)

proc call*(call_579147: Call_PartnersOffersList_579123; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          requestMetadataExperimentIds: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersOffersList
  ## Lists the Offers available for the current user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579148 = newJObject()
  add(query_579148, "key", newJString(key))
  add(query_579148, "pp", newJBool(pp))
  add(query_579148, "prettyPrint", newJBool(prettyPrint))
  add(query_579148, "oauth_token", newJString(oauthToken))
  add(query_579148, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579148, "$.xgafv", newJString(Xgafv))
  add(query_579148, "bearer_token", newJString(bearerToken))
  add(query_579148, "alt", newJString(alt))
  add(query_579148, "uploadType", newJString(uploadType))
  add(query_579148, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579148, "quotaUser", newJString(quotaUser))
  if requestMetadataExperimentIds != nil:
    query_579148.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_579148, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579148, "callback", newJString(callback))
  add(query_579148, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579148, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579148, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579148, "fields", newJString(fields))
  add(query_579148, "access_token", newJString(accessToken))
  add(query_579148, "upload_protocol", newJString(uploadProtocol))
  result = call_579147.call(nil, query_579148, nil, nil, nil)

var partnersOffersList* = Call_PartnersOffersList_579123(
    name: "partnersOffersList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers",
    validator: validate_PartnersOffersList_579124, base: "/",
    url: url_PartnersOffersList_579125, schemes: {Scheme.Https})
type
  Call_PartnersOffersHistoryList_579149 = ref object of OpenApiRestCall_578348
proc url_PartnersOffersHistoryList_579151(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersOffersHistoryList_579150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Historical Offers for the current user (or user's entire company)
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Maximum number of rows to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Comma-separated list of fields to order by, e.g.: "foo,bar,baz".
  ## Use "foo desc" to sort descending.
  ## List of valid field names is: name, offer_code, expiration_time, status,
  ##     last_modified_time, sender_name, creation_time, country_code,
  ##     offer_type.
  ##   pageToken: JString
  ##            : Token to retrieve a specific page.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   entireCompany: JBool
  ##                : if true, show history for the entire company.  Requires user to be admin.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579152 = query.getOrDefault("key")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "key", valid_579152
  var valid_579153 = query.getOrDefault("pp")
  valid_579153 = validateParameter(valid_579153, JBool, required = false,
                                 default = newJBool(true))
  if valid_579153 != nil:
    section.add "pp", valid_579153
  var valid_579154 = query.getOrDefault("prettyPrint")
  valid_579154 = validateParameter(valid_579154, JBool, required = false,
                                 default = newJBool(true))
  if valid_579154 != nil:
    section.add "prettyPrint", valid_579154
  var valid_579155 = query.getOrDefault("oauth_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "oauth_token", valid_579155
  var valid_579156 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579156
  var valid_579157 = query.getOrDefault("$.xgafv")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = newJString("1"))
  if valid_579157 != nil:
    section.add "$.xgafv", valid_579157
  var valid_579158 = query.getOrDefault("bearer_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "bearer_token", valid_579158
  var valid_579159 = query.getOrDefault("pageSize")
  valid_579159 = validateParameter(valid_579159, JInt, required = false, default = nil)
  if valid_579159 != nil:
    section.add "pageSize", valid_579159
  var valid_579160 = query.getOrDefault("alt")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("json"))
  if valid_579160 != nil:
    section.add "alt", valid_579160
  var valid_579161 = query.getOrDefault("uploadType")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "uploadType", valid_579161
  var valid_579162 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("orderBy")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "orderBy", valid_579164
  var valid_579165 = query.getOrDefault("pageToken")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "pageToken", valid_579165
  var valid_579166 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579166 = validateParameter(valid_579166, JArray, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "requestMetadata.experimentIds", valid_579166
  var valid_579167 = query.getOrDefault("entireCompany")
  valid_579167 = validateParameter(valid_579167, JBool, required = false, default = nil)
  if valid_579167 != nil:
    section.add "entireCompany", valid_579167
  var valid_579168 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579168
  var valid_579169 = query.getOrDefault("callback")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "callback", valid_579169
  var valid_579170 = query.getOrDefault("requestMetadata.locale")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "requestMetadata.locale", valid_579170
  var valid_579171 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579171
  var valid_579172 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579172
  var valid_579173 = query.getOrDefault("fields")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "fields", valid_579173
  var valid_579174 = query.getOrDefault("access_token")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "access_token", valid_579174
  var valid_579175 = query.getOrDefault("upload_protocol")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "upload_protocol", valid_579175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579176: Call_PartnersOffersHistoryList_579149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Historical Offers for the current user (or user's entire company)
  ## 
  let valid = call_579176.validator(path, query, header, formData, body)
  let scheme = call_579176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579176.url(scheme.get, call_579176.host, call_579176.base,
                         call_579176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579176, url, valid)

proc call*(call_579177: Call_PartnersOffersHistoryList_579149; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; requestMetadataUserOverridesUserId: string = "";
          quotaUser: string = ""; orderBy: string = ""; pageToken: string = "";
          requestMetadataExperimentIds: JsonNode = nil; entireCompany: bool = false;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersOffersHistoryList
  ## Lists the Historical Offers for the current user (or user's entire company)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Maximum number of rows to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Comma-separated list of fields to order by, e.g.: "foo,bar,baz".
  ## Use "foo desc" to sort descending.
  ## List of valid field names is: name, offer_code, expiration_time, status,
  ##     last_modified_time, sender_name, creation_time, country_code,
  ##     offer_type.
  ##   pageToken: string
  ##            : Token to retrieve a specific page.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   entireCompany: bool
  ##                : if true, show history for the entire company.  Requires user to be admin.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579178 = newJObject()
  add(query_579178, "key", newJString(key))
  add(query_579178, "pp", newJBool(pp))
  add(query_579178, "prettyPrint", newJBool(prettyPrint))
  add(query_579178, "oauth_token", newJString(oauthToken))
  add(query_579178, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579178, "$.xgafv", newJString(Xgafv))
  add(query_579178, "bearer_token", newJString(bearerToken))
  add(query_579178, "pageSize", newJInt(pageSize))
  add(query_579178, "alt", newJString(alt))
  add(query_579178, "uploadType", newJString(uploadType))
  add(query_579178, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579178, "quotaUser", newJString(quotaUser))
  add(query_579178, "orderBy", newJString(orderBy))
  add(query_579178, "pageToken", newJString(pageToken))
  if requestMetadataExperimentIds != nil:
    query_579178.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_579178, "entireCompany", newJBool(entireCompany))
  add(query_579178, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579178, "callback", newJString(callback))
  add(query_579178, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579178, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579178, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579178, "fields", newJString(fields))
  add(query_579178, "access_token", newJString(accessToken))
  add(query_579178, "upload_protocol", newJString(uploadProtocol))
  result = call_579177.call(nil, query_579178, nil, nil, nil)

var partnersOffersHistoryList* = Call_PartnersOffersHistoryList_579149(
    name: "partnersOffersHistoryList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers/history",
    validator: validate_PartnersOffersHistoryList_579150, base: "/",
    url: url_PartnersOffersHistoryList_579151, schemes: {Scheme.Https})
type
  Call_PartnersGetPartnersstatus_579179 = ref object of OpenApiRestCall_578348
proc url_PartnersGetPartnersstatus_579181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersGetPartnersstatus_579180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579182 = query.getOrDefault("key")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "key", valid_579182
  var valid_579183 = query.getOrDefault("pp")
  valid_579183 = validateParameter(valid_579183, JBool, required = false,
                                 default = newJBool(true))
  if valid_579183 != nil:
    section.add "pp", valid_579183
  var valid_579184 = query.getOrDefault("prettyPrint")
  valid_579184 = validateParameter(valid_579184, JBool, required = false,
                                 default = newJBool(true))
  if valid_579184 != nil:
    section.add "prettyPrint", valid_579184
  var valid_579185 = query.getOrDefault("oauth_token")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "oauth_token", valid_579185
  var valid_579186 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579186
  var valid_579187 = query.getOrDefault("$.xgafv")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = newJString("1"))
  if valid_579187 != nil:
    section.add "$.xgafv", valid_579187
  var valid_579188 = query.getOrDefault("bearer_token")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "bearer_token", valid_579188
  var valid_579189 = query.getOrDefault("alt")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = newJString("json"))
  if valid_579189 != nil:
    section.add "alt", valid_579189
  var valid_579190 = query.getOrDefault("uploadType")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "uploadType", valid_579190
  var valid_579191 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579191
  var valid_579192 = query.getOrDefault("quotaUser")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "quotaUser", valid_579192
  var valid_579193 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579193 = validateParameter(valid_579193, JArray, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "requestMetadata.experimentIds", valid_579193
  var valid_579194 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579194
  var valid_579195 = query.getOrDefault("callback")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "callback", valid_579195
  var valid_579196 = query.getOrDefault("requestMetadata.locale")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "requestMetadata.locale", valid_579196
  var valid_579197 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579197
  var valid_579198 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579198
  var valid_579199 = query.getOrDefault("fields")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "fields", valid_579199
  var valid_579200 = query.getOrDefault("access_token")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "access_token", valid_579200
  var valid_579201 = query.getOrDefault("upload_protocol")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "upload_protocol", valid_579201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579202: Call_PartnersGetPartnersstatus_579179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ## 
  let valid = call_579202.validator(path, query, header, formData, body)
  let scheme = call_579202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579202.url(scheme.get, call_579202.host, call_579202.base,
                         call_579202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579202, url, valid)

proc call*(call_579203: Call_PartnersGetPartnersstatus_579179; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          requestMetadataExperimentIds: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersGetPartnersstatus
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579204 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "pp", newJBool(pp))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579204, "$.xgafv", newJString(Xgafv))
  add(query_579204, "bearer_token", newJString(bearerToken))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "uploadType", newJString(uploadType))
  add(query_579204, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579204, "quotaUser", newJString(quotaUser))
  if requestMetadataExperimentIds != nil:
    query_579204.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_579204, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579204, "callback", newJString(callback))
  add(query_579204, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579204, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579204, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579204, "fields", newJString(fields))
  add(query_579204, "access_token", newJString(accessToken))
  add(query_579204, "upload_protocol", newJString(uploadProtocol))
  result = call_579203.call(nil, query_579204, nil, nil, nil)

var partnersGetPartnersstatus* = Call_PartnersGetPartnersstatus_579179(
    name: "partnersGetPartnersstatus", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/partnersstatus",
    validator: validate_PartnersGetPartnersstatus_579180, base: "/",
    url: url_PartnersGetPartnersstatus_579181, schemes: {Scheme.Https})
type
  Call_PartnersUserEventsLog_579205 = ref object of OpenApiRestCall_578348
proc url_PartnersUserEventsLog_579207(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUserEventsLog_579206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Logs a user event.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579208 = query.getOrDefault("key")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "key", valid_579208
  var valid_579209 = query.getOrDefault("pp")
  valid_579209 = validateParameter(valid_579209, JBool, required = false,
                                 default = newJBool(true))
  if valid_579209 != nil:
    section.add "pp", valid_579209
  var valid_579210 = query.getOrDefault("prettyPrint")
  valid_579210 = validateParameter(valid_579210, JBool, required = false,
                                 default = newJBool(true))
  if valid_579210 != nil:
    section.add "prettyPrint", valid_579210
  var valid_579211 = query.getOrDefault("oauth_token")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "oauth_token", valid_579211
  var valid_579212 = query.getOrDefault("$.xgafv")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("1"))
  if valid_579212 != nil:
    section.add "$.xgafv", valid_579212
  var valid_579213 = query.getOrDefault("bearer_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "bearer_token", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("uploadType")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "uploadType", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("callback")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "callback", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("access_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "access_token", valid_579219
  var valid_579220 = query.getOrDefault("upload_protocol")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "upload_protocol", valid_579220
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

proc call*(call_579222: Call_PartnersUserEventsLog_579205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a user event.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_PartnersUserEventsLog_579205; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## partnersUserEventsLog
  ## Logs a user event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579224 = newJObject()
  var body_579225 = newJObject()
  add(query_579224, "key", newJString(key))
  add(query_579224, "pp", newJBool(pp))
  add(query_579224, "prettyPrint", newJBool(prettyPrint))
  add(query_579224, "oauth_token", newJString(oauthToken))
  add(query_579224, "$.xgafv", newJString(Xgafv))
  add(query_579224, "bearer_token", newJString(bearerToken))
  add(query_579224, "alt", newJString(alt))
  add(query_579224, "uploadType", newJString(uploadType))
  add(query_579224, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579225 = body
  add(query_579224, "callback", newJString(callback))
  add(query_579224, "fields", newJString(fields))
  add(query_579224, "access_token", newJString(accessToken))
  add(query_579224, "upload_protocol", newJString(uploadProtocol))
  result = call_579223.call(nil, query_579224, nil, nil, body_579225)

var partnersUserEventsLog* = Call_PartnersUserEventsLog_579205(
    name: "partnersUserEventsLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/userEvents:log",
    validator: validate_PartnersUserEventsLog_579206, base: "/",
    url: url_PartnersUserEventsLog_579207, schemes: {Scheme.Https})
type
  Call_PartnersUserStatesList_579226 = ref object of OpenApiRestCall_578348
proc url_PartnersUserStatesList_579228(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUserStatesList_579227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists states for current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579229 = query.getOrDefault("key")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "key", valid_579229
  var valid_579230 = query.getOrDefault("pp")
  valid_579230 = validateParameter(valid_579230, JBool, required = false,
                                 default = newJBool(true))
  if valid_579230 != nil:
    section.add "pp", valid_579230
  var valid_579231 = query.getOrDefault("prettyPrint")
  valid_579231 = validateParameter(valid_579231, JBool, required = false,
                                 default = newJBool(true))
  if valid_579231 != nil:
    section.add "prettyPrint", valid_579231
  var valid_579232 = query.getOrDefault("oauth_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "oauth_token", valid_579232
  var valid_579233 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579233
  var valid_579234 = query.getOrDefault("$.xgafv")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("1"))
  if valid_579234 != nil:
    section.add "$.xgafv", valid_579234
  var valid_579235 = query.getOrDefault("bearer_token")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "bearer_token", valid_579235
  var valid_579236 = query.getOrDefault("alt")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = newJString("json"))
  if valid_579236 != nil:
    section.add "alt", valid_579236
  var valid_579237 = query.getOrDefault("uploadType")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "uploadType", valid_579237
  var valid_579238 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579238
  var valid_579239 = query.getOrDefault("quotaUser")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "quotaUser", valid_579239
  var valid_579240 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579240 = validateParameter(valid_579240, JArray, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "requestMetadata.experimentIds", valid_579240
  var valid_579241 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579241
  var valid_579242 = query.getOrDefault("callback")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "callback", valid_579242
  var valid_579243 = query.getOrDefault("requestMetadata.locale")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "requestMetadata.locale", valid_579243
  var valid_579244 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579244
  var valid_579245 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579245
  var valid_579246 = query.getOrDefault("fields")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "fields", valid_579246
  var valid_579247 = query.getOrDefault("access_token")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "access_token", valid_579247
  var valid_579248 = query.getOrDefault("upload_protocol")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "upload_protocol", valid_579248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579249: Call_PartnersUserStatesList_579226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists states for current user.
  ## 
  let valid = call_579249.validator(path, query, header, formData, body)
  let scheme = call_579249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579249.url(scheme.get, call_579249.host, call_579249.base,
                         call_579249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579249, url, valid)

proc call*(call_579250: Call_PartnersUserStatesList_579226; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          requestMetadataExperimentIds: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersUserStatesList
  ## Lists states for current user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579251 = newJObject()
  add(query_579251, "key", newJString(key))
  add(query_579251, "pp", newJBool(pp))
  add(query_579251, "prettyPrint", newJBool(prettyPrint))
  add(query_579251, "oauth_token", newJString(oauthToken))
  add(query_579251, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579251, "$.xgafv", newJString(Xgafv))
  add(query_579251, "bearer_token", newJString(bearerToken))
  add(query_579251, "alt", newJString(alt))
  add(query_579251, "uploadType", newJString(uploadType))
  add(query_579251, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579251, "quotaUser", newJString(quotaUser))
  if requestMetadataExperimentIds != nil:
    query_579251.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_579251, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579251, "callback", newJString(callback))
  add(query_579251, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579251, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579251, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579251, "fields", newJString(fields))
  add(query_579251, "access_token", newJString(accessToken))
  add(query_579251, "upload_protocol", newJString(uploadProtocol))
  result = call_579250.call(nil, query_579251, nil, nil, nil)

var partnersUserStatesList* = Call_PartnersUserStatesList_579226(
    name: "partnersUserStatesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/userStates",
    validator: validate_PartnersUserStatesList_579227, base: "/",
    url: url_PartnersUserStatesList_579228, schemes: {Scheme.Https})
type
  Call_PartnersUsersUpdateProfile_579252 = ref object of OpenApiRestCall_578348
proc url_PartnersUsersUpdateProfile_579254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUsersUpdateProfile_579253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579255 = query.getOrDefault("key")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "key", valid_579255
  var valid_579256 = query.getOrDefault("pp")
  valid_579256 = validateParameter(valid_579256, JBool, required = false,
                                 default = newJBool(true))
  if valid_579256 != nil:
    section.add "pp", valid_579256
  var valid_579257 = query.getOrDefault("prettyPrint")
  valid_579257 = validateParameter(valid_579257, JBool, required = false,
                                 default = newJBool(true))
  if valid_579257 != nil:
    section.add "prettyPrint", valid_579257
  var valid_579258 = query.getOrDefault("oauth_token")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "oauth_token", valid_579258
  var valid_579259 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579259
  var valid_579260 = query.getOrDefault("$.xgafv")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = newJString("1"))
  if valid_579260 != nil:
    section.add "$.xgafv", valid_579260
  var valid_579261 = query.getOrDefault("bearer_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "bearer_token", valid_579261
  var valid_579262 = query.getOrDefault("alt")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = newJString("json"))
  if valid_579262 != nil:
    section.add "alt", valid_579262
  var valid_579263 = query.getOrDefault("uploadType")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "uploadType", valid_579263
  var valid_579264 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579264
  var valid_579265 = query.getOrDefault("quotaUser")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "quotaUser", valid_579265
  var valid_579266 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579266 = validateParameter(valid_579266, JArray, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "requestMetadata.experimentIds", valid_579266
  var valid_579267 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579267
  var valid_579268 = query.getOrDefault("callback")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "callback", valid_579268
  var valid_579269 = query.getOrDefault("requestMetadata.locale")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "requestMetadata.locale", valid_579269
  var valid_579270 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579270
  var valid_579271 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579271
  var valid_579272 = query.getOrDefault("fields")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "fields", valid_579272
  var valid_579273 = query.getOrDefault("access_token")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "access_token", valid_579273
  var valid_579274 = query.getOrDefault("upload_protocol")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "upload_protocol", valid_579274
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

proc call*(call_579276: Call_PartnersUsersUpdateProfile_579252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ## 
  let valid = call_579276.validator(path, query, header, formData, body)
  let scheme = call_579276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579276.url(scheme.get, call_579276.host, call_579276.base,
                         call_579276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579276, url, valid)

proc call*(call_579277: Call_PartnersUsersUpdateProfile_579252; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersUsersUpdateProfile
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579278 = newJObject()
  var body_579279 = newJObject()
  add(query_579278, "key", newJString(key))
  add(query_579278, "pp", newJBool(pp))
  add(query_579278, "prettyPrint", newJBool(prettyPrint))
  add(query_579278, "oauth_token", newJString(oauthToken))
  add(query_579278, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579278, "$.xgafv", newJString(Xgafv))
  add(query_579278, "bearer_token", newJString(bearerToken))
  add(query_579278, "alt", newJString(alt))
  add(query_579278, "uploadType", newJString(uploadType))
  add(query_579278, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579278, "quotaUser", newJString(quotaUser))
  if requestMetadataExperimentIds != nil:
    query_579278.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_579279 = body
  add(query_579278, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579278, "callback", newJString(callback))
  add(query_579278, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579278, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579278, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579278, "fields", newJString(fields))
  add(query_579278, "access_token", newJString(accessToken))
  add(query_579278, "upload_protocol", newJString(uploadProtocol))
  result = call_579277.call(nil, query_579278, nil, nil, body_579279)

var partnersUsersUpdateProfile* = Call_PartnersUsersUpdateProfile_579252(
    name: "partnersUsersUpdateProfile", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/users/profile",
    validator: validate_PartnersUsersUpdateProfile_579253, base: "/",
    url: url_PartnersUsersUpdateProfile_579254, schemes: {Scheme.Https})
type
  Call_PartnersUsersGet_579280 = ref object of OpenApiRestCall_578348
proc url_PartnersUsersGet_579282(protocol: Scheme; host: string; base: string;
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

proc validate_PartnersUsersGet_579281(path: JsonNode; query: JsonNode;
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
  var valid_579283 = path.getOrDefault("userId")
  valid_579283 = validateParameter(valid_579283, JString, required = true,
                                 default = nil)
  if valid_579283 != nil:
    section.add "userId", valid_579283
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   userView: JString
  ##           : Specifies what parts of the user information to return.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579284 = query.getOrDefault("key")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "key", valid_579284
  var valid_579285 = query.getOrDefault("pp")
  valid_579285 = validateParameter(valid_579285, JBool, required = false,
                                 default = newJBool(true))
  if valid_579285 != nil:
    section.add "pp", valid_579285
  var valid_579286 = query.getOrDefault("prettyPrint")
  valid_579286 = validateParameter(valid_579286, JBool, required = false,
                                 default = newJBool(true))
  if valid_579286 != nil:
    section.add "prettyPrint", valid_579286
  var valid_579287 = query.getOrDefault("oauth_token")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "oauth_token", valid_579287
  var valid_579288 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579288
  var valid_579289 = query.getOrDefault("$.xgafv")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = newJString("1"))
  if valid_579289 != nil:
    section.add "$.xgafv", valid_579289
  var valid_579290 = query.getOrDefault("bearer_token")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "bearer_token", valid_579290
  var valid_579291 = query.getOrDefault("alt")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = newJString("json"))
  if valid_579291 != nil:
    section.add "alt", valid_579291
  var valid_579292 = query.getOrDefault("uploadType")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "uploadType", valid_579292
  var valid_579293 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579293
  var valid_579294 = query.getOrDefault("quotaUser")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "quotaUser", valid_579294
  var valid_579295 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579295 = validateParameter(valid_579295, JArray, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "requestMetadata.experimentIds", valid_579295
  var valid_579296 = query.getOrDefault("userView")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579296 != nil:
    section.add "userView", valid_579296
  var valid_579297 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579297
  var valid_579298 = query.getOrDefault("callback")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "callback", valid_579298
  var valid_579299 = query.getOrDefault("requestMetadata.locale")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "requestMetadata.locale", valid_579299
  var valid_579300 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579300
  var valid_579301 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579301
  var valid_579302 = query.getOrDefault("fields")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "fields", valid_579302
  var valid_579303 = query.getOrDefault("access_token")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "access_token", valid_579303
  var valid_579304 = query.getOrDefault("upload_protocol")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "upload_protocol", valid_579304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579305: Call_PartnersUsersGet_579280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a user.
  ## 
  let valid = call_579305.validator(path, query, header, formData, body)
  let scheme = call_579305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579305.url(scheme.get, call_579305.host, call_579305.base,
                         call_579305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579305, url, valid)

proc call*(call_579306: Call_PartnersUsersGet_579280; userId: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          requestMetadataExperimentIds: JsonNode = nil; userView: string = "BASIC";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersUsersGet
  ## Gets a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   userId: string (required)
  ##         : Identifier of the user. Can be set to <code>me</code> to mean the currently
  ## authenticated user.
  ##   userView: string
  ##           : Specifies what parts of the user information to return.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579307 = newJObject()
  var query_579308 = newJObject()
  add(query_579308, "key", newJString(key))
  add(query_579308, "pp", newJBool(pp))
  add(query_579308, "prettyPrint", newJBool(prettyPrint))
  add(query_579308, "oauth_token", newJString(oauthToken))
  add(query_579308, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579308, "$.xgafv", newJString(Xgafv))
  add(query_579308, "bearer_token", newJString(bearerToken))
  add(query_579308, "alt", newJString(alt))
  add(query_579308, "uploadType", newJString(uploadType))
  add(query_579308, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579308, "quotaUser", newJString(quotaUser))
  if requestMetadataExperimentIds != nil:
    query_579308.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(path_579307, "userId", newJString(userId))
  add(query_579308, "userView", newJString(userView))
  add(query_579308, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579308, "callback", newJString(callback))
  add(query_579308, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579308, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579308, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579308, "fields", newJString(fields))
  add(query_579308, "access_token", newJString(accessToken))
  add(query_579308, "upload_protocol", newJString(uploadProtocol))
  result = call_579306.call(path_579307, query_579308, nil, nil, nil)

var partnersUsersGet* = Call_PartnersUsersGet_579280(name: "partnersUsersGet",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com",
    route: "/v2/users/{userId}", validator: validate_PartnersUsersGet_579281,
    base: "/", url: url_PartnersUsersGet_579282, schemes: {Scheme.Https})
type
  Call_PartnersUsersCreateCompanyRelation_579309 = ref object of OpenApiRestCall_578348
proc url_PartnersUsersCreateCompanyRelation_579311(protocol: Scheme; host: string;
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

proc validate_PartnersUsersCreateCompanyRelation_579310(path: JsonNode;
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
  var valid_579312 = path.getOrDefault("userId")
  valid_579312 = validateParameter(valid_579312, JString, required = true,
                                 default = nil)
  if valid_579312 != nil:
    section.add "userId", valid_579312
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579313 = query.getOrDefault("key")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "key", valid_579313
  var valid_579314 = query.getOrDefault("pp")
  valid_579314 = validateParameter(valid_579314, JBool, required = false,
                                 default = newJBool(true))
  if valid_579314 != nil:
    section.add "pp", valid_579314
  var valid_579315 = query.getOrDefault("prettyPrint")
  valid_579315 = validateParameter(valid_579315, JBool, required = false,
                                 default = newJBool(true))
  if valid_579315 != nil:
    section.add "prettyPrint", valid_579315
  var valid_579316 = query.getOrDefault("oauth_token")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "oauth_token", valid_579316
  var valid_579317 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579317
  var valid_579318 = query.getOrDefault("$.xgafv")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("1"))
  if valid_579318 != nil:
    section.add "$.xgafv", valid_579318
  var valid_579319 = query.getOrDefault("bearer_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "bearer_token", valid_579319
  var valid_579320 = query.getOrDefault("alt")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("json"))
  if valid_579320 != nil:
    section.add "alt", valid_579320
  var valid_579321 = query.getOrDefault("uploadType")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "uploadType", valid_579321
  var valid_579322 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579322
  var valid_579323 = query.getOrDefault("quotaUser")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "quotaUser", valid_579323
  var valid_579324 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579324 = validateParameter(valid_579324, JArray, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "requestMetadata.experimentIds", valid_579324
  var valid_579325 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579325
  var valid_579326 = query.getOrDefault("callback")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "callback", valid_579326
  var valid_579327 = query.getOrDefault("requestMetadata.locale")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "requestMetadata.locale", valid_579327
  var valid_579328 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579328
  var valid_579329 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579329
  var valid_579330 = query.getOrDefault("fields")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "fields", valid_579330
  var valid_579331 = query.getOrDefault("access_token")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "access_token", valid_579331
  var valid_579332 = query.getOrDefault("upload_protocol")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "upload_protocol", valid_579332
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

proc call*(call_579334: Call_PartnersUsersCreateCompanyRelation_579309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's company relation. Affiliates the user to a company.
  ## 
  let valid = call_579334.validator(path, query, header, formData, body)
  let scheme = call_579334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579334.url(scheme.get, call_579334.host, call_579334.base,
                         call_579334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579334, url, valid)

proc call*(call_579335: Call_PartnersUsersCreateCompanyRelation_579309;
          userId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersUsersCreateCompanyRelation
  ## Creates a user's company relation. Affiliates the user to a company.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   userId: string (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  ##   body: JObject
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579336 = newJObject()
  var query_579337 = newJObject()
  var body_579338 = newJObject()
  add(query_579337, "key", newJString(key))
  add(query_579337, "pp", newJBool(pp))
  add(query_579337, "prettyPrint", newJBool(prettyPrint))
  add(query_579337, "oauth_token", newJString(oauthToken))
  add(query_579337, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579337, "$.xgafv", newJString(Xgafv))
  add(query_579337, "bearer_token", newJString(bearerToken))
  add(query_579337, "alt", newJString(alt))
  add(query_579337, "uploadType", newJString(uploadType))
  add(query_579337, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579337, "quotaUser", newJString(quotaUser))
  if requestMetadataExperimentIds != nil:
    query_579337.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(path_579336, "userId", newJString(userId))
  if body != nil:
    body_579338 = body
  add(query_579337, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579337, "callback", newJString(callback))
  add(query_579337, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579337, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579337, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579337, "fields", newJString(fields))
  add(query_579337, "access_token", newJString(accessToken))
  add(query_579337, "upload_protocol", newJString(uploadProtocol))
  result = call_579335.call(path_579336, query_579337, nil, nil, body_579338)

var partnersUsersCreateCompanyRelation* = Call_PartnersUsersCreateCompanyRelation_579309(
    name: "partnersUsersCreateCompanyRelation", meth: HttpMethod.HttpPut,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersCreateCompanyRelation_579310, base: "/",
    url: url_PartnersUsersCreateCompanyRelation_579311, schemes: {Scheme.Https})
type
  Call_PartnersUsersDeleteCompanyRelation_579339 = ref object of OpenApiRestCall_578348
proc url_PartnersUsersDeleteCompanyRelation_579341(protocol: Scheme; host: string;
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

proc validate_PartnersUsersDeleteCompanyRelation_579340(path: JsonNode;
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
  var valid_579342 = path.getOrDefault("userId")
  valid_579342 = validateParameter(valid_579342, JString, required = true,
                                 default = nil)
  if valid_579342 != nil:
    section.add "userId", valid_579342
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: JString
  ##           : JSONP
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579343 = query.getOrDefault("key")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "key", valid_579343
  var valid_579344 = query.getOrDefault("pp")
  valid_579344 = validateParameter(valid_579344, JBool, required = false,
                                 default = newJBool(true))
  if valid_579344 != nil:
    section.add "pp", valid_579344
  var valid_579345 = query.getOrDefault("prettyPrint")
  valid_579345 = validateParameter(valid_579345, JBool, required = false,
                                 default = newJBool(true))
  if valid_579345 != nil:
    section.add "prettyPrint", valid_579345
  var valid_579346 = query.getOrDefault("oauth_token")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "oauth_token", valid_579346
  var valid_579347 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_579347
  var valid_579348 = query.getOrDefault("$.xgafv")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = newJString("1"))
  if valid_579348 != nil:
    section.add "$.xgafv", valid_579348
  var valid_579349 = query.getOrDefault("bearer_token")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "bearer_token", valid_579349
  var valid_579350 = query.getOrDefault("alt")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = newJString("json"))
  if valid_579350 != nil:
    section.add "alt", valid_579350
  var valid_579351 = query.getOrDefault("uploadType")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "uploadType", valid_579351
  var valid_579352 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_579352
  var valid_579353 = query.getOrDefault("quotaUser")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "quotaUser", valid_579353
  var valid_579354 = query.getOrDefault("requestMetadata.experimentIds")
  valid_579354 = validateParameter(valid_579354, JArray, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "requestMetadata.experimentIds", valid_579354
  var valid_579355 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_579355
  var valid_579356 = query.getOrDefault("callback")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "callback", valid_579356
  var valid_579357 = query.getOrDefault("requestMetadata.locale")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "requestMetadata.locale", valid_579357
  var valid_579358 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_579358
  var valid_579359 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "requestMetadata.partnersSessionId", valid_579359
  var valid_579360 = query.getOrDefault("fields")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "fields", valid_579360
  var valid_579361 = query.getOrDefault("access_token")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "access_token", valid_579361
  var valid_579362 = query.getOrDefault("upload_protocol")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "upload_protocol", valid_579362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579363: Call_PartnersUsersDeleteCompanyRelation_579339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ## 
  let valid = call_579363.validator(path, query, header, formData, body)
  let scheme = call_579363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579363.url(scheme.get, call_579363.host, call_579363.base,
                         call_579363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579363, url, valid)

proc call*(call_579364: Call_PartnersUsersDeleteCompanyRelation_579339;
          userId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = "";
          requestMetadataUserOverridesIpAddress: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          requestMetadataUserOverridesUserId: string = ""; quotaUser: string = "";
          requestMetadataExperimentIds: JsonNode = nil;
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          callback: string = ""; requestMetadataLocale: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          requestMetadataPartnersSessionId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## partnersUsersDeleteCompanyRelation
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   userId: string (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   callback: string
  ##           : JSONP
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579365 = newJObject()
  var query_579366 = newJObject()
  add(query_579366, "key", newJString(key))
  add(query_579366, "pp", newJBool(pp))
  add(query_579366, "prettyPrint", newJBool(prettyPrint))
  add(query_579366, "oauth_token", newJString(oauthToken))
  add(query_579366, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_579366, "$.xgafv", newJString(Xgafv))
  add(query_579366, "bearer_token", newJString(bearerToken))
  add(query_579366, "alt", newJString(alt))
  add(query_579366, "uploadType", newJString(uploadType))
  add(query_579366, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_579366, "quotaUser", newJString(quotaUser))
  if requestMetadataExperimentIds != nil:
    query_579366.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(path_579365, "userId", newJString(userId))
  add(query_579366, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_579366, "callback", newJString(callback))
  add(query_579366, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_579366, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_579366, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_579366, "fields", newJString(fields))
  add(query_579366, "access_token", newJString(accessToken))
  add(query_579366, "upload_protocol", newJString(uploadProtocol))
  result = call_579364.call(path_579365, query_579366, nil, nil, nil)

var partnersUsersDeleteCompanyRelation* = Call_PartnersUsersDeleteCompanyRelation_579339(
    name: "partnersUsersDeleteCompanyRelation", meth: HttpMethod.HttpDelete,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersDeleteCompanyRelation_579340, base: "/",
    url: url_PartnersUsersDeleteCompanyRelation_579341, schemes: {Scheme.Https})
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
