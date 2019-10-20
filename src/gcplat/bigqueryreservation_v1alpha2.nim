
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
  gcpServiceName = "bigqueryreservation"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578610 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578612(
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

proc validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578611(
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the slot pool.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsSlotPoolsGet
  ## Returns information about the slot pool.
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
  ##   name: string (required)
  ##       : Resource name of the slot pool to retrieve. E.g.,
  ##    
  ## projects/myproject/locations/us-central1/reservations/my_reservation/slotPools/123
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsSlotPoolsGet* = Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578610(
    name: "bigqueryreservationProjectsLocationsReservationsSlotPoolsGet",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{name}", validator: validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578611,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsSlotPoolsGet_578612,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsPatch_578918 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsPatch_578920(
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

proc validate_BigqueryreservationProjectsLocationsReservationsPatch_578919(
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
  var valid_578921 = path.getOrDefault("name")
  valid_578921 = validateParameter(valid_578921, JString, required = true,
                                 default = nil)
  if valid_578921 != nil:
    section.add "name", valid_578921
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
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("prettyPrint")
  valid_578923 = validateParameter(valid_578923, JBool, required = false,
                                 default = newJBool(true))
  if valid_578923 != nil:
    section.add "prettyPrint", valid_578923
  var valid_578924 = query.getOrDefault("oauth_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "oauth_token", valid_578924
  var valid_578925 = query.getOrDefault("$.xgafv")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("1"))
  if valid_578925 != nil:
    section.add "$.xgafv", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("uploadType")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "uploadType", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("updateMask")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "updateMask", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
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

proc call*(call_578935: Call_BigqueryreservationProjectsLocationsReservationsPatch_578918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing reservation resource. Applicable only for child
  ## reservations.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_BigqueryreservationProjectsLocationsReservationsPatch_578918;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsPatch
  ## Updates an existing reservation resource. Applicable only for child
  ## reservations.
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
  ##   name: string (required)
  ##       : The resource name of the reservation, e.g.,
  ## "projects/*/locations/*/reservations/dev/team/product". Reservation names
  ## (e.g., "dev/team/product") exceeding a depth of six will fail with
  ## `google.rpc.Code.INVALID_ARGUMENT`.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  var body_578939 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(query_578938, "$.xgafv", newJString(Xgafv))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "uploadType", newJString(uploadType))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(path_578937, "name", newJString(name))
  add(query_578938, "updateMask", newJString(updateMask))
  if body != nil:
    body_578939 = body
  add(query_578938, "callback", newJString(callback))
  add(query_578938, "fields", newJString(fields))
  add(query_578938, "access_token", newJString(accessToken))
  add(query_578938, "upload_protocol", newJString(uploadProtocol))
  result = call_578936.call(path_578937, query_578938, nil, nil, body_578939)

var bigqueryreservationProjectsLocationsReservationsPatch* = Call_BigqueryreservationProjectsLocationsReservationsPatch_578918(
    name: "bigqueryreservationProjectsLocationsReservationsPatch",
    meth: HttpMethod.HttpPatch, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsPatch_578919,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsPatch_578920,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_578898 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationGrantsDelete_578900(
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

proc validate_BigqueryreservationProjectsLocationsReservationGrantsDelete_578899(
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
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
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
  ##   force: JBool
  ##        : If true, deletes all the child reservations of the given reservation.
  ## Otherwise, attempting to delete a reservation that has child
  ## reservations will fail with error code
  ## `google.rpc.Code.FAILED_PRECONDITION`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("force")
  valid_578909 = validateParameter(valid_578909, JBool, required = false, default = nil)
  if valid_578909 != nil:
    section.add "force", valid_578909
  var valid_578910 = query.getOrDefault("callback")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "callback", valid_578910
  var valid_578911 = query.getOrDefault("fields")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "fields", valid_578911
  var valid_578912 = query.getOrDefault("access_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "access_token", valid_578912
  var valid_578913 = query.getOrDefault("upload_protocol")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "upload_protocol", valid_578913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578914: Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_578898;
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
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; force: bool = false;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   name: string (required)
  ##       : Name of the resource, e.g.:
  ##   projects/myproject/locations/eu/reservationGrants/123
  ##   force: bool
  ##        : If true, deletes all the child reservations of the given reservation.
  ## Otherwise, attempting to delete a reservation that has child
  ## reservations will fail with error code
  ## `google.rpc.Code.FAILED_PRECONDITION`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578916 = newJObject()
  var query_578917 = newJObject()
  add(query_578917, "key", newJString(key))
  add(query_578917, "prettyPrint", newJBool(prettyPrint))
  add(query_578917, "oauth_token", newJString(oauthToken))
  add(query_578917, "$.xgafv", newJString(Xgafv))
  add(query_578917, "alt", newJString(alt))
  add(query_578917, "uploadType", newJString(uploadType))
  add(query_578917, "quotaUser", newJString(quotaUser))
  add(path_578916, "name", newJString(name))
  add(query_578917, "force", newJBool(force))
  add(query_578917, "callback", newJString(callback))
  add(query_578917, "fields", newJString(fields))
  add(query_578917, "access_token", newJString(accessToken))
  add(query_578917, "upload_protocol", newJString(uploadProtocol))
  result = call_578915.call(path_578916, query_578917, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationGrantsDelete* = Call_BigqueryreservationProjectsLocationsReservationGrantsDelete_578898(
    name: "bigqueryreservationProjectsLocationsReservationGrantsDelete",
    meth: HttpMethod.HttpDelete, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{name}", validator: validate_BigqueryreservationProjectsLocationsReservationGrantsDelete_578899,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationGrantsDelete_578900,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_578940 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsCreateReservation_578942(
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

proc validate_BigqueryreservationProjectsLocationsReservationsCreateReservation_578941(
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
  var valid_578943 = path.getOrDefault("parent")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "parent", valid_578943
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
  ##   reservationId: JString
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
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
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("$.xgafv")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("1"))
  if valid_578947 != nil:
    section.add "$.xgafv", valid_578947
  var valid_578948 = query.getOrDefault("reservationId")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "reservationId", valid_578948
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
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
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

proc call*(call_578957: Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_578940;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_578940;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; reservationId: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsCreateReservation
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   reservationId: string
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Project, location, and (optionally) reservation name. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/parent
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578959 = newJObject()
  var query_578960 = newJObject()
  var body_578961 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "$.xgafv", newJString(Xgafv))
  add(query_578960, "reservationId", newJString(reservationId))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "uploadType", newJString(uploadType))
  add(query_578960, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578961 = body
  add(query_578960, "callback", newJString(callback))
  add(path_578959, "parent", newJString(parent))
  add(query_578960, "fields", newJString(fields))
  add(query_578960, "access_token", newJString(accessToken))
  add(query_578960, "upload_protocol", newJString(uploadProtocol))
  result = call_578958.call(path_578959, query_578960, nil, nil, body_578961)

var bigqueryreservationProjectsLocationsReservationsCreateReservation* = Call_BigqueryreservationProjectsLocationsReservationsCreateReservation_578940(
    name: "bigqueryreservationProjectsLocationsReservationsCreateReservation",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}", validator: validate_BigqueryreservationProjectsLocationsReservationsCreateReservation_578941,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsCreateReservation_578942,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_578983 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationGrantsCreate_578985(
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

proc validate_BigqueryreservationProjectsLocationsReservationGrantsCreate_578984(
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
  var valid_578986 = path.getOrDefault("parent")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "parent", valid_578986
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
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("$.xgafv")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("1"))
  if valid_578990 != nil:
    section.add "$.xgafv", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("uploadType")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "uploadType", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  var valid_578994 = query.getOrDefault("callback")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "callback", valid_578994
  var valid_578995 = query.getOrDefault("fields")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "fields", valid_578995
  var valid_578996 = query.getOrDefault("access_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "access_token", valid_578996
  var valid_578997 = query.getOrDefault("upload_protocol")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "upload_protocol", valid_578997
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

proc call*(call_578999: Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_578983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the grant
  ## does not match location of the reservation.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_578983;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationGrantsCreate
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the grant
  ## does not match location of the reservation.
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
  ##   parent: string (required)
  ##         : The parent resource name of the reservation grant
  ## E.g.: projects/myproject/location/eu.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  var body_579003 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579003 = body
  add(query_579002, "callback", newJString(callback))
  add(path_579001, "parent", newJString(parent))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, body_579003)

var bigqueryreservationProjectsLocationsReservationGrantsCreate* = Call_BigqueryreservationProjectsLocationsReservationGrantsCreate_578983(
    name: "bigqueryreservationProjectsLocationsReservationGrantsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservationGrants", validator: validate_BigqueryreservationProjectsLocationsReservationGrantsCreate_578984,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationGrantsCreate_578985,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationGrantsList_578962 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationGrantsList_578964(
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

proc validate_BigqueryreservationProjectsLocationsReservationGrantsList_578963(
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
  var valid_578965 = path.getOrDefault("parent")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "parent", valid_578965
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
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  var valid_578970 = query.getOrDefault("pageSize")
  valid_578970 = validateParameter(valid_578970, JInt, required = false, default = nil)
  if valid_578970 != nil:
    section.add "pageSize", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("uploadType")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "uploadType", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("pageToken")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "pageToken", valid_578974
  var valid_578975 = query.getOrDefault("callback")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "callback", valid_578975
  var valid_578976 = query.getOrDefault("fields")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "fields", valid_578976
  var valid_578977 = query.getOrDefault("access_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "access_token", valid_578977
  var valid_578978 = query.getOrDefault("upload_protocol")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "upload_protocol", valid_578978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578979: Call_BigqueryreservationProjectsLocationsReservationGrantsList_578962;
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
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_BigqueryreservationProjectsLocationsReservationGrantsList_578962;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name e.g.: projects/myproject/location/eu.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "$.xgafv", newJString(Xgafv))
  add(query_578982, "pageSize", newJInt(pageSize))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "uploadType", newJString(uploadType))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(query_578982, "pageToken", newJString(pageToken))
  add(query_578982, "callback", newJString(callback))
  add(path_578981, "parent", newJString(parent))
  add(query_578982, "fields", newJString(fields))
  add(query_578982, "access_token", newJString(accessToken))
  add(query_578982, "upload_protocol", newJString(uploadProtocol))
  result = call_578980.call(path_578981, query_578982, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationGrantsList* = Call_BigqueryreservationProjectsLocationsReservationGrantsList_578962(
    name: "bigqueryreservationProjectsLocationsReservationGrantsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservationGrants", validator: validate_BigqueryreservationProjectsLocationsReservationGrantsList_578963,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationGrantsList_578964,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsCreate_579026 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsCreate_579028(
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

proc validate_BigqueryreservationProjectsLocationsReservationsCreate_579027(
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
  var valid_579029 = path.getOrDefault("parent")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = nil)
  if valid_579029 != nil:
    section.add "parent", valid_579029
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
  ##   reservationId: JString
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
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
  var valid_579030 = query.getOrDefault("key")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "key", valid_579030
  var valid_579031 = query.getOrDefault("prettyPrint")
  valid_579031 = validateParameter(valid_579031, JBool, required = false,
                                 default = newJBool(true))
  if valid_579031 != nil:
    section.add "prettyPrint", valid_579031
  var valid_579032 = query.getOrDefault("oauth_token")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "oauth_token", valid_579032
  var valid_579033 = query.getOrDefault("$.xgafv")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("1"))
  if valid_579033 != nil:
    section.add "$.xgafv", valid_579033
  var valid_579034 = query.getOrDefault("reservationId")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "reservationId", valid_579034
  var valid_579035 = query.getOrDefault("alt")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = newJString("json"))
  if valid_579035 != nil:
    section.add "alt", valid_579035
  var valid_579036 = query.getOrDefault("uploadType")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "uploadType", valid_579036
  var valid_579037 = query.getOrDefault("quotaUser")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "quotaUser", valid_579037
  var valid_579038 = query.getOrDefault("callback")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "callback", valid_579038
  var valid_579039 = query.getOrDefault("fields")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "fields", valid_579039
  var valid_579040 = query.getOrDefault("access_token")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "access_token", valid_579040
  var valid_579041 = query.getOrDefault("upload_protocol")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "upload_protocol", valid_579041
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

proc call*(call_579043: Call_BigqueryreservationProjectsLocationsReservationsCreate_579026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_BigqueryreservationProjectsLocationsReservationsCreate_579026;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; reservationId: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsCreate
  ## Creates a new reservation resource. Multiple reservations are created if
  ## the ancestor reservations do not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   reservationId: string
  ##                : The reservation ID relative to the parent, e.g., "dev". This field must
  ## only contain alphanumeric characters.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Project, location, and (optionally) reservation name. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/parent
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  var body_579047 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "$.xgafv", newJString(Xgafv))
  add(query_579046, "reservationId", newJString(reservationId))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "uploadType", newJString(uploadType))
  add(query_579046, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579047 = body
  add(query_579046, "callback", newJString(callback))
  add(path_579045, "parent", newJString(parent))
  add(query_579046, "fields", newJString(fields))
  add(query_579046, "access_token", newJString(accessToken))
  add(query_579046, "upload_protocol", newJString(uploadProtocol))
  result = call_579044.call(path_579045, query_579046, nil, nil, body_579047)

var bigqueryreservationProjectsLocationsReservationsCreate* = Call_BigqueryreservationProjectsLocationsReservationsCreate_579026(
    name: "bigqueryreservationProjectsLocationsReservationsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsCreate_579027,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsCreate_579028,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsList_579004 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsList_579006(
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

proc validate_BigqueryreservationProjectsLocationsReservationsList_579005(
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
  var valid_579007 = path.getOrDefault("parent")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "parent", valid_579007
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
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  var valid_579012 = query.getOrDefault("pageSize")
  valid_579012 = validateParameter(valid_579012, JInt, required = false, default = nil)
  if valid_579012 != nil:
    section.add "pageSize", valid_579012
  var valid_579013 = query.getOrDefault("alt")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("json"))
  if valid_579013 != nil:
    section.add "alt", valid_579013
  var valid_579014 = query.getOrDefault("uploadType")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "uploadType", valid_579014
  var valid_579015 = query.getOrDefault("quotaUser")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "quotaUser", valid_579015
  var valid_579016 = query.getOrDefault("filter")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "filter", valid_579016
  var valid_579017 = query.getOrDefault("pageToken")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "pageToken", valid_579017
  var valid_579018 = query.getOrDefault("callback")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "callback", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
  var valid_579020 = query.getOrDefault("access_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "access_token", valid_579020
  var valid_579021 = query.getOrDefault("upload_protocol")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "upload_protocol", valid_579021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579022: Call_BigqueryreservationProjectsLocationsReservationsList_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the reservations for the project in the specified location.
  ## 
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_BigqueryreservationProjectsLocationsReservationsList_579004;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsList
  ## Lists all the reservations for the project in the specified location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name containing project and location, e.g.:
  ##   "projects/myproject/locations/us-central1"
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579024 = newJObject()
  var query_579025 = newJObject()
  add(query_579025, "key", newJString(key))
  add(query_579025, "prettyPrint", newJBool(prettyPrint))
  add(query_579025, "oauth_token", newJString(oauthToken))
  add(query_579025, "$.xgafv", newJString(Xgafv))
  add(query_579025, "pageSize", newJInt(pageSize))
  add(query_579025, "alt", newJString(alt))
  add(query_579025, "uploadType", newJString(uploadType))
  add(query_579025, "quotaUser", newJString(quotaUser))
  add(query_579025, "filter", newJString(filter))
  add(query_579025, "pageToken", newJString(pageToken))
  add(query_579025, "callback", newJString(callback))
  add(path_579024, "parent", newJString(parent))
  add(query_579025, "fields", newJString(fields))
  add(query_579025, "access_token", newJString(accessToken))
  add(query_579025, "upload_protocol", newJString(uploadProtocol))
  result = call_579023.call(path_579024, query_579025, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsList* = Call_BigqueryreservationProjectsLocationsReservationsList_579004(
    name: "bigqueryreservationProjectsLocationsReservationsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsList_579005,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsList_579006,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579048 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579050(
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

proc validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579049(
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
  var valid_579051 = path.getOrDefault("parent")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "parent", valid_579051
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
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("$.xgafv")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("1"))
  if valid_579055 != nil:
    section.add "$.xgafv", valid_579055
  var valid_579056 = query.getOrDefault("pageSize")
  valid_579056 = validateParameter(valid_579056, JInt, required = false, default = nil)
  if valid_579056 != nil:
    section.add "pageSize", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("uploadType")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "uploadType", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("pageToken")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "pageToken", valid_579060
  var valid_579061 = query.getOrDefault("callback")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "callback", valid_579061
  var valid_579062 = query.getOrDefault("fields")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "fields", valid_579062
  var valid_579063 = query.getOrDefault("access_token")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "access_token", valid_579063
  var valid_579064 = query.getOrDefault("upload_protocol")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "upload_protocol", valid_579064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579065: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the slot pools for the reservation.
  ## 
  let valid = call_579065.validator(path, query, header, formData, body)
  let scheme = call_579065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579065.url(scheme.get, call_579065.host, call_579065.base,
                         call_579065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579065, url, valid)

proc call*(call_579066: Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579048;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsSlotPoolsList
  ## Lists all the slot pools for the reservation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Resource name of the parent reservation. Only top-level reservations can
  ## have slot pools. E.g.,
  ##    projects/myproject/locations/us-central1/reservations/my_reservation
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579067 = newJObject()
  var query_579068 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "$.xgafv", newJString(Xgafv))
  add(query_579068, "pageSize", newJInt(pageSize))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "uploadType", newJString(uploadType))
  add(query_579068, "quotaUser", newJString(quotaUser))
  add(query_579068, "pageToken", newJString(pageToken))
  add(query_579068, "callback", newJString(callback))
  add(path_579067, "parent", newJString(parent))
  add(query_579068, "fields", newJString(fields))
  add(query_579068, "access_token", newJString(accessToken))
  add(query_579068, "upload_protocol", newJString(uploadProtocol))
  result = call_579066.call(path_579067, query_579068, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsSlotPoolsList* = Call_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579048(
    name: "bigqueryreservationProjectsLocationsReservationsSlotPoolsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}/slotPools", validator: validate_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579049,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsSlotPoolsList_579050,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsSearchReservationGrants_579069 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsSearchReservationGrants_579071(
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

proc validate_BigqueryreservationProjectsLocationsSearchReservationGrants_579070(
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
  var valid_579072 = path.getOrDefault("parent")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "parent", valid_579072
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
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   query: JString
  ##        : Please specify resource name as grantee in the query.
  ## e.g., "grantee=projects/myproject"
  ##       "grantee=folders/123"
  ##       "grantee=organizations/456"
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("$.xgafv")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("1"))
  if valid_579076 != nil:
    section.add "$.xgafv", valid_579076
  var valid_579077 = query.getOrDefault("pageSize")
  valid_579077 = validateParameter(valid_579077, JInt, required = false, default = nil)
  if valid_579077 != nil:
    section.add "pageSize", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("uploadType")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "uploadType", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("pageToken")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "pageToken", valid_579081
  var valid_579082 = query.getOrDefault("query")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "query", valid_579082
  var valid_579083 = query.getOrDefault("callback")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "callback", valid_579083
  var valid_579084 = query.getOrDefault("fields")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "fields", valid_579084
  var valid_579085 = query.getOrDefault("access_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "access_token", valid_579085
  var valid_579086 = query.getOrDefault("upload_protocol")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "upload_protocol", valid_579086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579087: Call_BigqueryreservationProjectsLocationsSearchReservationGrants_579069;
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
  let valid = call_579087.validator(path, query, header, formData, body)
  let scheme = call_579087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579087.url(scheme.get, call_579087.host, call_579087.base,
                         call_579087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579087, url, valid)

proc call*(call_579088: Call_BigqueryreservationProjectsLocationsSearchReservationGrants_579069;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   query: string
  ##        : Please specify resource name as grantee in the query.
  ## e.g., "grantee=projects/myproject"
  ##       "grantee=folders/123"
  ##       "grantee=organizations/456"
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name (containing project and location), which owns the
  ## grants. e.g.:
  ##   "projects/myproject/locations/us-central1".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579089 = newJObject()
  var query_579090 = newJObject()
  add(query_579090, "key", newJString(key))
  add(query_579090, "prettyPrint", newJBool(prettyPrint))
  add(query_579090, "oauth_token", newJString(oauthToken))
  add(query_579090, "$.xgafv", newJString(Xgafv))
  add(query_579090, "pageSize", newJInt(pageSize))
  add(query_579090, "alt", newJString(alt))
  add(query_579090, "uploadType", newJString(uploadType))
  add(query_579090, "quotaUser", newJString(quotaUser))
  add(query_579090, "pageToken", newJString(pageToken))
  add(query_579090, "query", newJString(query))
  add(query_579090, "callback", newJString(callback))
  add(path_579089, "parent", newJString(parent))
  add(query_579090, "fields", newJString(fields))
  add(query_579090, "access_token", newJString(accessToken))
  add(query_579090, "upload_protocol", newJString(uploadProtocol))
  result = call_579088.call(path_579089, query_579090, nil, nil, nil)

var bigqueryreservationProjectsLocationsSearchReservationGrants* = Call_BigqueryreservationProjectsLocationsSearchReservationGrants_579069(
    name: "bigqueryreservationProjectsLocationsSearchReservationGrants",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1alpha2/{parent}:SearchReservationGrants", validator: validate_BigqueryreservationProjectsLocationsSearchReservationGrants_579070,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsSearchReservationGrants_579071,
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
