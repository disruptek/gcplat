
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Street View Publish
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Publishes 360 photos to Google Maps, along with position, orientation, and connectivity metadata. Apps can offer an interface for positioning, connecting, and uploading user-generated Street View images.
## 
## 
## https://developers.google.com/streetview/publish/
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "streetviewpublish"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StreetviewpublishPhotoCreate_579677 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotoCreate_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoCreate_579678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## After the client finishes uploading the photo with the returned
  ## UploadRef,
  ## CreatePhoto
  ## publishes the uploaded Photo to
  ## Street View on Google Maps.
  ## 
  ## Currently, the only way to set heading, pitch, and roll in CreatePhoto is
  ## through the [Photo Sphere XMP
  ## metadata](https://developers.google.com/streetview/spherical-metadata) in
  ## the photo bytes. CreatePhoto ignores the  `pose.heading`, `pose.pitch`,
  ## `pose.roll`, `pose.altitude`, and `pose.level` fields in Pose.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed or if
  ## the uploaded photo is not a 360 photo.
  ## * google.rpc.Code.NOT_FOUND if the upload reference does not exist.
  ## * google.rpc.Code.RESOURCE_EXHAUSTED if the account has reached the
  ## storage limit.
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("quotaUser")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "quotaUser", valid_579793
  var valid_579807 = query.getOrDefault("alt")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = newJString("json"))
  if valid_579807 != nil:
    section.add "alt", valid_579807
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("callback")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "callback", valid_579809
  var valid_579810 = query.getOrDefault("access_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "access_token", valid_579810
  var valid_579811 = query.getOrDefault("uploadType")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "uploadType", valid_579811
  var valid_579812 = query.getOrDefault("key")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "key", valid_579812
  var valid_579813 = query.getOrDefault("$.xgafv")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = newJString("1"))
  if valid_579813 != nil:
    section.add "$.xgafv", valid_579813
  var valid_579814 = query.getOrDefault("prettyPrint")
  valid_579814 = validateParameter(valid_579814, JBool, required = false,
                                 default = newJBool(true))
  if valid_579814 != nil:
    section.add "prettyPrint", valid_579814
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

proc call*(call_579838: Call_StreetviewpublishPhotoCreate_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## After the client finishes uploading the photo with the returned
  ## UploadRef,
  ## CreatePhoto
  ## publishes the uploaded Photo to
  ## Street View on Google Maps.
  ## 
  ## Currently, the only way to set heading, pitch, and roll in CreatePhoto is
  ## through the [Photo Sphere XMP
  ## metadata](https://developers.google.com/streetview/spherical-metadata) in
  ## the photo bytes. CreatePhoto ignores the  `pose.heading`, `pose.pitch`,
  ## `pose.roll`, `pose.altitude`, and `pose.level` fields in Pose.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed or if
  ## the uploaded photo is not a 360 photo.
  ## * google.rpc.Code.NOT_FOUND if the upload reference does not exist.
  ## * google.rpc.Code.RESOURCE_EXHAUSTED if the account has reached the
  ## storage limit.
  ## 
  let valid = call_579838.validator(path, query, header, formData, body)
  let scheme = call_579838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579838.url(scheme.get, call_579838.host, call_579838.base,
                         call_579838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579838, url, valid)

proc call*(call_579909: Call_StreetviewpublishPhotoCreate_579677;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotoCreate
  ## After the client finishes uploading the photo with the returned
  ## UploadRef,
  ## CreatePhoto
  ## publishes the uploaded Photo to
  ## Street View on Google Maps.
  ## 
  ## Currently, the only way to set heading, pitch, and roll in CreatePhoto is
  ## through the [Photo Sphere XMP
  ## metadata](https://developers.google.com/streetview/spherical-metadata) in
  ## the photo bytes. CreatePhoto ignores the  `pose.heading`, `pose.pitch`,
  ## `pose.roll`, `pose.altitude`, and `pose.level` fields in Pose.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed or if
  ## the uploaded photo is not a 360 photo.
  ## * google.rpc.Code.NOT_FOUND if the upload reference does not exist.
  ## * google.rpc.Code.RESOURCE_EXHAUSTED if the account has reached the
  ## storage limit.
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
  var query_579910 = newJObject()
  var body_579912 = newJObject()
  add(query_579910, "upload_protocol", newJString(uploadProtocol))
  add(query_579910, "fields", newJString(fields))
  add(query_579910, "quotaUser", newJString(quotaUser))
  add(query_579910, "alt", newJString(alt))
  add(query_579910, "oauth_token", newJString(oauthToken))
  add(query_579910, "callback", newJString(callback))
  add(query_579910, "access_token", newJString(accessToken))
  add(query_579910, "uploadType", newJString(uploadType))
  add(query_579910, "key", newJString(key))
  add(query_579910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579912 = body
  add(query_579910, "prettyPrint", newJBool(prettyPrint))
  result = call_579909.call(nil, query_579910, nil, nil, body_579912)

var streetviewpublishPhotoCreate* = Call_StreetviewpublishPhotoCreate_579677(
    name: "streetviewpublishPhotoCreate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo",
    validator: validate_StreetviewpublishPhotoCreate_579678, base: "/",
    url: url_StreetviewpublishPhotoCreate_579679, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoUpdate_579951 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotoUpdate_579953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoUpdate_579952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the metadata of a Photo, such
  ## as pose, place association, connections, etc. Changing the pixels of a
  ## photo is not supported.
  ## 
  ## Only the fields specified in the
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed.
  ## * google.rpc.Code.NOT_FOUND if the requested photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Required. A unique identifier for a photo.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579968 = path.getOrDefault("id")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "id", valid_579968
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
  ##             : Required. Mask that identifies fields on the photo metadata to update.
  ## If not present, the old Photo
  ## metadata is entirely replaced with the
  ## new Photo metadata in this request.
  ## The update fails if invalid fields are specified. Multiple fields can be
  ## specified in a comma-delimited list.
  ## 
  ## The following fields are valid:
  ## 
  ## * `pose.heading`
  ## * `pose.latLngPair`
  ## * `pose.pitch`
  ## * `pose.roll`
  ## * `pose.level`
  ## * `pose.altitude`
  ## * `connections`
  ## * `places`
  ## 
  ## 
  ## <aside class="note"><b>Note:</b> When
  ## updateMask
  ## contains repeated fields, the entire set of repeated values get replaced
  ## with the new contents. For example, if
  ## updateMask
  ## contains `connections` and `UpdatePhotoRequest.photo.connections` is empty,
  ## all connections are removed.</aside>
  section = newJObject()
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  var valid_579980 = query.getOrDefault("updateMask")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "updateMask", valid_579980
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

proc call*(call_579982: Call_StreetviewpublishPhotoUpdate_579951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the metadata of a Photo, such
  ## as pose, place association, connections, etc. Changing the pixels of a
  ## photo is not supported.
  ## 
  ## Only the fields specified in the
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed.
  ## * google.rpc.Code.NOT_FOUND if the requested photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_StreetviewpublishPhotoUpdate_579951; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## streetviewpublishPhotoUpdate
  ## Updates the metadata of a Photo, such
  ## as pose, place association, connections, etc. Changing the pixels of a
  ## photo is not supported.
  ## 
  ## Only the fields specified in the
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.INVALID_ARGUMENT if the request is malformed.
  ## * google.rpc.Code.NOT_FOUND if the requested photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
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
  ##   id: string (required)
  ##     : Required. A unique identifier for a photo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required. Mask that identifies fields on the photo metadata to update.
  ## If not present, the old Photo
  ## metadata is entirely replaced with the
  ## new Photo metadata in this request.
  ## The update fails if invalid fields are specified. Multiple fields can be
  ## specified in a comma-delimited list.
  ## 
  ## The following fields are valid:
  ## 
  ## * `pose.heading`
  ## * `pose.latLngPair`
  ## * `pose.pitch`
  ## * `pose.roll`
  ## * `pose.level`
  ## * `pose.altitude`
  ## * `connections`
  ## * `places`
  ## 
  ## 
  ## <aside class="note"><b>Note:</b> When
  ## updateMask
  ## contains repeated fields, the entire set of repeated values get replaced
  ## with the new contents. For example, if
  ## updateMask
  ## contains `connections` and `UpdatePhotoRequest.photo.connections` is empty,
  ## all connections are removed.</aside>
  var path_579984 = newJObject()
  var query_579985 = newJObject()
  var body_579986 = newJObject()
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "uploadType", newJString(uploadType))
  add(path_579984, "id", newJString(id))
  add(query_579985, "key", newJString(key))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579986 = body
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "updateMask", newJString(updateMask))
  result = call_579983.call(path_579984, query_579985, nil, nil, body_579986)

var streetviewpublishPhotoUpdate* = Call_StreetviewpublishPhotoUpdate_579951(
    name: "streetviewpublishPhotoUpdate", meth: HttpMethod.HttpPut,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{id}",
    validator: validate_StreetviewpublishPhotoUpdate_579952, base: "/",
    url: url_StreetviewpublishPhotoUpdate_579953, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoGet_579987 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotoGet_579989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "photoId" in path, "`photoId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "photoId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoGet_579988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metadata of the specified
  ## Photo.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested Photo.
  ## * google.rpc.Code.NOT_FOUND if the requested
  ## Photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   photoId: JString (required)
  ##          : Required. ID of the Photo.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `photoId` field"
  var valid_579990 = path.getOrDefault("photoId")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "photoId", valid_579990
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
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
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579991 = query.getOrDefault("upload_protocol")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "upload_protocol", valid_579991
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  var valid_579993 = query.getOrDefault("view")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579993 != nil:
    section.add "view", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("oauth_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "oauth_token", valid_579996
  var valid_579997 = query.getOrDefault("callback")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "callback", valid_579997
  var valid_579998 = query.getOrDefault("access_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "access_token", valid_579998
  var valid_579999 = query.getOrDefault("uploadType")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "uploadType", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("$.xgafv")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("1"))
  if valid_580001 != nil:
    section.add "$.xgafv", valid_580001
  var valid_580002 = query.getOrDefault("languageCode")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "languageCode", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_StreetviewpublishPhotoGet_579987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metadata of the specified
  ## Photo.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested Photo.
  ## * google.rpc.Code.NOT_FOUND if the requested
  ## Photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_StreetviewpublishPhotoGet_579987; photoId: string;
          uploadProtocol: string = ""; fields: string = ""; view: string = "BASIC";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotoGet
  ## Gets the metadata of the specified
  ## Photo.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested Photo.
  ## * google.rpc.Code.NOT_FOUND if the requested
  ## Photo does not exist.
  ## * google.rpc.Code.UNAVAILABLE if the requested
  ## Photo is still being indexed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   photoId: string (required)
  ##          : Required. ID of the Photo.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
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
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "upload_protocol", newJString(uploadProtocol))
  add(path_580006, "photoId", newJString(photoId))
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "view", newJString(view))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "callback", newJString(callback))
  add(query_580007, "access_token", newJString(accessToken))
  add(query_580007, "uploadType", newJString(uploadType))
  add(query_580007, "key", newJString(key))
  add(query_580007, "$.xgafv", newJString(Xgafv))
  add(query_580007, "languageCode", newJString(languageCode))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var streetviewpublishPhotoGet* = Call_StreetviewpublishPhotoGet_579987(
    name: "streetviewpublishPhotoGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoGet_579988, base: "/",
    url: url_StreetviewpublishPhotoGet_579989, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoDelete_580008 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotoDelete_580010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "photoId" in path, "`photoId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/photo/"),
               (kind: VariableSegment, value: "photoId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreetviewpublishPhotoDelete_580009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   photoId: JString (required)
  ##          : Required. ID of the Photo.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `photoId` field"
  var valid_580011 = path.getOrDefault("photoId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "photoId", valid_580011
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
  var valid_580012 = query.getOrDefault("upload_protocol")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "upload_protocol", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_StreetviewpublishPhotoDelete_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_StreetviewpublishPhotoDelete_580008; photoId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotoDelete
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   photoId: string (required)
  ##          : Required. ID of the Photo.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(path_580025, "photoId", newJString(photoId))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "key", newJString(key))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580024.call(path_580025, query_580026, nil, nil, nil)

var streetviewpublishPhotoDelete* = Call_StreetviewpublishPhotoDelete_580008(
    name: "streetviewpublishPhotoDelete", meth: HttpMethod.HttpDelete,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoDelete_580009, base: "/",
    url: url_StreetviewpublishPhotoDelete_580010, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoStartUpload_580027 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotoStartUpload_580029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoStartUpload_580028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an upload session to start uploading photo bytes.  The method uses
  ## the upload URL of the returned
  ## UploadRef to upload the bytes for
  ## the Photo.
  ## 
  ## In addition to the photo requirements shown in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604,
  ## the photo must meet the following requirements:
  ## 
  ## * Photo Sphere XMP metadata must be included in the photo medadata. See
  ## https://developers.google.com/streetview/spherical-metadata for the
  ## required fields.
  ## * The pixel size of the photo must meet the size requirements listed in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604, and
  ## the photo must be a full 360 horizontally.
  ## 
  ## After the upload completes, the method uses
  ## UploadRef with
  ## CreatePhoto
  ## to create the Photo object entry.
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
  var valid_580030 = query.getOrDefault("upload_protocol")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "upload_protocol", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("callback")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "callback", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("$.xgafv")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("1"))
  if valid_580039 != nil:
    section.add "$.xgafv", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
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

proc call*(call_580042: Call_StreetviewpublishPhotoStartUpload_580027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an upload session to start uploading photo bytes.  The method uses
  ## the upload URL of the returned
  ## UploadRef to upload the bytes for
  ## the Photo.
  ## 
  ## In addition to the photo requirements shown in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604,
  ## the photo must meet the following requirements:
  ## 
  ## * Photo Sphere XMP metadata must be included in the photo medadata. See
  ## https://developers.google.com/streetview/spherical-metadata for the
  ## required fields.
  ## * The pixel size of the photo must meet the size requirements listed in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604, and
  ## the photo must be a full 360 horizontally.
  ## 
  ## After the upload completes, the method uses
  ## UploadRef with
  ## CreatePhoto
  ## to create the Photo object entry.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_StreetviewpublishPhotoStartUpload_580027;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotoStartUpload
  ## Creates an upload session to start uploading photo bytes.  The method uses
  ## the upload URL of the returned
  ## UploadRef to upload the bytes for
  ## the Photo.
  ## 
  ## In addition to the photo requirements shown in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604,
  ## the photo must meet the following requirements:
  ## 
  ## * Photo Sphere XMP metadata must be included in the photo medadata. See
  ## https://developers.google.com/streetview/spherical-metadata for the
  ## required fields.
  ## * The pixel size of the photo must meet the size requirements listed in
  ## https://support.google.com/maps/answer/7012050?hl=en&ref_topic=6275604, and
  ## the photo must be a full 360 horizontally.
  ## 
  ## After the upload completes, the method uses
  ## UploadRef with
  ## CreatePhoto
  ## to create the Photo object entry.
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
  var query_580044 = newJObject()
  var body_580045 = newJObject()
  add(query_580044, "upload_protocol", newJString(uploadProtocol))
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "callback", newJString(callback))
  add(query_580044, "access_token", newJString(accessToken))
  add(query_580044, "uploadType", newJString(uploadType))
  add(query_580044, "key", newJString(key))
  add(query_580044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580045 = body
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  result = call_580043.call(nil, query_580044, nil, nil, body_580045)

var streetviewpublishPhotoStartUpload* = Call_StreetviewpublishPhotoStartUpload_580027(
    name: "streetviewpublishPhotoStartUpload", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo:startUpload",
    validator: validate_StreetviewpublishPhotoStartUpload_580028, base: "/",
    url: url_StreetviewpublishPhotoStartUpload_580029, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosList_580046 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotosList_580048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosList_580047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
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
  ##            : The
  ## nextPageToken
  ## value returned from a previous
  ## ListPhotos
  ## request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photos bytes should be returned in the
  ## Photos response.
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
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   pageSize: JInt
  ##           : The maximum number of photos to return.
  ## `pageSize` must be non-negative. If `pageSize` is zero or is not provided,
  ## the default page size of 100 is used.
  ## The number of photos returned in the response may be less than `pageSize`
  ## if the number of photos that belong to the user is less than `pageSize`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Required. The filter expression. For example: `placeId=ChIJj61dQgK6j4AR4GeTYWZsKWw`.
  ## 
  ## The only filter supported at the moment is `placeId`.
  section = newJObject()
  var valid_580049 = query.getOrDefault("upload_protocol")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "upload_protocol", valid_580049
  var valid_580050 = query.getOrDefault("fields")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "fields", valid_580050
  var valid_580051 = query.getOrDefault("pageToken")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "pageToken", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("view")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580053 != nil:
    section.add "view", valid_580053
  var valid_580054 = query.getOrDefault("alt")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("json"))
  if valid_580054 != nil:
    section.add "alt", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("callback")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "callback", valid_580056
  var valid_580057 = query.getOrDefault("access_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "access_token", valid_580057
  var valid_580058 = query.getOrDefault("uploadType")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "uploadType", valid_580058
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("$.xgafv")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("1"))
  if valid_580060 != nil:
    section.add "$.xgafv", valid_580060
  var valid_580061 = query.getOrDefault("languageCode")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "languageCode", valid_580061
  var valid_580062 = query.getOrDefault("pageSize")
  valid_580062 = validateParameter(valid_580062, JInt, required = false, default = nil)
  if valid_580062 != nil:
    section.add "pageSize", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
  var valid_580064 = query.getOrDefault("filter")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "filter", valid_580064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580065: Call_StreetviewpublishPhotosList_580046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_StreetviewpublishPhotosList_580046;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "BASIC"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## streetviewpublishPhotosList
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The
  ## nextPageToken
  ## value returned from a previous
  ## ListPhotos
  ## request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Required. Specifies if a download URL for the photos bytes should be returned in the
  ## Photos response.
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
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   pageSize: int
  ##           : The maximum number of photos to return.
  ## `pageSize` must be non-negative. If `pageSize` is zero or is not provided,
  ## the default page size of 100 is used.
  ## The number of photos returned in the response may be less than `pageSize`
  ## if the number of photos that belong to the user is less than `pageSize`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Required. The filter expression. For example: `placeId=ChIJj61dQgK6j4AR4GeTYWZsKWw`.
  ## 
  ## The only filter supported at the moment is `placeId`.
  var query_580067 = newJObject()
  add(query_580067, "upload_protocol", newJString(uploadProtocol))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "pageToken", newJString(pageToken))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "view", newJString(view))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "callback", newJString(callback))
  add(query_580067, "access_token", newJString(accessToken))
  add(query_580067, "uploadType", newJString(uploadType))
  add(query_580067, "key", newJString(key))
  add(query_580067, "$.xgafv", newJString(Xgafv))
  add(query_580067, "languageCode", newJString(languageCode))
  add(query_580067, "pageSize", newJInt(pageSize))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  add(query_580067, "filter", newJString(filter))
  result = call_580066.call(nil, query_580067, nil, nil, nil)

var streetviewpublishPhotosList* = Call_StreetviewpublishPhotosList_580046(
    name: "streetviewpublishPhotosList", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos",
    validator: validate_StreetviewpublishPhotosList_580047, base: "/",
    url: url_StreetviewpublishPhotosList_580048, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchDelete_580068 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotosBatchDelete_580070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchDelete_580069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a list of Photos and their
  ## metadata.
  ## 
  ## Note that if
  ## BatchDeletePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchDeletePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchDeletePhotosResponse.results.
  ## See
  ## DeletePhoto
  ## for specific failures that can occur per photo.
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
  var valid_580071 = query.getOrDefault("upload_protocol")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "upload_protocol", valid_580071
  var valid_580072 = query.getOrDefault("fields")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "fields", valid_580072
  var valid_580073 = query.getOrDefault("quotaUser")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "quotaUser", valid_580073
  var valid_580074 = query.getOrDefault("alt")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("json"))
  if valid_580074 != nil:
    section.add "alt", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("callback")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "callback", valid_580076
  var valid_580077 = query.getOrDefault("access_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "access_token", valid_580077
  var valid_580078 = query.getOrDefault("uploadType")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "uploadType", valid_580078
  var valid_580079 = query.getOrDefault("key")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "key", valid_580079
  var valid_580080 = query.getOrDefault("$.xgafv")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("1"))
  if valid_580080 != nil:
    section.add "$.xgafv", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
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

proc call*(call_580083: Call_StreetviewpublishPhotosBatchDelete_580068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a list of Photos and their
  ## metadata.
  ## 
  ## Note that if
  ## BatchDeletePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchDeletePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchDeletePhotosResponse.results.
  ## See
  ## DeletePhoto
  ## for specific failures that can occur per photo.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_StreetviewpublishPhotosBatchDelete_580068;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotosBatchDelete
  ## Deletes a list of Photos and their
  ## metadata.
  ## 
  ## Note that if
  ## BatchDeletePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchDeletePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchDeletePhotosResponse.results.
  ## See
  ## DeletePhoto
  ## for specific failures that can occur per photo.
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
  var query_580085 = newJObject()
  var body_580086 = newJObject()
  add(query_580085, "upload_protocol", newJString(uploadProtocol))
  add(query_580085, "fields", newJString(fields))
  add(query_580085, "quotaUser", newJString(quotaUser))
  add(query_580085, "alt", newJString(alt))
  add(query_580085, "oauth_token", newJString(oauthToken))
  add(query_580085, "callback", newJString(callback))
  add(query_580085, "access_token", newJString(accessToken))
  add(query_580085, "uploadType", newJString(uploadType))
  add(query_580085, "key", newJString(key))
  add(query_580085, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580086 = body
  add(query_580085, "prettyPrint", newJBool(prettyPrint))
  result = call_580084.call(nil, query_580085, nil, nil, body_580086)

var streetviewpublishPhotosBatchDelete* = Call_StreetviewpublishPhotosBatchDelete_580068(
    name: "streetviewpublishPhotosBatchDelete", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchDelete",
    validator: validate_StreetviewpublishPhotosBatchDelete_580069, base: "/",
    url: url_StreetviewpublishPhotosBatchDelete_580070, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchGet_580087 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotosBatchGet_580089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchGet_580088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metadata of the specified
  ## Photo batch.
  ## 
  ## Note that if
  ## BatchGetPhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchGetPhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchGetPhotosResponse.results.
  ## See
  ## GetPhoto
  ## for specific failures that can occur per photo.
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
  ##   view: JString
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
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
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   photoIds: JArray
  ##           : Required. IDs of the Photos. For HTTP
  ## GET requests, the URL query parameter should be
  ## `photoIds=<id1>&photoIds=<id2>&...`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580090 = query.getOrDefault("upload_protocol")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "upload_protocol", valid_580090
  var valid_580091 = query.getOrDefault("fields")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "fields", valid_580091
  var valid_580092 = query.getOrDefault("view")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580092 != nil:
    section.add "view", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("oauth_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "oauth_token", valid_580095
  var valid_580096 = query.getOrDefault("callback")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "callback", valid_580096
  var valid_580097 = query.getOrDefault("access_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "access_token", valid_580097
  var valid_580098 = query.getOrDefault("uploadType")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "uploadType", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("$.xgafv")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("1"))
  if valid_580100 != nil:
    section.add "$.xgafv", valid_580100
  var valid_580101 = query.getOrDefault("languageCode")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "languageCode", valid_580101
  var valid_580102 = query.getOrDefault("photoIds")
  valid_580102 = validateParameter(valid_580102, JArray, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "photoIds", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580104: Call_StreetviewpublishPhotosBatchGet_580087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the metadata of the specified
  ## Photo batch.
  ## 
  ## Note that if
  ## BatchGetPhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchGetPhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchGetPhotosResponse.results.
  ## See
  ## GetPhoto
  ## for specific failures that can occur per photo.
  ## 
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_StreetviewpublishPhotosBatchGet_580087;
          uploadProtocol: string = ""; fields: string = ""; view: string = "BASIC";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          photoIds: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotosBatchGet
  ## Gets the metadata of the specified
  ## Photo batch.
  ## 
  ## Note that if
  ## BatchGetPhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchGetPhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchGetPhotosResponse.results.
  ## See
  ## GetPhoto
  ## for specific failures that can occur per photo.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Required. Specifies if a download URL for the photo bytes should be returned in the
  ## Photo response.
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
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". For more
  ## information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## If language_code is unspecified, the user's language preference for Google
  ## services is used.
  ##   photoIds: JArray
  ##           : Required. IDs of the Photos. For HTTP
  ## GET requests, the URL query parameter should be
  ## `photoIds=<id1>&photoIds=<id2>&...`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580106 = newJObject()
  add(query_580106, "upload_protocol", newJString(uploadProtocol))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "view", newJString(view))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "callback", newJString(callback))
  add(query_580106, "access_token", newJString(accessToken))
  add(query_580106, "uploadType", newJString(uploadType))
  add(query_580106, "key", newJString(key))
  add(query_580106, "$.xgafv", newJString(Xgafv))
  add(query_580106, "languageCode", newJString(languageCode))
  if photoIds != nil:
    query_580106.add "photoIds", photoIds
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  result = call_580105.call(nil, query_580106, nil, nil, nil)

var streetviewpublishPhotosBatchGet* = Call_StreetviewpublishPhotosBatchGet_580087(
    name: "streetviewpublishPhotosBatchGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchGet",
    validator: validate_StreetviewpublishPhotosBatchGet_580088, base: "/",
    url: url_StreetviewpublishPhotosBatchGet_580089, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchUpdate_580107 = ref object of OpenApiRestCall_579408
proc url_StreetviewpublishPhotosBatchUpdate_580109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchUpdate_580108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the metadata of Photos, such
  ## as pose, place association, connections, etc. Changing the pixels of photos
  ## is not supported.
  ## 
  ## Note that if
  ## BatchUpdatePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchUpdatePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchUpdatePhotosResponse.results.
  ## See
  ## UpdatePhoto
  ## for specific failures that can occur per photo.
  ## 
  ## Only the fields specified in
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## The number of
  ## UpdatePhotoRequest
  ## messages in a
  ## BatchUpdatePhotosRequest
  ## must not exceed 20.
  ## 
  ## <aside class="note"><b>Note:</b> To update
  ## Pose.altitude,
  ## Pose.latLngPair has to be
  ## filled as well. Otherwise, the request will fail.</aside>
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
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("callback")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "callback", valid_580115
  var valid_580116 = query.getOrDefault("access_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "access_token", valid_580116
  var valid_580117 = query.getOrDefault("uploadType")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "uploadType", valid_580117
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("$.xgafv")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("1"))
  if valid_580119 != nil:
    section.add "$.xgafv", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
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

proc call*(call_580122: Call_StreetviewpublishPhotosBatchUpdate_580107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the metadata of Photos, such
  ## as pose, place association, connections, etc. Changing the pixels of photos
  ## is not supported.
  ## 
  ## Note that if
  ## BatchUpdatePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchUpdatePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchUpdatePhotosResponse.results.
  ## See
  ## UpdatePhoto
  ## for specific failures that can occur per photo.
  ## 
  ## Only the fields specified in
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## The number of
  ## UpdatePhotoRequest
  ## messages in a
  ## BatchUpdatePhotosRequest
  ## must not exceed 20.
  ## 
  ## <aside class="note"><b>Note:</b> To update
  ## Pose.altitude,
  ## Pose.latLngPair has to be
  ## filled as well. Otherwise, the request will fail.</aside>
  ## 
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_StreetviewpublishPhotosBatchUpdate_580107;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## streetviewpublishPhotosBatchUpdate
  ## Updates the metadata of Photos, such
  ## as pose, place association, connections, etc. Changing the pixels of photos
  ## is not supported.
  ## 
  ## Note that if
  ## BatchUpdatePhotos
  ## fails, either critical fields are missing or there is an authentication
  ## error. Even if
  ## BatchUpdatePhotos
  ## succeeds, individual photos in the batch may have failures.
  ## These failures are specified in each
  ## PhotoResponse.status
  ## in
  ## BatchUpdatePhotosResponse.results.
  ## See
  ## UpdatePhoto
  ## for specific failures that can occur per photo.
  ## 
  ## Only the fields specified in
  ## updateMask
  ## field are used. If `updateMask` is not present, the update applies to all
  ## fields.
  ## 
  ## The number of
  ## UpdatePhotoRequest
  ## messages in a
  ## BatchUpdatePhotosRequest
  ## must not exceed 20.
  ## 
  ## <aside class="note"><b>Note:</b> To update
  ## Pose.altitude,
  ## Pose.latLngPair has to be
  ## filled as well. Otherwise, the request will fail.</aside>
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
  var query_580124 = newJObject()
  var body_580125 = newJObject()
  add(query_580124, "upload_protocol", newJString(uploadProtocol))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "callback", newJString(callback))
  add(query_580124, "access_token", newJString(accessToken))
  add(query_580124, "uploadType", newJString(uploadType))
  add(query_580124, "key", newJString(key))
  add(query_580124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580125 = body
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  result = call_580123.call(nil, query_580124, nil, nil, body_580125)

var streetviewpublishPhotosBatchUpdate* = Call_StreetviewpublishPhotosBatchUpdate_580107(
    name: "streetviewpublishPhotosBatchUpdate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchUpdate",
    validator: validate_StreetviewpublishPhotosBatchUpdate_580108, base: "/",
    url: url_StreetviewpublishPhotosBatchUpdate_580109, schemes: {Scheme.Https})
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
