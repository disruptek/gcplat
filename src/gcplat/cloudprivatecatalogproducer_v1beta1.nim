
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "cloudprivatecatalogproducer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogproducerCatalogsCreate_597952 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsCreate_597954(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsCreate_597953(path: JsonNode;
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
  var valid_597955 = query.getOrDefault("upload_protocol")
  valid_597955 = validateParameter(valid_597955, JString, required = false,
                                 default = nil)
  if valid_597955 != nil:
    section.add "upload_protocol", valid_597955
  var valid_597956 = query.getOrDefault("fields")
  valid_597956 = validateParameter(valid_597956, JString, required = false,
                                 default = nil)
  if valid_597956 != nil:
    section.add "fields", valid_597956
  var valid_597957 = query.getOrDefault("quotaUser")
  valid_597957 = validateParameter(valid_597957, JString, required = false,
                                 default = nil)
  if valid_597957 != nil:
    section.add "quotaUser", valid_597957
  var valid_597958 = query.getOrDefault("alt")
  valid_597958 = validateParameter(valid_597958, JString, required = false,
                                 default = newJString("json"))
  if valid_597958 != nil:
    section.add "alt", valid_597958
  var valid_597959 = query.getOrDefault("oauth_token")
  valid_597959 = validateParameter(valid_597959, JString, required = false,
                                 default = nil)
  if valid_597959 != nil:
    section.add "oauth_token", valid_597959
  var valid_597960 = query.getOrDefault("callback")
  valid_597960 = validateParameter(valid_597960, JString, required = false,
                                 default = nil)
  if valid_597960 != nil:
    section.add "callback", valid_597960
  var valid_597961 = query.getOrDefault("access_token")
  valid_597961 = validateParameter(valid_597961, JString, required = false,
                                 default = nil)
  if valid_597961 != nil:
    section.add "access_token", valid_597961
  var valid_597962 = query.getOrDefault("uploadType")
  valid_597962 = validateParameter(valid_597962, JString, required = false,
                                 default = nil)
  if valid_597962 != nil:
    section.add "uploadType", valid_597962
  var valid_597963 = query.getOrDefault("key")
  valid_597963 = validateParameter(valid_597963, JString, required = false,
                                 default = nil)
  if valid_597963 != nil:
    section.add "key", valid_597963
  var valid_597964 = query.getOrDefault("$.xgafv")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = newJString("1"))
  if valid_597964 != nil:
    section.add "$.xgafv", valid_597964
  var valid_597965 = query.getOrDefault("prettyPrint")
  valid_597965 = validateParameter(valid_597965, JBool, required = false,
                                 default = newJBool(true))
  if valid_597965 != nil:
    section.add "prettyPrint", valid_597965
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

proc call*(call_597967: Call_CloudprivatecatalogproducerCatalogsCreate_597952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Catalog resource.
  ## 
  let valid = call_597967.validator(path, query, header, formData, body)
  let scheme = call_597967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597967.url(scheme.get, call_597967.host, call_597967.base,
                         call_597967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597967, url, valid)

proc call*(call_597968: Call_CloudprivatecatalogproducerCatalogsCreate_597952;
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
  var query_597969 = newJObject()
  var body_597970 = newJObject()
  add(query_597969, "upload_protocol", newJString(uploadProtocol))
  add(query_597969, "fields", newJString(fields))
  add(query_597969, "quotaUser", newJString(quotaUser))
  add(query_597969, "alt", newJString(alt))
  add(query_597969, "oauth_token", newJString(oauthToken))
  add(query_597969, "callback", newJString(callback))
  add(query_597969, "access_token", newJString(accessToken))
  add(query_597969, "uploadType", newJString(uploadType))
  add(query_597969, "key", newJString(key))
  add(query_597969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597970 = body
  add(query_597969, "prettyPrint", newJBool(prettyPrint))
  result = call_597968.call(nil, query_597969, nil, nil, body_597970)

var cloudprivatecatalogproducerCatalogsCreate* = Call_CloudprivatecatalogproducerCatalogsCreate_597952(
    name: "cloudprivatecatalogproducerCatalogsCreate", meth: HttpMethod.HttpPost,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsCreate_597953,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsCreate_597954,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsList_597677 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsList_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsList_597678(path: JsonNode;
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
  var valid_597809 = query.getOrDefault("oauth_token")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "oauth_token", valid_597809
  var valid_597810 = query.getOrDefault("callback")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "callback", valid_597810
  var valid_597811 = query.getOrDefault("access_token")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "access_token", valid_597811
  var valid_597812 = query.getOrDefault("uploadType")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "uploadType", valid_597812
  var valid_597813 = query.getOrDefault("parent")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "parent", valid_597813
  var valid_597814 = query.getOrDefault("key")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = nil)
  if valid_597814 != nil:
    section.add "key", valid_597814
  var valid_597815 = query.getOrDefault("$.xgafv")
  valid_597815 = validateParameter(valid_597815, JString, required = false,
                                 default = newJString("1"))
  if valid_597815 != nil:
    section.add "$.xgafv", valid_597815
  var valid_597816 = query.getOrDefault("pageSize")
  valid_597816 = validateParameter(valid_597816, JInt, required = false, default = nil)
  if valid_597816 != nil:
    section.add "pageSize", valid_597816
  var valid_597817 = query.getOrDefault("prettyPrint")
  valid_597817 = validateParameter(valid_597817, JBool, required = false,
                                 default = newJBool(true))
  if valid_597817 != nil:
    section.add "prettyPrint", valid_597817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597840: Call_CloudprivatecatalogproducerCatalogsList_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ## 
  let valid = call_597840.validator(path, query, header, formData, body)
  let scheme = call_597840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597840.url(scheme.get, call_597840.host, call_597840.base,
                         call_597840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597840, url, valid)

proc call*(call_597911: Call_CloudprivatecatalogproducerCatalogsList_597677;
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
  var query_597912 = newJObject()
  add(query_597912, "upload_protocol", newJString(uploadProtocol))
  add(query_597912, "fields", newJString(fields))
  add(query_597912, "pageToken", newJString(pageToken))
  add(query_597912, "quotaUser", newJString(quotaUser))
  add(query_597912, "alt", newJString(alt))
  add(query_597912, "oauth_token", newJString(oauthToken))
  add(query_597912, "callback", newJString(callback))
  add(query_597912, "access_token", newJString(accessToken))
  add(query_597912, "uploadType", newJString(uploadType))
  add(query_597912, "parent", newJString(parent))
  add(query_597912, "key", newJString(key))
  add(query_597912, "$.xgafv", newJString(Xgafv))
  add(query_597912, "pageSize", newJInt(pageSize))
  add(query_597912, "prettyPrint", newJBool(prettyPrint))
  result = call_597911.call(nil, query_597912, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsList* = Call_CloudprivatecatalogproducerCatalogsList_597677(
    name: "cloudprivatecatalogproducerCatalogsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsList_597678, base: "/",
    url: url_CloudprivatecatalogproducerCatalogsList_597679,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsList_597971 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerOperationsList_597973(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerOperationsList_597972(path: JsonNode;
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
  var valid_597974 = query.getOrDefault("upload_protocol")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "upload_protocol", valid_597974
  var valid_597975 = query.getOrDefault("fields")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "fields", valid_597975
  var valid_597976 = query.getOrDefault("pageToken")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "pageToken", valid_597976
  var valid_597977 = query.getOrDefault("quotaUser")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "quotaUser", valid_597977
  var valid_597978 = query.getOrDefault("alt")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("json"))
  if valid_597978 != nil:
    section.add "alt", valid_597978
  var valid_597979 = query.getOrDefault("oauth_token")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "oauth_token", valid_597979
  var valid_597980 = query.getOrDefault("callback")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "callback", valid_597980
  var valid_597981 = query.getOrDefault("access_token")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "access_token", valid_597981
  var valid_597982 = query.getOrDefault("uploadType")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "uploadType", valid_597982
  var valid_597983 = query.getOrDefault("key")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "key", valid_597983
  var valid_597984 = query.getOrDefault("name")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "name", valid_597984
  var valid_597985 = query.getOrDefault("$.xgafv")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = newJString("1"))
  if valid_597985 != nil:
    section.add "$.xgafv", valid_597985
  var valid_597986 = query.getOrDefault("pageSize")
  valid_597986 = validateParameter(valid_597986, JInt, required = false, default = nil)
  if valid_597986 != nil:
    section.add "pageSize", valid_597986
  var valid_597987 = query.getOrDefault("prettyPrint")
  valid_597987 = validateParameter(valid_597987, JBool, required = false,
                                 default = newJBool(true))
  if valid_597987 != nil:
    section.add "prettyPrint", valid_597987
  var valid_597988 = query.getOrDefault("filter")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "filter", valid_597988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597989: Call_CloudprivatecatalogproducerOperationsList_597971;
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
  let valid = call_597989.validator(path, query, header, formData, body)
  let scheme = call_597989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597989.url(scheme.get, call_597989.host, call_597989.base,
                         call_597989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597989, url, valid)

proc call*(call_597990: Call_CloudprivatecatalogproducerOperationsList_597971;
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
  var query_597991 = newJObject()
  add(query_597991, "upload_protocol", newJString(uploadProtocol))
  add(query_597991, "fields", newJString(fields))
  add(query_597991, "pageToken", newJString(pageToken))
  add(query_597991, "quotaUser", newJString(quotaUser))
  add(query_597991, "alt", newJString(alt))
  add(query_597991, "oauth_token", newJString(oauthToken))
  add(query_597991, "callback", newJString(callback))
  add(query_597991, "access_token", newJString(accessToken))
  add(query_597991, "uploadType", newJString(uploadType))
  add(query_597991, "key", newJString(key))
  add(query_597991, "name", newJString(name))
  add(query_597991, "$.xgafv", newJString(Xgafv))
  add(query_597991, "pageSize", newJInt(pageSize))
  add(query_597991, "prettyPrint", newJBool(prettyPrint))
  add(query_597991, "filter", newJString(filter))
  result = call_597990.call(nil, query_597991, nil, nil, nil)

var cloudprivatecatalogproducerOperationsList* = Call_CloudprivatecatalogproducerOperationsList_597971(
    name: "cloudprivatecatalogproducerOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/operations",
    validator: validate_CloudprivatecatalogproducerOperationsList_597972,
    base: "/", url: url_CloudprivatecatalogproducerOperationsList_597973,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsGet_597992 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerOperationsGet_597994(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerOperationsGet_597993(path: JsonNode;
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
  var valid_598009 = path.getOrDefault("name")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "name", valid_598009
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
  var valid_598010 = query.getOrDefault("upload_protocol")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "upload_protocol", valid_598010
  var valid_598011 = query.getOrDefault("fields")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "fields", valid_598011
  var valid_598012 = query.getOrDefault("quotaUser")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "quotaUser", valid_598012
  var valid_598013 = query.getOrDefault("alt")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("json"))
  if valid_598013 != nil:
    section.add "alt", valid_598013
  var valid_598014 = query.getOrDefault("oauth_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "oauth_token", valid_598014
  var valid_598015 = query.getOrDefault("callback")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "callback", valid_598015
  var valid_598016 = query.getOrDefault("access_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "access_token", valid_598016
  var valid_598017 = query.getOrDefault("uploadType")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "uploadType", valid_598017
  var valid_598018 = query.getOrDefault("key")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "key", valid_598018
  var valid_598019 = query.getOrDefault("$.xgafv")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("1"))
  if valid_598019 != nil:
    section.add "$.xgafv", valid_598019
  var valid_598020 = query.getOrDefault("prettyPrint")
  valid_598020 = validateParameter(valid_598020, JBool, required = false,
                                 default = newJBool(true))
  if valid_598020 != nil:
    section.add "prettyPrint", valid_598020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598021: Call_CloudprivatecatalogproducerOperationsGet_597992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_598021.validator(path, query, header, formData, body)
  let scheme = call_598021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598021.url(scheme.get, call_598021.host, call_598021.base,
                         call_598021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598021, url, valid)

proc call*(call_598022: Call_CloudprivatecatalogproducerOperationsGet_597992;
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
  var path_598023 = newJObject()
  var query_598024 = newJObject()
  add(query_598024, "upload_protocol", newJString(uploadProtocol))
  add(query_598024, "fields", newJString(fields))
  add(query_598024, "quotaUser", newJString(quotaUser))
  add(path_598023, "name", newJString(name))
  add(query_598024, "alt", newJString(alt))
  add(query_598024, "oauth_token", newJString(oauthToken))
  add(query_598024, "callback", newJString(callback))
  add(query_598024, "access_token", newJString(accessToken))
  add(query_598024, "uploadType", newJString(uploadType))
  add(query_598024, "key", newJString(key))
  add(query_598024, "$.xgafv", newJString(Xgafv))
  add(query_598024, "prettyPrint", newJBool(prettyPrint))
  result = call_598022.call(path_598023, query_598024, nil, nil, nil)

var cloudprivatecatalogproducerOperationsGet* = Call_CloudprivatecatalogproducerOperationsGet_597992(
    name: "cloudprivatecatalogproducerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerOperationsGet_597993,
    base: "/", url: url_CloudprivatecatalogproducerOperationsGet_597994,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598045 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598047(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598046(
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
  var valid_598048 = path.getOrDefault("name")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "name", valid_598048
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
  var valid_598049 = query.getOrDefault("upload_protocol")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "upload_protocol", valid_598049
  var valid_598050 = query.getOrDefault("fields")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "fields", valid_598050
  var valid_598051 = query.getOrDefault("quotaUser")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "quotaUser", valid_598051
  var valid_598052 = query.getOrDefault("alt")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = newJString("json"))
  if valid_598052 != nil:
    section.add "alt", valid_598052
  var valid_598053 = query.getOrDefault("oauth_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "oauth_token", valid_598053
  var valid_598054 = query.getOrDefault("callback")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "callback", valid_598054
  var valid_598055 = query.getOrDefault("access_token")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "access_token", valid_598055
  var valid_598056 = query.getOrDefault("uploadType")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "uploadType", valid_598056
  var valid_598057 = query.getOrDefault("key")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "key", valid_598057
  var valid_598058 = query.getOrDefault("$.xgafv")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = newJString("1"))
  if valid_598058 != nil:
    section.add "$.xgafv", valid_598058
  var valid_598059 = query.getOrDefault("prettyPrint")
  valid_598059 = validateParameter(valid_598059, JBool, required = false,
                                 default = newJBool(true))
  if valid_598059 != nil:
    section.add "prettyPrint", valid_598059
  var valid_598060 = query.getOrDefault("updateMask")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "updateMask", valid_598060
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

proc call*(call_598062: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a specific Version resource.
  ## 
  let valid = call_598062.validator(path, query, header, formData, body)
  let scheme = call_598062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598062.url(scheme.get, call_598062.host, call_598062.base,
                         call_598062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598062, url, valid)

proc call*(call_598063: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598045;
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
  var path_598064 = newJObject()
  var query_598065 = newJObject()
  var body_598066 = newJObject()
  add(query_598065, "upload_protocol", newJString(uploadProtocol))
  add(query_598065, "fields", newJString(fields))
  add(query_598065, "quotaUser", newJString(quotaUser))
  add(path_598064, "name", newJString(name))
  add(query_598065, "alt", newJString(alt))
  add(query_598065, "oauth_token", newJString(oauthToken))
  add(query_598065, "callback", newJString(callback))
  add(query_598065, "access_token", newJString(accessToken))
  add(query_598065, "uploadType", newJString(uploadType))
  add(query_598065, "key", newJString(key))
  add(query_598065, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598066 = body
  add(query_598065, "prettyPrint", newJBool(prettyPrint))
  add(query_598065, "updateMask", newJString(updateMask))
  result = call_598063.call(path_598064, query_598065, nil, nil, body_598066)

var cloudprivatecatalogproducerCatalogsProductsVersionsPatch* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598045(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsPatch",
    meth: HttpMethod.HttpPatch,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598046,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_598047,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsDelete_598025 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerOperationsDelete_598027(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerOperationsDelete_598026(path: JsonNode;
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
  var valid_598028 = path.getOrDefault("name")
  valid_598028 = validateParameter(valid_598028, JString, required = true,
                                 default = nil)
  if valid_598028 != nil:
    section.add "name", valid_598028
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
  var valid_598029 = query.getOrDefault("upload_protocol")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "upload_protocol", valid_598029
  var valid_598030 = query.getOrDefault("fields")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "fields", valid_598030
  var valid_598031 = query.getOrDefault("force")
  valid_598031 = validateParameter(valid_598031, JBool, required = false, default = nil)
  if valid_598031 != nil:
    section.add "force", valid_598031
  var valid_598032 = query.getOrDefault("quotaUser")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "quotaUser", valid_598032
  var valid_598033 = query.getOrDefault("alt")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = newJString("json"))
  if valid_598033 != nil:
    section.add "alt", valid_598033
  var valid_598034 = query.getOrDefault("oauth_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "oauth_token", valid_598034
  var valid_598035 = query.getOrDefault("callback")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "callback", valid_598035
  var valid_598036 = query.getOrDefault("access_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "access_token", valid_598036
  var valid_598037 = query.getOrDefault("uploadType")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "uploadType", valid_598037
  var valid_598038 = query.getOrDefault("key")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "key", valid_598038
  var valid_598039 = query.getOrDefault("$.xgafv")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = newJString("1"))
  if valid_598039 != nil:
    section.add "$.xgafv", valid_598039
  var valid_598040 = query.getOrDefault("prettyPrint")
  valid_598040 = validateParameter(valid_598040, JBool, required = false,
                                 default = newJBool(true))
  if valid_598040 != nil:
    section.add "prettyPrint", valid_598040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598041: Call_CloudprivatecatalogproducerOperationsDelete_598025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_598041.validator(path, query, header, formData, body)
  let scheme = call_598041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598041.url(scheme.get, call_598041.host, call_598041.base,
                         call_598041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598041, url, valid)

proc call*(call_598042: Call_CloudprivatecatalogproducerOperationsDelete_598025;
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
  var path_598043 = newJObject()
  var query_598044 = newJObject()
  add(query_598044, "upload_protocol", newJString(uploadProtocol))
  add(query_598044, "fields", newJString(fields))
  add(query_598044, "force", newJBool(force))
  add(query_598044, "quotaUser", newJString(quotaUser))
  add(path_598043, "name", newJString(name))
  add(query_598044, "alt", newJString(alt))
  add(query_598044, "oauth_token", newJString(oauthToken))
  add(query_598044, "callback", newJString(callback))
  add(query_598044, "access_token", newJString(accessToken))
  add(query_598044, "uploadType", newJString(uploadType))
  add(query_598044, "key", newJString(key))
  add(query_598044, "$.xgafv", newJString(Xgafv))
  add(query_598044, "prettyPrint", newJBool(prettyPrint))
  result = call_598042.call(path_598043, query_598044, nil, nil, nil)

var cloudprivatecatalogproducerOperationsDelete* = Call_CloudprivatecatalogproducerOperationsDelete_598025(
    name: "cloudprivatecatalogproducerOperationsDelete",
    meth: HttpMethod.HttpDelete,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerOperationsDelete_598026,
    base: "/", url: url_CloudprivatecatalogproducerOperationsDelete_598027,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsCancel_598067 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerOperationsCancel_598069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerOperationsCancel_598068(path: JsonNode;
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
  var valid_598070 = path.getOrDefault("name")
  valid_598070 = validateParameter(valid_598070, JString, required = true,
                                 default = nil)
  if valid_598070 != nil:
    section.add "name", valid_598070
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
  var valid_598071 = query.getOrDefault("upload_protocol")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "upload_protocol", valid_598071
  var valid_598072 = query.getOrDefault("fields")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "fields", valid_598072
  var valid_598073 = query.getOrDefault("quotaUser")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "quotaUser", valid_598073
  var valid_598074 = query.getOrDefault("alt")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = newJString("json"))
  if valid_598074 != nil:
    section.add "alt", valid_598074
  var valid_598075 = query.getOrDefault("oauth_token")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "oauth_token", valid_598075
  var valid_598076 = query.getOrDefault("callback")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "callback", valid_598076
  var valid_598077 = query.getOrDefault("access_token")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "access_token", valid_598077
  var valid_598078 = query.getOrDefault("uploadType")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "uploadType", valid_598078
  var valid_598079 = query.getOrDefault("key")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "key", valid_598079
  var valid_598080 = query.getOrDefault("$.xgafv")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = newJString("1"))
  if valid_598080 != nil:
    section.add "$.xgafv", valid_598080
  var valid_598081 = query.getOrDefault("prettyPrint")
  valid_598081 = validateParameter(valid_598081, JBool, required = false,
                                 default = newJBool(true))
  if valid_598081 != nil:
    section.add "prettyPrint", valid_598081
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

proc call*(call_598083: Call_CloudprivatecatalogproducerOperationsCancel_598067;
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
  let valid = call_598083.validator(path, query, header, formData, body)
  let scheme = call_598083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598083.url(scheme.get, call_598083.host, call_598083.base,
                         call_598083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598083, url, valid)

proc call*(call_598084: Call_CloudprivatecatalogproducerOperationsCancel_598067;
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
  var path_598085 = newJObject()
  var query_598086 = newJObject()
  var body_598087 = newJObject()
  add(query_598086, "upload_protocol", newJString(uploadProtocol))
  add(query_598086, "fields", newJString(fields))
  add(query_598086, "quotaUser", newJString(quotaUser))
  add(path_598085, "name", newJString(name))
  add(query_598086, "alt", newJString(alt))
  add(query_598086, "oauth_token", newJString(oauthToken))
  add(query_598086, "callback", newJString(callback))
  add(query_598086, "access_token", newJString(accessToken))
  add(query_598086, "uploadType", newJString(uploadType))
  add(query_598086, "key", newJString(key))
  add(query_598086, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598087 = body
  add(query_598086, "prettyPrint", newJBool(prettyPrint))
  result = call_598084.call(path_598085, query_598086, nil, nil, body_598087)

var cloudprivatecatalogproducerOperationsCancel* = Call_CloudprivatecatalogproducerOperationsCancel_598067(
    name: "cloudprivatecatalogproducerOperationsCancel",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_CloudprivatecatalogproducerOperationsCancel_598068,
    base: "/", url: url_CloudprivatecatalogproducerOperationsCancel_598069,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCopy_598088 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsProductsCopy_598090(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsProductsCopy_598089(
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
  var valid_598091 = path.getOrDefault("name")
  valid_598091 = validateParameter(valid_598091, JString, required = true,
                                 default = nil)
  if valid_598091 != nil:
    section.add "name", valid_598091
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
  var valid_598092 = query.getOrDefault("upload_protocol")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "upload_protocol", valid_598092
  var valid_598093 = query.getOrDefault("fields")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "fields", valid_598093
  var valid_598094 = query.getOrDefault("quotaUser")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "quotaUser", valid_598094
  var valid_598095 = query.getOrDefault("alt")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = newJString("json"))
  if valid_598095 != nil:
    section.add "alt", valid_598095
  var valid_598096 = query.getOrDefault("oauth_token")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "oauth_token", valid_598096
  var valid_598097 = query.getOrDefault("callback")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "callback", valid_598097
  var valid_598098 = query.getOrDefault("access_token")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "access_token", valid_598098
  var valid_598099 = query.getOrDefault("uploadType")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "uploadType", valid_598099
  var valid_598100 = query.getOrDefault("key")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "key", valid_598100
  var valid_598101 = query.getOrDefault("$.xgafv")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = newJString("1"))
  if valid_598101 != nil:
    section.add "$.xgafv", valid_598101
  var valid_598102 = query.getOrDefault("prettyPrint")
  valid_598102 = validateParameter(valid_598102, JBool, required = false,
                                 default = newJBool(true))
  if valid_598102 != nil:
    section.add "prettyPrint", valid_598102
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

proc call*(call_598104: Call_CloudprivatecatalogproducerCatalogsProductsCopy_598088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Copies a Product under another Catalog.
  ## 
  let valid = call_598104.validator(path, query, header, formData, body)
  let scheme = call_598104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598104.url(scheme.get, call_598104.host, call_598104.base,
                         call_598104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598104, url, valid)

proc call*(call_598105: Call_CloudprivatecatalogproducerCatalogsProductsCopy_598088;
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
  var path_598106 = newJObject()
  var query_598107 = newJObject()
  var body_598108 = newJObject()
  add(query_598107, "upload_protocol", newJString(uploadProtocol))
  add(query_598107, "fields", newJString(fields))
  add(query_598107, "quotaUser", newJString(quotaUser))
  add(path_598106, "name", newJString(name))
  add(query_598107, "alt", newJString(alt))
  add(query_598107, "oauth_token", newJString(oauthToken))
  add(query_598107, "callback", newJString(callback))
  add(query_598107, "access_token", newJString(accessToken))
  add(query_598107, "uploadType", newJString(uploadType))
  add(query_598107, "key", newJString(key))
  add(query_598107, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598108 = body
  add(query_598107, "prettyPrint", newJBool(prettyPrint))
  result = call_598105.call(path_598106, query_598107, nil, nil, body_598108)

var cloudprivatecatalogproducerCatalogsProductsCopy* = Call_CloudprivatecatalogproducerCatalogsProductsCopy_598088(
    name: "cloudprivatecatalogproducerCatalogsProductsCopy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:copy",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCopy_598089,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCopy_598090,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsUndelete_598109 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsUndelete_598111(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsUndelete_598110(path: JsonNode;
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
  var valid_598112 = path.getOrDefault("name")
  valid_598112 = validateParameter(valid_598112, JString, required = true,
                                 default = nil)
  if valid_598112 != nil:
    section.add "name", valid_598112
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
  var valid_598113 = query.getOrDefault("upload_protocol")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "upload_protocol", valid_598113
  var valid_598114 = query.getOrDefault("fields")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "fields", valid_598114
  var valid_598115 = query.getOrDefault("quotaUser")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "quotaUser", valid_598115
  var valid_598116 = query.getOrDefault("alt")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = newJString("json"))
  if valid_598116 != nil:
    section.add "alt", valid_598116
  var valid_598117 = query.getOrDefault("oauth_token")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "oauth_token", valid_598117
  var valid_598118 = query.getOrDefault("callback")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "callback", valid_598118
  var valid_598119 = query.getOrDefault("access_token")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "access_token", valid_598119
  var valid_598120 = query.getOrDefault("uploadType")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "uploadType", valid_598120
  var valid_598121 = query.getOrDefault("key")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "key", valid_598121
  var valid_598122 = query.getOrDefault("$.xgafv")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = newJString("1"))
  if valid_598122 != nil:
    section.add "$.xgafv", valid_598122
  var valid_598123 = query.getOrDefault("prettyPrint")
  valid_598123 = validateParameter(valid_598123, JBool, required = false,
                                 default = newJBool(true))
  if valid_598123 != nil:
    section.add "prettyPrint", valid_598123
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

proc call*(call_598125: Call_CloudprivatecatalogproducerCatalogsUndelete_598109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  let valid = call_598125.validator(path, query, header, formData, body)
  let scheme = call_598125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598125.url(scheme.get, call_598125.host, call_598125.base,
                         call_598125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598125, url, valid)

proc call*(call_598126: Call_CloudprivatecatalogproducerCatalogsUndelete_598109;
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
  var path_598127 = newJObject()
  var query_598128 = newJObject()
  var body_598129 = newJObject()
  add(query_598128, "upload_protocol", newJString(uploadProtocol))
  add(query_598128, "fields", newJString(fields))
  add(query_598128, "quotaUser", newJString(quotaUser))
  add(path_598127, "name", newJString(name))
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
  result = call_598126.call(path_598127, query_598128, nil, nil, body_598129)

var cloudprivatecatalogproducerCatalogsUndelete* = Call_CloudprivatecatalogproducerCatalogsUndelete_598109(
    name: "cloudprivatecatalogproducerCatalogsUndelete",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:undelete",
    validator: validate_CloudprivatecatalogproducerCatalogsUndelete_598110,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsUndelete_598111,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_598151 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsAssociationsCreate_598153(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_598152(
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
  var valid_598154 = path.getOrDefault("parent")
  valid_598154 = validateParameter(valid_598154, JString, required = true,
                                 default = nil)
  if valid_598154 != nil:
    section.add "parent", valid_598154
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
  var valid_598155 = query.getOrDefault("upload_protocol")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "upload_protocol", valid_598155
  var valid_598156 = query.getOrDefault("fields")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "fields", valid_598156
  var valid_598157 = query.getOrDefault("quotaUser")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "quotaUser", valid_598157
  var valid_598158 = query.getOrDefault("alt")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = newJString("json"))
  if valid_598158 != nil:
    section.add "alt", valid_598158
  var valid_598159 = query.getOrDefault("oauth_token")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "oauth_token", valid_598159
  var valid_598160 = query.getOrDefault("callback")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "callback", valid_598160
  var valid_598161 = query.getOrDefault("access_token")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "access_token", valid_598161
  var valid_598162 = query.getOrDefault("uploadType")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "uploadType", valid_598162
  var valid_598163 = query.getOrDefault("key")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "key", valid_598163
  var valid_598164 = query.getOrDefault("$.xgafv")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = newJString("1"))
  if valid_598164 != nil:
    section.add "$.xgafv", valid_598164
  var valid_598165 = query.getOrDefault("prettyPrint")
  valid_598165 = validateParameter(valid_598165, JBool, required = false,
                                 default = newJBool(true))
  if valid_598165 != nil:
    section.add "prettyPrint", valid_598165
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

proc call*(call_598167: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_598151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Association instance under a given Catalog.
  ## 
  let valid = call_598167.validator(path, query, header, formData, body)
  let scheme = call_598167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598167.url(scheme.get, call_598167.host, call_598167.base,
                         call_598167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598167, url, valid)

proc call*(call_598168: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_598151;
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
  var path_598169 = newJObject()
  var query_598170 = newJObject()
  var body_598171 = newJObject()
  add(query_598170, "upload_protocol", newJString(uploadProtocol))
  add(query_598170, "fields", newJString(fields))
  add(query_598170, "quotaUser", newJString(quotaUser))
  add(query_598170, "alt", newJString(alt))
  add(query_598170, "oauth_token", newJString(oauthToken))
  add(query_598170, "callback", newJString(callback))
  add(query_598170, "access_token", newJString(accessToken))
  add(query_598170, "uploadType", newJString(uploadType))
  add(path_598169, "parent", newJString(parent))
  add(query_598170, "key", newJString(key))
  add(query_598170, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598171 = body
  add(query_598170, "prettyPrint", newJBool(prettyPrint))
  result = call_598168.call(path_598169, query_598170, nil, nil, body_598171)

var cloudprivatecatalogproducerCatalogsAssociationsCreate* = Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_598151(
    name: "cloudprivatecatalogproducerCatalogsAssociationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_598152,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsCreate_598153,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsList_598130 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsAssociationsList_598132(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsAssociationsList_598131(
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
  var valid_598133 = path.getOrDefault("parent")
  valid_598133 = validateParameter(valid_598133, JString, required = true,
                                 default = nil)
  if valid_598133 != nil:
    section.add "parent", valid_598133
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
  var valid_598134 = query.getOrDefault("upload_protocol")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "upload_protocol", valid_598134
  var valid_598135 = query.getOrDefault("fields")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "fields", valid_598135
  var valid_598136 = query.getOrDefault("pageToken")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "pageToken", valid_598136
  var valid_598137 = query.getOrDefault("quotaUser")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "quotaUser", valid_598137
  var valid_598138 = query.getOrDefault("alt")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = newJString("json"))
  if valid_598138 != nil:
    section.add "alt", valid_598138
  var valid_598139 = query.getOrDefault("oauth_token")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "oauth_token", valid_598139
  var valid_598140 = query.getOrDefault("callback")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "callback", valid_598140
  var valid_598141 = query.getOrDefault("access_token")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "access_token", valid_598141
  var valid_598142 = query.getOrDefault("uploadType")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "uploadType", valid_598142
  var valid_598143 = query.getOrDefault("key")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "key", valid_598143
  var valid_598144 = query.getOrDefault("$.xgafv")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = newJString("1"))
  if valid_598144 != nil:
    section.add "$.xgafv", valid_598144
  var valid_598145 = query.getOrDefault("pageSize")
  valid_598145 = validateParameter(valid_598145, JInt, required = false, default = nil)
  if valid_598145 != nil:
    section.add "pageSize", valid_598145
  var valid_598146 = query.getOrDefault("prettyPrint")
  valid_598146 = validateParameter(valid_598146, JBool, required = false,
                                 default = newJBool(true))
  if valid_598146 != nil:
    section.add "prettyPrint", valid_598146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598147: Call_CloudprivatecatalogproducerCatalogsAssociationsList_598130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Association resources under a catalog.
  ## 
  let valid = call_598147.validator(path, query, header, formData, body)
  let scheme = call_598147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598147.url(scheme.get, call_598147.host, call_598147.base,
                         call_598147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598147, url, valid)

proc call*(call_598148: Call_CloudprivatecatalogproducerCatalogsAssociationsList_598130;
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
  var path_598149 = newJObject()
  var query_598150 = newJObject()
  add(query_598150, "upload_protocol", newJString(uploadProtocol))
  add(query_598150, "fields", newJString(fields))
  add(query_598150, "pageToken", newJString(pageToken))
  add(query_598150, "quotaUser", newJString(quotaUser))
  add(query_598150, "alt", newJString(alt))
  add(query_598150, "oauth_token", newJString(oauthToken))
  add(query_598150, "callback", newJString(callback))
  add(query_598150, "access_token", newJString(accessToken))
  add(query_598150, "uploadType", newJString(uploadType))
  add(path_598149, "parent", newJString(parent))
  add(query_598150, "key", newJString(key))
  add(query_598150, "$.xgafv", newJString(Xgafv))
  add(query_598150, "pageSize", newJInt(pageSize))
  add(query_598150, "prettyPrint", newJBool(prettyPrint))
  result = call_598148.call(path_598149, query_598150, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsAssociationsList* = Call_CloudprivatecatalogproducerCatalogsAssociationsList_598130(
    name: "cloudprivatecatalogproducerCatalogsAssociationsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsList_598131,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsList_598132,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCreate_598194 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsProductsCreate_598196(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsProductsCreate_598195(
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
  var valid_598197 = path.getOrDefault("parent")
  valid_598197 = validateParameter(valid_598197, JString, required = true,
                                 default = nil)
  if valid_598197 != nil:
    section.add "parent", valid_598197
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
  var valid_598198 = query.getOrDefault("upload_protocol")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "upload_protocol", valid_598198
  var valid_598199 = query.getOrDefault("fields")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "fields", valid_598199
  var valid_598200 = query.getOrDefault("quotaUser")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "quotaUser", valid_598200
  var valid_598201 = query.getOrDefault("alt")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = newJString("json"))
  if valid_598201 != nil:
    section.add "alt", valid_598201
  var valid_598202 = query.getOrDefault("oauth_token")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "oauth_token", valid_598202
  var valid_598203 = query.getOrDefault("callback")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "callback", valid_598203
  var valid_598204 = query.getOrDefault("access_token")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "access_token", valid_598204
  var valid_598205 = query.getOrDefault("uploadType")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "uploadType", valid_598205
  var valid_598206 = query.getOrDefault("key")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "key", valid_598206
  var valid_598207 = query.getOrDefault("$.xgafv")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = newJString("1"))
  if valid_598207 != nil:
    section.add "$.xgafv", valid_598207
  var valid_598208 = query.getOrDefault("prettyPrint")
  valid_598208 = validateParameter(valid_598208, JBool, required = false,
                                 default = newJBool(true))
  if valid_598208 != nil:
    section.add "prettyPrint", valid_598208
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

proc call*(call_598210: Call_CloudprivatecatalogproducerCatalogsProductsCreate_598194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Product instance under a given Catalog.
  ## 
  let valid = call_598210.validator(path, query, header, formData, body)
  let scheme = call_598210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598210.url(scheme.get, call_598210.host, call_598210.base,
                         call_598210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598210, url, valid)

proc call*(call_598211: Call_CloudprivatecatalogproducerCatalogsProductsCreate_598194;
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
  var path_598212 = newJObject()
  var query_598213 = newJObject()
  var body_598214 = newJObject()
  add(query_598213, "upload_protocol", newJString(uploadProtocol))
  add(query_598213, "fields", newJString(fields))
  add(query_598213, "quotaUser", newJString(quotaUser))
  add(query_598213, "alt", newJString(alt))
  add(query_598213, "oauth_token", newJString(oauthToken))
  add(query_598213, "callback", newJString(callback))
  add(query_598213, "access_token", newJString(accessToken))
  add(query_598213, "uploadType", newJString(uploadType))
  add(path_598212, "parent", newJString(parent))
  add(query_598213, "key", newJString(key))
  add(query_598213, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598214 = body
  add(query_598213, "prettyPrint", newJBool(prettyPrint))
  result = call_598211.call(path_598212, query_598213, nil, nil, body_598214)

var cloudprivatecatalogproducerCatalogsProductsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsCreate_598194(
    name: "cloudprivatecatalogproducerCatalogsProductsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCreate_598195,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCreate_598196,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsList_598172 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsProductsList_598174(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsProductsList_598173(
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
  var valid_598175 = path.getOrDefault("parent")
  valid_598175 = validateParameter(valid_598175, JString, required = true,
                                 default = nil)
  if valid_598175 != nil:
    section.add "parent", valid_598175
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
  var valid_598176 = query.getOrDefault("upload_protocol")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "upload_protocol", valid_598176
  var valid_598177 = query.getOrDefault("fields")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "fields", valid_598177
  var valid_598178 = query.getOrDefault("pageToken")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "pageToken", valid_598178
  var valid_598179 = query.getOrDefault("quotaUser")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "quotaUser", valid_598179
  var valid_598180 = query.getOrDefault("alt")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = newJString("json"))
  if valid_598180 != nil:
    section.add "alt", valid_598180
  var valid_598181 = query.getOrDefault("oauth_token")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "oauth_token", valid_598181
  var valid_598182 = query.getOrDefault("callback")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "callback", valid_598182
  var valid_598183 = query.getOrDefault("access_token")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "access_token", valid_598183
  var valid_598184 = query.getOrDefault("uploadType")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "uploadType", valid_598184
  var valid_598185 = query.getOrDefault("key")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "key", valid_598185
  var valid_598186 = query.getOrDefault("$.xgafv")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = newJString("1"))
  if valid_598186 != nil:
    section.add "$.xgafv", valid_598186
  var valid_598187 = query.getOrDefault("pageSize")
  valid_598187 = validateParameter(valid_598187, JInt, required = false, default = nil)
  if valid_598187 != nil:
    section.add "pageSize", valid_598187
  var valid_598188 = query.getOrDefault("prettyPrint")
  valid_598188 = validateParameter(valid_598188, JBool, required = false,
                                 default = newJBool(true))
  if valid_598188 != nil:
    section.add "prettyPrint", valid_598188
  var valid_598189 = query.getOrDefault("filter")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "filter", valid_598189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598190: Call_CloudprivatecatalogproducerCatalogsProductsList_598172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  let valid = call_598190.validator(path, query, header, formData, body)
  let scheme = call_598190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598190.url(scheme.get, call_598190.host, call_598190.base,
                         call_598190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598190, url, valid)

proc call*(call_598191: Call_CloudprivatecatalogproducerCatalogsProductsList_598172;
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
  var path_598192 = newJObject()
  var query_598193 = newJObject()
  add(query_598193, "upload_protocol", newJString(uploadProtocol))
  add(query_598193, "fields", newJString(fields))
  add(query_598193, "pageToken", newJString(pageToken))
  add(query_598193, "quotaUser", newJString(quotaUser))
  add(query_598193, "alt", newJString(alt))
  add(query_598193, "oauth_token", newJString(oauthToken))
  add(query_598193, "callback", newJString(callback))
  add(query_598193, "access_token", newJString(accessToken))
  add(query_598193, "uploadType", newJString(uploadType))
  add(path_598192, "parent", newJString(parent))
  add(query_598193, "key", newJString(key))
  add(query_598193, "$.xgafv", newJString(Xgafv))
  add(query_598193, "pageSize", newJInt(pageSize))
  add(query_598193, "prettyPrint", newJBool(prettyPrint))
  add(query_598193, "filter", newJString(filter))
  result = call_598191.call(path_598192, query_598193, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsList* = Call_CloudprivatecatalogproducerCatalogsProductsList_598172(
    name: "cloudprivatecatalogproducerCatalogsProductsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsList_598173,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsList_598174,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598236 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598238(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598237(
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
  var valid_598239 = path.getOrDefault("parent")
  valid_598239 = validateParameter(valid_598239, JString, required = true,
                                 default = nil)
  if valid_598239 != nil:
    section.add "parent", valid_598239
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
  var valid_598240 = query.getOrDefault("upload_protocol")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "upload_protocol", valid_598240
  var valid_598241 = query.getOrDefault("fields")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "fields", valid_598241
  var valid_598242 = query.getOrDefault("quotaUser")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "quotaUser", valid_598242
  var valid_598243 = query.getOrDefault("alt")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = newJString("json"))
  if valid_598243 != nil:
    section.add "alt", valid_598243
  var valid_598244 = query.getOrDefault("oauth_token")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "oauth_token", valid_598244
  var valid_598245 = query.getOrDefault("callback")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "callback", valid_598245
  var valid_598246 = query.getOrDefault("access_token")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "access_token", valid_598246
  var valid_598247 = query.getOrDefault("uploadType")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "uploadType", valid_598247
  var valid_598248 = query.getOrDefault("key")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "key", valid_598248
  var valid_598249 = query.getOrDefault("$.xgafv")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = newJString("1"))
  if valid_598249 != nil:
    section.add "$.xgafv", valid_598249
  var valid_598250 = query.getOrDefault("prettyPrint")
  valid_598250 = validateParameter(valid_598250, JBool, required = false,
                                 default = newJBool(true))
  if valid_598250 != nil:
    section.add "prettyPrint", valid_598250
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

proc call*(call_598252: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Version instance under a given Product.
  ## 
  let valid = call_598252.validator(path, query, header, formData, body)
  let scheme = call_598252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598252.url(scheme.get, call_598252.host, call_598252.base,
                         call_598252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598252, url, valid)

proc call*(call_598253: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598236;
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
  var path_598254 = newJObject()
  var query_598255 = newJObject()
  var body_598256 = newJObject()
  add(query_598255, "upload_protocol", newJString(uploadProtocol))
  add(query_598255, "fields", newJString(fields))
  add(query_598255, "quotaUser", newJString(quotaUser))
  add(query_598255, "alt", newJString(alt))
  add(query_598255, "oauth_token", newJString(oauthToken))
  add(query_598255, "callback", newJString(callback))
  add(query_598255, "access_token", newJString(accessToken))
  add(query_598255, "uploadType", newJString(uploadType))
  add(path_598254, "parent", newJString(parent))
  add(query_598255, "key", newJString(key))
  add(query_598255, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598256 = body
  add(query_598255, "prettyPrint", newJBool(prettyPrint))
  result = call_598253.call(path_598254, query_598255, nil, nil, body_598256)

var cloudprivatecatalogproducerCatalogsProductsVersionsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598236(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598237,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_598238,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_598215 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsList_598217(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_598216(
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
  var valid_598218 = path.getOrDefault("parent")
  valid_598218 = validateParameter(valid_598218, JString, required = true,
                                 default = nil)
  if valid_598218 != nil:
    section.add "parent", valid_598218
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
  var valid_598219 = query.getOrDefault("upload_protocol")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "upload_protocol", valid_598219
  var valid_598220 = query.getOrDefault("fields")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "fields", valid_598220
  var valid_598221 = query.getOrDefault("pageToken")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "pageToken", valid_598221
  var valid_598222 = query.getOrDefault("quotaUser")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "quotaUser", valid_598222
  var valid_598223 = query.getOrDefault("alt")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = newJString("json"))
  if valid_598223 != nil:
    section.add "alt", valid_598223
  var valid_598224 = query.getOrDefault("oauth_token")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "oauth_token", valid_598224
  var valid_598225 = query.getOrDefault("callback")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "callback", valid_598225
  var valid_598226 = query.getOrDefault("access_token")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "access_token", valid_598226
  var valid_598227 = query.getOrDefault("uploadType")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "uploadType", valid_598227
  var valid_598228 = query.getOrDefault("key")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "key", valid_598228
  var valid_598229 = query.getOrDefault("$.xgafv")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = newJString("1"))
  if valid_598229 != nil:
    section.add "$.xgafv", valid_598229
  var valid_598230 = query.getOrDefault("pageSize")
  valid_598230 = validateParameter(valid_598230, JInt, required = false, default = nil)
  if valid_598230 != nil:
    section.add "pageSize", valid_598230
  var valid_598231 = query.getOrDefault("prettyPrint")
  valid_598231 = validateParameter(valid_598231, JBool, required = false,
                                 default = newJBool(true))
  if valid_598231 != nil:
    section.add "prettyPrint", valid_598231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598232: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_598215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  let valid = call_598232.validator(path, query, header, formData, body)
  let scheme = call_598232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598232.url(scheme.get, call_598232.host, call_598232.base,
                         call_598232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598232, url, valid)

proc call*(call_598233: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_598215;
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
  var path_598234 = newJObject()
  var query_598235 = newJObject()
  add(query_598235, "upload_protocol", newJString(uploadProtocol))
  add(query_598235, "fields", newJString(fields))
  add(query_598235, "pageToken", newJString(pageToken))
  add(query_598235, "quotaUser", newJString(quotaUser))
  add(query_598235, "alt", newJString(alt))
  add(query_598235, "oauth_token", newJString(oauthToken))
  add(query_598235, "callback", newJString(callback))
  add(query_598235, "access_token", newJString(accessToken))
  add(query_598235, "uploadType", newJString(uploadType))
  add(path_598234, "parent", newJString(parent))
  add(query_598235, "key", newJString(key))
  add(query_598235, "$.xgafv", newJString(Xgafv))
  add(query_598235, "pageSize", newJInt(pageSize))
  add(query_598235, "prettyPrint", newJBool(prettyPrint))
  result = call_598233.call(path_598234, query_598235, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsList* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_598215(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_598216,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsList_598217,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598257 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598259(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598258(
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
  var valid_598260 = path.getOrDefault("product")
  valid_598260 = validateParameter(valid_598260, JString, required = true,
                                 default = nil)
  if valid_598260 != nil:
    section.add "product", valid_598260
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
  var valid_598261 = query.getOrDefault("upload_protocol")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = nil)
  if valid_598261 != nil:
    section.add "upload_protocol", valid_598261
  var valid_598262 = query.getOrDefault("fields")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "fields", valid_598262
  var valid_598263 = query.getOrDefault("quotaUser")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "quotaUser", valid_598263
  var valid_598264 = query.getOrDefault("alt")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = newJString("json"))
  if valid_598264 != nil:
    section.add "alt", valid_598264
  var valid_598265 = query.getOrDefault("oauth_token")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "oauth_token", valid_598265
  var valid_598266 = query.getOrDefault("callback")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "callback", valid_598266
  var valid_598267 = query.getOrDefault("access_token")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "access_token", valid_598267
  var valid_598268 = query.getOrDefault("uploadType")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "uploadType", valid_598268
  var valid_598269 = query.getOrDefault("key")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "key", valid_598269
  var valid_598270 = query.getOrDefault("$.xgafv")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = newJString("1"))
  if valid_598270 != nil:
    section.add "$.xgafv", valid_598270
  var valid_598271 = query.getOrDefault("prettyPrint")
  valid_598271 = validateParameter(valid_598271, JBool, required = false,
                                 default = newJBool(true))
  if valid_598271 != nil:
    section.add "prettyPrint", valid_598271
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

proc call*(call_598273: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  let valid = call_598273.validator(path, query, header, formData, body)
  let scheme = call_598273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598273.url(scheme.get, call_598273.host, call_598273.base,
                         call_598273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598273, url, valid)

proc call*(call_598274: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598257;
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
  var path_598275 = newJObject()
  var query_598276 = newJObject()
  var body_598277 = newJObject()
  add(query_598276, "upload_protocol", newJString(uploadProtocol))
  add(query_598276, "fields", newJString(fields))
  add(query_598276, "quotaUser", newJString(quotaUser))
  add(query_598276, "alt", newJString(alt))
  add(query_598276, "oauth_token", newJString(oauthToken))
  add(query_598276, "callback", newJString(callback))
  add(query_598276, "access_token", newJString(accessToken))
  add(query_598276, "uploadType", newJString(uploadType))
  add(query_598276, "key", newJString(key))
  add(query_598276, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598277 = body
  add(query_598276, "prettyPrint", newJBool(prettyPrint))
  add(path_598275, "product", newJString(product))
  result = call_598274.call(path_598275, query_598276, nil, nil, body_598277)

var cloudprivatecatalogproducerCatalogsProductsIconsUpload* = Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598257(
    name: "cloudprivatecatalogproducerCatalogsProductsIconsUpload",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{product}/icons:upload",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598258,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_598259,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_598278 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsGetIamPolicy_598280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_598279(
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
  var valid_598281 = path.getOrDefault("resource")
  valid_598281 = validateParameter(valid_598281, JString, required = true,
                                 default = nil)
  if valid_598281 != nil:
    section.add "resource", valid_598281
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
  var valid_598282 = query.getOrDefault("upload_protocol")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "upload_protocol", valid_598282
  var valid_598283 = query.getOrDefault("fields")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "fields", valid_598283
  var valid_598284 = query.getOrDefault("quotaUser")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "quotaUser", valid_598284
  var valid_598285 = query.getOrDefault("alt")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = newJString("json"))
  if valid_598285 != nil:
    section.add "alt", valid_598285
  var valid_598286 = query.getOrDefault("oauth_token")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "oauth_token", valid_598286
  var valid_598287 = query.getOrDefault("callback")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "callback", valid_598287
  var valid_598288 = query.getOrDefault("access_token")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "access_token", valid_598288
  var valid_598289 = query.getOrDefault("uploadType")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "uploadType", valid_598289
  var valid_598290 = query.getOrDefault("options.requestedPolicyVersion")
  valid_598290 = validateParameter(valid_598290, JInt, required = false, default = nil)
  if valid_598290 != nil:
    section.add "options.requestedPolicyVersion", valid_598290
  var valid_598291 = query.getOrDefault("key")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "key", valid_598291
  var valid_598292 = query.getOrDefault("$.xgafv")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = newJString("1"))
  if valid_598292 != nil:
    section.add "$.xgafv", valid_598292
  var valid_598293 = query.getOrDefault("prettyPrint")
  valid_598293 = validateParameter(valid_598293, JBool, required = false,
                                 default = newJBool(true))
  if valid_598293 != nil:
    section.add "prettyPrint", valid_598293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598294: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_598278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets IAM policy for the specified Catalog.
  ## 
  let valid = call_598294.validator(path, query, header, formData, body)
  let scheme = call_598294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598294.url(scheme.get, call_598294.host, call_598294.base,
                         call_598294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598294, url, valid)

proc call*(call_598295: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_598278;
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
  var path_598296 = newJObject()
  var query_598297 = newJObject()
  add(query_598297, "upload_protocol", newJString(uploadProtocol))
  add(query_598297, "fields", newJString(fields))
  add(query_598297, "quotaUser", newJString(quotaUser))
  add(query_598297, "alt", newJString(alt))
  add(query_598297, "oauth_token", newJString(oauthToken))
  add(query_598297, "callback", newJString(callback))
  add(query_598297, "access_token", newJString(accessToken))
  add(query_598297, "uploadType", newJString(uploadType))
  add(query_598297, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_598297, "key", newJString(key))
  add(query_598297, "$.xgafv", newJString(Xgafv))
  add(path_598296, "resource", newJString(resource))
  add(query_598297, "prettyPrint", newJBool(prettyPrint))
  result = call_598295.call(path_598296, query_598297, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsGetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_598278(
    name: "cloudprivatecatalogproducerCatalogsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_598279,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsGetIamPolicy_598280,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_598298 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsSetIamPolicy_598300(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_598299(
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
  var valid_598301 = path.getOrDefault("resource")
  valid_598301 = validateParameter(valid_598301, JString, required = true,
                                 default = nil)
  if valid_598301 != nil:
    section.add "resource", valid_598301
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
  var valid_598302 = query.getOrDefault("upload_protocol")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "upload_protocol", valid_598302
  var valid_598303 = query.getOrDefault("fields")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = nil)
  if valid_598303 != nil:
    section.add "fields", valid_598303
  var valid_598304 = query.getOrDefault("quotaUser")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "quotaUser", valid_598304
  var valid_598305 = query.getOrDefault("alt")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = newJString("json"))
  if valid_598305 != nil:
    section.add "alt", valid_598305
  var valid_598306 = query.getOrDefault("oauth_token")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = nil)
  if valid_598306 != nil:
    section.add "oauth_token", valid_598306
  var valid_598307 = query.getOrDefault("callback")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "callback", valid_598307
  var valid_598308 = query.getOrDefault("access_token")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "access_token", valid_598308
  var valid_598309 = query.getOrDefault("uploadType")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "uploadType", valid_598309
  var valid_598310 = query.getOrDefault("key")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = nil)
  if valid_598310 != nil:
    section.add "key", valid_598310
  var valid_598311 = query.getOrDefault("$.xgafv")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = newJString("1"))
  if valid_598311 != nil:
    section.add "$.xgafv", valid_598311
  var valid_598312 = query.getOrDefault("prettyPrint")
  valid_598312 = validateParameter(valid_598312, JBool, required = false,
                                 default = newJBool(true))
  if valid_598312 != nil:
    section.add "prettyPrint", valid_598312
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

proc call*(call_598314: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_598298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  let valid = call_598314.validator(path, query, header, formData, body)
  let scheme = call_598314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598314.url(scheme.get, call_598314.host, call_598314.base,
                         call_598314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598314, url, valid)

proc call*(call_598315: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_598298;
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
  var path_598316 = newJObject()
  var query_598317 = newJObject()
  var body_598318 = newJObject()
  add(query_598317, "upload_protocol", newJString(uploadProtocol))
  add(query_598317, "fields", newJString(fields))
  add(query_598317, "quotaUser", newJString(quotaUser))
  add(query_598317, "alt", newJString(alt))
  add(query_598317, "oauth_token", newJString(oauthToken))
  add(query_598317, "callback", newJString(callback))
  add(query_598317, "access_token", newJString(accessToken))
  add(query_598317, "uploadType", newJString(uploadType))
  add(query_598317, "key", newJString(key))
  add(query_598317, "$.xgafv", newJString(Xgafv))
  add(path_598316, "resource", newJString(resource))
  if body != nil:
    body_598318 = body
  add(query_598317, "prettyPrint", newJBool(prettyPrint))
  result = call_598315.call(path_598316, query_598317, nil, nil, body_598318)

var cloudprivatecatalogproducerCatalogsSetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_598298(
    name: "cloudprivatecatalogproducerCatalogsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_598299,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsSetIamPolicy_598300,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_598319 = ref object of OpenApiRestCall_597408
proc url_CloudprivatecatalogproducerCatalogsTestIamPermissions_598321(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_598320(
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
  var valid_598322 = path.getOrDefault("resource")
  valid_598322 = validateParameter(valid_598322, JString, required = true,
                                 default = nil)
  if valid_598322 != nil:
    section.add "resource", valid_598322
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
  var valid_598323 = query.getOrDefault("upload_protocol")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "upload_protocol", valid_598323
  var valid_598324 = query.getOrDefault("fields")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "fields", valid_598324
  var valid_598325 = query.getOrDefault("quotaUser")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "quotaUser", valid_598325
  var valid_598326 = query.getOrDefault("alt")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = newJString("json"))
  if valid_598326 != nil:
    section.add "alt", valid_598326
  var valid_598327 = query.getOrDefault("oauth_token")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "oauth_token", valid_598327
  var valid_598328 = query.getOrDefault("callback")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "callback", valid_598328
  var valid_598329 = query.getOrDefault("access_token")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "access_token", valid_598329
  var valid_598330 = query.getOrDefault("uploadType")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "uploadType", valid_598330
  var valid_598331 = query.getOrDefault("key")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "key", valid_598331
  var valid_598332 = query.getOrDefault("$.xgafv")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = newJString("1"))
  if valid_598332 != nil:
    section.add "$.xgafv", valid_598332
  var valid_598333 = query.getOrDefault("prettyPrint")
  valid_598333 = validateParameter(valid_598333, JBool, required = false,
                                 default = newJBool(true))
  if valid_598333 != nil:
    section.add "prettyPrint", valid_598333
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

proc call*(call_598335: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_598319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  let valid = call_598335.validator(path, query, header, formData, body)
  let scheme = call_598335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598335.url(scheme.get, call_598335.host, call_598335.base,
                         call_598335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598335, url, valid)

proc call*(call_598336: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_598319;
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
  var path_598337 = newJObject()
  var query_598338 = newJObject()
  var body_598339 = newJObject()
  add(query_598338, "upload_protocol", newJString(uploadProtocol))
  add(query_598338, "fields", newJString(fields))
  add(query_598338, "quotaUser", newJString(quotaUser))
  add(query_598338, "alt", newJString(alt))
  add(query_598338, "oauth_token", newJString(oauthToken))
  add(query_598338, "callback", newJString(callback))
  add(query_598338, "access_token", newJString(accessToken))
  add(query_598338, "uploadType", newJString(uploadType))
  add(query_598338, "key", newJString(key))
  add(query_598338, "$.xgafv", newJString(Xgafv))
  add(path_598337, "resource", newJString(resource))
  if body != nil:
    body_598339 = body
  add(query_598338, "prettyPrint", newJBool(prettyPrint))
  result = call_598336.call(path_598337, query_598338, nil, nil, body_598339)

var cloudprivatecatalogproducerCatalogsTestIamPermissions* = Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_598319(
    name: "cloudprivatecatalogproducerCatalogsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_598320,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsTestIamPermissions_598321,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
