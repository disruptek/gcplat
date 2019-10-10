
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: BigQuery Reservation
## version: v1alpha2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## A service to modify your BigQuery flat-rate reservations.
## 
## https://cloud.google.com/bigquery/
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "bigqueryreservation"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588710 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588712(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588711(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about the slot pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the slot pool to retrieve. E.g.,
  ##    
  ## projects/myproject/locations/us-central1/reservations/my_reservation/slotPools/123
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the slot pool.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsSlotPoolsGet
  ## Returns information about the slot pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the slot pool to retrieve. E.g.,
  ##    
  ## projects/myproject/locations/us-central1/reservations/my_reservation/slotPools/123
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsSlotPoolsGet* = Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588710(
    name: "bigqueryreservationProjectsLocationsReservationsSlotPoolsGet",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{name}", validator: validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588711,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_588712,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsPatch_589018 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsPatch_589020(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsPatch_589019(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing reservation resource. Applicable only for child
  ## reservations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the reservation, e.g.,
  ## "projects/*/locations/*/reservations/dev/team/product". Reservation names
  ## (e.g., "dev/team/product") exceeding a depth of six will fail with
  ## `google.rpc.Code.INVALID_ARGUMENT`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589021 = path.getOrDefault("name")
  valid_589021 = validateParameter(valid_589021, JString, required = true,
                                 default = nil)
  if valid_589021 != nil:
    section.add "name", valid_589021
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
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  section = newJObject()
  var valid_589022 = query.getOrDefault("upload_protocol")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "upload_protocol", valid_589022
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("callback")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "callback", valid_589027
  var valid_589028 = query.getOrDefault("access_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "access_token", valid_589028
  var valid_589029 = query.getOrDefault("uploadType")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "uploadType", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("$.xgafv")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("1"))
  if valid_589031 != nil:
    section.add "$.xgafv", valid_589031
  var valid_589032 = query.getOrDefault("prettyPrint")
  valid_589032 = validateParameter(valid_589032, JBool, required = false,
                                 default = newJBool(true))
  if valid_589032 != nil:
    section.add "prettyPrint", valid_589032
  var valid_589033 = query.getOrDefault("updateMask")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "updateMask", valid_589033
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

proc call*(call_589035: Call_BigqueryreservationProjectsLocationsReservationsPatch_589018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing reservation resource. Applicable only for child
  ## reservations.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_BigqueryreservationProjectsLocationsReservationsPatch_589018;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsPatch
  ## Updates an existing reservation resource. Applicable only for child
  ## reservations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the reservation, e.g.,
  ## "projects/*/locations/*/reservations/dev/team/product". Reservation names
  ## (e.g., "dev/team/product") exceeding a depth of six will fail with
  ## `google.rpc.Code.INVALID_ARGUMENT`.
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
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  var body_589039 = newJObject()
  add(query_589038, "upload_protocol", newJString(uploadProtocol))
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(path_589037, "name", newJString(name))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "callback", newJString(callback))
  add(query_589038, "access_token", newJString(accessToken))
  add(query_589038, "uploadType", newJString(uploadType))
  add(query_589038, "key", newJString(key))
  add(query_589038, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589039 = body
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  add(query_589038, "updateMask", newJString(updateMask))
  result = call_589036.call(path_589037, query_589038, nil, nil, body_589039)

var bigqueryreservationProjectsLocationsReservationsPatch* = Call_BigqueryreservationProjectsLocationsReservationsPatch_589018(
    name: "bigqueryreservationProjectsLocationsReservationsPatch",
    meth: HttpMethod.HttpPatch, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsPatch_589019,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsPatch_589020,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_588998 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationGrantsDelete_589000(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationGrantsDelete_588999(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a reservation grant. No expansion will happen.
  ## E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateReservationGrant was invoked previously and following grants were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then deletion of <organizationA, res1> won't affect <project1, res1>. After
  ## deletion of <organizationA, res1>, queries from project1 will still use
  ## res1, while queries from project2 will use on-demand mode.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource, e.g.:
  ##   projects/myproject/locations/eu/reservationGrants/123
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: JBool
  ##        : If true, deletes all the child reservations of the given reservation.
  ## Otherwise, attempting to delete a reservation that has child
  ## reservations will fail with error code
  ## `google.rpc.Code.FAILED_PRECONDITION`.
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("force")
  valid_589004 = validateParameter(valid_589004, JBool, required = false, default = nil)
  if valid_589004 != nil:
    section.add "force", valid_589004
  var valid_589005 = query.getOrDefault("quotaUser")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "quotaUser", valid_589005
  var valid_589006 = query.getOrDefault("alt")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("json"))
  if valid_589006 != nil:
    section.add "alt", valid_589006
  var valid_589007 = query.getOrDefault("oauth_token")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "oauth_token", valid_589007
  var valid_589008 = query.getOrDefault("callback")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "callback", valid_589008
  var valid_589009 = query.getOrDefault("access_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "access_token", valid_589009
  var valid_589010 = query.getOrDefault("uploadType")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "uploadType", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589014: Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a reservation grant. No expansion will happen.
  ## E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateReservationGrant was invoked previously and following grants were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then deletion of <organizationA, res1> won't affect <project1, res1>. After
  ## deletion of <organizationA, res1>, queries from project1 will still use
  ## res1, while queries from project2 will use on-demand mode.
  ## 
  let valid = call_589014.validator(path, query, header, formData, body)
  let scheme = call_589014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589014.url(scheme.get, call_589014.host, call_589014.base,
                         call_589014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589014, url, valid)

proc call*(call_589015: Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_588998;
          name: string; uploadProtocol: string = ""; fields: string = "";
          force: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationGrantsDelete
  ## Deletes a reservation grant. No expansion will happen.
  ## E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateReservationGrant was invoked previously and following grants were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then deletion of <organizationA, res1> won't affect <project1, res1>. After
  ## deletion of <organizationA, res1>, queries from project1 will still use
  ## res1, while queries from project2 will use on-demand mode.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: bool
  ##        : If true, deletes all the child reservations of the given reservation.
  ## Otherwise, attempting to delete a reservation that has child
  ## reservations will fail with error code
  ## `google.rpc.Code.FAILED_PRECONDITION`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the resource, e.g.:
  ##   projects/myproject/locations/eu/reservationGrants/123
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589016 = newJObject()
  var query_589017 = newJObject()
  add(query_589017, "upload_protocol", newJString(uploadProtocol))
  add(query_589017, "fields", newJString(fields))
  add(query_589017, "force", newJBool(force))
  add(query_589017, "quotaUser", newJString(quotaUser))
  add(path_589016, "name", newJString(name))
  add(query_589017, "alt", newJString(alt))
  add(query_589017, "oauth_token", newJString(oauthToken))
  add(query_589017, "callback", newJString(callback))
  add(query_589017, "access_token", newJString(accessToken))
  add(query_589017, "uploadType", newJString(uploadType))
  add(query_589017, "key", newJString(key))
  add(query_589017, "$.xgafv", newJString(Xgafv))
  add(query_589017, "prettyPrint", newJBool(prettyPrint))
  result = call_589015.call(path_589016, query_589017, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationGrantsDelete* = Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_588998(
    name: "bigqueryreservationProjectsLocationsReservationGrantsDelete",
    meth: HttpMethod.HttpDelete, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{name}", validator: validate_BigqueryreservationProjectsLocationsReservationGrantsDelete_588999,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationGrantsDelete_589000,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_589040 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsCreateReservation_589042(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsCreateReservation_589041(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Project, location, and (optionally) reservation name. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/parent
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589043 = path.getOrDefault("parent")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "parent", valid_589043
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
  ##   reservationId: JString
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("callback")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "callback", valid_589049
  var valid_589050 = query.getOrDefault("access_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "access_token", valid_589050
  var valid_589051 = query.getOrDefault("uploadType")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "uploadType", valid_589051
  var valid_589052 = query.getOrDefault("reservationId")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "reservationId", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
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

proc call*(call_589057: Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_589040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_589040;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          reservationId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsCreateReservation
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
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
  ##   parent: string (required)
  ##         : Project, location, and (optionally) reservation name. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/parent
  ##   reservationId: string
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  var body_589061 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(path_589059, "parent", newJString(parent))
  add(query_589060, "reservationId", newJString(reservationId))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589061 = body
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(path_589059, query_589060, nil, nil, body_589061)

var bigqueryreservationProjectsLocationsReservationsCreateReservation* = Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_589040(
    name: "bigqueryreservationProjectsLocationsReservationsCreateReservation",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}", validator: validate_BigqueryreservationProjectsLocationsReservationsCreateReservation_589041,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsCreateReservation_589042,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_589083 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationGrantsCreate_589085(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/reservationGrants")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationGrantsCreate_589084(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the grant
  ## does not match location of the reservation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name of the reservation grant
  ## E.g.: projects/myproject/location/eu.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589086 = path.getOrDefault("parent")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "parent", valid_589086
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
  var valid_589087 = query.getOrDefault("upload_protocol")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "upload_protocol", valid_589087
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("callback")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "callback", valid_589092
  var valid_589093 = query.getOrDefault("access_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "access_token", valid_589093
  var valid_589094 = query.getOrDefault("uploadType")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "uploadType", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("$.xgafv")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("1"))
  if valid_589096 != nil:
    section.add "$.xgafv", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
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

proc call*(call_589099: Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_589083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the grant
  ## does not match location of the reservation.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_589083;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationGrantsCreate
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the grant
  ## does not match location of the reservation.
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
  ##   parent: string (required)
  ##         : The parent resource name of the reservation grant
  ## E.g.: projects/myproject/location/eu.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  var body_589103 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(path_589101, "parent", newJString(parent))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589103 = body
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  result = call_589100.call(path_589101, query_589102, nil, nil, body_589103)

var bigqueryreservationProjectsLocationsReservationGrantsCreate* = Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_589083(
    name: "bigqueryreservationProjectsLocationsReservationGrantsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservationGrants", validator: validate_BigqueryreservationProjectsLocationsReservationGrantsCreate_589084,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationGrantsCreate_589085,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationGrantsList_589062 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationGrantsList_589064(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/reservationGrants")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationGrantsList_589063(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists reservation grants.
  ## Only explicitly created grants will be returned. E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateReservationGrant was invoked previously and following grants were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then this API will just return the above two grants for reservation res1,
  ## and no expansion/merge will happen.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name e.g.: projects/myproject/location/eu.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589065 = path.getOrDefault("parent")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "parent", valid_589065
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589066 = query.getOrDefault("upload_protocol")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "upload_protocol", valid_589066
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
  var valid_589068 = query.getOrDefault("pageToken")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "pageToken", valid_589068
  var valid_589069 = query.getOrDefault("quotaUser")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "quotaUser", valid_589069
  var valid_589070 = query.getOrDefault("alt")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("json"))
  if valid_589070 != nil:
    section.add "alt", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("callback")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "callback", valid_589072
  var valid_589073 = query.getOrDefault("access_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "access_token", valid_589073
  var valid_589074 = query.getOrDefault("uploadType")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "uploadType", valid_589074
  var valid_589075 = query.getOrDefault("key")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "key", valid_589075
  var valid_589076 = query.getOrDefault("$.xgafv")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("1"))
  if valid_589076 != nil:
    section.add "$.xgafv", valid_589076
  var valid_589077 = query.getOrDefault("pageSize")
  valid_589077 = validateParameter(valid_589077, JInt, required = false, default = nil)
  if valid_589077 != nil:
    section.add "pageSize", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589079: Call_BigqueryreservationProjectsLocationsReservationGrantsList_589062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists reservation grants.
  ## Only explicitly created grants will be returned. E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateReservationGrant was invoked previously and following grants were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then this API will just return the above two grants for reservation res1,
  ## and no expansion/merge will happen.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_BigqueryreservationProjectsLocationsReservationGrantsList_589062;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationGrantsList
  ## Lists reservation grants.
  ## Only explicitly created grants will be returned. E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateReservationGrant was invoked previously and following grants were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then this API will just return the above two grants for reservation res1,
  ## and no expansion/merge will happen.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   parent: string (required)
  ##         : The parent resource name e.g.: projects/myproject/location/eu.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "pageToken", newJString(pageToken))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(path_589081, "parent", newJString(parent))
  add(query_589082, "key", newJString(key))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  add(query_589082, "pageSize", newJInt(pageSize))
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationGrantsList* = Call_BigqueryreservationProjectsLocationsReservationGrantsList_589062(
    name: "bigqueryreservationProjectsLocationsReservationGrantsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservationGrants", validator: validate_BigqueryreservationProjectsLocationsReservationGrantsList_589063,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationGrantsList_589064,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsCreate_589126 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsCreate_589128(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/reservations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsCreate_589127(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Project, location, and (optionally) reservation name. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/parent
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589129 = path.getOrDefault("parent")
  valid_589129 = validateParameter(valid_589129, JString, required = true,
                                 default = nil)
  if valid_589129 != nil:
    section.add "parent", valid_589129
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
  ##   reservationId: JString
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589130 = query.getOrDefault("upload_protocol")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "upload_protocol", valid_589130
  var valid_589131 = query.getOrDefault("fields")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "fields", valid_589131
  var valid_589132 = query.getOrDefault("quotaUser")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "quotaUser", valid_589132
  var valid_589133 = query.getOrDefault("alt")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("json"))
  if valid_589133 != nil:
    section.add "alt", valid_589133
  var valid_589134 = query.getOrDefault("oauth_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "oauth_token", valid_589134
  var valid_589135 = query.getOrDefault("callback")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "callback", valid_589135
  var valid_589136 = query.getOrDefault("access_token")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "access_token", valid_589136
  var valid_589137 = query.getOrDefault("uploadType")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "uploadType", valid_589137
  var valid_589138 = query.getOrDefault("reservationId")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "reservationId", valid_589138
  var valid_589139 = query.getOrDefault("key")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "key", valid_589139
  var valid_589140 = query.getOrDefault("$.xgafv")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("1"))
  if valid_589140 != nil:
    section.add "$.xgafv", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
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

proc call*(call_589143: Call_BigqueryreservationProjectsLocationsReservationsCreate_589126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_BigqueryreservationProjectsLocationsReservationsCreate_589126;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          reservationId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsCreate
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
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
  ##   parent: string (required)
  ##         : Project, location, and (optionally) reservation name. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/parent
  ##   reservationId: string
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  var body_589147 = newJObject()
  add(query_589146, "upload_protocol", newJString(uploadProtocol))
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(query_589146, "callback", newJString(callback))
  add(query_589146, "access_token", newJString(accessToken))
  add(query_589146, "uploadType", newJString(uploadType))
  add(path_589145, "parent", newJString(parent))
  add(query_589146, "reservationId", newJString(reservationId))
  add(query_589146, "key", newJString(key))
  add(query_589146, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589147 = body
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(path_589145, query_589146, nil, nil, body_589147)

var bigqueryreservationProjectsLocationsReservationsCreate* = Call_BigqueryreservationProjectsLocationsReservationsCreate_589126(
    name: "bigqueryreservationProjectsLocationsReservationsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsCreate_589127,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsCreate_589128,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsList_589104 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsList_589106(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/reservations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsList_589105(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the reservations for the project in the specified location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name containing project and location, e.g.:
  ##   "projects/myproject/locations/us-central1"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589107 = path.getOrDefault("parent")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "parent", valid_589107
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  section = newJObject()
  var valid_589108 = query.getOrDefault("upload_protocol")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "upload_protocol", valid_589108
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("pageToken")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "pageToken", valid_589110
  var valid_589111 = query.getOrDefault("quotaUser")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "quotaUser", valid_589111
  var valid_589112 = query.getOrDefault("alt")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = newJString("json"))
  if valid_589112 != nil:
    section.add "alt", valid_589112
  var valid_589113 = query.getOrDefault("oauth_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "oauth_token", valid_589113
  var valid_589114 = query.getOrDefault("callback")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "callback", valid_589114
  var valid_589115 = query.getOrDefault("access_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "access_token", valid_589115
  var valid_589116 = query.getOrDefault("uploadType")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "uploadType", valid_589116
  var valid_589117 = query.getOrDefault("key")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "key", valid_589117
  var valid_589118 = query.getOrDefault("$.xgafv")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = newJString("1"))
  if valid_589118 != nil:
    section.add "$.xgafv", valid_589118
  var valid_589119 = query.getOrDefault("pageSize")
  valid_589119 = validateParameter(valid_589119, JInt, required = false, default = nil)
  if valid_589119 != nil:
    section.add "pageSize", valid_589119
  var valid_589120 = query.getOrDefault("prettyPrint")
  valid_589120 = validateParameter(valid_589120, JBool, required = false,
                                 default = newJBool(true))
  if valid_589120 != nil:
    section.add "prettyPrint", valid_589120
  var valid_589121 = query.getOrDefault("filter")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "filter", valid_589121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589122: Call_BigqueryreservationProjectsLocationsReservationsList_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the reservations for the project in the specified location.
  ## 
  let valid = call_589122.validator(path, query, header, formData, body)
  let scheme = call_589122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589122.url(scheme.get, call_589122.host, call_589122.base,
                         call_589122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589122, url, valid)

proc call*(call_589123: Call_BigqueryreservationProjectsLocationsReservationsList_589104;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsList
  ## Lists all the reservations for the project in the specified location.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   parent: string (required)
  ##         : The parent resource name containing project and location, e.g.:
  ##   "projects/myproject/locations/us-central1"
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  var path_589124 = newJObject()
  var query_589125 = newJObject()
  add(query_589125, "upload_protocol", newJString(uploadProtocol))
  add(query_589125, "fields", newJString(fields))
  add(query_589125, "pageToken", newJString(pageToken))
  add(query_589125, "quotaUser", newJString(quotaUser))
  add(query_589125, "alt", newJString(alt))
  add(query_589125, "oauth_token", newJString(oauthToken))
  add(query_589125, "callback", newJString(callback))
  add(query_589125, "access_token", newJString(accessToken))
  add(query_589125, "uploadType", newJString(uploadType))
  add(path_589124, "parent", newJString(parent))
  add(query_589125, "key", newJString(key))
  add(query_589125, "$.xgafv", newJString(Xgafv))
  add(query_589125, "pageSize", newJInt(pageSize))
  add(query_589125, "prettyPrint", newJBool(prettyPrint))
  add(query_589125, "filter", newJString(filter))
  result = call_589123.call(path_589124, query_589125, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsList* = Call_BigqueryreservationProjectsLocationsReservationsList_589104(
    name: "bigqueryreservationProjectsLocationsReservationsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsList_589105,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsList_589106,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589148 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589150(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/slotPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589149(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the slot pools for the reservation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the parent reservation. Only top-level reservations can
  ## have slot pools. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/my_reservation
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589151 = path.getOrDefault("parent")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "parent", valid_589151
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589152 = query.getOrDefault("upload_protocol")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "upload_protocol", valid_589152
  var valid_589153 = query.getOrDefault("fields")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "fields", valid_589153
  var valid_589154 = query.getOrDefault("pageToken")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "pageToken", valid_589154
  var valid_589155 = query.getOrDefault("quotaUser")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "quotaUser", valid_589155
  var valid_589156 = query.getOrDefault("alt")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("json"))
  if valid_589156 != nil:
    section.add "alt", valid_589156
  var valid_589157 = query.getOrDefault("oauth_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "oauth_token", valid_589157
  var valid_589158 = query.getOrDefault("callback")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "callback", valid_589158
  var valid_589159 = query.getOrDefault("access_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "access_token", valid_589159
  var valid_589160 = query.getOrDefault("uploadType")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "uploadType", valid_589160
  var valid_589161 = query.getOrDefault("key")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "key", valid_589161
  var valid_589162 = query.getOrDefault("$.xgafv")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = newJString("1"))
  if valid_589162 != nil:
    section.add "$.xgafv", valid_589162
  var valid_589163 = query.getOrDefault("pageSize")
  valid_589163 = validateParameter(valid_589163, JInt, required = false, default = nil)
  if valid_589163 != nil:
    section.add "pageSize", valid_589163
  var valid_589164 = query.getOrDefault("prettyPrint")
  valid_589164 = validateParameter(valid_589164, JBool, required = false,
                                 default = newJBool(true))
  if valid_589164 != nil:
    section.add "prettyPrint", valid_589164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589165: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the slot pools for the reservation.
  ## 
  let valid = call_589165.validator(path, query, header, formData, body)
  let scheme = call_589165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589165.url(scheme.get, call_589165.host, call_589165.base,
                         call_589165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589165, url, valid)

proc call*(call_589166: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589148;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsSlotPoolsList
  ## Lists all the slot pools for the reservation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   parent: string (required)
  ##         : Resource name of the parent reservation. Only top-level reservations can
  ## have slot pools. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/my_reservation
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589167 = newJObject()
  var query_589168 = newJObject()
  add(query_589168, "upload_protocol", newJString(uploadProtocol))
  add(query_589168, "fields", newJString(fields))
  add(query_589168, "pageToken", newJString(pageToken))
  add(query_589168, "quotaUser", newJString(quotaUser))
  add(query_589168, "alt", newJString(alt))
  add(query_589168, "oauth_token", newJString(oauthToken))
  add(query_589168, "callback", newJString(callback))
  add(query_589168, "access_token", newJString(accessToken))
  add(query_589168, "uploadType", newJString(uploadType))
  add(path_589167, "parent", newJString(parent))
  add(query_589168, "key", newJString(key))
  add(query_589168, "$.xgafv", newJString(Xgafv))
  add(query_589168, "pageSize", newJInt(pageSize))
  add(query_589168, "prettyPrint", newJBool(prettyPrint))
  result = call_589166.call(path_589167, query_589168, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsSlotPoolsList* = Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589148(
    name: "bigqueryreservationProjectsLocationsReservationsSlotPoolsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/slotPools", validator: validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589149,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_589150,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsSearchReservationGrants_589169 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsSearchReservationGrants_589171(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":SearchReservationGrants")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsSearchReservationGrants_589170(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Look up grants for a specified resource for a particular region.
  ## If the request is about a project:
  ##   1) Grants created on the project will be returned if they exist.
  ##   2) Otherwise grants created on the closest ancestor will be returned.
  ##   3) Grants for different JobTypes will all be returned.
  ## Same logic applies if the request is about a folder.
  ## If the request is about an organization, then grants created on the
  ## organization will be returned (organization doesn't have ancestors).
  ## Comparing to ListReservationGrants, there are two behavior
  ## differences:
  ##   1) permission on the grantee will be verified in this API.
  ##   2) Hierarchy lookup (project->folder->organization) happens in this API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name (containing project and location), which owns the
  ## grants. e.g.:
  ##   "projects/myproject/locations/us-central1".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589172 = path.getOrDefault("parent")
  valid_589172 = validateParameter(valid_589172, JString, required = true,
                                 default = nil)
  if valid_589172 != nil:
    section.add "parent", valid_589172
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : Please specify resource name as grantee in the query.
  ## e.g., "grantee=projects/myproject"
  ##       "grantee=folders/123"
  ##       "grantee=organizations/456"
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
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589173 = query.getOrDefault("upload_protocol")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "upload_protocol", valid_589173
  var valid_589174 = query.getOrDefault("fields")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "fields", valid_589174
  var valid_589175 = query.getOrDefault("pageToken")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "pageToken", valid_589175
  var valid_589176 = query.getOrDefault("quotaUser")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "quotaUser", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("query")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "query", valid_589178
  var valid_589179 = query.getOrDefault("oauth_token")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "oauth_token", valid_589179
  var valid_589180 = query.getOrDefault("callback")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "callback", valid_589180
  var valid_589181 = query.getOrDefault("access_token")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "access_token", valid_589181
  var valid_589182 = query.getOrDefault("uploadType")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "uploadType", valid_589182
  var valid_589183 = query.getOrDefault("key")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "key", valid_589183
  var valid_589184 = query.getOrDefault("$.xgafv")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("1"))
  if valid_589184 != nil:
    section.add "$.xgafv", valid_589184
  var valid_589185 = query.getOrDefault("pageSize")
  valid_589185 = validateParameter(valid_589185, JInt, required = false, default = nil)
  if valid_589185 != nil:
    section.add "pageSize", valid_589185
  var valid_589186 = query.getOrDefault("prettyPrint")
  valid_589186 = validateParameter(valid_589186, JBool, required = false,
                                 default = newJBool(true))
  if valid_589186 != nil:
    section.add "prettyPrint", valid_589186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589187: Call_BigqueryreservationProjectsLocationsSearchReservationGrants_589169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Look up grants for a specified resource for a particular region.
  ## If the request is about a project:
  ##   1) Grants created on the project will be returned if they exist.
  ##   2) Otherwise grants created on the closest ancestor will be returned.
  ##   3) Grants for different JobTypes will all be returned.
  ## Same logic applies if the request is about a folder.
  ## If the request is about an organization, then grants created on the
  ## organization will be returned (organization doesn't have ancestors).
  ## Comparing to ListReservationGrants, there are two behavior
  ## differences:
  ##   1) permission on the grantee will be verified in this API.
  ##   2) Hierarchy lookup (project->folder->organization) happens in this API.
  ## 
  let valid = call_589187.validator(path, query, header, formData, body)
  let scheme = call_589187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589187.url(scheme.get, call_589187.host, call_589187.base,
                         call_589187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589187, url, valid)

proc call*(call_589188: Call_BigqueryreservationProjectsLocationsSearchReservationGrants_589169;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsSearchReservationGrants
  ## Look up grants for a specified resource for a particular region.
  ## If the request is about a project:
  ##   1) Grants created on the project will be returned if they exist.
  ##   2) Otherwise grants created on the closest ancestor will be returned.
  ##   3) Grants for different JobTypes will all be returned.
  ## Same logic applies if the request is about a folder.
  ## If the request is about an organization, then grants created on the
  ## organization will be returned (organization doesn't have ancestors).
  ## Comparing to ListReservationGrants, there are two behavior
  ## differences:
  ##   1) permission on the grantee will be verified in this API.
  ##   2) Hierarchy lookup (project->folder->organization) happens in this API.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : Please specify resource name as grantee in the query.
  ## e.g., "grantee=projects/myproject"
  ##       "grantee=folders/123"
  ##       "grantee=organizations/456"
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name (containing project and location), which owns the
  ## grants. e.g.:
  ##   "projects/myproject/locations/us-central1".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589189 = newJObject()
  var query_589190 = newJObject()
  add(query_589190, "upload_protocol", newJString(uploadProtocol))
  add(query_589190, "fields", newJString(fields))
  add(query_589190, "pageToken", newJString(pageToken))
  add(query_589190, "quotaUser", newJString(quotaUser))
  add(query_589190, "alt", newJString(alt))
  add(query_589190, "query", newJString(query))
  add(query_589190, "oauth_token", newJString(oauthToken))
  add(query_589190, "callback", newJString(callback))
  add(query_589190, "access_token", newJString(accessToken))
  add(query_589190, "uploadType", newJString(uploadType))
  add(path_589189, "parent", newJString(parent))
  add(query_589190, "key", newJString(key))
  add(query_589190, "$.xgafv", newJString(Xgafv))
  add(query_589190, "pageSize", newJInt(pageSize))
  add(query_589190, "prettyPrint", newJBool(prettyPrint))
  result = call_589188.call(path_589189, query_589190, nil, nil, nil)

var bigqueryreservationProjectsLocationsSearchReservationGrants* = Call_BigqueryreservationProjectsLocationsSearchReservationGrants_589169(
    name: "bigqueryreservationProjectsLocationsSearchReservationGrants",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}:SearchReservationGrants", validator: validate_BigqueryreservationProjectsLocationsSearchReservationGrants_589170,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsSearchReservationGrants_589171,
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
