
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Healthcare
## version: v1alpha2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manage, store, and access healthcare data in Google Cloud Platform.
## 
## https://cloud.google.com/healthcare
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
  gcpServiceName = "healthcare"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578908 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578910(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578909(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the entire contents of a resource.
  ## 
  ## Implements the FHIR standard [update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#update).
  ## 
  ## If the specified resource does
  ## not exist and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`. The resource
  ## must contain an `id` element having an identical value to the ID in the
  ## REST path of the request.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578911 = path.getOrDefault("name")
  valid_578911 = validateParameter(valid_578911, JString, required = true,
                                 default = nil)
  if valid_578911 != nil:
    section.add "name", valid_578911
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
  var valid_578912 = query.getOrDefault("key")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "key", valid_578912
  var valid_578913 = query.getOrDefault("prettyPrint")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(true))
  if valid_578913 != nil:
    section.add "prettyPrint", valid_578913
  var valid_578914 = query.getOrDefault("oauth_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "oauth_token", valid_578914
  var valid_578915 = query.getOrDefault("$.xgafv")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("1"))
  if valid_578915 != nil:
    section.add "$.xgafv", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("uploadType")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "uploadType", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("callback")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "callback", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  var valid_578921 = query.getOrDefault("access_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "access_token", valid_578921
  var valid_578922 = query.getOrDefault("upload_protocol")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "upload_protocol", valid_578922
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

proc call*(call_578924: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578908;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the entire contents of a resource.
  ## 
  ## Implements the FHIR standard [update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#update).
  ## 
  ## If the specified resource does
  ## not exist and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`. The resource
  ## must contain an `id` element having an identical value to the ID in the
  ## REST path of the request.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578908;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate
  ## Updates the entire contents of a resource.
  ## 
  ## Implements the FHIR standard [update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#update).
  ## 
  ## If the specified resource does
  ## not exist and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`. The resource
  ## must contain an `id` element having an identical value to the ID in the
  ## REST path of the request.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
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
  ##       : The name of the resource to update.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  var body_578928 = newJObject()
  add(query_578927, "key", newJString(key))
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(query_578927, "$.xgafv", newJString(Xgafv))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "uploadType", newJString(uploadType))
  add(query_578927, "quotaUser", newJString(quotaUser))
  add(path_578926, "name", newJString(name))
  if body != nil:
    body_578928 = body
  add(query_578927, "callback", newJString(callback))
  add(query_578927, "fields", newJString(fields))
  add(query_578927, "access_token", newJString(accessToken))
  add(query_578927, "upload_protocol", newJString(uploadProtocol))
  result = call_578925.call(path_578926, query_578927, nil, nil, body_578928)

var healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578908(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578909,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578910,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_578619 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresGet_578621(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresGet_578620(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the specified DICOM store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the DICOM store to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  ##   view: JString
  ##       : Specifies which parts of the Message resource should be returned
  ## in the response.
  section = newJObject()
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
  var valid_578772 = query.getOrDefault("view")
  valid_578772 = validateParameter(valid_578772, JString, required = false, default = newJString(
      "MESSAGE_VIEW_UNSPECIFIED"))
  if valid_578772 != nil:
    section.add "view", valid_578772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578795: Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified DICOM store.
  ## 
  let valid = call_578795.validator(path, query, header, formData, body)
  let scheme = call_578795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578795.url(scheme.get, call_578795.host, call_578795.base,
                         call_578795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578795, url, valid)

proc call*(call_578866: Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_578619;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          view: string = "MESSAGE_VIEW_UNSPECIFIED"): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresGet
  ## Gets the specified DICOM store.
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
  ##       : The resource name of the DICOM store to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Specifies which parts of the Message resource should be returned
  ## in the response.
  var path_578867 = newJObject()
  var query_578869 = newJObject()
  add(query_578869, "key", newJString(key))
  add(query_578869, "prettyPrint", newJBool(prettyPrint))
  add(query_578869, "oauth_token", newJString(oauthToken))
  add(query_578869, "$.xgafv", newJString(Xgafv))
  add(query_578869, "alt", newJString(alt))
  add(query_578869, "uploadType", newJString(uploadType))
  add(query_578869, "quotaUser", newJString(quotaUser))
  add(path_578867, "name", newJString(name))
  add(query_578869, "callback", newJString(callback))
  add(query_578869, "fields", newJString(fields))
  add(query_578869, "access_token", newJString(accessToken))
  add(query_578869, "upload_protocol", newJString(uploadProtocol))
  add(query_578869, "view", newJString(view))
  result = call_578866.call(path_578867, query_578869, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresGet* = Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_578619(
    name: "healthcareProjectsLocationsDatasetsDicomStoresGet",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresGet_578620,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresGet_578621,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578948 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578950(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578949(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the specified DICOM store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. Resource name of the DICOM store, of the form
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578951 = path.getOrDefault("name")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "name", valid_578951
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
  ##             : The update mask applies to the resource. For the `FieldMask` definition,
  ## see
  ## 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("$.xgafv")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("1"))
  if valid_578955 != nil:
    section.add "$.xgafv", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("updateMask")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "updateMask", valid_578959
  var valid_578960 = query.getOrDefault("callback")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "callback", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
  var valid_578962 = query.getOrDefault("access_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "access_token", valid_578962
  var valid_578963 = query.getOrDefault("upload_protocol")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "upload_protocol", valid_578963
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

proc call*(call_578965: Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified DICOM store.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578948;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresPatch
  ## Updates the specified DICOM store.
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
  ##       : Output only. Resource name of the DICOM store, of the form
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`.
  ##   updateMask: string
  ##             : The update mask applies to the resource. For the `FieldMask` definition,
  ## see
  ## 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  var body_578969 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(query_578968, "$.xgafv", newJString(Xgafv))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "uploadType", newJString(uploadType))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(path_578967, "name", newJString(name))
  add(query_578968, "updateMask", newJString(updateMask))
  if body != nil:
    body_578969 = body
  add(query_578968, "callback", newJString(callback))
  add(query_578968, "fields", newJString(fields))
  add(query_578968, "access_token", newJString(accessToken))
  add(query_578968, "upload_protocol", newJString(uploadProtocol))
  result = call_578966.call(path_578967, query_578968, nil, nil, body_578969)

var healthcareProjectsLocationsDatasetsDicomStoresPatch* = Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578948(
    name: "healthcareProjectsLocationsDatasetsDicomStoresPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578949,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresPatch_578950,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578929 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578931(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578930(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified DICOM store and removes all images that are contained
  ## within it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the DICOM store to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578932 = path.getOrDefault("name")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "name", valid_578932
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
  var valid_578933 = query.getOrDefault("key")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "key", valid_578933
  var valid_578934 = query.getOrDefault("prettyPrint")
  valid_578934 = validateParameter(valid_578934, JBool, required = false,
                                 default = newJBool(true))
  if valid_578934 != nil:
    section.add "prettyPrint", valid_578934
  var valid_578935 = query.getOrDefault("oauth_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "oauth_token", valid_578935
  var valid_578936 = query.getOrDefault("$.xgafv")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("1"))
  if valid_578936 != nil:
    section.add "$.xgafv", valid_578936
  var valid_578937 = query.getOrDefault("alt")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("json"))
  if valid_578937 != nil:
    section.add "alt", valid_578937
  var valid_578938 = query.getOrDefault("uploadType")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "uploadType", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("callback")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "callback", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
  var valid_578942 = query.getOrDefault("access_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "access_token", valid_578942
  var valid_578943 = query.getOrDefault("upload_protocol")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "upload_protocol", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578944: Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578929;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified DICOM store and removes all images that are contained
  ## within it.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578929;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDelete
  ## Deletes the specified DICOM store and removes all images that are contained
  ## within it.
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
  ##       : The resource name of the DICOM store to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(query_578947, "$.xgafv", newJString(Xgafv))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "uploadType", newJString(uploadType))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(path_578946, "name", newJString(name))
  add(query_578947, "callback", newJString(callback))
  add(query_578947, "fields", newJString(fields))
  add(query_578947, "access_token", newJString(accessToken))
  add(query_578947, "upload_protocol", newJString(uploadProtocol))
  result = call_578945.call(path_578946, query_578947, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresDelete* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578929(
    name: "healthcareProjectsLocationsDatasetsDicomStoresDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578930,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDelete_578931,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578970 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578972(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/$everything")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578971(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves all the resources directly referenced by a patient, as well as
  ## all of the resources in the patient compartment.
  ## 
  ## Implements the FHIR extended operation
  ## [Patient-everything](http://hl7.org/implement/standards/fhir/STU3/patient-operations.html#everything).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the `Patient` resource for which the information is required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578973 = path.getOrDefault("name")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "name", valid_578973
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
  ##   pageToken: JString
  ##            : Used to retrieve the next or previous page of results
  ## when using pagination. Value should be set to the value of page_token set
  ## in next or previous page links' url. Next and previous page are returned
  ## in the response bundle's links field, where `link.relation` is "previous"
  ## or "next".
  ## 
  ## Omit `page_token` if no previous request has been made.
  ##   _count: JInt
  ##         : Maximum number of resources in a page. Defaults to 100.
  ##   start: JString
  ##        : The response includes records subsequent to the start date. If no start
  ## date is provided, all records prior to the end date are in scope.
  ##   callback: JString
  ##           : JSONP
  ##   end: JString
  ##      : The response includes records prior to the end date. If no end date is
  ## provided, all records subsequent to the start date are in scope.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("$.xgafv")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("1"))
  if valid_578977 != nil:
    section.add "$.xgafv", valid_578977
  var valid_578978 = query.getOrDefault("alt")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("json"))
  if valid_578978 != nil:
    section.add "alt", valid_578978
  var valid_578979 = query.getOrDefault("uploadType")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "uploadType", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("pageToken")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "pageToken", valid_578981
  var valid_578982 = query.getOrDefault("_count")
  valid_578982 = validateParameter(valid_578982, JInt, required = false, default = nil)
  if valid_578982 != nil:
    section.add "_count", valid_578982
  var valid_578983 = query.getOrDefault("start")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "start", valid_578983
  var valid_578984 = query.getOrDefault("callback")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "callback", valid_578984
  var valid_578985 = query.getOrDefault("end")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "end", valid_578985
  var valid_578986 = query.getOrDefault("fields")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "fields", valid_578986
  var valid_578987 = query.getOrDefault("access_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "access_token", valid_578987
  var valid_578988 = query.getOrDefault("upload_protocol")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "upload_protocol", valid_578988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578989: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the resources directly referenced by a patient, as well as
  ## all of the resources in the patient compartment.
  ## 
  ## Implements the FHIR extended operation
  ## [Patient-everything](http://hl7.org/implement/standards/fhir/STU3/patient-operations.html#everything).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578970;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          Count: int = 0; start: string = ""; callback: string = ""; `end`: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything
  ## Retrieves all the resources directly referenced by a patient, as well as
  ## all of the resources in the patient compartment.
  ## 
  ## Implements the FHIR extended operation
  ## [Patient-everything](http://hl7.org/implement/standards/fhir/STU3/patient-operations.html#everything).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
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
  ##       : Name of the `Patient` resource for which the information is required.
  ##   pageToken: string
  ##            : Used to retrieve the next or previous page of results
  ## when using pagination. Value should be set to the value of page_token set
  ## in next or previous page links' url. Next and previous page are returned
  ## in the response bundle's links field, where `link.relation` is "previous"
  ## or "next".
  ## 
  ## Omit `page_token` if no previous request has been made.
  ##   Count: int
  ##        : Maximum number of resources in a page. Defaults to 100.
  ##   start: string
  ##        : The response includes records subsequent to the start date. If no start
  ## date is provided, all records prior to the end date are in scope.
  ##   callback: string
  ##           : JSONP
  ##   end: string
  ##      : The response includes records prior to the end date. If no end date is
  ## provided, all records subsequent to the start date are in scope.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "$.xgafv", newJString(Xgafv))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "uploadType", newJString(uploadType))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "name", newJString(name))
  add(query_578992, "pageToken", newJString(pageToken))
  add(query_578992, "_count", newJInt(Count))
  add(query_578992, "start", newJString(start))
  add(query_578992, "callback", newJString(callback))
  add(query_578992, "end", newJString(`end`))
  add(query_578992, "fields", newJString(fields))
  add(query_578992, "access_token", newJString(accessToken))
  add(query_578992, "upload_protocol", newJString(uploadProtocol))
  result = call_578990.call(path_578991, query_578992, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578970(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/$everything", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578971,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578972,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578993 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578995(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/$purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578994(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes all the historical versions of a resource (excluding the current
  ## version) from the FHIR store. To remove all versions of a resource, first
  ## delete the current version and then call this method.
  ## 
  ## This is not a FHIR standard operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to purge.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578996 = path.getOrDefault("name")
  valid_578996 = validateParameter(valid_578996, JString, required = true,
                                 default = nil)
  if valid_578996 != nil:
    section.add "name", valid_578996
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
  var valid_578997 = query.getOrDefault("key")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "key", valid_578997
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
  var valid_579000 = query.getOrDefault("$.xgafv")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("1"))
  if valid_579000 != nil:
    section.add "$.xgafv", valid_579000
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("uploadType")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "uploadType", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  var valid_579004 = query.getOrDefault("callback")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "callback", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  var valid_579006 = query.getOrDefault("access_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "access_token", valid_579006
  var valid_579007 = query.getOrDefault("upload_protocol")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "upload_protocol", valid_579007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579008: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the historical versions of a resource (excluding the current
  ## version) from the FHIR store. To remove all versions of a resource, first
  ## delete the current version and then call this method.
  ## 
  ## This is not a FHIR standard operation.
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578993;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge
  ## Deletes all the historical versions of a resource (excluding the current
  ## version) from the FHIR store. To remove all versions of a resource, first
  ## delete the current version and then call this method.
  ## 
  ## This is not a FHIR standard operation.
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
  ##       : The name of the resource to purge.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "$.xgafv", newJString(Xgafv))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "uploadType", newJString(uploadType))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(path_579010, "name", newJString(name))
  add(query_579011, "callback", newJString(callback))
  add(query_579011, "fields", newJString(fields))
  add(query_579011, "access_token", newJString(accessToken))
  add(query_579011, "upload_protocol", newJString(uploadProtocol))
  result = call_579009.call(path_579010, query_579011, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578993(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/$purge", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578994,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578995,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579012 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579014(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_history")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579013(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the versions of a resource (including the current version and
  ## deleted versions) from the FHIR store.
  ## 
  ## Implements the per-resource form of the FHIR standard [history
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#history).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `history`, containing the version history
  ## sorted from most recent to oldest versions.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579015 = path.getOrDefault("name")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "name", valid_579015
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
  ##   count: JInt
  ##        : The maximum number of search results on a page. Defaults to 1000.
  ##   since: JString
  ##        : Only include resource versions that were created at or after the given
  ## instant in time. The instant in time uses the format
  ## YYYY-MM-DDThh:mm:ss.sss+zz:zz (for example 2015-02-07T13:28:17.239+02:00 or
  ## 2017-01-01T00:00:00Z). The time must be specified to the second and
  ## include a time zone.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   page: JString
  ##       : Used to retrieve the first, previous, next, or last page of resource
  ## versions when using pagination. Value should be set to the value of the
  ## `link.url` field returned in the response to the previous request, where
  ## `link.relation` is "first", "previous", "next" or "last".
  ## 
  ## Omit `page` if no previous request has been made.
  ##   at: JString
  ##     : Only include resource versions that were current at some point during the
  ## time period specified in the date time value. The date parameter format is
  ## yyyy-mm-ddThh:mm:ss[Z|(+|-)hh:mm]
  ## 
  ## Clients may specify any of the following:
  ## 
  ## *  An entire year: `_at=2019`
  ## *  An entire month: `_at=2019-01`
  ## *  A specific day: `_at=2019-01-20`
  ## *  A specific second: `_at=2018-12-31T23:59:58Z`
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579016 = query.getOrDefault("key")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "key", valid_579016
  var valid_579017 = query.getOrDefault("prettyPrint")
  valid_579017 = validateParameter(valid_579017, JBool, required = false,
                                 default = newJBool(true))
  if valid_579017 != nil:
    section.add "prettyPrint", valid_579017
  var valid_579018 = query.getOrDefault("oauth_token")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "oauth_token", valid_579018
  var valid_579019 = query.getOrDefault("$.xgafv")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("1"))
  if valid_579019 != nil:
    section.add "$.xgafv", valid_579019
  var valid_579020 = query.getOrDefault("count")
  valid_579020 = validateParameter(valid_579020, JInt, required = false, default = nil)
  if valid_579020 != nil:
    section.add "count", valid_579020
  var valid_579021 = query.getOrDefault("since")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "since", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("uploadType")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "uploadType", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("page")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "page", valid_579025
  var valid_579026 = query.getOrDefault("at")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "at", valid_579026
  var valid_579027 = query.getOrDefault("callback")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "callback", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
  var valid_579029 = query.getOrDefault("access_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "access_token", valid_579029
  var valid_579030 = query.getOrDefault("upload_protocol")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "upload_protocol", valid_579030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579031: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the versions of a resource (including the current version and
  ## deleted versions) from the FHIR store.
  ## 
  ## Implements the per-resource form of the FHIR standard [history
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#history).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `history`, containing the version history
  ## sorted from most recent to oldest versions.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_579031.validator(path, query, header, formData, body)
  let scheme = call_579031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579031.url(scheme.get, call_579031.host, call_579031.base,
                         call_579031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579031, url, valid)

proc call*(call_579032: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579012;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; count: int = 0; since: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          page: string = ""; at: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirHistory
  ## Lists all the versions of a resource (including the current version and
  ## deleted versions) from the FHIR store.
  ## 
  ## Implements the per-resource form of the FHIR standard [history
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#history).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `history`, containing the version history
  ## sorted from most recent to oldest versions.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   count: int
  ##        : The maximum number of search results on a page. Defaults to 1000.
  ##   since: string
  ##        : Only include resource versions that were created at or after the given
  ## instant in time. The instant in time uses the format
  ## YYYY-MM-DDThh:mm:ss.sss+zz:zz (for example 2015-02-07T13:28:17.239+02:00 or
  ## 2017-01-01T00:00:00Z). The time must be specified to the second and
  ## include a time zone.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to retrieve.
  ##   page: string
  ##       : Used to retrieve the first, previous, next, or last page of resource
  ## versions when using pagination. Value should be set to the value of the
  ## `link.url` field returned in the response to the previous request, where
  ## `link.relation` is "first", "previous", "next" or "last".
  ## 
  ## Omit `page` if no previous request has been made.
  ##   at: string
  ##     : Only include resource versions that were current at some point during the
  ## time period specified in the date time value. The date parameter format is
  ## yyyy-mm-ddThh:mm:ss[Z|(+|-)hh:mm]
  ## 
  ## Clients may specify any of the following:
  ## 
  ## *  An entire year: `_at=2019`
  ## *  An entire month: `_at=2019-01`
  ## *  A specific day: `_at=2019-01-20`
  ## *  A specific second: `_at=2018-12-31T23:59:58Z`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579033 = newJObject()
  var query_579034 = newJObject()
  add(query_579034, "key", newJString(key))
  add(query_579034, "prettyPrint", newJBool(prettyPrint))
  add(query_579034, "oauth_token", newJString(oauthToken))
  add(query_579034, "$.xgafv", newJString(Xgafv))
  add(query_579034, "count", newJInt(count))
  add(query_579034, "since", newJString(since))
  add(query_579034, "alt", newJString(alt))
  add(query_579034, "uploadType", newJString(uploadType))
  add(query_579034, "quotaUser", newJString(quotaUser))
  add(path_579033, "name", newJString(name))
  add(query_579034, "page", newJString(page))
  add(query_579034, "at", newJString(at))
  add(query_579034, "callback", newJString(callback))
  add(query_579034, "fields", newJString(fields))
  add(query_579034, "access_token", newJString(accessToken))
  add(query_579034, "upload_protocol", newJString(uploadProtocol))
  result = call_579032.call(path_579033, query_579034, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirHistory* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579012(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirHistory",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/_history", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579013,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579014,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579035 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579037(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/fhir/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579036(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the FHIR store to retrieve the capabilities for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579038 = path.getOrDefault("name")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "name", valid_579038
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
  var valid_579039 = query.getOrDefault("key")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "key", valid_579039
  var valid_579040 = query.getOrDefault("prettyPrint")
  valid_579040 = validateParameter(valid_579040, JBool, required = false,
                                 default = newJBool(true))
  if valid_579040 != nil:
    section.add "prettyPrint", valid_579040
  var valid_579041 = query.getOrDefault("oauth_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "oauth_token", valid_579041
  var valid_579042 = query.getOrDefault("$.xgafv")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("1"))
  if valid_579042 != nil:
    section.add "$.xgafv", valid_579042
  var valid_579043 = query.getOrDefault("alt")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("json"))
  if valid_579043 != nil:
    section.add "alt", valid_579043
  var valid_579044 = query.getOrDefault("uploadType")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "uploadType", valid_579044
  var valid_579045 = query.getOrDefault("quotaUser")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "quotaUser", valid_579045
  var valid_579046 = query.getOrDefault("callback")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "callback", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
  var valid_579048 = query.getOrDefault("access_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "access_token", valid_579048
  var valid_579049 = query.getOrDefault("upload_protocol")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "upload_protocol", valid_579049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579050: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  let valid = call_579050.validator(path, query, header, formData, body)
  let scheme = call_579050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579050.url(scheme.get, call_579050.host, call_579050.base,
                         call_579050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579050, url, valid)

proc call*(call_579051: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579035;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
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
  ##       : Name of the FHIR store to retrieve the capabilities for.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579052 = newJObject()
  var query_579053 = newJObject()
  add(query_579053, "key", newJString(key))
  add(query_579053, "prettyPrint", newJBool(prettyPrint))
  add(query_579053, "oauth_token", newJString(oauthToken))
  add(query_579053, "$.xgafv", newJString(Xgafv))
  add(query_579053, "alt", newJString(alt))
  add(query_579053, "uploadType", newJString(uploadType))
  add(query_579053, "quotaUser", newJString(quotaUser))
  add(path_579052, "name", newJString(name))
  add(query_579053, "callback", newJString(callback))
  add(query_579053, "fields", newJString(fields))
  add(query_579053, "access_token", newJString(accessToken))
  add(query_579053, "upload_protocol", newJString(uploadProtocol))
  result = call_579051.call(path_579052, query_579053, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579035(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/fhir/metadata", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579036,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579037,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsList_579054 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsList_579056(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsList_579055(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579057 = path.getOrDefault("name")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "name", valid_579057
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579058 = query.getOrDefault("key")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "key", valid_579058
  var valid_579059 = query.getOrDefault("prettyPrint")
  valid_579059 = validateParameter(valid_579059, JBool, required = false,
                                 default = newJBool(true))
  if valid_579059 != nil:
    section.add "prettyPrint", valid_579059
  var valid_579060 = query.getOrDefault("oauth_token")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "oauth_token", valid_579060
  var valid_579061 = query.getOrDefault("$.xgafv")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("1"))
  if valid_579061 != nil:
    section.add "$.xgafv", valid_579061
  var valid_579062 = query.getOrDefault("pageSize")
  valid_579062 = validateParameter(valid_579062, JInt, required = false, default = nil)
  if valid_579062 != nil:
    section.add "pageSize", valid_579062
  var valid_579063 = query.getOrDefault("alt")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("json"))
  if valid_579063 != nil:
    section.add "alt", valid_579063
  var valid_579064 = query.getOrDefault("uploadType")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "uploadType", valid_579064
  var valid_579065 = query.getOrDefault("quotaUser")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "quotaUser", valid_579065
  var valid_579066 = query.getOrDefault("filter")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "filter", valid_579066
  var valid_579067 = query.getOrDefault("pageToken")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "pageToken", valid_579067
  var valid_579068 = query.getOrDefault("callback")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "callback", valid_579068
  var valid_579069 = query.getOrDefault("fields")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "fields", valid_579069
  var valid_579070 = query.getOrDefault("access_token")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "access_token", valid_579070
  var valid_579071 = query.getOrDefault("upload_protocol")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "upload_protocol", valid_579071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579072: Call_HealthcareProjectsLocationsList_579054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579072.validator(path, query, header, formData, body)
  let scheme = call_579072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579072.url(scheme.get, call_579072.host, call_579072.base,
                         call_579072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579072, url, valid)

proc call*(call_579073: Call_HealthcareProjectsLocationsList_579054; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579074 = newJObject()
  var query_579075 = newJObject()
  add(query_579075, "key", newJString(key))
  add(query_579075, "prettyPrint", newJBool(prettyPrint))
  add(query_579075, "oauth_token", newJString(oauthToken))
  add(query_579075, "$.xgafv", newJString(Xgafv))
  add(query_579075, "pageSize", newJInt(pageSize))
  add(query_579075, "alt", newJString(alt))
  add(query_579075, "uploadType", newJString(uploadType))
  add(query_579075, "quotaUser", newJString(quotaUser))
  add(path_579074, "name", newJString(name))
  add(query_579075, "filter", newJString(filter))
  add(query_579075, "pageToken", newJString(pageToken))
  add(query_579075, "callback", newJString(callback))
  add(query_579075, "fields", newJString(fields))
  add(query_579075, "access_token", newJString(accessToken))
  add(query_579075, "upload_protocol", newJString(uploadProtocol))
  result = call_579073.call(path_579074, query_579075, nil, nil, nil)

var healthcareProjectsLocationsList* = Call_HealthcareProjectsLocationsList_579054(
    name: "healthcareProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1alpha2/{name}/locations",
    validator: validate_HealthcareProjectsLocationsList_579055, base: "/",
    url: url_HealthcareProjectsLocationsList_579056, schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579076 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579078(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579077(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the FHIR store to retrieve the capabilities for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579079 = path.getOrDefault("name")
  valid_579079 = validateParameter(valid_579079, JString, required = true,
                                 default = nil)
  if valid_579079 != nil:
    section.add "name", valid_579079
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
  var valid_579080 = query.getOrDefault("key")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "key", valid_579080
  var valid_579081 = query.getOrDefault("prettyPrint")
  valid_579081 = validateParameter(valid_579081, JBool, required = false,
                                 default = newJBool(true))
  if valid_579081 != nil:
    section.add "prettyPrint", valid_579081
  var valid_579082 = query.getOrDefault("oauth_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "oauth_token", valid_579082
  var valid_579083 = query.getOrDefault("$.xgafv")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("1"))
  if valid_579083 != nil:
    section.add "$.xgafv", valid_579083
  var valid_579084 = query.getOrDefault("alt")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("json"))
  if valid_579084 != nil:
    section.add "alt", valid_579084
  var valid_579085 = query.getOrDefault("uploadType")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "uploadType", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("callback")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "callback", valid_579087
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

proc call*(call_579091: Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  let valid = call_579091.validator(path, query, header, formData, body)
  let scheme = call_579091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579091.url(scheme.get, call_579091.host, call_579091.base,
                         call_579091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579091, url, valid)

proc call*(call_579092: Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579076;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresCapabilities
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
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
  ##       : Name of the FHIR store to retrieve the capabilities for.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579093 = newJObject()
  var query_579094 = newJObject()
  add(query_579094, "key", newJString(key))
  add(query_579094, "prettyPrint", newJBool(prettyPrint))
  add(query_579094, "oauth_token", newJString(oauthToken))
  add(query_579094, "$.xgafv", newJString(Xgafv))
  add(query_579094, "alt", newJString(alt))
  add(query_579094, "uploadType", newJString(uploadType))
  add(query_579094, "quotaUser", newJString(quotaUser))
  add(path_579093, "name", newJString(name))
  add(query_579094, "callback", newJString(callback))
  add(query_579094, "fields", newJString(fields))
  add(query_579094, "access_token", newJString(accessToken))
  add(query_579094, "upload_protocol", newJString(uploadProtocol))
  result = call_579092.call(path_579093, query_579094, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresCapabilities* = Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579076(
    name: "healthcareProjectsLocationsDatasetsFhirStoresCapabilities",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/metadata", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579077,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_579078,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsOperationsList_579095 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsOperationsList_579097(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsOperationsList_579096(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579098 = path.getOrDefault("name")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "name", valid_579098
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579099 = query.getOrDefault("key")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "key", valid_579099
  var valid_579100 = query.getOrDefault("prettyPrint")
  valid_579100 = validateParameter(valid_579100, JBool, required = false,
                                 default = newJBool(true))
  if valid_579100 != nil:
    section.add "prettyPrint", valid_579100
  var valid_579101 = query.getOrDefault("oauth_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "oauth_token", valid_579101
  var valid_579102 = query.getOrDefault("$.xgafv")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("1"))
  if valid_579102 != nil:
    section.add "$.xgafv", valid_579102
  var valid_579103 = query.getOrDefault("pageSize")
  valid_579103 = validateParameter(valid_579103, JInt, required = false, default = nil)
  if valid_579103 != nil:
    section.add "pageSize", valid_579103
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
  var valid_579106 = query.getOrDefault("quotaUser")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "quotaUser", valid_579106
  var valid_579107 = query.getOrDefault("filter")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "filter", valid_579107
  var valid_579108 = query.getOrDefault("pageToken")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "pageToken", valid_579108
  var valid_579109 = query.getOrDefault("callback")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "callback", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  var valid_579111 = query.getOrDefault("access_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "access_token", valid_579111
  var valid_579112 = query.getOrDefault("upload_protocol")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "upload_protocol", valid_579112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579113: Call_HealthcareProjectsLocationsDatasetsOperationsList_579095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_579113.validator(path, query, header, formData, body)
  let scheme = call_579113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579113.url(scheme.get, call_579113.host, call_579113.base,
                         call_579113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579113, url, valid)

proc call*(call_579114: Call_HealthcareProjectsLocationsDatasetsOperationsList_579095;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579115 = newJObject()
  var query_579116 = newJObject()
  add(query_579116, "key", newJString(key))
  add(query_579116, "prettyPrint", newJBool(prettyPrint))
  add(query_579116, "oauth_token", newJString(oauthToken))
  add(query_579116, "$.xgafv", newJString(Xgafv))
  add(query_579116, "pageSize", newJInt(pageSize))
  add(query_579116, "alt", newJString(alt))
  add(query_579116, "uploadType", newJString(uploadType))
  add(query_579116, "quotaUser", newJString(quotaUser))
  add(path_579115, "name", newJString(name))
  add(query_579116, "filter", newJString(filter))
  add(query_579116, "pageToken", newJString(pageToken))
  add(query_579116, "callback", newJString(callback))
  add(query_579116, "fields", newJString(fields))
  add(query_579116, "access_token", newJString(accessToken))
  add(query_579116, "upload_protocol", newJString(uploadProtocol))
  result = call_579114.call(path_579115, query_579116, nil, nil, nil)

var healthcareProjectsLocationsDatasetsOperationsList* = Call_HealthcareProjectsLocationsDatasetsOperationsList_579095(
    name: "healthcareProjectsLocationsDatasetsOperationsList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/operations",
    validator: validate_HealthcareProjectsLocationsDatasetsOperationsList_579096,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsOperationsList_579097,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_579117 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresExport_579119(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresExport_579118(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Exports data to the specified destination by copying it from the DICOM
  ## store.
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The DICOM store resource name from which the data should be exported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579120 = path.getOrDefault("name")
  valid_579120 = validateParameter(valid_579120, JString, required = true,
                                 default = nil)
  if valid_579120 != nil:
    section.add "name", valid_579120
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
  var valid_579121 = query.getOrDefault("key")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "key", valid_579121
  var valid_579122 = query.getOrDefault("prettyPrint")
  valid_579122 = validateParameter(valid_579122, JBool, required = false,
                                 default = newJBool(true))
  if valid_579122 != nil:
    section.add "prettyPrint", valid_579122
  var valid_579123 = query.getOrDefault("oauth_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "oauth_token", valid_579123
  var valid_579124 = query.getOrDefault("$.xgafv")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("1"))
  if valid_579124 != nil:
    section.add "$.xgafv", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("uploadType")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "uploadType", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("callback")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "callback", valid_579128
  var valid_579129 = query.getOrDefault("fields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "fields", valid_579129
  var valid_579130 = query.getOrDefault("access_token")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "access_token", valid_579130
  var valid_579131 = query.getOrDefault("upload_protocol")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "upload_protocol", valid_579131
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

proc call*(call_579133: Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_579117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports data to the specified destination by copying it from the DICOM
  ## store.
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_579117;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresExport
  ## Exports data to the specified destination by copying it from the DICOM
  ## store.
  ## The metadata field type is
  ## OperationMetadata.
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
  ##       : The DICOM store resource name from which the data should be exported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  var body_579137 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "$.xgafv", newJString(Xgafv))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "uploadType", newJString(uploadType))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(path_579135, "name", newJString(name))
  if body != nil:
    body_579137 = body
  add(query_579136, "callback", newJString(callback))
  add(query_579136, "fields", newJString(fields))
  add(query_579136, "access_token", newJString(accessToken))
  add(query_579136, "upload_protocol", newJString(uploadProtocol))
  result = call_579134.call(path_579135, query_579136, nil, nil, body_579137)

var healthcareProjectsLocationsDatasetsDicomStoresExport* = Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_579117(
    name: "healthcareProjectsLocationsDatasetsDicomStoresExport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}:export",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresExport_579118,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresExport_579119,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_579138 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresImport_579140(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresImport_579139(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Imports data into the DICOM store by copying it from the specified source.
  ## For errors, the Operation will be populated with error details (in the form
  ## of ImportDicomDataErrorDetails in error.details), which will hold
  ## finer-grained error information. Errors are also logged to Stackdriver
  ## (see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the DICOM store resource into which the data is imported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579141 = path.getOrDefault("name")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "name", valid_579141
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
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("$.xgafv")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("1"))
  if valid_579145 != nil:
    section.add "$.xgafv", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("uploadType")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "uploadType", valid_579147
  var valid_579148 = query.getOrDefault("quotaUser")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "quotaUser", valid_579148
  var valid_579149 = query.getOrDefault("callback")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "callback", valid_579149
  var valid_579150 = query.getOrDefault("fields")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "fields", valid_579150
  var valid_579151 = query.getOrDefault("access_token")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "access_token", valid_579151
  var valid_579152 = query.getOrDefault("upload_protocol")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "upload_protocol", valid_579152
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

proc call*(call_579154: Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_579138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports data into the DICOM store by copying it from the specified source.
  ## For errors, the Operation will be populated with error details (in the form
  ## of ImportDicomDataErrorDetails in error.details), which will hold
  ## finer-grained error information. Errors are also logged to Stackdriver
  ## (see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  let valid = call_579154.validator(path, query, header, formData, body)
  let scheme = call_579154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579154.url(scheme.get, call_579154.host, call_579154.base,
                         call_579154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579154, url, valid)

proc call*(call_579155: Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_579138;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresImport
  ## Imports data into the DICOM store by copying it from the specified source.
  ## For errors, the Operation will be populated with error details (in the form
  ## of ImportDicomDataErrorDetails in error.details), which will hold
  ## finer-grained error information. Errors are also logged to Stackdriver
  ## (see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## The metadata field type is
  ## OperationMetadata.
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
  ##       : The name of the DICOM store resource into which the data is imported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579156 = newJObject()
  var query_579157 = newJObject()
  var body_579158 = newJObject()
  add(query_579157, "key", newJString(key))
  add(query_579157, "prettyPrint", newJBool(prettyPrint))
  add(query_579157, "oauth_token", newJString(oauthToken))
  add(query_579157, "$.xgafv", newJString(Xgafv))
  add(query_579157, "alt", newJString(alt))
  add(query_579157, "uploadType", newJString(uploadType))
  add(query_579157, "quotaUser", newJString(quotaUser))
  add(path_579156, "name", newJString(name))
  if body != nil:
    body_579158 = body
  add(query_579157, "callback", newJString(callback))
  add(query_579157, "fields", newJString(fields))
  add(query_579157, "access_token", newJString(accessToken))
  add(query_579157, "upload_protocol", newJString(uploadProtocol))
  result = call_579155.call(path_579156, query_579157, nil, nil, body_579158)

var healthcareProjectsLocationsDatasetsDicomStoresImport* = Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_579138(
    name: "healthcareProjectsLocationsDatasetsDicomStoresImport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}:import",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresImport_579139,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresImport_579140,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579181 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579183(
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
               (kind: ConstantSegment, value: "/annotationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579182(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new Annotation store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this Annotation store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579184 = path.getOrDefault("parent")
  valid_579184 = validateParameter(valid_579184, JString, required = true,
                                 default = nil)
  if valid_579184 != nil:
    section.add "parent", valid_579184
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
  ##   annotationStoreId: JString
  ##                    : The ID of the Annotation store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
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
  var valid_579185 = query.getOrDefault("key")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "key", valid_579185
  var valid_579186 = query.getOrDefault("prettyPrint")
  valid_579186 = validateParameter(valid_579186, JBool, required = false,
                                 default = newJBool(true))
  if valid_579186 != nil:
    section.add "prettyPrint", valid_579186
  var valid_579187 = query.getOrDefault("oauth_token")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "oauth_token", valid_579187
  var valid_579188 = query.getOrDefault("$.xgafv")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("1"))
  if valid_579188 != nil:
    section.add "$.xgafv", valid_579188
  var valid_579189 = query.getOrDefault("annotationStoreId")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "annotationStoreId", valid_579189
  var valid_579190 = query.getOrDefault("alt")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = newJString("json"))
  if valid_579190 != nil:
    section.add "alt", valid_579190
  var valid_579191 = query.getOrDefault("uploadType")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "uploadType", valid_579191
  var valid_579192 = query.getOrDefault("quotaUser")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "quotaUser", valid_579192
  var valid_579193 = query.getOrDefault("callback")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "callback", valid_579193
  var valid_579194 = query.getOrDefault("fields")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "fields", valid_579194
  var valid_579195 = query.getOrDefault("access_token")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "access_token", valid_579195
  var valid_579196 = query.getOrDefault("upload_protocol")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "upload_protocol", valid_579196
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

proc call*(call_579198: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Annotation store within the parent dataset.
  ## 
  let valid = call_579198.validator(path, query, header, formData, body)
  let scheme = call_579198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579198.url(scheme.get, call_579198.host, call_579198.base,
                         call_579198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579198, url, valid)

proc call*(call_579199: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579181;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; annotationStoreId: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresCreate
  ## Creates a new Annotation store within the parent dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   annotationStoreId: string
  ##                    : The ID of the Annotation store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
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
  ##         : The name of the dataset this Annotation store belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579200 = newJObject()
  var query_579201 = newJObject()
  var body_579202 = newJObject()
  add(query_579201, "key", newJString(key))
  add(query_579201, "prettyPrint", newJBool(prettyPrint))
  add(query_579201, "oauth_token", newJString(oauthToken))
  add(query_579201, "$.xgafv", newJString(Xgafv))
  add(query_579201, "annotationStoreId", newJString(annotationStoreId))
  add(query_579201, "alt", newJString(alt))
  add(query_579201, "uploadType", newJString(uploadType))
  add(query_579201, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579202 = body
  add(query_579201, "callback", newJString(callback))
  add(path_579200, "parent", newJString(parent))
  add(query_579201, "fields", newJString(fields))
  add(query_579201, "access_token", newJString(accessToken))
  add(query_579201, "upload_protocol", newJString(uploadProtocol))
  result = call_579199.call(path_579200, query_579201, nil, nil, body_579202)

var healthcareProjectsLocationsDatasetsAnnotationStoresCreate* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579181(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotationStores", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579182,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_579183,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579159 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579161(
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
               (kind: ConstantSegment, value: "/annotationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579160(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the Annotation stores in the given dataset for a source store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579162 = path.getOrDefault("parent")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "parent", valid_579162
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
  ##           : Limit on the number of Annotation stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579163 = query.getOrDefault("key")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "key", valid_579163
  var valid_579164 = query.getOrDefault("prettyPrint")
  valid_579164 = validateParameter(valid_579164, JBool, required = false,
                                 default = newJBool(true))
  if valid_579164 != nil:
    section.add "prettyPrint", valid_579164
  var valid_579165 = query.getOrDefault("oauth_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "oauth_token", valid_579165
  var valid_579166 = query.getOrDefault("$.xgafv")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("1"))
  if valid_579166 != nil:
    section.add "$.xgafv", valid_579166
  var valid_579167 = query.getOrDefault("pageSize")
  valid_579167 = validateParameter(valid_579167, JInt, required = false, default = nil)
  if valid_579167 != nil:
    section.add "pageSize", valid_579167
  var valid_579168 = query.getOrDefault("alt")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("json"))
  if valid_579168 != nil:
    section.add "alt", valid_579168
  var valid_579169 = query.getOrDefault("uploadType")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "uploadType", valid_579169
  var valid_579170 = query.getOrDefault("quotaUser")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "quotaUser", valid_579170
  var valid_579171 = query.getOrDefault("filter")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "filter", valid_579171
  var valid_579172 = query.getOrDefault("pageToken")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "pageToken", valid_579172
  var valid_579173 = query.getOrDefault("callback")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "callback", valid_579173
  var valid_579174 = query.getOrDefault("fields")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "fields", valid_579174
  var valid_579175 = query.getOrDefault("access_token")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "access_token", valid_579175
  var valid_579176 = query.getOrDefault("upload_protocol")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "upload_protocol", valid_579176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579177: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Annotation stores in the given dataset for a source store.
  ## 
  let valid = call_579177.validator(path, query, header, formData, body)
  let scheme = call_579177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579177.url(scheme.get, call_579177.host, call_579177.base,
                         call_579177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579177, url, valid)

proc call*(call_579178: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579159;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresList
  ## Lists the Annotation stores in the given dataset for a source store.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of Annotation stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the dataset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579179 = newJObject()
  var query_579180 = newJObject()
  add(query_579180, "key", newJString(key))
  add(query_579180, "prettyPrint", newJBool(prettyPrint))
  add(query_579180, "oauth_token", newJString(oauthToken))
  add(query_579180, "$.xgafv", newJString(Xgafv))
  add(query_579180, "pageSize", newJInt(pageSize))
  add(query_579180, "alt", newJString(alt))
  add(query_579180, "uploadType", newJString(uploadType))
  add(query_579180, "quotaUser", newJString(quotaUser))
  add(query_579180, "filter", newJString(filter))
  add(query_579180, "pageToken", newJString(pageToken))
  add(query_579180, "callback", newJString(callback))
  add(path_579179, "parent", newJString(parent))
  add(query_579180, "fields", newJString(fields))
  add(query_579180, "access_token", newJString(accessToken))
  add(query_579180, "upload_protocol", newJString(uploadProtocol))
  result = call_579178.call(path_579179, query_579180, nil, nil, nil)

var healthcareProjectsLocationsDatasetsAnnotationStoresList* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579159(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotationStores", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579160,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresList_579161,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579225 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579227(
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
               (kind: ConstantSegment, value: "/annotations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579226(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new Annotation record. It is
  ## valid to create Annotation objects for the same source more than once since
  ## a unique ID is assigned to each record by this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the Annotation store this annotation belongs to. For example,
  ## 
  ## `projects/my-project/locations/us-central1/datasets/mydataset/annotationStores/myannotationstore`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579228 = path.getOrDefault("parent")
  valid_579228 = validateParameter(valid_579228, JString, required = true,
                                 default = nil)
  if valid_579228 != nil:
    section.add "parent", valid_579228
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
  var valid_579229 = query.getOrDefault("key")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "key", valid_579229
  var valid_579230 = query.getOrDefault("prettyPrint")
  valid_579230 = validateParameter(valid_579230, JBool, required = false,
                                 default = newJBool(true))
  if valid_579230 != nil:
    section.add "prettyPrint", valid_579230
  var valid_579231 = query.getOrDefault("oauth_token")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "oauth_token", valid_579231
  var valid_579232 = query.getOrDefault("$.xgafv")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = newJString("1"))
  if valid_579232 != nil:
    section.add "$.xgafv", valid_579232
  var valid_579233 = query.getOrDefault("alt")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("json"))
  if valid_579233 != nil:
    section.add "alt", valid_579233
  var valid_579234 = query.getOrDefault("uploadType")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "uploadType", valid_579234
  var valid_579235 = query.getOrDefault("quotaUser")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "quotaUser", valid_579235
  var valid_579236 = query.getOrDefault("callback")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "callback", valid_579236
  var valid_579237 = query.getOrDefault("fields")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "fields", valid_579237
  var valid_579238 = query.getOrDefault("access_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "access_token", valid_579238
  var valid_579239 = query.getOrDefault("upload_protocol")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "upload_protocol", valid_579239
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

proc call*(call_579241: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Annotation record. It is
  ## valid to create Annotation objects for the same source more than once since
  ## a unique ID is assigned to each record by this service.
  ## 
  let valid = call_579241.validator(path, query, header, formData, body)
  let scheme = call_579241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579241.url(scheme.get, call_579241.host, call_579241.base,
                         call_579241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579241, url, valid)

proc call*(call_579242: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579225;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate
  ## Creates a new Annotation record. It is
  ## valid to create Annotation objects for the same source more than once since
  ## a unique ID is assigned to each record by this service.
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
  ##         : The name of the Annotation store this annotation belongs to. For example,
  ## 
  ## `projects/my-project/locations/us-central1/datasets/mydataset/annotationStores/myannotationstore`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579243 = newJObject()
  var query_579244 = newJObject()
  var body_579245 = newJObject()
  add(query_579244, "key", newJString(key))
  add(query_579244, "prettyPrint", newJBool(prettyPrint))
  add(query_579244, "oauth_token", newJString(oauthToken))
  add(query_579244, "$.xgafv", newJString(Xgafv))
  add(query_579244, "alt", newJString(alt))
  add(query_579244, "uploadType", newJString(uploadType))
  add(query_579244, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579245 = body
  add(query_579244, "callback", newJString(callback))
  add(path_579243, "parent", newJString(parent))
  add(query_579244, "fields", newJString(fields))
  add(query_579244, "access_token", newJString(accessToken))
  add(query_579244, "upload_protocol", newJString(uploadProtocol))
  result = call_579242.call(path_579243, query_579244, nil, nil, body_579245)

var healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579225(name: "healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotations", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579226,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_579227,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579203 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579205(
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
               (kind: ConstantSegment, value: "/annotations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579204(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the Annotations in the given
  ## Annotation store for a source
  ## resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the Annotation store to retrieve Annotations from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579206 = path.getOrDefault("parent")
  valid_579206 = validateParameter(valid_579206, JString, required = true,
                                 default = nil)
  if valid_579206 != nil:
    section.add "parent", valid_579206
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
  ##           : Limit on the number of Annotations to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Restricts Annotations returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Fields/functions available for filtering are:
  ## - source_version
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579207 = query.getOrDefault("key")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "key", valid_579207
  var valid_579208 = query.getOrDefault("prettyPrint")
  valid_579208 = validateParameter(valid_579208, JBool, required = false,
                                 default = newJBool(true))
  if valid_579208 != nil:
    section.add "prettyPrint", valid_579208
  var valid_579209 = query.getOrDefault("oauth_token")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "oauth_token", valid_579209
  var valid_579210 = query.getOrDefault("$.xgafv")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = newJString("1"))
  if valid_579210 != nil:
    section.add "$.xgafv", valid_579210
  var valid_579211 = query.getOrDefault("pageSize")
  valid_579211 = validateParameter(valid_579211, JInt, required = false, default = nil)
  if valid_579211 != nil:
    section.add "pageSize", valid_579211
  var valid_579212 = query.getOrDefault("alt")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("json"))
  if valid_579212 != nil:
    section.add "alt", valid_579212
  var valid_579213 = query.getOrDefault("uploadType")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "uploadType", valid_579213
  var valid_579214 = query.getOrDefault("quotaUser")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "quotaUser", valid_579214
  var valid_579215 = query.getOrDefault("filter")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "filter", valid_579215
  var valid_579216 = query.getOrDefault("pageToken")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "pageToken", valid_579216
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
  if body != nil:
    result.add "body", body

proc call*(call_579221: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Annotations in the given
  ## Annotation store for a source
  ## resource.
  ## 
  let valid = call_579221.validator(path, query, header, formData, body)
  let scheme = call_579221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579221.url(scheme.get, call_579221.host, call_579221.base,
                         call_579221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579221, url, valid)

proc call*(call_579222: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579203;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList
  ## Lists the Annotations in the given
  ## Annotation store for a source
  ## resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of Annotations to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Restricts Annotations returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Fields/functions available for filtering are:
  ## - source_version
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the Annotation store to retrieve Annotations from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579223 = newJObject()
  var query_579224 = newJObject()
  add(query_579224, "key", newJString(key))
  add(query_579224, "prettyPrint", newJBool(prettyPrint))
  add(query_579224, "oauth_token", newJString(oauthToken))
  add(query_579224, "$.xgafv", newJString(Xgafv))
  add(query_579224, "pageSize", newJInt(pageSize))
  add(query_579224, "alt", newJString(alt))
  add(query_579224, "uploadType", newJString(uploadType))
  add(query_579224, "quotaUser", newJString(quotaUser))
  add(query_579224, "filter", newJString(filter))
  add(query_579224, "pageToken", newJString(pageToken))
  add(query_579224, "callback", newJString(callback))
  add(path_579223, "parent", newJString(parent))
  add(query_579224, "fields", newJString(fields))
  add(query_579224, "access_token", newJString(accessToken))
  add(query_579224, "upload_protocol", newJString(uploadProtocol))
  result = call_579222.call(path_579223, query_579224, nil, nil, nil)

var healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579203(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotations", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579204,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_579205,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsCreate_579267 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsCreate_579269(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsCreate_579268(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new health dataset. Results are returned through the
  ## Operation interface which returns either an
  ## `Operation.response` which contains a Dataset or
  ## `Operation.error`. The metadata
  ## field type is OperationMetadata.
  ## A Google Cloud Platform project can contain up to 500 datasets across all
  ## regions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in which the dataset should be created (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579270 = path.getOrDefault("parent")
  valid_579270 = validateParameter(valid_579270, JString, required = true,
                                 default = nil)
  if valid_579270 != nil:
    section.add "parent", valid_579270
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
  ##   datasetId: JString
  ##            : The ID of the dataset that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579271 = query.getOrDefault("key")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "key", valid_579271
  var valid_579272 = query.getOrDefault("prettyPrint")
  valid_579272 = validateParameter(valid_579272, JBool, required = false,
                                 default = newJBool(true))
  if valid_579272 != nil:
    section.add "prettyPrint", valid_579272
  var valid_579273 = query.getOrDefault("oauth_token")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "oauth_token", valid_579273
  var valid_579274 = query.getOrDefault("$.xgafv")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = newJString("1"))
  if valid_579274 != nil:
    section.add "$.xgafv", valid_579274
  var valid_579275 = query.getOrDefault("alt")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("json"))
  if valid_579275 != nil:
    section.add "alt", valid_579275
  var valid_579276 = query.getOrDefault("uploadType")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "uploadType", valid_579276
  var valid_579277 = query.getOrDefault("quotaUser")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "quotaUser", valid_579277
  var valid_579278 = query.getOrDefault("datasetId")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "datasetId", valid_579278
  var valid_579279 = query.getOrDefault("callback")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "callback", valid_579279
  var valid_579280 = query.getOrDefault("fields")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "fields", valid_579280
  var valid_579281 = query.getOrDefault("access_token")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "access_token", valid_579281
  var valid_579282 = query.getOrDefault("upload_protocol")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "upload_protocol", valid_579282
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

proc call*(call_579284: Call_HealthcareProjectsLocationsDatasetsCreate_579267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new health dataset. Results are returned through the
  ## Operation interface which returns either an
  ## `Operation.response` which contains a Dataset or
  ## `Operation.error`. The metadata
  ## field type is OperationMetadata.
  ## A Google Cloud Platform project can contain up to 500 datasets across all
  ## regions.
  ## 
  let valid = call_579284.validator(path, query, header, formData, body)
  let scheme = call_579284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579284.url(scheme.get, call_579284.host, call_579284.base,
                         call_579284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579284, url, valid)

proc call*(call_579285: Call_HealthcareProjectsLocationsDatasetsCreate_579267;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; datasetId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsCreate
  ## Creates a new health dataset. Results are returned through the
  ## Operation interface which returns either an
  ## `Operation.response` which contains a Dataset or
  ## `Operation.error`. The metadata
  ## field type is OperationMetadata.
  ## A Google Cloud Platform project can contain up to 500 datasets across all
  ## regions.
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
  ##   datasetId: string
  ##            : The ID of the dataset that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the project in which the dataset should be created (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579286 = newJObject()
  var query_579287 = newJObject()
  var body_579288 = newJObject()
  add(query_579287, "key", newJString(key))
  add(query_579287, "prettyPrint", newJBool(prettyPrint))
  add(query_579287, "oauth_token", newJString(oauthToken))
  add(query_579287, "$.xgafv", newJString(Xgafv))
  add(query_579287, "alt", newJString(alt))
  add(query_579287, "uploadType", newJString(uploadType))
  add(query_579287, "quotaUser", newJString(quotaUser))
  add(query_579287, "datasetId", newJString(datasetId))
  if body != nil:
    body_579288 = body
  add(query_579287, "callback", newJString(callback))
  add(path_579286, "parent", newJString(parent))
  add(query_579287, "fields", newJString(fields))
  add(query_579287, "access_token", newJString(accessToken))
  add(query_579287, "upload_protocol", newJString(uploadProtocol))
  result = call_579285.call(path_579286, query_579287, nil, nil, body_579288)

var healthcareProjectsLocationsDatasetsCreate* = Call_HealthcareProjectsLocationsDatasetsCreate_579267(
    name: "healthcareProjectsLocationsDatasetsCreate", meth: HttpMethod.HttpPost,
    host: "healthcare.googleapis.com", route: "/v1alpha2/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsCreate_579268,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsCreate_579269,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsList_579246 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsList_579248(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsList_579247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the health datasets in the current project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project whose datasets should be listed (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579249 = path.getOrDefault("parent")
  valid_579249 = validateParameter(valid_579249, JString, required = true,
                                 default = nil)
  if valid_579249 != nil:
    section.add "parent", valid_579249
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
  ##           : The maximum number of items to return. Capped to 100 if not specified.
  ## May not be larger than 1000.
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
  var valid_579250 = query.getOrDefault("key")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "key", valid_579250
  var valid_579251 = query.getOrDefault("prettyPrint")
  valid_579251 = validateParameter(valid_579251, JBool, required = false,
                                 default = newJBool(true))
  if valid_579251 != nil:
    section.add "prettyPrint", valid_579251
  var valid_579252 = query.getOrDefault("oauth_token")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "oauth_token", valid_579252
  var valid_579253 = query.getOrDefault("$.xgafv")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("1"))
  if valid_579253 != nil:
    section.add "$.xgafv", valid_579253
  var valid_579254 = query.getOrDefault("pageSize")
  valid_579254 = validateParameter(valid_579254, JInt, required = false, default = nil)
  if valid_579254 != nil:
    section.add "pageSize", valid_579254
  var valid_579255 = query.getOrDefault("alt")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = newJString("json"))
  if valid_579255 != nil:
    section.add "alt", valid_579255
  var valid_579256 = query.getOrDefault("uploadType")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "uploadType", valid_579256
  var valid_579257 = query.getOrDefault("quotaUser")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "quotaUser", valid_579257
  var valid_579258 = query.getOrDefault("pageToken")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "pageToken", valid_579258
  var valid_579259 = query.getOrDefault("callback")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "callback", valid_579259
  var valid_579260 = query.getOrDefault("fields")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "fields", valid_579260
  var valid_579261 = query.getOrDefault("access_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "access_token", valid_579261
  var valid_579262 = query.getOrDefault("upload_protocol")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "upload_protocol", valid_579262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579263: Call_HealthcareProjectsLocationsDatasetsList_579246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the health datasets in the current project.
  ## 
  let valid = call_579263.validator(path, query, header, formData, body)
  let scheme = call_579263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579263.url(scheme.get, call_579263.host, call_579263.base,
                         call_579263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579263, url, valid)

proc call*(call_579264: Call_HealthcareProjectsLocationsDatasetsList_579246;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsList
  ## Lists the health datasets in the current project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Capped to 100 if not specified.
  ## May not be larger than 1000.
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
  ##         : The name of the project whose datasets should be listed (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579265 = newJObject()
  var query_579266 = newJObject()
  add(query_579266, "key", newJString(key))
  add(query_579266, "prettyPrint", newJBool(prettyPrint))
  add(query_579266, "oauth_token", newJString(oauthToken))
  add(query_579266, "$.xgafv", newJString(Xgafv))
  add(query_579266, "pageSize", newJInt(pageSize))
  add(query_579266, "alt", newJString(alt))
  add(query_579266, "uploadType", newJString(uploadType))
  add(query_579266, "quotaUser", newJString(quotaUser))
  add(query_579266, "pageToken", newJString(pageToken))
  add(query_579266, "callback", newJString(callback))
  add(path_579265, "parent", newJString(parent))
  add(query_579266, "fields", newJString(fields))
  add(query_579266, "access_token", newJString(accessToken))
  add(query_579266, "upload_protocol", newJString(uploadProtocol))
  result = call_579264.call(path_579265, query_579266, nil, nil, nil)

var healthcareProjectsLocationsDatasetsList* = Call_HealthcareProjectsLocationsDatasetsList_579246(
    name: "healthcareProjectsLocationsDatasetsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1alpha2/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsList_579247, base: "/",
    url: url_HealthcareProjectsLocationsDatasetsList_579248,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579311 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579313(
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
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579312(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new DICOM store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this DICOM store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579314 = path.getOrDefault("parent")
  valid_579314 = validateParameter(valid_579314, JString, required = true,
                                 default = nil)
  if valid_579314 != nil:
    section.add "parent", valid_579314
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
  ##   dicomStoreId: JString
  ##               : The ID of the DICOM store that is being created.
  ## Any string value up to 256 characters in length.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579315 = query.getOrDefault("key")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "key", valid_579315
  var valid_579316 = query.getOrDefault("prettyPrint")
  valid_579316 = validateParameter(valid_579316, JBool, required = false,
                                 default = newJBool(true))
  if valid_579316 != nil:
    section.add "prettyPrint", valid_579316
  var valid_579317 = query.getOrDefault("oauth_token")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "oauth_token", valid_579317
  var valid_579318 = query.getOrDefault("$.xgafv")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("1"))
  if valid_579318 != nil:
    section.add "$.xgafv", valid_579318
  var valid_579319 = query.getOrDefault("alt")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = newJString("json"))
  if valid_579319 != nil:
    section.add "alt", valid_579319
  var valid_579320 = query.getOrDefault("uploadType")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "uploadType", valid_579320
  var valid_579321 = query.getOrDefault("quotaUser")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "quotaUser", valid_579321
  var valid_579322 = query.getOrDefault("dicomStoreId")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "dicomStoreId", valid_579322
  var valid_579323 = query.getOrDefault("callback")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "callback", valid_579323
  var valid_579324 = query.getOrDefault("fields")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "fields", valid_579324
  var valid_579325 = query.getOrDefault("access_token")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "access_token", valid_579325
  var valid_579326 = query.getOrDefault("upload_protocol")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "upload_protocol", valid_579326
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

proc call*(call_579328: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new DICOM store within the parent dataset.
  ## 
  let valid = call_579328.validator(path, query, header, formData, body)
  let scheme = call_579328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579328.url(scheme.get, call_579328.host, call_579328.base,
                         call_579328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579328, url, valid)

proc call*(call_579329: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579311;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; dicomStoreId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresCreate
  ## Creates a new DICOM store within the parent dataset.
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
  ##   dicomStoreId: string
  ##               : The ID of the DICOM store that is being created.
  ## Any string value up to 256 characters in length.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the dataset this DICOM store belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579330 = newJObject()
  var query_579331 = newJObject()
  var body_579332 = newJObject()
  add(query_579331, "key", newJString(key))
  add(query_579331, "prettyPrint", newJBool(prettyPrint))
  add(query_579331, "oauth_token", newJString(oauthToken))
  add(query_579331, "$.xgafv", newJString(Xgafv))
  add(query_579331, "alt", newJString(alt))
  add(query_579331, "uploadType", newJString(uploadType))
  add(query_579331, "quotaUser", newJString(quotaUser))
  add(query_579331, "dicomStoreId", newJString(dicomStoreId))
  if body != nil:
    body_579332 = body
  add(query_579331, "callback", newJString(callback))
  add(path_579330, "parent", newJString(parent))
  add(query_579331, "fields", newJString(fields))
  add(query_579331, "access_token", newJString(accessToken))
  add(query_579331, "upload_protocol", newJString(uploadProtocol))
  result = call_579329.call(path_579330, query_579331, nil, nil, body_579332)

var healthcareProjectsLocationsDatasetsDicomStoresCreate* = Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579311(
    name: "healthcareProjectsLocationsDatasetsDicomStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579312,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579313,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579289 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresList_579291(
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
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresList_579290(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the DICOM stores in the given dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579292 = path.getOrDefault("parent")
  valid_579292 = validateParameter(valid_579292, JString, required = true,
                                 default = nil)
  if valid_579292 != nil:
    section.add "parent", valid_579292
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
  ##           : Limit on the number of DICOM stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579293 = query.getOrDefault("key")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "key", valid_579293
  var valid_579294 = query.getOrDefault("prettyPrint")
  valid_579294 = validateParameter(valid_579294, JBool, required = false,
                                 default = newJBool(true))
  if valid_579294 != nil:
    section.add "prettyPrint", valid_579294
  var valid_579295 = query.getOrDefault("oauth_token")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "oauth_token", valid_579295
  var valid_579296 = query.getOrDefault("$.xgafv")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("1"))
  if valid_579296 != nil:
    section.add "$.xgafv", valid_579296
  var valid_579297 = query.getOrDefault("pageSize")
  valid_579297 = validateParameter(valid_579297, JInt, required = false, default = nil)
  if valid_579297 != nil:
    section.add "pageSize", valid_579297
  var valid_579298 = query.getOrDefault("alt")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = newJString("json"))
  if valid_579298 != nil:
    section.add "alt", valid_579298
  var valid_579299 = query.getOrDefault("uploadType")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "uploadType", valid_579299
  var valid_579300 = query.getOrDefault("quotaUser")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "quotaUser", valid_579300
  var valid_579301 = query.getOrDefault("filter")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "filter", valid_579301
  var valid_579302 = query.getOrDefault("pageToken")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "pageToken", valid_579302
  var valid_579303 = query.getOrDefault("callback")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "callback", valid_579303
  var valid_579304 = query.getOrDefault("fields")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "fields", valid_579304
  var valid_579305 = query.getOrDefault("access_token")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "access_token", valid_579305
  var valid_579306 = query.getOrDefault("upload_protocol")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "upload_protocol", valid_579306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579307: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DICOM stores in the given dataset.
  ## 
  let valid = call_579307.validator(path, query, header, formData, body)
  let scheme = call_579307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579307.url(scheme.get, call_579307.host, call_579307.base,
                         call_579307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579307, url, valid)

proc call*(call_579308: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579289;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresList
  ## Lists the DICOM stores in the given dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of DICOM stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the dataset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579309 = newJObject()
  var query_579310 = newJObject()
  add(query_579310, "key", newJString(key))
  add(query_579310, "prettyPrint", newJBool(prettyPrint))
  add(query_579310, "oauth_token", newJString(oauthToken))
  add(query_579310, "$.xgafv", newJString(Xgafv))
  add(query_579310, "pageSize", newJInt(pageSize))
  add(query_579310, "alt", newJString(alt))
  add(query_579310, "uploadType", newJString(uploadType))
  add(query_579310, "quotaUser", newJString(quotaUser))
  add(query_579310, "filter", newJString(filter))
  add(query_579310, "pageToken", newJString(pageToken))
  add(query_579310, "callback", newJString(callback))
  add(path_579309, "parent", newJString(parent))
  add(query_579310, "fields", newJString(fields))
  add(query_579310, "access_token", newJString(accessToken))
  add(query_579310, "upload_protocol", newJString(uploadProtocol))
  result = call_579308.call(path_579309, query_579310, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresList* = Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579289(
    name: "healthcareProjectsLocationsDatasetsDicomStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresList_579290,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresList_579291,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579353 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579355(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579354(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the StoreInstances DICOMweb request (e.g.,
  ## `studies/[{study_id}]`). Note that the `study_uid` is optional.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579356 = path.getOrDefault("parent")
  valid_579356 = validateParameter(valid_579356, JString, required = true,
                                 default = nil)
  if valid_579356 != nil:
    section.add "parent", valid_579356
  var valid_579357 = path.getOrDefault("dicomWebPath")
  valid_579357 = validateParameter(valid_579357, JString, required = true,
                                 default = nil)
  if valid_579357 != nil:
    section.add "dicomWebPath", valid_579357
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
  var valid_579358 = query.getOrDefault("key")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "key", valid_579358
  var valid_579359 = query.getOrDefault("prettyPrint")
  valid_579359 = validateParameter(valid_579359, JBool, required = false,
                                 default = newJBool(true))
  if valid_579359 != nil:
    section.add "prettyPrint", valid_579359
  var valid_579360 = query.getOrDefault("oauth_token")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "oauth_token", valid_579360
  var valid_579361 = query.getOrDefault("$.xgafv")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = newJString("1"))
  if valid_579361 != nil:
    section.add "$.xgafv", valid_579361
  var valid_579362 = query.getOrDefault("alt")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = newJString("json"))
  if valid_579362 != nil:
    section.add "alt", valid_579362
  var valid_579363 = query.getOrDefault("uploadType")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "uploadType", valid_579363
  var valid_579364 = query.getOrDefault("quotaUser")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "quotaUser", valid_579364
  var valid_579365 = query.getOrDefault("callback")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "callback", valid_579365
  var valid_579366 = query.getOrDefault("fields")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "fields", valid_579366
  var valid_579367 = query.getOrDefault("access_token")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "access_token", valid_579367
  var valid_579368 = query.getOrDefault("upload_protocol")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "upload_protocol", valid_579368
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

proc call*(call_579370: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
  ## 
  let valid = call_579370.validator(path, query, header, formData, body)
  let scheme = call_579370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579370.url(scheme.get, call_579370.host, call_579370.base,
                         call_579370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579370, url, valid)

proc call*(call_579371: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579353;
          parent: string; dicomWebPath: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
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
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dicomWebPath: string (required)
  ##               : The path of the StoreInstances DICOMweb request (e.g.,
  ## `studies/[{study_id}]`). Note that the `study_uid` is optional.
  var path_579372 = newJObject()
  var query_579373 = newJObject()
  var body_579374 = newJObject()
  add(query_579373, "key", newJString(key))
  add(query_579373, "prettyPrint", newJBool(prettyPrint))
  add(query_579373, "oauth_token", newJString(oauthToken))
  add(query_579373, "$.xgafv", newJString(Xgafv))
  add(query_579373, "alt", newJString(alt))
  add(query_579373, "uploadType", newJString(uploadType))
  add(query_579373, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579374 = body
  add(query_579373, "callback", newJString(callback))
  add(path_579372, "parent", newJString(parent))
  add(query_579373, "fields", newJString(fields))
  add(query_579373, "access_token", newJString(accessToken))
  add(query_579373, "upload_protocol", newJString(uploadProtocol))
  add(path_579372, "dicomWebPath", newJString(dicomWebPath))
  result = call_579371.call(path_579372, query_579373, nil, nil, body_579374)

var healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579353(name: "healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579354,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_579355,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579333 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579335(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579334(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## RetrieveRenderedFrames returns instances associated with the given study,
  ## series, SOP Instance UID and frame numbers in an acceptable Rendered Media
  ## Type. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the RetrieveRenderedFrames DICOMweb request (e.g.,
  ## 
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}/frames/{frame_list}/rendered`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579336 = path.getOrDefault("parent")
  valid_579336 = validateParameter(valid_579336, JString, required = true,
                                 default = nil)
  if valid_579336 != nil:
    section.add "parent", valid_579336
  var valid_579337 = path.getOrDefault("dicomWebPath")
  valid_579337 = validateParameter(valid_579337, JString, required = true,
                                 default = nil)
  if valid_579337 != nil:
    section.add "dicomWebPath", valid_579337
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
  var valid_579338 = query.getOrDefault("key")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "key", valid_579338
  var valid_579339 = query.getOrDefault("prettyPrint")
  valid_579339 = validateParameter(valid_579339, JBool, required = false,
                                 default = newJBool(true))
  if valid_579339 != nil:
    section.add "prettyPrint", valid_579339
  var valid_579340 = query.getOrDefault("oauth_token")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "oauth_token", valid_579340
  var valid_579341 = query.getOrDefault("$.xgafv")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = newJString("1"))
  if valid_579341 != nil:
    section.add "$.xgafv", valid_579341
  var valid_579342 = query.getOrDefault("alt")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = newJString("json"))
  if valid_579342 != nil:
    section.add "alt", valid_579342
  var valid_579343 = query.getOrDefault("uploadType")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "uploadType", valid_579343
  var valid_579344 = query.getOrDefault("quotaUser")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "quotaUser", valid_579344
  var valid_579345 = query.getOrDefault("callback")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "callback", valid_579345
  var valid_579346 = query.getOrDefault("fields")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "fields", valid_579346
  var valid_579347 = query.getOrDefault("access_token")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "access_token", valid_579347
  var valid_579348 = query.getOrDefault("upload_protocol")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "upload_protocol", valid_579348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579349: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RetrieveRenderedFrames returns instances associated with the given study,
  ## series, SOP Instance UID and frame numbers in an acceptable Rendered Media
  ## Type. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  let valid = call_579349.validator(path, query, header, formData, body)
  let scheme = call_579349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579349.url(scheme.get, call_579349.host, call_579349.base,
                         call_579349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579349, url, valid)

proc call*(call_579350: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579333;
          parent: string; dicomWebPath: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered
  ## RetrieveRenderedFrames returns instances associated with the given study,
  ## series, SOP Instance UID and frame numbers in an acceptable Rendered Media
  ## Type. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
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
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dicomWebPath: string (required)
  ##               : The path of the RetrieveRenderedFrames DICOMweb request (e.g.,
  ## 
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}/frames/{frame_list}/rendered`).
  var path_579351 = newJObject()
  var query_579352 = newJObject()
  add(query_579352, "key", newJString(key))
  add(query_579352, "prettyPrint", newJBool(prettyPrint))
  add(query_579352, "oauth_token", newJString(oauthToken))
  add(query_579352, "$.xgafv", newJString(Xgafv))
  add(query_579352, "alt", newJString(alt))
  add(query_579352, "uploadType", newJString(uploadType))
  add(query_579352, "quotaUser", newJString(quotaUser))
  add(query_579352, "callback", newJString(callback))
  add(path_579351, "parent", newJString(parent))
  add(query_579352, "fields", newJString(fields))
  add(query_579352, "access_token", newJString(accessToken))
  add(query_579352, "upload_protocol", newJString(uploadProtocol))
  add(path_579351, "dicomWebPath", newJString(dicomWebPath))
  result = call_579350.call(path_579351, query_579352, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579333(name: "healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579334,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_579335,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579375 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579377(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579376(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the DeleteInstance request (e.g.,
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579378 = path.getOrDefault("parent")
  valid_579378 = validateParameter(valid_579378, JString, required = true,
                                 default = nil)
  if valid_579378 != nil:
    section.add "parent", valid_579378
  var valid_579379 = path.getOrDefault("dicomWebPath")
  valid_579379 = validateParameter(valid_579379, JString, required = true,
                                 default = nil)
  if valid_579379 != nil:
    section.add "dicomWebPath", valid_579379
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
  var valid_579380 = query.getOrDefault("key")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "key", valid_579380
  var valid_579381 = query.getOrDefault("prettyPrint")
  valid_579381 = validateParameter(valid_579381, JBool, required = false,
                                 default = newJBool(true))
  if valid_579381 != nil:
    section.add "prettyPrint", valid_579381
  var valid_579382 = query.getOrDefault("oauth_token")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "oauth_token", valid_579382
  var valid_579383 = query.getOrDefault("$.xgafv")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = newJString("1"))
  if valid_579383 != nil:
    section.add "$.xgafv", valid_579383
  var valid_579384 = query.getOrDefault("alt")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = newJString("json"))
  if valid_579384 != nil:
    section.add "alt", valid_579384
  var valid_579385 = query.getOrDefault("uploadType")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "uploadType", valid_579385
  var valid_579386 = query.getOrDefault("quotaUser")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "quotaUser", valid_579386
  var valid_579387 = query.getOrDefault("callback")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "callback", valid_579387
  var valid_579388 = query.getOrDefault("fields")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "fields", valid_579388
  var valid_579389 = query.getOrDefault("access_token")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "access_token", valid_579389
  var valid_579390 = query.getOrDefault("upload_protocol")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "upload_protocol", valid_579390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579391: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
  ## 
  let valid = call_579391.validator(path, query, header, formData, body)
  let scheme = call_579391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579391.url(scheme.get, call_579391.host, call_579391.base,
                         call_579391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579391, url, valid)

proc call*(call_579392: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579375;
          parent: string; dicomWebPath: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
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
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dicomWebPath: string (required)
  ##               : The path of the DeleteInstance request (e.g.,
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}`).
  var path_579393 = newJObject()
  var query_579394 = newJObject()
  add(query_579394, "key", newJString(key))
  add(query_579394, "prettyPrint", newJBool(prettyPrint))
  add(query_579394, "oauth_token", newJString(oauthToken))
  add(query_579394, "$.xgafv", newJString(Xgafv))
  add(query_579394, "alt", newJString(alt))
  add(query_579394, "uploadType", newJString(uploadType))
  add(query_579394, "quotaUser", newJString(quotaUser))
  add(query_579394, "callback", newJString(callback))
  add(path_579393, "parent", newJString(parent))
  add(query_579394, "fields", newJString(fields))
  add(query_579394, "access_token", newJString(accessToken))
  add(query_579394, "upload_protocol", newJString(uploadProtocol))
  add(path_579393, "dicomWebPath", newJString(dicomWebPath))
  result = call_579392.call(path_579393, query_579394, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579375(name: "healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579376,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_579377,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579395 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579397(
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
               (kind: ConstantSegment, value: "/fhir")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579396(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Executes all the requests in the given Bundle.
  ## 
  ## Implements the FHIR standard [batch/transaction
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#transaction).
  ## 
  ## Supports all interactions within a bundle, except search. This method
  ## accepts Bundles of type `batch` and `transaction`, processing them
  ## according to the [batch processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.1)
  ## and [transaction processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.2).
  ## 
  ## The request body must contain a JSON-encoded FHIR `Bundle` resource, and
  ## the request headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## For a batch bundle or a successful transaction the response body will
  ## contain a JSON-encoded representation of a `Bundle` resource of type
  ## `batch-response` or `transaction-response` containing one entry for each
  ## entry in the request, with the outcome of processing the entry. In the
  ## case of an error for a transaction bundle, the response body will contain
  ## a JSON-encoded `OperationOutcome` resource describing the reason for the
  ## error. If the request cannot be mapped to a valid API method on a FHIR
  ## store, a generic GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the FHIR store in which this bundle will be executed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579398 = path.getOrDefault("parent")
  valid_579398 = validateParameter(valid_579398, JString, required = true,
                                 default = nil)
  if valid_579398 != nil:
    section.add "parent", valid_579398
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
  var valid_579399 = query.getOrDefault("key")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "key", valid_579399
  var valid_579400 = query.getOrDefault("prettyPrint")
  valid_579400 = validateParameter(valid_579400, JBool, required = false,
                                 default = newJBool(true))
  if valid_579400 != nil:
    section.add "prettyPrint", valid_579400
  var valid_579401 = query.getOrDefault("oauth_token")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "oauth_token", valid_579401
  var valid_579402 = query.getOrDefault("$.xgafv")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = newJString("1"))
  if valid_579402 != nil:
    section.add "$.xgafv", valid_579402
  var valid_579403 = query.getOrDefault("alt")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = newJString("json"))
  if valid_579403 != nil:
    section.add "alt", valid_579403
  var valid_579404 = query.getOrDefault("uploadType")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "uploadType", valid_579404
  var valid_579405 = query.getOrDefault("quotaUser")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "quotaUser", valid_579405
  var valid_579406 = query.getOrDefault("callback")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "callback", valid_579406
  var valid_579407 = query.getOrDefault("fields")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "fields", valid_579407
  var valid_579408 = query.getOrDefault("access_token")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "access_token", valid_579408
  var valid_579409 = query.getOrDefault("upload_protocol")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "upload_protocol", valid_579409
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

proc call*(call_579411: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes all the requests in the given Bundle.
  ## 
  ## Implements the FHIR standard [batch/transaction
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#transaction).
  ## 
  ## Supports all interactions within a bundle, except search. This method
  ## accepts Bundles of type `batch` and `transaction`, processing them
  ## according to the [batch processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.1)
  ## and [transaction processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.2).
  ## 
  ## The request body must contain a JSON-encoded FHIR `Bundle` resource, and
  ## the request headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## For a batch bundle or a successful transaction the response body will
  ## contain a JSON-encoded representation of a `Bundle` resource of type
  ## `batch-response` or `transaction-response` containing one entry for each
  ## entry in the request, with the outcome of processing the entry. In the
  ## case of an error for a transaction bundle, the response body will contain
  ## a JSON-encoded `OperationOutcome` resource describing the reason for the
  ## error. If the request cannot be mapped to a valid API method on a FHIR
  ## store, a generic GCP error might be returned instead.
  ## 
  let valid = call_579411.validator(path, query, header, formData, body)
  let scheme = call_579411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579411.url(scheme.get, call_579411.host, call_579411.base,
                         call_579411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579411, url, valid)

proc call*(call_579412: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579395;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle
  ## Executes all the requests in the given Bundle.
  ## 
  ## Implements the FHIR standard [batch/transaction
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#transaction).
  ## 
  ## Supports all interactions within a bundle, except search. This method
  ## accepts Bundles of type `batch` and `transaction`, processing them
  ## according to the [batch processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.1)
  ## and [transaction processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.2).
  ## 
  ## The request body must contain a JSON-encoded FHIR `Bundle` resource, and
  ## the request headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## For a batch bundle or a successful transaction the response body will
  ## contain a JSON-encoded representation of a `Bundle` resource of type
  ## `batch-response` or `transaction-response` containing one entry for each
  ## entry in the request, with the outcome of processing the entry. In the
  ## case of an error for a transaction bundle, the response body will contain
  ## a JSON-encoded `OperationOutcome` resource describing the reason for the
  ## error. If the request cannot be mapped to a valid API method on a FHIR
  ## store, a generic GCP error might be returned instead.
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
  ##         : Name of the FHIR store in which this bundle will be executed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579413 = newJObject()
  var query_579414 = newJObject()
  var body_579415 = newJObject()
  add(query_579414, "key", newJString(key))
  add(query_579414, "prettyPrint", newJBool(prettyPrint))
  add(query_579414, "oauth_token", newJString(oauthToken))
  add(query_579414, "$.xgafv", newJString(Xgafv))
  add(query_579414, "alt", newJString(alt))
  add(query_579414, "uploadType", newJString(uploadType))
  add(query_579414, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579415 = body
  add(query_579414, "callback", newJString(callback))
  add(path_579413, "parent", newJString(parent))
  add(query_579414, "fields", newJString(fields))
  add(query_579414, "access_token", newJString(accessToken))
  add(query_579414, "upload_protocol", newJString(uploadProtocol))
  result = call_579412.call(path_579413, query_579414, nil, nil, body_579415)

var healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579395(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579396,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579397,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579416 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579418(
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
               (kind: ConstantSegment, value: "/fhir/Observation/$lastn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579417(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the N most recent `Observation` resources for a subject matching
  ## search criteria specified as query parameters, grouped by
  ## `Observation.code`, sorted from most recent to oldest.
  ## 
  ## Implements the FHIR extended operation
  ## [Observation-lastn](http://hl7.org/implement/standards/fhir/STU3/observation-operations.html#lastn).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method. This operation accepts an additional
  ## query parameter `max`, which specifies N, the maximum number of
  ## Observations to return from each group, with a default of 1.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the FHIR store to retrieve resources from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579419 = path.getOrDefault("parent")
  valid_579419 = validateParameter(valid_579419, JString, required = true,
                                 default = nil)
  if valid_579419 != nil:
    section.add "parent", valid_579419
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
  var valid_579420 = query.getOrDefault("key")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "key", valid_579420
  var valid_579421 = query.getOrDefault("prettyPrint")
  valid_579421 = validateParameter(valid_579421, JBool, required = false,
                                 default = newJBool(true))
  if valid_579421 != nil:
    section.add "prettyPrint", valid_579421
  var valid_579422 = query.getOrDefault("oauth_token")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "oauth_token", valid_579422
  var valid_579423 = query.getOrDefault("$.xgafv")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = newJString("1"))
  if valid_579423 != nil:
    section.add "$.xgafv", valid_579423
  var valid_579424 = query.getOrDefault("alt")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = newJString("json"))
  if valid_579424 != nil:
    section.add "alt", valid_579424
  var valid_579425 = query.getOrDefault("uploadType")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "uploadType", valid_579425
  var valid_579426 = query.getOrDefault("quotaUser")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "quotaUser", valid_579426
  var valid_579427 = query.getOrDefault("callback")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "callback", valid_579427
  var valid_579428 = query.getOrDefault("fields")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "fields", valid_579428
  var valid_579429 = query.getOrDefault("access_token")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "access_token", valid_579429
  var valid_579430 = query.getOrDefault("upload_protocol")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "upload_protocol", valid_579430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579431: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the N most recent `Observation` resources for a subject matching
  ## search criteria specified as query parameters, grouped by
  ## `Observation.code`, sorted from most recent to oldest.
  ## 
  ## Implements the FHIR extended operation
  ## [Observation-lastn](http://hl7.org/implement/standards/fhir/STU3/observation-operations.html#lastn).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method. This operation accepts an additional
  ## query parameter `max`, which specifies N, the maximum number of
  ## Observations to return from each group, with a default of 1.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_579431.validator(path, query, header, formData, body)
  let scheme = call_579431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579431.url(scheme.get, call_579431.host, call_579431.base,
                         call_579431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579431, url, valid)

proc call*(call_579432: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579416;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn
  ## Retrieves the N most recent `Observation` resources for a subject matching
  ## search criteria specified as query parameters, grouped by
  ## `Observation.code`, sorted from most recent to oldest.
  ## 
  ## Implements the FHIR extended operation
  ## [Observation-lastn](http://hl7.org/implement/standards/fhir/STU3/observation-operations.html#lastn).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method. This operation accepts an additional
  ## query parameter `max`, which specifies N, the maximum number of
  ## Observations to return from each group, with a default of 1.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
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
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the FHIR store to retrieve resources from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579433 = newJObject()
  var query_579434 = newJObject()
  add(query_579434, "key", newJString(key))
  add(query_579434, "prettyPrint", newJBool(prettyPrint))
  add(query_579434, "oauth_token", newJString(oauthToken))
  add(query_579434, "$.xgafv", newJString(Xgafv))
  add(query_579434, "alt", newJString(alt))
  add(query_579434, "uploadType", newJString(uploadType))
  add(query_579434, "quotaUser", newJString(quotaUser))
  add(query_579434, "callback", newJString(callback))
  add(path_579433, "parent", newJString(parent))
  add(query_579434, "fields", newJString(fields))
  add(query_579434, "access_token", newJString(accessToken))
  add(query_579434, "upload_protocol", newJString(uploadProtocol))
  result = call_579432.call(path_579433, query_579434, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579416(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/Observation/$lastn", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579417,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579418,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579435 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579437(
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
               (kind: ConstantSegment, value: "/fhir/_search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579436(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Searches for resources in the given FHIR store according to criteria
  ## specified as query parameters.
  ## 
  ## Implements the FHIR standard [search
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#search)
  ## using the search semantics described in the [FHIR Search
  ## specification](http://hl7.org/implement/standards/fhir/STU3/search.html).
  ## 
  ## Supports three methods of search defined by the specification:
  ## 
  ## *  `GET [base]?[parameters]` to search across all resources.
  ## *  `GET [base]/[type]?[parameters]` to search resources of a specified
  ## type.
  ## *  `POST [base]/[type]/_search?[parameters]` as an alternate form having
  ## the same semantics as the `GET` method.
  ## 
  ## The `GET` methods do not support compartment searches. The `POST` method
  ## does not support `application/x-www-form-urlencoded` search parameters.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## search.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  ## The server's capability statement, retrieved through
  ## capabilities, indicates what search parameters
  ## are supported on each FHIR resource. A list of all search parameters
  ## defined by the specification can be found in the [FHIR Search Parameter
  ## Registry](http://hl7.org/implement/standards/fhir/STU3/searchparameter-registry.html).
  ## 
  ## Supported search modifiers: `:missing`, `:exact`, `:contains`, `:text`,
  ## `:in`, `:not-in`, `:above`, `:below`, `:[type]`, `:not`, and `:recurse`.
  ## 
  ## Supported search result parameters: `_sort`, `_count`, `_include`,
  ## `_revinclude`, `_summary=text`, `_summary=data`, and `_elements`.
  ## 
  ## The maximum number of search results returned defaults to 100, which can
  ## be overridden by the `_count` parameter up to a maximum limit of 1000. If
  ## there are additional results, the returned `Bundle` will contain
  ## pagination links.
  ## 
  ## Resources with a total size larger than 5MB or a field count larger than
  ## 50,000 might not be fully searchable as the server might trim its generated
  ## search index in those cases.
  ## 
  ## Note: FHIR resources are indexed asynchronously, so there might be a slight
  ## delay between the time a resource is created or changes and when the change
  ## is reflected in search results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the FHIR store to retrieve resources from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579438 = path.getOrDefault("parent")
  valid_579438 = validateParameter(valid_579438, JString, required = true,
                                 default = nil)
  if valid_579438 != nil:
    section.add "parent", valid_579438
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
  var valid_579439 = query.getOrDefault("key")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "key", valid_579439
  var valid_579440 = query.getOrDefault("prettyPrint")
  valid_579440 = validateParameter(valid_579440, JBool, required = false,
                                 default = newJBool(true))
  if valid_579440 != nil:
    section.add "prettyPrint", valid_579440
  var valid_579441 = query.getOrDefault("oauth_token")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "oauth_token", valid_579441
  var valid_579442 = query.getOrDefault("$.xgafv")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("1"))
  if valid_579442 != nil:
    section.add "$.xgafv", valid_579442
  var valid_579443 = query.getOrDefault("alt")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = newJString("json"))
  if valid_579443 != nil:
    section.add "alt", valid_579443
  var valid_579444 = query.getOrDefault("uploadType")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "uploadType", valid_579444
  var valid_579445 = query.getOrDefault("quotaUser")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "quotaUser", valid_579445
  var valid_579446 = query.getOrDefault("callback")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "callback", valid_579446
  var valid_579447 = query.getOrDefault("fields")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "fields", valid_579447
  var valid_579448 = query.getOrDefault("access_token")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "access_token", valid_579448
  var valid_579449 = query.getOrDefault("upload_protocol")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "upload_protocol", valid_579449
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

proc call*(call_579451: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579435;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Searches for resources in the given FHIR store according to criteria
  ## specified as query parameters.
  ## 
  ## Implements the FHIR standard [search
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#search)
  ## using the search semantics described in the [FHIR Search
  ## specification](http://hl7.org/implement/standards/fhir/STU3/search.html).
  ## 
  ## Supports three methods of search defined by the specification:
  ## 
  ## *  `GET [base]?[parameters]` to search across all resources.
  ## *  `GET [base]/[type]?[parameters]` to search resources of a specified
  ## type.
  ## *  `POST [base]/[type]/_search?[parameters]` as an alternate form having
  ## the same semantics as the `GET` method.
  ## 
  ## The `GET` methods do not support compartment searches. The `POST` method
  ## does not support `application/x-www-form-urlencoded` search parameters.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## search.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  ## The server's capability statement, retrieved through
  ## capabilities, indicates what search parameters
  ## are supported on each FHIR resource. A list of all search parameters
  ## defined by the specification can be found in the [FHIR Search Parameter
  ## Registry](http://hl7.org/implement/standards/fhir/STU3/searchparameter-registry.html).
  ## 
  ## Supported search modifiers: `:missing`, `:exact`, `:contains`, `:text`,
  ## `:in`, `:not-in`, `:above`, `:below`, `:[type]`, `:not`, and `:recurse`.
  ## 
  ## Supported search result parameters: `_sort`, `_count`, `_include`,
  ## `_revinclude`, `_summary=text`, `_summary=data`, and `_elements`.
  ## 
  ## The maximum number of search results returned defaults to 100, which can
  ## be overridden by the `_count` parameter up to a maximum limit of 1000. If
  ## there are additional results, the returned `Bundle` will contain
  ## pagination links.
  ## 
  ## Resources with a total size larger than 5MB or a field count larger than
  ## 50,000 might not be fully searchable as the server might trim its generated
  ## search index in those cases.
  ## 
  ## Note: FHIR resources are indexed asynchronously, so there might be a slight
  ## delay between the time a resource is created or changes and when the change
  ## is reflected in search results.
  ## 
  let valid = call_579451.validator(path, query, header, formData, body)
  let scheme = call_579451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579451.url(scheme.get, call_579451.host, call_579451.base,
                         call_579451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579451, url, valid)

proc call*(call_579452: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579435;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirSearch
  ## Searches for resources in the given FHIR store according to criteria
  ## specified as query parameters.
  ## 
  ## Implements the FHIR standard [search
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#search)
  ## using the search semantics described in the [FHIR Search
  ## specification](http://hl7.org/implement/standards/fhir/STU3/search.html).
  ## 
  ## Supports three methods of search defined by the specification:
  ## 
  ## *  `GET [base]?[parameters]` to search across all resources.
  ## *  `GET [base]/[type]?[parameters]` to search resources of a specified
  ## type.
  ## *  `POST [base]/[type]/_search?[parameters]` as an alternate form having
  ## the same semantics as the `GET` method.
  ## 
  ## The `GET` methods do not support compartment searches. The `POST` method
  ## does not support `application/x-www-form-urlencoded` search parameters.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## search.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  ## The server's capability statement, retrieved through
  ## capabilities, indicates what search parameters
  ## are supported on each FHIR resource. A list of all search parameters
  ## defined by the specification can be found in the [FHIR Search Parameter
  ## Registry](http://hl7.org/implement/standards/fhir/STU3/searchparameter-registry.html).
  ## 
  ## Supported search modifiers: `:missing`, `:exact`, `:contains`, `:text`,
  ## `:in`, `:not-in`, `:above`, `:below`, `:[type]`, `:not`, and `:recurse`.
  ## 
  ## Supported search result parameters: `_sort`, `_count`, `_include`,
  ## `_revinclude`, `_summary=text`, `_summary=data`, and `_elements`.
  ## 
  ## The maximum number of search results returned defaults to 100, which can
  ## be overridden by the `_count` parameter up to a maximum limit of 1000. If
  ## there are additional results, the returned `Bundle` will contain
  ## pagination links.
  ## 
  ## Resources with a total size larger than 5MB or a field count larger than
  ## 50,000 might not be fully searchable as the server might trim its generated
  ## search index in those cases.
  ## 
  ## Note: FHIR resources are indexed asynchronously, so there might be a slight
  ## delay between the time a resource is created or changes and when the change
  ## is reflected in search results.
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
  ##         : Name of the FHIR store to retrieve resources from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579453 = newJObject()
  var query_579454 = newJObject()
  var body_579455 = newJObject()
  add(query_579454, "key", newJString(key))
  add(query_579454, "prettyPrint", newJBool(prettyPrint))
  add(query_579454, "oauth_token", newJString(oauthToken))
  add(query_579454, "$.xgafv", newJString(Xgafv))
  add(query_579454, "alt", newJString(alt))
  add(query_579454, "uploadType", newJString(uploadType))
  add(query_579454, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579455 = body
  add(query_579454, "callback", newJString(callback))
  add(path_579453, "parent", newJString(parent))
  add(query_579454, "fields", newJString(fields))
  add(query_579454, "access_token", newJString(accessToken))
  add(query_579454, "upload_protocol", newJString(uploadProtocol))
  result = call_579452.call(path_579453, query_579454, nil, nil, body_579455)

var healthcareProjectsLocationsDatasetsFhirStoresFhirSearch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579435(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirSearch",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/_search", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579436,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579437,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579456 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579458(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579457(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates the entire contents of that resource.
  ## 
  ## Implements the FHIR standard [conditional update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cond-update).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## If the search criteria identify zero matches, and the supplied resource
  ## body contains an `id`, and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID. If the search criteria identify zero
  ## matches, and the supplied resource body does not contain an `id`, the
  ## resource will be created with a server-assigned ID as per the
  ## create method.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_579459 = path.getOrDefault("type")
  valid_579459 = validateParameter(valid_579459, JString, required = true,
                                 default = nil)
  if valid_579459 != nil:
    section.add "type", valid_579459
  var valid_579460 = path.getOrDefault("parent")
  valid_579460 = validateParameter(valid_579460, JString, required = true,
                                 default = nil)
  if valid_579460 != nil:
    section.add "parent", valid_579460
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
  var valid_579461 = query.getOrDefault("key")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "key", valid_579461
  var valid_579462 = query.getOrDefault("prettyPrint")
  valid_579462 = validateParameter(valid_579462, JBool, required = false,
                                 default = newJBool(true))
  if valid_579462 != nil:
    section.add "prettyPrint", valid_579462
  var valid_579463 = query.getOrDefault("oauth_token")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "oauth_token", valid_579463
  var valid_579464 = query.getOrDefault("$.xgafv")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = newJString("1"))
  if valid_579464 != nil:
    section.add "$.xgafv", valid_579464
  var valid_579465 = query.getOrDefault("alt")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = newJString("json"))
  if valid_579465 != nil:
    section.add "alt", valid_579465
  var valid_579466 = query.getOrDefault("uploadType")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "uploadType", valid_579466
  var valid_579467 = query.getOrDefault("quotaUser")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "quotaUser", valid_579467
  var valid_579468 = query.getOrDefault("callback")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "callback", valid_579468
  var valid_579469 = query.getOrDefault("fields")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "fields", valid_579469
  var valid_579470 = query.getOrDefault("access_token")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "access_token", valid_579470
  var valid_579471 = query.getOrDefault("upload_protocol")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "upload_protocol", valid_579471
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

proc call*(call_579473: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates the entire contents of that resource.
  ## 
  ## Implements the FHIR standard [conditional update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cond-update).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## If the search criteria identify zero matches, and the supplied resource
  ## body contains an `id`, and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID. If the search criteria identify zero
  ## matches, and the supplied resource body does not contain an `id`, the
  ## resource will be created with a server-assigned ID as per the
  ## create method.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_579473.validator(path, query, header, formData, body)
  let scheme = call_579473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579473.url(scheme.get, call_579473.host, call_579473.base,
                         call_579473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579473, url, valid)

proc call*(call_579474: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579456;
          `type`: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates the entire contents of that resource.
  ## 
  ## Implements the FHIR standard [conditional update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cond-update).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## If the search criteria identify zero matches, and the supplied resource
  ## body contains an `id`, and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID. If the search criteria identify zero
  ## matches, and the supplied resource body does not contain an `id`, the
  ## resource will be created with a server-assigned ID as per the
  ## create method.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   type: string (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
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
  ##         : The name of the FHIR store this resource belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579475 = newJObject()
  var query_579476 = newJObject()
  var body_579477 = newJObject()
  add(query_579476, "key", newJString(key))
  add(query_579476, "prettyPrint", newJBool(prettyPrint))
  add(query_579476, "oauth_token", newJString(oauthToken))
  add(query_579476, "$.xgafv", newJString(Xgafv))
  add(path_579475, "type", newJString(`type`))
  add(query_579476, "alt", newJString(alt))
  add(query_579476, "uploadType", newJString(uploadType))
  add(query_579476, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579477 = body
  add(query_579476, "callback", newJString(callback))
  add(path_579475, "parent", newJString(parent))
  add(query_579476, "fields", newJString(fields))
  add(query_579476, "access_token", newJString(accessToken))
  add(query_579476, "upload_protocol", newJString(uploadProtocol))
  result = call_579474.call(path_579475, query_579476, nil, nil, body_579477)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579456(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579457,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579458,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579478 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579480(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579479(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a FHIR resource.
  ## 
  ## Implements the FHIR standard [create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#create),
  ## which creates a new resource with a server-assigned resource ID.
  ## 
  ## Also supports the FHIR standard [conditional create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#ccreate),
  ## specified by supplying an `If-None-Exist` header containing a FHIR search
  ## query. If no resources match this search query, the server processes the
  ## create operation as normal.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource as it was created on the server, including the
  ## server-assigned resource ID and version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to create, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_579481 = path.getOrDefault("type")
  valid_579481 = validateParameter(valid_579481, JString, required = true,
                                 default = nil)
  if valid_579481 != nil:
    section.add "type", valid_579481
  var valid_579482 = path.getOrDefault("parent")
  valid_579482 = validateParameter(valid_579482, JString, required = true,
                                 default = nil)
  if valid_579482 != nil:
    section.add "parent", valid_579482
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
  var valid_579483 = query.getOrDefault("key")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "key", valid_579483
  var valid_579484 = query.getOrDefault("prettyPrint")
  valid_579484 = validateParameter(valid_579484, JBool, required = false,
                                 default = newJBool(true))
  if valid_579484 != nil:
    section.add "prettyPrint", valid_579484
  var valid_579485 = query.getOrDefault("oauth_token")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "oauth_token", valid_579485
  var valid_579486 = query.getOrDefault("$.xgafv")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = newJString("1"))
  if valid_579486 != nil:
    section.add "$.xgafv", valid_579486
  var valid_579487 = query.getOrDefault("alt")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = newJString("json"))
  if valid_579487 != nil:
    section.add "alt", valid_579487
  var valid_579488 = query.getOrDefault("uploadType")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "uploadType", valid_579488
  var valid_579489 = query.getOrDefault("quotaUser")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "quotaUser", valid_579489
  var valid_579490 = query.getOrDefault("callback")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "callback", valid_579490
  var valid_579491 = query.getOrDefault("fields")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "fields", valid_579491
  var valid_579492 = query.getOrDefault("access_token")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "access_token", valid_579492
  var valid_579493 = query.getOrDefault("upload_protocol")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "upload_protocol", valid_579493
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

proc call*(call_579495: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a FHIR resource.
  ## 
  ## Implements the FHIR standard [create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#create),
  ## which creates a new resource with a server-assigned resource ID.
  ## 
  ## Also supports the FHIR standard [conditional create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#ccreate),
  ## specified by supplying an `If-None-Exist` header containing a FHIR search
  ## query. If no resources match this search query, the server processes the
  ## create operation as normal.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource as it was created on the server, including the
  ## server-assigned resource ID and version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_579495.validator(path, query, header, formData, body)
  let scheme = call_579495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579495.url(scheme.get, call_579495.host, call_579495.base,
                         call_579495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579495, url, valid)

proc call*(call_579496: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579478;
          `type`: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirCreate
  ## Creates a FHIR resource.
  ## 
  ## Implements the FHIR standard [create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#create),
  ## which creates a new resource with a server-assigned resource ID.
  ## 
  ## Also supports the FHIR standard [conditional create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#ccreate),
  ## specified by supplying an `If-None-Exist` header containing a FHIR search
  ## query. If no resources match this search query, the server processes the
  ## create operation as normal.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource as it was created on the server, including the
  ## server-assigned resource ID and version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   type: string (required)
  ##       : The FHIR resource type to create, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
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
  ##         : The name of the FHIR store this resource belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579497 = newJObject()
  var query_579498 = newJObject()
  var body_579499 = newJObject()
  add(query_579498, "key", newJString(key))
  add(query_579498, "prettyPrint", newJBool(prettyPrint))
  add(query_579498, "oauth_token", newJString(oauthToken))
  add(query_579498, "$.xgafv", newJString(Xgafv))
  add(path_579497, "type", newJString(`type`))
  add(query_579498, "alt", newJString(alt))
  add(query_579498, "uploadType", newJString(uploadType))
  add(query_579498, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579499 = body
  add(query_579498, "callback", newJString(callback))
  add(path_579497, "parent", newJString(parent))
  add(query_579498, "fields", newJString(fields))
  add(query_579498, "access_token", newJString(accessToken))
  add(query_579498, "upload_protocol", newJString(uploadProtocol))
  result = call_579496.call(path_579497, query_579498, nil, nil, body_579499)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579478(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579479,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579480,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579520 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579522(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579521(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates part of that resource by applying the operations
  ## specified in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [conditional patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## 
  ## The request body must contain a JSON Patch document, and the request
  ## headers must contain `Content-Type: application/json-patch+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_579523 = path.getOrDefault("type")
  valid_579523 = validateParameter(valid_579523, JString, required = true,
                                 default = nil)
  if valid_579523 != nil:
    section.add "type", valid_579523
  var valid_579524 = path.getOrDefault("parent")
  valid_579524 = validateParameter(valid_579524, JString, required = true,
                                 default = nil)
  if valid_579524 != nil:
    section.add "parent", valid_579524
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
  var valid_579525 = query.getOrDefault("key")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "key", valid_579525
  var valid_579526 = query.getOrDefault("prettyPrint")
  valid_579526 = validateParameter(valid_579526, JBool, required = false,
                                 default = newJBool(true))
  if valid_579526 != nil:
    section.add "prettyPrint", valid_579526
  var valid_579527 = query.getOrDefault("oauth_token")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "oauth_token", valid_579527
  var valid_579528 = query.getOrDefault("$.xgafv")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = newJString("1"))
  if valid_579528 != nil:
    section.add "$.xgafv", valid_579528
  var valid_579529 = query.getOrDefault("alt")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = newJString("json"))
  if valid_579529 != nil:
    section.add "alt", valid_579529
  var valid_579530 = query.getOrDefault("uploadType")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "uploadType", valid_579530
  var valid_579531 = query.getOrDefault("quotaUser")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "quotaUser", valid_579531
  var valid_579532 = query.getOrDefault("callback")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "callback", valid_579532
  var valid_579533 = query.getOrDefault("fields")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "fields", valid_579533
  var valid_579534 = query.getOrDefault("access_token")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "access_token", valid_579534
  var valid_579535 = query.getOrDefault("upload_protocol")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = nil)
  if valid_579535 != nil:
    section.add "upload_protocol", valid_579535
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

proc call*(call_579537: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579520;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates part of that resource by applying the operations
  ## specified in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [conditional patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## 
  ## The request body must contain a JSON Patch document, and the request
  ## headers must contain `Content-Type: application/json-patch+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_579537.validator(path, query, header, formData, body)
  let scheme = call_579537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579537.url(scheme.get, call_579537.host, call_579537.base,
                         call_579537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579537, url, valid)

proc call*(call_579538: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579520;
          `type`: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates part of that resource by applying the operations
  ## specified in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [conditional patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## 
  ## The request body must contain a JSON Patch document, and the request
  ## headers must contain `Content-Type: application/json-patch+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   type: string (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
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
  ##         : The name of the FHIR store this resource belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579539 = newJObject()
  var query_579540 = newJObject()
  var body_579541 = newJObject()
  add(query_579540, "key", newJString(key))
  add(query_579540, "prettyPrint", newJBool(prettyPrint))
  add(query_579540, "oauth_token", newJString(oauthToken))
  add(query_579540, "$.xgafv", newJString(Xgafv))
  add(path_579539, "type", newJString(`type`))
  add(query_579540, "alt", newJString(alt))
  add(query_579540, "uploadType", newJString(uploadType))
  add(query_579540, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579541 = body
  add(query_579540, "callback", newJString(callback))
  add(path_579539, "parent", newJString(parent))
  add(query_579540, "fields", newJString(fields))
  add(query_579540, "access_token", newJString(accessToken))
  add(query_579540, "upload_protocol", newJString(uploadProtocol))
  result = call_579538.call(path_579539, query_579540, nil, nil, body_579541)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579520(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579521,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579522,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579500 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579502(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579501(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes FHIR resources that match a search query.
  ## 
  ## Implements the FHIR standard [conditional delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.13.1).
  ## If multiple resources match, all of them will be deleted.
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to delete, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_579503 = path.getOrDefault("type")
  valid_579503 = validateParameter(valid_579503, JString, required = true,
                                 default = nil)
  if valid_579503 != nil:
    section.add "type", valid_579503
  var valid_579504 = path.getOrDefault("parent")
  valid_579504 = validateParameter(valid_579504, JString, required = true,
                                 default = nil)
  if valid_579504 != nil:
    section.add "parent", valid_579504
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
  var valid_579505 = query.getOrDefault("key")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "key", valid_579505
  var valid_579506 = query.getOrDefault("prettyPrint")
  valid_579506 = validateParameter(valid_579506, JBool, required = false,
                                 default = newJBool(true))
  if valid_579506 != nil:
    section.add "prettyPrint", valid_579506
  var valid_579507 = query.getOrDefault("oauth_token")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "oauth_token", valid_579507
  var valid_579508 = query.getOrDefault("$.xgafv")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = newJString("1"))
  if valid_579508 != nil:
    section.add "$.xgafv", valid_579508
  var valid_579509 = query.getOrDefault("alt")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = newJString("json"))
  if valid_579509 != nil:
    section.add "alt", valid_579509
  var valid_579510 = query.getOrDefault("uploadType")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "uploadType", valid_579510
  var valid_579511 = query.getOrDefault("quotaUser")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "quotaUser", valid_579511
  var valid_579512 = query.getOrDefault("callback")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "callback", valid_579512
  var valid_579513 = query.getOrDefault("fields")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "fields", valid_579513
  var valid_579514 = query.getOrDefault("access_token")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "access_token", valid_579514
  var valid_579515 = query.getOrDefault("upload_protocol")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "upload_protocol", valid_579515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579516: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes FHIR resources that match a search query.
  ## 
  ## Implements the FHIR standard [conditional delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.13.1).
  ## If multiple resources match, all of them will be deleted.
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ## 
  let valid = call_579516.validator(path, query, header, formData, body)
  let scheme = call_579516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579516.url(scheme.get, call_579516.host, call_579516.base,
                         call_579516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579516, url, valid)

proc call*(call_579517: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579500;
          `type`: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete
  ## Deletes FHIR resources that match a search query.
  ## 
  ## Implements the FHIR standard [conditional delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.13.1).
  ## If multiple resources match, all of them will be deleted.
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   type: string (required)
  ##       : The FHIR resource type to delete, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the FHIR store this resource belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579518 = newJObject()
  var query_579519 = newJObject()
  add(query_579519, "key", newJString(key))
  add(query_579519, "prettyPrint", newJBool(prettyPrint))
  add(query_579519, "oauth_token", newJString(oauthToken))
  add(query_579519, "$.xgafv", newJString(Xgafv))
  add(path_579518, "type", newJString(`type`))
  add(query_579519, "alt", newJString(alt))
  add(query_579519, "uploadType", newJString(uploadType))
  add(query_579519, "quotaUser", newJString(quotaUser))
  add(query_579519, "callback", newJString(callback))
  add(path_579518, "parent", newJString(parent))
  add(query_579519, "fields", newJString(fields))
  add(query_579519, "access_token", newJString(accessToken))
  add(query_579519, "upload_protocol", newJString(uploadProtocol))
  result = call_579517.call(path_579518, query_579519, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579500(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579501,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579502,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579564 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579566(
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
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579565(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new FHIR store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this FHIR store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579567 = path.getOrDefault("parent")
  valid_579567 = validateParameter(valid_579567, JString, required = true,
                                 default = nil)
  if valid_579567 != nil:
    section.add "parent", valid_579567
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
  ##   fhirStoreId: JString
  ##              : The ID of the FHIR store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579568 = query.getOrDefault("key")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "key", valid_579568
  var valid_579569 = query.getOrDefault("prettyPrint")
  valid_579569 = validateParameter(valid_579569, JBool, required = false,
                                 default = newJBool(true))
  if valid_579569 != nil:
    section.add "prettyPrint", valid_579569
  var valid_579570 = query.getOrDefault("oauth_token")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "oauth_token", valid_579570
  var valid_579571 = query.getOrDefault("$.xgafv")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = newJString("1"))
  if valid_579571 != nil:
    section.add "$.xgafv", valid_579571
  var valid_579572 = query.getOrDefault("alt")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = newJString("json"))
  if valid_579572 != nil:
    section.add "alt", valid_579572
  var valid_579573 = query.getOrDefault("uploadType")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = nil)
  if valid_579573 != nil:
    section.add "uploadType", valid_579573
  var valid_579574 = query.getOrDefault("quotaUser")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "quotaUser", valid_579574
  var valid_579575 = query.getOrDefault("callback")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = nil)
  if valid_579575 != nil:
    section.add "callback", valid_579575
  var valid_579576 = query.getOrDefault("fhirStoreId")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "fhirStoreId", valid_579576
  var valid_579577 = query.getOrDefault("fields")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = nil)
  if valid_579577 != nil:
    section.add "fields", valid_579577
  var valid_579578 = query.getOrDefault("access_token")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "access_token", valid_579578
  var valid_579579 = query.getOrDefault("upload_protocol")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "upload_protocol", valid_579579
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

proc call*(call_579581: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579564;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new FHIR store within the parent dataset.
  ## 
  let valid = call_579581.validator(path, query, header, formData, body)
  let scheme = call_579581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579581.url(scheme.get, call_579581.host, call_579581.base,
                         call_579581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579581, url, valid)

proc call*(call_579582: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579564;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fhirStoreId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresCreate
  ## Creates a new FHIR store within the parent dataset.
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
  ##         : The name of the dataset this FHIR store belongs to.
  ##   fhirStoreId: string
  ##              : The ID of the FHIR store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579583 = newJObject()
  var query_579584 = newJObject()
  var body_579585 = newJObject()
  add(query_579584, "key", newJString(key))
  add(query_579584, "prettyPrint", newJBool(prettyPrint))
  add(query_579584, "oauth_token", newJString(oauthToken))
  add(query_579584, "$.xgafv", newJString(Xgafv))
  add(query_579584, "alt", newJString(alt))
  add(query_579584, "uploadType", newJString(uploadType))
  add(query_579584, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579585 = body
  add(query_579584, "callback", newJString(callback))
  add(path_579583, "parent", newJString(parent))
  add(query_579584, "fhirStoreId", newJString(fhirStoreId))
  add(query_579584, "fields", newJString(fields))
  add(query_579584, "access_token", newJString(accessToken))
  add(query_579584, "upload_protocol", newJString(uploadProtocol))
  result = call_579582.call(path_579583, query_579584, nil, nil, body_579585)

var healthcareProjectsLocationsDatasetsFhirStoresCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579564(
    name: "healthcareProjectsLocationsDatasetsFhirStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579565,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579566,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579542 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresList_579544(
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
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresList_579543(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the FHIR stores in the given dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579545 = path.getOrDefault("parent")
  valid_579545 = validateParameter(valid_579545, JString, required = true,
                                 default = nil)
  if valid_579545 != nil:
    section.add "parent", valid_579545
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
  ##           : Limit on the number of FHIR stores to return in a single response.  If zero
  ## the default page size of 100 is used.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579546 = query.getOrDefault("key")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "key", valid_579546
  var valid_579547 = query.getOrDefault("prettyPrint")
  valid_579547 = validateParameter(valid_579547, JBool, required = false,
                                 default = newJBool(true))
  if valid_579547 != nil:
    section.add "prettyPrint", valid_579547
  var valid_579548 = query.getOrDefault("oauth_token")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "oauth_token", valid_579548
  var valid_579549 = query.getOrDefault("$.xgafv")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = newJString("1"))
  if valid_579549 != nil:
    section.add "$.xgafv", valid_579549
  var valid_579550 = query.getOrDefault("pageSize")
  valid_579550 = validateParameter(valid_579550, JInt, required = false, default = nil)
  if valid_579550 != nil:
    section.add "pageSize", valid_579550
  var valid_579551 = query.getOrDefault("alt")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = newJString("json"))
  if valid_579551 != nil:
    section.add "alt", valid_579551
  var valid_579552 = query.getOrDefault("uploadType")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "uploadType", valid_579552
  var valid_579553 = query.getOrDefault("quotaUser")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "quotaUser", valid_579553
  var valid_579554 = query.getOrDefault("filter")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = nil)
  if valid_579554 != nil:
    section.add "filter", valid_579554
  var valid_579555 = query.getOrDefault("pageToken")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = nil)
  if valid_579555 != nil:
    section.add "pageToken", valid_579555
  var valid_579556 = query.getOrDefault("callback")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "callback", valid_579556
  var valid_579557 = query.getOrDefault("fields")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "fields", valid_579557
  var valid_579558 = query.getOrDefault("access_token")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "access_token", valid_579558
  var valid_579559 = query.getOrDefault("upload_protocol")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "upload_protocol", valid_579559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579560: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579542;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the FHIR stores in the given dataset.
  ## 
  let valid = call_579560.validator(path, query, header, formData, body)
  let scheme = call_579560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579560.url(scheme.get, call_579560.host, call_579560.base,
                         call_579560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579560, url, valid)

proc call*(call_579561: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579542;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresList
  ## Lists the FHIR stores in the given dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of FHIR stores to return in a single response.  If zero
  ## the default page size of 100 is used.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the dataset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579562 = newJObject()
  var query_579563 = newJObject()
  add(query_579563, "key", newJString(key))
  add(query_579563, "prettyPrint", newJBool(prettyPrint))
  add(query_579563, "oauth_token", newJString(oauthToken))
  add(query_579563, "$.xgafv", newJString(Xgafv))
  add(query_579563, "pageSize", newJInt(pageSize))
  add(query_579563, "alt", newJString(alt))
  add(query_579563, "uploadType", newJString(uploadType))
  add(query_579563, "quotaUser", newJString(quotaUser))
  add(query_579563, "filter", newJString(filter))
  add(query_579563, "pageToken", newJString(pageToken))
  add(query_579563, "callback", newJString(callback))
  add(path_579562, "parent", newJString(parent))
  add(query_579563, "fields", newJString(fields))
  add(query_579563, "access_token", newJString(accessToken))
  add(query_579563, "upload_protocol", newJString(uploadProtocol))
  result = call_579561.call(path_579562, query_579563, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresList* = Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579542(
    name: "healthcareProjectsLocationsDatasetsFhirStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresList_579543,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresList_579544,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579608 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579610(
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
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579609(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new HL7v2 store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this HL7v2 store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579611 = path.getOrDefault("parent")
  valid_579611 = validateParameter(valid_579611, JString, required = true,
                                 default = nil)
  if valid_579611 != nil:
    section.add "parent", valid_579611
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   hl7V2StoreId: JString
  ##               : The ID of the HL7v2 store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
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
  var valid_579612 = query.getOrDefault("key")
  valid_579612 = validateParameter(valid_579612, JString, required = false,
                                 default = nil)
  if valid_579612 != nil:
    section.add "key", valid_579612
  var valid_579613 = query.getOrDefault("prettyPrint")
  valid_579613 = validateParameter(valid_579613, JBool, required = false,
                                 default = newJBool(true))
  if valid_579613 != nil:
    section.add "prettyPrint", valid_579613
  var valid_579614 = query.getOrDefault("oauth_token")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = nil)
  if valid_579614 != nil:
    section.add "oauth_token", valid_579614
  var valid_579615 = query.getOrDefault("hl7V2StoreId")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "hl7V2StoreId", valid_579615
  var valid_579616 = query.getOrDefault("$.xgafv")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = newJString("1"))
  if valid_579616 != nil:
    section.add "$.xgafv", valid_579616
  var valid_579617 = query.getOrDefault("alt")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = newJString("json"))
  if valid_579617 != nil:
    section.add "alt", valid_579617
  var valid_579618 = query.getOrDefault("uploadType")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "uploadType", valid_579618
  var valid_579619 = query.getOrDefault("quotaUser")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "quotaUser", valid_579619
  var valid_579620 = query.getOrDefault("callback")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = nil)
  if valid_579620 != nil:
    section.add "callback", valid_579620
  var valid_579621 = query.getOrDefault("fields")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "fields", valid_579621
  var valid_579622 = query.getOrDefault("access_token")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "access_token", valid_579622
  var valid_579623 = query.getOrDefault("upload_protocol")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = nil)
  if valid_579623 != nil:
    section.add "upload_protocol", valid_579623
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

proc call*(call_579625: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new HL7v2 store within the parent dataset.
  ## 
  let valid = call_579625.validator(path, query, header, formData, body)
  let scheme = call_579625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579625.url(scheme.get, call_579625.host, call_579625.base,
                         call_579625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579625, url, valid)

proc call*(call_579626: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579608;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; hl7V2StoreId: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresCreate
  ## Creates a new HL7v2 store within the parent dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   hl7V2StoreId: string
  ##               : The ID of the HL7v2 store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
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
  ##         : The name of the dataset this HL7v2 store belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579627 = newJObject()
  var query_579628 = newJObject()
  var body_579629 = newJObject()
  add(query_579628, "key", newJString(key))
  add(query_579628, "prettyPrint", newJBool(prettyPrint))
  add(query_579628, "oauth_token", newJString(oauthToken))
  add(query_579628, "hl7V2StoreId", newJString(hl7V2StoreId))
  add(query_579628, "$.xgafv", newJString(Xgafv))
  add(query_579628, "alt", newJString(alt))
  add(query_579628, "uploadType", newJString(uploadType))
  add(query_579628, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579629 = body
  add(query_579628, "callback", newJString(callback))
  add(path_579627, "parent", newJString(parent))
  add(query_579628, "fields", newJString(fields))
  add(query_579628, "access_token", newJString(accessToken))
  add(query_579628, "upload_protocol", newJString(uploadProtocol))
  result = call_579626.call(path_579627, query_579628, nil, nil, body_579629)

var healthcareProjectsLocationsDatasetsHl7V2StoresCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579608(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579609,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579610,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579586 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579588(
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
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579587(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the HL7v2 stores in the given dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579589 = path.getOrDefault("parent")
  valid_579589 = validateParameter(valid_579589, JString, required = true,
                                 default = nil)
  if valid_579589 != nil:
    section.add "parent", valid_579589
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
  ##           : Limit on the number of HL7v2 stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579590 = query.getOrDefault("key")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "key", valid_579590
  var valid_579591 = query.getOrDefault("prettyPrint")
  valid_579591 = validateParameter(valid_579591, JBool, required = false,
                                 default = newJBool(true))
  if valid_579591 != nil:
    section.add "prettyPrint", valid_579591
  var valid_579592 = query.getOrDefault("oauth_token")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "oauth_token", valid_579592
  var valid_579593 = query.getOrDefault("$.xgafv")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = newJString("1"))
  if valid_579593 != nil:
    section.add "$.xgafv", valid_579593
  var valid_579594 = query.getOrDefault("pageSize")
  valid_579594 = validateParameter(valid_579594, JInt, required = false, default = nil)
  if valid_579594 != nil:
    section.add "pageSize", valid_579594
  var valid_579595 = query.getOrDefault("alt")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = newJString("json"))
  if valid_579595 != nil:
    section.add "alt", valid_579595
  var valid_579596 = query.getOrDefault("uploadType")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "uploadType", valid_579596
  var valid_579597 = query.getOrDefault("quotaUser")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "quotaUser", valid_579597
  var valid_579598 = query.getOrDefault("filter")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "filter", valid_579598
  var valid_579599 = query.getOrDefault("pageToken")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "pageToken", valid_579599
  var valid_579600 = query.getOrDefault("callback")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = nil)
  if valid_579600 != nil:
    section.add "callback", valid_579600
  var valid_579601 = query.getOrDefault("fields")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "fields", valid_579601
  var valid_579602 = query.getOrDefault("access_token")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "access_token", valid_579602
  var valid_579603 = query.getOrDefault("upload_protocol")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "upload_protocol", valid_579603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579604: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579586;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the HL7v2 stores in the given dataset.
  ## 
  let valid = call_579604.validator(path, query, header, formData, body)
  let scheme = call_579604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579604.url(scheme.get, call_579604.host, call_579604.base,
                         call_579604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579604, url, valid)

proc call*(call_579605: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579586;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresList
  ## Lists the HL7v2 stores in the given dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of HL7v2 stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the dataset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579606 = newJObject()
  var query_579607 = newJObject()
  add(query_579607, "key", newJString(key))
  add(query_579607, "prettyPrint", newJBool(prettyPrint))
  add(query_579607, "oauth_token", newJString(oauthToken))
  add(query_579607, "$.xgafv", newJString(Xgafv))
  add(query_579607, "pageSize", newJInt(pageSize))
  add(query_579607, "alt", newJString(alt))
  add(query_579607, "uploadType", newJString(uploadType))
  add(query_579607, "quotaUser", newJString(quotaUser))
  add(query_579607, "filter", newJString(filter))
  add(query_579607, "pageToken", newJString(pageToken))
  add(query_579607, "callback", newJString(callback))
  add(path_579606, "parent", newJString(parent))
  add(query_579607, "fields", newJString(fields))
  add(query_579607, "access_token", newJString(accessToken))
  add(query_579607, "upload_protocol", newJString(uploadProtocol))
  result = call_579605.call(path_579606, query_579607, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579586(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579587,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579588,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579653 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579655(
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
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579654(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this message belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579656 = path.getOrDefault("parent")
  valid_579656 = validateParameter(valid_579656, JString, required = true,
                                 default = nil)
  if valid_579656 != nil:
    section.add "parent", valid_579656
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
  var valid_579657 = query.getOrDefault("key")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "key", valid_579657
  var valid_579658 = query.getOrDefault("prettyPrint")
  valid_579658 = validateParameter(valid_579658, JBool, required = false,
                                 default = newJBool(true))
  if valid_579658 != nil:
    section.add "prettyPrint", valid_579658
  var valid_579659 = query.getOrDefault("oauth_token")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "oauth_token", valid_579659
  var valid_579660 = query.getOrDefault("$.xgafv")
  valid_579660 = validateParameter(valid_579660, JString, required = false,
                                 default = newJString("1"))
  if valid_579660 != nil:
    section.add "$.xgafv", valid_579660
  var valid_579661 = query.getOrDefault("alt")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = newJString("json"))
  if valid_579661 != nil:
    section.add "alt", valid_579661
  var valid_579662 = query.getOrDefault("uploadType")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = nil)
  if valid_579662 != nil:
    section.add "uploadType", valid_579662
  var valid_579663 = query.getOrDefault("quotaUser")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "quotaUser", valid_579663
  var valid_579664 = query.getOrDefault("callback")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "callback", valid_579664
  var valid_579665 = query.getOrDefault("fields")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "fields", valid_579665
  var valid_579666 = query.getOrDefault("access_token")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "access_token", valid_579666
  var valid_579667 = query.getOrDefault("upload_protocol")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "upload_protocol", valid_579667
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

proc call*(call_579669: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579653;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
  ## 
  let valid = call_579669.validator(path, query, header, formData, body)
  let scheme = call_579669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579669.url(scheme.get, call_579669.host, call_579669.base,
                         call_579669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579669, url, valid)

proc call*(call_579670: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579653;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
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
  ##         : The name of the dataset this message belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579671 = newJObject()
  var query_579672 = newJObject()
  var body_579673 = newJObject()
  add(query_579672, "key", newJString(key))
  add(query_579672, "prettyPrint", newJBool(prettyPrint))
  add(query_579672, "oauth_token", newJString(oauthToken))
  add(query_579672, "$.xgafv", newJString(Xgafv))
  add(query_579672, "alt", newJString(alt))
  add(query_579672, "uploadType", newJString(uploadType))
  add(query_579672, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579673 = body
  add(query_579672, "callback", newJString(callback))
  add(path_579671, "parent", newJString(parent))
  add(query_579672, "fields", newJString(fields))
  add(query_579672, "access_token", newJString(accessToken))
  add(query_579672, "upload_protocol", newJString(uploadProtocol))
  result = call_579670.call(path_579671, query_579672, nil, nil, body_579673)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579653(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579654,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579655,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579630 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579632(
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
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579631(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the HL7v2 store to retrieve messages from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579633 = path.getOrDefault("parent")
  valid_579633 = validateParameter(valid_579633, JString, required = true,
                                 default = nil)
  if valid_579633 != nil:
    section.add "parent", valid_579633
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
  ##           : Limit on the number of messages to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Orders messages returned by the specified order_by clause.
  ## Syntax: https://cloud.google.com/apis/design/design_patterns#sorting_order
  ## 
  ## Fields available for ordering are:
  ## 
  ## *  `send_time`
  ##   filter: JString
  ##         : Restricts messages returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## 
  ## Fields/functions available for filtering are:
  ## 
  ## *  `message_type`, from the MSH-9 segment; for example
  ## `NOT message_type = "ADT"`
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment; for example
  ## `send_date < "2017-01-02"`
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment; for example
  ## `send_time < "2017-01-02T00:00:00-05:00"`
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment; for example `send_facility = "ABC"`
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using re2 (http://code.google.com/p/re2/)
  ## syntax; for example `HL7RegExp("^.*\|.*\|EMERG")`
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments; for example `PatientId("123456", "MRN")`
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map, for example `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label, for example `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported, for example these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported, for example this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
  ## 
  ## The HasLabel(x) and Label(x) syntax from previous API versions are
  ## deprecated; replaced by the `labels.x` syntax.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579634 = query.getOrDefault("key")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "key", valid_579634
  var valid_579635 = query.getOrDefault("prettyPrint")
  valid_579635 = validateParameter(valid_579635, JBool, required = false,
                                 default = newJBool(true))
  if valid_579635 != nil:
    section.add "prettyPrint", valid_579635
  var valid_579636 = query.getOrDefault("oauth_token")
  valid_579636 = validateParameter(valid_579636, JString, required = false,
                                 default = nil)
  if valid_579636 != nil:
    section.add "oauth_token", valid_579636
  var valid_579637 = query.getOrDefault("$.xgafv")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = newJString("1"))
  if valid_579637 != nil:
    section.add "$.xgafv", valid_579637
  var valid_579638 = query.getOrDefault("pageSize")
  valid_579638 = validateParameter(valid_579638, JInt, required = false, default = nil)
  if valid_579638 != nil:
    section.add "pageSize", valid_579638
  var valid_579639 = query.getOrDefault("alt")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = newJString("json"))
  if valid_579639 != nil:
    section.add "alt", valid_579639
  var valid_579640 = query.getOrDefault("uploadType")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = nil)
  if valid_579640 != nil:
    section.add "uploadType", valid_579640
  var valid_579641 = query.getOrDefault("quotaUser")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "quotaUser", valid_579641
  var valid_579642 = query.getOrDefault("orderBy")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "orderBy", valid_579642
  var valid_579643 = query.getOrDefault("filter")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "filter", valid_579643
  var valid_579644 = query.getOrDefault("pageToken")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "pageToken", valid_579644
  var valid_579645 = query.getOrDefault("callback")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "callback", valid_579645
  var valid_579646 = query.getOrDefault("fields")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "fields", valid_579646
  var valid_579647 = query.getOrDefault("access_token")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = nil)
  if valid_579647 != nil:
    section.add "access_token", valid_579647
  var valid_579648 = query.getOrDefault("upload_protocol")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "upload_protocol", valid_579648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579649: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ## 
  let valid = call_579649.validator(path, query, header, formData, body)
  let scheme = call_579649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579649.url(scheme.get, call_579649.host, call_579649.base,
                         call_579649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579649, url, valid)

proc call*(call_579650: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579630;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of messages to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Orders messages returned by the specified order_by clause.
  ## Syntax: https://cloud.google.com/apis/design/design_patterns#sorting_order
  ## 
  ## Fields available for ordering are:
  ## 
  ## *  `send_time`
  ##   filter: string
  ##         : Restricts messages returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## 
  ## Fields/functions available for filtering are:
  ## 
  ## *  `message_type`, from the MSH-9 segment; for example
  ## `NOT message_type = "ADT"`
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment; for example
  ## `send_date < "2017-01-02"`
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment; for example
  ## `send_time < "2017-01-02T00:00:00-05:00"`
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment; for example `send_facility = "ABC"`
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using re2 (http://code.google.com/p/re2/)
  ## syntax; for example `HL7RegExp("^.*\|.*\|EMERG")`
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments; for example `PatientId("123456", "MRN")`
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map, for example `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label, for example `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported, for example these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported, for example this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
  ## 
  ## The HasLabel(x) and Label(x) syntax from previous API versions are
  ## deprecated; replaced by the `labels.x` syntax.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the HL7v2 store to retrieve messages from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579651 = newJObject()
  var query_579652 = newJObject()
  add(query_579652, "key", newJString(key))
  add(query_579652, "prettyPrint", newJBool(prettyPrint))
  add(query_579652, "oauth_token", newJString(oauthToken))
  add(query_579652, "$.xgafv", newJString(Xgafv))
  add(query_579652, "pageSize", newJInt(pageSize))
  add(query_579652, "alt", newJString(alt))
  add(query_579652, "uploadType", newJString(uploadType))
  add(query_579652, "quotaUser", newJString(quotaUser))
  add(query_579652, "orderBy", newJString(orderBy))
  add(query_579652, "filter", newJString(filter))
  add(query_579652, "pageToken", newJString(pageToken))
  add(query_579652, "callback", newJString(callback))
  add(path_579651, "parent", newJString(parent))
  add(query_579652, "fields", newJString(fields))
  add(query_579652, "access_token", newJString(accessToken))
  add(query_579652, "upload_protocol", newJString(uploadProtocol))
  result = call_579650.call(path_579651, query_579652, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579630(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579631,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579632,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579674 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579676(
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
               (kind: ConstantSegment, value: "/messages:ingest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579675(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the HL7v2 store this message belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579677 = path.getOrDefault("parent")
  valid_579677 = validateParameter(valid_579677, JString, required = true,
                                 default = nil)
  if valid_579677 != nil:
    section.add "parent", valid_579677
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
  var valid_579678 = query.getOrDefault("key")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = nil)
  if valid_579678 != nil:
    section.add "key", valid_579678
  var valid_579679 = query.getOrDefault("prettyPrint")
  valid_579679 = validateParameter(valid_579679, JBool, required = false,
                                 default = newJBool(true))
  if valid_579679 != nil:
    section.add "prettyPrint", valid_579679
  var valid_579680 = query.getOrDefault("oauth_token")
  valid_579680 = validateParameter(valid_579680, JString, required = false,
                                 default = nil)
  if valid_579680 != nil:
    section.add "oauth_token", valid_579680
  var valid_579681 = query.getOrDefault("$.xgafv")
  valid_579681 = validateParameter(valid_579681, JString, required = false,
                                 default = newJString("1"))
  if valid_579681 != nil:
    section.add "$.xgafv", valid_579681
  var valid_579682 = query.getOrDefault("alt")
  valid_579682 = validateParameter(valid_579682, JString, required = false,
                                 default = newJString("json"))
  if valid_579682 != nil:
    section.add "alt", valid_579682
  var valid_579683 = query.getOrDefault("uploadType")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "uploadType", valid_579683
  var valid_579684 = query.getOrDefault("quotaUser")
  valid_579684 = validateParameter(valid_579684, JString, required = false,
                                 default = nil)
  if valid_579684 != nil:
    section.add "quotaUser", valid_579684
  var valid_579685 = query.getOrDefault("callback")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "callback", valid_579685
  var valid_579686 = query.getOrDefault("fields")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "fields", valid_579686
  var valid_579687 = query.getOrDefault("access_token")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "access_token", valid_579687
  var valid_579688 = query.getOrDefault("upload_protocol")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "upload_protocol", valid_579688
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

proc call*(call_579690: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579674;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
  ## 
  let valid = call_579690.validator(path, query, header, formData, body)
  let scheme = call_579690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579690.url(scheme.get, call_579690.host, call_579690.base,
                         call_579690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579690, url, valid)

proc call*(call_579691: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579674;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
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
  ##         : The name of the HL7v2 store this message belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579692 = newJObject()
  var query_579693 = newJObject()
  var body_579694 = newJObject()
  add(query_579693, "key", newJString(key))
  add(query_579693, "prettyPrint", newJBool(prettyPrint))
  add(query_579693, "oauth_token", newJString(oauthToken))
  add(query_579693, "$.xgafv", newJString(Xgafv))
  add(query_579693, "alt", newJString(alt))
  add(query_579693, "uploadType", newJString(uploadType))
  add(query_579693, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579694 = body
  add(query_579693, "callback", newJString(callback))
  add(path_579692, "parent", newJString(parent))
  add(query_579693, "fields", newJString(fields))
  add(query_579693, "access_token", newJString(accessToken))
  add(query_579693, "upload_protocol", newJString(uploadProtocol))
  result = call_579691.call(path_579692, query_579693, nil, nil, body_579694)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579674(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/messages:ingest", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579675,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579676,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579715 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579717(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579716(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource. Returns NOT_FOUND error if
  ## the resource does not exist. Returns an empty policy if the resource exists
  ## but does not have a policy set.
  ## 
  ## Authorization requires the Google IAM permission
  ## `healthcare.AnnotationStores.getIamPolicy` on the specified
  ## resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579718 = path.getOrDefault("resource")
  valid_579718 = validateParameter(valid_579718, JString, required = true,
                                 default = nil)
  if valid_579718 != nil:
    section.add "resource", valid_579718
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
  var valid_579719 = query.getOrDefault("key")
  valid_579719 = validateParameter(valid_579719, JString, required = false,
                                 default = nil)
  if valid_579719 != nil:
    section.add "key", valid_579719
  var valid_579720 = query.getOrDefault("prettyPrint")
  valid_579720 = validateParameter(valid_579720, JBool, required = false,
                                 default = newJBool(true))
  if valid_579720 != nil:
    section.add "prettyPrint", valid_579720
  var valid_579721 = query.getOrDefault("oauth_token")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = nil)
  if valid_579721 != nil:
    section.add "oauth_token", valid_579721
  var valid_579722 = query.getOrDefault("$.xgafv")
  valid_579722 = validateParameter(valid_579722, JString, required = false,
                                 default = newJString("1"))
  if valid_579722 != nil:
    section.add "$.xgafv", valid_579722
  var valid_579723 = query.getOrDefault("alt")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = newJString("json"))
  if valid_579723 != nil:
    section.add "alt", valid_579723
  var valid_579724 = query.getOrDefault("uploadType")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = nil)
  if valid_579724 != nil:
    section.add "uploadType", valid_579724
  var valid_579725 = query.getOrDefault("quotaUser")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = nil)
  if valid_579725 != nil:
    section.add "quotaUser", valid_579725
  var valid_579726 = query.getOrDefault("callback")
  valid_579726 = validateParameter(valid_579726, JString, required = false,
                                 default = nil)
  if valid_579726 != nil:
    section.add "callback", valid_579726
  var valid_579727 = query.getOrDefault("fields")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "fields", valid_579727
  var valid_579728 = query.getOrDefault("access_token")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "access_token", valid_579728
  var valid_579729 = query.getOrDefault("upload_protocol")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "upload_protocol", valid_579729
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

proc call*(call_579731: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579715;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. Returns NOT_FOUND error if
  ## the resource does not exist. Returns an empty policy if the resource exists
  ## but does not have a policy set.
  ## 
  ## Authorization requires the Google IAM permission
  ## `healthcare.AnnotationStores.getIamPolicy` on the specified
  ## resource
  ## 
  let valid = call_579731.validator(path, query, header, formData, body)
  let scheme = call_579731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579731.url(scheme.get, call_579731.host, call_579731.base,
                         call_579731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579731, url, valid)

proc call*(call_579732: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579715;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy
  ## Gets the access control policy for a resource. Returns NOT_FOUND error if
  ## the resource does not exist. Returns an empty policy if the resource exists
  ## but does not have a policy set.
  ## 
  ## Authorization requires the Google IAM permission
  ## `healthcare.AnnotationStores.getIamPolicy` on the specified
  ## resource
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579733 = newJObject()
  var query_579734 = newJObject()
  var body_579735 = newJObject()
  add(query_579734, "key", newJString(key))
  add(query_579734, "prettyPrint", newJBool(prettyPrint))
  add(query_579734, "oauth_token", newJString(oauthToken))
  add(query_579734, "$.xgafv", newJString(Xgafv))
  add(query_579734, "alt", newJString(alt))
  add(query_579734, "uploadType", newJString(uploadType))
  add(query_579734, "quotaUser", newJString(quotaUser))
  add(path_579733, "resource", newJString(resource))
  if body != nil:
    body_579735 = body
  add(query_579734, "callback", newJString(callback))
  add(query_579734, "fields", newJString(fields))
  add(query_579734, "access_token", newJString(accessToken))
  add(query_579734, "upload_protocol", newJString(uploadProtocol))
  result = call_579732.call(path_579733, query_579734, nil, nil, body_579735)

var healthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579715(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:getIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579716,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_579717,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579695 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579697(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579696(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579698 = path.getOrDefault("resource")
  valid_579698 = validateParameter(valid_579698, JString, required = true,
                                 default = nil)
  if valid_579698 != nil:
    section.add "resource", valid_579698
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
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
  var valid_579699 = query.getOrDefault("key")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = nil)
  if valid_579699 != nil:
    section.add "key", valid_579699
  var valid_579700 = query.getOrDefault("prettyPrint")
  valid_579700 = validateParameter(valid_579700, JBool, required = false,
                                 default = newJBool(true))
  if valid_579700 != nil:
    section.add "prettyPrint", valid_579700
  var valid_579701 = query.getOrDefault("oauth_token")
  valid_579701 = validateParameter(valid_579701, JString, required = false,
                                 default = nil)
  if valid_579701 != nil:
    section.add "oauth_token", valid_579701
  var valid_579702 = query.getOrDefault("$.xgafv")
  valid_579702 = validateParameter(valid_579702, JString, required = false,
                                 default = newJString("1"))
  if valid_579702 != nil:
    section.add "$.xgafv", valid_579702
  var valid_579703 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579703 = validateParameter(valid_579703, JInt, required = false, default = nil)
  if valid_579703 != nil:
    section.add "options.requestedPolicyVersion", valid_579703
  var valid_579704 = query.getOrDefault("alt")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = newJString("json"))
  if valid_579704 != nil:
    section.add "alt", valid_579704
  var valid_579705 = query.getOrDefault("uploadType")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "uploadType", valid_579705
  var valid_579706 = query.getOrDefault("quotaUser")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "quotaUser", valid_579706
  var valid_579707 = query.getOrDefault("callback")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "callback", valid_579707
  var valid_579708 = query.getOrDefault("fields")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = nil)
  if valid_579708 != nil:
    section.add "fields", valid_579708
  var valid_579709 = query.getOrDefault("access_token")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "access_token", valid_579709
  var valid_579710 = query.getOrDefault("upload_protocol")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = nil)
  if valid_579710 != nil:
    section.add "upload_protocol", valid_579710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579711: Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579695;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579711.validator(path, query, header, formData, body)
  let scheme = call_579711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579711.url(scheme.get, call_579711.host, call_579711.base,
                         call_579711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579711, url, valid)

proc call*(call_579712: Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579695;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579713 = newJObject()
  var query_579714 = newJObject()
  add(query_579714, "key", newJString(key))
  add(query_579714, "prettyPrint", newJBool(prettyPrint))
  add(query_579714, "oauth_token", newJString(oauthToken))
  add(query_579714, "$.xgafv", newJString(Xgafv))
  add(query_579714, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579714, "alt", newJString(alt))
  add(query_579714, "uploadType", newJString(uploadType))
  add(query_579714, "quotaUser", newJString(quotaUser))
  add(path_579713, "resource", newJString(resource))
  add(query_579714, "callback", newJString(callback))
  add(query_579714, "fields", newJString(fields))
  add(query_579714, "access_token", newJString(accessToken))
  add(query_579714, "upload_protocol", newJString(uploadProtocol))
  result = call_579712.call(path_579713, query_579714, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579695(
    name: "healthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:getIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579696,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_579697,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579736 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579738(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579737(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579739 = path.getOrDefault("resource")
  valid_579739 = validateParameter(valid_579739, JString, required = true,
                                 default = nil)
  if valid_579739 != nil:
    section.add "resource", valid_579739
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
  var valid_579740 = query.getOrDefault("key")
  valid_579740 = validateParameter(valid_579740, JString, required = false,
                                 default = nil)
  if valid_579740 != nil:
    section.add "key", valid_579740
  var valid_579741 = query.getOrDefault("prettyPrint")
  valid_579741 = validateParameter(valid_579741, JBool, required = false,
                                 default = newJBool(true))
  if valid_579741 != nil:
    section.add "prettyPrint", valid_579741
  var valid_579742 = query.getOrDefault("oauth_token")
  valid_579742 = validateParameter(valid_579742, JString, required = false,
                                 default = nil)
  if valid_579742 != nil:
    section.add "oauth_token", valid_579742
  var valid_579743 = query.getOrDefault("$.xgafv")
  valid_579743 = validateParameter(valid_579743, JString, required = false,
                                 default = newJString("1"))
  if valid_579743 != nil:
    section.add "$.xgafv", valid_579743
  var valid_579744 = query.getOrDefault("alt")
  valid_579744 = validateParameter(valid_579744, JString, required = false,
                                 default = newJString("json"))
  if valid_579744 != nil:
    section.add "alt", valid_579744
  var valid_579745 = query.getOrDefault("uploadType")
  valid_579745 = validateParameter(valid_579745, JString, required = false,
                                 default = nil)
  if valid_579745 != nil:
    section.add "uploadType", valid_579745
  var valid_579746 = query.getOrDefault("quotaUser")
  valid_579746 = validateParameter(valid_579746, JString, required = false,
                                 default = nil)
  if valid_579746 != nil:
    section.add "quotaUser", valid_579746
  var valid_579747 = query.getOrDefault("callback")
  valid_579747 = validateParameter(valid_579747, JString, required = false,
                                 default = nil)
  if valid_579747 != nil:
    section.add "callback", valid_579747
  var valid_579748 = query.getOrDefault("fields")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "fields", valid_579748
  var valid_579749 = query.getOrDefault("access_token")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "access_token", valid_579749
  var valid_579750 = query.getOrDefault("upload_protocol")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = nil)
  if valid_579750 != nil:
    section.add "upload_protocol", valid_579750
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

proc call*(call_579752: Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579736;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579752.validator(path, query, header, formData, body)
  let scheme = call_579752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579752.url(scheme.get, call_579752.host, call_579752.base,
                         call_579752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579752, url, valid)

proc call*(call_579753: Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579736;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579754 = newJObject()
  var query_579755 = newJObject()
  var body_579756 = newJObject()
  add(query_579755, "key", newJString(key))
  add(query_579755, "prettyPrint", newJBool(prettyPrint))
  add(query_579755, "oauth_token", newJString(oauthToken))
  add(query_579755, "$.xgafv", newJString(Xgafv))
  add(query_579755, "alt", newJString(alt))
  add(query_579755, "uploadType", newJString(uploadType))
  add(query_579755, "quotaUser", newJString(quotaUser))
  add(path_579754, "resource", newJString(resource))
  if body != nil:
    body_579756 = body
  add(query_579755, "callback", newJString(callback))
  add(query_579755, "fields", newJString(fields))
  add(query_579755, "access_token", newJString(accessToken))
  add(query_579755, "upload_protocol", newJString(uploadProtocol))
  result = call_579753.call(path_579754, query_579755, nil, nil, body_579756)

var healthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579736(
    name: "healthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:setIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579737,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_579738,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579757 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579759(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579758(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579760 = path.getOrDefault("resource")
  valid_579760 = validateParameter(valid_579760, JString, required = true,
                                 default = nil)
  if valid_579760 != nil:
    section.add "resource", valid_579760
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
  var valid_579761 = query.getOrDefault("key")
  valid_579761 = validateParameter(valid_579761, JString, required = false,
                                 default = nil)
  if valid_579761 != nil:
    section.add "key", valid_579761
  var valid_579762 = query.getOrDefault("prettyPrint")
  valid_579762 = validateParameter(valid_579762, JBool, required = false,
                                 default = newJBool(true))
  if valid_579762 != nil:
    section.add "prettyPrint", valid_579762
  var valid_579763 = query.getOrDefault("oauth_token")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = nil)
  if valid_579763 != nil:
    section.add "oauth_token", valid_579763
  var valid_579764 = query.getOrDefault("$.xgafv")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = newJString("1"))
  if valid_579764 != nil:
    section.add "$.xgafv", valid_579764
  var valid_579765 = query.getOrDefault("alt")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("json"))
  if valid_579765 != nil:
    section.add "alt", valid_579765
  var valid_579766 = query.getOrDefault("uploadType")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = nil)
  if valid_579766 != nil:
    section.add "uploadType", valid_579766
  var valid_579767 = query.getOrDefault("quotaUser")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "quotaUser", valid_579767
  var valid_579768 = query.getOrDefault("callback")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "callback", valid_579768
  var valid_579769 = query.getOrDefault("fields")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "fields", valid_579769
  var valid_579770 = query.getOrDefault("access_token")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "access_token", valid_579770
  var valid_579771 = query.getOrDefault("upload_protocol")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "upload_protocol", valid_579771
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

proc call*(call_579773: Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579757;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_579773.validator(path, query, header, formData, body)
  let scheme = call_579773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579773.url(scheme.get, call_579773.host, call_579773.base,
                         call_579773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579773, url, valid)

proc call*(call_579774: Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579757;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579775 = newJObject()
  var query_579776 = newJObject()
  var body_579777 = newJObject()
  add(query_579776, "key", newJString(key))
  add(query_579776, "prettyPrint", newJBool(prettyPrint))
  add(query_579776, "oauth_token", newJString(oauthToken))
  add(query_579776, "$.xgafv", newJString(Xgafv))
  add(query_579776, "alt", newJString(alt))
  add(query_579776, "uploadType", newJString(uploadType))
  add(query_579776, "quotaUser", newJString(quotaUser))
  add(path_579775, "resource", newJString(resource))
  if body != nil:
    body_579777 = body
  add(query_579776, "callback", newJString(callback))
  add(query_579776, "fields", newJString(fields))
  add(query_579776, "access_token", newJString(accessToken))
  add(query_579776, "upload_protocol", newJString(uploadProtocol))
  result = call_579774.call(path_579775, query_579776, nil, nil, body_579777)

var healthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions* = Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579757(
    name: "healthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:testIamPermissions", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579758,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_579759,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDeidentify_579778 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDeidentify_579780(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceDataset" in path, "`sourceDataset` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "sourceDataset"),
               (kind: ConstantSegment, value: ":deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDeidentify_579779(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new dataset containing de-identified data from the source
  ## dataset. The metadata field type
  ## is OperationMetadata.
  ## If the request is successful, the
  ## response field type is
  ## DeidentifySummary.
  ## If errors occur,
  ## details field type is
  ## DeidentifyErrorDetails.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceDataset: JString (required)
  ##                : Source dataset resource name. (e.g.,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceDataset` field"
  var valid_579781 = path.getOrDefault("sourceDataset")
  valid_579781 = validateParameter(valid_579781, JString, required = true,
                                 default = nil)
  if valid_579781 != nil:
    section.add "sourceDataset", valid_579781
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
  var valid_579782 = query.getOrDefault("key")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "key", valid_579782
  var valid_579783 = query.getOrDefault("prettyPrint")
  valid_579783 = validateParameter(valid_579783, JBool, required = false,
                                 default = newJBool(true))
  if valid_579783 != nil:
    section.add "prettyPrint", valid_579783
  var valid_579784 = query.getOrDefault("oauth_token")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "oauth_token", valid_579784
  var valid_579785 = query.getOrDefault("$.xgafv")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = newJString("1"))
  if valid_579785 != nil:
    section.add "$.xgafv", valid_579785
  var valid_579786 = query.getOrDefault("alt")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = newJString("json"))
  if valid_579786 != nil:
    section.add "alt", valid_579786
  var valid_579787 = query.getOrDefault("uploadType")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "uploadType", valid_579787
  var valid_579788 = query.getOrDefault("quotaUser")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "quotaUser", valid_579788
  var valid_579789 = query.getOrDefault("callback")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "callback", valid_579789
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("access_token")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "access_token", valid_579791
  var valid_579792 = query.getOrDefault("upload_protocol")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "upload_protocol", valid_579792
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

proc call*(call_579794: Call_HealthcareProjectsLocationsDatasetsDeidentify_579778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new dataset containing de-identified data from the source
  ## dataset. The metadata field type
  ## is OperationMetadata.
  ## If the request is successful, the
  ## response field type is
  ## DeidentifySummary.
  ## If errors occur,
  ## details field type is
  ## DeidentifyErrorDetails.
  ## 
  let valid = call_579794.validator(path, query, header, formData, body)
  let scheme = call_579794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579794.url(scheme.get, call_579794.host, call_579794.base,
                         call_579794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579794, url, valid)

proc call*(call_579795: Call_HealthcareProjectsLocationsDatasetsDeidentify_579778;
          sourceDataset: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDeidentify
  ## Creates a new dataset containing de-identified data from the source
  ## dataset. The metadata field type
  ## is OperationMetadata.
  ## If the request is successful, the
  ## response field type is
  ## DeidentifySummary.
  ## If errors occur,
  ## details field type is
  ## DeidentifyErrorDetails.
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
  ##   sourceDataset: string (required)
  ##                : Source dataset resource name. (e.g.,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`).
  var path_579796 = newJObject()
  var query_579797 = newJObject()
  var body_579798 = newJObject()
  add(query_579797, "key", newJString(key))
  add(query_579797, "prettyPrint", newJBool(prettyPrint))
  add(query_579797, "oauth_token", newJString(oauthToken))
  add(query_579797, "$.xgafv", newJString(Xgafv))
  add(query_579797, "alt", newJString(alt))
  add(query_579797, "uploadType", newJString(uploadType))
  add(query_579797, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579798 = body
  add(query_579797, "callback", newJString(callback))
  add(query_579797, "fields", newJString(fields))
  add(query_579797, "access_token", newJString(accessToken))
  add(query_579797, "upload_protocol", newJString(uploadProtocol))
  add(path_579796, "sourceDataset", newJString(sourceDataset))
  result = call_579795.call(path_579796, query_579797, nil, nil, body_579798)

var healthcareProjectsLocationsDatasetsDeidentify* = Call_HealthcareProjectsLocationsDatasetsDeidentify_579778(
    name: "healthcareProjectsLocationsDatasetsDeidentify",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{sourceDataset}:deidentify",
    validator: validate_HealthcareProjectsLocationsDatasetsDeidentify_579779,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDeidentify_579780,
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
