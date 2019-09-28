
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Private Catalog Producer
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enables cloud users to manage and share enterprise catalogs intheir organizations.
## 
## https://cloud.google.com/private-catalog/
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
  gcpServiceName = "cloudprivatecatalogproducer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogproducerCatalogsCreate_579952 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsCreate_579954(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsCreate_579953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Catalog resource.
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
  var valid_579955 = query.getOrDefault("upload_protocol")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "upload_protocol", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("quotaUser")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "quotaUser", valid_579957
  var valid_579958 = query.getOrDefault("alt")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("json"))
  if valid_579958 != nil:
    section.add "alt", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("callback")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "callback", valid_579960
  var valid_579961 = query.getOrDefault("access_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "access_token", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("key")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "key", valid_579963
  var valid_579964 = query.getOrDefault("$.xgafv")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("1"))
  if valid_579964 != nil:
    section.add "$.xgafv", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
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

proc call*(call_579967: Call_CloudprivatecatalogproducerCatalogsCreate_579952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Catalog resource.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_CloudprivatecatalogproducerCatalogsCreate_579952;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsCreate
  ## Creates a new Catalog resource.
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
  var query_579969 = newJObject()
  var body_579970 = newJObject()
  add(query_579969, "upload_protocol", newJString(uploadProtocol))
  add(query_579969, "fields", newJString(fields))
  add(query_579969, "quotaUser", newJString(quotaUser))
  add(query_579969, "alt", newJString(alt))
  add(query_579969, "oauth_token", newJString(oauthToken))
  add(query_579969, "callback", newJString(callback))
  add(query_579969, "access_token", newJString(accessToken))
  add(query_579969, "uploadType", newJString(uploadType))
  add(query_579969, "key", newJString(key))
  add(query_579969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579970 = body
  add(query_579969, "prettyPrint", newJBool(prettyPrint))
  result = call_579968.call(nil, query_579969, nil, nil, body_579970)

var cloudprivatecatalogproducerCatalogsCreate* = Call_CloudprivatecatalogproducerCatalogsCreate_579952(
    name: "cloudprivatecatalogproducerCatalogsCreate", meth: HttpMethod.HttpPost,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsCreate_579953,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsCreate_579954,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsList_579677 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsList_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsList_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
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
  ##            : A pagination token returned from a previous call to ListCatalogs
  ## that indicates where this listing should continue from.
  ## This field is optional.
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
  ##   parent: JString
  ##         : The resource name of the parent resource.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of catalogs to return.
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
  var valid_579793 = query.getOrDefault("pageToken")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "pageToken", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("oauth_token")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "oauth_token", valid_579809
  var valid_579810 = query.getOrDefault("callback")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "callback", valid_579810
  var valid_579811 = query.getOrDefault("access_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "access_token", valid_579811
  var valid_579812 = query.getOrDefault("uploadType")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "uploadType", valid_579812
  var valid_579813 = query.getOrDefault("parent")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "parent", valid_579813
  var valid_579814 = query.getOrDefault("key")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "key", valid_579814
  var valid_579815 = query.getOrDefault("$.xgafv")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = newJString("1"))
  if valid_579815 != nil:
    section.add "$.xgafv", valid_579815
  var valid_579816 = query.getOrDefault("pageSize")
  valid_579816 = validateParameter(valid_579816, JInt, required = false, default = nil)
  if valid_579816 != nil:
    section.add "pageSize", valid_579816
  var valid_579817 = query.getOrDefault("prettyPrint")
  valid_579817 = validateParameter(valid_579817, JBool, required = false,
                                 default = newJBool(true))
  if valid_579817 != nil:
    section.add "prettyPrint", valid_579817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579840: Call_CloudprivatecatalogproducerCatalogsList_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ## 
  let valid = call_579840.validator(path, query, header, formData, body)
  let scheme = call_579840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579840.url(scheme.get, call_579840.host, call_579840.base,
                         call_579840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579840, url, valid)

proc call*(call_579911: Call_CloudprivatecatalogproducerCatalogsList_579677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsList
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListCatalogs
  ## that indicates where this listing should continue from.
  ## This field is optional.
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
  ##   parent: string
  ##         : The resource name of the parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of catalogs to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579912 = newJObject()
  add(query_579912, "upload_protocol", newJString(uploadProtocol))
  add(query_579912, "fields", newJString(fields))
  add(query_579912, "pageToken", newJString(pageToken))
  add(query_579912, "quotaUser", newJString(quotaUser))
  add(query_579912, "alt", newJString(alt))
  add(query_579912, "oauth_token", newJString(oauthToken))
  add(query_579912, "callback", newJString(callback))
  add(query_579912, "access_token", newJString(accessToken))
  add(query_579912, "uploadType", newJString(uploadType))
  add(query_579912, "parent", newJString(parent))
  add(query_579912, "key", newJString(key))
  add(query_579912, "$.xgafv", newJString(Xgafv))
  add(query_579912, "pageSize", newJInt(pageSize))
  add(query_579912, "prettyPrint", newJBool(prettyPrint))
  result = call_579911.call(nil, query_579912, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsList* = Call_CloudprivatecatalogproducerCatalogsList_579677(
    name: "cloudprivatecatalogproducerCatalogsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsList_579678, base: "/",
    url: url_CloudprivatecatalogproducerCatalogsList_579679,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsList_579971 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerOperationsList_579973(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerOperationsList_579972(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   name: JString
  ##       : The name of the operation's parent resource.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_579974 = query.getOrDefault("upload_protocol")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "upload_protocol", valid_579974
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
  var valid_579976 = query.getOrDefault("pageToken")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "pageToken", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("callback")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "callback", valid_579980
  var valid_579981 = query.getOrDefault("access_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "access_token", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("key")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "key", valid_579983
  var valid_579984 = query.getOrDefault("name")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "name", valid_579984
  var valid_579985 = query.getOrDefault("$.xgafv")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("1"))
  if valid_579985 != nil:
    section.add "$.xgafv", valid_579985
  var valid_579986 = query.getOrDefault("pageSize")
  valid_579986 = validateParameter(valid_579986, JInt, required = false, default = nil)
  if valid_579986 != nil:
    section.add "pageSize", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
  var valid_579988 = query.getOrDefault("filter")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "filter", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_CloudprivatecatalogproducerOperationsList_579971;
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
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_CloudprivatecatalogproducerOperationsList_579971;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudprivatecatalogproducerOperationsList
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
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
  ##   name: string
  ##       : The name of the operation's parent resource.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var query_579991 = newJObject()
  add(query_579991, "upload_protocol", newJString(uploadProtocol))
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "pageToken", newJString(pageToken))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "callback", newJString(callback))
  add(query_579991, "access_token", newJString(accessToken))
  add(query_579991, "uploadType", newJString(uploadType))
  add(query_579991, "key", newJString(key))
  add(query_579991, "name", newJString(name))
  add(query_579991, "$.xgafv", newJString(Xgafv))
  add(query_579991, "pageSize", newJInt(pageSize))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  add(query_579991, "filter", newJString(filter))
  result = call_579990.call(nil, query_579991, nil, nil, nil)

var cloudprivatecatalogproducerOperationsList* = Call_CloudprivatecatalogproducerOperationsList_579971(
    name: "cloudprivatecatalogproducerOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/operations",
    validator: validate_CloudprivatecatalogproducerOperationsList_579972,
    base: "/", url: url_CloudprivatecatalogproducerOperationsList_579973,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsGet_579992 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerOperationsGet_579994(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudprivatecatalogproducerOperationsGet_579993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580009 = path.getOrDefault("name")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "name", valid_580009
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
  var valid_580010 = query.getOrDefault("upload_protocol")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "upload_protocol", valid_580010
  var valid_580011 = query.getOrDefault("fields")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "fields", valid_580011
  var valid_580012 = query.getOrDefault("quotaUser")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "quotaUser", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("callback")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "callback", valid_580015
  var valid_580016 = query.getOrDefault("access_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "access_token", valid_580016
  var valid_580017 = query.getOrDefault("uploadType")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "uploadType", valid_580017
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("$.xgafv")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("1"))
  if valid_580019 != nil:
    section.add "$.xgafv", valid_580019
  var valid_580020 = query.getOrDefault("prettyPrint")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "prettyPrint", valid_580020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580021: Call_CloudprivatecatalogproducerOperationsGet_579992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580021.validator(path, query, header, formData, body)
  let scheme = call_580021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580021.url(scheme.get, call_580021.host, call_580021.base,
                         call_580021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580021, url, valid)

proc call*(call_580022: Call_CloudprivatecatalogproducerOperationsGet_579992;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_580023 = newJObject()
  var query_580024 = newJObject()
  add(query_580024, "upload_protocol", newJString(uploadProtocol))
  add(query_580024, "fields", newJString(fields))
  add(query_580024, "quotaUser", newJString(quotaUser))
  add(path_580023, "name", newJString(name))
  add(query_580024, "alt", newJString(alt))
  add(query_580024, "oauth_token", newJString(oauthToken))
  add(query_580024, "callback", newJString(callback))
  add(query_580024, "access_token", newJString(accessToken))
  add(query_580024, "uploadType", newJString(uploadType))
  add(query_580024, "key", newJString(key))
  add(query_580024, "$.xgafv", newJString(Xgafv))
  add(query_580024, "prettyPrint", newJBool(prettyPrint))
  result = call_580022.call(path_580023, query_580024, nil, nil, nil)

var cloudprivatecatalogproducerOperationsGet* = Call_CloudprivatecatalogproducerOperationsGet_579992(
    name: "cloudprivatecatalogproducerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerOperationsGet_579993,
    base: "/", url: url_CloudprivatecatalogproducerOperationsGet_579994,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580045 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580047(
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

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580046(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a specific Version resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the version, in the format
  ## `catalogs/{catalog_id}/products/{product_id}/versions/a-z*[a-z0-9]'.
  ## 
  ## A unique identifier for the version under a product, which can't
  ## be changed after the version is created. The final segment of the name must
  ## between 1 and 63 characters in length.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580048 = path.getOrDefault("name")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "name", valid_580048
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
  ##             : Field mask that controls which fields of the version should be updated.
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
  var valid_580051 = query.getOrDefault("quotaUser")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "quotaUser", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("oauth_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "oauth_token", valid_580053
  var valid_580054 = query.getOrDefault("callback")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "callback", valid_580054
  var valid_580055 = query.getOrDefault("access_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "access_token", valid_580055
  var valid_580056 = query.getOrDefault("uploadType")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "uploadType", valid_580056
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("$.xgafv")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("1"))
  if valid_580058 != nil:
    section.add "$.xgafv", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  var valid_580060 = query.getOrDefault("updateMask")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "updateMask", valid_580060
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

proc call*(call_580062: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a specific Version resource.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580045;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsPatch
  ## Updates a specific Version resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the version, in the format
  ## `catalogs/{catalog_id}/products/{product_id}/versions/a-z*[a-z0-9]'.
  ## 
  ## A unique identifier for the version under a product, which can't
  ## be changed after the version is created. The final segment of the name must
  ## between 1 and 63 characters in length.
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
  ##             : Field mask that controls which fields of the version should be updated.
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  var body_580066 = newJObject()
  add(query_580065, "upload_protocol", newJString(uploadProtocol))
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(path_580064, "name", newJString(name))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "callback", newJString(callback))
  add(query_580065, "access_token", newJString(accessToken))
  add(query_580065, "uploadType", newJString(uploadType))
  add(query_580065, "key", newJString(key))
  add(query_580065, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580066 = body
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "updateMask", newJString(updateMask))
  result = call_580063.call(path_580064, query_580065, nil, nil, body_580066)

var cloudprivatecatalogproducerCatalogsProductsVersionsPatch* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580045(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsPatch",
    meth: HttpMethod.HttpPatch,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580046,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580047,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsDelete_580025 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerOperationsDelete_580027(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudprivatecatalogproducerOperationsDelete_580026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580028 = path.getOrDefault("name")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "name", valid_580028
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: JBool
  ##        : Forces deletion of the `Catalog` and its `Association` resources.
  ## If the `Catalog` is still associated with other resources and
  ## force is not set to true, then the operation fails.
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
  var valid_580029 = query.getOrDefault("upload_protocol")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "upload_protocol", valid_580029
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("force")
  valid_580031 = validateParameter(valid_580031, JBool, required = false, default = nil)
  if valid_580031 != nil:
    section.add "force", valid_580031
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
  if body != nil:
    result.add "body", body

proc call*(call_580041: Call_CloudprivatecatalogproducerOperationsDelete_580025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_CloudprivatecatalogproducerOperationsDelete_580025;
          name: string; uploadProtocol: string = ""; fields: string = "";
          force: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: bool
  ##        : Forces deletion of the `Catalog` and its `Association` resources.
  ## If the `Catalog` is still associated with other resources and
  ## force is not set to true, then the operation fails.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  add(query_580044, "upload_protocol", newJString(uploadProtocol))
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "force", newJBool(force))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(path_580043, "name", newJString(name))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "callback", newJString(callback))
  add(query_580044, "access_token", newJString(accessToken))
  add(query_580044, "uploadType", newJString(uploadType))
  add(query_580044, "key", newJString(key))
  add(query_580044, "$.xgafv", newJString(Xgafv))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  result = call_580042.call(path_580043, query_580044, nil, nil, nil)

var cloudprivatecatalogproducerOperationsDelete* = Call_CloudprivatecatalogproducerOperationsDelete_580025(
    name: "cloudprivatecatalogproducerOperationsDelete",
    meth: HttpMethod.HttpDelete,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerOperationsDelete_580026,
    base: "/", url: url_CloudprivatecatalogproducerOperationsDelete_580027,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsCancel_580067 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerOperationsCancel_580069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerOperationsCancel_580068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580070 = path.getOrDefault("name")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "name", valid_580070
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

proc call*(call_580083: Call_CloudprivatecatalogproducerOperationsCancel_580067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_CloudprivatecatalogproducerOperationsCancel_580067;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  var body_580087 = newJObject()
  add(query_580086, "upload_protocol", newJString(uploadProtocol))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(path_580085, "name", newJString(name))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "callback", newJString(callback))
  add(query_580086, "access_token", newJString(accessToken))
  add(query_580086, "uploadType", newJString(uploadType))
  add(query_580086, "key", newJString(key))
  add(query_580086, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580087 = body
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  result = call_580084.call(path_580085, query_580086, nil, nil, body_580087)

var cloudprivatecatalogproducerOperationsCancel* = Call_CloudprivatecatalogproducerOperationsCancel_580067(
    name: "cloudprivatecatalogproducerOperationsCancel",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_CloudprivatecatalogproducerOperationsCancel_580068,
    base: "/", url: url_CloudprivatecatalogproducerOperationsCancel_580069,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCopy_580088 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsProductsCopy_580090(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":copy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCopy_580089(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Copies a Product under another Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the current product that is copied from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580091 = path.getOrDefault("name")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "name", valid_580091
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
  var valid_580092 = query.getOrDefault("upload_protocol")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "upload_protocol", valid_580092
  var valid_580093 = query.getOrDefault("fields")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "fields", valid_580093
  var valid_580094 = query.getOrDefault("quotaUser")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "quotaUser", valid_580094
  var valid_580095 = query.getOrDefault("alt")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("json"))
  if valid_580095 != nil:
    section.add "alt", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("callback")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "callback", valid_580097
  var valid_580098 = query.getOrDefault("access_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "access_token", valid_580098
  var valid_580099 = query.getOrDefault("uploadType")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "uploadType", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("$.xgafv")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("1"))
  if valid_580101 != nil:
    section.add "$.xgafv", valid_580101
  var valid_580102 = query.getOrDefault("prettyPrint")
  valid_580102 = validateParameter(valid_580102, JBool, required = false,
                                 default = newJBool(true))
  if valid_580102 != nil:
    section.add "prettyPrint", valid_580102
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

proc call*(call_580104: Call_CloudprivatecatalogproducerCatalogsProductsCopy_580088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Copies a Product under another Catalog.
  ## 
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_CloudprivatecatalogproducerCatalogsProductsCopy_580088;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsCopy
  ## Copies a Product under another Catalog.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the current product that is copied from.
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
  var path_580106 = newJObject()
  var query_580107 = newJObject()
  var body_580108 = newJObject()
  add(query_580107, "upload_protocol", newJString(uploadProtocol))
  add(query_580107, "fields", newJString(fields))
  add(query_580107, "quotaUser", newJString(quotaUser))
  add(path_580106, "name", newJString(name))
  add(query_580107, "alt", newJString(alt))
  add(query_580107, "oauth_token", newJString(oauthToken))
  add(query_580107, "callback", newJString(callback))
  add(query_580107, "access_token", newJString(accessToken))
  add(query_580107, "uploadType", newJString(uploadType))
  add(query_580107, "key", newJString(key))
  add(query_580107, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580108 = body
  add(query_580107, "prettyPrint", newJBool(prettyPrint))
  result = call_580105.call(path_580106, query_580107, nil, nil, body_580108)

var cloudprivatecatalogproducerCatalogsProductsCopy* = Call_CloudprivatecatalogproducerCatalogsProductsCopy_580088(
    name: "cloudprivatecatalogproducerCatalogsProductsCopy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:copy",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCopy_580089,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCopy_580090,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsUndelete_580109 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsUndelete_580111(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsUndelete_580110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the catalog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580112 = path.getOrDefault("name")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "name", valid_580112
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
  var valid_580113 = query.getOrDefault("upload_protocol")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "upload_protocol", valid_580113
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("callback")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "callback", valid_580118
  var valid_580119 = query.getOrDefault("access_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "access_token", valid_580119
  var valid_580120 = query.getOrDefault("uploadType")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "uploadType", valid_580120
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("$.xgafv")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("1"))
  if valid_580122 != nil:
    section.add "$.xgafv", valid_580122
  var valid_580123 = query.getOrDefault("prettyPrint")
  valid_580123 = validateParameter(valid_580123, JBool, required = false,
                                 default = newJBool(true))
  if valid_580123 != nil:
    section.add "prettyPrint", valid_580123
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

proc call*(call_580125: Call_CloudprivatecatalogproducerCatalogsUndelete_580109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_CloudprivatecatalogproducerCatalogsUndelete_580109;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsUndelete
  ## Undeletes a deleted Catalog and all resources under it.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the catalog.
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
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  var body_580129 = newJObject()
  add(query_580128, "upload_protocol", newJString(uploadProtocol))
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(path_580127, "name", newJString(name))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "callback", newJString(callback))
  add(query_580128, "access_token", newJString(accessToken))
  add(query_580128, "uploadType", newJString(uploadType))
  add(query_580128, "key", newJString(key))
  add(query_580128, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580129 = body
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  result = call_580126.call(path_580127, query_580128, nil, nil, body_580129)

var cloudprivatecatalogproducerCatalogsUndelete* = Call_CloudprivatecatalogproducerCatalogsUndelete_580109(
    name: "cloudprivatecatalogproducerCatalogsUndelete",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:undelete",
    validator: validate_CloudprivatecatalogproducerCatalogsUndelete_580110,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsUndelete_580111,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580151 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsAssociationsCreate_580153(
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
               (kind: ConstantSegment, value: "/associations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_580152(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an Association instance under a given Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The `Catalog` resource's name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580154 = path.getOrDefault("parent")
  valid_580154 = validateParameter(valid_580154, JString, required = true,
                                 default = nil)
  if valid_580154 != nil:
    section.add "parent", valid_580154
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
  var valid_580155 = query.getOrDefault("upload_protocol")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "upload_protocol", valid_580155
  var valid_580156 = query.getOrDefault("fields")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "fields", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("oauth_token")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "oauth_token", valid_580159
  var valid_580160 = query.getOrDefault("callback")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "callback", valid_580160
  var valid_580161 = query.getOrDefault("access_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "access_token", valid_580161
  var valid_580162 = query.getOrDefault("uploadType")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "uploadType", valid_580162
  var valid_580163 = query.getOrDefault("key")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "key", valid_580163
  var valid_580164 = query.getOrDefault("$.xgafv")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("1"))
  if valid_580164 != nil:
    section.add "$.xgafv", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
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

proc call*(call_580167: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Association instance under a given Catalog.
  ## 
  let valid = call_580167.validator(path, query, header, formData, body)
  let scheme = call_580167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580167.url(scheme.get, call_580167.host, call_580167.base,
                         call_580167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580167, url, valid)

proc call*(call_580168: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580151;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsAssociationsCreate
  ## Creates an Association instance under a given Catalog.
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
  ##         : The `Catalog` resource's name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580169 = newJObject()
  var query_580170 = newJObject()
  var body_580171 = newJObject()
  add(query_580170, "upload_protocol", newJString(uploadProtocol))
  add(query_580170, "fields", newJString(fields))
  add(query_580170, "quotaUser", newJString(quotaUser))
  add(query_580170, "alt", newJString(alt))
  add(query_580170, "oauth_token", newJString(oauthToken))
  add(query_580170, "callback", newJString(callback))
  add(query_580170, "access_token", newJString(accessToken))
  add(query_580170, "uploadType", newJString(uploadType))
  add(path_580169, "parent", newJString(parent))
  add(query_580170, "key", newJString(key))
  add(query_580170, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580171 = body
  add(query_580170, "prettyPrint", newJBool(prettyPrint))
  result = call_580168.call(path_580169, query_580170, nil, nil, body_580171)

var cloudprivatecatalogproducerCatalogsAssociationsCreate* = Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580151(
    name: "cloudprivatecatalogproducerCatalogsAssociationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_580152,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsCreate_580153,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsList_580130 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsAssociationsList_580132(
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
               (kind: ConstantSegment, value: "/associations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsList_580131(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all Association resources under a catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the `Catalog` whose `Associations` are
  ## being retrieved. In the format `catalogs/<catalog>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580133 = path.getOrDefault("parent")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "parent", valid_580133
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from the previous call to
  ## `ListAssociations`.
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
  ##           : The maximum number of catalog associations to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580134 = query.getOrDefault("upload_protocol")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "upload_protocol", valid_580134
  var valid_580135 = query.getOrDefault("fields")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "fields", valid_580135
  var valid_580136 = query.getOrDefault("pageToken")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "pageToken", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("alt")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("json"))
  if valid_580138 != nil:
    section.add "alt", valid_580138
  var valid_580139 = query.getOrDefault("oauth_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "oauth_token", valid_580139
  var valid_580140 = query.getOrDefault("callback")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "callback", valid_580140
  var valid_580141 = query.getOrDefault("access_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "access_token", valid_580141
  var valid_580142 = query.getOrDefault("uploadType")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "uploadType", valid_580142
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("$.xgafv")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("1"))
  if valid_580144 != nil:
    section.add "$.xgafv", valid_580144
  var valid_580145 = query.getOrDefault("pageSize")
  valid_580145 = validateParameter(valid_580145, JInt, required = false, default = nil)
  if valid_580145 != nil:
    section.add "pageSize", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580147: Call_CloudprivatecatalogproducerCatalogsAssociationsList_580130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Association resources under a catalog.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_CloudprivatecatalogproducerCatalogsAssociationsList_580130;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsAssociationsList
  ## Lists all Association resources under a catalog.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from the previous call to
  ## `ListAssociations`.
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
  ##         : The resource name of the `Catalog` whose `Associations` are
  ## being retrieved. In the format `catalogs/<catalog>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of catalog associations to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  add(query_580150, "upload_protocol", newJString(uploadProtocol))
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "pageToken", newJString(pageToken))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "callback", newJString(callback))
  add(query_580150, "access_token", newJString(accessToken))
  add(query_580150, "uploadType", newJString(uploadType))
  add(path_580149, "parent", newJString(parent))
  add(query_580150, "key", newJString(key))
  add(query_580150, "$.xgafv", newJString(Xgafv))
  add(query_580150, "pageSize", newJInt(pageSize))
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  result = call_580148.call(path_580149, query_580150, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsAssociationsList* = Call_CloudprivatecatalogproducerCatalogsAssociationsList_580130(
    name: "cloudprivatecatalogproducerCatalogsAssociationsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsList_580131,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsList_580132,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCreate_580194 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsProductsCreate_580196(
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
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCreate_580195(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a Product instance under a given Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The catalog name of the new product's parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580197 = path.getOrDefault("parent")
  valid_580197 = validateParameter(valid_580197, JString, required = true,
                                 default = nil)
  if valid_580197 != nil:
    section.add "parent", valid_580197
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
  var valid_580198 = query.getOrDefault("upload_protocol")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "upload_protocol", valid_580198
  var valid_580199 = query.getOrDefault("fields")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "fields", valid_580199
  var valid_580200 = query.getOrDefault("quotaUser")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "quotaUser", valid_580200
  var valid_580201 = query.getOrDefault("alt")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = newJString("json"))
  if valid_580201 != nil:
    section.add "alt", valid_580201
  var valid_580202 = query.getOrDefault("oauth_token")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "oauth_token", valid_580202
  var valid_580203 = query.getOrDefault("callback")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "callback", valid_580203
  var valid_580204 = query.getOrDefault("access_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "access_token", valid_580204
  var valid_580205 = query.getOrDefault("uploadType")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "uploadType", valid_580205
  var valid_580206 = query.getOrDefault("key")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "key", valid_580206
  var valid_580207 = query.getOrDefault("$.xgafv")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("1"))
  if valid_580207 != nil:
    section.add "$.xgafv", valid_580207
  var valid_580208 = query.getOrDefault("prettyPrint")
  valid_580208 = validateParameter(valid_580208, JBool, required = false,
                                 default = newJBool(true))
  if valid_580208 != nil:
    section.add "prettyPrint", valid_580208
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

proc call*(call_580210: Call_CloudprivatecatalogproducerCatalogsProductsCreate_580194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Product instance under a given Catalog.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_CloudprivatecatalogproducerCatalogsProductsCreate_580194;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsCreate
  ## Creates a Product instance under a given Catalog.
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
  ##         : The catalog name of the new product's parent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  var body_580214 = newJObject()
  add(query_580213, "upload_protocol", newJString(uploadProtocol))
  add(query_580213, "fields", newJString(fields))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(query_580213, "callback", newJString(callback))
  add(query_580213, "access_token", newJString(accessToken))
  add(query_580213, "uploadType", newJString(uploadType))
  add(path_580212, "parent", newJString(parent))
  add(query_580213, "key", newJString(key))
  add(query_580213, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580214 = body
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  result = call_580211.call(path_580212, query_580213, nil, nil, body_580214)

var cloudprivatecatalogproducerCatalogsProductsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsCreate_580194(
    name: "cloudprivatecatalogproducerCatalogsProductsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCreate_580195,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCreate_580196,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsList_580172 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsProductsList_580174(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsList_580173(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580175 = path.getOrDefault("parent")
  valid_580175 = validateParameter(valid_580175, JString, required = true,
                                 default = nil)
  if valid_580175 != nil:
    section.add "parent", valid_580175
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListProducts
  ## that indicates where this listing should continue from.
  ## This field is optional.
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
  ##           : The maximum number of products to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression used to restrict the returned results based
  ## upon properties of the product.
  section = newJObject()
  var valid_580176 = query.getOrDefault("upload_protocol")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "upload_protocol", valid_580176
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
  var valid_580178 = query.getOrDefault("pageToken")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "pageToken", valid_580178
  var valid_580179 = query.getOrDefault("quotaUser")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "quotaUser", valid_580179
  var valid_580180 = query.getOrDefault("alt")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("json"))
  if valid_580180 != nil:
    section.add "alt", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("callback")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "callback", valid_580182
  var valid_580183 = query.getOrDefault("access_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "access_token", valid_580183
  var valid_580184 = query.getOrDefault("uploadType")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "uploadType", valid_580184
  var valid_580185 = query.getOrDefault("key")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "key", valid_580185
  var valid_580186 = query.getOrDefault("$.xgafv")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("1"))
  if valid_580186 != nil:
    section.add "$.xgafv", valid_580186
  var valid_580187 = query.getOrDefault("pageSize")
  valid_580187 = validateParameter(valid_580187, JInt, required = false, default = nil)
  if valid_580187 != nil:
    section.add "pageSize", valid_580187
  var valid_580188 = query.getOrDefault("prettyPrint")
  valid_580188 = validateParameter(valid_580188, JBool, required = false,
                                 default = newJBool(true))
  if valid_580188 != nil:
    section.add "prettyPrint", valid_580188
  var valid_580189 = query.getOrDefault("filter")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "filter", valid_580189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580190: Call_CloudprivatecatalogproducerCatalogsProductsList_580172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  let valid = call_580190.validator(path, query, header, formData, body)
  let scheme = call_580190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580190.url(scheme.get, call_580190.host, call_580190.base,
                         call_580190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580190, url, valid)

proc call*(call_580191: Call_CloudprivatecatalogproducerCatalogsProductsList_580172;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsList
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListProducts
  ## that indicates where this listing should continue from.
  ## This field is optional.
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
  ##         : The resource name of the parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of products to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression used to restrict the returned results based
  ## upon properties of the product.
  var path_580192 = newJObject()
  var query_580193 = newJObject()
  add(query_580193, "upload_protocol", newJString(uploadProtocol))
  add(query_580193, "fields", newJString(fields))
  add(query_580193, "pageToken", newJString(pageToken))
  add(query_580193, "quotaUser", newJString(quotaUser))
  add(query_580193, "alt", newJString(alt))
  add(query_580193, "oauth_token", newJString(oauthToken))
  add(query_580193, "callback", newJString(callback))
  add(query_580193, "access_token", newJString(accessToken))
  add(query_580193, "uploadType", newJString(uploadType))
  add(path_580192, "parent", newJString(parent))
  add(query_580193, "key", newJString(key))
  add(query_580193, "$.xgafv", newJString(Xgafv))
  add(query_580193, "pageSize", newJInt(pageSize))
  add(query_580193, "prettyPrint", newJBool(prettyPrint))
  add(query_580193, "filter", newJString(filter))
  result = call_580191.call(path_580192, query_580193, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsList* = Call_CloudprivatecatalogproducerCatalogsProductsList_580172(
    name: "cloudprivatecatalogproducerCatalogsProductsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsList_580173,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsList_580174,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580236 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580238(
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
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580237(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a Version instance under a given Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The product name of the new version's parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580239 = path.getOrDefault("parent")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "parent", valid_580239
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
  var valid_580240 = query.getOrDefault("upload_protocol")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "upload_protocol", valid_580240
  var valid_580241 = query.getOrDefault("fields")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "fields", valid_580241
  var valid_580242 = query.getOrDefault("quotaUser")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "quotaUser", valid_580242
  var valid_580243 = query.getOrDefault("alt")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("json"))
  if valid_580243 != nil:
    section.add "alt", valid_580243
  var valid_580244 = query.getOrDefault("oauth_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "oauth_token", valid_580244
  var valid_580245 = query.getOrDefault("callback")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "callback", valid_580245
  var valid_580246 = query.getOrDefault("access_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "access_token", valid_580246
  var valid_580247 = query.getOrDefault("uploadType")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "uploadType", valid_580247
  var valid_580248 = query.getOrDefault("key")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "key", valid_580248
  var valid_580249 = query.getOrDefault("$.xgafv")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("1"))
  if valid_580249 != nil:
    section.add "$.xgafv", valid_580249
  var valid_580250 = query.getOrDefault("prettyPrint")
  valid_580250 = validateParameter(valid_580250, JBool, required = false,
                                 default = newJBool(true))
  if valid_580250 != nil:
    section.add "prettyPrint", valid_580250
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

proc call*(call_580252: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Version instance under a given Product.
  ## 
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580236;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsCreate
  ## Creates a Version instance under a given Product.
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
  ##         : The product name of the new version's parent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580254 = newJObject()
  var query_580255 = newJObject()
  var body_580256 = newJObject()
  add(query_580255, "upload_protocol", newJString(uploadProtocol))
  add(query_580255, "fields", newJString(fields))
  add(query_580255, "quotaUser", newJString(quotaUser))
  add(query_580255, "alt", newJString(alt))
  add(query_580255, "oauth_token", newJString(oauthToken))
  add(query_580255, "callback", newJString(callback))
  add(query_580255, "access_token", newJString(accessToken))
  add(query_580255, "uploadType", newJString(uploadType))
  add(path_580254, "parent", newJString(parent))
  add(query_580255, "key", newJString(key))
  add(query_580255, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580256 = body
  add(query_580255, "prettyPrint", newJBool(prettyPrint))
  result = call_580253.call(path_580254, query_580255, nil, nil, body_580256)

var cloudprivatecatalogproducerCatalogsProductsVersionsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580236(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580237,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580238,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580215 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsList_580217(
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
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_580216(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580218 = path.getOrDefault("parent")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "parent", valid_580218
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
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
  ##           : The maximum number of versions to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580219 = query.getOrDefault("upload_protocol")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "upload_protocol", valid_580219
  var valid_580220 = query.getOrDefault("fields")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "fields", valid_580220
  var valid_580221 = query.getOrDefault("pageToken")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "pageToken", valid_580221
  var valid_580222 = query.getOrDefault("quotaUser")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "quotaUser", valid_580222
  var valid_580223 = query.getOrDefault("alt")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("json"))
  if valid_580223 != nil:
    section.add "alt", valid_580223
  var valid_580224 = query.getOrDefault("oauth_token")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "oauth_token", valid_580224
  var valid_580225 = query.getOrDefault("callback")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "callback", valid_580225
  var valid_580226 = query.getOrDefault("access_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "access_token", valid_580226
  var valid_580227 = query.getOrDefault("uploadType")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "uploadType", valid_580227
  var valid_580228 = query.getOrDefault("key")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "key", valid_580228
  var valid_580229 = query.getOrDefault("$.xgafv")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("1"))
  if valid_580229 != nil:
    section.add "$.xgafv", valid_580229
  var valid_580230 = query.getOrDefault("pageSize")
  valid_580230 = validateParameter(valid_580230, JInt, required = false, default = nil)
  if valid_580230 != nil:
    section.add "pageSize", valid_580230
  var valid_580231 = query.getOrDefault("prettyPrint")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "prettyPrint", valid_580231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580232: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580215;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsList
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
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
  ##         : The resource name of the parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of versions to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  add(query_580235, "upload_protocol", newJString(uploadProtocol))
  add(query_580235, "fields", newJString(fields))
  add(query_580235, "pageToken", newJString(pageToken))
  add(query_580235, "quotaUser", newJString(quotaUser))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "callback", newJString(callback))
  add(query_580235, "access_token", newJString(accessToken))
  add(query_580235, "uploadType", newJString(uploadType))
  add(path_580234, "parent", newJString(parent))
  add(query_580235, "key", newJString(key))
  add(query_580235, "$.xgafv", newJString(Xgafv))
  add(query_580235, "pageSize", newJInt(pageSize))
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  result = call_580233.call(path_580234, query_580235, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsList* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580215(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_580216,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsList_580217,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580257 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580259(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "product" in path, "`product` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "product"),
               (kind: ConstantSegment, value: "/icons:upload")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580258(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   product: JString (required)
  ##          : The resource name of the product.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `product` field"
  var valid_580260 = path.getOrDefault("product")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "product", valid_580260
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
  var valid_580261 = query.getOrDefault("upload_protocol")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "upload_protocol", valid_580261
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("alt")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("json"))
  if valid_580264 != nil:
    section.add "alt", valid_580264
  var valid_580265 = query.getOrDefault("oauth_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "oauth_token", valid_580265
  var valid_580266 = query.getOrDefault("callback")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "callback", valid_580266
  var valid_580267 = query.getOrDefault("access_token")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "access_token", valid_580267
  var valid_580268 = query.getOrDefault("uploadType")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "uploadType", valid_580268
  var valid_580269 = query.getOrDefault("key")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "key", valid_580269
  var valid_580270 = query.getOrDefault("$.xgafv")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = newJString("1"))
  if valid_580270 != nil:
    section.add "$.xgafv", valid_580270
  var valid_580271 = query.getOrDefault("prettyPrint")
  valid_580271 = validateParameter(valid_580271, JBool, required = false,
                                 default = newJBool(true))
  if valid_580271 != nil:
    section.add "prettyPrint", valid_580271
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

proc call*(call_580273: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  let valid = call_580273.validator(path, query, header, formData, body)
  let scheme = call_580273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580273.url(scheme.get, call_580273.host, call_580273.base,
                         call_580273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580273, url, valid)

proc call*(call_580274: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580257;
          product: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsIconsUpload
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
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
  ##   product: string (required)
  ##          : The resource name of the product.
  var path_580275 = newJObject()
  var query_580276 = newJObject()
  var body_580277 = newJObject()
  add(query_580276, "upload_protocol", newJString(uploadProtocol))
  add(query_580276, "fields", newJString(fields))
  add(query_580276, "quotaUser", newJString(quotaUser))
  add(query_580276, "alt", newJString(alt))
  add(query_580276, "oauth_token", newJString(oauthToken))
  add(query_580276, "callback", newJString(callback))
  add(query_580276, "access_token", newJString(accessToken))
  add(query_580276, "uploadType", newJString(uploadType))
  add(query_580276, "key", newJString(key))
  add(query_580276, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580277 = body
  add(query_580276, "prettyPrint", newJBool(prettyPrint))
  add(path_580275, "product", newJString(product))
  result = call_580274.call(path_580275, query_580276, nil, nil, body_580277)

var cloudprivatecatalogproducerCatalogsProductsIconsUpload* = Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580257(
    name: "cloudprivatecatalogproducerCatalogsProductsIconsUpload",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{product}/icons:upload",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580258,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580259,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580278 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsGetIamPolicy_580280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_580279(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets IAM policy for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580281 = path.getOrDefault("resource")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "resource", valid_580281
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580282 = query.getOrDefault("upload_protocol")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "upload_protocol", valid_580282
  var valid_580283 = query.getOrDefault("fields")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "fields", valid_580283
  var valid_580284 = query.getOrDefault("quotaUser")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "quotaUser", valid_580284
  var valid_580285 = query.getOrDefault("alt")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("json"))
  if valid_580285 != nil:
    section.add "alt", valid_580285
  var valid_580286 = query.getOrDefault("oauth_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "oauth_token", valid_580286
  var valid_580287 = query.getOrDefault("callback")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "callback", valid_580287
  var valid_580288 = query.getOrDefault("access_token")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "access_token", valid_580288
  var valid_580289 = query.getOrDefault("uploadType")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "uploadType", valid_580289
  var valid_580290 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580290 = validateParameter(valid_580290, JInt, required = false, default = nil)
  if valid_580290 != nil:
    section.add "options.requestedPolicyVersion", valid_580290
  var valid_580291 = query.getOrDefault("key")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "key", valid_580291
  var valid_580292 = query.getOrDefault("$.xgafv")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("1"))
  if valid_580292 != nil:
    section.add "$.xgafv", valid_580292
  var valid_580293 = query.getOrDefault("prettyPrint")
  valid_580293 = validateParameter(valid_580293, JBool, required = false,
                                 default = newJBool(true))
  if valid_580293 != nil:
    section.add "prettyPrint", valid_580293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580294: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets IAM policy for the specified Catalog.
  ## 
  let valid = call_580294.validator(path, query, header, formData, body)
  let scheme = call_580294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580294.url(scheme.get, call_580294.host, call_580294.base,
                         call_580294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580294, url, valid)

proc call*(call_580295: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580278;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsGetIamPolicy
  ## Gets IAM policy for the specified Catalog.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580296 = newJObject()
  var query_580297 = newJObject()
  add(query_580297, "upload_protocol", newJString(uploadProtocol))
  add(query_580297, "fields", newJString(fields))
  add(query_580297, "quotaUser", newJString(quotaUser))
  add(query_580297, "alt", newJString(alt))
  add(query_580297, "oauth_token", newJString(oauthToken))
  add(query_580297, "callback", newJString(callback))
  add(query_580297, "access_token", newJString(accessToken))
  add(query_580297, "uploadType", newJString(uploadType))
  add(query_580297, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580297, "key", newJString(key))
  add(query_580297, "$.xgafv", newJString(Xgafv))
  add(path_580296, "resource", newJString(resource))
  add(query_580297, "prettyPrint", newJBool(prettyPrint))
  result = call_580295.call(path_580296, query_580297, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsGetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580278(
    name: "cloudprivatecatalogproducerCatalogsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_580279,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsGetIamPolicy_580280,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580298 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsSetIamPolicy_580300(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_580299(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580301 = path.getOrDefault("resource")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "resource", valid_580301
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
  var valid_580302 = query.getOrDefault("upload_protocol")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "upload_protocol", valid_580302
  var valid_580303 = query.getOrDefault("fields")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "fields", valid_580303
  var valid_580304 = query.getOrDefault("quotaUser")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "quotaUser", valid_580304
  var valid_580305 = query.getOrDefault("alt")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("json"))
  if valid_580305 != nil:
    section.add "alt", valid_580305
  var valid_580306 = query.getOrDefault("oauth_token")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "oauth_token", valid_580306
  var valid_580307 = query.getOrDefault("callback")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "callback", valid_580307
  var valid_580308 = query.getOrDefault("access_token")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "access_token", valid_580308
  var valid_580309 = query.getOrDefault("uploadType")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "uploadType", valid_580309
  var valid_580310 = query.getOrDefault("key")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "key", valid_580310
  var valid_580311 = query.getOrDefault("$.xgafv")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("1"))
  if valid_580311 != nil:
    section.add "$.xgafv", valid_580311
  var valid_580312 = query.getOrDefault("prettyPrint")
  valid_580312 = validateParameter(valid_580312, JBool, required = false,
                                 default = newJBool(true))
  if valid_580312 != nil:
    section.add "prettyPrint", valid_580312
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

proc call*(call_580314: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  let valid = call_580314.validator(path, query, header, formData, body)
  let scheme = call_580314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580314.url(scheme.get, call_580314.host, call_580314.base,
                         call_580314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580314, url, valid)

proc call*(call_580315: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580298;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsSetIamPolicy
  ## Sets the IAM policy for the specified Catalog.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580316 = newJObject()
  var query_580317 = newJObject()
  var body_580318 = newJObject()
  add(query_580317, "upload_protocol", newJString(uploadProtocol))
  add(query_580317, "fields", newJString(fields))
  add(query_580317, "quotaUser", newJString(quotaUser))
  add(query_580317, "alt", newJString(alt))
  add(query_580317, "oauth_token", newJString(oauthToken))
  add(query_580317, "callback", newJString(callback))
  add(query_580317, "access_token", newJString(accessToken))
  add(query_580317, "uploadType", newJString(uploadType))
  add(query_580317, "key", newJString(key))
  add(query_580317, "$.xgafv", newJString(Xgafv))
  add(path_580316, "resource", newJString(resource))
  if body != nil:
    body_580318 = body
  add(query_580317, "prettyPrint", newJBool(prettyPrint))
  result = call_580315.call(path_580316, query_580317, nil, nil, body_580318)

var cloudprivatecatalogproducerCatalogsSetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580298(
    name: "cloudprivatecatalogproducerCatalogsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_580299,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsSetIamPolicy_580300,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580319 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogproducerCatalogsTestIamPermissions_580321(
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

proc validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_580320(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580322 = path.getOrDefault("resource")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "resource", valid_580322
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
  var valid_580323 = query.getOrDefault("upload_protocol")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "upload_protocol", valid_580323
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("oauth_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "oauth_token", valid_580327
  var valid_580328 = query.getOrDefault("callback")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "callback", valid_580328
  var valid_580329 = query.getOrDefault("access_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "access_token", valid_580329
  var valid_580330 = query.getOrDefault("uploadType")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "uploadType", valid_580330
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("$.xgafv")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("1"))
  if valid_580332 != nil:
    section.add "$.xgafv", valid_580332
  var valid_580333 = query.getOrDefault("prettyPrint")
  valid_580333 = validateParameter(valid_580333, JBool, required = false,
                                 default = newJBool(true))
  if valid_580333 != nil:
    section.add "prettyPrint", valid_580333
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

proc call*(call_580335: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  let valid = call_580335.validator(path, query, header, formData, body)
  let scheme = call_580335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580335.url(scheme.get, call_580335.host, call_580335.base,
                         call_580335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580335, url, valid)

proc call*(call_580336: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580319;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogproducerCatalogsTestIamPermissions
  ## Tests the IAM permissions for the specified Catalog.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580337 = newJObject()
  var query_580338 = newJObject()
  var body_580339 = newJObject()
  add(query_580338, "upload_protocol", newJString(uploadProtocol))
  add(query_580338, "fields", newJString(fields))
  add(query_580338, "quotaUser", newJString(quotaUser))
  add(query_580338, "alt", newJString(alt))
  add(query_580338, "oauth_token", newJString(oauthToken))
  add(query_580338, "callback", newJString(callback))
  add(query_580338, "access_token", newJString(accessToken))
  add(query_580338, "uploadType", newJString(uploadType))
  add(query_580338, "key", newJString(key))
  add(query_580338, "$.xgafv", newJString(Xgafv))
  add(path_580337, "resource", newJString(resource))
  if body != nil:
    body_580339 = body
  add(query_580338, "prettyPrint", newJBool(prettyPrint))
  result = call_580336.call(path_580337, query_580338, nil, nil, body_580339)

var cloudprivatecatalogproducerCatalogsTestIamPermissions* = Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580319(
    name: "cloudprivatecatalogproducerCatalogsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_580320,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsTestIamPermissions_580321,
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
