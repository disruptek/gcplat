
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: G Suite Alert Center
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages alerts on issues affecting your domain.
## 
## https://developers.google.com/admin-sdk/alertcenter/
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "alertcenter"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlertcenterAlertsList_578610 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsList_578612(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the alerts.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The requested page size. Server may return fewer items than
  ## requested. If unspecified, server picks an appropriate default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional. The sort order of the list results.
  ## If not specified results may be returned in arbitrary order.
  ## You can sort the results in descending order based on the creation
  ## timestamp using `order_by="create_time desc"`.
  ## Currently, supported sorting are `create_time asc`, `create_time desc`,
  ## `update_time desc`
  ##   filter: JString
  ##         : Optional. A query string for filtering alert results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.list).
  ##   pageToken: JString
  ##            : Optional. A token identifying a page of results the server should return.
  ## If empty, a new iteration is started. To continue an iteration, pass in
  ## the value from the previous ListAlertsResponse's
  ## next_page_token field.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alerts are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("pageSize")
  valid_578741 = validateParameter(valid_578741, JInt, required = false, default = nil)
  if valid_578741 != nil:
    section.add "pageSize", valid_578741
  var valid_578742 = query.getOrDefault("alt")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("json"))
  if valid_578742 != nil:
    section.add "alt", valid_578742
  var valid_578743 = query.getOrDefault("uploadType")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "uploadType", valid_578743
  var valid_578744 = query.getOrDefault("quotaUser")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "quotaUser", valid_578744
  var valid_578745 = query.getOrDefault("orderBy")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "orderBy", valid_578745
  var valid_578746 = query.getOrDefault("filter")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "filter", valid_578746
  var valid_578747 = query.getOrDefault("pageToken")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "pageToken", valid_578747
  var valid_578748 = query.getOrDefault("customerId")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "customerId", valid_578748
  var valid_578749 = query.getOrDefault("callback")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "callback", valid_578749
  var valid_578750 = query.getOrDefault("fields")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "fields", valid_578750
  var valid_578751 = query.getOrDefault("access_token")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "access_token", valid_578751
  var valid_578752 = query.getOrDefault("upload_protocol")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "upload_protocol", valid_578752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578775: Call_AlertcenterAlertsList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the alerts.
  ## 
  let valid = call_578775.validator(path, query, header, formData, body)
  let scheme = call_578775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578775.url(scheme.get, call_578775.host, call_578775.base,
                         call_578775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578775, url, valid)

proc call*(call_578846: Call_AlertcenterAlertsList_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; customerId: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsList
  ## Lists the alerts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The requested page size. Server may return fewer items than
  ## requested. If unspecified, server picks an appropriate default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional. The sort order of the list results.
  ## If not specified results may be returned in arbitrary order.
  ## You can sort the results in descending order based on the creation
  ## timestamp using `order_by="create_time desc"`.
  ## Currently, supported sorting are `create_time asc`, `create_time desc`,
  ## `update_time desc`
  ##   filter: string
  ##         : Optional. A query string for filtering alert results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.list).
  ##   pageToken: string
  ##            : Optional. A token identifying a page of results the server should return.
  ## If empty, a new iteration is started. To continue an iteration, pass in
  ## the value from the previous ListAlertsResponse's
  ## next_page_token field.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alerts are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578847 = newJObject()
  add(query_578847, "key", newJString(key))
  add(query_578847, "prettyPrint", newJBool(prettyPrint))
  add(query_578847, "oauth_token", newJString(oauthToken))
  add(query_578847, "$.xgafv", newJString(Xgafv))
  add(query_578847, "pageSize", newJInt(pageSize))
  add(query_578847, "alt", newJString(alt))
  add(query_578847, "uploadType", newJString(uploadType))
  add(query_578847, "quotaUser", newJString(quotaUser))
  add(query_578847, "orderBy", newJString(orderBy))
  add(query_578847, "filter", newJString(filter))
  add(query_578847, "pageToken", newJString(pageToken))
  add(query_578847, "customerId", newJString(customerId))
  add(query_578847, "callback", newJString(callback))
  add(query_578847, "fields", newJString(fields))
  add(query_578847, "access_token", newJString(accessToken))
  add(query_578847, "upload_protocol", newJString(uploadProtocol))
  result = call_578846.call(nil, query_578847, nil, nil, nil)

var alertcenterAlertsList* = Call_AlertcenterAlertsList_578610(
    name: "alertcenterAlertsList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts",
    validator: validate_AlertcenterAlertsList_578611, base: "/",
    url: url_AlertcenterAlertsList_578612, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGet_578887 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsGet_578889(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsGet_578888(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_578904 = path.getOrDefault("alertId")
  valid_578904 = validateParameter(valid_578904, JString, required = true,
                                 default = nil)
  if valid_578904 != nil:
    section.add "alertId", valid_578904
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
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
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("$.xgafv")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("1"))
  if valid_578908 != nil:
    section.add "$.xgafv", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("uploadType")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "uploadType", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("customerId")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "customerId", valid_578912
  var valid_578913 = query.getOrDefault("callback")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "callback", valid_578913
  var valid_578914 = query.getOrDefault("fields")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "fields", valid_578914
  var valid_578915 = query.getOrDefault("access_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "access_token", valid_578915
  var valid_578916 = query.getOrDefault("upload_protocol")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "upload_protocol", valid_578916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578917: Call_AlertcenterAlertsGet_578887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_AlertcenterAlertsGet_578887; alertId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; customerId: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsGet
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to retrieve.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578919 = newJObject()
  var query_578920 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(path_578919, "alertId", newJString(alertId))
  add(query_578920, "$.xgafv", newJString(Xgafv))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "uploadType", newJString(uploadType))
  add(query_578920, "quotaUser", newJString(quotaUser))
  add(query_578920, "customerId", newJString(customerId))
  add(query_578920, "callback", newJString(callback))
  add(query_578920, "fields", newJString(fields))
  add(query_578920, "access_token", newJString(accessToken))
  add(query_578920, "upload_protocol", newJString(uploadProtocol))
  result = call_578918.call(path_578919, query_578920, nil, nil, nil)

var alertcenterAlertsGet* = Call_AlertcenterAlertsGet_578887(
    name: "alertcenterAlertsGet", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsGet_578888, base: "/",
    url: url_AlertcenterAlertsGet_578889, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsDelete_578921 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsDelete_578923(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsDelete_578922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_578924 = path.getOrDefault("alertId")
  valid_578924 = validateParameter(valid_578924, JString, required = true,
                                 default = nil)
  if valid_578924 != nil:
    section.add "alertId", valid_578924
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("$.xgafv")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("1"))
  if valid_578928 != nil:
    section.add "$.xgafv", valid_578928
  var valid_578929 = query.getOrDefault("alt")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("json"))
  if valid_578929 != nil:
    section.add "alt", valid_578929
  var valid_578930 = query.getOrDefault("uploadType")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "uploadType", valid_578930
  var valid_578931 = query.getOrDefault("quotaUser")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "quotaUser", valid_578931
  var valid_578932 = query.getOrDefault("customerId")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "customerId", valid_578932
  var valid_578933 = query.getOrDefault("callback")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "callback", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  var valid_578935 = query.getOrDefault("access_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "access_token", valid_578935
  var valid_578936 = query.getOrDefault("upload_protocol")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "upload_protocol", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578937: Call_AlertcenterAlertsDelete_578921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_AlertcenterAlertsDelete_578921; alertId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; customerId: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsDelete
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to delete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(path_578939, "alertId", newJString(alertId))
  add(query_578940, "$.xgafv", newJString(Xgafv))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "uploadType", newJString(uploadType))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(query_578940, "customerId", newJString(customerId))
  add(query_578940, "callback", newJString(callback))
  add(query_578940, "fields", newJString(fields))
  add(query_578940, "access_token", newJString(accessToken))
  add(query_578940, "upload_protocol", newJString(uploadProtocol))
  result = call_578938.call(path_578939, query_578940, nil, nil, nil)

var alertcenterAlertsDelete* = Call_AlertcenterAlertsDelete_578921(
    name: "alertcenterAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsDelete_578922, base: "/",
    url: url_AlertcenterAlertsDelete_578923, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackCreate_578962 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsFeedbackCreate_578964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/feedback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsFeedbackCreate_578963(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert this feedback belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_578965 = path.getOrDefault("alertId")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "alertId", valid_578965
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578966 = query.getOrDefault("key")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "key", valid_578966
  var valid_578967 = query.getOrDefault("prettyPrint")
  valid_578967 = validateParameter(valid_578967, JBool, required = false,
                                 default = newJBool(true))
  if valid_578967 != nil:
    section.add "prettyPrint", valid_578967
  var valid_578968 = query.getOrDefault("oauth_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "oauth_token", valid_578968
  var valid_578969 = query.getOrDefault("$.xgafv")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("1"))
  if valid_578969 != nil:
    section.add "$.xgafv", valid_578969
  var valid_578970 = query.getOrDefault("alt")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("json"))
  if valid_578970 != nil:
    section.add "alt", valid_578970
  var valid_578971 = query.getOrDefault("uploadType")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "uploadType", valid_578971
  var valid_578972 = query.getOrDefault("quotaUser")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "quotaUser", valid_578972
  var valid_578973 = query.getOrDefault("customerId")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "customerId", valid_578973
  var valid_578974 = query.getOrDefault("callback")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "callback", valid_578974
  var valid_578975 = query.getOrDefault("fields")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "fields", valid_578975
  var valid_578976 = query.getOrDefault("access_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "access_token", valid_578976
  var valid_578977 = query.getOrDefault("upload_protocol")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "upload_protocol", valid_578977
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

proc call*(call_578979: Call_AlertcenterAlertsFeedbackCreate_578962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_AlertcenterAlertsFeedbackCreate_578962;
          alertId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          customerId: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsFeedbackCreate
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert this feedback belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(path_578981, "alertId", newJString(alertId))
  add(query_578982, "$.xgafv", newJString(Xgafv))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "uploadType", newJString(uploadType))
  add(query_578982, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578983 = body
  add(query_578982, "customerId", newJString(customerId))
  add(query_578982, "callback", newJString(callback))
  add(query_578982, "fields", newJString(fields))
  add(query_578982, "access_token", newJString(accessToken))
  add(query_578982, "upload_protocol", newJString(uploadProtocol))
  result = call_578980.call(path_578981, query_578982, nil, nil, body_578983)

var alertcenterAlertsFeedbackCreate* = Call_AlertcenterAlertsFeedbackCreate_578962(
    name: "alertcenterAlertsFeedbackCreate", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackCreate_578963, base: "/",
    url: url_AlertcenterAlertsFeedbackCreate_578964, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackList_578941 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsFeedbackList_578943(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/feedback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsFeedbackList_578942(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The alert identifier.
  ## The "-" wildcard could be used to represent all alerts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_578944 = path.getOrDefault("alertId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "alertId", valid_578944
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Optional. A query string for filtering alert feedback results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.feedback.list).
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert feedback are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("$.xgafv")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("1"))
  if valid_578948 != nil:
    section.add "$.xgafv", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("filter")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "filter", valid_578952
  var valid_578953 = query.getOrDefault("customerId")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "customerId", valid_578953
  var valid_578954 = query.getOrDefault("callback")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "callback", valid_578954
  var valid_578955 = query.getOrDefault("fields")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "fields", valid_578955
  var valid_578956 = query.getOrDefault("access_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "access_token", valid_578956
  var valid_578957 = query.getOrDefault("upload_protocol")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "upload_protocol", valid_578957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578958: Call_AlertcenterAlertsFeedbackList_578941; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_578958.validator(path, query, header, formData, body)
  let scheme = call_578958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578958.url(scheme.get, call_578958.host, call_578958.base,
                         call_578958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578958, url, valid)

proc call*(call_578959: Call_AlertcenterAlertsFeedbackList_578941; alertId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; customerId: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsFeedbackList
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Required. The alert identifier.
  ## The "-" wildcard could be used to represent all alerts.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Optional. A query string for filtering alert feedback results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.feedback.list).
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert feedback are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578960 = newJObject()
  var query_578961 = newJObject()
  add(query_578961, "key", newJString(key))
  add(query_578961, "prettyPrint", newJBool(prettyPrint))
  add(query_578961, "oauth_token", newJString(oauthToken))
  add(path_578960, "alertId", newJString(alertId))
  add(query_578961, "$.xgafv", newJString(Xgafv))
  add(query_578961, "alt", newJString(alt))
  add(query_578961, "uploadType", newJString(uploadType))
  add(query_578961, "quotaUser", newJString(quotaUser))
  add(query_578961, "filter", newJString(filter))
  add(query_578961, "customerId", newJString(customerId))
  add(query_578961, "callback", newJString(callback))
  add(query_578961, "fields", newJString(fields))
  add(query_578961, "access_token", newJString(accessToken))
  add(query_578961, "upload_protocol", newJString(uploadProtocol))
  result = call_578959.call(path_578960, query_578961, nil, nil, nil)

var alertcenterAlertsFeedbackList* = Call_AlertcenterAlertsFeedbackList_578941(
    name: "alertcenterAlertsFeedbackList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackList_578942, base: "/",
    url: url_AlertcenterAlertsFeedbackList_578943, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGetMetadata_578984 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsGetMetadata_578986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsGetMetadata_578985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert this metadata belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_578987 = path.getOrDefault("alertId")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "alertId", valid_578987
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert metadata is associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578988 = query.getOrDefault("key")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "key", valid_578988
  var valid_578989 = query.getOrDefault("prettyPrint")
  valid_578989 = validateParameter(valid_578989, JBool, required = false,
                                 default = newJBool(true))
  if valid_578989 != nil:
    section.add "prettyPrint", valid_578989
  var valid_578990 = query.getOrDefault("oauth_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "oauth_token", valid_578990
  var valid_578991 = query.getOrDefault("$.xgafv")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("1"))
  if valid_578991 != nil:
    section.add "$.xgafv", valid_578991
  var valid_578992 = query.getOrDefault("alt")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = newJString("json"))
  if valid_578992 != nil:
    section.add "alt", valid_578992
  var valid_578993 = query.getOrDefault("uploadType")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "uploadType", valid_578993
  var valid_578994 = query.getOrDefault("quotaUser")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "quotaUser", valid_578994
  var valid_578995 = query.getOrDefault("customerId")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "customerId", valid_578995
  var valid_578996 = query.getOrDefault("callback")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "callback", valid_578996
  var valid_578997 = query.getOrDefault("fields")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "fields", valid_578997
  var valid_578998 = query.getOrDefault("access_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "access_token", valid_578998
  var valid_578999 = query.getOrDefault("upload_protocol")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "upload_protocol", valid_578999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579000: Call_AlertcenterAlertsGetMetadata_578984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_AlertcenterAlertsGetMetadata_578984; alertId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; customerId: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsGetMetadata
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert this metadata belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert metadata is associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(path_579002, "alertId", newJString(alertId))
  add(query_579003, "$.xgafv", newJString(Xgafv))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "uploadType", newJString(uploadType))
  add(query_579003, "quotaUser", newJString(quotaUser))
  add(query_579003, "customerId", newJString(customerId))
  add(query_579003, "callback", newJString(callback))
  add(query_579003, "fields", newJString(fields))
  add(query_579003, "access_token", newJString(accessToken))
  add(query_579003, "upload_protocol", newJString(uploadProtocol))
  result = call_579001.call(path_579002, query_579003, nil, nil, nil)

var alertcenterAlertsGetMetadata* = Call_AlertcenterAlertsGetMetadata_578984(
    name: "alertcenterAlertsGetMetadata", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/metadata",
    validator: validate_AlertcenterAlertsGetMetadata_578985, base: "/",
    url: url_AlertcenterAlertsGetMetadata_578986, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsUndelete_579004 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsUndelete_579006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsUndelete_579005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert to undelete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_579007 = path.getOrDefault("alertId")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "alertId", valid_579007
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("$.xgafv")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("1"))
  if valid_579011 != nil:
    section.add "$.xgafv", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("uploadType")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "uploadType", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("callback")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "callback", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("access_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "access_token", valid_579017
  var valid_579018 = query.getOrDefault("upload_protocol")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "upload_protocol", valid_579018
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

proc call*(call_579020: Call_AlertcenterAlertsUndelete_579004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ## 
  let valid = call_579020.validator(path, query, header, formData, body)
  let scheme = call_579020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579020.url(scheme.get, call_579020.host, call_579020.base,
                         call_579020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579020, url, valid)

proc call*(call_579021: Call_AlertcenterAlertsUndelete_579004; alertId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsUndelete
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to undelete.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var path_579022 = newJObject()
  var query_579023 = newJObject()
  var body_579024 = newJObject()
  add(query_579023, "key", newJString(key))
  add(query_579023, "prettyPrint", newJBool(prettyPrint))
  add(query_579023, "oauth_token", newJString(oauthToken))
  add(path_579022, "alertId", newJString(alertId))
  add(query_579023, "$.xgafv", newJString(Xgafv))
  add(query_579023, "alt", newJString(alt))
  add(query_579023, "uploadType", newJString(uploadType))
  add(query_579023, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579024 = body
  add(query_579023, "callback", newJString(callback))
  add(query_579023, "fields", newJString(fields))
  add(query_579023, "access_token", newJString(accessToken))
  add(query_579023, "upload_protocol", newJString(uploadProtocol))
  result = call_579021.call(path_579022, query_579023, nil, nil, body_579024)

var alertcenterAlertsUndelete* = Call_AlertcenterAlertsUndelete_579004(
    name: "alertcenterAlertsUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}:undelete",
    validator: validate_AlertcenterAlertsUndelete_579005, base: "/",
    url: url_AlertcenterAlertsUndelete_579006, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchDelete_579025 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsBatchDelete_579027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchDelete_579026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs batch delete operation on alerts.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("$.xgafv")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("1"))
  if valid_579031 != nil:
    section.add "$.xgafv", valid_579031
  var valid_579032 = query.getOrDefault("alt")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("json"))
  if valid_579032 != nil:
    section.add "alt", valid_579032
  var valid_579033 = query.getOrDefault("uploadType")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "uploadType", valid_579033
  var valid_579034 = query.getOrDefault("quotaUser")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "quotaUser", valid_579034
  var valid_579035 = query.getOrDefault("callback")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "callback", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  var valid_579037 = query.getOrDefault("access_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "access_token", valid_579037
  var valid_579038 = query.getOrDefault("upload_protocol")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "upload_protocol", valid_579038
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

proc call*(call_579040: Call_AlertcenterAlertsBatchDelete_579025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch delete operation on alerts.
  ## 
  let valid = call_579040.validator(path, query, header, formData, body)
  let scheme = call_579040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579040.url(scheme.get, call_579040.host, call_579040.base,
                         call_579040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579040, url, valid)

proc call*(call_579041: Call_AlertcenterAlertsBatchDelete_579025; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsBatchDelete
  ## Performs batch delete operation on alerts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_579042 = newJObject()
  var body_579043 = newJObject()
  add(query_579042, "key", newJString(key))
  add(query_579042, "prettyPrint", newJBool(prettyPrint))
  add(query_579042, "oauth_token", newJString(oauthToken))
  add(query_579042, "$.xgafv", newJString(Xgafv))
  add(query_579042, "alt", newJString(alt))
  add(query_579042, "uploadType", newJString(uploadType))
  add(query_579042, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579043 = body
  add(query_579042, "callback", newJString(callback))
  add(query_579042, "fields", newJString(fields))
  add(query_579042, "access_token", newJString(accessToken))
  add(query_579042, "upload_protocol", newJString(uploadProtocol))
  result = call_579041.call(nil, query_579042, nil, nil, body_579043)

var alertcenterAlertsBatchDelete* = Call_AlertcenterAlertsBatchDelete_579025(
    name: "alertcenterAlertsBatchDelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchDelete",
    validator: validate_AlertcenterAlertsBatchDelete_579026, base: "/",
    url: url_AlertcenterAlertsBatchDelete_579027, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchUndelete_579044 = ref object of OpenApiRestCall_578339
proc url_AlertcenterAlertsBatchUndelete_579046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchUndelete_579045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs batch undelete operation on alerts.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
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
  var valid_579051 = query.getOrDefault("alt")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("json"))
  if valid_579051 != nil:
    section.add "alt", valid_579051
  var valid_579052 = query.getOrDefault("uploadType")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "uploadType", valid_579052
  var valid_579053 = query.getOrDefault("quotaUser")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "quotaUser", valid_579053
  var valid_579054 = query.getOrDefault("callback")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "callback", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
  var valid_579056 = query.getOrDefault("access_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "access_token", valid_579056
  var valid_579057 = query.getOrDefault("upload_protocol")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "upload_protocol", valid_579057
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

proc call*(call_579059: Call_AlertcenterAlertsBatchUndelete_579044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch undelete operation on alerts.
  ## 
  let valid = call_579059.validator(path, query, header, formData, body)
  let scheme = call_579059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579059.url(scheme.get, call_579059.host, call_579059.base,
                         call_579059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579059, url, valid)

proc call*(call_579060: Call_AlertcenterAlertsBatchUndelete_579044;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterAlertsBatchUndelete
  ## Performs batch undelete operation on alerts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_579061 = newJObject()
  var body_579062 = newJObject()
  add(query_579061, "key", newJString(key))
  add(query_579061, "prettyPrint", newJBool(prettyPrint))
  add(query_579061, "oauth_token", newJString(oauthToken))
  add(query_579061, "$.xgafv", newJString(Xgafv))
  add(query_579061, "alt", newJString(alt))
  add(query_579061, "uploadType", newJString(uploadType))
  add(query_579061, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579062 = body
  add(query_579061, "callback", newJString(callback))
  add(query_579061, "fields", newJString(fields))
  add(query_579061, "access_token", newJString(accessToken))
  add(query_579061, "upload_protocol", newJString(uploadProtocol))
  result = call_579060.call(nil, query_579061, nil, nil, body_579062)

var alertcenterAlertsBatchUndelete* = Call_AlertcenterAlertsBatchUndelete_579044(
    name: "alertcenterAlertsBatchUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchUndelete",
    validator: validate_AlertcenterAlertsBatchUndelete_579045, base: "/",
    url: url_AlertcenterAlertsBatchUndelete_579046, schemes: {Scheme.Https})
type
  Call_AlertcenterGetSettings_579063 = ref object of OpenApiRestCall_578339
proc url_AlertcenterGetSettings_579065(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterGetSettings_579064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns customer-level settings.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579066 = query.getOrDefault("key")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "key", valid_579066
  var valid_579067 = query.getOrDefault("prettyPrint")
  valid_579067 = validateParameter(valid_579067, JBool, required = false,
                                 default = newJBool(true))
  if valid_579067 != nil:
    section.add "prettyPrint", valid_579067
  var valid_579068 = query.getOrDefault("oauth_token")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "oauth_token", valid_579068
  var valid_579069 = query.getOrDefault("$.xgafv")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = newJString("1"))
  if valid_579069 != nil:
    section.add "$.xgafv", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("uploadType")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "uploadType", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("customerId")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "customerId", valid_579073
  var valid_579074 = query.getOrDefault("callback")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "callback", valid_579074
  var valid_579075 = query.getOrDefault("fields")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "fields", valid_579075
  var valid_579076 = query.getOrDefault("access_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "access_token", valid_579076
  var valid_579077 = query.getOrDefault("upload_protocol")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "upload_protocol", valid_579077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579078: Call_AlertcenterGetSettings_579063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns customer-level settings.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_AlertcenterGetSettings_579063; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          customerId: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterGetSettings
  ## Returns customer-level settings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579080 = newJObject()
  add(query_579080, "key", newJString(key))
  add(query_579080, "prettyPrint", newJBool(prettyPrint))
  add(query_579080, "oauth_token", newJString(oauthToken))
  add(query_579080, "$.xgafv", newJString(Xgafv))
  add(query_579080, "alt", newJString(alt))
  add(query_579080, "uploadType", newJString(uploadType))
  add(query_579080, "quotaUser", newJString(quotaUser))
  add(query_579080, "customerId", newJString(customerId))
  add(query_579080, "callback", newJString(callback))
  add(query_579080, "fields", newJString(fields))
  add(query_579080, "access_token", newJString(accessToken))
  add(query_579080, "upload_protocol", newJString(uploadProtocol))
  result = call_579079.call(nil, query_579080, nil, nil, nil)

var alertcenterGetSettings* = Call_AlertcenterGetSettings_579063(
    name: "alertcenterGetSettings", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterGetSettings_579064, base: "/",
    url: url_AlertcenterGetSettings_579065, schemes: {Scheme.Https})
type
  Call_AlertcenterUpdateSettings_579081 = ref object of OpenApiRestCall_578339
proc url_AlertcenterUpdateSettings_579083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterUpdateSettings_579082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the customer-level settings.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579084 = query.getOrDefault("key")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "key", valid_579084
  var valid_579085 = query.getOrDefault("prettyPrint")
  valid_579085 = validateParameter(valid_579085, JBool, required = false,
                                 default = newJBool(true))
  if valid_579085 != nil:
    section.add "prettyPrint", valid_579085
  var valid_579086 = query.getOrDefault("oauth_token")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "oauth_token", valid_579086
  var valid_579087 = query.getOrDefault("$.xgafv")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = newJString("1"))
  if valid_579087 != nil:
    section.add "$.xgafv", valid_579087
  var valid_579088 = query.getOrDefault("alt")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("json"))
  if valid_579088 != nil:
    section.add "alt", valid_579088
  var valid_579089 = query.getOrDefault("uploadType")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "uploadType", valid_579089
  var valid_579090 = query.getOrDefault("quotaUser")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "quotaUser", valid_579090
  var valid_579091 = query.getOrDefault("customerId")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "customerId", valid_579091
  var valid_579092 = query.getOrDefault("callback")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "callback", valid_579092
  var valid_579093 = query.getOrDefault("fields")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "fields", valid_579093
  var valid_579094 = query.getOrDefault("access_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "access_token", valid_579094
  var valid_579095 = query.getOrDefault("upload_protocol")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "upload_protocol", valid_579095
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

proc call*(call_579097: Call_AlertcenterUpdateSettings_579081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the customer-level settings.
  ## 
  let valid = call_579097.validator(path, query, header, formData, body)
  let scheme = call_579097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579097.url(scheme.get, call_579097.host, call_579097.base,
                         call_579097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579097, url, valid)

proc call*(call_579098: Call_AlertcenterUpdateSettings_579081; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; customerId: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## alertcenterUpdateSettings
  ## Updates the customer-level settings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579099 = newJObject()
  var body_579100 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(query_579099, "$.xgafv", newJString(Xgafv))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "uploadType", newJString(uploadType))
  add(query_579099, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579100 = body
  add(query_579099, "customerId", newJString(customerId))
  add(query_579099, "callback", newJString(callback))
  add(query_579099, "fields", newJString(fields))
  add(query_579099, "access_token", newJString(accessToken))
  add(query_579099, "upload_protocol", newJString(uploadProtocol))
  result = call_579098.call(nil, query_579099, nil, nil, body_579100)

var alertcenterUpdateSettings* = Call_AlertcenterUpdateSettings_579081(
    name: "alertcenterUpdateSettings", meth: HttpMethod.HttpPatch,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterUpdateSettings_579082, base: "/",
    url: url_AlertcenterUpdateSettings_579083, schemes: {Scheme.Https})
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
