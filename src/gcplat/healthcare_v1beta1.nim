
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Healthcare
## version: v1beta1
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578909,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_578910,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578619 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578621(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578620(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the contents of a FHIR resource.
  ## 
  ## Implements the FHIR standard [read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#read).
  ## 
  ## Also supports the FHIR standard [conditional read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cread)
  ## specified by supplying an `If-Modified-Since` header with a date/time value
  ## or an `If-None-Match` header with an ETag value.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource.
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
  ##       : Specifies which parts of the Message resource to return in the response.
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

proc call*(call_578795: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the contents of a FHIR resource.
  ## 
  ## Implements the FHIR standard [read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#read).
  ## 
  ## Also supports the FHIR standard [conditional read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cread)
  ## specified by supplying an `If-Modified-Since` header with a date/time value
  ## or an `If-None-Match` header with an ETag value.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_578795.validator(path, query, header, formData, body)
  let scheme = call_578795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578795.url(scheme.get, call_578795.host, call_578795.base,
                         call_578795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578795, url, valid)

proc call*(call_578866: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578619;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          view: string = "MESSAGE_VIEW_UNSPECIFIED"): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirRead
  ## Gets the contents of a FHIR resource.
  ## 
  ## Implements the FHIR standard [read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#read).
  ## 
  ## Also supports the FHIR standard [conditional read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cread)
  ## specified by supplying an `If-Modified-Since` header with a date/time value
  ## or an `If-None-Match` header with an ETag value.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource.
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
  ##       : The name of the resource to retrieve.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Specifies which parts of the Message resource to return in the response.
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

var healthcareProjectsLocationsDatasetsFhirStoresFhirRead* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578619(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirRead",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578620,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_578621,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578948 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578950(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578949(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates part of an existing resource by applying the operations specified
  ## in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
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
  ##   name: JString (required)
  ##       : The name of the resource to update.
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

proc call*(call_578965: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates part of an existing resource by applying the operations specified
  ## in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
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
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578948;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirPatch
  ## Updates part of an existing resource by applying the operations specified
  ## in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to update.
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

var healthcareProjectsLocationsDatasetsFhirStoresFhirPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578948(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578949,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_578950,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578929 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578931(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578930(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a FHIR resource.
  ## 
  ## Implements the FHIR standard [delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#delete).
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
  ##   name: JString (required)
  ##       : The name of the resource to delete.
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

proc call*(call_578944: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578929;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a FHIR resource.
  ## 
  ## Implements the FHIR standard [delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#delete).
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578929;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirDelete
  ## Deletes a FHIR resource.
  ## 
  ## Implements the FHIR standard [delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#delete).
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to delete.
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

var healthcareProjectsLocationsDatasetsFhirStoresFhirDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578929(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578930,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_578931,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
  ## in next or previous page links' urls. Next and previous page are returned
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
  ## in next or previous page links' urls. Next and previous page are returned
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
    route: "/v1beta1/{name}/$everything", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_578971,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}/$purge", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_578994,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}/_history", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_579013,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}/fhir/metadata", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_579036,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    host: "healthcare.googleapis.com", route: "/v1beta1/{name}/locations",
    validator: validate_HealthcareProjectsLocationsList_579055, base: "/",
    url: url_HealthcareProjectsLocationsList_579056, schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsOperationsList_579076 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsOperationsList_579078(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsOperationsList_579077(
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
  var valid_579084 = query.getOrDefault("pageSize")
  valid_579084 = validateParameter(valid_579084, JInt, required = false, default = nil)
  if valid_579084 != nil:
    section.add "pageSize", valid_579084
  var valid_579085 = query.getOrDefault("alt")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = newJString("json"))
  if valid_579085 != nil:
    section.add "alt", valid_579085
  var valid_579086 = query.getOrDefault("uploadType")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "uploadType", valid_579086
  var valid_579087 = query.getOrDefault("quotaUser")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "quotaUser", valid_579087
  var valid_579088 = query.getOrDefault("filter")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "filter", valid_579088
  var valid_579089 = query.getOrDefault("pageToken")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "pageToken", valid_579089
  var valid_579090 = query.getOrDefault("callback")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "callback", valid_579090
  var valid_579091 = query.getOrDefault("fields")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "fields", valid_579091
  var valid_579092 = query.getOrDefault("access_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "access_token", valid_579092
  var valid_579093 = query.getOrDefault("upload_protocol")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "upload_protocol", valid_579093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579094: Call_HealthcareProjectsLocationsDatasetsOperationsList_579076;
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
  let valid = call_579094.validator(path, query, header, formData, body)
  let scheme = call_579094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579094.url(scheme.get, call_579094.host, call_579094.base,
                         call_579094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579094, url, valid)

proc call*(call_579095: Call_HealthcareProjectsLocationsDatasetsOperationsList_579076;
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
  var path_579096 = newJObject()
  var query_579097 = newJObject()
  add(query_579097, "key", newJString(key))
  add(query_579097, "prettyPrint", newJBool(prettyPrint))
  add(query_579097, "oauth_token", newJString(oauthToken))
  add(query_579097, "$.xgafv", newJString(Xgafv))
  add(query_579097, "pageSize", newJInt(pageSize))
  add(query_579097, "alt", newJString(alt))
  add(query_579097, "uploadType", newJString(uploadType))
  add(query_579097, "quotaUser", newJString(quotaUser))
  add(path_579096, "name", newJString(name))
  add(query_579097, "filter", newJString(filter))
  add(query_579097, "pageToken", newJString(pageToken))
  add(query_579097, "callback", newJString(callback))
  add(query_579097, "fields", newJString(fields))
  add(query_579097, "access_token", newJString(accessToken))
  add(query_579097, "upload_protocol", newJString(uploadProtocol))
  result = call_579095.call(path_579096, query_579097, nil, nil, nil)

var healthcareProjectsLocationsDatasetsOperationsList* = Call_HealthcareProjectsLocationsDatasetsOperationsList_579076(
    name: "healthcareProjectsLocationsDatasetsOperationsList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}/operations",
    validator: validate_HealthcareProjectsLocationsDatasetsOperationsList_579077,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsOperationsList_579078,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_579098 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresExport_579100(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresExport_579099(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Export resources from the FHIR store to the specified destination.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the export by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## Otherwise, when the operation finishes, a detailed response of type
  ## ExportResourcesResponse is returned in the
  ## response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the FHIR store to export resource from. The name should be in
  ## the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579101 = path.getOrDefault("name")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "name", valid_579101
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
  var valid_579102 = query.getOrDefault("key")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "key", valid_579102
  var valid_579103 = query.getOrDefault("prettyPrint")
  valid_579103 = validateParameter(valid_579103, JBool, required = false,
                                 default = newJBool(true))
  if valid_579103 != nil:
    section.add "prettyPrint", valid_579103
  var valid_579104 = query.getOrDefault("oauth_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "oauth_token", valid_579104
  var valid_579105 = query.getOrDefault("$.xgafv")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = newJString("1"))
  if valid_579105 != nil:
    section.add "$.xgafv", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("uploadType")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "uploadType", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579114: Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_579098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export resources from the FHIR store to the specified destination.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the export by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## Otherwise, when the operation finishes, a detailed response of type
  ## ExportResourcesResponse is returned in the
  ## response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  let valid = call_579114.validator(path, query, header, formData, body)
  let scheme = call_579114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579114.url(scheme.get, call_579114.host, call_579114.base,
                         call_579114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579114, url, valid)

proc call*(call_579115: Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_579098;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresExport
  ## Export resources from the FHIR store to the specified destination.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the export by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## Otherwise, when the operation finishes, a detailed response of type
  ## ExportResourcesResponse is returned in the
  ## response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
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
  ##       : The name of the FHIR store to export resource from. The name should be in
  ## the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579116 = newJObject()
  var query_579117 = newJObject()
  var body_579118 = newJObject()
  add(query_579117, "key", newJString(key))
  add(query_579117, "prettyPrint", newJBool(prettyPrint))
  add(query_579117, "oauth_token", newJString(oauthToken))
  add(query_579117, "$.xgafv", newJString(Xgafv))
  add(query_579117, "alt", newJString(alt))
  add(query_579117, "uploadType", newJString(uploadType))
  add(query_579117, "quotaUser", newJString(quotaUser))
  add(path_579116, "name", newJString(name))
  if body != nil:
    body_579118 = body
  add(query_579117, "callback", newJString(callback))
  add(query_579117, "fields", newJString(fields))
  add(query_579117, "access_token", newJString(accessToken))
  add(query_579117, "upload_protocol", newJString(uploadProtocol))
  result = call_579115.call(path_579116, query_579117, nil, nil, body_579118)

var healthcareProjectsLocationsDatasetsFhirStoresExport* = Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_579098(
    name: "healthcareProjectsLocationsDatasetsFhirStoresExport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}:export",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresExport_579099,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresExport_579100,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_579119 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresImport_579121(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresImport_579120(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Import resources to the FHIR store by loading data from the specified
  ## sources. This method is optimized to load large quantities of data using
  ## import semantics that ignore some FHIR store configuration options and are
  ## not suitable for all use cases. It is primarily intended to load data into
  ## an empty FHIR store that is not being used by other clients. In cases
  ## where this method is not appropriate, consider using ExecuteBundle to
  ## load data.
  ## 
  ## Every resource in the input must contain a client-supplied ID, and will be
  ## stored using that ID regardless of the
  ## enable_update_create setting on the FHIR
  ## store.
  ## 
  ## The import process does not enforce referential integrity, regardless of
  ## the
  ## disable_referential_integrity
  ## setting on the FHIR store. This allows the import of resources with
  ## arbitrary interdependencies without considering grouping or ordering, but
  ## if the input data contains invalid references or if some resources fail to
  ## be imported, the FHIR store might be left in a state that violates
  ## referential integrity.
  ## 
  ## If a resource with the specified ID already exists, the most recent
  ## version of the resource is overwritten without creating a new historical
  ## version, regardless of the
  ## disable_resource_versioning
  ## setting on the FHIR store. If transient failures occur during the import,
  ## it is possible that successfully imported resources will be overwritten
  ## more than once.
  ## 
  ## The import operation is idempotent unless the input data contains multiple
  ## valid resources with the same ID but different contents. In that case,
  ## after the import completes, the store will contain exactly one resource
  ## with that ID but there is no ordering guarantee on which version of the
  ## contents it will have. The operation result counters do not count
  ## duplicate IDs as an error and will count one success for each resource in
  ## the input, which might result in a success count larger than the number
  ## of resources in the FHIR store. This often occurs when importing data
  ## organized in bundles produced by Patient-everything
  ## where each bundle contains its own copy of a resource such as Practitioner
  ## that might be referred to by many patients.
  ## 
  ## If some resources fail to import, for example due to parsing errors,
  ## successfully imported resources are not rolled back.
  ## 
  ## The location and format of the input data is specified by the parameters
  ## below. Note that if no format is specified, this method assumes the
  ## `BUNDLE` format. When using the `BUNDLE` format this method ignores the
  ## `Bundle.type` field, except that `history` bundles are rejected, and does
  ## not apply any of the bundle processing semantics for batch or transaction
  ## bundles. Unlike in ExecuteBundle, transaction bundles are not executed
  ## as a single transaction and bundle-internal references are not rewritten.
  ## The bundle is treated as a collection of resources to be written as
  ## provided in `Bundle.entry.resource`, ignoring `Bundle.entry.request`. As
  ## an example, this allows the import of `searchset` bundles produced by a
  ## FHIR search or
  ## Patient-everything operation.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the import by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)). Otherwise, when the
  ## operation finishes, a detailed response of type ImportResourcesResponse
  ## is returned in the response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the FHIR store to import FHIR resources to. The name should be
  ## in the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579122 = path.getOrDefault("name")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "name", valid_579122
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
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("$.xgafv")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("1"))
  if valid_579126 != nil:
    section.add "$.xgafv", valid_579126
  var valid_579127 = query.getOrDefault("alt")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = newJString("json"))
  if valid_579127 != nil:
    section.add "alt", valid_579127
  var valid_579128 = query.getOrDefault("uploadType")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "uploadType", valid_579128
  var valid_579129 = query.getOrDefault("quotaUser")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "quotaUser", valid_579129
  var valid_579130 = query.getOrDefault("callback")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "callback", valid_579130
  var valid_579131 = query.getOrDefault("fields")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "fields", valid_579131
  var valid_579132 = query.getOrDefault("access_token")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "access_token", valid_579132
  var valid_579133 = query.getOrDefault("upload_protocol")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "upload_protocol", valid_579133
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

proc call*(call_579135: Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_579119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Import resources to the FHIR store by loading data from the specified
  ## sources. This method is optimized to load large quantities of data using
  ## import semantics that ignore some FHIR store configuration options and are
  ## not suitable for all use cases. It is primarily intended to load data into
  ## an empty FHIR store that is not being used by other clients. In cases
  ## where this method is not appropriate, consider using ExecuteBundle to
  ## load data.
  ## 
  ## Every resource in the input must contain a client-supplied ID, and will be
  ## stored using that ID regardless of the
  ## enable_update_create setting on the FHIR
  ## store.
  ## 
  ## The import process does not enforce referential integrity, regardless of
  ## the
  ## disable_referential_integrity
  ## setting on the FHIR store. This allows the import of resources with
  ## arbitrary interdependencies without considering grouping or ordering, but
  ## if the input data contains invalid references or if some resources fail to
  ## be imported, the FHIR store might be left in a state that violates
  ## referential integrity.
  ## 
  ## If a resource with the specified ID already exists, the most recent
  ## version of the resource is overwritten without creating a new historical
  ## version, regardless of the
  ## disable_resource_versioning
  ## setting on the FHIR store. If transient failures occur during the import,
  ## it is possible that successfully imported resources will be overwritten
  ## more than once.
  ## 
  ## The import operation is idempotent unless the input data contains multiple
  ## valid resources with the same ID but different contents. In that case,
  ## after the import completes, the store will contain exactly one resource
  ## with that ID but there is no ordering guarantee on which version of the
  ## contents it will have. The operation result counters do not count
  ## duplicate IDs as an error and will count one success for each resource in
  ## the input, which might result in a success count larger than the number
  ## of resources in the FHIR store. This often occurs when importing data
  ## organized in bundles produced by Patient-everything
  ## where each bundle contains its own copy of a resource such as Practitioner
  ## that might be referred to by many patients.
  ## 
  ## If some resources fail to import, for example due to parsing errors,
  ## successfully imported resources are not rolled back.
  ## 
  ## The location and format of the input data is specified by the parameters
  ## below. Note that if no format is specified, this method assumes the
  ## `BUNDLE` format. When using the `BUNDLE` format this method ignores the
  ## `Bundle.type` field, except that `history` bundles are rejected, and does
  ## not apply any of the bundle processing semantics for batch or transaction
  ## bundles. Unlike in ExecuteBundle, transaction bundles are not executed
  ## as a single transaction and bundle-internal references are not rewritten.
  ## The bundle is treated as a collection of resources to be written as
  ## provided in `Bundle.entry.resource`, ignoring `Bundle.entry.request`. As
  ## an example, this allows the import of `searchset` bundles produced by a
  ## FHIR search or
  ## Patient-everything operation.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the import by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)). Otherwise, when the
  ## operation finishes, a detailed response of type ImportResourcesResponse
  ## is returned in the response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  let valid = call_579135.validator(path, query, header, formData, body)
  let scheme = call_579135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579135.url(scheme.get, call_579135.host, call_579135.base,
                         call_579135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579135, url, valid)

proc call*(call_579136: Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_579119;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresImport
  ## Import resources to the FHIR store by loading data from the specified
  ## sources. This method is optimized to load large quantities of data using
  ## import semantics that ignore some FHIR store configuration options and are
  ## not suitable for all use cases. It is primarily intended to load data into
  ## an empty FHIR store that is not being used by other clients. In cases
  ## where this method is not appropriate, consider using ExecuteBundle to
  ## load data.
  ## 
  ## Every resource in the input must contain a client-supplied ID, and will be
  ## stored using that ID regardless of the
  ## enable_update_create setting on the FHIR
  ## store.
  ## 
  ## The import process does not enforce referential integrity, regardless of
  ## the
  ## disable_referential_integrity
  ## setting on the FHIR store. This allows the import of resources with
  ## arbitrary interdependencies without considering grouping or ordering, but
  ## if the input data contains invalid references or if some resources fail to
  ## be imported, the FHIR store might be left in a state that violates
  ## referential integrity.
  ## 
  ## If a resource with the specified ID already exists, the most recent
  ## version of the resource is overwritten without creating a new historical
  ## version, regardless of the
  ## disable_resource_versioning
  ## setting on the FHIR store. If transient failures occur during the import,
  ## it is possible that successfully imported resources will be overwritten
  ## more than once.
  ## 
  ## The import operation is idempotent unless the input data contains multiple
  ## valid resources with the same ID but different contents. In that case,
  ## after the import completes, the store will contain exactly one resource
  ## with that ID but there is no ordering guarantee on which version of the
  ## contents it will have. The operation result counters do not count
  ## duplicate IDs as an error and will count one success for each resource in
  ## the input, which might result in a success count larger than the number
  ## of resources in the FHIR store. This often occurs when importing data
  ## organized in bundles produced by Patient-everything
  ## where each bundle contains its own copy of a resource such as Practitioner
  ## that might be referred to by many patients.
  ## 
  ## If some resources fail to import, for example due to parsing errors,
  ## successfully imported resources are not rolled back.
  ## 
  ## The location and format of the input data is specified by the parameters
  ## below. Note that if no format is specified, this method assumes the
  ## `BUNDLE` format. When using the `BUNDLE` format this method ignores the
  ## `Bundle.type` field, except that `history` bundles are rejected, and does
  ## not apply any of the bundle processing semantics for batch or transaction
  ## bundles. Unlike in ExecuteBundle, transaction bundles are not executed
  ## as a single transaction and bundle-internal references are not rewritten.
  ## The bundle is treated as a collection of resources to be written as
  ## provided in `Bundle.entry.resource`, ignoring `Bundle.entry.request`. As
  ## an example, this allows the import of `searchset` bundles produced by a
  ## FHIR search or
  ## Patient-everything operation.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the import by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)). Otherwise, when the
  ## operation finishes, a detailed response of type ImportResourcesResponse
  ## is returned in the response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
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
  ##       : The name of the FHIR store to import FHIR resources to. The name should be
  ## in the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579137 = newJObject()
  var query_579138 = newJObject()
  var body_579139 = newJObject()
  add(query_579138, "key", newJString(key))
  add(query_579138, "prettyPrint", newJBool(prettyPrint))
  add(query_579138, "oauth_token", newJString(oauthToken))
  add(query_579138, "$.xgafv", newJString(Xgafv))
  add(query_579138, "alt", newJString(alt))
  add(query_579138, "uploadType", newJString(uploadType))
  add(query_579138, "quotaUser", newJString(quotaUser))
  add(path_579137, "name", newJString(name))
  if body != nil:
    body_579139 = body
  add(query_579138, "callback", newJString(callback))
  add(query_579138, "fields", newJString(fields))
  add(query_579138, "access_token", newJString(accessToken))
  add(query_579138, "upload_protocol", newJString(uploadProtocol))
  result = call_579136.call(path_579137, query_579138, nil, nil, body_579139)

var healthcareProjectsLocationsDatasetsFhirStoresImport* = Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_579119(
    name: "healthcareProjectsLocationsDatasetsFhirStoresImport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}:import",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresImport_579120,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresImport_579121,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsCreate_579161 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsCreate_579163(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsCreate_579162(path: JsonNode;
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
  ##         : The name of the project where the server creates the dataset. For
  ## example, `projects/{project_id}/locations/{location_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579164 = path.getOrDefault("parent")
  valid_579164 = validateParameter(valid_579164, JString, required = true,
                                 default = nil)
  if valid_579164 != nil:
    section.add "parent", valid_579164
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
  var valid_579165 = query.getOrDefault("key")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "key", valid_579165
  var valid_579166 = query.getOrDefault("prettyPrint")
  valid_579166 = validateParameter(valid_579166, JBool, required = false,
                                 default = newJBool(true))
  if valid_579166 != nil:
    section.add "prettyPrint", valid_579166
  var valid_579167 = query.getOrDefault("oauth_token")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "oauth_token", valid_579167
  var valid_579168 = query.getOrDefault("$.xgafv")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("1"))
  if valid_579168 != nil:
    section.add "$.xgafv", valid_579168
  var valid_579169 = query.getOrDefault("alt")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = newJString("json"))
  if valid_579169 != nil:
    section.add "alt", valid_579169
  var valid_579170 = query.getOrDefault("uploadType")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "uploadType", valid_579170
  var valid_579171 = query.getOrDefault("quotaUser")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "quotaUser", valid_579171
  var valid_579172 = query.getOrDefault("datasetId")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "datasetId", valid_579172
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579178: Call_HealthcareProjectsLocationsDatasetsCreate_579161;
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
  let valid = call_579178.validator(path, query, header, formData, body)
  let scheme = call_579178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579178.url(scheme.get, call_579178.host, call_579178.base,
                         call_579178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579178, url, valid)

proc call*(call_579179: Call_HealthcareProjectsLocationsDatasetsCreate_579161;
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
  ##         : The name of the project where the server creates the dataset. For
  ## example, `projects/{project_id}/locations/{location_id}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579180 = newJObject()
  var query_579181 = newJObject()
  var body_579182 = newJObject()
  add(query_579181, "key", newJString(key))
  add(query_579181, "prettyPrint", newJBool(prettyPrint))
  add(query_579181, "oauth_token", newJString(oauthToken))
  add(query_579181, "$.xgafv", newJString(Xgafv))
  add(query_579181, "alt", newJString(alt))
  add(query_579181, "uploadType", newJString(uploadType))
  add(query_579181, "quotaUser", newJString(quotaUser))
  add(query_579181, "datasetId", newJString(datasetId))
  if body != nil:
    body_579182 = body
  add(query_579181, "callback", newJString(callback))
  add(path_579180, "parent", newJString(parent))
  add(query_579181, "fields", newJString(fields))
  add(query_579181, "access_token", newJString(accessToken))
  add(query_579181, "upload_protocol", newJString(uploadProtocol))
  result = call_579179.call(path_579180, query_579181, nil, nil, body_579182)

var healthcareProjectsLocationsDatasetsCreate* = Call_HealthcareProjectsLocationsDatasetsCreate_579161(
    name: "healthcareProjectsLocationsDatasetsCreate", meth: HttpMethod.HttpPost,
    host: "healthcare.googleapis.com", route: "/v1beta1/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsCreate_579162,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsCreate_579163,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsList_579140 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsList_579142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsList_579141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the health datasets in the current project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project whose datasets should be listed.
  ## For example, `projects/{project_id}/locations/{location_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579143 = path.getOrDefault("parent")
  valid_579143 = validateParameter(valid_579143, JString, required = true,
                                 default = nil)
  if valid_579143 != nil:
    section.add "parent", valid_579143
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
  var valid_579144 = query.getOrDefault("key")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "key", valid_579144
  var valid_579145 = query.getOrDefault("prettyPrint")
  valid_579145 = validateParameter(valid_579145, JBool, required = false,
                                 default = newJBool(true))
  if valid_579145 != nil:
    section.add "prettyPrint", valid_579145
  var valid_579146 = query.getOrDefault("oauth_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "oauth_token", valid_579146
  var valid_579147 = query.getOrDefault("$.xgafv")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("1"))
  if valid_579147 != nil:
    section.add "$.xgafv", valid_579147
  var valid_579148 = query.getOrDefault("pageSize")
  valid_579148 = validateParameter(valid_579148, JInt, required = false, default = nil)
  if valid_579148 != nil:
    section.add "pageSize", valid_579148
  var valid_579149 = query.getOrDefault("alt")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = newJString("json"))
  if valid_579149 != nil:
    section.add "alt", valid_579149
  var valid_579150 = query.getOrDefault("uploadType")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "uploadType", valid_579150
  var valid_579151 = query.getOrDefault("quotaUser")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "quotaUser", valid_579151
  var valid_579152 = query.getOrDefault("pageToken")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "pageToken", valid_579152
  var valid_579153 = query.getOrDefault("callback")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "callback", valid_579153
  var valid_579154 = query.getOrDefault("fields")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "fields", valid_579154
  var valid_579155 = query.getOrDefault("access_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "access_token", valid_579155
  var valid_579156 = query.getOrDefault("upload_protocol")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "upload_protocol", valid_579156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579157: Call_HealthcareProjectsLocationsDatasetsList_579140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the health datasets in the current project.
  ## 
  let valid = call_579157.validator(path, query, header, formData, body)
  let scheme = call_579157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579157.url(scheme.get, call_579157.host, call_579157.base,
                         call_579157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579157, url, valid)

proc call*(call_579158: Call_HealthcareProjectsLocationsDatasetsList_579140;
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
  ##         : The name of the project whose datasets should be listed.
  ## For example, `projects/{project_id}/locations/{location_id}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579159 = newJObject()
  var query_579160 = newJObject()
  add(query_579160, "key", newJString(key))
  add(query_579160, "prettyPrint", newJBool(prettyPrint))
  add(query_579160, "oauth_token", newJString(oauthToken))
  add(query_579160, "$.xgafv", newJString(Xgafv))
  add(query_579160, "pageSize", newJInt(pageSize))
  add(query_579160, "alt", newJString(alt))
  add(query_579160, "uploadType", newJString(uploadType))
  add(query_579160, "quotaUser", newJString(quotaUser))
  add(query_579160, "pageToken", newJString(pageToken))
  add(query_579160, "callback", newJString(callback))
  add(path_579159, "parent", newJString(parent))
  add(query_579160, "fields", newJString(fields))
  add(query_579160, "access_token", newJString(accessToken))
  add(query_579160, "upload_protocol", newJString(uploadProtocol))
  result = call_579158.call(path_579159, query_579160, nil, nil, nil)

var healthcareProjectsLocationsDatasetsList* = Call_HealthcareProjectsLocationsDatasetsList_579140(
    name: "healthcareProjectsLocationsDatasetsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1beta1/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsList_579141, base: "/",
    url: url_HealthcareProjectsLocationsDatasetsList_579142,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579205 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579207(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579206(
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
  var valid_579208 = path.getOrDefault("parent")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "parent", valid_579208
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
  var valid_579209 = query.getOrDefault("key")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "key", valid_579209
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
  var valid_579213 = query.getOrDefault("alt")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("json"))
  if valid_579213 != nil:
    section.add "alt", valid_579213
  var valid_579214 = query.getOrDefault("uploadType")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "uploadType", valid_579214
  var valid_579215 = query.getOrDefault("quotaUser")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "quotaUser", valid_579215
  var valid_579216 = query.getOrDefault("dicomStoreId")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "dicomStoreId", valid_579216
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

proc call*(call_579222: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new DICOM store within the parent dataset.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579205;
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
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  var body_579226 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "$.xgafv", newJString(Xgafv))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "uploadType", newJString(uploadType))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(query_579225, "dicomStoreId", newJString(dicomStoreId))
  if body != nil:
    body_579226 = body
  add(query_579225, "callback", newJString(callback))
  add(path_579224, "parent", newJString(parent))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "access_token", newJString(accessToken))
  add(query_579225, "upload_protocol", newJString(uploadProtocol))
  result = call_579223.call(path_579224, query_579225, nil, nil, body_579226)

var healthcareProjectsLocationsDatasetsDicomStoresCreate* = Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579205(
    name: "healthcareProjectsLocationsDatasetsDicomStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579206,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_579207,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579183 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresList_579185(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresList_579184(
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
  var valid_579186 = path.getOrDefault("parent")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "parent", valid_579186
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
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
  var valid_579187 = query.getOrDefault("key")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "key", valid_579187
  var valid_579188 = query.getOrDefault("prettyPrint")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(true))
  if valid_579188 != nil:
    section.add "prettyPrint", valid_579188
  var valid_579189 = query.getOrDefault("oauth_token")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "oauth_token", valid_579189
  var valid_579190 = query.getOrDefault("$.xgafv")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = newJString("1"))
  if valid_579190 != nil:
    section.add "$.xgafv", valid_579190
  var valid_579191 = query.getOrDefault("pageSize")
  valid_579191 = validateParameter(valid_579191, JInt, required = false, default = nil)
  if valid_579191 != nil:
    section.add "pageSize", valid_579191
  var valid_579192 = query.getOrDefault("alt")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("json"))
  if valid_579192 != nil:
    section.add "alt", valid_579192
  var valid_579193 = query.getOrDefault("uploadType")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "uploadType", valid_579193
  var valid_579194 = query.getOrDefault("quotaUser")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "quotaUser", valid_579194
  var valid_579195 = query.getOrDefault("filter")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "filter", valid_579195
  var valid_579196 = query.getOrDefault("pageToken")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "pageToken", valid_579196
  var valid_579197 = query.getOrDefault("callback")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "callback", valid_579197
  var valid_579198 = query.getOrDefault("fields")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "fields", valid_579198
  var valid_579199 = query.getOrDefault("access_token")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "access_token", valid_579199
  var valid_579200 = query.getOrDefault("upload_protocol")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "upload_protocol", valid_579200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579201: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DICOM stores in the given dataset.
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579183;
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
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
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "$.xgafv", newJString(Xgafv))
  add(query_579204, "pageSize", newJInt(pageSize))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "uploadType", newJString(uploadType))
  add(query_579204, "quotaUser", newJString(quotaUser))
  add(query_579204, "filter", newJString(filter))
  add(query_579204, "pageToken", newJString(pageToken))
  add(query_579204, "callback", newJString(callback))
  add(path_579203, "parent", newJString(parent))
  add(query_579204, "fields", newJString(fields))
  add(query_579204, "access_token", newJString(accessToken))
  add(query_579204, "upload_protocol", newJString(uploadProtocol))
  result = call_579202.call(path_579203, query_579204, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresList* = Call_HealthcareProjectsLocationsDatasetsDicomStoresList_579183(
    name: "healthcareProjectsLocationsDatasetsDicomStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresList_579184,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresList_579185,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579247 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579249(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579248(
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the StoreInstances DICOMweb request (for example,
  ## `studies/[{study_uid}]`). Note that the `study_uid` is optional.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579250 = path.getOrDefault("parent")
  valid_579250 = validateParameter(valid_579250, JString, required = true,
                                 default = nil)
  if valid_579250 != nil:
    section.add "parent", valid_579250
  var valid_579251 = path.getOrDefault("dicomWebPath")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "dicomWebPath", valid_579251
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
  var valid_579252 = query.getOrDefault("key")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "key", valid_579252
  var valid_579253 = query.getOrDefault("prettyPrint")
  valid_579253 = validateParameter(valid_579253, JBool, required = false,
                                 default = newJBool(true))
  if valid_579253 != nil:
    section.add "prettyPrint", valid_579253
  var valid_579254 = query.getOrDefault("oauth_token")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "oauth_token", valid_579254
  var valid_579255 = query.getOrDefault("$.xgafv")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = newJString("1"))
  if valid_579255 != nil:
    section.add "$.xgafv", valid_579255
  var valid_579256 = query.getOrDefault("alt")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = newJString("json"))
  if valid_579256 != nil:
    section.add "alt", valid_579256
  var valid_579257 = query.getOrDefault("uploadType")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "uploadType", valid_579257
  var valid_579258 = query.getOrDefault("quotaUser")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "quotaUser", valid_579258
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579264: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
  ## 
  let valid = call_579264.validator(path, query, header, formData, body)
  let scheme = call_579264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579264.url(scheme.get, call_579264.host, call_579264.base,
                         call_579264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579264, url, valid)

proc call*(call_579265: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579247;
          parent: string; dicomWebPath: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dicomWebPath: string (required)
  ##               : The path of the StoreInstances DICOMweb request (for example,
  ## `studies/[{study_uid}]`). Note that the `study_uid` is optional.
  var path_579266 = newJObject()
  var query_579267 = newJObject()
  var body_579268 = newJObject()
  add(query_579267, "key", newJString(key))
  add(query_579267, "prettyPrint", newJBool(prettyPrint))
  add(query_579267, "oauth_token", newJString(oauthToken))
  add(query_579267, "$.xgafv", newJString(Xgafv))
  add(query_579267, "alt", newJString(alt))
  add(query_579267, "uploadType", newJString(uploadType))
  add(query_579267, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579268 = body
  add(query_579267, "callback", newJString(callback))
  add(path_579266, "parent", newJString(parent))
  add(query_579267, "fields", newJString(fields))
  add(query_579267, "access_token", newJString(accessToken))
  add(query_579267, "upload_protocol", newJString(uploadProtocol))
  add(path_579266, "dicomWebPath", newJString(dicomWebPath))
  result = call_579265.call(path_579266, query_579267, nil, nil, body_579268)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579247(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579248,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_579249,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579227 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579229(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579228(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## RetrieveFrames returns instances associated with the given study, series,
  ## SOP Instance UID and frame numbers. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the RetrieveFrames DICOMweb request (for example,
  ## 
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}/frames/{frame_list}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579230 = path.getOrDefault("parent")
  valid_579230 = validateParameter(valid_579230, JString, required = true,
                                 default = nil)
  if valid_579230 != nil:
    section.add "parent", valid_579230
  var valid_579231 = path.getOrDefault("dicomWebPath")
  valid_579231 = validateParameter(valid_579231, JString, required = true,
                                 default = nil)
  if valid_579231 != nil:
    section.add "dicomWebPath", valid_579231
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
  var valid_579232 = query.getOrDefault("key")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "key", valid_579232
  var valid_579233 = query.getOrDefault("prettyPrint")
  valid_579233 = validateParameter(valid_579233, JBool, required = false,
                                 default = newJBool(true))
  if valid_579233 != nil:
    section.add "prettyPrint", valid_579233
  var valid_579234 = query.getOrDefault("oauth_token")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "oauth_token", valid_579234
  var valid_579235 = query.getOrDefault("$.xgafv")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = newJString("1"))
  if valid_579235 != nil:
    section.add "$.xgafv", valid_579235
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
  var valid_579238 = query.getOrDefault("quotaUser")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "quotaUser", valid_579238
  var valid_579239 = query.getOrDefault("callback")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "callback", valid_579239
  var valid_579240 = query.getOrDefault("fields")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "fields", valid_579240
  var valid_579241 = query.getOrDefault("access_token")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "access_token", valid_579241
  var valid_579242 = query.getOrDefault("upload_protocol")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "upload_protocol", valid_579242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579243: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RetrieveFrames returns instances associated with the given study, series,
  ## SOP Instance UID and frame numbers. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  let valid = call_579243.validator(path, query, header, formData, body)
  let scheme = call_579243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579243.url(scheme.get, call_579243.host, call_579243.base,
                         call_579243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579243, url, valid)

proc call*(call_579244: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579227;
          parent: string; dicomWebPath: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames
  ## RetrieveFrames returns instances associated with the given study, series,
  ## SOP Instance UID and frame numbers. See
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dicomWebPath: string (required)
  ##               : The path of the RetrieveFrames DICOMweb request (for example,
  ## 
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}/frames/{frame_list}`).
  var path_579245 = newJObject()
  var query_579246 = newJObject()
  add(query_579246, "key", newJString(key))
  add(query_579246, "prettyPrint", newJBool(prettyPrint))
  add(query_579246, "oauth_token", newJString(oauthToken))
  add(query_579246, "$.xgafv", newJString(Xgafv))
  add(query_579246, "alt", newJString(alt))
  add(query_579246, "uploadType", newJString(uploadType))
  add(query_579246, "quotaUser", newJString(quotaUser))
  add(query_579246, "callback", newJString(callback))
  add(path_579245, "parent", newJString(parent))
  add(query_579246, "fields", newJString(fields))
  add(query_579246, "access_token", newJString(accessToken))
  add(query_579246, "upload_protocol", newJString(uploadProtocol))
  add(path_579245, "dicomWebPath", newJString(dicomWebPath))
  result = call_579244.call(path_579245, query_579246, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579227(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579228,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_579229,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579269 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579271(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579270(
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the DeleteInstance request (for example,
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579272 = path.getOrDefault("parent")
  valid_579272 = validateParameter(valid_579272, JString, required = true,
                                 default = nil)
  if valid_579272 != nil:
    section.add "parent", valid_579272
  var valid_579273 = path.getOrDefault("dicomWebPath")
  valid_579273 = validateParameter(valid_579273, JString, required = true,
                                 default = nil)
  if valid_579273 != nil:
    section.add "dicomWebPath", valid_579273
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
  var valid_579274 = query.getOrDefault("key")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "key", valid_579274
  var valid_579275 = query.getOrDefault("prettyPrint")
  valid_579275 = validateParameter(valid_579275, JBool, required = false,
                                 default = newJBool(true))
  if valid_579275 != nil:
    section.add "prettyPrint", valid_579275
  var valid_579276 = query.getOrDefault("oauth_token")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "oauth_token", valid_579276
  var valid_579277 = query.getOrDefault("$.xgafv")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = newJString("1"))
  if valid_579277 != nil:
    section.add "$.xgafv", valid_579277
  var valid_579278 = query.getOrDefault("alt")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = newJString("json"))
  if valid_579278 != nil:
    section.add "alt", valid_579278
  var valid_579279 = query.getOrDefault("uploadType")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "uploadType", valid_579279
  var valid_579280 = query.getOrDefault("quotaUser")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "quotaUser", valid_579280
  var valid_579281 = query.getOrDefault("callback")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "callback", valid_579281
  var valid_579282 = query.getOrDefault("fields")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "fields", valid_579282
  var valid_579283 = query.getOrDefault("access_token")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "access_token", valid_579283
  var valid_579284 = query.getOrDefault("upload_protocol")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "upload_protocol", valid_579284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579285: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
  ## 
  let valid = call_579285.validator(path, query, header, formData, body)
  let scheme = call_579285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579285.url(scheme.get, call_579285.host, call_579285.base,
                         call_579285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579285, url, valid)

proc call*(call_579286: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579269;
          parent: string; dicomWebPath: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dicomWebPath: string (required)
  ##               : The path of the DeleteInstance request (for example,
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}`).
  var path_579287 = newJObject()
  var query_579288 = newJObject()
  add(query_579288, "key", newJString(key))
  add(query_579288, "prettyPrint", newJBool(prettyPrint))
  add(query_579288, "oauth_token", newJString(oauthToken))
  add(query_579288, "$.xgafv", newJString(Xgafv))
  add(query_579288, "alt", newJString(alt))
  add(query_579288, "uploadType", newJString(uploadType))
  add(query_579288, "quotaUser", newJString(quotaUser))
  add(query_579288, "callback", newJString(callback))
  add(path_579287, "parent", newJString(parent))
  add(query_579288, "fields", newJString(fields))
  add(query_579288, "access_token", newJString(accessToken))
  add(query_579288, "upload_protocol", newJString(uploadProtocol))
  add(path_579287, "dicomWebPath", newJString(dicomWebPath))
  result = call_579286.call(path_579287, query_579288, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579269(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579270,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_579271,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579289 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579291(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579290(
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
  var valid_579297 = query.getOrDefault("alt")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = newJString("json"))
  if valid_579297 != nil:
    section.add "alt", valid_579297
  var valid_579298 = query.getOrDefault("uploadType")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "uploadType", valid_579298
  var valid_579299 = query.getOrDefault("quotaUser")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "quotaUser", valid_579299
  var valid_579300 = query.getOrDefault("callback")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "callback", valid_579300
  var valid_579301 = query.getOrDefault("fields")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "fields", valid_579301
  var valid_579302 = query.getOrDefault("access_token")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "access_token", valid_579302
  var valid_579303 = query.getOrDefault("upload_protocol")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "upload_protocol", valid_579303
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

proc call*(call_579305: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579289;
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
  let valid = call_579305.validator(path, query, header, formData, body)
  let scheme = call_579305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579305.url(scheme.get, call_579305.host, call_579305.base,
                         call_579305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579305, url, valid)

proc call*(call_579306: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579289;
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
  var path_579307 = newJObject()
  var query_579308 = newJObject()
  var body_579309 = newJObject()
  add(query_579308, "key", newJString(key))
  add(query_579308, "prettyPrint", newJBool(prettyPrint))
  add(query_579308, "oauth_token", newJString(oauthToken))
  add(query_579308, "$.xgafv", newJString(Xgafv))
  add(query_579308, "alt", newJString(alt))
  add(query_579308, "uploadType", newJString(uploadType))
  add(query_579308, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579309 = body
  add(query_579308, "callback", newJString(callback))
  add(path_579307, "parent", newJString(parent))
  add(query_579308, "fields", newJString(fields))
  add(query_579308, "access_token", newJString(accessToken))
  add(query_579308, "upload_protocol", newJString(uploadProtocol))
  result = call_579306.call(path_579307, query_579308, nil, nil, body_579309)

var healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579289(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579290,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_579291,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579310 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579312(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/Observation/$lastn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579311(
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
  var valid_579313 = path.getOrDefault("parent")
  valid_579313 = validateParameter(valid_579313, JString, required = true,
                                 default = nil)
  if valid_579313 != nil:
    section.add "parent", valid_579313
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
  var valid_579314 = query.getOrDefault("key")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "key", valid_579314
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
  var valid_579317 = query.getOrDefault("$.xgafv")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = newJString("1"))
  if valid_579317 != nil:
    section.add "$.xgafv", valid_579317
  var valid_579318 = query.getOrDefault("alt")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("json"))
  if valid_579318 != nil:
    section.add "alt", valid_579318
  var valid_579319 = query.getOrDefault("uploadType")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "uploadType", valid_579319
  var valid_579320 = query.getOrDefault("quotaUser")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "quotaUser", valid_579320
  var valid_579321 = query.getOrDefault("callback")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "callback", valid_579321
  var valid_579322 = query.getOrDefault("fields")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "fields", valid_579322
  var valid_579323 = query.getOrDefault("access_token")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "access_token", valid_579323
  var valid_579324 = query.getOrDefault("upload_protocol")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "upload_protocol", valid_579324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579325: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579310;
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
  let valid = call_579325.validator(path, query, header, formData, body)
  let scheme = call_579325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579325.url(scheme.get, call_579325.host, call_579325.base,
                         call_579325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579325, url, valid)

proc call*(call_579326: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579310;
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
  var path_579327 = newJObject()
  var query_579328 = newJObject()
  add(query_579328, "key", newJString(key))
  add(query_579328, "prettyPrint", newJBool(prettyPrint))
  add(query_579328, "oauth_token", newJString(oauthToken))
  add(query_579328, "$.xgafv", newJString(Xgafv))
  add(query_579328, "alt", newJString(alt))
  add(query_579328, "uploadType", newJString(uploadType))
  add(query_579328, "quotaUser", newJString(quotaUser))
  add(query_579328, "callback", newJString(callback))
  add(path_579327, "parent", newJString(parent))
  add(query_579328, "fields", newJString(fields))
  add(query_579328, "access_token", newJString(accessToken))
  add(query_579328, "upload_protocol", newJString(uploadProtocol))
  result = call_579326.call(path_579327, query_579328, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579310(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/Observation/$lastn", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579311,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_579312,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579329 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579331(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/_search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579330(
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
  var valid_579332 = path.getOrDefault("parent")
  valid_579332 = validateParameter(valid_579332, JString, required = true,
                                 default = nil)
  if valid_579332 != nil:
    section.add "parent", valid_579332
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
  var valid_579333 = query.getOrDefault("key")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "key", valid_579333
  var valid_579334 = query.getOrDefault("prettyPrint")
  valid_579334 = validateParameter(valid_579334, JBool, required = false,
                                 default = newJBool(true))
  if valid_579334 != nil:
    section.add "prettyPrint", valid_579334
  var valid_579335 = query.getOrDefault("oauth_token")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "oauth_token", valid_579335
  var valid_579336 = query.getOrDefault("$.xgafv")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = newJString("1"))
  if valid_579336 != nil:
    section.add "$.xgafv", valid_579336
  var valid_579337 = query.getOrDefault("alt")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = newJString("json"))
  if valid_579337 != nil:
    section.add "alt", valid_579337
  var valid_579338 = query.getOrDefault("uploadType")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "uploadType", valid_579338
  var valid_579339 = query.getOrDefault("quotaUser")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "quotaUser", valid_579339
  var valid_579340 = query.getOrDefault("callback")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "callback", valid_579340
  var valid_579341 = query.getOrDefault("fields")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "fields", valid_579341
  var valid_579342 = query.getOrDefault("access_token")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "access_token", valid_579342
  var valid_579343 = query.getOrDefault("upload_protocol")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "upload_protocol", valid_579343
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

proc call*(call_579345: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579329;
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
  let valid = call_579345.validator(path, query, header, formData, body)
  let scheme = call_579345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579345.url(scheme.get, call_579345.host, call_579345.base,
                         call_579345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579345, url, valid)

proc call*(call_579346: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579329;
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
  var path_579347 = newJObject()
  var query_579348 = newJObject()
  var body_579349 = newJObject()
  add(query_579348, "key", newJString(key))
  add(query_579348, "prettyPrint", newJBool(prettyPrint))
  add(query_579348, "oauth_token", newJString(oauthToken))
  add(query_579348, "$.xgafv", newJString(Xgafv))
  add(query_579348, "alt", newJString(alt))
  add(query_579348, "uploadType", newJString(uploadType))
  add(query_579348, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579349 = body
  add(query_579348, "callback", newJString(callback))
  add(path_579347, "parent", newJString(parent))
  add(query_579348, "fields", newJString(fields))
  add(query_579348, "access_token", newJString(accessToken))
  add(query_579348, "upload_protocol", newJString(uploadProtocol))
  result = call_579346.call(path_579347, query_579348, nil, nil, body_579349)

var healthcareProjectsLocationsDatasetsFhirStoresFhirSearch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579329(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirSearch",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/_search", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579330,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_579331,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579350 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579352(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579351(
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
  var valid_579353 = path.getOrDefault("type")
  valid_579353 = validateParameter(valid_579353, JString, required = true,
                                 default = nil)
  if valid_579353 != nil:
    section.add "type", valid_579353
  var valid_579354 = path.getOrDefault("parent")
  valid_579354 = validateParameter(valid_579354, JString, required = true,
                                 default = nil)
  if valid_579354 != nil:
    section.add "parent", valid_579354
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
  var valid_579355 = query.getOrDefault("key")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "key", valid_579355
  var valid_579356 = query.getOrDefault("prettyPrint")
  valid_579356 = validateParameter(valid_579356, JBool, required = false,
                                 default = newJBool(true))
  if valid_579356 != nil:
    section.add "prettyPrint", valid_579356
  var valid_579357 = query.getOrDefault("oauth_token")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "oauth_token", valid_579357
  var valid_579358 = query.getOrDefault("$.xgafv")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = newJString("1"))
  if valid_579358 != nil:
    section.add "$.xgafv", valid_579358
  var valid_579359 = query.getOrDefault("alt")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = newJString("json"))
  if valid_579359 != nil:
    section.add "alt", valid_579359
  var valid_579360 = query.getOrDefault("uploadType")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "uploadType", valid_579360
  var valid_579361 = query.getOrDefault("quotaUser")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "quotaUser", valid_579361
  var valid_579362 = query.getOrDefault("callback")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "callback", valid_579362
  var valid_579363 = query.getOrDefault("fields")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "fields", valid_579363
  var valid_579364 = query.getOrDefault("access_token")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "access_token", valid_579364
  var valid_579365 = query.getOrDefault("upload_protocol")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "upload_protocol", valid_579365
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

proc call*(call_579367: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579350;
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
  let valid = call_579367.validator(path, query, header, formData, body)
  let scheme = call_579367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579367.url(scheme.get, call_579367.host, call_579367.base,
                         call_579367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579367, url, valid)

proc call*(call_579368: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579350;
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
  var path_579369 = newJObject()
  var query_579370 = newJObject()
  var body_579371 = newJObject()
  add(query_579370, "key", newJString(key))
  add(query_579370, "prettyPrint", newJBool(prettyPrint))
  add(query_579370, "oauth_token", newJString(oauthToken))
  add(query_579370, "$.xgafv", newJString(Xgafv))
  add(path_579369, "type", newJString(`type`))
  add(query_579370, "alt", newJString(alt))
  add(query_579370, "uploadType", newJString(uploadType))
  add(query_579370, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579371 = body
  add(query_579370, "callback", newJString(callback))
  add(path_579369, "parent", newJString(parent))
  add(query_579370, "fields", newJString(fields))
  add(query_579370, "access_token", newJString(accessToken))
  add(query_579370, "upload_protocol", newJString(uploadProtocol))
  result = call_579368.call(path_579369, query_579370, nil, nil, body_579371)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579350(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579351,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_579352,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579372 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579374(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579373(
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
  var valid_579375 = path.getOrDefault("type")
  valid_579375 = validateParameter(valid_579375, JString, required = true,
                                 default = nil)
  if valid_579375 != nil:
    section.add "type", valid_579375
  var valid_579376 = path.getOrDefault("parent")
  valid_579376 = validateParameter(valid_579376, JString, required = true,
                                 default = nil)
  if valid_579376 != nil:
    section.add "parent", valid_579376
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
  var valid_579377 = query.getOrDefault("key")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "key", valid_579377
  var valid_579378 = query.getOrDefault("prettyPrint")
  valid_579378 = validateParameter(valid_579378, JBool, required = false,
                                 default = newJBool(true))
  if valid_579378 != nil:
    section.add "prettyPrint", valid_579378
  var valid_579379 = query.getOrDefault("oauth_token")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "oauth_token", valid_579379
  var valid_579380 = query.getOrDefault("$.xgafv")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = newJString("1"))
  if valid_579380 != nil:
    section.add "$.xgafv", valid_579380
  var valid_579381 = query.getOrDefault("alt")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = newJString("json"))
  if valid_579381 != nil:
    section.add "alt", valid_579381
  var valid_579382 = query.getOrDefault("uploadType")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "uploadType", valid_579382
  var valid_579383 = query.getOrDefault("quotaUser")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "quotaUser", valid_579383
  var valid_579384 = query.getOrDefault("callback")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "callback", valid_579384
  var valid_579385 = query.getOrDefault("fields")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "fields", valid_579385
  var valid_579386 = query.getOrDefault("access_token")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "access_token", valid_579386
  var valid_579387 = query.getOrDefault("upload_protocol")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "upload_protocol", valid_579387
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

proc call*(call_579389: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579372;
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
  let valid = call_579389.validator(path, query, header, formData, body)
  let scheme = call_579389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579389.url(scheme.get, call_579389.host, call_579389.base,
                         call_579389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579389, url, valid)

proc call*(call_579390: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579372;
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
  var path_579391 = newJObject()
  var query_579392 = newJObject()
  var body_579393 = newJObject()
  add(query_579392, "key", newJString(key))
  add(query_579392, "prettyPrint", newJBool(prettyPrint))
  add(query_579392, "oauth_token", newJString(oauthToken))
  add(query_579392, "$.xgafv", newJString(Xgafv))
  add(path_579391, "type", newJString(`type`))
  add(query_579392, "alt", newJString(alt))
  add(query_579392, "uploadType", newJString(uploadType))
  add(query_579392, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579393 = body
  add(query_579392, "callback", newJString(callback))
  add(path_579391, "parent", newJString(parent))
  add(query_579392, "fields", newJString(fields))
  add(query_579392, "access_token", newJString(accessToken))
  add(query_579392, "upload_protocol", newJString(uploadProtocol))
  result = call_579390.call(path_579391, query_579392, nil, nil, body_579393)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579372(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579373,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_579374,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579414 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579416(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579415(
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
  var valid_579417 = path.getOrDefault("type")
  valid_579417 = validateParameter(valid_579417, JString, required = true,
                                 default = nil)
  if valid_579417 != nil:
    section.add "type", valid_579417
  var valid_579418 = path.getOrDefault("parent")
  valid_579418 = validateParameter(valid_579418, JString, required = true,
                                 default = nil)
  if valid_579418 != nil:
    section.add "parent", valid_579418
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
  var valid_579419 = query.getOrDefault("key")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "key", valid_579419
  var valid_579420 = query.getOrDefault("prettyPrint")
  valid_579420 = validateParameter(valid_579420, JBool, required = false,
                                 default = newJBool(true))
  if valid_579420 != nil:
    section.add "prettyPrint", valid_579420
  var valid_579421 = query.getOrDefault("oauth_token")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "oauth_token", valid_579421
  var valid_579422 = query.getOrDefault("$.xgafv")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = newJString("1"))
  if valid_579422 != nil:
    section.add "$.xgafv", valid_579422
  var valid_579423 = query.getOrDefault("alt")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = newJString("json"))
  if valid_579423 != nil:
    section.add "alt", valid_579423
  var valid_579424 = query.getOrDefault("uploadType")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "uploadType", valid_579424
  var valid_579425 = query.getOrDefault("quotaUser")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "quotaUser", valid_579425
  var valid_579426 = query.getOrDefault("callback")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "callback", valid_579426
  var valid_579427 = query.getOrDefault("fields")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "fields", valid_579427
  var valid_579428 = query.getOrDefault("access_token")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "access_token", valid_579428
  var valid_579429 = query.getOrDefault("upload_protocol")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "upload_protocol", valid_579429
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

proc call*(call_579431: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579414;
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
  let valid = call_579431.validator(path, query, header, formData, body)
  let scheme = call_579431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579431.url(scheme.get, call_579431.host, call_579431.base,
                         call_579431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579431, url, valid)

proc call*(call_579432: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579414;
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
  var path_579433 = newJObject()
  var query_579434 = newJObject()
  var body_579435 = newJObject()
  add(query_579434, "key", newJString(key))
  add(query_579434, "prettyPrint", newJBool(prettyPrint))
  add(query_579434, "oauth_token", newJString(oauthToken))
  add(query_579434, "$.xgafv", newJString(Xgafv))
  add(path_579433, "type", newJString(`type`))
  add(query_579434, "alt", newJString(alt))
  add(query_579434, "uploadType", newJString(uploadType))
  add(query_579434, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579435 = body
  add(query_579434, "callback", newJString(callback))
  add(path_579433, "parent", newJString(parent))
  add(query_579434, "fields", newJString(fields))
  add(query_579434, "access_token", newJString(accessToken))
  add(query_579434, "upload_protocol", newJString(uploadProtocol))
  result = call_579432.call(path_579433, query_579434, nil, nil, body_579435)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579414(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579415,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_579416,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579394 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579396(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579395(
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
  var valid_579397 = path.getOrDefault("type")
  valid_579397 = validateParameter(valid_579397, JString, required = true,
                                 default = nil)
  if valid_579397 != nil:
    section.add "type", valid_579397
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
  if body != nil:
    result.add "body", body

proc call*(call_579410: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579394;
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
  let valid = call_579410.validator(path, query, header, formData, body)
  let scheme = call_579410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579410.url(scheme.get, call_579410.host, call_579410.base,
                         call_579410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579410, url, valid)

proc call*(call_579411: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579394;
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
  var path_579412 = newJObject()
  var query_579413 = newJObject()
  add(query_579413, "key", newJString(key))
  add(query_579413, "prettyPrint", newJBool(prettyPrint))
  add(query_579413, "oauth_token", newJString(oauthToken))
  add(query_579413, "$.xgafv", newJString(Xgafv))
  add(path_579412, "type", newJString(`type`))
  add(query_579413, "alt", newJString(alt))
  add(query_579413, "uploadType", newJString(uploadType))
  add(query_579413, "quotaUser", newJString(quotaUser))
  add(query_579413, "callback", newJString(callback))
  add(path_579412, "parent", newJString(parent))
  add(query_579413, "fields", newJString(fields))
  add(query_579413, "access_token", newJString(accessToken))
  add(query_579413, "upload_protocol", newJString(uploadProtocol))
  result = call_579411.call(path_579412, query_579413, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579394(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579395,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_579396,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579458 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579460(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579459(
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
  var valid_579461 = path.getOrDefault("parent")
  valid_579461 = validateParameter(valid_579461, JString, required = true,
                                 default = nil)
  if valid_579461 != nil:
    section.add "parent", valid_579461
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
  var valid_579462 = query.getOrDefault("key")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "key", valid_579462
  var valid_579463 = query.getOrDefault("prettyPrint")
  valid_579463 = validateParameter(valid_579463, JBool, required = false,
                                 default = newJBool(true))
  if valid_579463 != nil:
    section.add "prettyPrint", valid_579463
  var valid_579464 = query.getOrDefault("oauth_token")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "oauth_token", valid_579464
  var valid_579465 = query.getOrDefault("$.xgafv")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = newJString("1"))
  if valid_579465 != nil:
    section.add "$.xgafv", valid_579465
  var valid_579466 = query.getOrDefault("alt")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = newJString("json"))
  if valid_579466 != nil:
    section.add "alt", valid_579466
  var valid_579467 = query.getOrDefault("uploadType")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "uploadType", valid_579467
  var valid_579468 = query.getOrDefault("quotaUser")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "quotaUser", valid_579468
  var valid_579469 = query.getOrDefault("callback")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "callback", valid_579469
  var valid_579470 = query.getOrDefault("fhirStoreId")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "fhirStoreId", valid_579470
  var valid_579471 = query.getOrDefault("fields")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "fields", valid_579471
  var valid_579472 = query.getOrDefault("access_token")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "access_token", valid_579472
  var valid_579473 = query.getOrDefault("upload_protocol")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = nil)
  if valid_579473 != nil:
    section.add "upload_protocol", valid_579473
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

proc call*(call_579475: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new FHIR store within the parent dataset.
  ## 
  let valid = call_579475.validator(path, query, header, formData, body)
  let scheme = call_579475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579475.url(scheme.get, call_579475.host, call_579475.base,
                         call_579475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579475, url, valid)

proc call*(call_579476: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579458;
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
  var path_579477 = newJObject()
  var query_579478 = newJObject()
  var body_579479 = newJObject()
  add(query_579478, "key", newJString(key))
  add(query_579478, "prettyPrint", newJBool(prettyPrint))
  add(query_579478, "oauth_token", newJString(oauthToken))
  add(query_579478, "$.xgafv", newJString(Xgafv))
  add(query_579478, "alt", newJString(alt))
  add(query_579478, "uploadType", newJString(uploadType))
  add(query_579478, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579479 = body
  add(query_579478, "callback", newJString(callback))
  add(path_579477, "parent", newJString(parent))
  add(query_579478, "fhirStoreId", newJString(fhirStoreId))
  add(query_579478, "fields", newJString(fields))
  add(query_579478, "access_token", newJString(accessToken))
  add(query_579478, "upload_protocol", newJString(uploadProtocol))
  result = call_579476.call(path_579477, query_579478, nil, nil, body_579479)

var healthcareProjectsLocationsDatasetsFhirStoresCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579458(
    name: "healthcareProjectsLocationsDatasetsFhirStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579459,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_579460,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579436 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresList_579438(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresList_579437(
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
  var valid_579439 = path.getOrDefault("parent")
  valid_579439 = validateParameter(valid_579439, JString, required = true,
                                 default = nil)
  if valid_579439 != nil:
    section.add "parent", valid_579439
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
  var valid_579440 = query.getOrDefault("key")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "key", valid_579440
  var valid_579441 = query.getOrDefault("prettyPrint")
  valid_579441 = validateParameter(valid_579441, JBool, required = false,
                                 default = newJBool(true))
  if valid_579441 != nil:
    section.add "prettyPrint", valid_579441
  var valid_579442 = query.getOrDefault("oauth_token")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "oauth_token", valid_579442
  var valid_579443 = query.getOrDefault("$.xgafv")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = newJString("1"))
  if valid_579443 != nil:
    section.add "$.xgafv", valid_579443
  var valid_579444 = query.getOrDefault("pageSize")
  valid_579444 = validateParameter(valid_579444, JInt, required = false, default = nil)
  if valid_579444 != nil:
    section.add "pageSize", valid_579444
  var valid_579445 = query.getOrDefault("alt")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = newJString("json"))
  if valid_579445 != nil:
    section.add "alt", valid_579445
  var valid_579446 = query.getOrDefault("uploadType")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "uploadType", valid_579446
  var valid_579447 = query.getOrDefault("quotaUser")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "quotaUser", valid_579447
  var valid_579448 = query.getOrDefault("filter")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "filter", valid_579448
  var valid_579449 = query.getOrDefault("pageToken")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "pageToken", valid_579449
  var valid_579450 = query.getOrDefault("callback")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "callback", valid_579450
  var valid_579451 = query.getOrDefault("fields")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "fields", valid_579451
  var valid_579452 = query.getOrDefault("access_token")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "access_token", valid_579452
  var valid_579453 = query.getOrDefault("upload_protocol")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "upload_protocol", valid_579453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579454: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the FHIR stores in the given dataset.
  ## 
  let valid = call_579454.validator(path, query, header, formData, body)
  let scheme = call_579454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579454.url(scheme.get, call_579454.host, call_579454.base,
                         call_579454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579454, url, valid)

proc call*(call_579455: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579436;
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
  var path_579456 = newJObject()
  var query_579457 = newJObject()
  add(query_579457, "key", newJString(key))
  add(query_579457, "prettyPrint", newJBool(prettyPrint))
  add(query_579457, "oauth_token", newJString(oauthToken))
  add(query_579457, "$.xgafv", newJString(Xgafv))
  add(query_579457, "pageSize", newJInt(pageSize))
  add(query_579457, "alt", newJString(alt))
  add(query_579457, "uploadType", newJString(uploadType))
  add(query_579457, "quotaUser", newJString(quotaUser))
  add(query_579457, "filter", newJString(filter))
  add(query_579457, "pageToken", newJString(pageToken))
  add(query_579457, "callback", newJString(callback))
  add(path_579456, "parent", newJString(parent))
  add(query_579457, "fields", newJString(fields))
  add(query_579457, "access_token", newJString(accessToken))
  add(query_579457, "upload_protocol", newJString(uploadProtocol))
  result = call_579455.call(path_579456, query_579457, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresList* = Call_HealthcareProjectsLocationsDatasetsFhirStoresList_579436(
    name: "healthcareProjectsLocationsDatasetsFhirStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresList_579437,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresList_579438,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579502 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579504(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579503(
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
  var valid_579505 = path.getOrDefault("parent")
  valid_579505 = validateParameter(valid_579505, JString, required = true,
                                 default = nil)
  if valid_579505 != nil:
    section.add "parent", valid_579505
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
  var valid_579506 = query.getOrDefault("key")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "key", valid_579506
  var valid_579507 = query.getOrDefault("prettyPrint")
  valid_579507 = validateParameter(valid_579507, JBool, required = false,
                                 default = newJBool(true))
  if valid_579507 != nil:
    section.add "prettyPrint", valid_579507
  var valid_579508 = query.getOrDefault("oauth_token")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "oauth_token", valid_579508
  var valid_579509 = query.getOrDefault("hl7V2StoreId")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "hl7V2StoreId", valid_579509
  var valid_579510 = query.getOrDefault("$.xgafv")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = newJString("1"))
  if valid_579510 != nil:
    section.add "$.xgafv", valid_579510
  var valid_579511 = query.getOrDefault("alt")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = newJString("json"))
  if valid_579511 != nil:
    section.add "alt", valid_579511
  var valid_579512 = query.getOrDefault("uploadType")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "uploadType", valid_579512
  var valid_579513 = query.getOrDefault("quotaUser")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "quotaUser", valid_579513
  var valid_579514 = query.getOrDefault("callback")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "callback", valid_579514
  var valid_579515 = query.getOrDefault("fields")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "fields", valid_579515
  var valid_579516 = query.getOrDefault("access_token")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "access_token", valid_579516
  var valid_579517 = query.getOrDefault("upload_protocol")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = nil)
  if valid_579517 != nil:
    section.add "upload_protocol", valid_579517
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

proc call*(call_579519: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579502;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new HL7v2 store within the parent dataset.
  ## 
  let valid = call_579519.validator(path, query, header, formData, body)
  let scheme = call_579519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579519.url(scheme.get, call_579519.host, call_579519.base,
                         call_579519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579519, url, valid)

proc call*(call_579520: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579502;
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
  var path_579521 = newJObject()
  var query_579522 = newJObject()
  var body_579523 = newJObject()
  add(query_579522, "key", newJString(key))
  add(query_579522, "prettyPrint", newJBool(prettyPrint))
  add(query_579522, "oauth_token", newJString(oauthToken))
  add(query_579522, "hl7V2StoreId", newJString(hl7V2StoreId))
  add(query_579522, "$.xgafv", newJString(Xgafv))
  add(query_579522, "alt", newJString(alt))
  add(query_579522, "uploadType", newJString(uploadType))
  add(query_579522, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579523 = body
  add(query_579522, "callback", newJString(callback))
  add(path_579521, "parent", newJString(parent))
  add(query_579522, "fields", newJString(fields))
  add(query_579522, "access_token", newJString(accessToken))
  add(query_579522, "upload_protocol", newJString(uploadProtocol))
  result = call_579520.call(path_579521, query_579522, nil, nil, body_579523)

var healthcareProjectsLocationsDatasetsHl7V2StoresCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579502(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579503,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_579504,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579480 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579482(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579481(
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
  var valid_579483 = path.getOrDefault("parent")
  valid_579483 = validateParameter(valid_579483, JString, required = true,
                                 default = nil)
  if valid_579483 != nil:
    section.add "parent", valid_579483
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
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
  var valid_579484 = query.getOrDefault("key")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "key", valid_579484
  var valid_579485 = query.getOrDefault("prettyPrint")
  valid_579485 = validateParameter(valid_579485, JBool, required = false,
                                 default = newJBool(true))
  if valid_579485 != nil:
    section.add "prettyPrint", valid_579485
  var valid_579486 = query.getOrDefault("oauth_token")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = nil)
  if valid_579486 != nil:
    section.add "oauth_token", valid_579486
  var valid_579487 = query.getOrDefault("$.xgafv")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = newJString("1"))
  if valid_579487 != nil:
    section.add "$.xgafv", valid_579487
  var valid_579488 = query.getOrDefault("pageSize")
  valid_579488 = validateParameter(valid_579488, JInt, required = false, default = nil)
  if valid_579488 != nil:
    section.add "pageSize", valid_579488
  var valid_579489 = query.getOrDefault("alt")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = newJString("json"))
  if valid_579489 != nil:
    section.add "alt", valid_579489
  var valid_579490 = query.getOrDefault("uploadType")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "uploadType", valid_579490
  var valid_579491 = query.getOrDefault("quotaUser")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "quotaUser", valid_579491
  var valid_579492 = query.getOrDefault("filter")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "filter", valid_579492
  var valid_579493 = query.getOrDefault("pageToken")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "pageToken", valid_579493
  var valid_579494 = query.getOrDefault("callback")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "callback", valid_579494
  var valid_579495 = query.getOrDefault("fields")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "fields", valid_579495
  var valid_579496 = query.getOrDefault("access_token")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "access_token", valid_579496
  var valid_579497 = query.getOrDefault("upload_protocol")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "upload_protocol", valid_579497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579498: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the HL7v2 stores in the given dataset.
  ## 
  let valid = call_579498.validator(path, query, header, formData, body)
  let scheme = call_579498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579498.url(scheme.get, call_579498.host, call_579498.base,
                         call_579498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579498, url, valid)

proc call*(call_579499: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579480;
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
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
  var path_579500 = newJObject()
  var query_579501 = newJObject()
  add(query_579501, "key", newJString(key))
  add(query_579501, "prettyPrint", newJBool(prettyPrint))
  add(query_579501, "oauth_token", newJString(oauthToken))
  add(query_579501, "$.xgafv", newJString(Xgafv))
  add(query_579501, "pageSize", newJInt(pageSize))
  add(query_579501, "alt", newJString(alt))
  add(query_579501, "uploadType", newJString(uploadType))
  add(query_579501, "quotaUser", newJString(quotaUser))
  add(query_579501, "filter", newJString(filter))
  add(query_579501, "pageToken", newJString(pageToken))
  add(query_579501, "callback", newJString(callback))
  add(path_579500, "parent", newJString(parent))
  add(query_579501, "fields", newJString(fields))
  add(query_579501, "access_token", newJString(accessToken))
  add(query_579501, "upload_protocol", newJString(uploadProtocol))
  result = call_579499.call(path_579500, query_579501, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579480(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579481,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_579482,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579547 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579549(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579548(
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
  var valid_579550 = path.getOrDefault("parent")
  valid_579550 = validateParameter(valid_579550, JString, required = true,
                                 default = nil)
  if valid_579550 != nil:
    section.add "parent", valid_579550
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
  var valid_579551 = query.getOrDefault("key")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "key", valid_579551
  var valid_579552 = query.getOrDefault("prettyPrint")
  valid_579552 = validateParameter(valid_579552, JBool, required = false,
                                 default = newJBool(true))
  if valid_579552 != nil:
    section.add "prettyPrint", valid_579552
  var valid_579553 = query.getOrDefault("oauth_token")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "oauth_token", valid_579553
  var valid_579554 = query.getOrDefault("$.xgafv")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = newJString("1"))
  if valid_579554 != nil:
    section.add "$.xgafv", valid_579554
  var valid_579555 = query.getOrDefault("alt")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = newJString("json"))
  if valid_579555 != nil:
    section.add "alt", valid_579555
  var valid_579556 = query.getOrDefault("uploadType")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "uploadType", valid_579556
  var valid_579557 = query.getOrDefault("quotaUser")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "quotaUser", valid_579557
  var valid_579558 = query.getOrDefault("callback")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "callback", valid_579558
  var valid_579559 = query.getOrDefault("fields")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "fields", valid_579559
  var valid_579560 = query.getOrDefault("access_token")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "access_token", valid_579560
  var valid_579561 = query.getOrDefault("upload_protocol")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "upload_protocol", valid_579561
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

proc call*(call_579563: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
  ## 
  let valid = call_579563.validator(path, query, header, formData, body)
  let scheme = call_579563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579563.url(scheme.get, call_579563.host, call_579563.base,
                         call_579563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579563, url, valid)

proc call*(call_579564: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579547;
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
  var path_579565 = newJObject()
  var query_579566 = newJObject()
  var body_579567 = newJObject()
  add(query_579566, "key", newJString(key))
  add(query_579566, "prettyPrint", newJBool(prettyPrint))
  add(query_579566, "oauth_token", newJString(oauthToken))
  add(query_579566, "$.xgafv", newJString(Xgafv))
  add(query_579566, "alt", newJString(alt))
  add(query_579566, "uploadType", newJString(uploadType))
  add(query_579566, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579567 = body
  add(query_579566, "callback", newJString(callback))
  add(path_579565, "parent", newJString(parent))
  add(query_579566, "fields", newJString(fields))
  add(query_579566, "access_token", newJString(accessToken))
  add(query_579566, "upload_protocol", newJString(uploadProtocol))
  result = call_579564.call(path_579565, query_579566, nil, nil, body_579567)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579547(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579548,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_579549,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579524 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579526(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579525(
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
  var valid_579527 = path.getOrDefault("parent")
  valid_579527 = validateParameter(valid_579527, JString, required = true,
                                 default = nil)
  if valid_579527 != nil:
    section.add "parent", valid_579527
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
  ## *  `message_type`, from the MSH-9 segment. For example,
  ## `NOT message_type = "ADT"`.
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment. For example,
  ## `send_date < "2017-01-02"`.
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment. For example,
  ## `send_time < "2017-01-02T00:00:00-05:00"`.
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment. For example, `send_facility = "ABC"`.
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using RE2 syntax
  ## (https://github.com/google/re2/wiki/Syntax). For example,
  ## `HL7RegExp("^.*\|.*\|EMERG")`.
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments. For example, `PatientId("123456", "MRN")`.
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map. For example, `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label. For example, `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported. For example, these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported. For example, this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
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
  var valid_579528 = query.getOrDefault("key")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "key", valid_579528
  var valid_579529 = query.getOrDefault("prettyPrint")
  valid_579529 = validateParameter(valid_579529, JBool, required = false,
                                 default = newJBool(true))
  if valid_579529 != nil:
    section.add "prettyPrint", valid_579529
  var valid_579530 = query.getOrDefault("oauth_token")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "oauth_token", valid_579530
  var valid_579531 = query.getOrDefault("$.xgafv")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = newJString("1"))
  if valid_579531 != nil:
    section.add "$.xgafv", valid_579531
  var valid_579532 = query.getOrDefault("pageSize")
  valid_579532 = validateParameter(valid_579532, JInt, required = false, default = nil)
  if valid_579532 != nil:
    section.add "pageSize", valid_579532
  var valid_579533 = query.getOrDefault("alt")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = newJString("json"))
  if valid_579533 != nil:
    section.add "alt", valid_579533
  var valid_579534 = query.getOrDefault("uploadType")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "uploadType", valid_579534
  var valid_579535 = query.getOrDefault("quotaUser")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = nil)
  if valid_579535 != nil:
    section.add "quotaUser", valid_579535
  var valid_579536 = query.getOrDefault("orderBy")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "orderBy", valid_579536
  var valid_579537 = query.getOrDefault("filter")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = nil)
  if valid_579537 != nil:
    section.add "filter", valid_579537
  var valid_579538 = query.getOrDefault("pageToken")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = nil)
  if valid_579538 != nil:
    section.add "pageToken", valid_579538
  var valid_579539 = query.getOrDefault("callback")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "callback", valid_579539
  var valid_579540 = query.getOrDefault("fields")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "fields", valid_579540
  var valid_579541 = query.getOrDefault("access_token")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "access_token", valid_579541
  var valid_579542 = query.getOrDefault("upload_protocol")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "upload_protocol", valid_579542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579543: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ## 
  let valid = call_579543.validator(path, query, header, formData, body)
  let scheme = call_579543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579543.url(scheme.get, call_579543.host, call_579543.base,
                         call_579543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579543, url, valid)

proc call*(call_579544: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579524;
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
  ## *  `message_type`, from the MSH-9 segment. For example,
  ## `NOT message_type = "ADT"`.
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment. For example,
  ## `send_date < "2017-01-02"`.
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment. For example,
  ## `send_time < "2017-01-02T00:00:00-05:00"`.
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment. For example, `send_facility = "ABC"`.
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using RE2 syntax
  ## (https://github.com/google/re2/wiki/Syntax). For example,
  ## `HL7RegExp("^.*\|.*\|EMERG")`.
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments. For example, `PatientId("123456", "MRN")`.
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map. For example, `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label. For example, `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported. For example, these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported. For example, this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
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
  var path_579545 = newJObject()
  var query_579546 = newJObject()
  add(query_579546, "key", newJString(key))
  add(query_579546, "prettyPrint", newJBool(prettyPrint))
  add(query_579546, "oauth_token", newJString(oauthToken))
  add(query_579546, "$.xgafv", newJString(Xgafv))
  add(query_579546, "pageSize", newJInt(pageSize))
  add(query_579546, "alt", newJString(alt))
  add(query_579546, "uploadType", newJString(uploadType))
  add(query_579546, "quotaUser", newJString(quotaUser))
  add(query_579546, "orderBy", newJString(orderBy))
  add(query_579546, "filter", newJString(filter))
  add(query_579546, "pageToken", newJString(pageToken))
  add(query_579546, "callback", newJString(callback))
  add(path_579545, "parent", newJString(parent))
  add(query_579546, "fields", newJString(fields))
  add(query_579546, "access_token", newJString(accessToken))
  add(query_579546, "upload_protocol", newJString(uploadProtocol))
  result = call_579544.call(path_579545, query_579546, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579524(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579525,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_579526,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579568 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579570(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/messages:ingest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579569(
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
  var valid_579571 = path.getOrDefault("parent")
  valid_579571 = validateParameter(valid_579571, JString, required = true,
                                 default = nil)
  if valid_579571 != nil:
    section.add "parent", valid_579571
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
  var valid_579572 = query.getOrDefault("key")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "key", valid_579572
  var valid_579573 = query.getOrDefault("prettyPrint")
  valid_579573 = validateParameter(valid_579573, JBool, required = false,
                                 default = newJBool(true))
  if valid_579573 != nil:
    section.add "prettyPrint", valid_579573
  var valid_579574 = query.getOrDefault("oauth_token")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "oauth_token", valid_579574
  var valid_579575 = query.getOrDefault("$.xgafv")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = newJString("1"))
  if valid_579575 != nil:
    section.add "$.xgafv", valid_579575
  var valid_579576 = query.getOrDefault("alt")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = newJString("json"))
  if valid_579576 != nil:
    section.add "alt", valid_579576
  var valid_579577 = query.getOrDefault("uploadType")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = nil)
  if valid_579577 != nil:
    section.add "uploadType", valid_579577
  var valid_579578 = query.getOrDefault("quotaUser")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "quotaUser", valid_579578
  var valid_579579 = query.getOrDefault("callback")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "callback", valid_579579
  var valid_579580 = query.getOrDefault("fields")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "fields", valid_579580
  var valid_579581 = query.getOrDefault("access_token")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "access_token", valid_579581
  var valid_579582 = query.getOrDefault("upload_protocol")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "upload_protocol", valid_579582
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

proc call*(call_579584: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
  ## 
  let valid = call_579584.validator(path, query, header, formData, body)
  let scheme = call_579584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579584.url(scheme.get, call_579584.host, call_579584.base,
                         call_579584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579584, url, valid)

proc call*(call_579585: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579568;
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
  var path_579586 = newJObject()
  var query_579587 = newJObject()
  var body_579588 = newJObject()
  add(query_579587, "key", newJString(key))
  add(query_579587, "prettyPrint", newJBool(prettyPrint))
  add(query_579587, "oauth_token", newJString(oauthToken))
  add(query_579587, "$.xgafv", newJString(Xgafv))
  add(query_579587, "alt", newJString(alt))
  add(query_579587, "uploadType", newJString(uploadType))
  add(query_579587, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579588 = body
  add(query_579587, "callback", newJString(callback))
  add(path_579586, "parent", newJString(parent))
  add(query_579587, "fields", newJString(fields))
  add(query_579587, "access_token", newJString(accessToken))
  add(query_579587, "upload_protocol", newJString(uploadProtocol))
  result = call_579585.call(path_579586, query_579587, nil, nil, body_579588)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579568(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages:ingest", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579569,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_579570,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579589 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579591(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579590(
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
  var valid_579592 = path.getOrDefault("resource")
  valid_579592 = validateParameter(valid_579592, JString, required = true,
                                 default = nil)
  if valid_579592 != nil:
    section.add "resource", valid_579592
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
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
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
  var valid_579593 = query.getOrDefault("key")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "key", valid_579593
  var valid_579594 = query.getOrDefault("prettyPrint")
  valid_579594 = validateParameter(valid_579594, JBool, required = false,
                                 default = newJBool(true))
  if valid_579594 != nil:
    section.add "prettyPrint", valid_579594
  var valid_579595 = query.getOrDefault("oauth_token")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "oauth_token", valid_579595
  var valid_579596 = query.getOrDefault("$.xgafv")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = newJString("1"))
  if valid_579596 != nil:
    section.add "$.xgafv", valid_579596
  var valid_579597 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579597 = validateParameter(valid_579597, JInt, required = false, default = nil)
  if valid_579597 != nil:
    section.add "options.requestedPolicyVersion", valid_579597
  var valid_579598 = query.getOrDefault("alt")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = newJString("json"))
  if valid_579598 != nil:
    section.add "alt", valid_579598
  var valid_579599 = query.getOrDefault("uploadType")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "uploadType", valid_579599
  var valid_579600 = query.getOrDefault("quotaUser")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = nil)
  if valid_579600 != nil:
    section.add "quotaUser", valid_579600
  var valid_579601 = query.getOrDefault("callback")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "callback", valid_579601
  var valid_579602 = query.getOrDefault("fields")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "fields", valid_579602
  var valid_579603 = query.getOrDefault("access_token")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "access_token", valid_579603
  var valid_579604 = query.getOrDefault("upload_protocol")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "upload_protocol", valid_579604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579605: Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579589;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579605.validator(path, query, header, formData, body)
  let scheme = call_579605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579605.url(scheme.get, call_579605.host, call_579605.base,
                         call_579605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579605, url, valid)

proc call*(call_579606: Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579589;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy
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
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
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
  var path_579607 = newJObject()
  var query_579608 = newJObject()
  add(query_579608, "key", newJString(key))
  add(query_579608, "prettyPrint", newJBool(prettyPrint))
  add(query_579608, "oauth_token", newJString(oauthToken))
  add(query_579608, "$.xgafv", newJString(Xgafv))
  add(query_579608, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579608, "alt", newJString(alt))
  add(query_579608, "uploadType", newJString(uploadType))
  add(query_579608, "quotaUser", newJString(quotaUser))
  add(path_579607, "resource", newJString(resource))
  add(query_579608, "callback", newJString(callback))
  add(query_579608, "fields", newJString(fields))
  add(query_579608, "access_token", newJString(accessToken))
  add(query_579608, "upload_protocol", newJString(uploadProtocol))
  result = call_579606.call(path_579607, query_579608, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579589(
    name: "healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579590,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_579591,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579609 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579611(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579610(
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
  var valid_579612 = path.getOrDefault("resource")
  valid_579612 = validateParameter(valid_579612, JString, required = true,
                                 default = nil)
  if valid_579612 != nil:
    section.add "resource", valid_579612
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
  var valid_579613 = query.getOrDefault("key")
  valid_579613 = validateParameter(valid_579613, JString, required = false,
                                 default = nil)
  if valid_579613 != nil:
    section.add "key", valid_579613
  var valid_579614 = query.getOrDefault("prettyPrint")
  valid_579614 = validateParameter(valid_579614, JBool, required = false,
                                 default = newJBool(true))
  if valid_579614 != nil:
    section.add "prettyPrint", valid_579614
  var valid_579615 = query.getOrDefault("oauth_token")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "oauth_token", valid_579615
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

proc call*(call_579625: Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579625.validator(path, query, header, formData, body)
  let scheme = call_579625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579625.url(scheme.get, call_579625.host, call_579625.base,
                         call_579625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579625, url, valid)

proc call*(call_579626: Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579609;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy
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
  var path_579627 = newJObject()
  var query_579628 = newJObject()
  var body_579629 = newJObject()
  add(query_579628, "key", newJString(key))
  add(query_579628, "prettyPrint", newJBool(prettyPrint))
  add(query_579628, "oauth_token", newJString(oauthToken))
  add(query_579628, "$.xgafv", newJString(Xgafv))
  add(query_579628, "alt", newJString(alt))
  add(query_579628, "uploadType", newJString(uploadType))
  add(query_579628, "quotaUser", newJString(quotaUser))
  add(path_579627, "resource", newJString(resource))
  if body != nil:
    body_579629 = body
  add(query_579628, "callback", newJString(callback))
  add(query_579628, "fields", newJString(fields))
  add(query_579628, "access_token", newJString(accessToken))
  add(query_579628, "upload_protocol", newJString(uploadProtocol))
  result = call_579626.call(path_579627, query_579628, nil, nil, body_579629)

var healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579609(
    name: "healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579610,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_579611,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579630 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579632(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579631(
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
  var valid_579633 = path.getOrDefault("resource")
  valid_579633 = validateParameter(valid_579633, JString, required = true,
                                 default = nil)
  if valid_579633 != nil:
    section.add "resource", valid_579633
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
  var valid_579638 = query.getOrDefault("alt")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = newJString("json"))
  if valid_579638 != nil:
    section.add "alt", valid_579638
  var valid_579639 = query.getOrDefault("uploadType")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "uploadType", valid_579639
  var valid_579640 = query.getOrDefault("quotaUser")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = nil)
  if valid_579640 != nil:
    section.add "quotaUser", valid_579640
  var valid_579641 = query.getOrDefault("callback")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "callback", valid_579641
  var valid_579642 = query.getOrDefault("fields")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "fields", valid_579642
  var valid_579643 = query.getOrDefault("access_token")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "access_token", valid_579643
  var valid_579644 = query.getOrDefault("upload_protocol")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "upload_protocol", valid_579644
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

proc call*(call_579646: Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579630;
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
  let valid = call_579646.validator(path, query, header, formData, body)
  let scheme = call_579646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579646.url(scheme.get, call_579646.host, call_579646.base,
                         call_579646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579646, url, valid)

proc call*(call_579647: Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579630;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions
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
  var path_579648 = newJObject()
  var query_579649 = newJObject()
  var body_579650 = newJObject()
  add(query_579649, "key", newJString(key))
  add(query_579649, "prettyPrint", newJBool(prettyPrint))
  add(query_579649, "oauth_token", newJString(oauthToken))
  add(query_579649, "$.xgafv", newJString(Xgafv))
  add(query_579649, "alt", newJString(alt))
  add(query_579649, "uploadType", newJString(uploadType))
  add(query_579649, "quotaUser", newJString(quotaUser))
  add(path_579648, "resource", newJString(resource))
  if body != nil:
    body_579650 = body
  add(query_579649, "callback", newJString(callback))
  add(query_579649, "fields", newJString(fields))
  add(query_579649, "access_token", newJString(accessToken))
  add(query_579649, "upload_protocol", newJString(uploadProtocol))
  result = call_579647.call(path_579648, query_579649, nil, nil, body_579650)

var healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions* = Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579630(
    name: "healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579631,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_579632,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDeidentify_579651 = ref object of OpenApiRestCall_578348
proc url_HealthcareProjectsLocationsDatasetsDeidentify_579653(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceDataset" in path, "`sourceDataset` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "sourceDataset"),
               (kind: ConstantSegment, value: ":deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDeidentify_579652(
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
  ## Errors are also logged to Stackdriver Logging. For more information,
  ## see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceDataset: JString (required)
  ##                : Source dataset resource name. For example,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceDataset` field"
  var valid_579654 = path.getOrDefault("sourceDataset")
  valid_579654 = validateParameter(valid_579654, JString, required = true,
                                 default = nil)
  if valid_579654 != nil:
    section.add "sourceDataset", valid_579654
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
  var valid_579655 = query.getOrDefault("key")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "key", valid_579655
  var valid_579656 = query.getOrDefault("prettyPrint")
  valid_579656 = validateParameter(valid_579656, JBool, required = false,
                                 default = newJBool(true))
  if valid_579656 != nil:
    section.add "prettyPrint", valid_579656
  var valid_579657 = query.getOrDefault("oauth_token")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "oauth_token", valid_579657
  var valid_579658 = query.getOrDefault("$.xgafv")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = newJString("1"))
  if valid_579658 != nil:
    section.add "$.xgafv", valid_579658
  var valid_579659 = query.getOrDefault("alt")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = newJString("json"))
  if valid_579659 != nil:
    section.add "alt", valid_579659
  var valid_579660 = query.getOrDefault("uploadType")
  valid_579660 = validateParameter(valid_579660, JString, required = false,
                                 default = nil)
  if valid_579660 != nil:
    section.add "uploadType", valid_579660
  var valid_579661 = query.getOrDefault("quotaUser")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "quotaUser", valid_579661
  var valid_579662 = query.getOrDefault("callback")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = nil)
  if valid_579662 != nil:
    section.add "callback", valid_579662
  var valid_579663 = query.getOrDefault("fields")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "fields", valid_579663
  var valid_579664 = query.getOrDefault("access_token")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "access_token", valid_579664
  var valid_579665 = query.getOrDefault("upload_protocol")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "upload_protocol", valid_579665
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

proc call*(call_579667: Call_HealthcareProjectsLocationsDatasetsDeidentify_579651;
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
  ## Errors are also logged to Stackdriver Logging. For more information,
  ## see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging).
  ## 
  let valid = call_579667.validator(path, query, header, formData, body)
  let scheme = call_579667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579667.url(scheme.get, call_579667.host, call_579667.base,
                         call_579667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579667, url, valid)

proc call*(call_579668: Call_HealthcareProjectsLocationsDatasetsDeidentify_579651;
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
  ## Errors are also logged to Stackdriver Logging. For more information,
  ## see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging).
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
  ##                : Source dataset resource name. For example,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`.
  var path_579669 = newJObject()
  var query_579670 = newJObject()
  var body_579671 = newJObject()
  add(query_579670, "key", newJString(key))
  add(query_579670, "prettyPrint", newJBool(prettyPrint))
  add(query_579670, "oauth_token", newJString(oauthToken))
  add(query_579670, "$.xgafv", newJString(Xgafv))
  add(query_579670, "alt", newJString(alt))
  add(query_579670, "uploadType", newJString(uploadType))
  add(query_579670, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579671 = body
  add(query_579670, "callback", newJString(callback))
  add(query_579670, "fields", newJString(fields))
  add(query_579670, "access_token", newJString(accessToken))
  add(query_579670, "upload_protocol", newJString(uploadProtocol))
  add(path_579669, "sourceDataset", newJString(sourceDataset))
  result = call_579668.call(path_579669, query_579670, nil, nil, body_579671)

var healthcareProjectsLocationsDatasetsDeidentify* = Call_HealthcareProjectsLocationsDatasetsDeidentify_579651(
    name: "healthcareProjectsLocationsDatasetsDeidentify",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{sourceDataset}:deidentify",
    validator: validate_HealthcareProjectsLocationsDatasetsDeidentify_579652,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDeidentify_579653,
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
