
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "alertcenter"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlertcenterAlertsList_597677 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsList_597679(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsList_597678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the alerts.
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
  ##            : Optional. A token identifying a page of results the server should return.
  ## If empty, a new iteration is started. To continue an iteration, pass in
  ## the value from the previous ListAlertsResponse's
  ## next_page_token field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alerts are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional. The sort order of the list results.
  ## If not specified results may be returned in arbitrary order.
  ## You can sort the results in descending order based on the creation
  ## timestamp using `order_by="create_time desc"`.
  ## Currently, supported sorting are `create_time asc`, `create_time desc`,
  ## `update_time desc`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The requested page size. Server may return fewer items than
  ## requested. If unspecified, server picks an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. A query string for filtering alert results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.list).
  section = newJObject()
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("pageToken")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "pageToken", valid_597793
  var valid_597794 = query.getOrDefault("quotaUser")
  valid_597794 = validateParameter(valid_597794, JString, required = false,
                                 default = nil)
  if valid_597794 != nil:
    section.add "quotaUser", valid_597794
  var valid_597808 = query.getOrDefault("alt")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = newJString("json"))
  if valid_597808 != nil:
    section.add "alt", valid_597808
  var valid_597809 = query.getOrDefault("customerId")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "customerId", valid_597809
  var valid_597810 = query.getOrDefault("oauth_token")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "oauth_token", valid_597810
  var valid_597811 = query.getOrDefault("callback")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "callback", valid_597811
  var valid_597812 = query.getOrDefault("access_token")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "access_token", valid_597812
  var valid_597813 = query.getOrDefault("uploadType")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "uploadType", valid_597813
  var valid_597814 = query.getOrDefault("orderBy")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = nil)
  if valid_597814 != nil:
    section.add "orderBy", valid_597814
  var valid_597815 = query.getOrDefault("key")
  valid_597815 = validateParameter(valid_597815, JString, required = false,
                                 default = nil)
  if valid_597815 != nil:
    section.add "key", valid_597815
  var valid_597816 = query.getOrDefault("$.xgafv")
  valid_597816 = validateParameter(valid_597816, JString, required = false,
                                 default = newJString("1"))
  if valid_597816 != nil:
    section.add "$.xgafv", valid_597816
  var valid_597817 = query.getOrDefault("pageSize")
  valid_597817 = validateParameter(valid_597817, JInt, required = false, default = nil)
  if valid_597817 != nil:
    section.add "pageSize", valid_597817
  var valid_597818 = query.getOrDefault("prettyPrint")
  valid_597818 = validateParameter(valid_597818, JBool, required = false,
                                 default = newJBool(true))
  if valid_597818 != nil:
    section.add "prettyPrint", valid_597818
  var valid_597819 = query.getOrDefault("filter")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "filter", valid_597819
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597842: Call_AlertcenterAlertsList_597677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the alerts.
  ## 
  let valid = call_597842.validator(path, query, header, formData, body)
  let scheme = call_597842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597842.url(scheme.get, call_597842.host, call_597842.base,
                         call_597842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597842, url, valid)

proc call*(call_597913: Call_AlertcenterAlertsList_597677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; customerId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## alertcenterAlertsList
  ## Lists the alerts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A token identifying a page of results the server should return.
  ## If empty, a new iteration is started. To continue an iteration, pass in
  ## the value from the previous ListAlertsResponse's
  ## next_page_token field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alerts are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: string
  ##          : Optional. The sort order of the list results.
  ## If not specified results may be returned in arbitrary order.
  ## You can sort the results in descending order based on the creation
  ## timestamp using `order_by="create_time desc"`.
  ## Currently, supported sorting are `create_time asc`, `create_time desc`,
  ## `update_time desc`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The requested page size. Server may return fewer items than
  ## requested. If unspecified, server picks an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. A query string for filtering alert results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.list).
  var query_597914 = newJObject()
  add(query_597914, "upload_protocol", newJString(uploadProtocol))
  add(query_597914, "fields", newJString(fields))
  add(query_597914, "pageToken", newJString(pageToken))
  add(query_597914, "quotaUser", newJString(quotaUser))
  add(query_597914, "alt", newJString(alt))
  add(query_597914, "customerId", newJString(customerId))
  add(query_597914, "oauth_token", newJString(oauthToken))
  add(query_597914, "callback", newJString(callback))
  add(query_597914, "access_token", newJString(accessToken))
  add(query_597914, "uploadType", newJString(uploadType))
  add(query_597914, "orderBy", newJString(orderBy))
  add(query_597914, "key", newJString(key))
  add(query_597914, "$.xgafv", newJString(Xgafv))
  add(query_597914, "pageSize", newJInt(pageSize))
  add(query_597914, "prettyPrint", newJBool(prettyPrint))
  add(query_597914, "filter", newJString(filter))
  result = call_597913.call(nil, query_597914, nil, nil, nil)

var alertcenterAlertsList* = Call_AlertcenterAlertsList_597677(
    name: "alertcenterAlertsList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts",
    validator: validate_AlertcenterAlertsList_597678, base: "/",
    url: url_AlertcenterAlertsList_597679, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGet_597954 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsGet_597956(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsGet_597955(path: JsonNode; query: JsonNode;
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
  var valid_597971 = path.getOrDefault("alertId")
  valid_597971 = validateParameter(valid_597971, JString, required = true,
                                 default = nil)
  if valid_597971 != nil:
    section.add "alertId", valid_597971
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
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
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
  section = newJObject()
  var valid_597972 = query.getOrDefault("upload_protocol")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "upload_protocol", valid_597972
  var valid_597973 = query.getOrDefault("fields")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "fields", valid_597973
  var valid_597974 = query.getOrDefault("quotaUser")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "quotaUser", valid_597974
  var valid_597975 = query.getOrDefault("alt")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = newJString("json"))
  if valid_597975 != nil:
    section.add "alt", valid_597975
  var valid_597976 = query.getOrDefault("customerId")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "customerId", valid_597976
  var valid_597977 = query.getOrDefault("oauth_token")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "oauth_token", valid_597977
  var valid_597978 = query.getOrDefault("callback")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "callback", valid_597978
  var valid_597979 = query.getOrDefault("access_token")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "access_token", valid_597979
  var valid_597980 = query.getOrDefault("uploadType")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "uploadType", valid_597980
  var valid_597981 = query.getOrDefault("key")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "key", valid_597981
  var valid_597982 = query.getOrDefault("$.xgafv")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = newJString("1"))
  if valid_597982 != nil:
    section.add "$.xgafv", valid_597982
  var valid_597983 = query.getOrDefault("prettyPrint")
  valid_597983 = validateParameter(valid_597983, JBool, required = false,
                                 default = newJBool(true))
  if valid_597983 != nil:
    section.add "prettyPrint", valid_597983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597984: Call_AlertcenterAlertsGet_597954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_AlertcenterAlertsGet_597954; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsGet
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
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
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to retrieve.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  add(query_597987, "upload_protocol", newJString(uploadProtocol))
  add(query_597987, "fields", newJString(fields))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "customerId", newJString(customerId))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "callback", newJString(callback))
  add(query_597987, "access_token", newJString(accessToken))
  add(query_597987, "uploadType", newJString(uploadType))
  add(query_597987, "key", newJString(key))
  add(path_597986, "alertId", newJString(alertId))
  add(query_597987, "$.xgafv", newJString(Xgafv))
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  result = call_597985.call(path_597986, query_597987, nil, nil, nil)

var alertcenterAlertsGet* = Call_AlertcenterAlertsGet_597954(
    name: "alertcenterAlertsGet", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsGet_597955, base: "/",
    url: url_AlertcenterAlertsGet_597956, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsDelete_597988 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsDelete_597990(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsDelete_597989(path: JsonNode; query: JsonNode;
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
  var valid_597991 = path.getOrDefault("alertId")
  valid_597991 = validateParameter(valid_597991, JString, required = true,
                                 default = nil)
  if valid_597991 != nil:
    section.add "alertId", valid_597991
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
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
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
  section = newJObject()
  var valid_597992 = query.getOrDefault("upload_protocol")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "upload_protocol", valid_597992
  var valid_597993 = query.getOrDefault("fields")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "fields", valid_597993
  var valid_597994 = query.getOrDefault("quotaUser")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "quotaUser", valid_597994
  var valid_597995 = query.getOrDefault("alt")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = newJString("json"))
  if valid_597995 != nil:
    section.add "alt", valid_597995
  var valid_597996 = query.getOrDefault("customerId")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "customerId", valid_597996
  var valid_597997 = query.getOrDefault("oauth_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "oauth_token", valid_597997
  var valid_597998 = query.getOrDefault("callback")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "callback", valid_597998
  var valid_597999 = query.getOrDefault("access_token")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "access_token", valid_597999
  var valid_598000 = query.getOrDefault("uploadType")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "uploadType", valid_598000
  var valid_598001 = query.getOrDefault("key")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "key", valid_598001
  var valid_598002 = query.getOrDefault("$.xgafv")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = newJString("1"))
  if valid_598002 != nil:
    section.add "$.xgafv", valid_598002
  var valid_598003 = query.getOrDefault("prettyPrint")
  valid_598003 = validateParameter(valid_598003, JBool, required = false,
                                 default = newJBool(true))
  if valid_598003 != nil:
    section.add "prettyPrint", valid_598003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598004: Call_AlertcenterAlertsDelete_597988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ## 
  let valid = call_598004.validator(path, query, header, formData, body)
  let scheme = call_598004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598004.url(scheme.get, call_598004.host, call_598004.base,
                         call_598004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598004, url, valid)

proc call*(call_598005: Call_AlertcenterAlertsDelete_597988; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsDelete
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
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
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to delete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598006 = newJObject()
  var query_598007 = newJObject()
  add(query_598007, "upload_protocol", newJString(uploadProtocol))
  add(query_598007, "fields", newJString(fields))
  add(query_598007, "quotaUser", newJString(quotaUser))
  add(query_598007, "alt", newJString(alt))
  add(query_598007, "customerId", newJString(customerId))
  add(query_598007, "oauth_token", newJString(oauthToken))
  add(query_598007, "callback", newJString(callback))
  add(query_598007, "access_token", newJString(accessToken))
  add(query_598007, "uploadType", newJString(uploadType))
  add(query_598007, "key", newJString(key))
  add(path_598006, "alertId", newJString(alertId))
  add(query_598007, "$.xgafv", newJString(Xgafv))
  add(query_598007, "prettyPrint", newJBool(prettyPrint))
  result = call_598005.call(path_598006, query_598007, nil, nil, nil)

var alertcenterAlertsDelete* = Call_AlertcenterAlertsDelete_597988(
    name: "alertcenterAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsDelete_597989, base: "/",
    url: url_AlertcenterAlertsDelete_597990, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackCreate_598029 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsFeedbackCreate_598031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AlertcenterAlertsFeedbackCreate_598030(path: JsonNode;
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
  var valid_598032 = path.getOrDefault("alertId")
  valid_598032 = validateParameter(valid_598032, JString, required = true,
                                 default = nil)
  if valid_598032 != nil:
    section.add "alertId", valid_598032
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
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
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
  section = newJObject()
  var valid_598033 = query.getOrDefault("upload_protocol")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "upload_protocol", valid_598033
  var valid_598034 = query.getOrDefault("fields")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "fields", valid_598034
  var valid_598035 = query.getOrDefault("quotaUser")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "quotaUser", valid_598035
  var valid_598036 = query.getOrDefault("alt")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = newJString("json"))
  if valid_598036 != nil:
    section.add "alt", valid_598036
  var valid_598037 = query.getOrDefault("customerId")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "customerId", valid_598037
  var valid_598038 = query.getOrDefault("oauth_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "oauth_token", valid_598038
  var valid_598039 = query.getOrDefault("callback")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "callback", valid_598039
  var valid_598040 = query.getOrDefault("access_token")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "access_token", valid_598040
  var valid_598041 = query.getOrDefault("uploadType")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "uploadType", valid_598041
  var valid_598042 = query.getOrDefault("key")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "key", valid_598042
  var valid_598043 = query.getOrDefault("$.xgafv")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = newJString("1"))
  if valid_598043 != nil:
    section.add "$.xgafv", valid_598043
  var valid_598044 = query.getOrDefault("prettyPrint")
  valid_598044 = validateParameter(valid_598044, JBool, required = false,
                                 default = newJBool(true))
  if valid_598044 != nil:
    section.add "prettyPrint", valid_598044
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

proc call*(call_598046: Call_AlertcenterAlertsFeedbackCreate_598029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ## 
  let valid = call_598046.validator(path, query, header, formData, body)
  let scheme = call_598046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598046.url(scheme.get, call_598046.host, call_598046.base,
                         call_598046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598046, url, valid)

proc call*(call_598047: Call_AlertcenterAlertsFeedbackCreate_598029;
          alertId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; customerId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsFeedbackCreate
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
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
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert this feedback belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598048 = newJObject()
  var query_598049 = newJObject()
  var body_598050 = newJObject()
  add(query_598049, "upload_protocol", newJString(uploadProtocol))
  add(query_598049, "fields", newJString(fields))
  add(query_598049, "quotaUser", newJString(quotaUser))
  add(query_598049, "alt", newJString(alt))
  add(query_598049, "customerId", newJString(customerId))
  add(query_598049, "oauth_token", newJString(oauthToken))
  add(query_598049, "callback", newJString(callback))
  add(query_598049, "access_token", newJString(accessToken))
  add(query_598049, "uploadType", newJString(uploadType))
  add(query_598049, "key", newJString(key))
  add(path_598048, "alertId", newJString(alertId))
  add(query_598049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598050 = body
  add(query_598049, "prettyPrint", newJBool(prettyPrint))
  result = call_598047.call(path_598048, query_598049, nil, nil, body_598050)

var alertcenterAlertsFeedbackCreate* = Call_AlertcenterAlertsFeedbackCreate_598029(
    name: "alertcenterAlertsFeedbackCreate", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackCreate_598030, base: "/",
    url: url_AlertcenterAlertsFeedbackCreate_598031, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackList_598008 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsFeedbackList_598010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AlertcenterAlertsFeedbackList_598009(path: JsonNode; query: JsonNode;
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
  var valid_598011 = path.getOrDefault("alertId")
  valid_598011 = validateParameter(valid_598011, JString, required = true,
                                 default = nil)
  if valid_598011 != nil:
    section.add "alertId", valid_598011
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
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert feedback are associated with.
  ## Inferred from the caller identity if not provided.
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
  ##   filter: JString
  ##         : Optional. A query string for filtering alert feedback results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.feedback.list).
  section = newJObject()
  var valid_598012 = query.getOrDefault("upload_protocol")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "upload_protocol", valid_598012
  var valid_598013 = query.getOrDefault("fields")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "fields", valid_598013
  var valid_598014 = query.getOrDefault("quotaUser")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "quotaUser", valid_598014
  var valid_598015 = query.getOrDefault("alt")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = newJString("json"))
  if valid_598015 != nil:
    section.add "alt", valid_598015
  var valid_598016 = query.getOrDefault("customerId")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "customerId", valid_598016
  var valid_598017 = query.getOrDefault("oauth_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "oauth_token", valid_598017
  var valid_598018 = query.getOrDefault("callback")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "callback", valid_598018
  var valid_598019 = query.getOrDefault("access_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "access_token", valid_598019
  var valid_598020 = query.getOrDefault("uploadType")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "uploadType", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("$.xgafv")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = newJString("1"))
  if valid_598022 != nil:
    section.add "$.xgafv", valid_598022
  var valid_598023 = query.getOrDefault("prettyPrint")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(true))
  if valid_598023 != nil:
    section.add "prettyPrint", valid_598023
  var valid_598024 = query.getOrDefault("filter")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "filter", valid_598024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598025: Call_AlertcenterAlertsFeedbackList_598008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_598025.validator(path, query, header, formData, body)
  let scheme = call_598025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598025.url(scheme.get, call_598025.host, call_598025.base,
                         call_598025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598025, url, valid)

proc call*(call_598026: Call_AlertcenterAlertsFeedbackList_598008; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## alertcenterAlertsFeedbackList
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert feedback are associated with.
  ## Inferred from the caller identity if not provided.
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
  ##   alertId: string (required)
  ##          : Required. The alert identifier.
  ## The "-" wildcard could be used to represent all alerts.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. A query string for filtering alert feedback results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.feedback.list).
  var path_598027 = newJObject()
  var query_598028 = newJObject()
  add(query_598028, "upload_protocol", newJString(uploadProtocol))
  add(query_598028, "fields", newJString(fields))
  add(query_598028, "quotaUser", newJString(quotaUser))
  add(query_598028, "alt", newJString(alt))
  add(query_598028, "customerId", newJString(customerId))
  add(query_598028, "oauth_token", newJString(oauthToken))
  add(query_598028, "callback", newJString(callback))
  add(query_598028, "access_token", newJString(accessToken))
  add(query_598028, "uploadType", newJString(uploadType))
  add(query_598028, "key", newJString(key))
  add(path_598027, "alertId", newJString(alertId))
  add(query_598028, "$.xgafv", newJString(Xgafv))
  add(query_598028, "prettyPrint", newJBool(prettyPrint))
  add(query_598028, "filter", newJString(filter))
  result = call_598026.call(path_598027, query_598028, nil, nil, nil)

var alertcenterAlertsFeedbackList* = Call_AlertcenterAlertsFeedbackList_598008(
    name: "alertcenterAlertsFeedbackList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackList_598009, base: "/",
    url: url_AlertcenterAlertsFeedbackList_598010, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGetMetadata_598051 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsGetMetadata_598053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AlertcenterAlertsGetMetadata_598052(path: JsonNode; query: JsonNode;
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
  var valid_598054 = path.getOrDefault("alertId")
  valid_598054 = validateParameter(valid_598054, JString, required = true,
                                 default = nil)
  if valid_598054 != nil:
    section.add "alertId", valid_598054
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
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert metadata is associated with.
  ## Inferred from the caller identity if not provided.
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
  section = newJObject()
  var valid_598055 = query.getOrDefault("upload_protocol")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "upload_protocol", valid_598055
  var valid_598056 = query.getOrDefault("fields")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "fields", valid_598056
  var valid_598057 = query.getOrDefault("quotaUser")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "quotaUser", valid_598057
  var valid_598058 = query.getOrDefault("alt")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = newJString("json"))
  if valid_598058 != nil:
    section.add "alt", valid_598058
  var valid_598059 = query.getOrDefault("customerId")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "customerId", valid_598059
  var valid_598060 = query.getOrDefault("oauth_token")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "oauth_token", valid_598060
  var valid_598061 = query.getOrDefault("callback")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "callback", valid_598061
  var valid_598062 = query.getOrDefault("access_token")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "access_token", valid_598062
  var valid_598063 = query.getOrDefault("uploadType")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "uploadType", valid_598063
  var valid_598064 = query.getOrDefault("key")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "key", valid_598064
  var valid_598065 = query.getOrDefault("$.xgafv")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = newJString("1"))
  if valid_598065 != nil:
    section.add "$.xgafv", valid_598065
  var valid_598066 = query.getOrDefault("prettyPrint")
  valid_598066 = validateParameter(valid_598066, JBool, required = false,
                                 default = newJBool(true))
  if valid_598066 != nil:
    section.add "prettyPrint", valid_598066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598067: Call_AlertcenterAlertsGetMetadata_598051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_598067.validator(path, query, header, formData, body)
  let scheme = call_598067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598067.url(scheme.get, call_598067.host, call_598067.base,
                         call_598067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598067, url, valid)

proc call*(call_598068: Call_AlertcenterAlertsGetMetadata_598051; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsGetMetadata
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert metadata is associated with.
  ## Inferred from the caller identity if not provided.
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
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert this metadata belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598069 = newJObject()
  var query_598070 = newJObject()
  add(query_598070, "upload_protocol", newJString(uploadProtocol))
  add(query_598070, "fields", newJString(fields))
  add(query_598070, "quotaUser", newJString(quotaUser))
  add(query_598070, "alt", newJString(alt))
  add(query_598070, "customerId", newJString(customerId))
  add(query_598070, "oauth_token", newJString(oauthToken))
  add(query_598070, "callback", newJString(callback))
  add(query_598070, "access_token", newJString(accessToken))
  add(query_598070, "uploadType", newJString(uploadType))
  add(query_598070, "key", newJString(key))
  add(path_598069, "alertId", newJString(alertId))
  add(query_598070, "$.xgafv", newJString(Xgafv))
  add(query_598070, "prettyPrint", newJBool(prettyPrint))
  result = call_598068.call(path_598069, query_598070, nil, nil, nil)

var alertcenterAlertsGetMetadata* = Call_AlertcenterAlertsGetMetadata_598051(
    name: "alertcenterAlertsGetMetadata", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/metadata",
    validator: validate_AlertcenterAlertsGetMetadata_598052, base: "/",
    url: url_AlertcenterAlertsGetMetadata_598053, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsUndelete_598071 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsUndelete_598073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AlertcenterAlertsUndelete_598072(path: JsonNode; query: JsonNode;
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
  var valid_598074 = path.getOrDefault("alertId")
  valid_598074 = validateParameter(valid_598074, JString, required = true,
                                 default = nil)
  if valid_598074 != nil:
    section.add "alertId", valid_598074
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
  section = newJObject()
  var valid_598075 = query.getOrDefault("upload_protocol")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "upload_protocol", valid_598075
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
  var valid_598080 = query.getOrDefault("callback")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "callback", valid_598080
  var valid_598081 = query.getOrDefault("access_token")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "access_token", valid_598081
  var valid_598082 = query.getOrDefault("uploadType")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "uploadType", valid_598082
  var valid_598083 = query.getOrDefault("key")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "key", valid_598083
  var valid_598084 = query.getOrDefault("$.xgafv")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = newJString("1"))
  if valid_598084 != nil:
    section.add "$.xgafv", valid_598084
  var valid_598085 = query.getOrDefault("prettyPrint")
  valid_598085 = validateParameter(valid_598085, JBool, required = false,
                                 default = newJBool(true))
  if valid_598085 != nil:
    section.add "prettyPrint", valid_598085
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

proc call*(call_598087: Call_AlertcenterAlertsUndelete_598071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ## 
  let valid = call_598087.validator(path, query, header, formData, body)
  let scheme = call_598087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598087.url(scheme.get, call_598087.host, call_598087.base,
                         call_598087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598087, url, valid)

proc call*(call_598088: Call_AlertcenterAlertsUndelete_598071; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsUndelete
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to undelete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598089 = newJObject()
  var query_598090 = newJObject()
  var body_598091 = newJObject()
  add(query_598090, "upload_protocol", newJString(uploadProtocol))
  add(query_598090, "fields", newJString(fields))
  add(query_598090, "quotaUser", newJString(quotaUser))
  add(query_598090, "alt", newJString(alt))
  add(query_598090, "oauth_token", newJString(oauthToken))
  add(query_598090, "callback", newJString(callback))
  add(query_598090, "access_token", newJString(accessToken))
  add(query_598090, "uploadType", newJString(uploadType))
  add(query_598090, "key", newJString(key))
  add(path_598089, "alertId", newJString(alertId))
  add(query_598090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598091 = body
  add(query_598090, "prettyPrint", newJBool(prettyPrint))
  result = call_598088.call(path_598089, query_598090, nil, nil, body_598091)

var alertcenterAlertsUndelete* = Call_AlertcenterAlertsUndelete_598071(
    name: "alertcenterAlertsUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}:undelete",
    validator: validate_AlertcenterAlertsUndelete_598072, base: "/",
    url: url_AlertcenterAlertsUndelete_598073, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchDelete_598092 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsBatchDelete_598094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchDelete_598093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs batch delete operation on alerts.
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
  section = newJObject()
  var valid_598095 = query.getOrDefault("upload_protocol")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "upload_protocol", valid_598095
  var valid_598096 = query.getOrDefault("fields")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "fields", valid_598096
  var valid_598097 = query.getOrDefault("quotaUser")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "quotaUser", valid_598097
  var valid_598098 = query.getOrDefault("alt")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("json"))
  if valid_598098 != nil:
    section.add "alt", valid_598098
  var valid_598099 = query.getOrDefault("oauth_token")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "oauth_token", valid_598099
  var valid_598100 = query.getOrDefault("callback")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "callback", valid_598100
  var valid_598101 = query.getOrDefault("access_token")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "access_token", valid_598101
  var valid_598102 = query.getOrDefault("uploadType")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "uploadType", valid_598102
  var valid_598103 = query.getOrDefault("key")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "key", valid_598103
  var valid_598104 = query.getOrDefault("$.xgafv")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = newJString("1"))
  if valid_598104 != nil:
    section.add "$.xgafv", valid_598104
  var valid_598105 = query.getOrDefault("prettyPrint")
  valid_598105 = validateParameter(valid_598105, JBool, required = false,
                                 default = newJBool(true))
  if valid_598105 != nil:
    section.add "prettyPrint", valid_598105
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

proc call*(call_598107: Call_AlertcenterAlertsBatchDelete_598092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch delete operation on alerts.
  ## 
  let valid = call_598107.validator(path, query, header, formData, body)
  let scheme = call_598107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598107.url(scheme.get, call_598107.host, call_598107.base,
                         call_598107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598107, url, valid)

proc call*(call_598108: Call_AlertcenterAlertsBatchDelete_598092;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsBatchDelete
  ## Performs batch delete operation on alerts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_598109 = newJObject()
  var body_598110 = newJObject()
  add(query_598109, "upload_protocol", newJString(uploadProtocol))
  add(query_598109, "fields", newJString(fields))
  add(query_598109, "quotaUser", newJString(quotaUser))
  add(query_598109, "alt", newJString(alt))
  add(query_598109, "oauth_token", newJString(oauthToken))
  add(query_598109, "callback", newJString(callback))
  add(query_598109, "access_token", newJString(accessToken))
  add(query_598109, "uploadType", newJString(uploadType))
  add(query_598109, "key", newJString(key))
  add(query_598109, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598110 = body
  add(query_598109, "prettyPrint", newJBool(prettyPrint))
  result = call_598108.call(nil, query_598109, nil, nil, body_598110)

var alertcenterAlertsBatchDelete* = Call_AlertcenterAlertsBatchDelete_598092(
    name: "alertcenterAlertsBatchDelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchDelete",
    validator: validate_AlertcenterAlertsBatchDelete_598093, base: "/",
    url: url_AlertcenterAlertsBatchDelete_598094, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchUndelete_598111 = ref object of OpenApiRestCall_597408
proc url_AlertcenterAlertsBatchUndelete_598113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchUndelete_598112(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs batch undelete operation on alerts.
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
  section = newJObject()
  var valid_598114 = query.getOrDefault("upload_protocol")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "upload_protocol", valid_598114
  var valid_598115 = query.getOrDefault("fields")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "fields", valid_598115
  var valid_598116 = query.getOrDefault("quotaUser")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "quotaUser", valid_598116
  var valid_598117 = query.getOrDefault("alt")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = newJString("json"))
  if valid_598117 != nil:
    section.add "alt", valid_598117
  var valid_598118 = query.getOrDefault("oauth_token")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "oauth_token", valid_598118
  var valid_598119 = query.getOrDefault("callback")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "callback", valid_598119
  var valid_598120 = query.getOrDefault("access_token")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "access_token", valid_598120
  var valid_598121 = query.getOrDefault("uploadType")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "uploadType", valid_598121
  var valid_598122 = query.getOrDefault("key")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "key", valid_598122
  var valid_598123 = query.getOrDefault("$.xgafv")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = newJString("1"))
  if valid_598123 != nil:
    section.add "$.xgafv", valid_598123
  var valid_598124 = query.getOrDefault("prettyPrint")
  valid_598124 = validateParameter(valid_598124, JBool, required = false,
                                 default = newJBool(true))
  if valid_598124 != nil:
    section.add "prettyPrint", valid_598124
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

proc call*(call_598126: Call_AlertcenterAlertsBatchUndelete_598111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch undelete operation on alerts.
  ## 
  let valid = call_598126.validator(path, query, header, formData, body)
  let scheme = call_598126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598126.url(scheme.get, call_598126.host, call_598126.base,
                         call_598126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598126, url, valid)

proc call*(call_598127: Call_AlertcenterAlertsBatchUndelete_598111;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsBatchUndelete
  ## Performs batch undelete operation on alerts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_598128 = newJObject()
  var body_598129 = newJObject()
  add(query_598128, "upload_protocol", newJString(uploadProtocol))
  add(query_598128, "fields", newJString(fields))
  add(query_598128, "quotaUser", newJString(quotaUser))
  add(query_598128, "alt", newJString(alt))
  add(query_598128, "oauth_token", newJString(oauthToken))
  add(query_598128, "callback", newJString(callback))
  add(query_598128, "access_token", newJString(accessToken))
  add(query_598128, "uploadType", newJString(uploadType))
  add(query_598128, "key", newJString(key))
  add(query_598128, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598129 = body
  add(query_598128, "prettyPrint", newJBool(prettyPrint))
  result = call_598127.call(nil, query_598128, nil, nil, body_598129)

var alertcenterAlertsBatchUndelete* = Call_AlertcenterAlertsBatchUndelete_598111(
    name: "alertcenterAlertsBatchUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchUndelete",
    validator: validate_AlertcenterAlertsBatchUndelete_598112, base: "/",
    url: url_AlertcenterAlertsBatchUndelete_598113, schemes: {Scheme.Https})
type
  Call_AlertcenterGetSettings_598130 = ref object of OpenApiRestCall_597408
proc url_AlertcenterGetSettings_598132(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlertcenterGetSettings_598131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns customer-level settings.
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
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
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
  section = newJObject()
  var valid_598133 = query.getOrDefault("upload_protocol")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "upload_protocol", valid_598133
  var valid_598134 = query.getOrDefault("fields")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "fields", valid_598134
  var valid_598135 = query.getOrDefault("quotaUser")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "quotaUser", valid_598135
  var valid_598136 = query.getOrDefault("alt")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = newJString("json"))
  if valid_598136 != nil:
    section.add "alt", valid_598136
  var valid_598137 = query.getOrDefault("customerId")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "customerId", valid_598137
  var valid_598138 = query.getOrDefault("oauth_token")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "oauth_token", valid_598138
  var valid_598139 = query.getOrDefault("callback")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "callback", valid_598139
  var valid_598140 = query.getOrDefault("access_token")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "access_token", valid_598140
  var valid_598141 = query.getOrDefault("uploadType")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "uploadType", valid_598141
  var valid_598142 = query.getOrDefault("key")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "key", valid_598142
  var valid_598143 = query.getOrDefault("$.xgafv")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = newJString("1"))
  if valid_598143 != nil:
    section.add "$.xgafv", valid_598143
  var valid_598144 = query.getOrDefault("prettyPrint")
  valid_598144 = validateParameter(valid_598144, JBool, required = false,
                                 default = newJBool(true))
  if valid_598144 != nil:
    section.add "prettyPrint", valid_598144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598145: Call_AlertcenterGetSettings_598130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns customer-level settings.
  ## 
  let valid = call_598145.validator(path, query, header, formData, body)
  let scheme = call_598145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598145.url(scheme.get, call_598145.host, call_598145.base,
                         call_598145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598145, url, valid)

proc call*(call_598146: Call_AlertcenterGetSettings_598130;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterGetSettings
  ## Returns customer-level settings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598147 = newJObject()
  add(query_598147, "upload_protocol", newJString(uploadProtocol))
  add(query_598147, "fields", newJString(fields))
  add(query_598147, "quotaUser", newJString(quotaUser))
  add(query_598147, "alt", newJString(alt))
  add(query_598147, "customerId", newJString(customerId))
  add(query_598147, "oauth_token", newJString(oauthToken))
  add(query_598147, "callback", newJString(callback))
  add(query_598147, "access_token", newJString(accessToken))
  add(query_598147, "uploadType", newJString(uploadType))
  add(query_598147, "key", newJString(key))
  add(query_598147, "$.xgafv", newJString(Xgafv))
  add(query_598147, "prettyPrint", newJBool(prettyPrint))
  result = call_598146.call(nil, query_598147, nil, nil, nil)

var alertcenterGetSettings* = Call_AlertcenterGetSettings_598130(
    name: "alertcenterGetSettings", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterGetSettings_598131, base: "/",
    url: url_AlertcenterGetSettings_598132, schemes: {Scheme.Https})
type
  Call_AlertcenterUpdateSettings_598148 = ref object of OpenApiRestCall_597408
proc url_AlertcenterUpdateSettings_598150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlertcenterUpdateSettings_598149(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the customer-level settings.
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
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
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
  section = newJObject()
  var valid_598151 = query.getOrDefault("upload_protocol")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "upload_protocol", valid_598151
  var valid_598152 = query.getOrDefault("fields")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "fields", valid_598152
  var valid_598153 = query.getOrDefault("quotaUser")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "quotaUser", valid_598153
  var valid_598154 = query.getOrDefault("alt")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = newJString("json"))
  if valid_598154 != nil:
    section.add "alt", valid_598154
  var valid_598155 = query.getOrDefault("customerId")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "customerId", valid_598155
  var valid_598156 = query.getOrDefault("oauth_token")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "oauth_token", valid_598156
  var valid_598157 = query.getOrDefault("callback")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "callback", valid_598157
  var valid_598158 = query.getOrDefault("access_token")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "access_token", valid_598158
  var valid_598159 = query.getOrDefault("uploadType")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "uploadType", valid_598159
  var valid_598160 = query.getOrDefault("key")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "key", valid_598160
  var valid_598161 = query.getOrDefault("$.xgafv")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = newJString("1"))
  if valid_598161 != nil:
    section.add "$.xgafv", valid_598161
  var valid_598162 = query.getOrDefault("prettyPrint")
  valid_598162 = validateParameter(valid_598162, JBool, required = false,
                                 default = newJBool(true))
  if valid_598162 != nil:
    section.add "prettyPrint", valid_598162
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

proc call*(call_598164: Call_AlertcenterUpdateSettings_598148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the customer-level settings.
  ## 
  let valid = call_598164.validator(path, query, header, formData, body)
  let scheme = call_598164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598164.url(scheme.get, call_598164.host, call_598164.base,
                         call_598164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598164, url, valid)

proc call*(call_598165: Call_AlertcenterUpdateSettings_598148;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## alertcenterUpdateSettings
  ## Updates the customer-level settings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
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
  var query_598166 = newJObject()
  var body_598167 = newJObject()
  add(query_598166, "upload_protocol", newJString(uploadProtocol))
  add(query_598166, "fields", newJString(fields))
  add(query_598166, "quotaUser", newJString(quotaUser))
  add(query_598166, "alt", newJString(alt))
  add(query_598166, "customerId", newJString(customerId))
  add(query_598166, "oauth_token", newJString(oauthToken))
  add(query_598166, "callback", newJString(callback))
  add(query_598166, "access_token", newJString(accessToken))
  add(query_598166, "uploadType", newJString(uploadType))
  add(query_598166, "key", newJString(key))
  add(query_598166, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598167 = body
  add(query_598166, "prettyPrint", newJBool(prettyPrint))
  result = call_598165.call(nil, query_598166, nil, nil, body_598167)

var alertcenterUpdateSettings* = Call_AlertcenterUpdateSettings_598148(
    name: "alertcenterUpdateSettings", meth: HttpMethod.HttpPatch,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterUpdateSettings_598149, base: "/",
    url: url_AlertcenterUpdateSettings_598150, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
