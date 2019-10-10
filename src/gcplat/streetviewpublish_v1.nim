
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
  gcpServiceName = "streetviewpublish"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StreetviewpublishPhotoCreate_588710 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotoCreate_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoCreate_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("quotaUser")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "quotaUser", valid_588826
  var valid_588840 = query.getOrDefault("alt")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = newJString("json"))
  if valid_588840 != nil:
    section.add "alt", valid_588840
  var valid_588841 = query.getOrDefault("oauth_token")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "oauth_token", valid_588841
  var valid_588842 = query.getOrDefault("callback")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "callback", valid_588842
  var valid_588843 = query.getOrDefault("access_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "access_token", valid_588843
  var valid_588844 = query.getOrDefault("uploadType")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "uploadType", valid_588844
  var valid_588845 = query.getOrDefault("key")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "key", valid_588845
  var valid_588846 = query.getOrDefault("$.xgafv")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = newJString("1"))
  if valid_588846 != nil:
    section.add "$.xgafv", valid_588846
  var valid_588847 = query.getOrDefault("prettyPrint")
  valid_588847 = validateParameter(valid_588847, JBool, required = false,
                                 default = newJBool(true))
  if valid_588847 != nil:
    section.add "prettyPrint", valid_588847
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

proc call*(call_588871: Call_StreetviewpublishPhotoCreate_588710; path: JsonNode;
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
  let valid = call_588871.validator(path, query, header, formData, body)
  let scheme = call_588871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588871.url(scheme.get, call_588871.host, call_588871.base,
                         call_588871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588871, url, valid)

proc call*(call_588942: Call_StreetviewpublishPhotoCreate_588710;
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
  var query_588943 = newJObject()
  var body_588945 = newJObject()
  add(query_588943, "upload_protocol", newJString(uploadProtocol))
  add(query_588943, "fields", newJString(fields))
  add(query_588943, "quotaUser", newJString(quotaUser))
  add(query_588943, "alt", newJString(alt))
  add(query_588943, "oauth_token", newJString(oauthToken))
  add(query_588943, "callback", newJString(callback))
  add(query_588943, "access_token", newJString(accessToken))
  add(query_588943, "uploadType", newJString(uploadType))
  add(query_588943, "key", newJString(key))
  add(query_588943, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588945 = body
  add(query_588943, "prettyPrint", newJBool(prettyPrint))
  result = call_588942.call(nil, query_588943, nil, nil, body_588945)

var streetviewpublishPhotoCreate* = Call_StreetviewpublishPhotoCreate_588710(
    name: "streetviewpublishPhotoCreate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo",
    validator: validate_StreetviewpublishPhotoCreate_588711, base: "/",
    url: url_StreetviewpublishPhotoCreate_588712, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoUpdate_588984 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotoUpdate_588986(protocol: Scheme; host: string;
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

proc validate_StreetviewpublishPhotoUpdate_588985(path: JsonNode; query: JsonNode;
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
  var valid_589001 = path.getOrDefault("id")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "id", valid_589001
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
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  var valid_589013 = query.getOrDefault("updateMask")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "updateMask", valid_589013
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

proc call*(call_589015: Call_StreetviewpublishPhotoUpdate_588984; path: JsonNode;
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
  let valid = call_589015.validator(path, query, header, formData, body)
  let scheme = call_589015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589015.url(scheme.get, call_589015.host, call_589015.base,
                         call_589015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589015, url, valid)

proc call*(call_589016: Call_StreetviewpublishPhotoUpdate_588984; id: string;
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
  var path_589017 = newJObject()
  var query_589018 = newJObject()
  var body_589019 = newJObject()
  add(query_589018, "upload_protocol", newJString(uploadProtocol))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "callback", newJString(callback))
  add(query_589018, "access_token", newJString(accessToken))
  add(query_589018, "uploadType", newJString(uploadType))
  add(path_589017, "id", newJString(id))
  add(query_589018, "key", newJString(key))
  add(query_589018, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589019 = body
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  add(query_589018, "updateMask", newJString(updateMask))
  result = call_589016.call(path_589017, query_589018, nil, nil, body_589019)

var streetviewpublishPhotoUpdate* = Call_StreetviewpublishPhotoUpdate_588984(
    name: "streetviewpublishPhotoUpdate", meth: HttpMethod.HttpPut,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{id}",
    validator: validate_StreetviewpublishPhotoUpdate_588985, base: "/",
    url: url_StreetviewpublishPhotoUpdate_588986, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoGet_589020 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotoGet_589022(protocol: Scheme; host: string;
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

proc validate_StreetviewpublishPhotoGet_589021(path: JsonNode; query: JsonNode;
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
  var valid_589023 = path.getOrDefault("photoId")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "photoId", valid_589023
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
  var valid_589024 = query.getOrDefault("upload_protocol")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "upload_protocol", valid_589024
  var valid_589025 = query.getOrDefault("fields")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "fields", valid_589025
  var valid_589026 = query.getOrDefault("view")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589026 != nil:
    section.add "view", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("callback")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "callback", valid_589030
  var valid_589031 = query.getOrDefault("access_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "access_token", valid_589031
  var valid_589032 = query.getOrDefault("uploadType")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "uploadType", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("$.xgafv")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("1"))
  if valid_589034 != nil:
    section.add "$.xgafv", valid_589034
  var valid_589035 = query.getOrDefault("languageCode")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "languageCode", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_StreetviewpublishPhotoGet_589020; path: JsonNode;
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
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_StreetviewpublishPhotoGet_589020; photoId: string;
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
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  add(query_589040, "upload_protocol", newJString(uploadProtocol))
  add(path_589039, "photoId", newJString(photoId))
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "view", newJString(view))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "callback", newJString(callback))
  add(query_589040, "access_token", newJString(accessToken))
  add(query_589040, "uploadType", newJString(uploadType))
  add(query_589040, "key", newJString(key))
  add(query_589040, "$.xgafv", newJString(Xgafv))
  add(query_589040, "languageCode", newJString(languageCode))
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(path_589039, query_589040, nil, nil, nil)

var streetviewpublishPhotoGet* = Call_StreetviewpublishPhotoGet_589020(
    name: "streetviewpublishPhotoGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoGet_589021, base: "/",
    url: url_StreetviewpublishPhotoGet_589022, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoDelete_589041 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotoDelete_589043(protocol: Scheme; host: string;
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

proc validate_StreetviewpublishPhotoDelete_589042(path: JsonNode; query: JsonNode;
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
  var valid_589044 = path.getOrDefault("photoId")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "photoId", valid_589044
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
  var valid_589045 = query.getOrDefault("upload_protocol")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "upload_protocol", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
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
  if body != nil:
    result.add "body", body

proc call*(call_589056: Call_StreetviewpublishPhotoDelete_589041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Photo and its metadata.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * google.rpc.Code.PERMISSION_DENIED if the requesting user did not
  ## create the requested photo.
  ## * google.rpc.Code.NOT_FOUND if the photo ID does not exist.
  ## 
  let valid = call_589056.validator(path, query, header, formData, body)
  let scheme = call_589056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589056.url(scheme.get, call_589056.host, call_589056.base,
                         call_589056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589056, url, valid)

proc call*(call_589057: Call_StreetviewpublishPhotoDelete_589041; photoId: string;
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
  var path_589058 = newJObject()
  var query_589059 = newJObject()
  add(query_589059, "upload_protocol", newJString(uploadProtocol))
  add(path_589058, "photoId", newJString(photoId))
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "callback", newJString(callback))
  add(query_589059, "access_token", newJString(accessToken))
  add(query_589059, "uploadType", newJString(uploadType))
  add(query_589059, "key", newJString(key))
  add(query_589059, "$.xgafv", newJString(Xgafv))
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589057.call(path_589058, query_589059, nil, nil, nil)

var streetviewpublishPhotoDelete* = Call_StreetviewpublishPhotoDelete_589041(
    name: "streetviewpublishPhotoDelete", meth: HttpMethod.HttpDelete,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo/{photoId}",
    validator: validate_StreetviewpublishPhotoDelete_589042, base: "/",
    url: url_StreetviewpublishPhotoDelete_589043, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotoStartUpload_589060 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotoStartUpload_589062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotoStartUpload_589061(path: JsonNode;
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
  var valid_589063 = query.getOrDefault("upload_protocol")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "upload_protocol", valid_589063
  var valid_589064 = query.getOrDefault("fields")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "fields", valid_589064
  var valid_589065 = query.getOrDefault("quotaUser")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "quotaUser", valid_589065
  var valid_589066 = query.getOrDefault("alt")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("json"))
  if valid_589066 != nil:
    section.add "alt", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("callback")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "callback", valid_589068
  var valid_589069 = query.getOrDefault("access_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "access_token", valid_589069
  var valid_589070 = query.getOrDefault("uploadType")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "uploadType", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("$.xgafv")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("1"))
  if valid_589072 != nil:
    section.add "$.xgafv", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
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

proc call*(call_589075: Call_StreetviewpublishPhotoStartUpload_589060;
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
  let valid = call_589075.validator(path, query, header, formData, body)
  let scheme = call_589075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589075.url(scheme.get, call_589075.host, call_589075.base,
                         call_589075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589075, url, valid)

proc call*(call_589076: Call_StreetviewpublishPhotoStartUpload_589060;
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
  var query_589077 = newJObject()
  var body_589078 = newJObject()
  add(query_589077, "upload_protocol", newJString(uploadProtocol))
  add(query_589077, "fields", newJString(fields))
  add(query_589077, "quotaUser", newJString(quotaUser))
  add(query_589077, "alt", newJString(alt))
  add(query_589077, "oauth_token", newJString(oauthToken))
  add(query_589077, "callback", newJString(callback))
  add(query_589077, "access_token", newJString(accessToken))
  add(query_589077, "uploadType", newJString(uploadType))
  add(query_589077, "key", newJString(key))
  add(query_589077, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589078 = body
  add(query_589077, "prettyPrint", newJBool(prettyPrint))
  result = call_589076.call(nil, query_589077, nil, nil, body_589078)

var streetviewpublishPhotoStartUpload* = Call_StreetviewpublishPhotoStartUpload_589060(
    name: "streetviewpublishPhotoStartUpload", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photo:startUpload",
    validator: validate_StreetviewpublishPhotoStartUpload_589061, base: "/",
    url: url_StreetviewpublishPhotoStartUpload_589062, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosList_589079 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotosList_589081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosList_589080(path: JsonNode; query: JsonNode;
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
  var valid_589082 = query.getOrDefault("upload_protocol")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "upload_protocol", valid_589082
  var valid_589083 = query.getOrDefault("fields")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "fields", valid_589083
  var valid_589084 = query.getOrDefault("pageToken")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "pageToken", valid_589084
  var valid_589085 = query.getOrDefault("quotaUser")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "quotaUser", valid_589085
  var valid_589086 = query.getOrDefault("view")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589086 != nil:
    section.add "view", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("callback")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "callback", valid_589089
  var valid_589090 = query.getOrDefault("access_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "access_token", valid_589090
  var valid_589091 = query.getOrDefault("uploadType")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "uploadType", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("$.xgafv")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("1"))
  if valid_589093 != nil:
    section.add "$.xgafv", valid_589093
  var valid_589094 = query.getOrDefault("languageCode")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "languageCode", valid_589094
  var valid_589095 = query.getOrDefault("pageSize")
  valid_589095 = validateParameter(valid_589095, JInt, required = false, default = nil)
  if valid_589095 != nil:
    section.add "pageSize", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  var valid_589097 = query.getOrDefault("filter")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "filter", valid_589097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589098: Call_StreetviewpublishPhotosList_589079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Photos that belong to
  ## the user.
  ## 
  ## <aside class="note"><b>Note:</b> Recently created photos that are still
  ## being indexed are not returned in the response.</aside>
  ## 
  let valid = call_589098.validator(path, query, header, formData, body)
  let scheme = call_589098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589098.url(scheme.get, call_589098.host, call_589098.base,
                         call_589098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589098, url, valid)

proc call*(call_589099: Call_StreetviewpublishPhotosList_589079;
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
  var query_589100 = newJObject()
  add(query_589100, "upload_protocol", newJString(uploadProtocol))
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "pageToken", newJString(pageToken))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(query_589100, "view", newJString(view))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(query_589100, "callback", newJString(callback))
  add(query_589100, "access_token", newJString(accessToken))
  add(query_589100, "uploadType", newJString(uploadType))
  add(query_589100, "key", newJString(key))
  add(query_589100, "$.xgafv", newJString(Xgafv))
  add(query_589100, "languageCode", newJString(languageCode))
  add(query_589100, "pageSize", newJInt(pageSize))
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  add(query_589100, "filter", newJString(filter))
  result = call_589099.call(nil, query_589100, nil, nil, nil)

var streetviewpublishPhotosList* = Call_StreetviewpublishPhotosList_589079(
    name: "streetviewpublishPhotosList", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos",
    validator: validate_StreetviewpublishPhotosList_589080, base: "/",
    url: url_StreetviewpublishPhotosList_589081, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchDelete_589101 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotosBatchDelete_589103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchDelete_589102(path: JsonNode;
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
  var valid_589104 = query.getOrDefault("upload_protocol")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "upload_protocol", valid_589104
  var valid_589105 = query.getOrDefault("fields")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "fields", valid_589105
  var valid_589106 = query.getOrDefault("quotaUser")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "quotaUser", valid_589106
  var valid_589107 = query.getOrDefault("alt")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("json"))
  if valid_589107 != nil:
    section.add "alt", valid_589107
  var valid_589108 = query.getOrDefault("oauth_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "oauth_token", valid_589108
  var valid_589109 = query.getOrDefault("callback")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "callback", valid_589109
  var valid_589110 = query.getOrDefault("access_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "access_token", valid_589110
  var valid_589111 = query.getOrDefault("uploadType")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "uploadType", valid_589111
  var valid_589112 = query.getOrDefault("key")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "key", valid_589112
  var valid_589113 = query.getOrDefault("$.xgafv")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("1"))
  if valid_589113 != nil:
    section.add "$.xgafv", valid_589113
  var valid_589114 = query.getOrDefault("prettyPrint")
  valid_589114 = validateParameter(valid_589114, JBool, required = false,
                                 default = newJBool(true))
  if valid_589114 != nil:
    section.add "prettyPrint", valid_589114
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

proc call*(call_589116: Call_StreetviewpublishPhotosBatchDelete_589101;
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
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_StreetviewpublishPhotosBatchDelete_589101;
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
  var query_589118 = newJObject()
  var body_589119 = newJObject()
  add(query_589118, "upload_protocol", newJString(uploadProtocol))
  add(query_589118, "fields", newJString(fields))
  add(query_589118, "quotaUser", newJString(quotaUser))
  add(query_589118, "alt", newJString(alt))
  add(query_589118, "oauth_token", newJString(oauthToken))
  add(query_589118, "callback", newJString(callback))
  add(query_589118, "access_token", newJString(accessToken))
  add(query_589118, "uploadType", newJString(uploadType))
  add(query_589118, "key", newJString(key))
  add(query_589118, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589119 = body
  add(query_589118, "prettyPrint", newJBool(prettyPrint))
  result = call_589117.call(nil, query_589118, nil, nil, body_589119)

var streetviewpublishPhotosBatchDelete* = Call_StreetviewpublishPhotosBatchDelete_589101(
    name: "streetviewpublishPhotosBatchDelete", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchDelete",
    validator: validate_StreetviewpublishPhotosBatchDelete_589102, base: "/",
    url: url_StreetviewpublishPhotosBatchDelete_589103, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchGet_589120 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotosBatchGet_589122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchGet_589121(path: JsonNode;
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
  var valid_589123 = query.getOrDefault("upload_protocol")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "upload_protocol", valid_589123
  var valid_589124 = query.getOrDefault("fields")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "fields", valid_589124
  var valid_589125 = query.getOrDefault("view")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589125 != nil:
    section.add "view", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("oauth_token")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "oauth_token", valid_589128
  var valid_589129 = query.getOrDefault("callback")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "callback", valid_589129
  var valid_589130 = query.getOrDefault("access_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "access_token", valid_589130
  var valid_589131 = query.getOrDefault("uploadType")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "uploadType", valid_589131
  var valid_589132 = query.getOrDefault("key")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "key", valid_589132
  var valid_589133 = query.getOrDefault("$.xgafv")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("1"))
  if valid_589133 != nil:
    section.add "$.xgafv", valid_589133
  var valid_589134 = query.getOrDefault("languageCode")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "languageCode", valid_589134
  var valid_589135 = query.getOrDefault("photoIds")
  valid_589135 = validateParameter(valid_589135, JArray, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "photoIds", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589137: Call_StreetviewpublishPhotosBatchGet_589120;
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
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_StreetviewpublishPhotosBatchGet_589120;
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
  var query_589139 = newJObject()
  add(query_589139, "upload_protocol", newJString(uploadProtocol))
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "view", newJString(view))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(query_589139, "callback", newJString(callback))
  add(query_589139, "access_token", newJString(accessToken))
  add(query_589139, "uploadType", newJString(uploadType))
  add(query_589139, "key", newJString(key))
  add(query_589139, "$.xgafv", newJString(Xgafv))
  add(query_589139, "languageCode", newJString(languageCode))
  if photoIds != nil:
    query_589139.add "photoIds", photoIds
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(nil, query_589139, nil, nil, nil)

var streetviewpublishPhotosBatchGet* = Call_StreetviewpublishPhotosBatchGet_589120(
    name: "streetviewpublishPhotosBatchGet", meth: HttpMethod.HttpGet,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchGet",
    validator: validate_StreetviewpublishPhotosBatchGet_589121, base: "/",
    url: url_StreetviewpublishPhotosBatchGet_589122, schemes: {Scheme.Https})
type
  Call_StreetviewpublishPhotosBatchUpdate_589140 = ref object of OpenApiRestCall_588441
proc url_StreetviewpublishPhotosBatchUpdate_589142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StreetviewpublishPhotosBatchUpdate_589141(path: JsonNode;
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
  var valid_589143 = query.getOrDefault("upload_protocol")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "upload_protocol", valid_589143
  var valid_589144 = query.getOrDefault("fields")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "fields", valid_589144
  var valid_589145 = query.getOrDefault("quotaUser")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "quotaUser", valid_589145
  var valid_589146 = query.getOrDefault("alt")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("json"))
  if valid_589146 != nil:
    section.add "alt", valid_589146
  var valid_589147 = query.getOrDefault("oauth_token")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "oauth_token", valid_589147
  var valid_589148 = query.getOrDefault("callback")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "callback", valid_589148
  var valid_589149 = query.getOrDefault("access_token")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "access_token", valid_589149
  var valid_589150 = query.getOrDefault("uploadType")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "uploadType", valid_589150
  var valid_589151 = query.getOrDefault("key")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "key", valid_589151
  var valid_589152 = query.getOrDefault("$.xgafv")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = newJString("1"))
  if valid_589152 != nil:
    section.add "$.xgafv", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
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

proc call*(call_589155: Call_StreetviewpublishPhotosBatchUpdate_589140;
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
  let valid = call_589155.validator(path, query, header, formData, body)
  let scheme = call_589155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589155.url(scheme.get, call_589155.host, call_589155.base,
                         call_589155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589155, url, valid)

proc call*(call_589156: Call_StreetviewpublishPhotosBatchUpdate_589140;
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
  var query_589157 = newJObject()
  var body_589158 = newJObject()
  add(query_589157, "upload_protocol", newJString(uploadProtocol))
  add(query_589157, "fields", newJString(fields))
  add(query_589157, "quotaUser", newJString(quotaUser))
  add(query_589157, "alt", newJString(alt))
  add(query_589157, "oauth_token", newJString(oauthToken))
  add(query_589157, "callback", newJString(callback))
  add(query_589157, "access_token", newJString(accessToken))
  add(query_589157, "uploadType", newJString(uploadType))
  add(query_589157, "key", newJString(key))
  add(query_589157, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589158 = body
  add(query_589157, "prettyPrint", newJBool(prettyPrint))
  result = call_589156.call(nil, query_589157, nil, nil, body_589158)

var streetviewpublishPhotosBatchUpdate* = Call_StreetviewpublishPhotosBatchUpdate_589140(
    name: "streetviewpublishPhotosBatchUpdate", meth: HttpMethod.HttpPost,
    host: "streetviewpublish.googleapis.com", route: "/v1/photos:batchUpdate",
    validator: validate_StreetviewpublishPhotosBatchUpdate_589141, base: "/",
    url: url_StreetviewpublishPhotosBatchUpdate_589142, schemes: {Scheme.Https})
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
